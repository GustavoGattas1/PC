-- Tabelas criadas automaticamente via vRP.Prepare em server/database.lua
-- Execute este SQL manualmente apenas se preferir instalação antecipada:

CREATE TABLE IF NOT EXISTS `loja_vip_purchases` (
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`passport` INT NOT NULL,
	`product_id` VARCHAR(64) NOT NULL,
	`product_name` VARCHAR(128) NOT NULL,
	`product_type` VARCHAR(32) NOT NULL,
	`price` INT NOT NULL,
	`currency` VARCHAR(16) NOT NULL,
	`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	INDEX `idx_passport` (`passport`),
	INDEX `idx_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `loja_vip_extras` (
	`passport` INT NOT NULL,
	`extra_type` VARCHAR(64) NOT NULL,
	`amount` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`passport`, `extra_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
