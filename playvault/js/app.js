const state = {
  view: 'landing',
  platform: 'all',
  query: '',
  sort: 'year-desc',
  selected: null,
  onlyOwned: false,
  localGames: [],
  status: null,
  launcherOnline: false,
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
  launcherBadge: document.getElementById('launcher-badge'),
  ownedToggle: document.getElementById('owned-toggle'),
  refreshLibrary: document.getElementById('refresh-library'),
  platformCount: document.getElementById('platform-count'),
};

function normalizeTitle(t) {
  return String(t || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '');
}

function allGames() {
  const curated = (typeof CURATED_GAMES !== 'undefined' ? CURATED_GAMES : []).map((g) => ({
    ...g,
    source: 'curated',
    hasRom: false,
    file: null,
  }));

  const byKey = new Map();
  curated.forEach((g) => {
    byKey.set(`${g.platform}::${normalizeTitle(g.title)}`, g);
  });

  state.localGames.forEach((local) => {
    const key = `${local.platform}::${normalizeTitle(local.title)}`;
    const existing = byKey.get(key);
    if (existing) {
      existing.hasRom = true;
      existing.file = local.file;
      existing.filename = local.filename;
      existing.source = 'curated+disk';
    } else {
      byKey.set(key, { ...local });
    }
  });

  return Array.from(byKey.values());
}

async function refreshLauncher() {
  try {
    const statusRes = await fetch('/api/status');
    if (!statusRes.ok) throw new Error('offline');
    state.status = await statusRes.json();
    state.launcherOnline = true;

    const libRes = await fetch('/api/library');
    const lib = await libRes.json();
    state.localGames = lib.games || [];
  } catch {
    state.launcherOnline = false;
    state.status = null;
    state.localGames = [];
  }
  updateLauncherBadge();
  if (state.view === 'library') renderLibrary();
}

function updateLauncherBadge() {
  if (!els.launcherBadge) return;
  if (state.launcherOnline) {
    const n = state.status?.rom_count || 0;
    els.launcherBadge.textContent = `Launcher online · ${n} ROMs no disco`;
    els.launcherBadge.className = 'launcher-badge on';
  } else {
    els.launcherBadge.textContent = 'UI only · rode python3 launcher/server.py';
    els.launcherBadge.className = 'launcher-badge';
  }
}

function setView(view) {
  state.view = view;
  Object.entries(els.views).forEach(([key, node]) => {
    node?.classList.toggle('active', key === view);
  });
  history.replaceState(null, '', view === 'library' ? '#biblioteca' : '#inicio');
  if (view === 'library') renderLibrary();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function filteredGames() {
  let list = allGames();
  if (state.platform !== 'all') {
    list = list.filter((g) => g.platform === state.platform);
  }
  if (state.onlyOwned) {
    list = list.filter((g) => g.hasRom);
  }
  if (state.query.trim()) {
    const q = state.query.trim().toLowerCase();
    list = list.filter(
      (g) =>
        g.title.toLowerCase().includes(q) ||
        (g.genre || '').toLowerCase().includes(q) ||
        platformLabel(g.platform).toLowerCase().includes(q)
    );
  }
  list.sort((a, b) => {
    if (state.sort === 'owned') return Number(b.hasRom) - Number(a.hasRom) || a.title.localeCompare(b.title);
    if (state.sort === 'year-desc') return (b.year || 0) - (a.year || 0) || a.title.localeCompare(b.title);
    if (state.sort === 'year-asc') return (a.year || 0) - (b.year || 0) || a.title.localeCompare(b.title);
    if (state.sort === 'title') return a.title.localeCompare(b.title);
    return 0;
  });
  return list;
}

function renderFilters() {
  const games = allGames();
  const counts = Object.fromEntries(PLATFORMS.map((p) => [p.id, 0]));
  counts.all = games.length;
  games.forEach((g) => {
    counts[g.platform] = (counts[g.platform] || 0) + 1;
  });

  const groups = [];
  let current = null;
  PLATFORMS.forEach((p) => {
    if (p.id === 'all') {
      groups.push({ type: 'item', platform: p });
      return;
    }
    if (!current || current.name !== p.group) {
      current = { type: 'group', name: p.group, items: [] };
      groups.push(current);
    }
    current.items.push(p);
  });

  els.filterList.innerHTML = groups
    .map((g) => {
      if (g.type === 'item') {
        const p = g.platform;
        return `<button class="filter-btn ${state.platform === p.id ? 'active' : ''}" data-platform="${p.id}" type="button">
          <span>${p.label}</span><span class="count">${counts[p.id] || 0}</span>
        </button>`;
      }
      const items = g.items
        .map(
          (p) => `<button class="filter-btn ${state.platform === p.id ? 'active' : ''}" data-platform="${p.id}" type="button">
            <span>${p.label}</span><span class="count">${counts[p.id] || 0}</span>
          </button>`
        )
        .join('');
      return `<div class="filter-group"><h3>${g.name}</h3>${items}</div>`;
    })
    .join('');

  if (els.platformCount) {
    els.platformCount.textContent = `${PLATFORMS.length - 1} consoles · ${games.length} jogos`;
  }
}

function renderLibrary() {
  renderFilters();
  const games = filteredGames();
  const owned = games.filter((g) => g.hasRom).length;
  els.resultCount.textContent = `${games.length} jogos${owned ? ` · ${owned} com ROM` : ''}`;

  if (!games.length) {
    els.gamesGrid.innerHTML = `<div class="empty">Nenhum jogo encontrado. Ajuste filtros ou coloque ROMs em <code>roms/&lt;plataforma&gt;/</code>.</div>`;
    return;
  }

  els.gamesGrid.innerHTML = games
    .map((game, index) => {
      const family = platformFamily(game.platform);
      return `
      <button class="game-card" type="button" data-id="${game.id}" style="animation-delay:${Math.min(index, 24) * 16}ms">
        <div class="game-cover">
          <div class="game-cover-art" style="background:${coverGradient(game)}">${game.title}</div>
          <span class="game-badge ${family}">${platformLabel(game.platform)}</span>
          ${game.hasRom ? '<span class="rom-dot" title="ROM no disco">ROM</span>' : ''}
        </div>
        <div class="game-info">
          <h4>${game.title}</h4>
          <p>${game.year || '—'} · ${game.genre || '—'}</p>
        </div>
      </button>`;
    })
    .join('');
}

function findGame(id) {
  return allGames().find((g) => g.id === id);
}

function openGame(id) {
  const game = findGame(id);
  if (!game) return;
  state.selected = game;
  const plat = platformById(game.platform);
  els.modalTitle.textContent = game.title;
  els.modalHero.style.background = `${coverGradient(game)}, #0b1522`;
  els.modalMeta.innerHTML = `
    <span class="pill">${platformLabel(game.platform)}</span>
    <span class="pill">${game.year || 'ano —'}</span>
    <span class="pill">${game.genre || '—'}</span>
    <span class="pill">${game.hasRom ? 'ROM no disco' : 'Sem ROM local'}</span>`;

  let hint = '';
  if (!plat?.emu) {
    hint = plat?.note || 'Esta geração não tem emulação PC madura — use o console oficial.';
  } else if (!game.hasRom) {
    hint = `Para jogar: coloque o dump em <code>roms/${plat.folder || game.platform}/</code> e clique em Atualizar.`;
  } else {
    hint = `Pronto para lançar via ${plat.emu}${plat.core ? ` / ${plat.core}` : ''}.`;
  }

  els.modalPlayer.innerHTML = `
    <div>
      <strong>${game.title}</strong>
      ${hint}
      <div id="launch-feedback" style="margin-top:0.8rem;color:var(--brand)"></div>
    </div>`;

  const playBtn = document.getElementById('btn-play');
  playBtn.disabled = !game.hasRom || !plat?.emu;
  playBtn.title = playBtn.disabled ? 'Precisa de ROM local + emulador suportado' : 'Lançar no emulador';

  els.modal.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeModal() {
  els.modal.classList.remove('open');
  document.body.style.overflow = '';
  state.selected = null;
}

async function launchSelected(dryRun = false) {
  const game = state.selected;
  const feedback = document.getElementById('launch-feedback');
  if (!game?.hasRom || !game.file) {
    if (feedback) feedback.textContent = 'Sem arquivo ROM/ISO local.';
    return;
  }
  if (!state.launcherOnline) {
    if (feedback) feedback.textContent = 'Inicie o launcher: python3 launcher/server.py';
    return;
  }
  if (feedback) feedback.textContent = dryRun ? 'Testando comando…' : 'Abrindo emulador…';
  try {
    const res = await fetch('/api/launch', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ platform: game.platform, file: game.file, dryRun }),
    });
    const data = await res.json();
    if (!data.ok) {
      if (feedback) feedback.textContent = data.error || 'Falha ao lançar';
      return;
    }
    if (feedback) {
      feedback.textContent = dryRun
        ? `OK: ${(data.command || []).join(' ')}`
        : `Lançado: ${(data.command || []).join(' ')}`;
    }
  } catch (err) {
    if (feedback) feedback.textContent = String(err.message || err);
  }
}

function simulateSave(kind) {
  const feedback = document.getElementById('launch-feedback');
  if (!feedback) return;
  const title = state.selected?.title || 'Jogo';
  feedback.textContent =
    kind === 'save' ? `Save state pedido para “${title}” (use o hotkey do emulador).` : `Load state — use o hotkey do emulador.`;
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

  els.ownedToggle?.addEventListener('change', (e) => {
    state.onlyOwned = e.target.checked;
    renderLibrary();
  });

  els.refreshLibrary?.addEventListener('click', async () => {
    await refreshLauncher();
    renderLibrary();
  });

  document.getElementById('close-modal').addEventListener('click', closeModal);
  els.modal.addEventListener('click', (e) => {
    if (e.target === els.modal) closeModal();
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeModal();
  });

  document.getElementById('btn-play').addEventListener('click', () => launchSelected(false));
  document.getElementById('btn-dry').addEventListener('click', () => launchSelected(true));
  document.getElementById('btn-save').addEventListener('click', () => simulateSave('save'));
  document.getElementById('btn-load').addEventListener('click', () => simulateSave('load'));
}

async function boot() {
  bindEvents();
  await refreshLauncher();
  const hash = location.hash.replace('#', '');
  setView(hash === 'biblioteca' ? 'library' : 'landing');
}

boot();
