const RESOURCE = typeof GetParentResourceName === "function" ? GetParentResourceName() : "camera-corporal";

let state = {
	sessions: [],
	live: [],
	selectedSession: null,
	supervisor: false,
	canWatch: false,
	currentTab: "timeline",
	currentSection: "live",
	detail: null,
	liveTimer: null
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
		weapon_drawn: "🔫", weapon_fired: "💥", pursuit: "🚔", siren: "🚨",
		damage: "🩹", bookmark: "📌", session_start: "▶️", snapshot: "📍"
	};
	return icons[type] || "●";
}

function switchSection(section) {
	state.currentSection = section;
	$$(".nav-btn").forEach((b) => b.classList.toggle("active", b.dataset.section === section));
	$("#section-live").classList.toggle("hidden", section !== "live");
	$("#section-archive").classList.toggle("hidden", section !== "archive");
}

function renderLiveGrid() {
	const grid = $("#live-grid");
	const empty = $("#live-empty");
	grid.innerHTML = "";

	$("#stat-live-count").textContent = state.live.length;

	if (!state.canWatch) {
		grid.innerHTML = `<div class="no-access">Apenas supervisores podem assistir feeds ao vivo.</div>`;
		empty.classList.add("hidden");
		return;
	}

	if (!state.live.length) {
		empty.classList.remove("hidden");
		return;
	}

	empty.classList.add("hidden");

	state.live.forEach((officer) => {
		const card = document.createElement("div");
		card.className = "live-card";
		card.innerHTML = `
			<div class="live-card-head">
				<span class="live-rec">● REC</span>
				<span class="live-elapsed">${formatDuration(officer.elapsed)}</span>
			</div>
			<div class="live-card-body">
				<h3>${officer.officerName}</h3>
				<p class="live-unit">${officer.unit || "—"} · ${officer.badge || ""}</p>
				<div class="live-meta">
					<span>🚗 ${officer.speed || 0} km/h</span>
					<span>🔋 ${Math.floor(officer.battery || 0)}%</span>
				</div>
				<p class="live-street">📍 ${officer.street || "—"}</p>
				<p class="live-weapon">${officer.weapon || "Desarmado"}</p>
			</div>
			<button class="btn btn-primary btn-watch" data-source="${officer.source}">Assistir ao vivo</button>
		`;
		card.querySelector(".btn-watch").addEventListener("click", () => watchOfficer(officer));
		grid.appendChild(card);
	});
}

async function refreshLive() {
	if (!state.canWatch) return;
	const result = await post("getLiveOfficers");
	state.live = result.officers || [];
	renderLiveGrid();
}

async function watchOfficer(officer) {
	const result = await post("startWatch", { source: officer.source });
	if (!result.success) return;
}

function renderSessionList() {
	const list = $("#session-list");
	list.innerHTML = "";
	$("#stat-archive-count").textContent = state.sessions.length;

	if (!state.sessions.length) {
		list.innerHTML = `<div class="list-empty">Nenhuma gravação encontrada</div>`;
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

function renderArchiveTimeline(events) {
	const container = $("#archive-timeline");
	container.innerHTML = "";
	const items = (events || []).filter((e) => e.type !== "snapshot").slice(0, 40);
	if (!items.length) return;

	const max = Math.max(...items.map((e) => e.elapsed || 0), 1);
	items.forEach((event) => {
		const mark = document.createElement("button");
		mark.className = `tl-mark type-${event.type}`;
		mark.style.left = `${((event.elapsed || 0) / max) * 100}%`;
		mark.title = `${formatDuration(event.elapsed)} — ${event.label}`;
		mark.textContent = eventIcon(event.type);
		container.appendChild(mark);
	});
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
	$("#btn-delete").classList.toggle("hidden", !state.supervisor);

	renderTimeline(data.events || []);
	renderBookmarks(data.bookmarks || []);
	renderArchiveTimeline(data.events || []);
}

function renderTimeline(events) {
	const container = $("#timeline");
	container.innerHTML = "";
	const filtered = (events || []).filter((e) => e.type !== "snapshot");
	if (!filtered.length) {
		container.innerHTML = `<div class="list-empty">Nenhum evento registrado.</div>`;
		return;
	}
	filtered.forEach((event) => {
		const el = document.createElement("div");
		el.className = `timeline-item type-${event.type}`;
		el.innerHTML = `
			<div class="tl-time">${formatDuration(event.elapsed)}</div>
			<div class="tl-body">
				<div class="tl-type">${eventIcon(event.type)} ${(event.type || "").replace(/_/g, " ")}</div>
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
		container.innerHTML = `<div class="list-empty">Nenhuma marcação.</div>`;
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

function showLiveOverlay(data) {
	$("#live-overlay").classList.remove("hidden");
	$("#live-officer-name").textContent = data.officerName || "Oficial";
	$("#live-unit").textContent = data.unit || "—";
	$("#live-speed").textContent = `${data.speed || 0} km/h`;
	$("#live-battery").textContent = `${Math.floor(data.battery || 0)}%`;
	$("#live-street").textContent = data.street || "—";
}

function hideLiveOverlay() {
	$("#live-overlay").classList.add("hidden");
}

function showPlaybackOverlay(data) {
	const session = data.session || {};
	const duration = data.duration || session.duration || 0;
	$("#playback-overlay").classList.remove("hidden");
	$("#playback-session-id").textContent = session.sessionId || "BCC";
	$("#playback-slider").max = Math.max(1, duration);
	$("#playback-slider").value = data.elapsed || 0;
	$("#playback-current").textContent = formatDuration(data.elapsed || 0);
	$("#playback-total").textContent = formatDuration(duration);
}

function hidePlaybackOverlay() {
	$("#playback-overlay").classList.add("hidden");
}

function updatePlaybackOverlay(data) {
	if (!data) return;
	$("#playback-slider").value = data.elapsed || 0;
	$("#playback-current").textContent = formatDuration(data.elapsed || 0);
	if (data.frame && data.frame.label) {
		$("#playback-info").textContent = data.frame.label;
	}
}

function openDispatch(data) {
	state.sessions = data.sessions || [];
	state.live = data.live || [];
	state.supervisor = data.supervisor || false;
	state.canWatch = data.canWatch || false;
	state.selectedSession = null;
	state.detail = null;

	if (data.officerName) {
		$("#header-subtitle").textContent = `Operador: ${data.officerName}`;
	}

	if (!state.canWatch) switchSection("archive");
	else switchSection("live");

	$("#app").classList.remove("hidden");
	$("#empty-state").classList.remove("hidden");
	$("#detail-view").classList.add("hidden");
	renderLiveGrid();
	renderSessionList();

	if (state.liveTimer) clearInterval(state.liveTimer);
	if (state.canWatch) {
		state.liveTimer = setInterval(refreshLive, 3000);
	}
}

function closeAll() {
	if (state.liveTimer) {
		clearInterval(state.liveTimer);
		state.liveTimer = null;
	}
	$("#app").classList.add("hidden");
	$("#hud").classList.add("hidden");
	hideLiveOverlay();
	hidePlaybackOverlay();
	post("close");
}

$("#btn-close").addEventListener("click", closeAll);
$("#btn-refresh-live").addEventListener("click", refreshLive);

$("#btn-export").addEventListener("click", async () => {
	if (!state.selectedSession) return;
	const result = await post("exportSession", { sessionId: state.selectedSession });
	if (result.success && result.report) {
		$("#report-box").textContent = result.report;
		switchTab("report");
	}
});

$("#btn-playback").addEventListener("click", async () => {
	if (!state.selectedSession) return;
	await post("startPlayback", { sessionId: state.selectedSession });
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
	const result = await post("searchSessions", { query: e.target.value.trim(), filter: $("#filter-select").value });
	state.sessions = result.sessions || [];
	renderSessionList();
}, 300));

$("#filter-select").addEventListener("change", async () => {
	const result = await post("searchSessions", { query: $("#search-input").value.trim(), filter: $("#filter-select").value });
	state.sessions = result.sessions || [];
	renderSessionList();
});

$("#playback-slider").addEventListener("input", (e) => {
	post("seekPlayback", { elapsed: Number(e.target.value) });
});

$$(".nav-btn").forEach((btn) => btn.addEventListener("click", () => switchSection(btn.dataset.section)));
$$(".tab").forEach((tab) => tab.addEventListener("click", () => switchTab(tab.dataset.tab)));

document.addEventListener("keydown", (e) => {
	if (e.key === "Escape" && !$("#app").classList.contains("hidden")) closeAll();
});

function debounce(fn, ms) {
	let timer;
	return (...args) => { clearTimeout(timer); timer = setTimeout(() => fn(...args), ms); };
}

window.addEventListener("message", (event) => {
	const msg = event.data;
	if (!msg || !msg.action) return;

	switch (msg.action) {
		case "openDispatch":
		case "openReview":
			openDispatch(msg.data || {});
			break;
		case "close":
			$("#app").classList.add("hidden");
			break;
		case "hud":
			if (msg.visible && msg.data) { $("#hud").classList.remove("hidden"); updateHud(msg.data); }
			else $("#hud").classList.add("hidden");
			break;
		case "liveOverlay":
			if (msg.visible) showLiveOverlay(msg.data || {});
			else hideLiveOverlay();
			break;
		case "liveOverlayUpdate":
			showLiveOverlay(msg.data || {});
			break;
		case "playbackOverlay":
			if (msg.visible) showPlaybackOverlay(msg.data || {});
			else hidePlaybackOverlay();
			break;
		case "playbackOverlayUpdate":
			updatePlaybackOverlay(msg.data);
			break;
	}
});
