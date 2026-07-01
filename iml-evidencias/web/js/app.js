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
let progressAnim = null;
let nuiPanelOpen = false;
let collectionUiActive = false;

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
	nuiPanelOpen = true;
	reportDate.textContent = new Date().toLocaleString("pt-BR");
}

function hideCollectionUi() {
	collectionUiActive = false;
	minigameOverlay.classList.add("hidden");
	progressOverlay.classList.add("hidden");
	if (!nuiPanelOpen) {
		app.classList.add("hidden");
	}
	mainPanel.classList.remove("hidden");
	mainPanel.classList.remove("panel-tablet");
}

function resetUiState() {
	nuiPanelOpen = false;
	collectionUiActive = false;
	app.classList.add("hidden");
	minigameOverlay.classList.add("hidden");
	progressOverlay.classList.add("hidden");
	mainPanel.classList.remove("hidden");
	mainPanel.classList.remove("panel-tablet");
	hideAllViews();
	stopMinigame();
	stopProgress();
}

function closeApp() {
	resetUiState();
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

let mgCleanup = null;
let mgFinished = false;
let mgTimerInterval = null;
const MG_TIME_LIMIT = 22000;

document.getElementById("btn-close").addEventListener("click", closeApp);
document.addEventListener("keydown", (e) => {
	if (e.key === "Escape") {
		if (collectionUiActive) {
			post("progressCancel");
			post("minigameCancel");
			hideCollectionUi();
			return;
		}
		closeApp();
	}
});

document.getElementById("btn-print").addEventListener("click", () => {
	const reportId = currentReport?.report_id || currentReport?.evidence_id;
	closeApp();
	post("printReport", { report_id: reportId });
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
document.getElementById("btn-gsr-scan").addEventListener("click", () => { post("scanNearbyGsr"); closeApp(); });

const minigameThemes = {
	swab: { icon: "🩸", badge: "SANGUE", className: "theme-swab" },
	bag: { icon: "🔫", badge: "BALÍSTICA", className: "theme-bag" },
	dna: { icon: "🧬", badge: "DNA", className: "theme-dna" },
	mold: { icon: "🛞", badge: "PNEU", className: "theme-mold" },
	pickup: { icon: "🔬", badge: "COLETA", className: "theme-pickup" }
};

function setMinigameTheme(type, title, hint) {
	const theme = minigameThemes[type] || minigameThemes.pickup;
	const panel = document.getElementById("minigame-panel");
	const icon = document.getElementById("minigame-icon");
	const badge = document.getElementById("minigame-badge");

	panel.className = "minigame-panel minigame-panel-wide " + theme.className;
	icon.textContent = theme.icon;
	badge.textContent = theme.badge;
	document.getElementById("minigame-title").textContent = title;
	document.getElementById("minigame-hint").textContent = hint;
}

function getStageRect(stage) {
	return stage.getBoundingClientRect();
}

function clamp(value, min, max) {
	return Math.max(min, Math.min(max, value));
}

function rectsOverlap(a, b, padding = 0) {
	return !(
		a.right + padding < b.left - padding ||
		a.left - padding > b.right + padding ||
		a.bottom + padding < b.top - padding ||
		a.top - padding > b.bottom + padding
	);
}

function setupDraggable(el, container, onMove, onEnd) {
	let dragging = false;
	let offsetX = 0;
	let offsetY = 0;

	const onMouseDown = (e) => {
		if (mgFinished) return;
		dragging = true;
		const rect = el.getBoundingClientRect();
		offsetX = e.clientX - rect.left;
		offsetY = e.clientY - rect.top;
		el.classList.add("dragging");
		e.preventDefault();
	};

	const onMouseMove = (e) => {
		if (!dragging || mgFinished) return;
		const containerRect = getStageRect(container);
		const elW = el.offsetWidth;
		const elH = el.offsetHeight;
		let x = e.clientX - containerRect.left - offsetX;
		let y = e.clientY - containerRect.top - offsetY;
		x = clamp(x, 0, container.offsetWidth - elW);
		y = clamp(y, 0, container.offsetHeight - elH);
		el.style.left = x + "px";
		el.style.top = y + "px";
		if (onMove) onMove(el, x, y);
	};

	const onMouseUp = () => {
		if (!dragging) return;
		dragging = false;
		el.classList.remove("dragging");
		if (onEnd) onEnd(el);
	};

	el.addEventListener("mousedown", onMouseDown);
	document.addEventListener("mousemove", onMouseMove);
	document.addEventListener("mouseup", onMouseUp);

	return () => {
		el.removeEventListener("mousedown", onMouseDown);
		document.removeEventListener("mousemove", onMouseMove);
		document.removeEventListener("mouseup", onMouseUp);
	};
}

function startMinigameTimer(onTimeout) {
	const fill = document.getElementById("minigame-timer-fill");
	const start = Date.now();
	stopMinigameTimer();
	fill.style.width = "100%";
	mgTimerInterval = setInterval(() => {
		const elapsed = Date.now() - start;
		const remaining = Math.max(0, 1 - elapsed / MG_TIME_LIMIT);
		fill.style.width = (remaining * 100) + "%";
		if (remaining <= 0) {
			stopMinigameTimer();
			if (onTimeout) onTimeout();
		}
	}, 50);
}

function stopMinigameTimer() {
	if (mgTimerInterval) {
		clearInterval(mgTimerInterval);
		mgTimerInterval = null;
	}
}

function updateMinigameStatus(text) {
	const el = document.getElementById("minigame-status-text");
	if (el) el.textContent = text;
}

function completeMinigame(success) {
	if (mgFinished) return;
	mgFinished = true;
	stopMinigameTimer();
	if (mgCleanup) {
		const cleanup = mgCleanup;
		mgCleanup = null;
		cleanup();
	}
	minigameOverlay.classList.add("hidden");
	setTimeout(() => {
		stopMinigame();
		post("minigameResult", { success });
	}, success ? 300 : 0);
}

function startSwabMinigame(stage) {
	setMinigameTheme("swab", "Coleta de Sangue", "Arraste o cotonete e limpe todas as manchas de sangue na superfície");
	updateMinigameStatus("Manchas: 0/0");

	const floor = document.createElement("div");
	floor.className = "mg-scene-floor";
	stage.appendChild(floor);

	const stainCount = 5 + Math.floor(Math.random() * 2);
	const stains = [];
	const stageW = stage.offsetWidth || 480;
	const stageH = stage.offsetHeight || 256;

	for (let i = 0; i < stainCount; i++) {
		const stain = document.createElement("div");
		stain.className = "mg-blood-stain";
		const size = 36 + Math.random() * 32;
		stain.style.width = size + "px";
		stain.style.height = (size * (0.7 + Math.random() * 0.4)) + "px";
		stain.style.left = (40 + Math.random() * (stageW - size - 80)) + "px";
		stain.style.top = (30 + Math.random() * (stageH - size - 70)) + "px";
		stain.dataset.health = "100";
		stage.appendChild(stain);
		stains.push(stain);
	}

	let cleaned = 0;
	updateMinigameStatus(`Manchas: ${cleaned}/${stainCount}`);

	const swab = document.createElement("div");
	swab.className = "mg-swab";
	swab.innerHTML = '<div class="mg-swab-tip"></div><div class="mg-swab-stick"></div>';
	swab.style.left = (stageW / 2 - 22) + "px";
	swab.style.top = (stageH - 90) + "px";
	stage.appendChild(swab);

	const cleanStains = (el) => {
		const tipRect = el.querySelector(".mg-swab-tip").getBoundingClientRect();
		stains.forEach((stain) => {
			if (stain.classList.contains("cleaned")) return;
			const stainRect = stain.getBoundingClientRect();
			if (rectsOverlap(tipRect, stainRect, 8)) {
				let health = parseFloat(stain.dataset.health) - 4;
				stain.dataset.health = health;
				stain.style.opacity = Math.max(0, health / 100);
				if (health <= 0) {
					stain.classList.add("cleaned");
					cleaned++;
					updateMinigameStatus(`Manchas: ${cleaned}/${stainCount}`);
					if (cleaned >= stainCount) {
						updateMinigameStatus("Amostra coletada!");
						completeMinigame(true);
					}
				}
			}
		});
	};

	const cleanupDrag = setupDraggable(swab, stage, cleanStains);
	mgCleanup = () => {
		cleanupDrag();
		stopMinigameTimer();
	};

	startMinigameTimer(() => completeMinigame(false));
}

function startBagMinigame(stage) {
	setMinigameTheme("bag", "Cápsula de Projétil", "Arraste a cápsula e coloque dentro do saco de evidência");
	updateMinigameStatus("Coloque no saco");

	const scene = document.createElement("div");
	scene.className = "mg-bag-scene";
	scene.innerHTML = '<div class="mg-surface"></div>';
	stage.appendChild(scene);

	const stageW = stage.offsetWidth || 480;
	const stageH = stage.offsetHeight || 256;

	const bag = document.createElement("div");
	bag.className = "mg-evidence-bag";
	bag.innerHTML = '<span class="mg-bag-label">Saco de Evidência</span><span class="mg-bag-icon">📦</span>';
	scene.appendChild(bag);

	const casing = document.createElement("div");
	casing.className = "mg-casing";
	casing.innerHTML = '<div class="mg-casing-rim"></div><div class="mg-casing-body"></div>';
	casing.style.left = (40 + Math.random() * 80) + "px";
	casing.style.top = (stageH * 0.45 + Math.random() * 40) + "px";
	scene.appendChild(casing);

	const homeX = casing.style.left;
	const homeY = casing.style.top;

	const checkBagHover = (el) => {
		const elRect = el.getBoundingClientRect();
		const bagRect = bag.getBoundingClientRect();
		if (rectsOverlap(elRect, bagRect, 4)) {
			bag.classList.add("hover");
		} else {
			bag.classList.remove("hover");
		}
	};

	const cleanupDrag = setupDraggable(casing, scene, checkBagHover, (el) => {
		const elRect = el.getBoundingClientRect();
		const bagRect = bag.getBoundingClientRect();
		bag.classList.remove("hover");
		if (rectsOverlap(elRect, bagRect, 6)) {
			updateMinigameStatus("Cápsula lacrada!");
			el.style.transition = "all 0.35s ease";
			const bagCenterX = bag.offsetLeft + bag.offsetWidth / 2 - el.offsetWidth / 2;
			const bagCenterY = bag.offsetTop + bag.offsetHeight / 2 - el.offsetHeight / 2;
			el.style.left = bagCenterX + "px";
			el.style.top = bagCenterY + "px";
			el.style.opacity = "0.5";
			el.style.transform = "scale(0.7)";
			completeMinigame(true);
		} else {
			el.style.transition = "left 0.25s ease, top 0.25s ease";
			el.style.left = homeX;
			el.style.top = homeY;
			setTimeout(() => { el.style.transition = ""; }, 250);
		}
	});

	mgCleanup = () => {
		cleanupDrag();
		stopMinigameTimer();
	};

	startMinigameTimer(() => completeMinigame(false));
}

function startMoldMinigame(stage) {
	setMinigameTheme("mold", "Molde de Pneu", "Arraste o molde até o rastro de pneu");
	updateMinigameStatus("Posicione o molde");

	const stageW = stage.offsetWidth || 480;
	const stageH = stage.offsetHeight || 256;

	const track = document.createElement("div");
	track.className = "mg-target-zone";
	track.textContent = "Rastro de pneu";
	track.style.left = "55%";
	track.style.top = "35%";
	track.style.width = "35%";
	track.style.height = "40%";
	stage.appendChild(track);

	const mold = document.createElement("div");
	mold.className = "mg-drag-item";
	mold.textContent = "🛞";
	mold.style.left = "12%";
	mold.style.top = "55%";
	stage.appendChild(mold);

	setupGenericDropMinigame(stage, mold, track, "Molde aplicado!");
}

function startPickupMinigame(stage) {
	setMinigameTheme("pickup", "Coleta de Evidência", "Arraste a pinça até a evidência e recolha");
	updateMinigameStatus("Recolha a evidência");

	const evidence = document.createElement("div");
	evidence.className = "mg-target-zone";
	evidence.textContent = "Evidência";
	evidence.style.left = "58%";
	evidence.style.top = "38%";
	evidence.style.width = "28%";
	evidence.style.height = "32%";
	stage.appendChild(evidence);

	const tweezers = document.createElement("div");
	tweezers.className = "mg-drag-item";
	tweezers.textContent = "🔬";
	tweezers.style.left = "10%";
	tweezers.style.top = "50%";
	stage.appendChild(tweezers);

	setupGenericDropMinigame(stage, tweezers, evidence, "Evidência recolhida!");
}

function setupGenericDropMinigame(stage, item, target, successText) {
	const homeX = item.style.left;
	const homeY = item.style.top;

	const checkHover = (el) => {
		const elRect = el.getBoundingClientRect();
		const targetRect = target.getBoundingClientRect();
		if (rectsOverlap(elRect, targetRect, 4)) {
			target.classList.add("hover");
		} else {
			target.classList.remove("hover");
		}
	};

	const cleanupDrag = setupDraggable(item, stage, checkHover, (el) => {
		const elRect = el.getBoundingClientRect();
		const targetRect = target.getBoundingClientRect();
		target.classList.remove("hover");
		if (rectsOverlap(elRect, targetRect, 6)) {
			updateMinigameStatus(successText);
			completeMinigame(true);
		} else {
			el.style.transition = "left 0.25s ease, top 0.25s ease";
			el.style.left = homeX;
			el.style.top = homeY;
			setTimeout(() => { el.style.transition = ""; }, 250);
		}
	});

	mgCleanup = () => {
		cleanupDrag();
		stopMinigameTimer();
	};

	startMinigameTimer(() => completeMinigame(false));
}

function startDnaMinigame(stage) {
	setMinigameTheme("dna", "Coleta de DNA", "Arraste o swab molecular e colete todas as amostras na hélice");
	updateMinigameStatus("Amostras: 0/0");

	const stageW = stage.offsetWidth || 480;
	const stageH = stage.offsetHeight || 256;

	const scene = document.createElement("div");
	scene.className = "mg-dna-scene";
	stage.appendChild(scene);

	const helix = document.createElement("div");
	helix.className = "mg-dna-helix";
	helix.innerHTML = `
		<div class="mg-dna-strand mg-dna-strand-left"></div>
		<div class="mg-dna-strand mg-dna-strand-right"></div>
		<div class="mg-dna-grid"></div>
	`;
	scene.appendChild(helix);

	const nodeCount = 5;
	const nodes = [];
	const nodePositions = [
		{ left: 42, top: 18 },
		{ left: 58, top: 32 },
		{ left: 40, top: 48 },
		{ left: 60, top: 62 },
		{ left: 45, top: 76 }
	];

	for (let i = 0; i < nodeCount; i++) {
		const pos = nodePositions[i] || { left: 50, top: 20 + i * 14 };
		const node = document.createElement("div");
		node.className = "mg-dna-node";
		node.style.left = pos.left + "%";
		node.style.top = pos.top + "%";
		helix.appendChild(node);
		nodes.push(node);
	}

	let collected = 0;
	updateMinigameStatus(`Amostras: ${collected}/${nodeCount}`);

	const swab = document.createElement("div");
	swab.className = "mg-dna-swab";
	swab.innerHTML = '<div class="mg-dna-swab-tip"></div><div class="mg-dna-swab-stick"></div>';
	swab.style.left = (stageW / 2 - 20) + "px";
	swab.style.top = (stageH - 88) + "px";
	scene.appendChild(swab);

	const collectNodes = (el) => {
		const tipRect = el.querySelector(".mg-dna-swab-tip").getBoundingClientRect();
		nodes.forEach((node) => {
			if (node.classList.contains("collected")) return;
			const nodeRect = node.getBoundingClientRect();
			if (rectsOverlap(tipRect, nodeRect, 10)) {
				node.classList.add("collected");
				collected++;
				updateMinigameStatus(`Amostras: ${collected}/${nodeCount}`);
				if (collected >= nodeCount) {
					updateMinigameStatus("Perfil genético capturado!");
					stage.classList.add("mg-success-flash");
					completeMinigame(true);
				}
			}
		});
	};

	const cleanupDrag = setupDraggable(swab, scene, collectNodes);
	mgCleanup = () => {
		cleanupDrag();
		stopMinigameTimer();
	};

	startMinigameTimer(() => completeMinigame(false));
}

function startMinigame(type) {
	collectionUiActive = true;
	mgFinished = false;
	app.classList.remove("hidden");
	minigameOverlay.classList.remove("hidden");
	mainPanel.classList.add("hidden");

	stopMinigame();

	const stage = document.getElementById("minigame-stage");
	stage.innerHTML = "";
	stage.classList.remove("mg-success-flash");

	requestAnimationFrame(() => {
		switch (type) {
			case "swab":
				startSwabMinigame(stage);
				break;
			case "bag":
				startBagMinigame(stage);
				break;
			case "dna":
				startDnaMinigame(stage);
				break;
			case "mold":
				startMoldMinigame(stage);
				break;
			default:
				startPickupMinigame(stage);
				break;
		}
	});
}

function stopMinigame() {
	if (mgCleanup) {
		mgCleanup();
		mgCleanup = null;
	}
	stopMinigameTimer();
	mgFinished = false;
	const stage = document.getElementById("minigame-stage");
	if (stage) {
		stage.innerHTML = "";
		stage.classList.remove("mg-success-flash");
	}
}

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
	collectionUiActive = true;
	app.classList.remove("hidden");
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

	if (data.action === "finishCollectionUi") {
		hideCollectionUi();
		return;
	}

	if (data.action === "forceClose") {
		resetUiState();
		return;
	}

	if (data.action === "cancelCollection") {
		hideCollectionUi();
		stopMinigame();
		stopProgress();
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
