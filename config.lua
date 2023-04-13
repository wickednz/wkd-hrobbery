Config = {}

Config.Lang = 'en'

Config.currency = '$'

--How long the search takes. 10 - 30 Seconds
--Config.SearchTime = math.random(10000, 30000)
Config.searchTime = 5000

-- How long before a location can be robbed again
Config.Cooldown = 900000 --15 Minutes 

Config.MoneyType = 'cash'

--Max quantity of items to recieve
Config.MaxItems = 4

--Enable a skill check before robbery
Config.skillCheck = true

-- How many times to "roll the dice" for items
Config.rollAmount = 6

-- 0, 25, 50, 75 or 100 percent chance that something will be found for money and items
Config.chancePercentage = 75

--Maximum money that can be recieved from a robbery
Config.maxMoney = 300 

--If true a drop with the robbery items will be made at the door. If false it will be put into players inventory regardless of free space. 
Config.drop = false

--Will show polyzone boxes
Config.debug = false

-- Remove lockpick on failed attempt
Config.removeLockpickOnFail = true

--Webhook url for discord logging
Config.WebhookURL = ''

Config.robberyLocations = {

    [1] = vector3(1646.45, 4843.86, 42.02),   --Grapeseed start 
    [2] = vector3(1644.53, 4858.09, 42.01),
    [3] = vector3(1639.18, 4870.56, 42.03),
    [4] = vector3(1639.49, 4879.62, 42.14),
    [5] = vector3(1649.02, 4779.4, 42.02),
    [6] = vector3(1653.37, 4746.49, 42.18),
    [7] = vector3(1675.09, 4681.48, 43.06),
    [8] = vector3(1663.93, 4661.67, 43.67),
    [9] = vector3(1740.69, 4648.2, 43.92),
    [10] = vector3(1790.47, 4602.72, 37.68),
    [11] = vector3(1726.82, 4682.43, 43.66),
    [12] = vector3(1722.28, 4734.74, 42.14),
    [13] = vector3(1726.04, 4765.75, 41.94),
    [14] = vector3(1702.14, 4840.62, 42.02),
    [15] = vector3(1700.81, 4857.9, 42.03),
    [16] = vector3(1701.18, 4865.57, 42.02),
    [17] = vector3(1690.5, 4886.82, 42.42),
    [18] = vector3(1673.31, 4958.19, 42.34) --Grapeseed end
}

Config.pedModel = {

  [1] = 0xE5A11106,
  [2] = 0x040EABE3,
  [3] = 0xBDBB4922,
  [4] = 0xAD9EF1BB,
  [5] = 0x04498DDE,
  [6] = 0xD7DA9E99,
  [7] = 0xD47303AC,
  [8] = 0x94562DD7,
  [9] = 0x38BAD33B,
  [10] = 0xA956BD9E, 
  [11] = 0x30830813,
  [12] = 0x092D9CC1,
  [13] = 0xB594F5C3,
  [14] = 0xE7B31432,
}

Config.findableItems = { --Items that can be found 
[1] = 'tosti',
[2] = 'twerks_candy',
--[3] = 'sandwhich',
[4] = 'joint',
[5] = 'vodka',
[6] = 'screwdriverset',
[7] = 'drill',
[8] = 'electronickit',
[9] = 'repairkit',
[10] = 'jerry_can',
[11] = 'bandage',
[12] = 'laptop',
[13] = 'tablet',
[14] = 'phone',
[15] = 'radio',
[16] = 'fitbit',
[17] = 'rolex',
[18] = 'diamond_ring',
[19] = 'goldchain',
[20] = '10kgoldchain',
[21] = 'firework1',
[22] = 'binoculars'

}

Config.npcWeapons = {

[1] = 0x92A27487, -- Knife
[2] = 0x1B06D571, -- Gun
[3] = 0x958A4A8F, -- Bat
[4] = 0xF9E6AA4B, -- Broken Bottle
[5] = 0x4E875F73, -- Hammer
[6] = 0x440E4788, -- Golfclub
[7] = 0xF9DCBF2D, -- Hatchet 
[8] = 0xA2719263, -- Fist
[9] = 0x94117305, -- Poolcue

}
