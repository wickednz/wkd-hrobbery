--The purpose of this file is to allow customization to certain areas of the script like notify.
local minigameStarted = false
local success = nil 
local justchecked = nil 


--This function is for using your own notify. It is passed three variables which are listed below.
--    - text = A string with the notify or progress text. 
--    - time = Time the action takes in ms(5000 = 5 Seconds)
--    - type = A string with primary(default), error or success
function KZNotify(text, type, time)
	QBCore.Functions.Notify(text, type, time)
end

function KZRobberyStarted(pos)
	local s1 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
	local streetLabel = GetStreetNameFromHashKey(s1)

 --This function can be used to dispatch to police, it is passed a vector3 value of the location. 

end

function KZMinigame()
	local function lockpickdone(locksuccess)
		success = locksuccess
		Wait(5000)
		minigameStarted = false
	end
	if not minigameStarted and not justchecked then
		checkHasItem()
	end
	return success
end

