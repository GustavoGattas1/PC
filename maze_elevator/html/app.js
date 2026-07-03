/**
 * MAZE ELEVATOR — NUI APP
 * Comunicação segura com o client.lua via callbacks NUI.
 */

const app = document.getElementById("app");
const buildingName = document.getElementById("building-name");
const subtitle = document.getElementById("subtitle");
const floorList = document.getElementById("floor-list");
const btnClose = document.getElementById("btn-close");
const logo = document.getElementById("logo");

let currentData = null;
const sounds = {};

/**
 * Requisição POST para o client.lua.
 */
function post(endpoint, data = {}) {
	return fetch(`https://maze_elevator/${endpoint}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data)
	});
}

/**
 * Pré-carrega sons definidos no config.
 */
function preloadSounds(soundConfig = {}) {
	const map = {
		button: soundConfig.Button,
		elevator: soundConfig.Elevator,
		ding: soundConfig.Ding
	};

	for (const [key, path] of Object.entries(map)) {
		if (!path) continue;
		const audio = new Audio(path);
		audio.preload = "auto";
		sounds[key] = audio;
	}
}

/**
 * Toca um som da interface.
 */
function playSound(name, volume = 0.45) {
	const audio = sounds[name];
	if (!audio) return;

	const clone = audio.cloneNode();
	clone.volume = volume;
	clone.play().catch(() => {});
}

/**
 * Renderiza a lista de andares.
 */
function renderFloors(floors = []) {
	floorList.innerHTML = "";

	floors.forEach((floor) => {
		const item = document.createElement("button");
		item.type = "button";
		item.className = "floor-item";

		if (floor.current) item.classList.add("current");
		if (floor.locked) item.classList.add("locked");

		const icon = floor.icon?.startsWith("fa-") ? floor.icon : "fa-layer-group";

		item.innerHTML = `
			<div class="floor-icon"><i class="fa-solid ${icon}"></i></div>
			<div class="floor-info">
				<h3>${floor.label || "Andar"}</h3>
				<p>${floor.description || ""}</p>
			</div>
			<div class="floor-badge ${floor.current ? "here" : floor.locked ? "locked" : ""}">
				${floor.current ? "Aqui" : floor.locked ? "Bloqueado" : "Ir"}
			</div>
		`;

		item.addEventListener("click", () => {
			if (floor.locked || floor.current) return;

			playSound("button", currentData?.sounds?.Volume || 0.45);
			item.style.transform = "scale(0.98)";

			setTimeout(() => {
				post("selectFloor", { floor: floor.index });
			}, 120);
		});

		floorList.appendChild(item);
	});
}

/**
 * Abre o painel com os dados vindos do servidor.
 */
function openPanel(data) {
	currentData = data;

	buildingName.textContent = (data.label || "ELEVADOR").toUpperCase();
	subtitle.textContent = data.subtitle || "Selecione o andar";

	if (data.logo) {
		logo.src = data.logo;
	}

	preloadSounds(data.sounds || {});
	renderFloors(data.floors || []);

	app.classList.remove("hidden");
}

/**
 * Fecha o painel.
 */
function closePanel() {
	app.classList.add("hidden");
	currentData = null;
	floorList.innerHTML = "";
}

btnClose.addEventListener("click", () => {
	playSound("button");
	post("close");
});

window.addEventListener("keydown", (event) => {
	if (event.key === "Escape" && !app.classList.contains("hidden")) {
		post("close");
	}
});

window.addEventListener("message", (event) => {
	const { action, data, sound, volume } = event.data || {};

	switch (action) {
		case "open":
			openPanel(data || {});
			break;
		case "close":
			closePanel();
			break;
		case "playSound":
			playSound(sound, volume);
			break;
	}
});
