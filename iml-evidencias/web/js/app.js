const app = document.getElementById("app");
const panelTitle = document.getElementById("panel-title");
const panelSubtitle = document.getElementById("panel-subtitle");
const reportDate = document.getElementById("report-date");

const views = {
	lab: document.getElementById("view-lab"),
	autopsy: document.getElementById("view-autopsy"),
	locker: document.getElementById("view-locker"),
	bodydrop: document.getElementById("view-bodydrop"),
	report: document.getElementById("view-report")
};

const evidenceIcons = {
	blood: "🩸",
	blood_pool: "🩸",
	blood_swab: "🧪",
	fingerprint: "👆",
	casing: "🔫",
	magazine: "📦",
	bullet: "💥",
	bullet_fragment: "💥",
	gsr: "🧤",
	vehicle_bullet: "🚗",
	autopsy: "⚕",
	corpse_exam: "⚰"
};

function post(endpoint, data = {}) {
	return fetch(`https://iml-evidencias/${endpoint}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data)
	});
}

function hideAllViews() {
	Object.values(views).forEach(v => v.classList.add("hidden"));
}

function showApp() {
	app.classList.remove("hidden");
	reportDate.textContent = new Date().toLocaleString("pt-BR");
}

function closeApp() {
	app.classList.add("hidden");
	hideAllViews();
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
document.addEventListener("keydown", (e) => { if (e.key === "Escape") closeApp(); });

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
		card.innerHTML = `
			<div class="card-left">
				<span class="card-icon">${icon}</span>
				<div class="card-info">
					<h3>${label}</h3>
					<p>ID: ${id}${extra}</p>
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
		const weapon = body.weapon_hash ? ` • Arma registrada` : "";
		card.innerHTML = `
			<div class="card-left">
				<span class="card-icon">⚰</span>
				<div class="card-info">
					<h3>${name}</h3>
					<p>ID: ${id} • ${cause}${weapon}</p>
				</div>
			</div>
			<button class="btn-action">${actionLabel}</button>`;
		card.querySelector(".btn-action").addEventListener("click", () => actionCallback(body));
		container.appendChild(card);
	});
}

function renderReport(report, title) {
	const content = document.getElementById("report-content");
	document.getElementById("report-title").textContent = title || "Laudo Pericial";
	content.innerHTML = "";

	if (report.type === "corpse_exam") {
		content.innerHTML = `
			${row("Vítima", report.victim?.Name)}
			${row("Passaporte", report.victim?.Passport ? "#" + report.victim.Passport : "N/A")}
			${row("Hora do Óbito", report.time_of_death)}
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
			${row("Passaporte", report.victim?.Passport ? "#" + report.victim.Passport : "N/A")}
			${row("Causa da Morte", report.cause_of_death)}
			${row("Arma do Crime", report.weapon)}
			${row("Calibre", report.ammo_label || report.ammo_type)}
			${row("Serial da Arma", report.weapon_serial)}
			${row("Região do Impacto", report.bone_hit)}
			${row("Distância", report.distance ? report.distance + "m" : "N/A")}
			${row("Headshot", report.headshot ? "Confirmado" : "Não")}
			${row("Código DNA", report.dna_code)}
			${row("Autor do Fato", report.killer ? report.killer.Name + " (#" + report.killer.Passport + ")" : "Não identificado", report.killer ? "match" : "")}
			${row("Perito Legista", report.pathologist?.Name)}
			${row("Data", report.timestamp)}
			${findingsList(report.findings)}
		`;
	} else {
		const a = report.analysis || {};
		const matchClass = a.match ? "match" : "no-match";
		content.innerHTML = `
			${row("Tipo de Evidência", report.label || report.type)}
			${row("ID", report.evidence_id)}
			${row("Resultado", a.message, matchClass)}
			${row("DNA", a.dna_code)}
			${row("Impressão Digital", a.fingerprint_hash)}
			${row("Arma Identificada", a.weapon)}
			${row("Calibre / Munição", a.ammo_label)}
			${row("Categoria", a.ammo_category)}
			${row("Serial Balístico", a.serial)}
			${row("Proprietário da Arma", a.owner ? a.owner.Name + " (#" + a.owner.Passport + ")" : a.owner_message ? "Não registrado" : "", a.owner ? "match" : "")}
			${row("Suspeito (GSR)", a.identity ? a.identity.Name + " (#" + a.identity.Passport + ")" : "")}
			${row("Perito Criminal", report.analyst?.Name)}
			${row("Data", report.timestamp)}
		`;
	}
}

window.addEventListener("message", (event) => {
	const data = event.data;
	if (!data || !data.action) return;
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
			panelSubtitle.textContent = "Exame médico-legal completo";
			views.autopsy.classList.remove("hidden");
			renderBodyList(document.getElementById("body-list"), data.bodies, "Autopsiar", (body) => post("autopsy", { body_id: body.body_id }));
			break;
		case "openLocker":
			panelTitle.textContent = "Armário de Evidências";
			panelSubtitle.textContent = "Evidências armazenadas";
			views.locker.classList.remove("hidden");
			renderEvidenceList(document.getElementById("locker-list"), data.evidence, "Ver", () => {});
			break;
		case "openBodyDrop":
			panelTitle.textContent = "Entrega de Corpos";
			panelSubtitle.textContent = "Recepção do IML";
			views.bodydrop.classList.remove("hidden");
			renderBodyList(document.getElementById("bodydrop-list"), data.bodies, "Entregar", (body) => post("deliverBody", { body_id: body.body_id }));
			break;
		case "openReport":
			panelTitle.textContent = data.title || "Laudo Pericial";
			panelSubtitle.textContent = "Documento oficial";
			views.report.classList.remove("hidden");
			renderReport(data.report, data.title);
			break;
	}
});
