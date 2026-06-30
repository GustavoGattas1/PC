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
const playerAvatar = document.getElementById("player-avatar");
const viewProducts = document.getElementById("view-products");
const viewHistory = document.getElementById("view-history");
const heroBanner = document.getElementById("hero-banner");
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

const CATEGORY_EMOJI = {
	all: "🌟", crown: "👑", car: "🏎️", home: "🏡",
	box: "📦", gift: "🎁", star: "✨", grid: "🌟"
};

const CATEGORY_GRADIENT = {
	all: "cat-all", vip: "cat-vip", vehicles: "cat-vehicle",
	houses: "cat-house", items: "cat-item", packs: "cat-pack", extras: "cat-extra"
};

const TYPE_LABELS = {
	vip: "VIP", vehicle: "Veículo", house: "Casa",
	item: "Item", pack: "Pack", extra: "Extra"
};

const TYPE_EMOJI = {
	vip: "👑", vehicle: "🚗", house: "🏠", item: "📦", pack: "🎁", extra: "⭐"
};

const PRODUCT_IMAGES = {
	vip_bronze: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=500&h=280&fit=crop",
	vip_prata: "https://images.unsplash.com/photo-1635322978813-dbe983d94d48?w=500&h=280&fit=crop",
	vip_ouro: "https://images.unsplash.com/photo-1610375461246-83e3f3d815e6?w=500&h=280&fit=crop",
	vip_diamante: "https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=500&h=280&fit=crop",
	veh_adder: "https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=500&h=280&fit=crop",
	veh_t20: "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=500&h=280&fit=crop",
	veh_zentorno: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=500&h=280&fit=crop",
	veh_sultanrs: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=500&h=280&fit=crop",
	veh_bati: "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&h=280&fit=crop",
	veh_insurgent: "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=500&h=280&fit=crop",
	veh_volatus: "https://images.unsplash.com/photo-1527900839177-dbb3b5ebb2d0?w=500&h=280&fit=crop",
	veh_seashark: "https://images.unsplash.com/photo-1567899378494-47b22e2f9d0e?w=500&h=280&fit=crop",
	house_apto_vip: "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=500&h=280&fit=crop",
	house_casa_praia: "https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500&h=280&fit=crop",
	house_mansao_hills: "https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=500&h=280&fit=crop",
	house_loft_industrial: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500&h=280&fit=crop",
	item_kit_inicial: "https://images.unsplash.com/photo-1607083206869-4c7672f72d8a?w=500&h=280&fit=crop",
	item_kit_armas: "https://images.unsplash.com/photo-1595590424283-b8f190a9c4c0?w=500&h=280&fit=crop",
	item_dinheiro_50k: "https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=500&h=280&fit=crop",
	item_dinheiro_250k: "https://images.unsplash.com/photo-1580519542036-c47de6196ba5?w=500&h=280&fit=crop",
	pack_starter: "https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=500&h=280&fit=crop",
	pack_premium: "https://images.unsplash.com/photo-1607083206869-4c7672f72d8a?w=500&h=280&fit=crop",
	pack_elite: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=500&h=280&fit=crop",
	extra_slot_personagem: "https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=500&h=280&fit=crop",
	extra_slot_garagem: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=280&fit=crop",
	extra_placa_custom: "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=500&h=280&fit=crop",
	extra_nome_personagem: "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=500&h=280&fit=crop"
};

const TYPE_IMAGES = {
	vip: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=500&h=280&fit=crop",
	vehicle: "https://images.unsplash.com/photo-1494976388531-d1058498cdd8?w=500&h=280&fit=crop",
	house: "https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=500&h=280&fit=crop",
	item: "https://images.unsplash.com/photo-1607083206869-4c7672f72d8a?w=500&h=280&fit=crop",
	pack: "https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=500&h=280&fit=crop",
	extra: "https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=500&h=280&fit=crop"
};

const HERO_BY_CATEGORY = {
	all: "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=900&h=200&fit=crop",
	vip: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=900&h=200&fit=crop",
	vehicles: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900&h=200&fit=crop",
	houses: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=900&h=200&fit=crop",
	items: "https://images.unsplash.com/photo-1607083206869-4c7672f72d8a?w=900&h=200&fit=crop",
	packs: "https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=900&h=200&fit=crop",
	extras: "https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=900&h=200&fit=crop"
};

function getProductImage(product) {
	return PRODUCT_IMAGES[product.id] || TYPE_IMAGES[product.type] || TYPE_IMAGES.item;
}

function post(endpoint, data = {}) {
	return fetch(`https://loja-vip/${endpoint}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data)
	}).then(r => r.json()).catch(() => ({}));
}

function formatMoney(v) { return "R$ " + Number(v || 0).toLocaleString("pt-BR"); }
function formatGems(v) { return Number(v || 0).toLocaleString("pt-BR"); }

function getBadgeClass(badge) {
	if (!badge) return "";
	const l = badge.toLowerCase();
	if (l.includes("popular")) return "badge-popular";
	if (l.includes("recomend")) return "badge-hot";
	if (l.includes("premium") || l.includes("luxo")) return "badge-premium";
	if (l.includes("elite") || l.includes("melhor")) return "badge-elite";
	if (l.includes("%")) return "badge-sale";
	return "badge-default";
}

function showToast(msg, type = "success") {
	document.getElementById("toast-icon").textContent = type === "success" ? "✅" : "❌";
	document.getElementById("toast-message").textContent = msg;
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
	const name = data.name || "Jogador";
	playerName.textContent = name;
	playerAvatar.textContent = name.charAt(0).toUpperCase();
	if (data.vip) {
		playerVip.textContent = "★ " + data.vip;
		playerVip.classList.remove("hidden");
	} else {
		playerVip.classList.add("hidden");
	}
	updateBalance(data.balance);
}

function updateHero(categoryId) {
	const img = heroBanner.querySelector(".hero-bg");
	if (img) img.src = HERO_BY_CATEGORY[categoryId] || HERO_BY_CATEGORY.all;
}

function renderCategories() {
	categoryNav.innerHTML = "";
	(catalog.categories || []).forEach(cat => {
		const btn = document.createElement("button");
		btn.className = `nav-item ${CATEGORY_GRADIENT[cat.id] || "cat-all"}${cat.id === currentCategory ? " active" : ""}`;
		btn.dataset.category = cat.id;
		btn.innerHTML = `
			<span class="nav-emoji">${CATEGORY_EMOJI[cat.icon] || "🌟"}</span>
			<span>${cat.label}</span>
			<span class="nav-arrow">›</span>
		`;
		btn.addEventListener("click", () => selectCategory(cat.id));
		categoryNav.appendChild(btn);
	});
}

function selectCategory(categoryId) {
	currentCategory = categoryId;
	currentView = "products";
	viewProducts.classList.remove("hidden");
	viewHistory.classList.add("hidden");
	heroBanner.classList.remove("hidden");

	const cat = (catalog.categories || []).find(c => c.id === categoryId);
	sectionTitle.textContent = cat ? cat.label : "Produtos";
	sectionDesc.textContent = cat ? cat.description : "";
	updateHero(categoryId);

	document.querySelectorAll(".category-nav .nav-item").forEach(el => {
		el.classList.toggle("active", el.dataset.category === categoryId);
	});
	document.querySelector(".history-btn")?.classList.remove("active");
	renderProducts();
}

function showHistory() {
	currentView = "history";
	viewProducts.classList.add("hidden");
	viewHistory.classList.remove("hidden");
	heroBanner.classList.add("hidden");
	sectionTitle.textContent = "Histórico";
	sectionDesc.textContent = "Suas últimas compras";

	document.querySelectorAll(".category-nav .nav-item").forEach(el => el.classList.remove("active"));
	document.querySelector(".history-btn")?.classList.add("active");
	renderHistory();
}

function getFilteredProducts() {
	let products = catalog.products || [];
	if (currentCategory !== "all") products = products.filter(p => p.category === currentCategory);
	const q = (searchInput.value || "").toLowerCase().trim();
	if (q) {
		products = products.filter(p =>
			(p.name || "").toLowerCase().includes(q) ||
			(p.description || "").toLowerCase().includes(q)
		);
	}
	return products;
}

function renderProducts() {
	const products = getFilteredProducts();
	productGrid.innerHTML = "";

	if (!products.length) {
		productGrid.innerHTML = '<div class="empty-state">🔍 Nenhum produto encontrado.</div>';
		return;
	}

	products.forEach((product, i) => {
		const card = document.createElement("div");
		card.className = `product-card card-${product.type}`;
		card.style.animationDelay = `${i * 0.05}s`;

		const img = getProductImage(product);
		const badge = product.badge
			? `<span class="product-badge ${getBadgeClass(product.badge)}">${product.badge}</span>` : "";
		const original = product.originalPrice
			? `<span class="original">${formatGems(product.originalPrice)}</span>` : "";

		card.innerHTML = `
			<div class="card-image">
				<img src="${img}" alt="${product.name}" loading="lazy">
				<div class="card-image-overlay"></div>
				<span class="card-type-pill">${TYPE_EMOJI[product.type] || "📋"} ${TYPE_LABELS[product.type] || product.type}</span>
				${badge}
			</div>
			<div class="card-body">
				<h3 class="product-name">${product.name}</h3>
				<p class="product-desc">${product.description || ""}</p>
				<div class="product-footer">
					<div class="product-price">
						${original}
						<span class="gem">💎</span>
						<strong>${formatGems(product.price)}</strong>
					</div>
					<button class="btn-buy">Comprar</button>
				</div>
			</div>
		`;

		card.addEventListener("click", () => openModal(product));
		productGrid.appendChild(card);
	});
}

function renderHistory() {
	historyList.innerHTML = "";
	if (!history?.length) {
		historyList.innerHTML = '<div class="empty-state">🛒 Nenhuma compra ainda. Explore a loja!</div>';
		return;
	}
	history.forEach(item => {
		const el = document.createElement("div");
		el.className = "history-item";
		const date = item.created_at ? new Date(item.created_at).toLocaleString("pt-BR") : "";
		const emoji = TYPE_EMOJI[item.product_type] || "📋";
		el.innerHTML = `
			<div class="history-icon">${emoji}</div>
			<div class="history-info">
				<h4>${item.product_name || item.product_id}</h4>
				<span>${TYPE_LABELS[item.product_type] || item.product_type} • ${date}</span>
			</div>
			<span class="history-price">💎 ${formatGems(item.price)}</span>
		`;
		historyList.appendChild(el);
	});
}

function openModal(product) {
	selectedProduct = product;
	const img = getProductImage(product);
	document.getElementById("modal-image").src = img;
	document.getElementById("modal-title").textContent = "Confirmar Compra";
	document.getElementById("modal-product-name").textContent = product.name;
	document.getElementById("modal-product-desc").textContent = product.description || "";
	document.getElementById("modal-type-badge").textContent =
		`${TYPE_EMOJI[product.type] || ""} ${TYPE_LABELS[product.type] || product.type}`;

	const list = document.getElementById("modal-benefits");
	list.innerHTML = "";
	if (product.benefits?.length) {
		product.benefits.forEach(b => {
			const li = document.createElement("li");
			li.innerHTML = `<span>✓</span>${b}`;
			list.appendChild(li);
		});
		list.classList.remove("hidden");
	} else {
		list.classList.add("hidden");
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

	if (result?.success) {
		showToast(result.message || "Compra realizada! 🎉", "success");
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

document.getElementById("btn-close").addEventListener("click", closeApp);
document.getElementById("modal-close").addEventListener("click", closeModal);
document.getElementById("modal-cancel").addEventListener("click", closeModal);
document.getElementById("modal-confirm").addEventListener("click", confirmPurchase);
document.querySelector(".history-btn").addEventListener("click", showHistory);
searchInput.addEventListener("input", renderProducts);

document.addEventListener("keydown", (e) => {
	if (e.key === "Escape") {
		if (!modalOverlay.classList.contains("hidden")) closeModal();
		else if (!app.classList.contains("hidden")) closeApp();
	}
});

modalOverlay.addEventListener("click", (e) => {
	if (e.target === modalOverlay) closeModal();
});

window.addEventListener("message", (event) => {
	const data = event.data;
	if (!data?.action) return;
	switch (data.action) {
		case "open": openShop(data); break;
		case "close": app.classList.add("hidden"); closeModal(); break;
		case "updateBalance": updateBalance(data.balance); break;
		case "refresh":
			if (data.catalog) catalog = data.catalog;
			if (data.player) { player = data.player; updatePlayer(player); }
			if (data.history) history = data.history;
			currentView === "history" ? renderHistory() : renderProducts();
			break;
	}
});
