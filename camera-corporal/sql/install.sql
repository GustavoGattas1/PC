-- Câmera Corporal Policial — Instalação do banco de dados
-- Execute no MariaDB/MySQL da sua base Creative Uncharted

CREATE TABLE IF NOT EXISTS `bcc_sessions` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`session_id` VARCHAR(32) NOT NULL,
	`passport` INT(11) NOT NULL,
	`officer_name` VARCHAR(128) NOT NULL,
	`unit` VARCHAR(64) DEFAULT NULL,
	`badge` VARCHAR(32) DEFAULT NULL,
	`started_at` DATETIME NOT NULL,
	`ended_at` DATETIME DEFAULT NULL,
	`duration` INT(11) DEFAULT 0,
	`event_count` INT(11) DEFAULT 0,
	`bookmark_count` INT(11) DEFAULT 0,
	`battery_start` FLOAT DEFAULT 100,
	`battery_end` FLOAT DEFAULT 0,
	`metadata` LONGTEXT DEFAULT NULL,
	`status` VARCHAR(16) DEFAULT 'active',
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `session_id` (`session_id`),
	KEY `passport` (`passport`),
	KEY `started_at` (`started_at`),
	KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bcc_events` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`session_id` VARCHAR(32) NOT NULL,
	`event_type` VARCHAR(32) NOT NULL,
	`label` VARCHAR(255) NOT NULL,
	`coords` VARCHAR(64) DEFAULT NULL,
	`street` VARCHAR(128) DEFAULT NULL,
	`speed` FLOAT DEFAULT NULL,
	`weapon_hash` INT(11) DEFAULT NULL,
	`metadata` LONGTEXT DEFAULT NULL,
	`elapsed` INT(11) DEFAULT 0,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	KEY `session_id` (`session_id`),
	KEY `event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bcc_bookmarks` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`bookmark_id` VARCHAR(32) NOT NULL,
	`session_id` VARCHAR(32) NOT NULL,
	`passport` INT(11) NOT NULL,
	`label` VARCHAR(255) DEFAULT 'Incidente marcado',
	`coords` VARCHAR(64) DEFAULT NULL,
	`street` VARCHAR(128) DEFAULT NULL,
	`elapsed` INT(11) DEFAULT 0,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `bookmark_id` (`bookmark_id`),
	KEY `session_id` (`session_id`),
	KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
