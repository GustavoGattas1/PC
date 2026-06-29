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
	KEY `type` (`type`)
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
	`cause` VARCHAR(128) DEFAULT 'Causa indeterminada',
	`collected_by` INT(11) NOT NULL,
	`autopsy_done` TINYINT(1) DEFAULT 0,
	`autopsy_by` INT(11) DEFAULT NULL,
	`report_id` VARCHAR(64) DEFAULT NULL,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `body_id` (`body_id`),
	KEY `victim_passport` (`victim_passport`)
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
