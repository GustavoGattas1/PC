-----------------------------------------------------------------------------------------------------------------------------------------
-- BANCO DE DADOS — HISTÓRICO DE COMPRAS E EXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------

vRP.Prepare("loja_vip/CreatePurchases", [[
	CREATE TABLE IF NOT EXISTS loja_vip_purchases (
		id INT AUTO_INCREMENT PRIMARY KEY,
		passport INT NOT NULL,
		product_id VARCHAR(64) NOT NULL,
		product_name VARCHAR(128) NOT NULL,
		product_type VARCHAR(32) NOT NULL,
		price INT NOT NULL,
		currency VARCHAR(16) NOT NULL,
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		INDEX idx_passport (passport),
		INDEX idx_product (product_id)
	)
]])

vRP.Prepare("loja_vip/InsertPurchase", [[
	INSERT INTO loja_vip_purchases (passport, product_id, product_name, product_type, price, currency)
	VALUES (@passport, @product_id, @product_name, @product_type, @price, @currency)
]])

vRP.Prepare("loja_vip/GetPurchases", [[
	SELECT product_id, product_name, product_type, price, currency, created_at
	FROM loja_vip_purchases
	WHERE passport = @passport
	ORDER BY created_at DESC
	LIMIT @limit
]])

vRP.Prepare("loja_vip/CountProductPurchase", [[
	SELECT COUNT(*) AS total FROM loja_vip_purchases
	WHERE passport = @passport AND product_id = @product_id
]])

vRP.Prepare("loja_vip/CreateExtras", [[
	CREATE TABLE IF NOT EXISTS loja_vip_extras (
		passport INT NOT NULL,
		extra_type VARCHAR(64) NOT NULL,
		amount INT NOT NULL DEFAULT 0,
		PRIMARY KEY (passport, extra_type)
	)
]])

vRP.Prepare("loja_vip/AddExtra", [[
	INSERT INTO loja_vip_extras (passport, extra_type, amount)
	VALUES (@passport, @extra_type, @amount)
	ON DUPLICATE KEY UPDATE amount = amount + @amount
]])

vRP.Prepare("loja_vip/GetExtras", [[
	SELECT extra_type, amount FROM loja_vip_extras WHERE passport = @passport
]])

-- Veículos (padrão Creative Uncharted)
vRP.Prepare("loja_vip/VehicleExist", [[
	SELECT Passport FROM vehicles WHERE Passport = @Passport AND vehicle = @vehicle LIMIT 1
]])

vRP.Prepare("loja_vip/AddVehicle", [[
	INSERT IGNORE INTO vehicles (Passport, vehicle, plate, work, tax)
	VALUES (@Passport, @vehicle, @plate, @work, UNIX_TIMESTAMP() + 604800)
]])

-- Propriedades (padrão Creative Uncharted)
vRP.Prepare("loja_vip/PropertyOwner", [[
	SELECT Passport FROM propertys WHERE Name = @name LIMIT 1
]])

vRP.Prepare("loja_vip/BuyProperty", [[
	INSERT INTO propertys (Name, Passport, Interior, Tax)
	VALUES (@name, @passport, @interior, UNIX_TIMESTAMP() + 604800)
	ON DUPLICATE KEY UPDATE Passport = @passport
]])

CreateThread(function()
	vRP.Query("loja_vip/CreatePurchases", {})
	vRP.Query("loja_vip/CreateExtras", {})
end)

function Loja_DB_LogPurchase(Passport, Product)
	vRP.Query("loja_vip/InsertPurchase", {
		passport = Passport,
		product_id = Product.id,
		product_name = Product.name,
		product_type = Product.type,
		price = Product.price,
		currency = Product.currency or Config.DefaultCurrency
	})
end

function Loja_DB_GetHistory(Passport, Limit)
	return vRP.Query("loja_vip/GetPurchases", {
		passport = Passport,
		limit = Limit or 20
	}) or {}
end

function Loja_DB_CountPurchase(Passport, ProductId)
	local Result = vRP.Query("loja_vip/CountProductPurchase", {
		passport = Passport,
		product_id = ProductId
	})
	if Result and Result[1] then
		return tonumber(Result[1].total) or 0
	end
	return 0
end

function Loja_DB_AddExtra(Passport, ExtraType, Amount)
	vRP.Query("loja_vip/AddExtra", {
		passport = Passport,
		extra_type = ExtraType,
		amount = Amount
	})
end

function Loja_DB_GetExtras(Passport)
	return vRP.Query("loja_vip/GetExtras", { passport = Passport }) or {}
end
