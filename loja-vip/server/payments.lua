-----------------------------------------------------------------------------------------------------------------------------------------
-- MERCADO PAGO — PIX, Cartão e Webhook
-----------------------------------------------------------------------------------------------------------------------------------------

local PendingPolls = {}

local function MP_Enabled()
	return Config.MercadoPago
		and Config.MercadoPago.Enabled
		and Config.MercadoPago.AccessToken
		and Config.MercadoPago.AccessToken ~= ""
		and Config.MercadoPago.AccessToken ~= "SEU_ACCESS_TOKEN_AQUI"
end

local function MP_GenerateRef(Passport)
	return ("LV%s%s%s"):format(
		tostring(Passport),
		tostring(os.time()),
		tostring(math.random(1000, 9999))
	)
end

local function MP_IdempotencyKey()
	return ("lv-%s-%s"):format(os.time(), math.random(100000, 999999))
end

local function MP_Request(Method, Endpoint, Body, Callback)
	local MP = Config.MercadoPago
	local Url = "https://api.mercadopago.com" .. Endpoint
	local Headers = {
		["Authorization"] = "Bearer " .. MP.AccessToken,
		["Content-Type"] = "application/json",
		["X-Idempotency-Key"] = MP_IdempotencyKey()
	}

	PerformHttpRequest(Url, function(Code, Response)
		local Data = nil
		if Response and Response ~= "" then
			local Ok, Decoded = pcall(json.decode, Response)
			if Ok then Data = Decoded end
		end
		Callback(Code, Data, Response)
	end, Method, Body and json.encode(Body) or "", Headers)
end

local function MP_GetPayer(Passport)
	local Char = Loja_Bridge_GetCharacter(Passport)
	local First = "Jogador"
	local Last = tostring(Passport)

	if Char then
		if Char.name and Char.name ~= "" then First = Char.name end
		if Char.name2 and Char.name2 ~= "" then Last = Char.name2 end
	end

	return {
		email = Config.MercadoPago.DefaultPayerEmail,
		first_name = First,
		last_name = Last
	}
end

function MP_CreditDiamonds(Passport, Gems, Ref)
	local Payment = vRP.Query("loja_vip/GetMPPayment", { ref = Ref })
	if Payment and Payment[1] and Payment[1].status == "approved" then
		return false
	end

	if not Loja_Bridge_GiveGems(Passport, Gems) then
		return false
	end

	vRP.Query("loja_vip/UpdateMPPaymentStatus", {
		ref = Ref,
		status = "approved",
		paid_at = os.date("%Y-%m-%d %H:%M:%S")
	})

	Loja_DB_LogPurchase(Passport, {
		id = "mp_" .. Ref,
		name = Gems .. " Diamantes (Mercado Pago)",
		type = "diamonds",
		price = Gems,
		currency = "brl"
	})

	Loja_ClearPlayerCache(Passport)
	return true
end

function MP_ProcessApproval(Ref, MpId, Status)
	if Status ~= "approved" then return false end

	local Result = vRP.Query("loja_vip/GetMPPayment", { ref = Ref })
	if not Result or not Result[1] then return false end

	local Row = Result[1]
	if Row.status == "approved" then return true end

	local Passport = tonumber(Row.passport)
	local Gems = tonumber(Row.gems_amount) or 0
	if not Passport or Gems <= 0 then return false end

	if MP_CreditDiamonds(Passport, Gems, Ref) then
		local Source = vRP.Source(Passport)
		if Source then
			Loja_Notify(Source, "success", Config.Lang.PaymentApproved)
			TriggerClientEvent("loja-vip:PaymentApproved", Source, {
				ref = Ref,
				gems = Gems,
				balance = {
					gems = Loja_Bridge_GetGems(Passport),
					bank = Loja_Bridge_GetBank(Passport)
				}
			})
		end
		return true
	end

	return false
end

function MP_CheckPaymentStatus(Ref, Callback)
	local Result = vRP.Query("loja_vip/GetMPPayment", { ref = Ref })
	if not Result or not Result[1] then
		Callback({ success = false, status = "not_found" })
		return
	end

	local Row = Result[1]
	if Row.status == "approved" then
		Callback({
			success = true,
			status = "approved",
			balance = {
				gems = Loja_Bridge_GetGems(Row.passport),
				bank = Loja_Bridge_GetBank(Row.passport)
			}
		})
		return
	end

	local function Finish(Status, PayData)
		if Status == "approved" then
			MP_ProcessApproval(Ref, PayData and PayData.id or Row.mp_id, Status)
		elseif Status == "rejected" or Status == "cancelled" then
			vRP.Query("loja_vip/UpdateMPPaymentStatus", {
				ref = Ref,
				status = Status,
				paid_at = nil
			})
		end

		Callback({
			success = true,
			status = Status,
			balance = {
				gems = Loja_Bridge_GetGems(Row.passport),
				bank = Loja_Bridge_GetBank(Row.passport)
			}
		})
	end

	if Row.method == "card" then
		MP_Request("GET", "/v1/payments/search?external_reference=" .. Ref, nil, function(Code, Data)
			if Code == 200 and Data and Data.results and Data.results[1] then
				local Pay = Data.results[1]
				if Pay.id and Pay.id ~= Row.mp_id then
					vRP.Query("loja_vip/UpdateMPPaymentMpId", { ref = Ref, mp_id = tostring(Pay.id) })
				end
				Finish(Pay.status or "pending", Pay)
			else
				Callback({ success = true, status = Row.status or "pending" })
			end
		end)
		return
	end

	MP_Request("GET", "/v1/payments/" .. Row.mp_id, nil, function(Code, Data)
		if Code ~= 200 or not Data then
			Callback({ success = true, status = Row.status or "pending" })
			return
		end
		Finish(Data.status or "pending", Data)
	end)
end

function MP_CreatePixPayment(Passport, Product, Ref, Callback)
	local Amount = tonumber(Product.price_brl) or 0
	local Payer = MP_GetPayer(Passport)

	local Body = {
		transaction_amount = Amount,
		description = Product.name .. " — Loja VIP",
		payment_method_id = "pix",
		payer = Payer,
		external_reference = Ref
	}

	if Config.MercadoPago.NotificationUrl and Config.MercadoPago.NotificationUrl ~= "" then
		Body.notification_url = Config.MercadoPago.NotificationUrl
	end

	MP_Request("POST", "/v1/payments", Body, function(Code, Data)
		if Code ~= 201 or not Data or not Data.id then
			Loja_Debug("MP PIX erro:", Code, json.encode(Data or {}))
			Callback({ success = false, message = Config.Lang.MercadoPagoError })
			return
		end

		vRP.Query("loja_vip/InsertMPPayment", {
			ref = Ref,
			passport = Passport,
			product_id = Product.id,
			gems_amount = Product.data.gems,
			amount_brl = Amount,
			method = "pix",
			mp_id = tostring(Data.id),
			status = Data.status or "pending"
		})

		local PixData = {}
		if Data.point_of_interaction and Data.point_of_interaction.transaction_data then
			local Tx = Data.point_of_interaction.transaction_data
			PixData = {
				qr_code = Tx.qr_code,
				qr_code_base64 = Tx.qr_code_base64,
				ticket_url = Tx.ticket_url
			}
		end

		Callback({
			success = true,
			ref = Ref,
			method = "pix",
			mp_id = Data.id,
			status = Data.status or "pending",
			pix = PixData,
			amount_brl = Amount,
			gems_amount = Product.data.gems
		})
	end)
end

function MP_CreateCardPayment(Passport, Product, Ref, Callback)
	local Amount = tonumber(Product.price_brl) or 0
	local Payer = MP_GetPayer(Passport)

	local Body = {
		items = {
			{
				title = Product.name .. " — Loja VIP",
				quantity = 1,
				unit_price = Amount,
				currency_id = "BRL"
			}
		},
		payer = { email = Payer.email },
		external_reference = Ref,
		payment_methods = {
			installments = 12,
			excluded_payment_types = {
				{ id = "ticket" }
			}
		},
		auto_return = "approved"
	}

	if Config.MercadoPago.NotificationUrl and Config.MercadoPago.NotificationUrl ~= "" then
		Body.notification_url = Config.MercadoPago.NotificationUrl
	end

	MP_Request("POST", "/v1/checkout/preferences", Body, function(Code, Data)
		if Code ~= 201 or not Data or not Data.id then
			Loja_Debug("MP Card erro:", Code, json.encode(Data or {}))
			Callback({ success = false, message = Config.Lang.MercadoPagoError })
			return
		end

		vRP.Query("loja_vip/InsertMPPayment", {
			ref = Ref,
			passport = Passport,
			product_id = Product.id,
			gems_amount = Product.data.gems,
			amount_brl = Amount,
			method = "card",
			mp_id = tostring(Data.id),
			status = "pending"
		})

		local InitPoint = Data.init_point
		if Config.MercadoPago.Sandbox and Data.sandbox_init_point then
			InitPoint = Data.sandbox_init_point
		end

		Callback({
			success = true,
			ref = Ref,
			method = "card",
			mp_id = Data.id,
			status = "pending",
			checkout_url = InitPoint,
			amount_brl = Amount,
			gems_amount = Product.data.gems
		})
	end)
end

function MP_CreatePayment(Passport, ProductId, Method, Callback)
	if not MP_Enabled() then
		Callback({ success = false, message = Config.Lang.MercadoPagoDisabled })
		return
	end

	local Product = Loja_FindProduct(ProductId)
	if not Product or Product.type ~= "diamonds" or not Product.data or not Product.data.gems then
		Callback({ success = false, message = Config.Lang.ProductNotFound })
		return
	end

	Method = string.lower(Method or "pix")
	if Method ~= "pix" and Method ~= "card" then
		Method = "pix"
	end

	local Ref = MP_GenerateRef(Passport)

	if Method == "pix" then
		MP_CreatePixPayment(Passport, Product, Ref, Callback)
	else
		MP_CreateCardPayment(Passport, Product, Ref, Callback)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK HTTP
-----------------------------------------------------------------------------------------------------------------------------------------
SetHttpHandler(function(Request, Response)
	local Path = Request.path or ""

	if Path ~= "/loja-vip/webhook" and not string.find(Path, "loja%-vip/webhook") then
		Response.writeHead(404)
		Response.send("")
		return
	end

	if Request.method == "GET" then
		local Query = Request.query or {}
		local Topic = Query.topic or Query.type
		local MpId = Query.id or Query["data.id"]

		if Topic == "payment" and MpId then
			MP_Request("GET", "/v1/payments/" .. MpId, nil, function(Code, Data)
				if Code == 200 and Data and Data.external_reference and Data.status == "approved" then
					MP_ProcessApproval(Data.external_reference, MpId, Data.status)
				end
			end)
		end

		Response.writeHead(200)
		Response.send("OK")
		return
	end

	if Request.method == "POST" then
		Request.setDataHandler(function(Body)
			local Data = nil
			if Body and Body ~= "" then
				pcall(function() Data = json.decode(Body) end)
			end

			local MpId = nil
			if Data then
				MpId = Data.data and Data.data.id or Data.id
			end

			local Query = Request.query or {}
			if not MpId then MpId = Query.id or Query["data.id"] end

			if MpId then
				MP_Request("GET", "/v1/payments/" .. MpId, nil, function(Code, PayData)
					if Code == 200 and PayData and PayData.external_reference and PayData.status == "approved" then
						MP_ProcessApproval(PayData.external_reference, MpId, PayData.status)
					end
				end)
			end

			Response.writeHead(200)
			Response.send("OK")
		end)
		return
	end

	Response.writeHead(405)
	Response.send("")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- POLL AUTOMÁTICO DE PAGAMENTOS PENDENTES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(Config.MercadoPago.PollInterval or 8000)

		if not MP_Enabled() then goto continue end

		local Pending = vRP.Query("loja_vip/GetPendingMPPayments", {})
		if Pending then
			for _, Row in ipairs(Pending) do
				if Row.mp_id and Row.ref then
					MP_CheckPaymentStatus(Row.ref, function() end)
				end
			end
		end

		::continue::
	end
end)
