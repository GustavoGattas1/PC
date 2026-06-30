const app = document.getElementById("app");
const productGrid = document.getElementById("product-grid");
const categoryNav = document.getElementById("category-nav");
const sectionTitle = document.getElementById("section-title");
const sectionDesc = document.getElementById("section-desc");
const searchInput = document.getElementById("search-input");
const balanceGems = document.getElementById("balance-gems");
const balanceBank = document.getElementById("balance-bank");
const playerName = document.getElementById("player-name");
const playerVip = document.getElementById("player-vip");
const viewProducts = document.getElementById("view-products");
const viewHistory = document.getElementById("view-history");
const historyList = document.getElementById("history-list");
const modalOverlay = document.getElementById("modal-overlay");
const toast = document.getElementById("toast");

let catalog = { categories: [], products: [] };
let player = {};
let history = [];
let currentCategory = "all";
let currentView = "products";
let selectedProduct = null;
let purchasing = false;

const categoryIcons = {
	all: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>',
	crown: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 20h20L19 8l-5 4-2-6-2 6-5-4z"/></svg>',
	car: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 17h14v-5H5v5zM5 12l2-5h10l2 5"/><circle cx="7.5" cy="17" r="1.5"/><circle cx="16.5" cy="17" r="1.5"/></svg>',
	home: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>',
	box: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"/></svg>',
	gift: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/><line x1="12" y1="22" x2="12" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 010-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 000-5C13 2 12 7 12 7z"/></svg>',
	star: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>',
	grid: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>'
};

const typeIcons = {
	vip: "👑",
	vehicle: "🚗",
	house: "🏠",
	item: "📦",
	pack: "🎁",
	extra: "⭐"
};

const typeLabels = {
	vip: "VIP",
	vehicle: "Veículo",
	house: "Casa",
	item: "Item",
	pack: "Pack",
	extra: "Extra"
};

function post(endpoint, data = {}) {
	return fetch(`https://loja-vip/${endpoint}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data)
	}).then(r => r.json()).catch(() => ({}));
}

function formatMoney(value) {
	return "R$ " + Number(value || 0).toLocaleString("pt-BR");
}

function formatGems(value) {
	return Number(value || 0).toLocaleString("pt-BR");
}

function getBadgeClass(badge) {
	if (!badge) return "";
	const lower = badge.toLowerCase();
	if (lower.includes("popular")) return "badge-popular";
	if (lower.includes("recomend")) return "badge-recommended";
	if (lower.includes("premium") || lower.includes("luxo")) return "badge-premium";
	if (lower.includes("elite") || lower.includes("melhor")) return "badge-elite";
	return "badge-default";
}

function showToast(message, type = "success") {
	const toastIcon = document.getElementById("toast-icon");
	const toastMessage = document.getElementById("toast-message");
	toastIcon.textContent = type === "success" ? "✓" : "✕";
	toastMessage.textContent = message;
	toast.className = `toast ${type}`;
	setTimeout(() => toast.classList.add("hidden"), 3500);
}

function closeApp() {
	app.classList.add("hidden");
	closeModal();
	post("close");
}

function updateBalance(balance) {
	if (!balance) return;
	balanceGems.textContent = formatGems(balance.gems);
	balanceBank.textContent = formatMoney(balance.bank);
}

function updatePlayer(data) {
	if (!data) return;
	playerName.textContent = data.name || "Jogador";
	if (data.vip) {
		playerVip.textContent = data.vip;
		playerVip.classList.remove("hidden");
	} else {
		playerVip.classList.add("hidden");
	}
	updateBalance(data.balance);
}

function renderCategories() {
	categoryNav.innerHTML = "";
	(catalog.categories || []).forEach(cat => {
		const btn = document.createElement("button");
		btn.className = `nav-item${cat.id === currentCategory ? " active" : ""}`;
		btn.dataset.category = cat.id;
		btn.innerHTML = `${categoryIcons[cat.icon] || categoryIcons.grid}<span>${cat.label}</span>`;
		btn.addEventListener("click", () => selectCategory(cat.id));
		categoryNav.appendChild(btn);
	});
}

function selectCategory(categoryId) {
	currentCategory = categoryId;
	currentView = "products";
	viewProducts.classList.remove("hidden");
	viewHistory.classList.add("hidden");

	const cat = (catalog.categories || []).find(c => c.id === categoryId);
	sectionTitle.textContent = cat ? cat.label : "Produtos";
	sectionDesc.textContent = cat ? cat.description : "";

	document.querySelectorAll(".category-nav .nav-item").forEach(el => {
		el.classList.toggle("active", el.dataset.category === categoryId);
	});
	document.querySelectorAll(".sidebar-footer .nav-item").forEach(el => {
		el.classList.remove("active");
	});

	renderProducts();
}

function showHistory() {
	currentView = "history";
	viewProducts.classList.add("hidden");
	viewHistory.classList.remove("hidden");
	sectionTitle.textContent = "Histórico de Compras";
	sectionDesc.textContent = "Suas últimas transações na loja";

	document.querySelectorAll(".category-nav .nav-item").forEach(el => {
		el.classList.remove("active");
	});
	document.querySelector(".sidebar-footer .nav-item").classList.add("active");

	renderHistory();
}

function getFilteredProducts() {
	let products = catalog.products || [];

	if (currentCategory !== "all") {
		products = products.filter(p => p.category === currentCategory);
	}

	const query = (searchInput.value || "").toLowerCase().trim();
	if (query) {
		products = products.filter(p =>
			(p.name || "").toLowerCase().includes(query) ||
			(p.description || "").toLowerCase().includes(query) ||
			(p.type || "").toLowerCase().includes(query)
		);
	}

	return products;
}

function renderProducts() {
	const products = getFilteredProducts();
	productGrid.innerHTML = "";

	if (!products.length) {
		productGrid.innerHTML = '<div class="empty-state">Nenhum produto encontrado.</div>';
		return;
	}

	products.forEach((product, i) => {
		const card = document.createElement("div");
		card.className = "product-card";
		card.style.animationDelay = `${i * 0.04}s`;

		const badgeHtml = product.badge
			? `<span class="product-badge ${getBadgeClass(product.badge)}">${product.badge}</span>`
			: "";

		const originalHtml = product.originalPrice
			? `<span class="original">${formatGems(product.originalPrice)}</span>`
			: "";

		const currencyIcon = (product.currency || "gems") === "gems"
			? '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2L2 9l10 13L22 9 12 2z"/></svg>'
			: "";

		card.innerHTML = `
			${badgeHtml}
			<div class="product-icon icon-${product.type}">${typeIcons[product.type] || "📋"}</div>
			<div class="product-name">${product.name}</div>
			<div class="product-desc">${product.description || ""}</div>
			<div class="product-footer">
				<div class="product-price">
					${originalHtml}
					${currencyIcon}
					<span>${formatGems(product.price)}</span>
				</div>
				<span class="product-type">${typeLabels[product.type] || product.type}</span>
			</div>
		`;

		card.addEventListener("click", () => openModal(product));
		productGrid.appendChild(card);
	});
}

function renderHistory() {
	historyList.innerHTML = "";

	if (!history || !history.length) {
		historyList.innerHTML = '<div class="empty-state">Nenhuma compra realizada ainda.</div>';
		return;
	}

	history.forEach(item => {
		const el = document.createElement("div");
		el.className = "history-item";
		const date = item.created_at ? new Date(item.created_at).toLocaleString("pt-BR") : "";
		el.innerHTML = `
			<div class="history-info">
				<h4>${item.product_name || item.product_id}</h4>
				<span>${typeLabels[item.product_type] || item.product_type} • ${date}</span>
			</div>
			<span class="history-price">${formatGems(item.price)} 💎</span>
		`;
		historyList.appendChild(el);
	});
}

function openModal(product) {
	selectedProduct = product;
	document.getElementById("modal-title").textContent = "Confirmar Compra";
	document.getElementById("modal-product-name").textContent = product.name;
	document.getElementById("modal-product-desc").textContent = product.description || "";

	const modalIcon = document.getElementById("modal-icon");
	modalIcon.className = `modal-icon icon-${product.type}`;
	modalIcon.textContent = typeIcons[product.type] || "📋";

	const benefitsList = document.getElementById("modal-benefits");
	benefitsList.innerHTML = "";
	if (product.benefits && product.benefits.length) {
		product.benefits.forEach(b => {
			const li = document.createElement("li");
			li.textContent = b;
			benefitsList.appendChild(li);
		});
		benefitsList.classList.remove("hidden");
	} else {
		benefitsList.classList.add("hidden");
	}

	document.getElementById("modal-price-value").textContent = formatGems(product.price);
	modalOverlay.classList.remove("hidden");
}

function closeModal() {
	modalOverlay.classList.add("hidden");
	selectedProduct = null;
	purchasing = false;
	document.getElementById("modal-confirm").disabled = false;
}

async function confirmPurchase() {
	if (!selectedProduct || purchasing) return;
	purchasing = true;
	document.getElementById("modal-confirm").disabled = true;

	const result = await post("purchase", { productId: selectedProduct.id });

	if (result && result.success) {
		showToast(result.message || "Compra realizada!", "success");
		if (result.balance) updateBalance(result.balance);
		closeModal();
		post("refresh");
	} else {
		showToast(result?.message || "Erro na compra.", "error");
		purchasing = false;
		document.getElementById("modal-confirm").disabled = false;
	}
}

function openShop(data) {
	catalog = data.catalog || catalog;
	player = data.player || player;
	history = data.history || history;

	updatePlayer(player);
	renderCategories();
	selectCategory("all");
	app.classList.remove("hidden");
}

// Event Listeners
document.getElementById("btn-close").addEventListener("click", closeApp);
document.getElementById("modal-close").addEventListener("click", closeModal);
document.getElementById("modal-cancel").addEventListener("click", closeModal);
document.getElementById("modal-confirm").addEventListener("click", confirmPurchase);
document.querySelector(".sidebar-footer .nav-item").addEventListener("click", showHistory);
searchInput.addEventListener("input", renderProducts);

document.addEventListener("keydown", (e) => {
	if (e.key === "Escape") {
		if (!modalOverlay.classList.contains("hidden")) {
			closeModal();
		} else if (!app.classList.contains("hidden")) {
			closeApp();
		}
	}
});

modalOverlay.addEventListener("click", (e) => {
	if (e.target === modalOverlay) closeModal();
});

window.addEventListener("message", (event) => {
	const data = event.data;
	if (!data || !data.action) return;

	switch (data.action) {
		case "open":
			openShop(data);
			break;
		case "close":
			app.classList.add("hidden");
			closeModal();
			break;
		case "updateBalance":
			updateBalance(data.balance);
			break;
		case "refresh":
			if (data.catalog) catalog = data.catalog;
			if (data.player) { player = data.player; updatePlayer(player); }
			if (data.history) history = data.history;
			if (currentView === "history") renderHistory();
			else renderProducts();
			break;
	}
});
