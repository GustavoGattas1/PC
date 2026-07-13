-----------------------------------------------------------------------------------------------------------------------------------------
-- PROP DA CÂMERA CORPORAL NO PEITO
-----------------------------------------------------------------------------------------------------------------------------------------

local BodycamProp = nil

function BCC_AttachProp()
	if not Config.Prop.Enabled then return end
	if BodycamProp and DoesEntityExist(BodycamProp) then return end

	local Ped = PlayerPedId()
	local Model = Config.Prop.Model

	RequestModel(Model)
	local Timeout = GetGameTimer() + 5000
	while not HasModelLoaded(Model) and GetGameTimer() < Timeout do
		Wait(10)
	end

	if not HasModelLoaded(Model) then return end

	BodycamProp = CreateObject(Model, 0.0, 0.0, 0.0, true, true, false)
	local Bone = GetPedBoneIndex(Ped, Config.Prop.Bone)
	local Offset = Config.Prop.Offset
	local Rotation = Config.Prop.Rotation

	AttachEntityToEntity(
		BodycamProp, Ped, Bone,
		Offset.x, Offset.y, Offset.z,
		Rotation.x, Rotation.y, Rotation.z,
		true, true, false, true, 1, true
	)

	SetModelAsNoLongerNeeded(Model)
end

function BCC_RemoveProp()
	if BodycamProp and DoesEntityExist(BodycamProp) then
		DeleteEntity(BodycamProp)
	end
	BodycamProp = nil
end

function BCC_HasProp()
	return BodycamProp ~= nil and DoesEntityExist(BodycamProp)
end

AddEventHandler("onResourceStop", function(Resource)
	if Resource == GetCurrentResourceName() then
		BCC_RemoveProp()
	end
end)
