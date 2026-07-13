const RESOURCE = typeof GetParentResourceName === "function" ? GetParentResourceName() : "camera-corporal";

let state = {
	sessions: [],
	selectedSession: null,
	supervisor: false,
	currentTab: "timeline",
	detail: null
};

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => document.querySelectorAll(sel);

function post(endpoint, data = {}) {
	return fetch(`https://${RESOURCE}/${endpoint}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data)
	}).then((r) => r.json()).catch(() => ({}));
}

function formatDuration(seconds) {
	seconds = Math.max(0, Math.floor(seconds || 0));
	const h = Math.floor(seconds / 3600);
	const m = Math.floor((seconds % 3600) / 60);
	const s = seconds % 60;
	if (h > 0) return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
	return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
}

function eventIcon(type) {
	const icons = {
		weapon_drawn: "🔫",
		weapon_fired: "💥",
		pursuit: "🚔",
		siren: "🚨",
		damage: "🩹",
		bookmark: "📌",
		session_start: "▶️",
		snapshot: "📍"
	};
	return icons[type] || "●";
}

function renderSessionList() {
	const list = $("#session-list");
	list.innerHTML = "";

	if (!state.sessions.length) {
		list.innerHTML = `<div style="padding:20px;text-align:center;color:rgba(255,255,255,0.4);font-size:0.8rem">Nenhuma gravação encontrada</div>`;
		return;
	}

	state.sessions.forEach((session) => {
		const el = document.createElement("div");
		el.className = "session-item" + (state.selectedSession === session.sessionId ? " active" : "");
		el.innerHTML = `
			<div class="si-id">${session.sessionId}</div>
			<div class="si-officer">${session.officerName}</div>
			<div class="si-meta">${session.unit || "—"} · ${session.durationLabel || formatDuration(session.duration)}</div>
			<div class="si-tags">
				${session.eventCount ? `<span class="tag events">${session.eventCount} eventos</span>` : ""}
				${session.bookmarkCount ? `<span class="tag bookmarks">${session.bookmarkCount} marcações</span>` : ""}
			</div>
		`;
		el.addEventListener("click", () => selectSession(session.sessionId));
		list.appendChild(el);
	});
}

async function selectSession(sessionId) {
	state.selectedSession = sessionId;
	renderSessionList();

	const result = await post("loadSession", { sessionId });
	if (!result.success) return;

	state.detail = result;
	showDetail(result);
}

function showDetail(data) {
	$("#empty-state").classList.add("hidden");
	$("#detail-view").classList.remove("hidden");

	const s = data.session;
	$("#detail-id").textContent = s.sessionId;
	$("#detail-officer").textContent = s.officerName;
	$("#detail-meta").textContent = `${s.unit || "—"} · Crachá ${s.badge || "—"} · ${s.startedAt || ""}`;
	$("#stat-duration").textContent = s.durationLabel || formatDuration(s.duration);
	$("#stat-events").textContent = s.eventCount || 0;
	$("#stat-bookmarks").textContent = s.bookmarkCount || 0;
	$("#stat-battery").textContent = `${Math.floor(s.batteryEnd || s.batteryStart || 0)}%`;

	const deleteBtn = $("#btn-delete");
	if (state.supervisor) {
		deleteBtn.classList.remove("hidden");
	} else {
		deleteBtn.classList.add("hidden");
	}

	renderTimeline(data.events || []);
	renderBookmarks(data.bookmarks || []);
}

function renderTimeline(events) {
	const container = $("#timeline");
	container.innerHTML = "";

	const filtered = events.filter((e) => e.type !== "snapshot");

	if (!filtered.length) {
		container.innerHTML = `<div style="padding:20px;color:rgba(255,255,255,0.4);font-size:0.8rem">Nenhum evento registrado nesta sessão.</div>`;
		return;
	}

	filtered.forEach((event) => {
		const el = document.createElement("div");
		el.className = `timeline-item type-${event.type}`;
		el.innerHTML = `
			<div class="tl-time">${formatDuration(event.elapsed)}</div>
			<div class="tl-body">
				<div class="tl-type">${eventIcon(event.type)} ${event.type.replace(/_/g, " ")}</div>
				<div class="tl-label">${event.label}</div>
				${event.street ? `<div class="tl-location">📍 ${event.street}</div>` : ""}
			</div>
		`;
		container.appendChild(el);
	});
}

function renderBookmarks(bookmarks) {
	const container = $("#bookmarks-list");
	container.innerHTML = "";

	if (!bookmarks.length) {
		container.innerHTML = `<div style="padding:20px;color:rgba(255,255,255,0.4);font-size:0.8rem">Nenhuma marcação nesta sessão.</div>`;
		return;
	}

	bookmarks.forEach((bm) => {
		const el = document.createElement("div");
		el.className = "timeline-item type-bookmark";
		el.innerHTML = `
			<div class="tl-time">${formatDuration(bm.elapsed)}</div>
			<div class="tl-body">
				<div class="tl-type">📌 Marcação</div>
				<div class="tl-label">${bm.label}</div>
				${bm.street ? `<div class="tl-location">📍 ${bm.street}</div>` : ""}
			</div>
		`;
		container.appendChild(el);
	});
}

function switchTab(tab) {
	state.currentTab = tab;
	$$(".tab").forEach((t) => t.classList.toggle("active", t.dataset.tab === tab));
	$("#tab-timeline").classList.toggle("hidden", tab !== "timeline");
	$("#tab-bookmarks").classList.toggle("hidden", tab !== "bookmarks");
	$("#tab-report").classList.toggle("hidden", tab !== "report");
}

function updateHud(data) {
	if (!data) return;
	$("#hud-session").textContent = data.sessionId || "";
	$("#hud-time").textContent = data.timestamp || "";
	$("#hud-officer").textContent = data.officerName ? `OFICIAL: ${data.officerName}` : "";
	$("#hud-badge").textContent = data.badge ? `CRACHÁ: ${data.badge}` : "";
	$("#hud-unit").textContent = data.unit ? `UNIDADE: ${data.unit}` : "";
	$("#hud-gps").textContent = data.gps ? `GPS: ${data.gps}` : "";
	$("#hud-speed").textContent = data.speed !== undefined ? `VEL: ${data.speed} km/h` : "";
	$("#hud-battery").textContent = data.battery !== undefined ? `BAT: ${Math.floor(data.battery)}%` : "";
}

function openReview(data) {
	state.sessions = data.sessions || [];
	state.supervisor = data.supervisor || false;
	state.selectedSession = null;
	state.detail = null;

	if (data.officerName) {
		$("#header-subtitle").textContent = `Central de Revisão — ${data.officerName}`;
	}

	$("#app").classList.remove("hidden");
	$("#empty-state").classList.remove("hidden");
	$("#detail-view").classList.add("hidden");
	renderSessionList();
}

function closeAll() {
	$("#app").classList.add("hidden");
	$("#hud").classList.add("hidden");
	post("close");
}

$("#btn-close").addEventListener("click", closeAll);

$("#btn-export").addEventListener("click", async () => {
	if (!state.selectedSession) return;
	const result = await post("exportSession", { sessionId: state.selectedSession });
	if (result.success && result.report) {
		$("#report-box").textContent = result.report;
		switchTab("report");
	}
});

$("#btn-delete").addEventListener("click", async () => {
	if (!state.selectedSession || !state.supervisor) return;
	const result = await post("deleteSession", { sessionId: state.selectedSession });
	if (result.success) {
		state.sessions = state.sessions.filter((s) => s.sessionId !== state.selectedSession);
		state.selectedSession = null;
		state.detail = null;
		$("#detail-view").classList.add("hidden");
		$("#empty-state").classList.remove("hidden");
		renderSessionList();
	}
});

$("#search-input").addEventListener("input", debounce(async (e) => {
	const query = e.target.value.trim();
	const filter = $("#filter-select").value;
	const result = await post("searchSessions", { query, filter });
	state.sessions = result.sessions || [];
	renderSessionList();
}, 300));

$("#filter-select").addEventListener("change", async () => {
	const query = $("#search-input").value.trim();
	const filter = $("#filter-select").value;
	const result = await post("searchSessions", { query, filter });
	state.sessions = result.sessions || [];
	renderSessionList();
});

$$(".tab").forEach((tab) => {
	tab.addEventListener("click", () => switchTab(tab.dataset.tab));
});

document.addEventListener("keydown", (e) => {
	if (e.key === "Escape") closeAll();
});

function debounce(fn, ms) {
	let timer;
	return (...args) => {
		clearTimeout(timer);
		timer = setTimeout(() => fn(...args), ms);
	};
}

window.addEventListener("message", (event) => {
	const msg = event.data;
	if (!msg || !msg.action) return;

	switch (msg.action) {
		case "openReview":
			openReview(msg.data || {});
			break;
		case "close":
			$("#app").classList.add("hidden");
			break;
		case "hud":
			if (msg.visible && msg.data) {
				$("#hud").classList.remove("hidden");
				updateHud(msg.data);
			} else {
				$("#hud").classList.add("hidden");
			}
			break;
	}
});
