ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local Pings = {}

RegisterCommand("ping", function(source, args, rawCommand) 
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local task = args[1]
    if task == "accept" then
        if Pings[src] ~= nil then
            TriggerClientEvent('cm-ping:client:AcceptPing', src, Pings[src], ESX.GetPlayerFromId(Pings[src].sender))
            Pings[src] = nil
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text= 'You dont have a ping open..'})
        end
    elseif task == "deny" then
        if Pings[src] ~= nil then
            TriggerClientEvent('mythic_notify:client:SendAlert', Pings[src].sender, {type = 'error', text = "Your ping has been rejected.."})
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text='Ping rejected...'})
            Pings[src] = nil
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = 'You dont have a ping open..'})
        end
    else
        TriggerClientEvent('cm-ping:client:DoPing', src, tonumber(args[1]))
    end
end)

RegisterServerEvent('cm-ping:server:SendPing')
AddEventHandler('cm-ping:server:SendPing', function(id, coords) 
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local Target = ESX.GetPlayerFromId(id)
    if (Target == nil and Target == -1) then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = 'The ID is invalid'})
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'inform', text = 'You sent a ping to ' .. Target.getName()})
        Pings[id] = {
            coords = coords,
            sender = src,
        }
        TriggerClientEvent('mythic_notify:client:SendAlert', id, {type = 'inform', text = 'You recived a ping from ' .. Player.getName()})
    end
end)

RegisterServerEvent('cm-ping:server:SendLocation')
AddEventHandler('cm-ping:server:SendLocation', function(PingData, SenderData) 
    TriggerClientEvent('cm-ping:client:SendLocation', PingData.sender, PingData, SenderData)
end)