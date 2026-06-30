-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITÁRIOS COMPARTILHADOS
-----------------------------------------------------------------------------------------------------------------------------------------

function Loja_FindProduct(ProductId)
	for _, Product in ipairs(Config.Products) do
		if Product.id == ProductId then
			return Product
		end
	end
	return nil
end

function Loja_GetProductsByCategory(CategoryId)
	if not CategoryId or CategoryId == "all" then
		return Config.Products
	end

	local Filtered = {}
	for _, Product in ipairs(Config.Products) do
		if Product.category == CategoryId then
			Filtered[#Filtered + 1] = Product
		end
	end
	return Filtered
end

function Loja_SanitizeProduct(Product)
	return {
		id = Product.id,
		category = Product.category,
		type = Product.type,
		name = Product.name,
		description = Product.description,
		price = Product.price,
		currency = Product.currency or Config.DefaultCurrency,
		badge = Product.badge,
		benefits = Product.benefits,
		originalPrice = Product.originalPrice
	}
end

function Loja_SanitizeCatalog()
	local Catalog = {
		categories = Config.Categories,
		products = {}
	}

	for _, Product in ipairs(Config.Products) do
		Catalog.products[#Catalog.products + 1] = Loja_SanitizeProduct(Product)
	end

	return Catalog
end

function Loja_HasGroup(Passport, Groups)
	if not Groups then return true end
	if type(Groups) == "string" then Groups = { Groups } end

	for _, Group in ipairs(Groups) do
		if vRP and vRP.HasGroup(Passport, Group) then
			return true
		end
	end
	return false
end

function Loja_Notify(Source, Key, Message, Time)
	local Notify = Config.Notify[Key] or Config.Notify.info
	TriggerClientEvent("Notify", Source, Notify.Title, Message or "", Notify.Color, Time or 5000)
end

function Loja_Debug(...)
	if Config.Debug then
		print("[loja-vip]", ...)
	end
end
