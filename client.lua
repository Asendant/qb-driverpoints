local QBCore = exports['qb-core']:GetCoreObject()

-- Remove Points Command
RegisterCommand('removepoints', function(args)
    local id = tonumber(args[1])
    local points = tonumber(args[2])
    TriggerServerEvent('points:server:removePoints', id, points)
end)

-- Events
RegisterNetEvent('points:client:removedPoints', function(points)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { '[MDT]', 'Removed ' .. points .. ' points.' }
    })
end)

RegisterNetEvent('points:client:noPointsFound', function()
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { '[MDT]', 'No points found.' }
    })
end)


-- Add points command
RegisterCommand('addpoints', function(source, args)
    local id = tonumber(args[1])
    local points = tonumber(args[2])
    TriggerServerEvent('points:server:addPoints', id, points)
end)



-- Get Points Command
-- Command
RegisterCommand('getpoints', function(source, id)
    local src = source
    local id = tonumber(id[1])

    TriggerServerEvent('points:server:getPoints', id)
end)

-- Events
RegisterNetEvent('points:client:returnPoints', function(points)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { '[MDT]', 'This person has ' .. points .. ' points.' }
    })
end)


-- Global Events
RegisterNetEvent('points:client:notAOfficer', function()
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { '[ERROR]', 'You are not an officer.' }
    })
end)
