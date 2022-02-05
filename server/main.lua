RegisterNetEvent('interact:saveTarget')
AddEventHandler('interact:saveTarget', function(entityModel)
    local text = "\n" .. [[#### - NEW TARGET (]] .. os.date('%x - %X') .. [[) - ####

    local newTargets = {]].. entityModel .. [[}

    addNewTarget(newTargets, {
        options = {
            {
                label = '', 
                icon = '', 
                event = '', 
            }, 
        }, 
        distance = 5.0, 
        enable = function(entity)
            return true
        end 

#### - ♾️♾️♾️♾️♾️♾️♾️♾️♾️♾️♾️ - ####]]


    local file = io.open(Config.saveFile, "a")
    if file then
        io.output(file)
        io.write(text)
        io.close(file)
    end
end)