-- IML / Evidências - Instalação do banco de dados
-- Execute no MariaDB/MySQL da sua base Creative Uncharted

CREATE TABLE IF NOT EXISTS `iml_evidence` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`evidence_id` VARCHAR(64) NOT NULL,
	`type` VARCHAR(32) NOT NULL,
	`passport` INT(11) DEFAULT NULL,
	`weapon_hash` INT(11) DEFAULT NULL,
	`weapon_serial` VARCHAR(32) DEFAULT NULL,
	`coords` TEXT DEFAULT NULL,
	`metadata` LONGTEXT DEFAULT NULL,
	`collected_by` INT(11) DEFAULT NULL,
	`collected_at` DATETIME DEFAULT NULL,
	`analyzed` TINYINT(1) DEFAULT 0,
	`analyzed_by` INT(11) DEFAULT NULL,
	`analyzed_at` DATETIME DEFAULT NULL,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `evidence_id` (`evidence_id`),
	KEY `passport` (`passport`),
	KEY `type` (`type`),
	KEY `weapon_serial` (`weapon_serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `iml_reports` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`report_id` VARCHAR(64) NOT NULL,
	`type` VARCHAR(32) NOT NULL,
	`victim_passport` INT(11) DEFAULT NULL,
	`author_passport` INT(11) NOT NULL,
	`title` VARCHAR(128) NOT NULL,
	`content` LONGTEXT NOT NULL,
	`evidence_ids` TEXT DEFAULT NULL,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `report_id` (`report_id`),
	KEY `victim_passport` (`victim_passport`),
	KEY `author_passport` (`author_passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `iml_bodies` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`body_id` VARCHAR(64) NOT NULL,
	`victim_passport` INT(11) NOT NULL,
	`victim_name` VARCHAR(128) NOT NULL,
	`cause` VARCHAR(255) DEFAULT 'Causa indeterminada',
	`killer_passport` INT(11) DEFAULT NULL,
	`weapon_hash` INT(11) DEFAULT NULL,
	`weapon_serial` VARCHAR(32) DEFAULT NULL,
	`ammo_type` VARCHAR(32) DEFAULT NULL,
	`metadata` LONGTEXT DEFAULT NULL,
	`collected_by` INT(11) NOT NULL,
	`autopsy_done` TINYINT(1) DEFAULT 0,
	`autopsy_by` INT(11) DEFAULT NULL,
	`report_id` VARCHAR(64) DEFAULT NULL,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `body_id` (`body_id`),
	KEY `victim_passport` (`victim_passport`),
	KEY `killer_passport` (`killer_passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `iml_fingerprints` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`passport` INT(11) NOT NULL,
	`fingerprint_hash` VARCHAR(64) NOT NULL,
	`registered_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `iml_dna` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`passport` INT(11) NOT NULL,
	`dna_code` VARCHAR(64) NOT NULL,
	`registered_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `iml_weapon_registry` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`passport` INT(11) NOT NULL,
	`weapon_hash` INT(11) NOT NULL,
	`weapon_serial` VARCHAR(32) NOT NULL,
	`ammo_type` VARCHAR(32) DEFAULT NULL,
	`registered_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `weapon_serial` (`weapon_serial`),
	KEY `passport` (`passport`),
	KEY `weapon_hash` (`weapon_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `iml_death_records` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`record_id` VARCHAR(64) NOT NULL,
	`victim_passport` INT(11) NOT NULL,
	`killer_passport` INT(11) DEFAULT NULL,
	`weapon_hash` INT(11) DEFAULT NULL,
	`weapon_serial` VARCHAR(32) DEFAULT NULL,
	`ammo_type` VARCHAR(32) DEFAULT NULL,
	`ammo_label` VARCHAR(64) DEFAULT NULL,
	`cause_of_death` VARCHAR(255) DEFAULT NULL,
	`bone_hit` VARCHAR(64) DEFAULT NULL,
	`distance` FLOAT DEFAULT 0,
	`headshot` TINYINT(1) DEFAULT 0,
	`coords` TEXT DEFAULT NULL,
	`time_of_death` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`examined` TINYINT(1) DEFAULT 0,
	`bagged` TINYINT(1) DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE KEY `record_id` (`record_id`),
	KEY `victim_passport` (`victim_passport`),
	KEY `killer_passport` (`killer_passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
