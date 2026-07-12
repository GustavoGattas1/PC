-- Integração client-side — Hall Liberdade
-- Controle de acesso à interface e animações do tablet.

local currentAreaKey = nil
local uiAccessible = false
local hallReady = false

function CanAccessControllerInterface()
    return not IsEntityDead(PlayerPedId())
end

RegisterCommand('hall', function()
    if currentAreaKey and uiAccessible then
        TriggerServerEvent('cs-hall:integration:toggleControllerInterface', currentAreaKey)
    elseif config.debug then
        print('[hall-liberdade] Interface inacessível (fora da área ou bloqueada)', currentAreaKey, uiAccessible)
    end
end, false)

RegisterKeyMapping('hall', 'Abrir Hall Liberdade', 'keyboard', '')

RegisterKeyMapping('hall-liberdade-screen', 'Controle de Tela (Remoto)', 'keyboard', '')
RegisterKeyMapping('hall-liberdade-smoke', 'Ativar Fumaça (Remoto)', 'keyboard', '')
RegisterKeyMapping('hall-liberdade-sparklers', 'Ativar Faíscas (Remoto)', 'keyboard', '')

RegisterCommand('hall-liberdade-screen', function()
    if not currentAreaKey or not exports[GetCurrentResourceName()]:CanAccessRemoteControl() then
        return
    end

    TriggerServerEvent('cs-hall:triggerSetting', currentAreaKey, 'screenControl', true, exports[GetCurrentResourceName()]:IsUiEnabled())
end, false)

RegisterCommand('hall-liberdade-smoke', function()
    if not currentAreaKey or not exports[GetCurrentResourceName()]:CanAccessRemoteControl() then
        return
    end

    TriggerServerEvent('cs-hall:triggerSetting', currentAreaKey, 'triggerSmoke', true, exports[GetCurrentResourceName()]:IsUiEnabled())
end, false)

RegisterCommand('hall-liberdade-sparklers', function()
    if not currentAreaKey or not exports[GetCurrentResourceName()]:CanAccessRemoteControl() then
        return
    end

    TriggerServerEvent('cs-hall:triggerSetting', currentAreaKey, 'triggerSparklers', true, exports[GetCurrentResourceName()]:IsUiEnabled())
end, false)

AddEventHandler('cs-hall:onAreaEntered', function(areaKey)
    currentAreaKey = areaKey
end)

AddEventHandler('cs-hall:onAreaLeft', function(areaKey)
    currentAreaKey = nil
end)

AddEventHandler('cs-hall:ready', function()
    hallReady = true
end)

CreateThread(function()
    TriggerEvent('cs-hall:integrationReady')

    while true do
        if hallReady and CanAccessControllerInterface() ~= uiAccessible then
            uiAccessible = not uiAccessible
            TriggerEvent('cs-hall:setUiAccessible', uiAccessible)
        end

        Wait(500)
    end
end)

-- Tablet e animações
local tabletHandle = nil
local tabletAnimDict = 'amb@world_human_seat_wall_tablet@female@idle_a'
local tabletAnimName = 'idle_c'
local remoteAnimDict = 'anim@mp_player_intmenu@key_fob@'
local remoteAnimName = 'fob_click_fp'
local interfaceOpen = false

AddEventHandler('cs-hall:onControllerInterfaceOpen', function()
    interfaceOpen = true

    CreateThread(function()
        while interfaceOpen do
            DisablePlayerFiring(PlayerId())
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            Wait(0)
        end
    end)

    local playerPed = PlayerPedId()

    if not IsEntityPlayingAnim(playerPed, tabletAnimDict, tabletAnimName, 3) then
        RequestAnimDict(tabletAnimDict)
        RequestAnimDict(remoteAnimDict)

        while not HasAnimDictLoaded(tabletAnimDict) or not HasAnimDictLoaded(remoteAnimDict) do
            Wait(0)
        end

        TaskPlayAnim(playerPed, tabletAnimDict, tabletAnimName, 4.0, 4.0, -1, 49, 0, 0, 0, 0)
        Wait(175)

        tabletHandle = CreateObject(`hei_prop_dlc_tablet`, 0, 0, 0, true, true, false)
        AttachEntityToEntity(tabletHandle, playerPed, GetPedBoneIndex(playerPed, 18905), 0.12, 0.05, 0.13, -10.5, 180.0, 180.0, true, true, false, true, 1, true)
        TriggerServerEvent('cs-hall:integration:onControllerInterfaceObjectCreated', NetworkGetNetworkIdFromEntity(tabletHandle))
    end

    while interfaceOpen do
        playerPed = PlayerPedId()

        if not IsEntityPlayingAnim(playerPed, tabletAnimDict, tabletAnimName, 3) then
            TaskPlayAnim(playerPed, tabletAnimDict, tabletAnimName, 4.0, 4.0, -1, 49, 0, 0, 0, 0)
        end

        Wait(500)
    end
end)

AddEventHandler('cs-hall:onControllerInterfaceClose', function()
    interfaceOpen = false

    local playerPed = PlayerPedId()

    if IsEntityPlayingAnim(playerPed, tabletAnimDict, tabletAnimName, 3) then
        StopAnimTask(playerPed, tabletAnimDict, tabletAnimName, 4.0)
        Wait(75)
    end

    if tabletHandle then
        DeleteEntity(tabletHandle)
        tabletHandle = nil
    end
end)

AddEventHandler('cs-hall:onInterfacelessFeatureUsed', function(area, feature)
    if not tabletHandle then
        TaskPlayAnim(PlayerPedId(), remoteAnimDict, remoteAnimName, 4.0, 4.0, -1, 48, 1, false, false, false)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentServerEndpoint() == nil then
        return
    end

    if resource == GetCurrentResourceName() then
        local playerPed = PlayerPedId()

        if IsEntityPlayingAnim(playerPed, tabletAnimDict, tabletAnimName, 3) then
            StopAnimTask(playerPed, tabletAnimDict, tabletAnimName, 4.0)
        end

        if tabletHandle then
            DeleteEntity(tabletHandle)
        end
    end
end)
