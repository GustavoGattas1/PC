const app = document.getElementById("app");
const panelTitle = document.getElementById("panel-title");
const panelSubtitle = document.getElementById("panel-subtitle");
const reportDate = document.getElementById("report-date");
const mainPanel = document.getElementById("main-panel");
const minigameOverlay = document.getElementById("minigame-overlay");
const progressOverlay = document.getElementById("progress-overlay");

const views = {
	lab: document.getElementById("view-lab"),
	autopsy: document.getElementById("view-autopsy"),
	locker: document.getElementById("view-locker"),
	bodydrop: document.getElementById("view-bodydrop"),
	report: document.getElementById("view-report"),
	tablet: document.getElementById("view-tablet"),
	bodyDiagram: document.getElementById("view-body-diagram"),
	gsr: document.getElementById("view-gsr")
};

const evidenceIcons = {
	blood: "🩸", blood_pool: "🩸", blood_swab: "🧪", fingerprint: "👆", dna: "🧬",
	casing: "🔫", magazine: "📦", bullet: "💥", bullet_fragment: "💥",
	gsr: "🧤", vehicle_bullet: "🚗", tire_track: "🛞", autopsy: "⚕", corpse_exam: "⚰"
};

const zoneLabels = {
	head: "Cabeça", neck: "Pescoço", chest: "Tórax", abdomen: "Abdômen", pelvis: "Pelve",
	arm_left: "Braço Esquerdo", arm_right: "Braço Direito",
	hand_left: "Mão Esquerda", hand_right: "Mão Direita",
	leg_left: "Perna Esquerda", leg_right: "Perna Direita", unknown: "Não identificado"
};

const zonePositions = {
	head: { cx: 100, cy: 35 }, neck: { cx: 100, cy: 74 }, chest: { cx: 100, cy: 110 },
	abdomen: { cx: 100, cy: 163 }, pelvis: { cx: 100, cy: 205 },
	arm_left: { cx: 44, cy: 123 }, arm_right: { cx: 156, cy: 123 },
	hand_left: { cx: 29, cy: 169 }, hand_right: { cx: 171, cy: 169 },
	leg_left: { cx: 85, cy: 268 }, leg_right: { cx: 115, cy: 268 }
};

let currentReport = null;
let currentBodyExam = null;
let mgAnim = null;
let mgCallback = null;
let progressAnim = null;

function post(endpoint, data = {}) {
	return fetch(`https://iml-evidencias/${endpoint}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data)
	});
}

function hideAllViews() {
	Object.values(views).forEach(v => v && v.classList.add("hidden"));
}

function showApp() {
	app.classList.remove("hidden");
	mainPanel.classList.remove("hidden");
	reportDate.textContent = new Date().toLocaleString("pt-BR");
}

function closeApp() {
	app.classList.add("hidden");
	minigameOverlay.classList.add("hidden");
	progressOverlay.classList.add("hidden");
	mainPanel.classList.remove("panel-tablet");
	hideAllViews();
	stopMinigame();
	stopProgress();
	post("close");
}

function row(label, value, extraClass = "") {
	if (value === undefined || value === null || value === "") return "";
	return `<div class="report-row"><span class="report-label">${label}</span><span class="report-value ${extraClass}">${value}</span></div>`;
}

function findingsList(items) {
	if (!items || !items.length) return "";
	return `<div class="report-section"><h4>Achados / Conclusões</h4><ul class="report-findings">${items.map(f => `<li>${f}</li>`).join("")}</ul></div>`;
}

document.getElementById("btn-close").addEventListener("click", closeApp);
document.addEventListener("keydown", (e) => {
	if (e.key === "Escape") closeApp();
	if (mgAnim && e.code === "Space") {
		e.preventDefault();
		checkMinigame();
	}
});

document.getElementById("btn-print").addEventListener("click", () => {
	post("printReport", { report_id: currentReport?.evidence_id });
});

document.getElementById("btn-body-full-report").addEventListener("click", () => {
	if (currentBodyExam) {
		hideAllViews();
		views.report.classList.remove("hidden");
		renderReport(currentBodyExam, "Perícia Preliminar do Cadáver");
	}
});

function switchTabletTab(tab) {
	document.querySelectorAll(".sidebar-btn").forEach(b => b.classList.toggle("active", b.dataset.tab === tab));
	document.querySelectorAll(".tablet-content .tablet-tab").forEach(t => t.classList.add("hidden"));
	const el = document.getElementById("tablet-" + tab);
	if (el) el.classList.remove("hidden");
}

document.querySelectorAll(".sidebar-btn").forEach(btn => {
	btn.addEventListener("click", () => switchTabletTab(btn.dataset.tab));
});

document.getElementById("btn-refresh-scene").addEventListener("click", () => post("refreshScene"));

document.getElementById("btn-overlay").addEventListener("click", () => post("toggleOverlay"));
document.getElementById("btn-marker").addEventListener("click", () => { post("placeMarker"); closeApp(); });
document.getElementById("btn-tape").addEventListener("click", () => { post("placeTape"); closeApp(); });
document.getElementById("btn-gsr-scan").addEventListener("click", () => { post("scanNearbyGsr"); closeApp(); });
document.getElementById("mg-action").addEventListener("click", checkMinigame);

function renderEvidenceList(container, items, actionLabel, actionCallback) {
	container.innerHTML = "";
	if (!items || items.length === 0) {
		container.innerHTML = '<div class="empty-state">Nenhuma evidência disponível.</div>';
		return;
	}
	items.forEach(item => {
		const card = document.createElement("div");
		card.className = "card";
		const icon = evidenceIcons[item.type] || "📋";
		const label = item.label || item.type || "Evidência";
		const id = item.evidence_id || item.id || "N/A";
		const extra = item.weapon_serial ? ` • Serial: ${item.weapon_serial}` : "";
		const caliber = item.metadata?.caliber ? ` • ${item.metadata.caliber}` : "";
		card.innerHTML = `
			<div class="card-left">
				<span class="card-icon">${icon}</span>
				<div class="card-info">
					<h3>${label}</h3>
					<p>ID: ${id}${extra}${caliber}</p>
				</div>
			</div>
			<button class="btn-action">${actionLabel}</button>`;
		card.querySelector(".btn-action").addEventListener("click", () => actionCallback(item));
		container.appendChild(card);
	});
}

function renderBodyList(container, bodies, actionLabel, actionCallback) {
	container.innerHTML = "";
	if (!bodies || bodies.length === 0) {
		container.innerHTML = '<div class="empty-state">Nenhum corpo aguardando.</div>';
		return;
	}
	bodies.forEach(body => {
		const card = document.createElement("div");
		card.className = "card";
		const name = body.victim_name || "Desconhecido";
		const id = body.body_id || body.id || "N/A";
		const cause = body.cause || body.cause_of_death || "Indeterminada";
		card.innerHTML = `
			<div class="card-left">
				<span class="card-icon">⚰</span>
				<div class="card-info">
					<h3>${name}</h3>
					<p>ID: ${id} • ${cause}</p>
				</div>
			</div>
			<button class="btn-action">${actionLabel}</button>`;
		card.querySelector(".btn-action").addEventListener("click", () => actionCallback(body));
		container.appendChild(card);
	});
}

function renderReport(report, title) {
	currentReport = report;
	const content = document.getElementById("report-content");
	document.getElementById("report-title").textContent = title || "Laudo Pericial";
	content.innerHTML = "";

	if (report.type === "corpse_exam") {
		const tempClass = report.body_temperature === "Quente" ? "match" : "";
		content.innerHTML = `
			${row("Vítima", report.victim?.Name)}
			${row("Passaporte", report.victim?.Passport ? "#" + report.victim.Passport : "N/A")}
			${row("Estado do Corpo", report.body_temperature, tempClass)}
			${row("Descrição Térmica", report.body_temperature_desc)}
			${row("Causa Provável", report.cause_of_death)}
			${row("Região do Impacto", report.bone_hit)}
			${row("Arma Utilizada", report.weapon)}
			${row("Calibre / Munição", report.ammo_label)}
			${row("Serial Balístico", report.weapon_serial)}
			${row("Distância do Disparo", report.distance ? report.distance + "m" : "N/A")}
			${row("Headshot", report.headshot ? "Sim" : "Não", report.headshot ? "no-match" : "")}
			${row("Suspeito", report.killer ? report.killer.Name + " (#" + report.killer.Passport + ")" : "Não identificado", report.killer ? "match" : "no-match")}
			${findingsList(report.findings)}
		`;
	} else if (report.type === "autopsy") {
		content.innerHTML = `
			${row("Vítima", report.victim?.Name)}
			${row("Causa da Morte", report.cause_of_death)}
			${row("Arma do Crime", report.weapon)}
			${row("Calibre", report.ammo_label || report.ammo_type)}
			${row("Serial da Arma", report.weapon_serial)}
			${row("Região do Impacto", report.bone_hit)}
			${row("Código DNA", report.dna_code)}
			${row("Autor do Fato", report.killer ? report.killer.Name + " (#" + report.killer.Passport + ")" : "Não identificado")}
			${row("Perito Legista", report.pathologist?.Name)}
			${findingsList(report.findings)}
		`;
	} else {
		const a = report.analysis || {};
		content.innerHTML = `
			${row("Tipo de Evidência", report.label || report.type)}
			${row("ID", report.evidence_id)}
			${row("Resultado", a.message, a.match ? "match" : "no-match")}
			${row("DNA", a.dna_code)}
			${row("Impressão Digital", a.fingerprint_hash)}
			${row("Arma Identificada", a.weapon)}
			${row("Calibre / Munição", a.ammo_label)}
			${row("Serial Balístico", a.serial)}
			${row("Proprietário da Arma", a.owner ? a.owner.Name + " (#" + a.owner.Passport + ")" : "")}
			${row("Perito Criminal", report.analyst?.Name)}
		`;
	}
}

function renderBodyDiagram(exam) {
	currentBodyExam = exam;
	const zone = exam.bone_zone || "unknown";
	const pos = zonePositions[zone] || { cx: 100, cy: 110 };

	document.querySelectorAll(".body-part").forEach(part => {
		part.classList.remove("hit");
		if (part.dataset.zone === zone) part.classList.add("hit");
	});

	const marker = document.getElementById("impact-marker");
	marker.classList.remove("hidden");
	marker.setAttribute("cx", pos.cx);
	marker.setAttribute("cy", pos.cy);

	const tempColor = exam.body_temperature_color || "#e74c3c";
	document.getElementById("body-info").innerHTML = `
		<div class="temp-badge" style="border-color:${tempColor};color:${tempColor}">
			<span class="temp-label">Estado do Corpo</span>
			<span class="temp-value">${exam.body_temperature || "Desconhecido"}</span>
			<span class="temp-desc">${exam.body_temperature_desc || ""}</span>
		</div>
		${row("Vítima", exam.victim?.Name)}
		${row("Região Atingida", exam.bone_hit || zoneLabels[zone])}
		${row("Arma", exam.weapon)}
		${row("Calibre", exam.ammo_label)}
		${row("Distância", exam.distance ? exam.distance + "m" : "N/A")}
		${row("Causa", exam.cause_of_death)}
		${row("Suspeito", exam.killer ? exam.killer.Name : "Não identificado")}
	`;
}

function renderGsrScanner(result) {
	const el = document.getElementById("gsr-result");
	const positive = result?.positive;
	el.innerHTML = `
		<div class="gsr-display ${positive ? "positive" : "negative"}">
			<div class="gsr-icon">${positive ? "⚠" : "✓"}</div>
			<h3>${positive ? "GSR POSITIVO" : "GSR NEGATIVO"}</h3>
			<p>${result?.message || ""}</p>
			${result?.suspect ? `<p>Suspeito: <strong>${result.suspect.Name}</strong> (#${result.suspect.Passport})</p>` : ""}
			${result?.weapon ? `<p>Arma: <strong>${result.weapon}</strong></p>` : ""}
		</div>
	`;
}

function renderSceneScan(scene) {
	const el = document.getElementById("scene-scan-list");
	el.innerHTML = "";
	if (!scene || !scene.length) {
		el.innerHTML = '<div class="empty-state">Nenhuma evidência detectada na área.<br>Ative o overlay (M) para investigar.</div>';
		return;
	}
	scene.forEach((item, i) => {
		const row = document.createElement("div");
		row.className = "scene-item";
		row.style.borderLeftColor = item.color || "#e74c3c";
		row.innerHTML = `
			<span class="scene-num">#${i + 1}</span>
			<span class="scene-icon">${item.icon || "📋"}</span>
			<div class="scene-info">
				<strong>${item.label}</strong>
				<span>${item.distance}m${item.caliber ? " • " + item.caliber : ""}</span>
			</div>`;
		el.appendChild(row);
	});
}

function renderTablet(data) {
	renderSceneScan(data.scene);
	renderEvidenceList(document.getElementById("tablet-evidence"), data.evidence, "Analisar", (item) => post("analyze", { evidence_id: item.evidence_id }));

	const casesEl = document.getElementById("tablet-cases");
	casesEl.innerHTML = "";
	if (!data.cases || !data.cases.length) {
		casesEl.innerHTML = '<div class="empty-state">Nenhum caso arquivado.</div>';
	} else {
		data.cases.forEach(c => {
			const card = document.createElement("div");
			card.className = "card";
			card.innerHTML = `<div class="card-info"><h3>${c.title || c.case_id}</h3><p>${c.notes || "Sem notas"}</p></div>`;
			casesEl.appendChild(card);
		});
	}
	switchTabletTab("scene");
}

function startMinigame(type) {
	const hints = { swab: "Estabilize o swab no sangue", bag: "Lacre o saco de evidência", mold: "Pressione o molde no rastro", pickup: "Colete com precisão" };
	document.getElementById("minigame-title").textContent = "Coleta Forense";
	document.getElementById("minigame-hint").textContent = hints[type] || "Pressione ESPAÇO no momento certo";
	minigameOverlay.classList.remove("hidden");
	mainPanel.classList.add("hidden");

	const cursor = document.getElementById("mg-cursor");
	let pos = 0;
	let dir = 1;
	stopMinigame();
	mgAnim = setInterval(() => {
		pos += dir * 3;
		if (pos >= 100) { pos = 100; dir = -1; }
		if (pos <= 0) { pos = 0; dir = 1; }
		cursor.style.left = pos + "%";
	}, 16);
	mgCallback = () => {
		const success = pos >= 38 && pos <= 62;
		stopMinigame();
		minigameOverlay.classList.add("hidden");
		mainPanel.classList.remove("hidden");
		post("minigameResult", { success });
	};
}

function checkMinigame() {
	if (mgCallback) mgCallback();
}

function stopMinigame() {
	if (mgAnim) { clearInterval(mgAnim); mgAnim = null; }
	mgCallback = null;
}

function stopProgress() {
	if (progressAnim) { clearInterval(progressAnim); progressAnim = null; }
}

function startProgress(label, duration) {
	const circle = document.getElementById("progress-circle");
	const pct = document.getElementById("progress-pct");
	const labelEl = document.getElementById("progress-label");
	const circumference = 2 * Math.PI * 42;

	circle.style.strokeDasharray = circumference;
	circle.style.strokeDashoffset = circumference;
	labelEl.textContent = label || "Coletando evidência...";
	pct.textContent = "0%";
	progressOverlay.classList.remove("hidden");
	mainPanel.classList.add("hidden");

	const start = Date.now();
	stopProgress();
	progressAnim = setInterval(() => {
		const elapsed = Date.now() - start;
		const progress = Math.min(elapsed / duration, 1);
		circle.style.strokeDashoffset = circumference * (1 - progress);
		pct.textContent = Math.floor(progress * 100) + "%";
		if (progress >= 1) {
			stopProgress();
			progressOverlay.classList.add("hidden");
			mainPanel.classList.remove("hidden");
			post("progressComplete");
		}
	}, 30);
}

window.addEventListener("message", (event) => {
	const data = event.data;
	if (!data || !data.action) return;

	if (data.action === "startMinigame") {
		startMinigame(data.type);
		return;
	}

	if (data.action === "startProgress") {
		startProgress(data.label, data.duration || 3000);
		return;
	}

	if (data.action === "updateScene") {
		renderSceneScan(data.scene);
		return;
	}

	if (data.action === "startGsrScan") {
		hideAllViews();
		showApp();
		panelTitle.textContent = "Scanner GSR";
		panelSubtitle.textContent = "Analisando suspeito...";
		views.gsr.classList.remove("hidden");
		document.getElementById("gsr-result").innerHTML = '<div class="gsr-scanning"><div class="radar"></div><p>Escaneando resíduo de pólvora...</p></div>';
		return;
	}

	hideAllViews();
	showApp();

	switch (data.action) {
		case "openLab":
			panelTitle.textContent = "Laboratório Forense";
			panelSubtitle.textContent = "Análise de DNA, balística e digitais";
			views.lab.classList.remove("hidden");
			renderEvidenceList(document.getElementById("evidence-list"), data.evidence, "Analisar", (item) => post("analyze", { evidence_id: item.evidence_id }));
			break;
		case "openAutopsy":
			panelTitle.textContent = "Sala de Autópsia";
			views.autopsy.classList.remove("hidden");
			renderBodyList(document.getElementById("body-list"), data.bodies, "Autopsiar", (body) => post("autopsy", { body_id: body.body_id }));
			break;
		case "openLocker":
			panelTitle.textContent = "Armário de Evidências";
			views.locker.classList.remove("hidden");
			renderEvidenceList(document.getElementById("locker-list"), data.evidence, "Ver", () => {});
			break;
		case "openBodyDrop":
			panelTitle.textContent = "Entrega de Corpos";
			views.bodydrop.classList.remove("hidden");
			renderBodyList(document.getElementById("bodydrop-list"), data.bodies, "Entregar", (body) => post("deliverBody", { body_id: body.body_id }));
			break;
		case "openReport":
			panelTitle.textContent = data.title || "Laudo Pericial";
			views.report.classList.remove("hidden");
			renderReport(data.report, data.title);
			break;
		case "openTablet":
			panelTitle.textContent = "Tablet Forense";
			panelSubtitle.textContent = "Sistema de Investigação Criminal";
			mainPanel.classList.add("panel-tablet");
			views.tablet.classList.remove("hidden");
			renderTablet(data);
			break;
		case "openBodyDiagram":
			panelTitle.textContent = "Perícia de Local de Tiro";
			panelSubtitle.textContent = "Análise do impacto balístico";
			views.bodyDiagram.classList.remove("hidden");
			renderBodyDiagram(data.exam);
			break;
		case "openGsrScanner":
			panelTitle.textContent = "Scanner GSR";
			panelSubtitle.textContent = "Detecção de pólvora";
			views.gsr.classList.remove("hidden");
			renderGsrScanner(data.result);
			break;
	}
});
