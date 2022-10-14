QBCore = exports["qb-core"]:GetCoreObject()

local robbed = {}

RegisterNetEvent('kz-hrobbery:server:robbed', function(currentRobbery)
   table.insert(robbed, currentRobbery)
end)

QBCore.Functions.CreateCallback("kz-hrobbery:server:isitRobbed", function(source, cb, currentRobbery) 
    local src = source
    local isrobbed = false
    for k, value in pairs(robbed) do
        if currentRobbery == value then
            isrobbed = true
        end
    end
    cb(isrobbed)
end)

QBCore.Functions.CreateCallback("kz-hrobbery:server:gotItem", function(source, cb) 
    print(source)
    
    local Player = QBCore.Functions.GetPlayer(source)
    local lockpickQ = Player.Functions.GetItemByName('lockpick')
   cb(lockpickQ)

end)

RegisterNetEvent('kz-hrobbery:server:removeItem', function() 
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('lockpick', 1)
end)

RegisterNetEvent('kz-hrobbery:server:payCash', function(src, recieveMoney) 
    local Player = QBCore.Functions.GetPlayer(tonumber(source))
    Player.Functions.AddMoney(Config.MoneyType, recieveMoney, "found")
end)

Citizen.CreateThread(function()
	while true do 
		Wait(Config.Cooldown)
		for k, value in pairs(robbed) do
			table.remove(robbed, k)
		end 
	end
end)

RegisterNetEvent('kz-hrobbery:server:webhook', function(data)
    local webhook = Config.WebhookURL
    PerformHttpRequest(webhook, function(err, text, headers)  end, "POST", json.encode(data), {['Content-Type'] = 'application/json'})
end)
