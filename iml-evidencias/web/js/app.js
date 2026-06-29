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
	fingerprint: "👆",
	casing: "🔫",
	magazine: "📦",
	bullet: "💥",
	autopsy: "⚕"
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

document.getElementById("btn-close").addEventListener("click", closeApp);

document.addEventListener("keydown", (e) => {
	if (e.key === "Escape") closeApp();
});

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

		card.innerHTML = `
			<div class="card-left">
				<span class="card-icon">${icon}</span>
				<div class="card-info">
					<h3>${label}</h3>
					<p>ID: ${id} ${item.collected_at ? "• Coletado: " + item.collected_at : ""}</p>
				</div>
			</div>
			<button class="btn-action">${actionLabel}</button>
		`;

		card.querySelector(".btn-action").addEventListener("click", () => {
			actionCallback(item);
		});

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
		const cause = body.cause || "Indeterminada";

		card.innerHTML = `
			<div class="card-left">
				<span class="card-icon">⚰</span>
				<div class="card-info">
					<h3>${name}</h3>
					<p>ID: ${id} • Causa: ${cause}</p>
				</div>
			</div>
			<button class="btn-action">${actionLabel}</button>
		`;

		card.querySelector(".btn-action").addEventListener("click", () => {
			actionCallback(body);
		});

		container.appendChild(card);
	});
}

function renderReport(report, title) {
	const content = document.getElementById("report-content");
	document.getElementById("report-title").textContent = title || "Laudo Pericial";
	content.innerHTML = "";

	if (report.type === "autopsy") {
		content.innerHTML = `
			<div class="report-row"><span class="report-label">Vítima</span><span class="report-value">${report.victim?.Name || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Passaporte</span><span class="report-value">#${report.victim?.Passport || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Causa da Morte</span><span class="report-value">${report.cause_of_death || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Código DNA</span><span class="report-value">${report.dna_code || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Perito</span><span class="report-value">${report.pathologist?.Name || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Data</span><span class="report-value">${report.timestamp || ""}</span></div>
			<div class="report-section">
				<h4>Achados</h4>
				<ul class="report-findings">
					${(report.findings || []).map(f => `<li>${f}</li>`).join("")}
				</ul>
			</div>
		`;
	} else {
		const analysis = report.analysis || {};
		const matchClass = analysis.match ? "match" : "no-match";

		content.innerHTML = `
			<div class="report-row"><span class="report-label">Tipo</span><span class="report-value">${report.label || report.type || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">ID Evidência</span><span class="report-value">${report.evidence_id || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Resultado</span><span class="report-value ${matchClass}">${analysis.message || "N/A"}</span></div>
			${analysis.dna_code ? `<div class="report-row"><span class="report-label">Código DNA</span><span class="report-value">${analysis.dna_code}</span></div>` : ""}
			${analysis.fingerprint_hash ? `<div class="report-row"><span class="report-label">Digital</span><span class="report-value">${analysis.fingerprint_hash}</span></div>` : ""}
			${analysis.weapon ? `<div class="report-row"><span class="report-label">Arma</span><span class="report-value">${analysis.weapon}</span></div>` : ""}
			${analysis.serial ? `<div class="report-row"><span class="report-label">Serial</span><span class="report-value">${analysis.serial}</span></div>` : ""}
			<div class="report-row"><span class="report-label">Perito</span><span class="report-value">${report.analyst?.Name || "N/A"}</span></div>
			<div class="report-row"><span class="report-label">Data</span><span class="report-value">${report.timestamp || ""}</span></div>
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
			panelSubtitle.textContent = "Análise de evidências coletadas";
			views.lab.classList.remove("hidden");
			renderEvidenceList(
				document.getElementById("evidence-list"),
				data.evidence,
				"Analisar",
				(item) => post("analyze", { evidence_id: item.evidence_id })
			);
			break;

		case "openAutopsy":
			panelTitle.textContent = "Sala de Autópsia";
			panelSubtitle.textContent = "Exame médico-legal";
			views.autopsy.classList.remove("hidden");
			renderBodyList(
				document.getElementById("body-list"),
				data.bodies,
				"Autopsiar",
				(body) => post("autopsy", { body_id: body.body_id })
			);
			break;

		case "openLocker":
			panelTitle.textContent = "Armário de Evidências";
			panelSubtitle.textContent = "Evidências armazenadas";
			views.locker.classList.remove("hidden");
			renderEvidenceList(
				document.getElementById("locker-list"),
				data.evidence,
				"Ver",
				() => {}
			);
			break;

		case "openBodyDrop":
			panelTitle.textContent = "Entrega de Corpos";
			panelSubtitle.textContent = "Recepção do IML";
			views.bodydrop.classList.remove("hidden");
			renderBodyList(
				document.getElementById("bodydrop-list"),
				data.bodies,
				"Entregar",
				(body) => post("deliverBody", { body_id: body.body_id })
			);
			break;

		case "openReport":
			panelTitle.textContent = "Laudo Pericial";
			panelSubtitle.textContent = "Documento oficial";
			views.report.classList.remove("hidden");
			renderReport(data.report, data.title);
			break;
	}
});
