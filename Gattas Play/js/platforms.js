/**
 * Gattas Play — plataformas suportadas no launcher caseiro.
 * Emuladores: configure caminhos em launcher/config.json
 * ROMs: coloque dumps próprios em roms/<pasta>/
 */
const PLATFORMS = [
  { id: 'all', label: 'Todos', family: 'all', group: 'all' },

  // Microsoft
  { id: 'xbox-series', label: 'Xbox Series X|S', family: 'xbox', group: 'Microsoft', emu: null, note: 'Console / Game Pass — sem emu PC maduro' },
  { id: 'xbox-one', label: 'Xbox One', family: 'xbox', group: 'Microsoft', emu: null, note: 'Console / Game Pass' },
  { id: 'xbox360', label: 'Xbox 360', family: 'xbox', group: 'Microsoft', emu: 'xenia', folder: 'xbox360', exts: ['.iso', '.xex', '.zar'] },
  { id: 'xbox', label: 'Xbox Clássico', family: 'xbox', group: 'Microsoft', emu: 'xemu', folder: 'xbox', exts: ['.iso', '.xiso'] },

  // Sony
  { id: 'ps5', label: 'PlayStation 5', family: 'playstation', group: 'Sony', emu: null, note: 'Console / PS Plus — sem emu PC maduro' },
  { id: 'ps4', label: 'PlayStation 4', family: 'playstation', group: 'Sony', emu: null, note: 'Console / PS Plus' },
  { id: 'ps3', label: 'PlayStation 3', family: 'playstation', group: 'Sony', emu: 'rpcs3', folder: 'ps3', exts: ['.iso', '.pkg', '.rap'] },
  { id: 'ps2', label: 'PlayStation 2', family: 'playstation', group: 'Sony', emu: 'pcsx2', folder: 'ps2', exts: ['.iso', '.bin', '.chd', '.cso'] },
  { id: 'ps1', label: 'PlayStation', family: 'playstation', group: 'Sony', emu: 'retroarch', core: 'pcsx_rearmed', folder: 'ps1', exts: ['.cue', '.bin', '.chd', '.pbp', '.iso'] },
  { id: 'psp', label: 'PSP', family: 'playstation', group: 'Sony', emu: 'retroarch', core: 'ppsspp', folder: 'psp', exts: ['.iso', '.cso', '.pbp'] },
  { id: 'psvita', label: 'PS Vita', family: 'playstation', group: 'Sony', emu: 'vita3k', folder: 'psvita', exts: ['.vpk', '.zip'] },

  // Nintendo
  { id: 'switch', label: 'Nintendo Switch', family: 'nintendo', group: 'Nintendo', emu: 'ryujinx', folder: 'switch', exts: ['.nsp', '.xci'], note: 'Requer firmware dumpado do seu Switch' },
  { id: 'wiiu', label: 'Wii U', family: 'nintendo', group: 'Nintendo', emu: 'cemu', folder: 'wiiu', exts: ['.rpx', '.wud', '.wux'] },
  { id: 'wii', label: 'Wii', family: 'nintendo', group: 'Nintendo', emu: 'dolphin', folder: 'wii', exts: ['.iso', '.wbfs', '.rvz', '.gcm'] },
  { id: 'gamecube', label: 'GameCube', family: 'nintendo', group: 'Nintendo', emu: 'dolphin', folder: 'gamecube', exts: ['.iso', '.gcm', '.rvz', '.gcz'] },
  { id: 'n64', label: 'Nintendo 64', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'mupen64plus_next', folder: 'n64', exts: ['.z64', '.n64', '.v64'] },
  { id: 'snes', label: 'Super Nintendo', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'snes9x', folder: 'snes', exts: ['.sfc', '.smc', '.zip'] },
  { id: 'nes', label: 'Nintendinho / NES', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'nestopia', folder: 'nes', exts: ['.nes', '.zip'] },
  { id: '3ds', label: 'Nintendo 3DS', family: 'nintendo', group: 'Nintendo', emu: 'citra', folder: '3ds', exts: ['.cia', '.3ds', '.cxi'] },
  { id: 'nds', label: 'Nintendo DS', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'melonds', folder: 'nds', exts: ['.nds'] },
  { id: 'gba', label: 'Game Boy Advance', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'mgba', folder: 'gba', exts: ['.gba', '.zip'] },
  { id: 'gbc', label: 'Game Boy Color', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'gambatte', folder: 'gbc', exts: ['.gbc', '.zip'] },
  { id: 'gb', label: 'Game Boy', family: 'nintendo', group: 'Nintendo', emu: 'retroarch', core: 'gambatte', folder: 'gb', exts: ['.gb', '.zip'] },

  // Sega
  { id: 'dreamcast', label: 'Dreamcast', family: 'sega', group: 'Sega', emu: 'retroarch', core: 'flycast', folder: 'dreamcast', exts: ['.chd', '.gdi', '.cdi', '.iso'] },
  { id: 'saturn', label: 'Sega Saturn', family: 'sega', group: 'Sega', emu: 'retroarch', core: 'mednafen_saturn', folder: 'saturn', exts: ['.cue', '.chd', '.iso'] },
  { id: 'genesis', label: 'Mega Drive / Genesis', family: 'sega', group: 'Sega', emu: 'retroarch', core: 'genesis_plus_gx', folder: 'genesis', exts: ['.md', '.gen', '.bin', '.zip', '.smd'] },
  { id: 'mastersystem', label: 'Master System', family: 'sega', group: 'Sega', emu: 'retroarch', core: 'genesis_plus_gx', folder: 'mastersystem', exts: ['.sms', '.zip'] },

  // Outros
  { id: 'arcade', label: 'Arcade / MAME', family: 'arcade', group: 'Arcade', emu: 'retroarch', core: 'mame', folder: 'arcade', exts: ['.zip', '.7z'] },
  { id: 'neogeo', label: 'Neo Geo', family: 'arcade', group: 'Arcade', emu: 'retroarch', core: 'fbneo', folder: 'neogeo', exts: ['.zip'] },
  { id: 'pcengine', label: 'PC Engine / TG-16', family: 'retro', group: 'Outros', emu: 'retroarch', core: 'mednafen_pce_fast', folder: 'pcengine', exts: ['.pce', '.cue', '.chd', '.zip'] },
  { id: 'atari2600', label: 'Atari 2600', family: 'retro', group: 'Outros', emu: 'retroarch', core: 'stella', folder: 'atari2600', exts: ['.a26', '.bin', '.zip'] },
  { id: 'wonderswan', label: 'WonderSwan', family: 'retro', group: 'Outros', emu: 'retroarch', core: 'mednafen_wswan', folder: 'wonderswan', exts: ['.ws', '.wsc', '.zip'] },
  { id: 'msx', label: 'MSX', family: 'retro', group: 'Outros', emu: 'retroarch', core: 'bluemsx', folder: 'msx', exts: ['.rom', '.dsk', '.zip'] },
];

function platformById(id) {
  return PLATFORMS.find((p) => p.id === id);
}

function platformLabel(id) {
  return platformById(id)?.label || id;
}

function platformFamily(id) {
  return platformById(id)?.family || 'retro';
}

function coverGradient(game) {
  const [a, b] = game.color || ['#102030', '#3dffc0'];
  return `linear-gradient(160deg, ${a} 0%, ${b} 120%)`;
}

function slugify(text) {
  return String(text)
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '');
}
