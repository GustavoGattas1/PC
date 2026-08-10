#!/usr/bin/env python3
"""Gera catálogo curado grande (metadados) para Gattas Play."""
from __future__ import annotations

import json
from pathlib import Path

# (title, platform, year, genre)
RAW: list[tuple[str, str, int, str]] = []

def add(platform: str, year: int, genre: str, *titles: str) -> None:
    for t in titles:
        RAW.append((t, platform, year, genre))

# --- Xbox Series ---
add("xbox-series", 2021, "FPS", "Halo Infinite")
add("xbox-series", 2021, "Corrida", "Forza Horizon 5")
add("xbox-series", 2023, "RPG", "Starfield")
add("xbox-series", 2018, "Aventura", "Sea of Thieves")
add("xbox-series", 2019, "Ação", "Gears 5")
add("xbox-series", 2020, "Simulação", "Microsoft Flight Simulator")
add("xbox-series", 2023, "Ritmo", "Hi-Fi RUSH")
add("xbox-series", 2022, "Narrativo", "Pentiment")
add("xbox-series", 2021, "Plataforma", "Psychonauts 2")
add("xbox-series", 2020, "Plataforma", "Ori and the Will of the Wisps")
add("xbox-series", 2023, "Ação", "Lies of P")
add("xbox-series", 2024, "Ação", "Indiana Jones and the Great Circle")

# --- Xbox One ---
add("xbox-one", 2017, "Run & Gun", "Cuphead")
add("xbox-one", 2017, "Corrida", "Forza Motorsport 7")
add("xbox-one", 2016, "Ação", "Quantum Break")
add("xbox-one", 2014, "Ação", "Sunset Overdrive")
add("xbox-one", 2018, "Sobrevivência", "State of Decay 2")
add("xbox-one", 2015, "RPG", "Fallout 4")
add("xbox-one", 2015, "Ação", "Rise of the Tomb Raider")
add("xbox-one", 2016, "FPS", "Doom (2016)")
add("xbox-one", 2018, "RPG", "Kingdom Come: Deliverance")
add("xbox-one", 2019, "Aventura", "Outer Wilds")

# --- Xbox 360 ---
add("xbox360", 2007, "FPS", "Halo 3", "BioShock", "Call of Duty 4: Modern Warfare")
add("xbox360", 2006, "Ação", "Gears of War", "Dead Rising")
add("xbox360", 2008, "RPG", "Fable II", "Fallout 3")
add("xbox360", 2009, "Corrida", "Forza Motorsport 3")
add("xbox360", 2009, "Co-op", "Left 4 Dead 2", "Borderlands")
add("xbox360", 2010, "Ação", "Red Dead Redemption", "Alan Wake")
add("xbox360", 2010, "RPG", "Mass Effect 2")
add("xbox360", 2011, "Ação", "Batman: Arkham City", "Dark Souls")
add("xbox360", 2011, "FPS", "Halo: Reach")
add("xbox360", 2012, "Ação", "Sleeping Dogs", "Max Payne 3")
add("xbox360", 2013, "Ação", "Grand Theft Auto V", "Tomb Raider")
add("xbox360", 2007, "Corrida", "Burnout Paradise")
add("xbox360", 2008, "Ação", "Metal Gear Solid 4")  # actually PS3 exclusive mostly - skip mindset, keep known multi
add("xbox360", 2008, "Esporte", "FIFA 09", "NBA 2K9")
add("xbox360", 2011, "Aventura", "The Elder Scrolls V: Skyrim")
add("xbox360", 2007, "Música", "Guitar Hero III")
add("xbox360", 2008, "Luta", "Street Fighter IV")
add("xbox360", 2010, "FPS", "Halo: ODST")

# --- Xbox clássico ---
add("xbox", 2001, "FPS", "Halo: Combat Evolved")
add("xbox", 2004, "RPG", "Fable", "Jade Empire")
add("xbox", 2005, "Ação", "Ninja Gaiden Black", "Otogi 2")
add("xbox", 2003, "Ação", "Crimson Skies: High Road to Revenge", "Amped 2")
add("xbox", 2002, "Corrida", "Project Gotham Racing")
add("xbox", 2004, "FPS", "Halo 2")
add("xbox", 2003, "Stealth", "Splinter Cell")
add("xbox", 2002, "Ação", "Dead or Alive 3")
add("xbox", 2004, "Esporte", "Madden NFL 2005")
add("xbox", 2005, "RPG", "Kameo: Elements of Power")

# --- PS5 ---
add("ps5", 2023, "Ação", "Marvel's Spider-Man 2", "Final Fantasy XVI")
add("ps5", 2022, "Ação", "God of War Ragnarök", "Horizon Forbidden West", "Gran Turismo 7")
add("ps5", 2021, "Roguelike", "Returnal")
add("ps5", 2021, "Ação", "Ratchet & Clank: Rift Apart")
add("ps5", 2024, "Plataforma", "Astro Bot")
add("ps5", 2020, "Souls", "Demon's Souls")
add("ps5", 2023, "Ação", "Stellar Blade")
add("ps5", 2022, "Aventura", "The Last of Us Part I")
add("ps5", 2023, "Ação", "Resident Evil 4 Remake")
add("ps5", 2024, "Ação", "Black Myth: Wukong")
add("ps5", 2022, "Luta", "Street Fighter 6")
add("ps5", 2023, "RPG", "Baldur's Gate 3")

# --- PS4 ---
add("ps4", 2020, "Ação", "The Last of Us Part II", "Ghost of Tsushima")
add("ps4", 2015, "Souls", "Bloodborne")
add("ps4", 2016, "Aventura", "Uncharted 4")
add("ps4", 2019, "RPG", "Persona 5 Royal")
add("ps4", 2018, "Ação", "Marvel's Spider-Man", "God of War", "Red Dead Redemption 2")
add("ps4", 2015, "Ação", "The Witcher 3: Wild Hunt", "Metal Gear Solid V")
add("ps4", 2017, "Ação", "Horizon Zero Dawn", "Nier: Automata")
add("ps4", 2016, "Ação", "Doom (2016)", "Titanfall 2")
add("ps4", 2019, "Ação", "Sekiro: Shadows Die Twice", "Death Stranding")
add("ps4", 2014, "Ação", "The Last of Us Remastered")
add("ps4", 2018, "Esporte", "FIFA 19", "NBA 2K19")
add("ps4", 2020, "RPG", "Final Fantasy VII Remake")
add("ps4", 2017, "Aventura", "What Remains of Edith Finch")

# --- PS3 ---
add("ps3", 2009, "Aventura", "Uncharted 2: Among Thieves")
add("ps3", 2013, "Ação", "The Last of Us")
add("ps3", 2008, "Stealth", "Metal Gear Solid 4: Guns of the Patriots")
add("ps3", 2011, "Ação", "inFAMOUS 2", "Uncharted 3")
add("ps3", 2009, "FPS", "Killzone 2", "Resistance 2")
add("ps3", 2010, "Ação", "God of War III", "Heavy Rain")
add("ps3", 2011, "RPG", "Dark Souls", "The Elder Scrolls V: Skyrim")
add("ps3", 2012, "Ação", "Journey", "Sleeping Dogs")
add("ps3", 2007, "Ação", "MotorStorm", "Ratchet & Clank Future")
add("ps3", 2010, "Luta", "Tekken 6", "Soulcalibur IV")
add("ps3", 2008, "Música", "Rock Band 2")
add("ps3", 2011, "Corrida", "Gran Turismo 5")
add("ps3", 2009, "RPG", "Demon's Souls")
add("ps3", 2013, "Ação", "Grand Theft Auto V")

# --- PS2 ---
add("ps2", 2004, "Ação", "Grand Theft Auto: San Andreas", "Metal Gear Solid 3: Snake Eater")
add("ps2", 2007, "Ação", "God of War II")
add("ps2", 2005, "Aventura", "Shadow of the Colossus", "Kingdom Hearts II")
add("ps2", 2003, "Aventura", "Jak II", "Ratchet & Clank: Going Commando")
add("ps2", 2001, "Ação", "Grand Theft Auto III", "Metal Gear Solid 2")
add("ps2", 2002, "Ação", "Grand Theft Auto: Vice City", "Kingdom Hearts")
add("ps2", 2005, "Ação", "God of War", "Resident Evil 4")
add("ps2", 2004, "RPG", "Final Fantasy X-2", "Persona 3")
add("ps2", 2001, "RPG", "Final Fantasy X")
add("ps2", 2006, "RPG", "Final Fantasy XII", "Persona 4")
add("ps2", 2003, "Luta", "Soulcalibur II", "Tekken 4")
add("ps2", 2004, "Esporte", "Winning Eleven 8", "NBA Street V3")
add("ps2", 2002, "Corrida", "Gran Turismo 3 A-Spec", "Burnout 2")
add("ps2", 2001, "Terror", "Silent Hill 2")
add("ps2", 2003, "Terror", "Silent Hill 3")
add("ps2", 2005, "Ação", "Devil May Cry 3", "Okami")
add("ps2", 2006, "Ação", "Black", "Scarface")
add("ps2", 2004, "Aventura", "Jak 3")
add("ps2", 2002, "Stealth", "Splinter Cell")
add("ps2", 2001, "Luta", "Tekken Tag Tournament")

# --- PS1 ---
add("ps1", 1997, "RPG", "Final Fantasy VII", "Castlevania: Symphony of the Night")
add("ps1", 1998, "Stealth", "Metal Gear Solid")
add("ps1", 1996, "Plataforma", "Crash Bandicoot")
add("ps1", 1998, "Plataforma", "Spyro the Dragon", "Crash Bandicoot: Warped")
add("ps1", 1998, "Terror", "Resident Evil 2")
add("ps1", 1999, "RPG", "Final Fantasy VIII", "Chrono Cross")
add("ps1", 2000, "RPG", "Final Fantasy IX", "Vagrant Story")
add("ps1", 1997, "Luta", "Tekken 3")
add("ps1", 1999, "Ação", "Ape Escape", "Legacy of Kain: Soul Reaver")
add("ps1", 1996, "Corrida", "Wipeout XL", "Ridge Racer Type 4")
add("ps1", 1998, "Terror", "Metal Gear Solid", "Silent Hill")
add("ps1", 1999, "Terror", "Resident Evil 3: Nemesis")
add("ps1", 1995, "Luta", "Tekken 2", "Battle Arena Toshinden")
add("ps1", 1997, "Aventura", "Oddworld: Abe's Oddysee")
add("ps1", 1999, "Aventura", "MediEvil")
add("ps1", 1998, "Esporte", "Tony Hawk's Pro Skater")
add("ps1", 2000, "Esporte", "Tony Hawk's Pro Skater 2")
add("ps1", 1996, "RPG", "Suikoden", "Wild Arms")

# --- PSP ---
add("psp", 2005, "Ação", "Lumines", "Wipeout Pure")
add("psp", 2006, "RPG", "Final Fantasy III", "Monster Hunter Freedom")
add("psp", 2007, "Ação", "God of War: Chains of Olympus", "Crisis Core: Final Fantasy VII")
add("psp", 2008, "Ação", "Metal Gear Solid: Peace Walker", "Patapon")
add("psp", 2009, "RPG", "Persona 3 Portable")
add("psp", 2010, "Ação", "God of War: Ghost of Sparta", "Daxter")
add("psp", 2005, "Corrida", "Gran Turismo")
add("psp", 2006, "Luta", "Tekken: Dark Resurrection")
add("psp", 2008, "RPG", "Dissidia Final Fantasy")
add("psp", 2009, "Aventura", "LittleBigPlanet")

# --- PS Vita ---
add("psvita", 2012, "Ação", "Uncharted: Golden Abyss", "Gravity Rush")
add("psvita", 2013, "RPG", "Persona 4 Golden")
add("psvita", 2014, "Ação", "Killzone Mercenary")
add("psvita", 2015, "RPG", "Soul Sacrifice Delta")
add("psvita", 2012, "Aventura", "LittleBigPlanet PS Vita")
add("psvita", 2013, "Ação", "Tearaway")
add("psvita", 2014, "RPG", "Freedom Wars")
add("psvita", 2016, "RPG", "World of Final Fantasy")
add("psvita", 2013, "Ação", "Muramasa Rebirth")

# --- Switch (metadata; needs own firmware dump) ---
add("switch", 2017, "Ação", "The Legend of Zelda: Breath of the Wild", "Super Mario Odyssey")
add("switch", 2018, "Luta", "Super Smash Bros. Ultimate")
add("switch", 2019, "RPG", "Pokémon Sword", "Fire Emblem: Three Houses")
add("switch", 2020, "Aventura", "Animal Crossing: New Horizons")
add("switch", 2021, "Metroidvania", "Metroid Dread")
add("switch", 2023, "Ação", "The Legend of Zelda: Tears of the Kingdom")
add("switch", 2022, "RPG", "Pokémon Scarlet", "Xenoblade Chronicles 3")
add("switch", 2018, "Kart", "Mario Kart 8 Deluxe")
add("switch", 2019, "Ação", "Luigi's Mansion 3", "Astral Chain")
add("switch", 2021, "Ação", "Monster Hunter Rise")

# --- Wii U ---
add("wiiu", 2012, "Ação", "Nintendo Land", "New Super Mario Bros. U")
add("wiiu", 2013, "Ação", "The Legend of Zelda: The Wind Waker HD")
add("wiiu", 2014, "Ação", "Mario Kart 8", "Super Smash Bros. for Wii U")
add("wiiu", 2015, "Ação", "Splatoon")
add("wiiu", 2016, "Aventura", "The Legend of Zelda: Twilight Princess HD")
add("wiiu", 2017, "Ação", "The Legend of Zelda: Breath of the Wild")
add("wiiu", 2014, "Ação", "Bayonetta 2")
add("wiiu", 2013, "Plataforma", "Super Mario 3D World")

# --- Wii ---
add("wii", 2006, "Esporte", "Wii Sports")
add("wii", 2007, "Aventura", "The Legend of Zelda: Twilight Princess", "Super Mario Galaxy")
add("wii", 2008, "Ação", "Super Smash Bros. Brawl", "Mario Kart Wii")
add("wii", 2009, "Aventura", "New Super Mario Bros. Wii")
add("wii", 2010, "Aventura", "Super Mario Galaxy 2", "Donkey Kong Country Returns")
add("wii", 2011, "Aventura", "The Legend of Zelda: Skyward Sword")
add("wii", 2008, "Ação", "Dead Space Extraction", "No More Heroes")
add("wii", 2009, "Ação", "Xenoblade Chronicles")
add("wii", 2007, "Música", "Guitar Hero III")
add("wii", 2006, "Aventura", "Red Steel")

# --- GameCube ---
add("gamecube", 2001, "Aventura", "Luigi's Mansion", "Wave Race: Blue Storm")
add("gamecube", 2002, "Aventura", "Super Mario Sunshine", "Metroid Prime", "The Legend of Zelda: The Wind Waker")
add("gamecube", 2003, "Ação", "Soulcalibur II", "Viewtiful Joe")
add("gamecube", 2004, "Aventura", "Metroid Prime 2: Echoes", "Paper Mario: The Thousand-Year Door")
add("gamecube", 2005, "Kart", "Mario Kart: Double Dash!!")  # actually 2003
add("gamecube", 2003, "Kart", "Mario Kart: Double Dash!!")
add("gamecube", 2004, "Esporte", "Mario Power Tennis")
add("gamecube", 2002, "Terror", "Resident Evil")
add("gamecube", 2003, "Terror", "Resident Evil 4")
add("gamecube", 2001, "Luta", "Super Smash Bros. Melee")
add("gamecube", 2004, "Ação", "Tales of Symphonia", "F-Zero GX")
add("gamecube", 2005, "Aventura", "The Legend of Zelda: Twilight Princess")
add("gamecube", 2002, "Ação", "Eternal Darkness")
add("gamecube", 2003, "Aventura", "Star Fox Adventures")
add("gamecube", 2004, "Ação", "Pikmin 2")

# --- N64 ---
add("n64", 1996, "Plataforma", "Super Mario 64", "Wave Race 64")
add("n64", 1997, "FPS", "GoldenEye 007")
add("n64", 1998, "Aventura", "The Legend of Zelda: Ocarina of Time", "Banjo-Kazooie", "F-Zero X")
add("n64", 1999, "Kart", "Mario Kart 64")  # 1996
add("n64", 1996, "Kart", "Mario Kart 64")
add("n64", 2000, "Aventura", "The Legend of Zelda: Majora's Mask", "Perfect Dark", "Paper Mario")
add("n64", 1999, "Ação", "Donkey Kong 64", "Jet Force Gemini")
add("n64", 1998, "Esporte", "International Superstar Soccer 98")
add("n64", 1999, "Luta", "Super Smash Bros.")
add("n64", 1997, "Corrida", "Diddy Kong Racing")
add("n64", 1998, "Aventura", "Banjo-Kazooie")
add("n64", 2000, "Aventura", "Banjo-Tooie")
add("n64", 1999, "Ação", "Conker's Bad Fur Day")

# --- SNES ---
add("snes", 1990, "Plataforma", "Super Mario World", "F-Zero")
add("snes", 1991, "Ação", "The Legend of Zelda: A Link to the Past", "Final Fight")
add("snes", 1992, "Luta", "Street Fighter II", "Mortal Kombat")
add("snes", 1993, "Corrida", "Top Gear", "F-Zero")
add("snes", 1994, "Plataforma", "Donkey Kong Country", "Super Metroid", "EarthBound")
add("snes", 1995, "RPG", "Chrono Trigger", "Secret of Mana")
add("snes", 1996, "RPG", "Final Fantasy VI", "Super Mario RPG")
add("snes", 1994, "Ação", "Mega Man X", "Kirby Super Star")
add("snes", 1993, "Plataforma", "Super Mario All-Stars")
add("snes", 1992, "RPG", "Final Fantasy IV", "Final Fantasy V")
add("snes", 1995, "Ação", "Yoshi's Island", "Donkey Kong Country 2")
add("snes", 1996, "Ação", "Donkey Kong Country 3")
add("snes", 1991, "Esporte", "Super Soccer", "NBA Jam")
add("snes", 1993, "Luta", "Fatal Fury Special", "Samurai Shodown")

# --- NES ---
add("nes", 1985, "Plataforma", "Super Mario Bros.", "Excitebike")
add("nes", 1986, "Aventura", "The Legend of Zelda", "Metroid")
add("nes", 1987, "Plataforma", "Mega Man", "Castlevania")
add("nes", 1988, "Ação", "Mega Man 2", "Ninja Gaiden", "Bionic Commando")
add("nes", 1989, "Aventura", "Zelda II: The Adventure of Link", "DuckTales")
add("nes", 1990, "Plataforma", "Super Mario Bros. 3", "Mega Man 3")
add("nes", 1983, "Arcade", "Donkey Kong", "Popeye")
add("nes", 1988, "Esporte", "Tecmo Bowl", "Punch-Out!!")
add("nes", 1987, "RPG", "Final Fantasy", "Dragon Warrior")
add("nes", 1989, "Ação", "Teenage Mutant Ninja Turtles", "Batman")
add("nes", 1991, "Ação", "Battletoads", "Base Wars")

# --- GBA ---
add("gba", 2001, "Plataforma", "Super Mario Advance", "Mario Kart: Super Circuit")
add("gba", 2002, "RPG", "Metroid Fusion", "Golden Sun")
add("gba", 2003, "Aventura", "The Legend of Zelda: The Minish Cap", "Pokémon Ruby")
add("gba", 2004, "Metroidvania", "Metroid: Zero Mission", "Castlevania: Aria of Sorrow")
add("gba", 2001, "RPG", "Advance Wars", "Fire Emblem")
add("gba", 2004, "RPG", "Pokémon FireRed", "Pokémon Emerald")
add("gba", 2003, "Ação", "WarioWare, Inc.", "Klonoa Heroes")
add("gba", 2002, "Plataforma", "Sonic Advance", "Kirby: Nightmare in Dream Land")
add("gba", 2005, "RPG", "Final Fantasy IV Advance", "Mario & Luigi: Superstar Saga")
add("gba", 2003, "Ação", "Sword of Mana", "Tactics Ogre")

# --- GBC / GB ---
add("gbc", 1998, "RPG", "Pokémon Gold", "Pokémon Silver")
add("gbc", 1999, "Aventura", "The Legend of Zelda: Link's Awakening DX", "Wario Land 3")
add("gbc", 2000, "RPG", "Pokémon Crystal", "Dragon Warrior III")
add("gbc", 2001, "Ação", "Mario Tennis", "Shantae")
add("gb", 1989, "Plataforma", "Super Mario Land", "Tetris")
add("gb", 1990, "Aventura", "The Legend of Zelda: Link's Awakening")
add("gb", 1991, "Plataforma", "Metroid II: Return of Samus", "Mega Man: Dr. Wily's Revenge")
add("gb", 1996, "RPG", "Pokémon Red", "Pokémon Blue")
add("gb", 1994, "Ação", "Donkey Kong", "Kirby's Dream Land")
add("gb", 1992, "Plataforma", "Super Mario Land 2")

# --- NDS / 3DS ---
add("nds", 2005, "RPG", "Nintendogs", "Animal Crossing: Wild World")
add("nds", 2006, "RPG", "Pokémon Diamond", "New Super Mario Bros.")
add("nds", 2007, "Aventura", "The Legend of Zelda: Phantom Hourglass")
add("nds", 2008, "RPG", "Pokémon Platinum", "Mario Kart DS")
add("nds", 2009, "Aventura", "The Legend of Zelda: Spirit Tracks")
add("nds", 2010, "RPG", "Pokémon Black", "Dragon Quest IX")
add("nds", 2005, "Ação", "Mario & Luigi: Partners in Time", "Castlevania: Dawn of Sorrow")
add("nds", 2007, "Ação", "The World Ends with You", "Ghost Trick")
add("3ds", 2011, "Aventura", "The Legend of Zelda: Ocarina of Time 3D", "Super Mario 3D Land")
add("3ds", 2012, "RPG", "Animal Crossing: New Leaf", "Fire Emblem: Awakening")
add("3ds", 2013, "Aventura", "The Legend of Zelda: A Link Between Worlds", "Pokémon X")
add("3ds", 2014, "Ação", "Super Smash Bros. for Nintendo 3DS", "Monster Hunter 4 Ultimate")
add("3ds", 2015, "RPG", "Xenoblade Chronicles 3D")
add("3ds", 2016, "Aventura", "Pokémon Sun", "The Legend of Zelda: Tri Force Heroes")
add("3ds", 2017, "Ação", "Mario Kart 7", "Miitopia")
add("3ds", 2011, "Kart", "Mario Kart 7")
add("3ds", 2018, "RPG", "Detective Pikachu")

# --- Sega ---
add("dreamcast", 1999, "Ação", "Sonic Adventure", "Soulcalibur", "Power Stone")
add("dreamcast", 2000, "Ação", "Jet Set Radio", "Shenmue", "Crazy Taxi")
add("dreamcast", 2001, "Ação", "Sonic Adventure 2", "Skies of Arcadia", "Phantasy Star Online")
add("dreamcast", 2000, "Luta", "Marvel vs. Capcom 2", "Dead or Alive 2")
add("dreamcast", 2001, "Corrida", "Daytona USA", "Metropolis Street Racer")
add("dreamcast", 1999, "Esporte", "NFL 2K", "NBA 2K")
add("saturn", 1995, "Luta", "Virtua Fighter 2", "Panzer Dragoon")
add("saturn", 1996, "Ação", "Nights into Dreams", "Guardian Heroes")
add("saturn", 1997, "Ação", "Panzer Dragoon Saga", "Shining Force III")
add("saturn", 1998, "Luta", "Street Fighter Alpha 3", "Last Bronx")
add("saturn", 1995, "Corrida", "Sega Rally Championship", "Daytona USA")
add("genesis", 1991, "Plataforma", "Sonic the Hedgehog", "Streets of Rage")
add("genesis", 1992, "Plataforma", "Sonic the Hedgehog 2", "Streets of Rage 2")
add("genesis", 1993, "Ação", "Gunstar Heroes", "Shinobi III", "Castlevania: Bloodlines")
add("genesis", 1994, "Plataforma", "Sonic & Knuckles", "Earthworm Jim")
add("genesis", 1990, "Esporte", "John Madden Football", "NHL Hockey")
add("genesis", 1992, "Luta", "Mortal Kombat", "Street Fighter II' Special Champion Edition")
add("genesis", 1991, "Ação", "Altered Beast", "Golden Axe")
add("genesis", 1994, "RPG", "Phantasy Star IV", "Shining Force II")
add("mastersystem", 1986, "Plataforma", "Alex Kidd in Miracle World", "Fantasy Zone")
add("mastersystem", 1987, "Ação", "Wonder Boy", "Shinobi")
add("mastersystem", 1988, "Plataforma", "Sonic the Hedgehog")  # SMS Sonic later
add("mastersystem", 1991, "Plataforma", "Sonic the Hedgehog")
add("mastersystem", 1985, "Arcade", "Hang-On", "TransBot")
add("mastersystem", 1989, "Ação", "R-Type", "Phantasy Star")

# --- Arcade / Neo Geo ---
add("arcade", 1980, "Arcade", "Pac-Man", "Galaga", "Donkey Kong")
add("arcade", 1981, "Arcade", "Frogger", "Ms. Pac-Man")
add("arcade", 1985, "Luta", "Karate Champ")
add("arcade", 1991, "Luta", "Street Fighter II")
add("arcade", 1992, "Luta", "Street Fighter II Turbo")
add("arcade", 1993, "Luta", "Mortal Kombat II", "Fatal Fury Special")
add("arcade", 1994, "Luta", "Killer Instinct", "The King of Fighters '94")
add("arcade", 1995, "Luta", "Tekken 2", "Virtua Fighter 2")
add("arcade", 1996, "Run & Gun", "Metal Slug", "Street Fighter Alpha 2")
add("arcade", 1997, "Ação", "Beatmania", "Marvel Super Heroes")
add("arcade", 1999, "Luta", "The King of Fighters '99", "Garou: Mark of the Wolves")
add("arcade", 2001, "Luta", "Street Fighter III: 3rd Strike")
add("neogeo", 1990, "Luta", "Fatal Fury", "Magician Lord")
add("neogeo", 1991, "Luta", "Fatal Fury 2", "Sengoku")
add("neogeo", 1992, "Luta", "Art of Fighting", "World Heroes")
add("neogeo", 1994, "Luta", "The King of Fighters '94", "Samurai Shodown II")
add("neogeo", 1996, "Run & Gun", "Metal Slug")
add("neogeo", 1997, "Luta", "The King of Fighters '97")
add("neogeo", 1999, "Luta", "Garou: Mark of the Wolves")
add("neogeo", 1998, "Luta", "The Last Blade 2")

# --- Outros ---
add("pcengine", 1989, "Ação", "Blazing Lazers", "Military Madness")
add("pcengine", 1990, "Ação", "Bonk's Adventure", "Devil's Crush")
add("pcengine", 1992, "Ação", "Air Zonk", "Lords of Thunder")
add("pcengine", 1993, "Ação", "Gate of Thunder", "Cotton")
add("atari2600", 1977, "Arcade", "Combat", "Surround")
add("atari2600", 1978, "Arcade", "Space Invaders", "Adventure")
add("atari2600", 1980, "Arcade", "Pac-Man", "Missile Command", "Warlords")
add("atari2600", 1981, "Arcade", "Pitfall!", "Asteroids", "Yars' Revenge")
add("atari2600", 1982, "Arcade", "River Raid", "Demon Attack")
add("wonderswan", 1999, "RPG", "Chocobo's Dungeon", "Gunpey")
add("wonderswan", 2000, "RPG", "Final Fantasy", "Digimon Adventure 02")
add("wonderswan", 2001, "RPG", "Final Fantasy II", "Makai Toushi SaGa")
add("msx", 1983, "Ação", "Antarctic Adventure", "Athletic Land")
add("msx", 1986, "Ação", "Metal Gear", "Vampire Killer")
add("msx", 1987, "Ação", "Metal Gear 2: Solid Snake", "Parodius")
add("msx", 1988, "RPG", "Snatcher", "Golvellius")

PALETTE = [
    ("#0b3d2e", "#3dffc0"),
    ("#1a3a5c", "#ffb14a"),
    ("#101828", "#6ecbff"),
    ("#3a1510", "#ff7a45"),
    ("#12324a", "#8ecbff"),
    ("#2a1040", "#ff5d9a"),
    ("#3a2a12", "#ffb14a"),
    ("#180818", "#ff4a5d"),
    ("#102818", "#3dffc0"),
    ("#281840", "#c07aff"),
]


def slug(title: str, platform: str) -> str:
    import re
    import unicodedata

    s = unicodedata.normalize("NFD", title.lower())
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return f"{platform}-{s}"


def main() -> None:
    seen: set[str] = set()
    games = []
    for i, (title, platform, year, genre) in enumerate(RAW):
        sid = slug(title, platform)
        if sid in seen:
            continue
        seen.add(sid)
        color = PALETTE[i % len(PALETTE)]
        games.append(
            {
                "id": sid,
                "title": title,
                "platform": platform,
                "year": year,
                "genre": genre,
                "color": list(color),
            }
        )

    out_js = Path(__file__).resolve().parents[1] / "js" / "games.js"
    payload = json.dumps(games, ensure_ascii=False, indent=2)
    out_js.write_text(
        f"// Catálogo curado Gattas Play — metadados only ({len(games)} títulos)\n"
        f"// ROMs reais vêm das pastas locais via launcher.\n"
        f"const CURATED_GAMES = {payload};\n",
        encoding="utf-8",
    )
    print(f"Wrote {len(games)} games -> {out_js}")


if __name__ == "__main__":
    main()
