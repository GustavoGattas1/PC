const state = {
  view: 'landing',
  platform: 'all',
  query: '',
  sort: 'year-desc',
  selected: null,
};

const els = {
  views: {
    landing: document.getElementById('view-landing'),
    library: document.getElementById('view-library'),
  },
  filterList: document.getElementById('filter-list'),
  gamesGrid: document.getElementById('games-grid'),
  searchInput: document.getElementById('search-input'),
  sortSelect: document.getElementById('sort-select'),
  resultCount: document.getElementById('result-count'),
  modal: document.getElementById('game-modal'),
  modalTitle: document.getElementById('modal-title'),
  modalHero: document.getElementById('modal-hero'),
  modalMeta: document.getElementById('modal-meta'),
  modalPlayer: document.getElementById('modal-player'),
  toggleFilters: document.getElementById('toggle-filters'),
};

function setView(view) {
  state.view = view;
  Object.entries(els.views).forEach(([key, node]) => {
    node.classList.toggle('active', key === view);
  });
  history.replaceState(null, '', view === 'library' ? '#biblioteca' : '#inicio');
  if (view === 'library') renderLibrary();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function filteredGames() {
  let list = [...GAMES];
  if (state.platform !== 'all') {
    list = list.filter((g) => g.platform === state.platform);
  }
  if (state.query.trim()) {
    const q = state.query.trim().toLowerCase();
    list = list.filter(
      (g) =>
        g.title.toLowerCase().includes(q) ||
        g.genre.toLowerCase().includes(q) ||
        platformLabel(g.platform).toLowerCase().includes(q)
    );
  }
  list.sort((a, b) => {
    if (state.sort === 'year-desc') return b.year - a.year || a.title.localeCompare(b.title);
    if (state.sort === 'year-asc') return a.year - b.year || a.title.localeCompare(b.title);
    if (state.sort === 'title') return a.title.localeCompare(b.title);
    return 0;
  });
  return list;
}

function renderFilters() {
  const counts = Object.fromEntries(PLATFORMS.map((p) => [p.id, 0]));
  counts.all = GAMES.length;
  GAMES.forEach((g) => {
    counts[g.platform] = (counts[g.platform] || 0) + 1;
  });

  els.filterList.innerHTML = PLATFORMS.map(
    (p) => `
    <button class="filter-btn ${state.platform === p.id ? 'active' : ''}" data-platform="${p.id}" type="button">
      <span>${p.label}</span>
      <span class="count">${counts[p.id] || 0}</span>
    </button>`
  ).join('');
}

function renderLibrary() {
  renderFilters();
  const games = filteredGames();
  els.resultCount.textContent = `${games.length} jogos`;

  if (!games.length) {
    els.gamesGrid.innerHTML = `<div class="empty">Nenhum jogo encontrado com esses filtros.</div>`;
    return;
  }

  els.gamesGrid.innerHTML = games
    .map((game, index) => {
      const family = platformFamily(game.platform);
      return `
      <button class="game-card" type="button" data-id="${game.id}" style="animation-delay:${Math.min(index, 20) * 20}ms">
        <div class="game-cover">
          <div class="game-cover-art" style="background:${coverGradient(game)}">${game.title}</div>
          <span class="game-badge ${family}">${platformLabel(game.platform)}</span>
        </div>
        <div class="game-info">
          <h4>${game.title}</h4>
          <p>${game.year} · ${game.genre}</p>
        </div>
      </button>`;
    })
    .join('');
}

function openGame(id) {
  const game = GAMES.find((g) => g.id === id);
  if (!game) return;
  state.selected = game;
  els.modalTitle.textContent = game.title;
  els.modalHero.style.background = `${coverGradient(game)}, #0b1522`;
  els.modalMeta.innerHTML = `
    <span class="pill">${platformLabel(game.platform)}</span>
    <span class="pill">${game.year}</span>
    <span class="pill">${game.genre}</span>`;
  els.modalPlayer.innerHTML = `
    <div>
      <strong>${game.title}</strong>
      Sessão demo do launcher — sem ROMs nem binários.
      <br>Use este shell para navegar o catálogo e simular save/load.
    </div>`;
  els.modal.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeModal() {
  els.modal.classList.remove('open');
  document.body.style.overflow = '';
  state.selected = null;
}

function simulateAction(kind) {
  const title = state.selected?.title || 'Jogo';
  const messages = {
    play: `Iniciando sessão demo de “${title}”…`,
    save: `Save state criado para “${title}”.`,
    load: `Save state carregado para “${title}”.`,
  };
  const box = els.modalPlayer.querySelector('div') || els.modalPlayer;
  const note = document.createElement('p');
  note.style.marginTop = '0.85rem';
  note.style.color = 'var(--brand)';
  note.textContent = messages[kind] || 'Ação simulada.';
  box.appendChild(note);
  setTimeout(() => note.remove(), 2200);
}

function bindEvents() {
  document.querySelectorAll('[data-nav]').forEach((btn) => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      setView(btn.dataset.nav);
    });
  });

  els.filterList.addEventListener('click', (e) => {
    const btn = e.target.closest('[data-platform]');
    if (!btn) return;
    state.platform = btn.dataset.platform;
    renderLibrary();
  });

  els.gamesGrid.addEventListener('click', (e) => {
    const card = e.target.closest('[data-id]');
    if (!card) return;
    openGame(card.dataset.id);
  });

  els.searchInput.addEventListener('input', (e) => {
    state.query = e.target.value;
    renderLibrary();
  });

  els.sortSelect.addEventListener('change', (e) => {
    state.sort = e.target.value;
    renderLibrary();
  });

  document.getElementById('close-modal').addEventListener('click', closeModal);
  els.modal.addEventListener('click', (e) => {
    if (e.target === els.modal) closeModal();
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeModal();
  });

  document.getElementById('btn-play').addEventListener('click', () => simulateAction('play'));
  document.getElementById('btn-save').addEventListener('click', () => simulateAction('save'));
  document.getElementById('btn-load').addEventListener('click', () => simulateAction('load'));

  els.toggleFilters?.addEventListener('click', () => {
    els.filterList.classList.toggle('collapsed');
  });
}

function boot() {
  bindEvents();
  const hash = location.hash.replace('#', '');
  setView(hash === 'biblioteca' ? 'library' : 'landing');
}

boot();
