-- Integração server-side — Hall Liberdade
-- Permissões de acesso ao controle do palco.

function CanAccessControllerInterface(source, area)
    return true
end

RegisterNetEvent('cs-hall:integration:toggleControllerInterface', function(area)
    local source = source

    if CanAccessControllerInterface(source, area) then
        TriggerEvent('cs-hall:toggleControllerInterface', source, area)
    else
        if config.debug then
            print('[hall-liberdade] Acesso negado', source, area)
        end

        TriggerEvent('cs-hall:disallowControllerInterface', source)
    end
end)

local activeControllerInterfaceObjects = {}

RegisterNetEvent('cs-hall:integration:onControllerInterfaceObjectCreated', function(objectNetId)
    local source = source
    activeControllerInterfaceObjects[source] = objectNetId
end)

AddEventHandler('playerDropped', function(reason)
    local source = source

    if activeControllerInterfaceObjects[source] then
        local entity = NetworkGetEntityFromNetworkId(activeControllerInterfaceObjects[source])

        if entity > 0 and DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        activeControllerInterfaceObjects[source] = nil
    end
end)

-- Exports disponíveis (via eventos cs-hall internos):
-- exports['hall-liberdade']:Play('liberdade')
-- exports['hall-liberdade']:Pause('liberdade')
-- exports['hall-liberdade']:Stop('liberdade')
-- exports['hall-liberdade']:IsPlaying('liberdade')
-- exports['hall-liberdade']:SetLoop('liberdade', true)
-- exports['hall-liberdade']:AddToQueue('liberdade', url, thumb, thumbTitle, title, icon, duration)
-- exports['hall-liberdade']:QueueNow('liberdade', position)
-- exports['hall-liberdade']:RemoveFromQueue('liberdade', position)
-- exports['hall-liberdade']:GetPlayer('liberdade')
-- exports['hall-liberdade']:GetQueue('liberdade')
