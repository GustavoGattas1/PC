// PlayVault catalog — metadata-only demo library (no ROMs / no downloads)
const PLATFORMS = [
  { id: 'all', label: 'Todos', family: 'all' },
  { id: 'xbox-series', label: 'Xbox Series X|S', family: 'xbox' },
  { id: 'xbox-one', label: 'Xbox One', family: 'xbox' },
  { id: 'xbox-360', label: 'Xbox 360', family: 'xbox' },
  { id: 'xbox', label: 'Xbox Clássico', family: 'xbox' },
  { id: 'ps5', label: 'PlayStation 5', family: 'playstation' },
  { id: 'ps4', label: 'PlayStation 4', family: 'playstation' },
  { id: 'ps3', label: 'PlayStation 3', family: 'playstation' },
  { id: 'ps2', label: 'PlayStation 2', family: 'playstation' },
  { id: 'ps1', label: 'PlayStation', family: 'playstation' },
  { id: 'snes', label: 'Super Nintendo', family: 'retro' },
  { id: 'n64', label: 'Nintendo 64', family: 'retro' },
  { id: 'genesis', label: 'Mega Drive', family: 'retro' },
  { id: 'nes', label: 'Nintendinho', family: 'retro' },
  { id: 'arcade', label: 'Arcade', family: 'retro' },
];

const GAMES = [
  // Xbox Series
  { id: 'halo-infinite', title: 'Halo Infinite', platform: 'xbox-series', year: 2021, genre: 'FPS', color: ['#0b3d2e', '#3dffc0'] },
  { id: 'forza-horizon-5', title: 'Forza Horizon 5', platform: 'xbox-series', year: 2021, genre: 'Corrida', color: ['#1a3a5c', '#ffb14a'] },
  { id: 'starfield', title: 'Starfield', platform: 'xbox-series', year: 2023, genre: 'RPG', color: ['#101828', '#6ecbff'] },
  { id: 'sea-of-thieves', title: 'Sea of Thieves', platform: 'xbox-series', year: 2018, genre: 'Aventura', color: ['#0c3b4a', '#3dffc0'] },
  { id: 'gears-5', title: 'Gears 5', platform: 'xbox-series', year: 2019, genre: 'Ação', color: ['#3a1510', '#ff7a45'] },
  { id: 'flight-sim', title: 'Microsoft Flight Simulator', platform: 'xbox-series', year: 2020, genre: 'Simulação', color: ['#12324a', '#8ecbff'] },
  { id: 'hi-fi-rush', title: 'Hi-Fi RUSH', platform: 'xbox-series', year: 2023, genre: 'Ritmo', color: ['#2a1040', '#ff5d9a'] },
  { id: 'pentiment', title: 'Pentiment', platform: 'xbox-series', year: 2022, genre: 'Narrativo', color: ['#3a2a12', '#ffb14a'] },

  // Xbox One
  { id: 'ori-will', title: 'Ori and the Will of the Wisps', platform: 'xbox-one', year: 2020, genre: 'Plataforma', color: ['#123a4a', '#7dffd0'] },
  { id: 'cuphead', title: 'Cuphead', platform: 'xbox-one', year: 2017, genre: 'Run & Gun', color: ['#3a2010', '#ffb14a'] },
  { id: 'forza-7', title: 'Forza Motorsport 7', platform: 'xbox-one', year: 2017, genre: 'Corrida', color: ['#102030', '#4aa3ff'] },
  { id: 'quantum-break', title: 'Quantum Break', platform: 'xbox-one', year: 2016, genre: 'Ação', color: ['#1a2038', '#7aa0ff'] },
  { id: 'sunset-overdrive', title: 'Sunset Overdrive', platform: 'xbox-one', year: 2014, genre: 'Ação', color: ['#3a1840', '#ff6ad5'] },
  { id: 'state-of-decay-2', title: 'State of Decay 2', platform: 'xbox-one', year: 2018, genre: 'Sobrevivência', color: ['#2a1a10', '#c47a3a'] },

  // Xbox 360
  { id: 'halo-3', title: 'Halo 3', platform: 'xbox-360', year: 2007, genre: 'FPS', color: ['#143020', '#7dffb3'] },
  { id: 'gears-of-war', title: 'Gears of War', platform: 'xbox-360', year: 2006, genre: 'Ação', color: ['#2a1208', '#d45a30'] },
  { id: 'forza-3', title: 'Forza Motorsport 3', platform: 'xbox-360', year: 2009, genre: 'Corrida', color: ['#102438', '#4aa3ff'] },
  { id: 'fable-2', title: 'Fable II', platform: 'xbox-360', year: 2008, genre: 'RPG', color: ['#203018', '#a8d46a'] },
  { id: 'bioshock', title: 'BioShock', platform: 'xbox-360', year: 2007, genre: 'FPS', color: ['#102840', '#4ad0ff'] },
  { id: 'left-4-dead-2', title: 'Left 4 Dead 2', platform: 'xbox-360', year: 2009, genre: 'Co-op', color: ['#2a1008', '#ff5d45'] },
  { id: 'red-dead-redemption', title: 'Red Dead Redemption', platform: 'xbox-360', year: 2010, genre: 'Ação', color: ['#3a2410', '#d4a06a'] },
  { id: 'mass-effect-2', title: 'Mass Effect 2', platform: 'xbox-360', year: 2010, genre: 'RPG', color: ['#101828', '#5aa0ff'] },

  // Xbox clássico
  { id: 'halo-ce', title: 'Halo: Combat Evolved', platform: 'xbox', year: 2001, genre: 'FPS', color: ['#0e2a20', '#3dffc0'] },
  { id: 'fable', title: 'Fable', platform: 'xbox', year: 2004, genre: 'RPG', color: ['#243018', '#b8d46a'] },
  { id: 'jade-empire', title: 'Jade Empire', platform: 'xbox', year: 2005, genre: 'RPG', color: ['#3a1810', '#ff8a4a'] },
  { id: 'ninja-gaiden-black', title: 'Ninja Gaiden Black', platform: 'xbox', year: 2005, genre: 'Ação', color: ['#181018', '#ff5d6c'] },
  { id: 'crimson-skies', title: 'Crimson Skies', platform: 'xbox', year: 2003, genre: 'Ação', color: ['#102838', '#6ecbff'] },

  // PS5
  { id: 'spider-man-2', title: "Marvel's Spider-Man 2", platform: 'ps5', year: 2023, genre: 'Ação', color: ['#1a1028', '#ff4a5d'] },
  { id: 'god-of-war-ragnarok', title: 'God of War Ragnarök', platform: 'ps5', year: 2022, genre: 'Ação', color: ['#101820', '#8ecbff'] },
  { id: 'horizon-fw', title: 'Horizon Forbidden West', platform: 'ps5', year: 2022, genre: 'Aventura', color: ['#0e2a38', '#3dffc0'] },
  { id: 'ff16', title: 'Final Fantasy XVI', platform: 'ps5', year: 2023, genre: 'RPG', color: ['#1a1020', '#c07aff'] },
  { id: 'returnal', title: 'Returnal', platform: 'ps5', year: 2021, genre: 'Roguelike', color: ['#102028', '#4ad0c0'] },
  { id: 'ratchet', title: 'Ratchet & Clank: Rift Apart', platform: 'ps5', year: 2021, genre: 'Ação', color: ['#201838', '#ffb14a'] },
  { id: 'astro-bot', title: 'Astro Bot', platform: 'ps5', year: 2024, genre: 'Plataforma', color: ['#102840', '#6ecbff'] },
  { id: 'demon-souls', title: "Demon's Souls", platform: 'ps5', year: 2020, genre: 'Souls', color: ['#181010', '#c45a4a'] },
  { id: 'gt7', title: 'Gran Turismo 7', platform: 'ps5', year: 2022, genre: 'Corrida', color: ['#101820', '#4aa3ff'] },

  // PS4
  { id: 'the-last-of-us-2', title: 'The Last of Us Part II', platform: 'ps4', year: 2020, genre: 'Ação', color: ['#1a2410', '#8ab06a'] },
  { id: 'bloodborne', title: 'Bloodborne', platform: 'ps4', year: 2015, genre: 'Souls', color: ['#101018', '#8a6a4a'] },
  { id: 'uncharted-4', title: 'Uncharted 4', platform: 'ps4', year: 2016, genre: 'Aventura', color: ['#102838', '#3dffc0'] },
  { id: 'persona-5', title: 'Persona 5 Royal', platform: 'ps4', year: 2019, genre: 'RPG', color: ['#280808', '#ff3a3a'] },
  { id: 'ghost-tsushima', title: 'Ghost of Tsushima', platform: 'ps4', year: 2020, genre: 'Ação', color: ['#2a1810', '#ff8a4a'] },
  { id: 'spider-man', title: "Marvel's Spider-Man", platform: 'ps4', year: 2018, genre: 'Ação', color: ['#180818', '#ff4a5d'] },
  { id: 'god-of-war-2018', title: 'God of War', platform: 'ps4', year: 2018, genre: 'Ação', color: ['#101820', '#6ecbff'] },

  // PS3
  { id: 'uncharted-2', title: 'Uncharted 2', platform: 'ps3', year: 2009, genre: 'Aventura', color: ['#102030', '#ffb14a'] },
  { id: 'the-last-of-us', title: 'The Last of Us', platform: 'ps3', year: 2013, genre: 'Ação', color: ['#1a2418', '#a8c07a'] },
  { id: 'metal-gear-4', title: 'Metal Gear Solid 4', platform: 'ps3', year: 2008, genre: 'Stealth', color: ['#101818', '#6a8a7a'] },
  { id: 'infamous-2', title: 'inFAMOUS 2', platform: 'ps3', year: 2011, genre: 'Ação', color: ['#101828', '#4aa3ff'] },
  { id: 'killzone-2', title: 'Killzone 2', platform: 'ps3', year: 2009, genre: 'FPS', color: ['#201010', '#c45a3a'] },

  // PS2
  { id: 'gta-san-andreas', title: 'GTA: San Andreas', platform: 'ps2', year: 2004, genre: 'Ação', color: ['#1a2810', '#8ab05a'] },
  { id: 'god-of-war-2', title: 'God of War II', platform: 'ps2', year: 2007, genre: 'Ação', color: ['#181010', '#c45a4a'] },
  { id: 'shadow-colossus', title: 'Shadow of the Colossus', platform: 'ps2', year: 2005, genre: 'Aventura', color: ['#182028', '#8aa0b0'] },
  { id: 'metal-gear-3', title: 'Metal Gear Solid 3', platform: 'ps2', year: 2004, genre: 'Stealth', color: ['#142018', '#6a9a5a'] },
  { id: 'kingdom-hearts-2', title: 'Kingdom Hearts II', platform: 'ps2', year: 2005, genre: 'RPG', color: ['#101828', '#6ecbff'] },
  { id: 'jak-2', title: 'Jak II', platform: 'ps2', year: 2003, genre: 'Aventura', color: ['#203010', '#b8d46a'] },

  // PS1
  { id: 'ff7', title: 'Final Fantasy VII', platform: 'ps1', year: 1997, genre: 'RPG', color: ['#101820', '#4aa3ff'] },
  { id: 'metal-gear-solid', title: 'Metal Gear Solid', platform: 'ps1', year: 1998, genre: 'Stealth', color: ['#101818', '#7a9a8a'] },
  { id: 'crash-1', title: 'Crash Bandicoot', platform: 'ps1', year: 1996, genre: 'Plataforma', color: ['#3a2810', '#ffb14a'] },
  { id: 'spyro', title: 'Spyro the Dragon', platform: 'ps1', year: 1998, genre: 'Plataforma', color: ['#281840', '#c07aff'] },
  { id: 'resident-evil-2', title: 'Resident Evil 2', platform: 'ps1', year: 1998, genre: 'Terror', color: ['#180808', '#c45a4a'] },
  { id: 'castlevania-sotn', title: 'Castlevania: SOTN', platform: 'ps1', year: 1997, genre: 'Metroidvania', color: ['#101018', '#8a6aff'] },

  // Retro
  { id: 'super-mario-world', title: 'Super Mario World', platform: 'snes', year: 1990, genre: 'Plataforma', color: ['#102840', '#4aa3ff'] },
  { id: 'chrono-trigger', title: 'Chrono Trigger', platform: 'snes', year: 1995, genre: 'RPG', color: ['#182838', '#6ecbff'] },
  { id: 'donkey-kong-country', title: 'Donkey Kong Country', platform: 'snes', year: 1994, genre: 'Plataforma', color: ['#203010', '#8ab05a'] },
  { id: 'street-fighter-2', title: 'Street Fighter II', platform: 'snes', year: 1992, genre: 'Luta', color: ['#281010', '#ff5d6c'] },
  { id: 'zelda-oot', title: 'The Legend of Zelda: Ocarina of Time', platform: 'n64', year: 1998, genre: 'Aventura', color: ['#102818', '#3dffc0'] },
  { id: 'mario-64', title: 'Super Mario 64', platform: 'n64', year: 1996, genre: 'Plataforma', color: ['#102040', '#4aa3ff'] },
  { id: 'goldeneye', title: 'GoldenEye 007', platform: 'n64', year: 1997, genre: 'FPS', color: ['#101818', '#6a8a5a'] },
  { id: 'sonic-2', title: 'Sonic the Hedgehog 2', platform: 'genesis', year: 1992, genre: 'Plataforma', color: ['#102040', '#4aa3ff'] },
  { id: 'streets-of-rage-2', title: 'Streets of Rage 2', platform: 'genesis', year: 1992, genre: 'Beat \'em up', color: ['#281018', '#ff5d6c'] },
  { id: 'super-mario-bros', title: 'Super Mario Bros.', platform: 'nes', year: 1985, genre: 'Plataforma', color: ['#102040', '#4aa3ff'] },
  { id: 'mega-man-2', title: 'Mega Man 2', platform: 'nes', year: 1988, genre: 'Ação', color: ['#102838', '#6ecbff'] },
  { id: 'pac-man', title: 'Pac-Man', platform: 'arcade', year: 1980, genre: 'Arcade', color: ['#181028', '#ffb14a'] },
  { id: 'mortal-kombat-2', title: 'Mortal Kombat II', platform: 'arcade', year: 1993, genre: 'Luta', color: ['#180808', '#ff5d45'] },
  { id: 'metal-slug', title: 'Metal Slug', platform: 'arcade', year: 1996, genre: 'Run & Gun', color: ['#203010', '#b8d46a'] },
];

function platformLabel(id) {
  return PLATFORMS.find((p) => p.id === id)?.label || id;
}

function platformFamily(id) {
  return PLATFORMS.find((p) => p.id === id)?.family || 'retro';
}

function coverGradient(game) {
  const [a, b] = game.color;
  return `linear-gradient(160deg, ${a} 0%, ${b} 120%)`;
}
