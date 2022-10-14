QBCore = exports["qb-core"]:GetCoreObject()

--Variables
local robberyStarted = false
local nobodyhome = false
local currentRobbery = nil
local hasMoved = false
local hasBeenRobbed = false
local searching = false
local itemTable = Config.findableItems
local pedTable = Config.pedModel
local testing = true 
local moneyRecvd = 0
local success = nil

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

function MonitorPOS()
	CreateThread(function() -- Thread to check if you have moved away from an active robbery update variable
		while robberyStarted do
			Wait(500)
			if currentRobbery ~= nil then 
				local pos = GetEntityCoords(PlayerPedId())
				local difference = #(pos - currentRobbery)   
				if difference > 7 then
					hasMoved = true
					KZNotify("You have moved too far away, robbery cancelled")
					robberyStarted = false
					currentRobbery = nil
					hasMoved = false
				else
					hasMoved = false
				end
			end
		end
	end)
end

function generateRandomPed()
	local itemchance = math.random(1 , 2)
	if chance == 1 then 
		nobodyhome = true
	elseif chance == 2 then 
		nobodyhome = false
	elseif chance == 3 then 
		nobodyhome = true
	end
	randomped = pedTable[math.random(1, #pedTable)]
	RequestModel(randomped)    
end

function checkStatus()
	QBCore.Functions.TriggerCallback("kz-hrobbery:server:isitRobbed", function(cb)
		if cb == true then
			hasBeenRobbed = true
		else
			hasBeenRobbed = false
		end
	end, currentRobbery)
end

function webhookPost(item)
	local Player = QBCore.Functions.GetPlayerData()
	local name = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname
	local citizenid = Player.citizenid
	local s1 = GetStreetNameAtCoord(currentRobbery.x, currentRobbery.y, currentRobbery.z)
	local streetLabel = GetStreetNameFromHashKey(s1)
	local iteminfo = ' '

	if item ~= nil and type(item) == 'table' then 
		iteminfo = dump(item)
	else
		iteminfo = 'Nothing'
	end
		
	local data = {
		["embeds"] = {{ 
			color = 16776960;
			title = 'House Robbery';
			fields = {
				{
					name = "Thief",
					value = name,
					inline = true
				},
				{
					name = "Citizen ID",
					value = citizenid,
					inline = true
				},
				{
					name = "Location",
					value = streetLabel,
					inline = true
				},
				{
					name = "Items Taken",
					value = iteminfo,
					inline = true
				},
				{
					name = "Money Taken",
					value = '$' .. tostring(moneyRecvd),
					inline = true
				},
			};
			footer = {
				["text"] = 'kz-houserobbery';
				};
			}};
		["content"] = '';
		avatar_url = "";
	};
	
	TriggerServerEvent('kz-hrobbery:server:webhook', data)
	moneyRecvd = 0
end

function findMoney(amount)
	TriggerServerEvent('kz-hrobbery:server:payCash', src, amount)
	KZNotify("Found $" .. amount, "success")
	moneyRecvd = amount
end

function lockpickdone(locksuccess)
	
	print(locksuccess)
	if not locksuccess then 
		if Config.removeLockpickOnFail then 
			TriggerServerEvent('kz-hrobbery:server:removeItem')
		end
	end
	
	success = locksuccess
	
	Wait(5000)
	minigameStarted = false
	success = nil
end

function checkHasItem()
	QBCore.Functions.TriggerCallback('kz-hrobbery:server:gotItem', function(lockpickQ) 
		if lockpickQ ~= nil and lockpickQ.amount >= 1 then 
			minigameStarted = true 
			TriggerEvent('qb-lockpick:client:openLockpick', lockpickdone)
		else
			KZNotify('You do not have the correct supplies', 'error', 5000)
			success = false
		end
	end) 
end

function startRobbery(location, name) 
	local src = source
    local ped = PlayerPedId()
	local playerHeading = GetEntityHeading(ped)
    local chance = math.random(1 , 9)
	local zoneName = tostring(name)
	local nobodyhome = true

	if not hasBeenRobbed then 
		
		checkHasItem()

		while success == nil do
			Wait(50)
		end

		if success then 
			
			KZRobberyStarted(location)
			MonitorPOS()
			TriggerServerEvent('kz-hrobbery:server:robbed', currentRobbery)
			
			--if nobodyhome == false then --Spawn a ped.
			if not testing then 
				robberyStarted = true
				local angryPed = CreatePed(0, randomped, location.x, location.y, location.z, playerHeading - 180.00, true, true)   
				TaskCombatPed(angryPed, ped, 0, 16)
				if chance == 1 then -- Give ped a knife
					GiveWeaponToPed(angryPed, 0x92A27487, 1, false, true)
				elseif chance == 2 then --Give ped a gun
					GiveWeaponToPed(angryPed, 0x1B06D571, 30, false, true)
				elseif chance == 3 then --give ped a bat
					GiveWeaponToPed(angryPed, 0x958A4A8F, 1, false, true)  
				elseif chance == 4 then --give ped a broken bottle
					GiveWeaponToPed(angryPed, 0xF9E6AA4B, 1, false, true)  
				elseif chance == 5 then --Give ped a hammer
					GiveWeaponToPed(angryPed, 0x4E875F73, 1, false, true)  
				elseif chance == 6 then --Give ped a golfclub
					GiveWeaponToPed(angryPed, 0x440E4788, 1, false, true)  
				elseif chance == 7 then --Give ped a hatchet
					GiveWeaponToPed(angryPed, 0xF9DCBF2D, 1, false, true)  
				elseif chance == 8 then --Give ped a fist
					GiveWeaponToPed(angryPed, 0xA2719263, 1, false, true)
				elseif chance == 9 then --give ped a poolcue
					GiveWeaponToPed(angryPed, 0x94117305, 1, false, true)  
				end  
			elseif nobodyhome == true then
				robberyStarted = true
				KZNotify("No one is home")
			end 
		else
			robberyStarted = false
			KZNotify('Robbery Failed', 'error', 5000)
		end
	else
		KZNotify('This place has already been hit', 'error', 5000)
	end
end

function startSearching()
	local ped = PlayerPedId()
	local searchTime = Config.SearchTime
    
	searching = true 
	
	QBCore.Functions.Progressbar("repair_vehicle", "Searching...", searchTime, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
		searching = false
		robberyStarted = false
		giveRandomItems()
	end, function() -- Cancel
		StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
		KZNotify("Failed", "error")
		searching = false
		robberyStarted = false
		currentRobbery = nil 
	end)
end

function giveRandomItems()
	local recieveItemChance = Config.recieveItemChance
	local itemstoReceive = {}
	
	if Config.chancePercentage == 100 then 
		for i = 1, recieveItemChance do
			local randomItem = itemTable[math.random(1, #itemTable)]
			table.insert(itemstoReceive, {randomItem})
		end
		local recieveMoney = math.random(0 , Config.maxMoney)
		if recieveMoney >= 1 then 
			findMoney(recieveMoney)
		end
	elseif Config.chancePercentage == 75 then 
		for i = 1, recieveItemChance do 
			local itemchance = math.random(1, 3)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if itemchance == 2 or chance == 3 then
				table.insert(itemstoReceive, {randomItem})
			end
		end
		local moneychance = math.random(1, 3)
		local recieveMoney = math.random(0 , Config.maxMoney)
		if recieveMoney >= 1 and moneychance == 2 or moneychance == 3 then
			findMoney(recieveMoney)
		end
		
	elseif Config.chancePercentage == 50 then 
		for i = 1, recieveItemChance do 
			local itemchance = math.random(1, 2)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if itemchance == 1 then
				table.insert(itemstoReceive, {randomItem})
			end
		end
		local moneychance = math.random(1, 2)
		local recieveMoney = math.random(0 , Config.maxMoney)
		if recieveMoney >= 1 and moneychance == 2 then
			findMoney(recieveMoney)
		end
		
	elseif Config.chancePercentage == 25 then 
		for i = 1, recieveItemChance do 
			local itemchance = math.random(1, 4)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if itemchance == 1 then
				table.insert(itemstoReceive, {randomItem})
			end
		end	
		local moneychance = math.random(1, 4)
		local recieveMoney = math.random(0 , Config.maxMoney)
		if recieveMoney >= 1 and moneychance == 1 then
			findMoney(recieveMoney)
		end
	end

	if itemstoReceive[1] then 
		local itemsReceived = {}
		for _, v in pairs(itemstoReceive) do 
			for _, items in pairs(v) do
			local itemQuantity = math.random(1, Config.MaxItems)
			TriggerServerEvent('QBCore:Server:AddItem', items, itemQuantity)
			KZNotify('Found ' .. itemQuantity .. ' x ' .. items, 'success', 5000)
			table.insert(itemsReceived, {['items'] = itemQuantity .. ' x ' .. items})
			end
		end
		webhookPost(itemsReceived)
		currentRobbery = nil 
	else
		KZNotify("No Valuables Found...", "error")
		webhookPost()
		currentRobbery = nil 
	end
end

function initLocations()
	for k, location in pairs(Config.robberyLocations) do 

		exports['qb-target']:AddBoxZone(tostring(k), vector3(location.x, location.y, location.z), 1.5, 1.6, { 
		name = tostring(k), 
		heading = 12.0, 
		debugPoly = false, 
		minZ = 36.7, 
		maxZ = 44.00,
		}, {
		options = { 
			{
			label = 'Break In',
			canInteract = function(entity, distance, data) 
				if robberyStarted then 
					return false
				end 
				return true
			end,
				action = function(entity) 
					currentRobbery = location     
					checkStatus()
					generateRandomPed()
					startRobbery(location, k)
				end,
			},
			{ 
				label = 'Search Property',
				canInteract = function(entity, distance, data) 
					if robberyStarted and not searching then 
						return true
					end 
					return false
				end,
				action = function(entity)
					startSearching() 
				end,
			}
		},
		distance = 2.5, 
		})
	end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	initLocations()
end)

initLocations()


