local QBCore = exports['qb-core']:GetCoreObject()
local maxPoints = 10

-- Remove Points
RegisterNetEvent('points:server:removePoints', function(identifier, pointsToBeRemoved)
    local src = source
    local id = identifier
    local points = pointsToBeRemoved
    local citizenid = QBCore.Functions.GetPlayer(id).PlayerData.citizenid
    local hasPoints = false

    if QBCore.Functions.GetPlayer(id).PlayerData.job.name == "police" then
        local pointsFound = MySQL.Sync.prepare("SELECT Points from points WHERE citizenid = ?", { citizenid })

        if pointsFound then
            hasPoints = true
        else
            hasPoints = false
        end

        if hasPoints then
            local pointsFound = MySQL.Sync.fetchScalar("SELECT Points from points WHERE citizenid = ?", { citizenid })
            local newPoints = pointsFound - points

            if newPoints < 0 then
                newPoints = 0
            end

            MySQL.Async.execute("DELETE FROM points WHERE citizenid = ?", { citizenid })
            MySQL.Sync.insert("INSERT INTO points (citizenid, Points) VALUES (?, ?)", { citizenid, newPoints })
            TriggerClientEvent('QBCore:Notify', src, 'Removed ' .. points .. ' points.', 'success', 3000)
        else
            TriggerClientEvent('QBCore:Notify', src, 'No points found!', 'error', 2000)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not an officer!', 2000)
    end
end)


-- Add Points
RegisterNetEvent('points:server:addPoints', function(identifier, pointsToBeAdded)
    local src = source
    local id = QBCore.Functions.GetPlayer(identifier).PlayerData.citizenid
    local hasPoints = false

    if QBCore.Functions.GetPlayer(identifier).PlayerData.job.name == "police" then
        local points = MySQL.Sync.prepare("SELECT Points from points WHERE citizenid = ?", { id })

        if points then
            hasPoints = true
        else
            hasPoints = false
        end

        if hasPoints then
            local points = MySQL.Sync.fetchScalar("SELECT Points from points WHERE citizenid = ?", { id })
            local newPoints = pointsToBeAdded + points
            MySQL.Async.execute("DELETE FROM points WHERE citizenid = ?", { id })
            MySQL.Sync.insert("INSERT INTO points (citizenid, Points) VALUES (?, ?)", { id, newPoints })
        else
            MySQL.Sync.insert("INSERT INTO points (citizenid, Points) VALUES (?, ?)", { id, pointsToBeAdded })
        end
        local currentPoints = MySQL.Sync.fetchScalar("SELECT Points from points WHERE citizenid = ?", { id })
        if maxPoints <= currentPoints then
            TriggerClientEvent('QBCore:Notify', src, "This person has the maximum amount of points!  Revoke that license!", "error", 5000)
        else
            TriggerClientEvent('QBCore:Notify', src, "Added " .. pointsToBeAdded .. " points.", "success")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You are not an officer.", "error", 2000)
    end
end)


-- Get Points
RegisterNetEvent("points:server:getPoints", function(identifier)
    local src = source
    local id = QBCore.Functions.GetPlayer(identifier).PlayerData.citizenid
    local result = MySQL.Sync.prepare("SELECT Points from points WHERE citizenid = ?", { id })

    TriggerClientEvent('QBCore:Notify', src, "This person has " .. result .. " points.", "success", 2000)
end)
