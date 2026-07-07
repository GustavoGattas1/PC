-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILITÁRIOS COMPARTILHADOS
-----------------------------------------------------------------------------------------------------------------------------------------

function VP_Debug(...)
	if Config.Debug then
		print("[vehicle-photos]", ...)
	end
end

function VP_NotifyClient(Type, Message, Duration)
	local Info = Config.Notify
	TriggerEvent("Notify", Info.Title, Message, Info[Type] or Info.Info, Duration or 5000)
end

function VP_NotifyServer(Source, Type, Message, Duration)
	local Info = Config.Notify
	TriggerClientEvent("Notify", Source, Info.Title, Message, Info[Type] or Info.Info, Duration or 5000)
end

function VP_NormalizeModel(Model)
	if not Model then return nil end
	return string.lower(tostring(Model)):gsub("%s+", "")
end

function VP_MergeModels(Target, Source)
	local Seen = {}
	for i = 1, #Target do
		Seen[Target[i]] = true
	end

	for i = 1, #Source do
		local Model = VP_NormalizeModel(Source[i])
		if Model and not Seen[Model] then
			Target[#Target + 1] = Model
			Seen[Model] = true
		end
	end

	return Target
end

function VP_SortModels(Models)
	table.sort(Models)
	return Models
end
