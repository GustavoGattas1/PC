(function () {
  var ICONS = {
    bag:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>',
    menu:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12h16"/><path d="M4 18h16"/><path d="M4 6h16"/></svg>',
    close:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>',
    heart:
      '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>',
    eye:
      '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/></svg>',
    star:
      '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"/></svg>',
    instagram:
      '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="20" x="2" y="2" rx="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/></svg>',
    mail:
      '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"/><rect x="2" y="4" width="20" height="16" rx="2"/></svg>',
    chat:
      '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M7.9 20A9 9 0 1 0 4 16.1L2 22Z"/></svg>',
    pin:
      '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg>',
    leaf:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z"/><path d="M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12"/></svg>',
    spark:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg>',
    shield:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20 13c0 5-3.5 7.5-8 10-4.5-2.5-8-5-8-10V6l8-3 8 3Z"/><path d="m9 12 2 2 4-4"/></svg>',
    truck:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><path d="M15 18H9"/><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/></svg>',
    chevron:
      '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>',
  };

  var CART_KEY = "keu-cart";
  var FAV_KEY = "keu-favs";

  function qs(sel, root) {
    return (root || document).querySelector(sel);
  }

  function qsa(sel, root) {
    return Array.prototype.slice.call((root || document).querySelectorAll(sel));
  }

  function param(name) {
    return new URLSearchParams(location.search).get(name);
  }

  function page() {
    return document.body.getAttribute("data-page") || "home";
  }

  function loadCart() {
    try {
      return JSON.parse(localStorage.getItem(CART_KEY) || "[]");
    } catch (e) {
      return [];
    }
  }

  function saveCart(cart) {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
    updateBadges();
    renderCart();
  }

  function loadFavs() {
    try {
      return JSON.parse(localStorage.getItem(FAV_KEY) || "[]");
    } catch (e) {
      return [];
    }
  }

  function saveFavs(favs) {
    localStorage.setItem(FAV_KEY, JSON.stringify(favs));
  }

  function cartCount() {
    return loadCart().reduce(function (n, i) {
      return n + i.qty;
    }, 0);
  }

  function cartTotal() {
    return loadCart().reduce(function (n, i) {
      return n + i.price * i.qty;
    }, 0);
  }

  function toast(msg) {
    var el = qs("#toast");
    if (!el) return;
    el.textContent = msg;
    el.classList.add("is-on");
    clearTimeout(toast._t);
    toast._t = setTimeout(function () {
      el.classList.remove("is-on");
    }, 2400);
  }

  function updateBadges() {
    var n = cartCount();
    qsa("[data-cart-badge]").forEach(function (el) {
      el.textContent = String(n);
      el.classList.toggle("has-items", n > 0);
    });
  }

  function addToCart(product, option, qty) {
    var cart = loadCart();
    var key = product.slug + "::" + (option || "");
    var found = cart.find(function (i) {
      return i.key === key;
    });
    if (found) found.qty += qty || 1;
    else
      cart.push({
        key: key,
        slug: product.slug,
        name: product.name,
        option: option || product.options[0],
        price: product.price,
        image: product.image,
        qty: qty || 1,
      });
    saveCart(cart);
    toast(product.name + " adicionada à sacola");
  }

  function toggleFav(slug) {
    var favs = loadFavs();
    var i = favs.indexOf(slug);
    if (i >= 0) favs.splice(i, 1);
    else favs.push(slug);
    saveFavs(favs);
    return favs.indexOf(slug) >= 0;
  }

  window.KeuApp = {
    addToCart: addToCart,
    toast: toast,
    openCart: function () {
      qs("#overlay").classList.add("is-open");
      qs("#drawer").classList.add("is-open");
    },
    closeCart: function () {
      qs("#overlay").classList.remove("is-open");
      qs("#drawer").classList.remove("is-open");
    },
    openQuick: openQuick,
  };

  function productCard(p) {
    var favs = loadFavs();
    var badges = "";
    if (p.isNew) badges += '<span class="badge badge-gold">Novo</span>';
    if (p.featured) badges += '<span class="badge badge-dark">Destaque</span>';
    if (p.isExclusive) badges += '<span class="badge badge-dark">Exclusivo</span>';
    var price =
      (p.compareAt
        ? '<span class="price-old">' + KEU.formatPrice(p.compareAt) + "</span>"
        : "") +
      "<span>" +
      KEU.formatPrice(p.price) +
      "</span>";
    return (
      '<article class="product-card group">' +
      '<div class="thumb">' +
      '<a href="produto.html?slug=' +
      p.slug +
      '"><img alt="' +
      p.name +
      '" src="' +
      p.image +
      '"/></a>' +
      '<div class="badges">' +
      badges +
      "</div>" +
      '<div class="card-actions">' +
      '<button type="button" data-fav="' +
      p.slug +
      '" class="' +
      (favs.indexOf(p.slug) >= 0 ? "is-on" : "") +
      '" aria-label="Favoritar">' +
      ICONS.heart +
      "</button>" +
      '<button type="button" data-quick="' +
      p.slug +
      '" aria-label="Visualização rápida">' +
      ICONS.eye +
      "</button>" +
      "</div>" +
      '<div class="quick-add"><button type="button" class="btn" data-add="' +
      p.slug +
      '">' +
      ICONS.bag +
      " Escolher opção</button></div>" +
      "</div>" +
      '<a class="block" href="produto.html?slug=' +
      p.slug +
      '">' +
      '<p class="product-meta">' +
      p.scent +
      "</p>" +
      "<h3>" +
      p.name +
      "</h3>" +
      '<div class="price">' +
      price +
      "</div>" +
      "</a></article>"
    );
  }

  function collectionCard(c) {
    var count = KEU.productsByCollection(c.slug).length;
    return (
      '<a class="collection-card" href="colecao.html?slug=' +
      c.slug +
      '">' +
      '<img alt="' +
      c.name +
      '" src="' +
      c.image +
      '"/>' +
      '<div class="shade"></div>' +
      '<div class="collection-body">' +
      '<p class="collection-count">' +
      count +
      " peças</p>" +
      "<h3>" +
      c.name +
      "</h3>" +
      "<p>" +
      c.description +
      "</p>" +
      '<span class="collection-cta">Explorar coleção →</span>' +
      "</div></a>"
    );
  }

  function bindProductGrid(root) {
    root.addEventListener("click", function (e) {
      var fav = e.target.closest("[data-fav]");
      var quick = e.target.closest("[data-quick]");
      var add = e.target.closest("[data-add]");
      if (fav) {
        e.preventDefault();
        var on = toggleFav(fav.getAttribute("data-fav"));
        fav.classList.toggle("is-on", on);
        toast(on ? "Adicionado aos favoritos" : "Removido dos favoritos");
      }
      if (quick) {
        e.preventDefault();
        openQuick(quick.getAttribute("data-quick"));
      }
      if (add) {
        e.preventDefault();
        var p = KEU.getProduct(add.getAttribute("data-add"));
        if (p) addToCart(p, p.options[0], 1);
      }
    });
  }

  function openQuick(slug) {
    var p = KEU.getProduct(slug);
    if (!p) return;
    var modal = qs("#quick-modal");
    modal.innerHTML =
      '<div class="overlay is-open" data-close-quick></div>' +
      '<div class="modal-card">' +
      '<button class="modal-close" type="button" data-close-quick>' +
      ICONS.close +
      "</button>" +
      '<img alt="' +
      p.name +
      '" src="' +
      p.image +
      '"/>' +
      '<div class="modal-body">' +
      '<p class="pdp-kicker">' +
      p.scent +
      "</p>" +
      "<h2 class=\"font-display\" style=\"font-size:1.75rem;font-weight:500;margin-bottom:.75rem\">" +
      p.name +
      "</h2>" +
      '<p class="pdp-price">' +
      KEU.formatPrice(p.price) +
      "</p>" +
      '<p class="pdp-desc">' +
      p.description +
      "</p>" +
      '<p class="options-label">' +
      p.optionsLabel +
      "</p>" +
      '<div class="options">' +
      p.options
        .map(function (o, i) {
          return (
            '<button type="button" class="opt' +
            (i === 0 ? " is-on" : "") +
            '" data-opt="' +
            o +
            '">' +
            o +
            "</button>"
          );
        })
        .join("") +
      "</div>" +
      '<button class="btn btn-primary btn-full" type="button" id="quick-add">Adicionar à sacola</button>' +
      '<p style="margin-top:1rem"><a class="link-gold" href="produto.html?slug=' +
      p.slug +
      '">Ver detalhes →</a></p>' +
      "</div></div>";
    modal.classList.add("is-open");
    var selected = p.options[0];
    modal.onclick = function (e) {
      if (e.target.closest("[data-close-quick]")) {
        modal.classList.remove("is-open");
        modal.innerHTML = "";
      }
      var opt = e.target.closest("[data-opt]");
      if (opt) {
        qsa(".opt", modal).forEach(function (b) {
          b.classList.remove("is-on");
        });
        opt.classList.add("is-on");
        selected = opt.getAttribute("data-opt");
      }
      if (e.target.id === "quick-add") {
        addToCart(p, selected, 1);
        modal.classList.remove("is-open");
        modal.innerHTML = "";
        KeuApp.openCart();
      }
    };
  }

  function renderHeader() {
    var brand = KEU.brand;
    var current = page();
    var solid = current !== "home";
    var nav = [
      ["index.html", "Início", "home"],
      ["colecoes.html", "Coleções", "colecoes"],
      ["conta.html", "Minha conta", "conta"],
      ["sobre.html", "Essência", "sobre"],
      ["contato.html", "Contato", "contato"],
    ];
    var links = nav
      .map(function (n) {
        return (
          '<a class="' +
          (n[2] === current ? "is-active" : "") +
          '" href="' +
          n[0] +
          '">' +
          n[1] +
          "</a>"
        );
      })
      .join("");

    qs("#site-header").innerHTML =
      '<header class="site-header' +
      (solid ? " is-solid" : "") +
      '" id="header">' +
      '<div class="demo-banner">Modelo de apresentação — Keu Semijoias</div>' +
      '<div class="container"><div class="header-inner">' +
      '<a class="logo" href="index.html"><span class="logo-main">' +
      brand.logoMain +
      '</span><span class="logo-sub">' +
      brand.logoSub +
      "</span></a>" +
      '<nav class="nav-desktop" aria-label="Principal">' +
      links +
      "</nav>" +
      '<div class="header-actions">' +
      '<button class="icon-btn" type="button" data-open-cart aria-label="Carrinho">' +
      ICONS.bag +
      '<span class="cart-badge" data-cart-badge>0</span></button>' +
      '<button class="icon-btn menu-toggle" type="button" id="menu-toggle" aria-label="Abrir menu">' +
      ICONS.menu +
      "</button></div></div></div>" +
      '<nav class="mobile-nav" id="mobile-nav">' +
      links +
      "</nav></header>";

    qs("#menu-toggle").addEventListener("click", function () {
      qs("#mobile-nav").classList.toggle("is-open");
    });
    qsa("[data-open-cart]").forEach(function (b) {
      b.addEventListener("click", KeuApp.openCart);
    });

    if (!solid) {
      window.addEventListener("scroll", function () {
        qs("#header").classList.toggle("is-scrolled", window.scrollY > 40);
      });
    }
  }

  function renderFooter() {
    var b = KEU.brand;
    qs("#site-footer").innerHTML =
      '<footer class="site-footer"><div class="container"><div class="footer-grid">' +
      '<div class="footer-brand"><a href="index.html"><span class="logo-main" style="color:var(--color-footer-text);font-size:1.5rem">' +
      b.logoMain +
      '</span><span class="logo-sub">' +
      b.logoSub +
      "</span></a><p>" +
      b.mission +
      "</p></div>" +
      '<div><h4 class="footer-title">Navegação</h4><ul class="footer-links">' +
      '<li><a href="colecoes.html">Coleções</a></li>' +
      '<li><a href="sobre.html">Nossa Essência</a></li>' +
      '<li><a href="conta.html">Minha conta</a></li>' +
      '<li><a href="contato.html">Contato</a></li></ul></div>' +
      '<div><h4 class="footer-title">Contato</h4><ul class="footer-links">' +
      '<li class="contact-row">' +
      ICONS.mail +
      " " +
      b.email +
      "</li>" +
      '<li><a class="contact-row" href="' +
      b.whatsappUrl +
      '" target="_blank" rel="noopener">' +
      ICONS.chat +
      " " +
      b.whatsapp +
      "</a></li>" +
      '<li><a class="contact-row" href="' +
      b.instagramUrl +
      '" target="_blank" rel="noopener">' +
      ICONS.instagram +
      " " +
      b.instagram +
      "</a></li>" +
      '<li class="contact-row">' +
      ICONS.pin +
      " Entrega: " +
      b.delivery +
      "</li></ul></div></div>" +
      '<div class="footer-bottom"><p>© 2026 ' +
      b.name +
      "</p><p>Pagamento seguro via Pix, cartão e boleto</p></div></div></footer>" +
      '<div class="overlay" id="overlay"></div>' +
      '<aside class="drawer" id="drawer" aria-label="Sacola">' +
      '<div class="drawer-head"><h2>Sacola</h2><button type="button" class="icon-btn" data-close-cart style="color:var(--color-heading)">' +
      ICONS.close +
      "</button></div>" +
      '<div class="drawer-body" id="cart-body"></div>' +
      '<div class="drawer-foot" id="cart-foot"></div></aside>' +
      '<div class="chat-wrap">' +
      '<div class="chat-panel" id="chat-panel"><header>Atendimento Keu</header>' +
      '<div class="msgs">Olá! Este é um modelo de apresentação. No site final, este chat conecta ao WhatsApp e ao e-mail da loja.</div>' +
      '<a class="btn btn-gold btn-sm wa" href="' +
      b.whatsappUrl +
      '" target="_blank" rel="noopener">Falar no WhatsApp</a></div>' +
      '<button type="button" class="chat-btn" id="chat-toggle">' +
      ICONS.chat +
      "<span>Chat</span></button></div>" +
      '<div class="toast" id="toast"></div>' +
      '<div class="modal" id="quick-modal"></div>';

    qs("#overlay").addEventListener("click", KeuApp.closeCart);
    qs("[data-close-cart]").addEventListener("click", KeuApp.closeCart);
    qs("#chat-toggle").addEventListener("click", function () {
      qs("#chat-panel").classList.toggle("is-open");
    });
    renderCart();
  }

  function renderCart() {
    var cart = loadCart();
    var body = qs("#cart-body");
    var foot = qs("#cart-foot");
    if (!body) return;
    if (!cart.length) {
      body.innerHTML =
        '<div class="cart-empty"><p>Sua sacola está vazia.</p><p style="margin-top:1rem"><a class="link-gold" href="colecoes.html">Explorar coleções →</a></p></div>';
      foot.innerHTML = "";
      return;
    }
    body.innerHTML = cart
      .map(function (i) {
        return (
          '<div class="cart-item">' +
          '<img alt="' +
          i.name +
          '" src="' +
          i.image +
          '"/>' +
          "<div><h3>" +
          i.name +
          '</h3><p class="meta">' +
          i.option +
          " · Qtd " +
          i.qty +
          "</p>" +
          '<button class="remove" data-remove="' +
          i.key +
          '">Remover</button></div>' +
          "<div>" +
          KEU.formatPrice(i.price * i.qty) +
          "</div></div>"
        );
      })
      .join("");
    foot.innerHTML =
      '<div class="total-row"><span>Total</span><strong>' +
      KEU.formatPrice(cartTotal()) +
      "</strong></div>" +
      '<button class="btn btn-primary btn-full" type="button" id="checkout-btn">Finalizar pedido</button>' +
      '<p style="font-size:11px;color:var(--color-muted);text-align:center;margin-top:.75rem">Pagamento simulado para apresentação</p>';
    body.onclick = function (e) {
      var rm = e.target.closest("[data-remove]");
      if (!rm) return;
      saveCart(
        loadCart().filter(function (i) {
          return i.key !== rm.getAttribute("data-remove");
        })
      );
    };
    qs("#checkout-btn").addEventListener("click", function () {
      saveCart([]);
      KeuApp.closeCart();
      toast("Pedido de demonstração registrado. Obrigada!");
    });
  }

  function renderHome() {
    var featured = KEU.products.filter(function (p) {
      return p.featured;
    });
    qs("#collections-grid").innerHTML = KEU.collections.map(collectionCard).join("");
    qs("#featured-grid").innerHTML = featured.map(productCard).join("");
    bindProductGrid(qs("#featured-grid"));
    qs("#values").innerHTML = KEU.brand.values
      .map(function (v) {
        return '<span class="value-chip">' + v + "</span>";
      })
      .join("");
    qs("#reviews").innerHTML = KEU.reviews
      .map(function (r) {
        return (
          "<blockquote class=\"review\"><div class=\"stars\">" +
          ICONS.star.repeat(5) +
          "</div><p>“" +
          r.text +
          "”</p><footer>" +
          r.name +
          "</footer></blockquote>"
        );
      })
      .join("");
    qs("#instagram").innerHTML = KEU.instagram
      .map(function (src, i) {
        return (
          '<a class="ig-tile" href="' +
          KEU.brand.instagramUrl +
          '" target="_blank" rel="noopener"><img alt="Keu no Instagram ' +
          (i + 1) +
          '" src="' +
          src +
          '"/></a>'
        );
      })
      .join("");
  }

  function renderColecoes() {
    qs("#collections-grid").innerHTML = KEU.collections.map(collectionCard).join("");
    var grid = qs("#all-products");
    var list = KEU.products.slice();
    function paint(filter) {
      var items = filter === "all" ? list : list.filter(function (p) {
        return p.collection === filter;
      });
      grid.innerHTML = items.map(productCard).join("");
    }
    paint("all");
    bindProductGrid(grid);
    qsa("[data-filter]").forEach(function (btn) {
      btn.addEventListener("click", function () {
        qsa("[data-filter]").forEach(function (b) {
          b.classList.remove("is-on");
        });
        btn.classList.add("is-on");
        paint(btn.getAttribute("data-filter"));
      });
    });
  }

  function renderColecao() {
    var slug = param("slug");
    var col = KEU.getCollection(slug);
    if (!col) {
      location.href = "colecoes.html";
      return;
    }
    qs("#col-title").textContent = col.name;
    qs("#col-desc").textContent = col.description;
    var items = KEU.productsByCollection(slug);
    qs("#col-count").textContent = items.length + " peças";
    var grid = qs("#col-products");
    grid.innerHTML = items.map(productCard).join("");
    bindProductGrid(grid);
  }

  function renderProduto() {
    var p = KEU.getProduct(param("slug"));
    if (!p) {
      location.href = "colecoes.html";
      return;
    }
    document.title = p.name + " | Keu Semijoias";
    var selected = p.options[0];
    var qty = 1;
    var img = p.images[0];
    function paint() {
      qs("#pdp").innerHTML =
        '<div><div class="pdp-gallery"><img id="pdp-img" alt="' +
        p.name +
        '" src="' +
        img +
        '"/></div>' +
        '<div class="thumbs">' +
        p.images
          .map(function (src, i) {
            return (
              '<button type="button" class="' +
              (src === img ? "is-on" : "") +
              '" data-img="' +
              src +
              '"><img alt="" src="' +
              src +
              '"/></button>'
            );
          })
          .join("") +
        "</div></div>" +
        "<div>" +
        (p.featured ? '<span class="badge badge-dark" style="margin-bottom:1rem">Destaque</span>' : "") +
        (p.isNew ? ' <span class="badge badge-gold">Novo</span>' : "") +
        '<p class="pdp-kicker" style="margin-top:1rem">' +
        p.scent +
        "</p>" +
        "<h1>" +
        p.name +
        "</h1>" +
        '<p class="pdp-desc">Escolha o ' +
        p.optionsLabel.toLowerCase() +
        " abaixo ao adicionar à sacola.</p>" +
        '<p class="pdp-price">' +
        (p.compareAt
          ? '<span class="price-old">' + KEU.formatPrice(p.compareAt) + "</span> "
          : "") +
        KEU.formatPrice(p.price) +
        "</p>" +
        "<p class=\"pdp-desc\">" +
        p.longDescription +
        "</p>" +
        '<div class="specs"><div><strong>Peso</strong>' +
        p.weight +
        "</div><div><strong>Disponibilidade</strong>Disponível</div></div>" +
        '<p class="options-label">Escolha ' +
        p.optionsLabel.toLowerCase() +
        "</p>" +
        '<div class="options">' +
        p.options
          .map(function (o) {
            return (
              '<button type="button" class="opt' +
              (o === selected ? " is-on" : "") +
              '" data-opt="' +
              o +
              '">' +
              o +
              "</button>"
            );
          })
          .join("") +
        "</div>" +
        '<div class="qty-row"><div class="qty"><button type="button" data-qty="-1">−</button><span>' +
        qty +
        '</span><button type="button" data-qty="1">+</button></div>' +
        '<button class="btn btn-primary" type="button" id="add-pdp" style="flex:1">Adicionar à sacola</button></div>' +
        '<ul class="highlights">' +
        p.highlights
          .map(function (h) {
            return "<li>" + h + "</li>";
          })
          .join("") +
        "</ul></div>";
    }
    paint();
    qs("#pdp").addEventListener("click", function (e) {
      if (e.target.closest("#add-pdp")) {
        addToCart(p, selected, qty);
        KeuApp.openCart();
        return;
      }
      var t = e.target.closest("[data-img]");
      var o = e.target.closest("[data-opt]");
      var q = e.target.closest("[data-qty]");
      if (t) {
        img = t.getAttribute("data-img");
        paint();
      }
      if (o) {
        selected = o.getAttribute("data-opt");
        paint();
      }
      if (q) {
        qty = Math.max(1, qty + Number(q.getAttribute("data-qty")));
        paint();
      }
    });
    var related = KEU.products
      .filter(function (x) {
        return x.collection === p.collection && x.slug !== p.slug;
      })
      .slice(0, 4);
    if (related.length) {
      qs("#related-grid").innerHTML = related.map(productCard).join("");
      bindProductGrid(qs("#related-grid"));
    }
  }

  function bindForms() {
    qsa("[data-newsletter]").forEach(function (form) {
      form.addEventListener("submit", function (e) {
        e.preventDefault();
        toast("Obrigada por se juntar à nossa comunidade.");
        form.reset();
      });
    });
    qsa("[data-contact]").forEach(function (form) {
      form.addEventListener("submit", function (e) {
        e.preventDefault();
        qs("#contact-ok").classList.add("is-on");
        form.reset();
      });
    });
    qsa("[data-account]").forEach(function (form) {
      form.addEventListener("submit", function (e) {
        e.preventDefault();
        toast("Acesso de demonstração confirmado.");
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    renderHeader();
    renderFooter();
    updateBadges();
    bindForms();
    var p = page();
    if (p === "home") renderHome();
    if (p === "colecoes") renderColecoes();
    if (p === "colecao") renderColecao();
    if (p === "produto") renderProduto();
  });
})();
