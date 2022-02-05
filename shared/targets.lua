--[[ DONT MOVE THIS FUNCTION ]]

function addNewTarget(targets, props)
    local modelsTarget = {}
    for i = 1, #targets, 1 do 
        modelsTarget[tostring(targets[i])] = true
        totalTargets[#totalTargets + 1] = targets[i]
    end
    targetRegistered[#targetRegistered + 1] = {
        models = modelsTarget, 
        options = props.options, 
        distance = props.distance,
        enable = props.enable
    }
end

--[[ ADD YOUR TARGETS HERE ]]

local testTargets = {
    -1403128555, 
}

addNewTarget(testTargets, {
    options = {
        {
            label = 'Test', 
            icon = 'Test', 
            event = 'test1', 
            bone = 'wheel_rr'
        }, 
        {
            label = 'Test', 
            icon = 'Test', 
            event = 'test2', 
            bone = 'wheel_rr'
        }, 
    }, 
    distance = 5.0, 
    enable = function(entity)
        return true
    end 
})