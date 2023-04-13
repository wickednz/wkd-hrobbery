QBCore = exports["qb-core"]:GetCoreObject()
local WKD = exports["wkd-utils"]:utils()

local robbed = {}

RegisterNetEvent('kz-hrobbery:server:robbed', function(currentRobbery)
   table.insert(robbed, currentRobbery)
end)

function dump(o)
	if type(o) == 'table' then
	   local s = ''
	   for k,v in pairs(o) do
		  s = s .. dump(v)
	   end
	   return s .. ' '
	else
	   return tostring(o)
	end
end

function createDrop(itemTable, coords)
    local dropItems = {}

    for item, qty in pairs(itemTable) do 
        dropItems[#dropItems+1] = {item, qty}
    end

    exports.ox_inventory:CustomDrop('Robbery Items', dropItems, coords)
end

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

RegisterNetEvent('wkd-hrobbery:server:giveItems', function(source, itemTable, coords)

    if not Config.drop then 
        for item, qty in pairs(itemTable) do 
            local success, response = exports.ox_inventory:AddItem(source, item, qty)
            if not success then
                return print(response)
            end
        end
    else
        createDrop(itemTable, coords)
    end
 
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
