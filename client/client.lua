ESX = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if ESX == nil then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end
end)

local CurrentPings = {}
local PingActive = false

RegisterNetEvent('cm-ping:client:DoPing')
AddEventHandler('cm-ping:client:DoPing', function(id) 
    local player = GetPlayerFromServerId(id)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    print(pos)
    local coords = {
        x = pos.x,
        y = pos.y,
        z = pos.z,
    }
    TriggerServerEvent('cm-ping:server:SendPing', id, coords)
end)


RegisterNetEvent('cm-ping:client:AcceptPing')
AddEventHandler('cm-ping:client:AcceptPing', function(PingData, SenderData) 
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    TriggerServerEvent('cm-ping:server:SendLocation', PingData, SenderData)
end)

RegisterNetEvent('cm-ping:client:SendLocation')
AddEventHandler('cm-ping:client:SendLocation', function(PingData, SenderData)
    exports['mythic_notify']:SendAlert('inform', 'The location has been set on your GPS.')
    PingActive = true
    CurrentPings[PingData.sender] = AddBlipForCoord(PingData.coords.x, PingData.coords.y, PingData.coords.z)
    --CurrentPings[PingData.sender] = AddBlipForCoord(114.72, -998.65, 29.4)
    SetBlipSprite(CurrentPings[PingData.sender], 280)
    SetBlipDisplay(CurrentPings[PingData.sender], 4)
    SetBlipScale(CurrentPings[PingData.sender], 1.1)
    SetBlipAsShortRange(CurrentPings[PingData.sender], false)
    SetBlipColour(CurrentPings[PingData.sender], 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Ping")
    EndTextCommandSetBlipName(CurrentPings[PingData.sender])
    while PingActive do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, PingData.coords.x, PingData.coords.y, PingData.coords.z, true) < 5.0 then
            exports['mythic_notify']:SendAlert('inform', 'You have arrived at your destination')
            RemoveBlip(CurrentPings[PingData.sender])
            PingActive = false
        end
    end
end)
