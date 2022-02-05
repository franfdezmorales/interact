Config = {}
Config.modeDebug = true
Config.saveFile = "./targets_interact.txt"

--[[ DONT TOUCH THIS OR YOU WILL BREAK THE DEBUG SYSTEM (YOU CAN ADD MORE OPTIONS) ]]

targetDebug = {
    options = {
        {
            label = 'Save target', 
            icon = 'MdSave', 
            event = 'interact:saveTarget',
        }, 
    },
}

--[[ ADD OPTIONS TO ALL VEHICLE TARGETS LIKE OPEN LEFT DOOR (?) ]]

targetVehicles = {
    options = {

    }, 
    distance = 5.0, 
    enable = function(entity)
        return true
    end
}

--[[ ADD OPTIONS TO ALL PED TARGETS LIKE GIVE CASH (?) ]]

targetPeds = {
    options = {

    }, 
    distance = 5.0, 
    enable = function(entity) 
        return true
    end
}