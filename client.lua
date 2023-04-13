QBCore = exports["qb-core"]:GetCoreObject()
local WKD = exports["wkd-utils"]:utils()

--Variables
local Player = nil
local name = nil
local citizenid = nil
local robberyStarted = false
local currentRobbery = nil
local hasMoved = false
local searching = false
local itemTable = Config.findableItems
local pedTable = Config.pedModel
local moneyRecvd = 0
local itemstoReceive = {}

-- Config.findableItems = { --Items that can be found 
-- ['tosti'] = 10,
-- ['twerks_candy'] = 10,
-- ['sandwhich'] = 6,
-- ['joint'] = 2,
-- ['vodka'] = 5,
-- ['screwdriverset'] = 4,
-- ['drill'] = 6,
-- ['electronickit'] = 4,
-- ['repairkit'] = 2,
-- ['jerry_can'] = 3,
-- ['bandage'] = 8,
-- ['laptop'] = 8,
-- ['tablet'] = 7,
-- ['phone'] = 8,
-- ['radio'] = 4,
-- ['fitbit'] = 4,
-- ['rolex'] = 2,
-- ['diamond_ring'] = 2,
-- ['goldchain'] = 3,
-- ['10kgoldchain'] = 1,
-- ['firework1'] = 1,
-- ['binoculars'] = 2

-- }

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
					WKD.Functions.Notify(Lang[Config.Lang]['moved_too_far'], 'error')
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
	local randomped = pedTable[math.random(1, #pedTable)]
	RequestModel(randomped)
	return randomped
end

function startSkillCheck(location, k)
	local success = lib.skillCheck('medium', {'w', 'a', 's', 'd'})

	if success then 
		startRobbery(location, k)
	end

end

function checkStatus(location, k)
	QBCore.Functions.TriggerCallback("kz-hrobbery:server:isitRobbed", function(cb)
		if cb then
			WKD.Functions.Notify(Lang[Config.Lang]['already_hit'], 'error', 5000)
		else
			if Config.skillCheck then 
				startSkillCheck(location, k)
			else
				startRobbery(location, k)
			end
		end
	end, currentRobbery)
end

function webhookPost(item)
	local s1 = GetStreetNameAtCoord(currentRobbery.x, currentRobbery.y, currentRobbery.z)
	local streetLabel = GetStreetNameFromHashKey(s1)
	local iteminfo = ' '

	if item ~= nil and type(item) == 'table' then 
		iteminfo = dump(item)
	else
		iteminfo = Lang[Config.Lang]['nothing']
	end
		
	local data = {
		["embeds"] = {{ 
			color = 16776960;
			title = Lang[Config.Lang]['house_rob'];
			fields = {
				{
					name = Lang[Config.Lang]['theif'],
					value = name,
					inline = true
				},
				{
					name = Lang[Config.Lang]['cid'],
					value = citizenid,
					inline = true
				},
				{
					name = Lang[Config.Lang]['loc'],
					value = streetLabel,
					inline = true
				},
				{
					name =Lang[Config.Lang]['itemtaken'],
					value = '| ' .. iteminfo,
					inline = true
				},
				{
					name = Lang[Config.Lang]['moneytaken'],
					value = '$' .. tostring(moneyRecvd),
					inline = true
				},
			};
			footer = {
				["text"] = 'wkd-houserobbery';
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
	WKD.Functions.Notify(Lang[Config.Lang]['found'] .. ' ' .. Config.currency .. amount, "success")
	moneyRecvd = amount
end

function lockpickdone(locksuccess)
	if not locksuccess then 
		if Config.removeLockpickOnFail then 
			TriggerServerEvent('kz-hrobbery:server:removeItem')
		end
	end
	
	Wait(5000)
	minigameStarted = false
end


function setContains(set, key)
    return set[key] ~= nil
end

function loadRandomItems()
	local rollAmount = Config.rollAmount
	
	if Config.chancePercentage == 100 then 
		for i = 1, rollAmount do
			local itemQuantity = math.random(1, Config.MaxItems)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if not setContains(itemstoReceive, randomItem) then 
				itemstoReceive[randomItem] = itemQuantity
			end
		end
	elseif Config.chancePercentage == 75 then 
		for i = 1, rollAmount do 
			local itemchance = math.random(1, 3)
			local itemQuantity = math.random(1, Config.MaxItems)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if itemchance == 2 or chance == 3 then
				if not setContains(itemstoReceive, randomItem) then 
					itemstoReceive[randomItem] = itemQuantity
				end
			end
		end
	elseif Config.chancePercentage == 50 then 
		for i = 1, rollAmount do 
			local itemchance = math.random(1, 2)
			local itemQuantity = math.random(1, Config.MaxItems)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if itemchance == 1 then
				if not setContains(itemstoReceive, randomItem) then 
					itemstoReceive[randomItem] = itemQuantity
				end
			end
		end		
	elseif Config.chancePercentage == 25 then 
		for i = 1, rollAmount do 
			local itemchance = math.random(1, 4)
			local itemQuantity = math.random(1, Config.MaxItems)
			local randomItem = itemTable[math.random(1, #itemTable)]
			if itemchance == 1 then
				if not setContains(itemstoReceive, randomItem) then 
					if not setContains(itemstoReceive, randomItem) then 
						itemstoReceive[randomItem] = itemQuantity
					end
				end
			end
		end	
	end
end

function giveRandomItems()
	local itemsReceived = {}
	local PlayerData = QBCore.Functions.GetPlayerData()
	local identifier = PlayerData.license
	local playerId = (GetPlayerServerId(PlayerId()))
	if itemstoReceive then 
		for k, v in pairs(itemstoReceive) do
			table.insert(itemsReceived, {['items'] = k .. ' x ' .. v .. ' |'})
		end
		TriggerServerEvent('wkd-hrobbery:server:giveItems', playerId, itemstoReceive, currentRobbery)
	else
		WKD.Functions.Notify(Lang[Config.Lang]['no_valuables'], "error")
	end
	local recieveMoney = math.random(0 , Config.maxMoney)
	if recieveMoney >= 1 then 
		findMoney(recieveMoney)
	end
	if next(itemstoReceive) then 
		WKD.Functions.Notify({text = Lang[Config.Lang]['items_found'], caption =  dump(itemsReceived)}, 'success' , 10000)
	end
	webhookPost(itemsReceived)
	currentRobbery = nil 
end

function alertAuthorities(location)
	print('Please provide police dispatch code at line 265 in client.lua')
end

function startRobbery(location, name) 
	local src = source
    local ped = PlayerPedId()
	local pedChance = math.random(1 , 2)
	local playerHeading = GetEntityHeading(ped)
    local randomWeapon = Config.npcWeapons[math.random(1 , 9)]
	local ammo = 1
	local zoneName = tostring(name)
	local randomped = generateRandomPed()

	if randomWeapon == 0x1B06D571 then 
		ammo = 30
	end
	
	MonitorPOS()
	TriggerServerEvent('kz-hrobbery:server:robbed', currentRobbery)
		
	if pedChance == 2 then --Spawn a ped.
		robberyStarted = true
		local angryPed = CreatePed(0, randomped, location.x, location.y, location.z, playerHeading - 180.00, true, true)   
		TaskCombatPed(angryPed, ped, 0, 16)
		GiveWeaponToPed(angryPed, randomWeapon, ammo, false, true)
		CreateThread(function()
			while robberyStarted do 
				Wait(5000)
				local Player = QBCore.Functions.GetPlayerData()
				if Player.metadata.isdead or Player.metadata.inlaststand then 
					alertAuthorities(location)
					robberyStarted = false
					WKD.Functions.Notify(Lang[Config.Lang]['failed'], 'error', 5000)
				end
			end
		end)
		
	elseif pedChance == 1 then  -- Dont spawn a ped 
		robberyStarted = true
		WKD.Functions.Notify(Lang[Config.Lang]['nobody_home'])
	end 

end

function startSearching()
	local ped = PlayerPedId()
	loadRandomItems()

	searching = true 

	lib.showTextUI(Lang[Config.Lang]['cancelprogress'])

	if lib.progressCircle({
		duration = Config.searchTime,
		position = 'bottom',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			dict = 'mini@repair',
			clip =  "fixing_a_player"
		},
		disable = {
			move = true
		}
	}) then 
		searching = false
		robberyStarted = false
		giveRandomItems()
		lib.hideTextUI()
	else 
		WKD.Functions.Notify(Lang[Config.Lang]['failed'], "error")
		searching = false
		robberyStarted = false
		currentRobbery = nil 
		lib.hideTextUI()
	end
end

function initLocations()
	for k, location in pairs(Config.robberyLocations) do 

		exports['qb-target']:AddBoxZone(tostring(k), vector3(location.x, location.y, location.z), 1.5, 1.6, { 
		name = tostring(k), 
		heading = 12.0, 
		debugPoly = Config.debug, 
		minZ = 36.7, 
		maxZ = 44.00,
		}, {
		options = { 
			{
			label = Lang[Config.Lang]['break_in'],
			canInteract = function(entity, distance, data) 
				currentRobbery = vector3(location.x, location.y, location.z)
				if robberyStarted then 
					return false
				else 
					return true
				end
			end,
				action = function(entity)
					checkStatus(location, k)
				end,
			},
			{ 
				label = Lang[Config.Lang]['search_prop'],
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
	Player = QBCore.Functions.GetPlayerData()
	name = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname
	citizenid = Player.citizenid
end)

if Config.debug then 
	initLocations()
	Player = QBCore.Functions.GetPlayerData()
	name = Player.charinfo.firstname .. ' ' .. Player.charinfo.lastname
	citizenid = Player.citizenid
end

Citizen.CreateThread(function()
	while true do
		Wait(2000)
		--print(WKD.Shared.dump(itemstoReceive))
	end

end)


