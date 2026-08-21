(function () {
  var DEMO_EMAIL = "admin@keusemijoias.com.br";
  var DEMO_PASS = "keu123";

  var SEED_ORDERS = [
    {
      id: "KEU-1042",
      name: "Mariana Souza",
      email: "mariana@email.com",
      total: 379.8,
      status: "pago",
      items: "Colar Aurora + Brinco Estrela",
      date: "21/08/2026",
    },
    {
      id: "KEU-1041",
      name: "Camila Ribeiro",
      email: "camila@email.com",
      total: 329.9,
      status: "enviado",
      items: "Conjunto Harmonia",
      date: "20/08/2026",
    },
    {
      id: "KEU-1040",
      name: "Ana Paula Mendes",
      email: "ana@email.com",
      total: 219.9,
      status: "entregue",
      items: "Anel Solitário · 16",
      date: "18/08/2026",
    },
    {
      id: "KEU-1039",
      name: "Beatriz Lima",
      email: "bia@email.com",
      total: 149.9,
      status: "novo",
      items: "Pulseira Elo",
      date: "21/08/2026",
    },
  ];

  var SEED_CUSTOMERS = [
    { name: "Mariana Souza", email: "mariana@email.com", orders: 3, spent: 729.7 },
    { name: "Camila Ribeiro", email: "camila@email.com", orders: 2, spent: 509.8 },
    { name: "Ana Paula Mendes", email: "ana@email.com", orders: 1, spent: 219.9 },
    { name: "Beatriz Lima", email: "bia@email.com", orders: 1, spent: 149.9 },
  ];

  var SEED_MESSAGES = [
    {
      id: 1,
      name: "Juliana Costa",
      email: "juliana@email.com",
      subject: "Troca de numeração",
      message: "Comprei o Anel Infinito 16, mas preciso do 18. Vocês fazem troca?",
      createdAt: "2026-08-20T14:10:00",
      read: false,
    },
    {
      id: 2,
      name: "Fernanda Alves",
      email: "fernanda@email.com",
      subject: "Pedido para madrinhas",
      message: "Gostaria de 8 conjuntos Harmonia para madrinhas. Tem desconto para atacado?",
      createdAt: "2026-08-19T09:32:00",
      read: true,
    },
  ];

  function qs(sel, root) {
    return (root || document).querySelector(sel);
  }

  function qsa(sel, root) {
    return Array.prototype.slice.call((root || document).querySelectorAll(sel));
  }

  function toast(msg) {
    var el = qs("#toast");
    el.textContent = msg;
    el.classList.add("is-on");
    clearTimeout(toast._t);
    toast._t = setTimeout(function () {
      el.classList.remove("is-on");
    }, 2200);
  }

  function orders() {
    try {
      var saved = JSON.parse(localStorage.getItem(KEU.ORDERS_KEY) || "null");
      if (saved && saved.length) return saved;
    } catch (e) {}
    localStorage.setItem(KEU.ORDERS_KEY, JSON.stringify(SEED_ORDERS));
    return SEED_ORDERS.slice();
  }

  function saveOrders(list) {
    localStorage.setItem(KEU.ORDERS_KEY, JSON.stringify(list));
  }

  function messages() {
    try {
      var saved = JSON.parse(localStorage.getItem(KEU.MESSAGES_KEY) || "null");
      if (saved && saved.length) return saved;
    } catch (e) {}
    localStorage.setItem(KEU.MESSAGES_KEY, JSON.stringify(SEED_MESSAGES));
    return SEED_MESSAGES.slice();
  }

  function isAuth() {
    return localStorage.getItem(KEU.AUTH_KEY) === "1";
  }

  function showApp() {
    qs("#login-screen").style.display = "none";
    qs("#admin-shell").classList.add("is-on");
    render("dashboard");
  }

  function slugify(text) {
    return String(text || "")
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/(^-|-$)/g, "");
  }

  function statusLabel(s) {
    return (
      { novo: "Novo", pago: "Pago", enviado: "Enviado", entregue: "Entregue" }[s] || s
    );
  }

  function render(view) {
    qsa("#admin-nav button[data-view]").forEach(function (b) {
      b.classList.toggle("is-on", b.getAttribute("data-view") === view);
    });
    var main = qs("#admin-main");
    if (view === "dashboard") main.innerHTML = viewDashboard();
    if (view === "orders") main.innerHTML = viewOrders();
    if (view === "products") main.innerHTML = viewProducts();
    if (view === "collections") main.innerHTML = viewCollections();
    if (view === "customers") main.innerHTML = viewCustomers();
    if (view === "messages") main.innerHTML = viewMessages();
    if (view === "settings") main.innerHTML = viewSettings();
    bindView(view);
  }

  function viewDashboard() {
    var list = orders();
    var revenue = list.reduce(function (n, o) {
      return n + o.total;
    }, 0);
    var unread = messages().filter(function (m) {
      return !m.read;
    }).length;
    return (
      '<div class="admin-top"><div><p class="kicker">Visão geral</p><h2 class="section-title" style="font-size:2rem">Olá, Keu</h2></div><a class="btn btn-outline btn-sm" href="index.html" target="_blank">Ver loja</a></div>' +
      '<div class="kpi-grid">' +
      kpi("Pedidos", String(list.length)) +
      kpi("Faturamento", KEU.formatPrice(revenue)) +
      kpi("Produtos", String(KEU.products.length)) +
      kpi("Mensagens novas", String(unread)) +
      "</div>" +
      "<h3 class=\"font-display\" style=\"font-size:1.35rem;margin-bottom:1rem\">Últimos pedidos</h3>" +
      ordersTable(list.slice(0, 4))
    );
  }

  function kpi(label, value) {
    return '<div class="kpi"><span>' + label + "</span><strong>" + value + "</strong></div>";
  }

  function ordersTable(list) {
    return (
      '<div class="table-wrap"><table class="admin-table"><thead><tr><th>Pedido</th><th>Cliente</th><th>Itens</th><th>Total</th><th>Status</th><th></th></tr></thead><tbody>' +
      list
        .map(function (o) {
          return (
            "<tr><td>" +
            o.id +
            "</td><td>" +
            o.name +
            "<br><span style=\"color:var(--color-muted);font-size:12px\">" +
            o.date +
            "</span></td><td>" +
            o.items +
            "</td><td>" +
            KEU.formatPrice(o.total) +
            '</td><td><span class="status status-' +
            o.status +
            '">' +
            statusLabel(o.status) +
            '</span></td><td><select data-order-status="' +
            o.id +
            '">' +
            ["novo", "pago", "enviado", "entregue"]
              .map(function (s) {
                return (
                  '<option value="' +
                  s +
                  '"' +
                  (s === o.status ? " selected" : "") +
                  ">" +
                  statusLabel(s) +
                  "</option>"
                );
              })
              .join("") +
            "</select></td></tr>"
          );
        })
        .join("") +
      "</tbody></table></div>"
    );
  }

  function viewOrders() {
    return (
      '<div class="admin-top"><div><p class="kicker">Pedidos</p><h2 class="section-title" style="font-size:2rem">Vendas da loja</h2></div></div>' +
      ordersTable(orders())
    );
  }

  function viewProducts() {
    return (
      '<div class="admin-top"><div><p class="kicker">Catálogo</p><h2 class="section-title" style="font-size:2rem">Produtos</h2></div><button class="btn btn-primary btn-sm" type="button" id="new-product">Novo produto</button></div>' +
      '<div class="table-wrap"><table class="admin-table"><thead><tr><th></th><th>Peça</th><th>Coleção</th><th>Preço</th><th>Destaque</th><th></th></tr></thead><tbody>' +
      KEU.products
        .map(function (p) {
          var col = KEU.getCollection(p.collection);
          return (
            "<tr><td><img alt=\"\" src=\"" +
            p.image +
            '"/></td><td>' +
            p.name +
            "</td><td>" +
            (col ? col.name : p.collection) +
            "</td><td>" +
            KEU.formatPrice(p.price) +
            "</td><td>" +
            (p.featured ? "Sim" : "—") +
            '</td><td class="admin-actions"><button class="linkish" data-edit="' +
            p.slug +
            '">Editar</button><button class="linkish danger" data-del="' +
            p.slug +
            '">Excluir</button></td></tr>'
          );
        })
        .join("") +
      "</tbody></table></div><div id=\"product-form-wrap\"></div>"
    );
  }

  function productForm(p) {
    var empty = {
      slug: "",
      name: "",
      collection: KEU.collections[0].slug,
      scent: "",
      price: 99.9,
      compareAt: null,
      image: "",
      images: [],
      featured: false,
      isNew: true,
      isExclusive: false,
      weight: "",
      description: "",
      longDescription: "",
      optionsLabel: "Acabamento",
      options: ["Ouro 18k"],
      highlights: ["Banho de ouro 18k", "Hipoalergênico"],
    };
    p = p || empty;
    return (
      '<form class="admin-form" id="product-form" data-slug="' +
      p.slug +
      '"><h3 class="font-display" style="font-size:1.3rem">' +
      (p.slug ? "Editar peça" : "Nova peça") +
      "</h3>" +
      '<div class="two"><div><label>Nome</label><input class="field-input" name="name" required value="' +
      escapeAttr(p.name) +
      '"/></div><div><label>Coleção</label><select class="field-input" name="collection">' +
      KEU.collections
        .map(function (c) {
          return (
            '<option value="' +
            c.slug +
            '"' +
            (c.slug === p.collection ? " selected" : "") +
            ">" +
            c.name +
            "</option>"
          );
        })
        .join("") +
      '</select></div></div>' +
      '<div class="two"><div><label>Preço (R$)</label><input class="field-input" name="price" type="number" step="0.01" required value="' +
      p.price +
      '"/></div><div><label>Detalhe (banho, pedra…)</label><input class="field-input" name="scent" value="' +
      escapeAttr(p.scent) +
      '"/></div></div>' +
      '<div><label>URL da imagem</label><input class="field-input" name="image" value="' +
      escapeAttr(p.image) +
      '"/></div>' +
      '<div><label>Descrição curta</label><textarea class="field-input" name="description">' +
      escapeHtml(p.description || "") +
      "</textarea></div>" +
      '<div><label>Opções (separadas por vírgula)</label><input class="field-input" name="options" value="' +
      escapeAttr((p.options || []).join(", ")) +
      '"/></div>' +
      '<div class="check-row"><label><input type="checkbox" name="featured"' +
      (p.featured ? " checked" : "") +
      "/> Destaque</label><label><input type=\"checkbox\" name=\"isNew\"" +
      (p.isNew ? " checked" : "") +
      "/> Novo</label><label><input type=\"checkbox\" name=\"isExclusive\"" +
      (p.isExclusive ? " checked" : "") +
      "/> Exclusivo</label></div>" +
      '<div style="display:flex;gap:.6rem"><button class="btn btn-primary" type="submit">Salvar</button><button class="btn btn-outline" type="button" id="cancel-form">Cancelar</button></div></form>'
    );
  }

  function viewCollections() {
    return (
      '<div class="admin-top"><div><p class="kicker">Coleções</p><h2 class="section-title" style="font-size:2rem">Linhas da loja</h2></div></div>' +
      '<div class="table-wrap"><table class="admin-table"><thead><tr><th></th><th>Nome</th><th>Peças</th><th>Descrição</th></tr></thead><tbody>' +
      KEU.collections
        .map(function (c) {
          return (
            "<tr><td><img alt=\"\" src=\"" +
            c.image +
            '"/></td><td>' +
            c.name +
            "</td><td>" +
            KEU.productsByCollection(c.slug).length +
            "</td><td>" +
            c.description +
            "</td></tr>"
          );
        })
        .join("") +
      "</tbody></table></div>" +
      '<form class="admin-form" id="collection-form"><h3 class="font-display" style="font-size:1.3rem">Nova coleção</h3>' +
      '<div class="two"><div><label>Nome</label><input class="field-input" name="name" required/></div><div><label>URL da imagem</label><input class="field-input" name="image"/></div></div>' +
      '<div><label>Descrição</label><input class="field-input" name="description"/></div>' +
      '<button class="btn btn-primary" type="submit">Adicionar coleção</button></form>'
    );
  }

  function viewCustomers() {
    return (
      '<div class="admin-top"><div><p class="kicker">Clientes</p><h2 class="section-title" style="font-size:2rem">Quem compra na Keu</h2></div></div>' +
      '<div class="table-wrap"><table class="admin-table"><thead><tr><th>Nome</th><th>E-mail</th><th>Pedidos</th><th>Total</th></tr></thead><tbody>' +
      SEED_CUSTOMERS.map(function (c) {
        return (
          "<tr><td>" +
          c.name +
          "</td><td>" +
          c.email +
          "</td><td>" +
          c.orders +
          "</td><td>" +
          KEU.formatPrice(c.spent) +
          "</td></tr>"
        );
      }).join("") +
      "</tbody></table></div>"
    );
  }

  function viewMessages() {
    return (
      '<div class="admin-top"><div><p class="kicker">Contato</p><h2 class="section-title" style="font-size:2rem">Mensagens</h2></div></div>' +
      messages()
        .map(function (m) {
          return (
            '<article class="review" style="margin-bottom:1rem"><strong>' +
            escapeHtml(m.name) +
            "</strong> · " +
            escapeHtml(m.email) +
            "<p style=\"margin:.6rem 0 .4rem;font-style:normal;font-weight:500\">" +
            escapeHtml(m.subject) +
            "</p><p style=\"margin:0\">" +
            escapeHtml(m.message) +
            "</p></article>"
          );
        })
        .join("")
    );
  }

  function viewSettings() {
    var b = KEU.brand;
    var h = KEU.hero;
    return (
      '<div class="admin-top"><div><p class="kicker">Aparência</p><h2 class="section-title" style="font-size:2rem">Conteúdo da loja</h2></div></div>' +
      '<form class="admin-form" id="settings-form">' +
      '<div class="two"><div><label>Nome da marca</label><input class="field-input" name="name" value="' +
      escapeAttr(b.name) +
      '"/></div><div><label>Instagram</label><input class="field-input" name="instagram" value="' +
      escapeAttr(b.instagram) +
      '"/></div></div>' +
      '<div class="two"><div><label>E-mail</label><input class="field-input" name="email" value="' +
      escapeAttr(b.email) +
      '"/></div><div><label>WhatsApp</label><input class="field-input" name="whatsapp" value="' +
      escapeAttr(b.whatsapp) +
      '"/></div></div>' +
      '<div><label>Título do hero</label><input class="field-input" name="heroTitle" value="' +
      escapeAttr(h.title) +
      '"/></div>' +
      '<div><label>Subtítulo do hero</label><textarea class="field-input" name="heroSubtitle">' +
      escapeHtml(h.subtitle) +
      "</textarea></div>" +
      '<div><label>Missão / rodapé</label><textarea class="field-input" name="mission">' +
      escapeHtml(b.mission) +
      "</textarea></div>" +
      '<button class="btn btn-primary" type="submit">Salvar aparência</button></form>'
    );
  }

  function escapeAttr(s) {
    return String(s || "")
      .replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/</g, "&lt;");
  }

  function escapeHtml(s) {
    return String(s || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }

  function bindView(view) {
    qsa("[data-order-status]").forEach(function (sel) {
      sel.addEventListener("change", function () {
        var list = orders();
        var id = sel.getAttribute("data-order-status");
        list.forEach(function (o) {
          if (o.id === id) o.status = sel.value;
        });
        saveOrders(list);
        toast("Status do pedido atualizado");
        render(view);
      });
    });

    if (view === "products") {
      qs("#new-product").addEventListener("click", function () {
        qs("#product-form-wrap").innerHTML = productForm(null);
        bindProductForm();
      });
      qsa("[data-edit]").forEach(function (b) {
        b.addEventListener("click", function () {
          qs("#product-form-wrap").innerHTML = productForm(
            KEU.getProduct(b.getAttribute("data-edit"))
          );
          bindProductForm();
          qs("#product-form").scrollIntoView({ behavior: "smooth" });
        });
      });
      qsa("[data-del]").forEach(function (b) {
        b.addEventListener("click", function () {
          var slug = b.getAttribute("data-del");
          if (!confirm("Excluir esta peça do catálogo?")) return;
          KEU.products = KEU.products.filter(function (p) {
            return p.slug !== slug;
          });
          KEU.saveCatalog();
          toast("Produto removido");
          render("products");
        });
      });
    }

    if (view === "collections") {
      qs("#collection-form").addEventListener("submit", function (e) {
        e.preventDefault();
        var fd = new FormData(e.target);
        var name = String(fd.get("name") || "").trim();
        KEU.collections.push({
          slug: slugify(name),
          name: name,
          description: String(fd.get("description") || ""),
          image:
            String(fd.get("image") || "").trim() ||
            "https://images.unsplash.com/photo-1515562148047-bd4d0b5c0e8e?auto=format&fit=crop&w=900&q=80",
        });
        KEU.saveCatalog();
        toast("Coleção criada");
        render("collections");
      });
    }

    if (view === "settings") {
      qs("#settings-form").addEventListener("submit", function (e) {
        e.preventDefault();
        var fd = new FormData(e.target);
        KEU.brand.name = String(fd.get("name") || KEU.brand.name);
        KEU.brand.instagram = String(fd.get("instagram") || KEU.brand.instagram);
        KEU.brand.email = String(fd.get("email") || KEU.brand.email);
        KEU.brand.whatsapp = String(fd.get("whatsapp") || KEU.brand.whatsapp);
        KEU.brand.mission = String(fd.get("mission") || KEU.brand.mission);
        KEU.hero.title = String(fd.get("heroTitle") || KEU.hero.title);
        KEU.hero.subtitle = String(fd.get("heroSubtitle") || KEU.hero.subtitle);
        KEU.saveSettings();
        toast("Aparência salva — atualize a loja para ver");
      });
    }
  }

  function bindProductForm() {
    var cancel = qs("#cancel-form");
    if (cancel)
      cancel.addEventListener("click", function () {
        qs("#product-form-wrap").innerHTML = "";
      });
    qs("#product-form").addEventListener("submit", function (e) {
      e.preventDefault();
      var fd = new FormData(e.target);
      var slug = e.target.getAttribute("data-slug") || slugify(fd.get("name"));
      var existing = KEU.getProduct(slug);
      var image =
        String(fd.get("image") || "").trim() ||
        (existing && existing.image) ||
        "https://images.unsplash.com/photo-1515562148047-bd4d0b5c0e8e?auto=format&fit=crop&w=900&q=80";
      var next = {
        slug: slug,
        name: String(fd.get("name")),
        collection: String(fd.get("collection")),
        scent: String(fd.get("scent") || ""),
        price: Number(fd.get("price")),
        compareAt: existing ? existing.compareAt : null,
        image: image,
        images: existing && existing.images && existing.images.length ? existing.images : [image],
        featured: qs('[name="featured"]').checked,
        isNew: qs('[name="isNew"]').checked,
        isExclusive: qs('[name="isExclusive"]').checked,
        weight: existing ? existing.weight : "—",
        description: String(fd.get("description") || ""),
        longDescription: existing ? existing.longDescription : String(fd.get("description") || ""),
        optionsLabel: existing ? existing.optionsLabel : "Acabamento",
        options: String(fd.get("options") || "Ouro 18k")
          .split(",")
          .map(function (s) {
            return s.trim();
          })
          .filter(Boolean),
        highlights: existing
          ? existing.highlights
          : ["Banho de ouro 18k", "Hipoalergênico", "Embalagem presenteável"],
      };
      if (existing) {
        KEU.products = KEU.products.map(function (p) {
          return p.slug === slug ? next : p;
        });
      } else {
        KEU.products.unshift(next);
      }
      KEU.saveCatalog();
      toast("Produto salvo");
      render("products");
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    if (isAuth()) showApp();
    qs("#login-form").addEventListener("submit", function (e) {
      e.preventDefault();
      var email = qs("#admin-email").value.trim().toLowerCase();
      var pass = qs("#admin-pass").value;
      if (email === DEMO_EMAIL && pass === DEMO_PASS) {
        localStorage.setItem(KEU.AUTH_KEY, "1");
        showApp();
      } else {
        qs("#login-error").style.display = "block";
      }
    });
    qs("#admin-nav").addEventListener("click", function (e) {
      var btn = e.target.closest("button[data-view]");
      if (btn) render(btn.getAttribute("data-view"));
    });
    qs("#logout").addEventListener("click", function () {
      localStorage.removeItem(KEU.AUTH_KEY);
      location.reload();
    });
  });
})();
