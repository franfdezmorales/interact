local interactEnabled = false
local interacting = false 
local targetFound = false 
local glm = require 'glm'

Citizen.CreateThread(function()
    RegisterKeyMapping("+enableInteract", "Player Targeting", "keyboard", "LMENU")
    RegisterCommand('+enableInteract', startInteract, false)
    RegisterCommand('-enableInteract', stopInteract, false)
end)

RegisterNUICallback('targetSelected', function(data, cb)
    hideUI()
    TriggerEvent(data.event, data.entity)
    cb({})
end)

RegisterNUICallback('closeUI', function(data, cb)
    hideUI()
    cb({})
end)

function showUI()
    SendNUIMessage({
        app = 'interact',
        method = 'toggleVisibility',
        data = true
    })
end

function hideUI()
    SendNUIMessage({
        app = 'interact',
        method = 'toggleVisibility',
        data = false
    })
    SetNuiFocus(false, false)
    interactEnabled = false
    targetFound = false
    interacting = false
    updateInfo({})
end

function updateInfo(data)
    SendNUIMessage({
        app = 'interact',
        method = 'updateInfo',
        data = {
            list = data.list or {}
        }
    })
end

function startInteract()
    showUI() 
    interactEnabled = true
    local currentList = {}

    Citizen.CreateThread(disableControls) 

    while interactEnabled do 
        Citizen.Wait(5)
        if not interacting then 
            local result, data = pcall(getData)
            targetFound = false 
            local newList = {}
            local currentBones = {}
            local currentKey = 0
            if result then 
                local entity, type, distance, model, coordsRay = table.unpack(data)
                for key, target in ipairs(targetRegistered) do 
                    if target.models[tostring(model)] then
                        if distance <= target.distance then 
                            if target.enable(entity) then
                                for i = 1, #target.options, 1 do
                                    target.options[i].entity = entity
                                    if type == 2 then 
                                        if target.options[i].bone then 
                                            if isNearBone(coordsRay, target.options[i].bone, entity) then 
                                                newList[#newList + 1] = target.options[i]
                                                currentBones[#currentBones + 1] = target.options[i].bone
                                            end
                                        else 
                                            newList[#newList + 1] = target.options[i]
                                        end
                                    else                                     
                                        newList[#newList + 1] = target.options[i]
                                    end
                                end
                                currentKey = key
                                targetFound = true
                                break
                            end
                        end
                    end
                end

                if type == 2 then 
                    local options = targetVehicles.options
                    if distance <= targetVehicles.distance then
                        if targetVehicles.enable(entity) then  
                            for i = 1, #options, 1 do
                                options[i].entity = entity
                                if options[i].bone then 
                                    if isNearBone(coordsRay, options[i].bone, entity) then  
                                        newList[#newList + 1] = options[i]
                                        currentBones[#currentBones + 1] = options[i].bone
                                    end
                                else 
                                    newList[#newList + 1] = options[i]
                                end                              
                            end
                            targetFound = true
                        end
                    end
                elseif type == 1 then 
                    local options = targetPeds.options 
                    if distance <= targetPeds.distance then 
                        if targetPeds.enable(entity) then 
                            for i = 1, #options, 1 do 
                                options[i].entity = entity
                                newList[#newList + 1] = options[i]
                            end
                            targetFound = true
                        end
                    end
                end

                if Config.modeDebug then 
                    if entity ~= 0 then 
                        local options = targetDebug.options
                        for i = 1, #options, 1 do 
                            options[i].entity = entity
                            newList[#newList + 1] = options[i]
                        end
                        targetFound = true                     
                    end
                end

                if targetFound then 
                    Citizen.CreateThread(interact)
                end

                if not deepcompare(currentList, newList, true) then 
                    currentList = newList
                    updateInfo({list = currentList})
                end

                while targetFound do 
                    Citizen.Wait(0)
                    local foundResult, foundData = pcall(getData)
                    local targetEntity = targetRegistered[currentKey] or {}

                    if foundResult then 
                        local foundEntity, _, foundDistance, _, foundCoordsRay = table.unpack(foundData)
                        local options = targetEntity.options or {}
                        local distance = targetEntity.distance or 5.0
                        local enable = targetEntity.enable and targetEntity.enable(foundEntity) or false
                        if foundEntity ~= entity or foundDistance > distance or not enable then 
                            targetFound = false
                        end
                        if targetFound then
                            if type == 2 then
                                options = {table.unpack(options), table.unpack(targetVehicles.options)}
                                for i = 1, #options, 1 do
                                    local bone = options[i].bone
                                    if bone then                        
                                        for j = 1, #currentBones, 1 do 
                                            if currentBones[j] == bone then                                                
                                                if not isNearBone(foundCoordsRay, bone, entity) then                                                 
                                                    targetFound = false
                                                    break
                                                end
                                            end
                                        end
                                        if isNearBone(foundCoordsRay, bone, entity) then 
                                            targetFound = false
                                            break
                                        end
                                    end
                                end
                                if not targetVehicles.enable(foundEntity) then 
                                    targetFound = false
                                end
                            elseif type == 1 and not targetPeds.enable(foundEntity) then 
                                targetFound = false
                            elseif Config.modeDebug then 
                                if targetEntity == 0 then 
                                    targetFound = false
                                end
                            end
                        end
                    else 
                        targetFound = false
                    end
                end
            end

            if not deepcompare(currentList, newList, true) then 
                currentList = newList
                updateInfo({list = currentList})
            end
        end
    end
end

function stopInteract() 
    if not interacting then 
        hideUI()
    end
end


---Source: https://github.com/citizenfx/lua/blob/luaglm-dev/cfx/libs/scripts/examples/scripting_gta.lua

function getRayInfo()
    local glm_rad = glm.rad
    local glm_quatEuler = glm.quatEulerAngleZYX
    local glm_rayPicking = glm.rayPicking

    local glm_up = glm.up()
    local glm_forward = glm.forward()

    local pos = GetFinalRenderedCamCoord()
    local rot = glm_rad(GetFinalRenderedCamRot(2))
    local screen = {}

    screen.ratio = GetAspectRatio(true)
	screen.fov = GetFinalRenderedCamFov()

    local q = glm_quatEuler(rot.z, rot.y, rot.x)
    return pos, glm_rayPicking(
        q * glm_forward,
        q * glm_up,
        glm_rad(screen.fov),
        screen.ratio,
        0.10000,
        10000.0, 
        0, 0
    )
end

function getData()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local rayPos, rayDir = getRayInfo()
    local destination = rayPos + 10000 * rayDir 
    local rayHandle = StartShapeTestLosProbe(rayPos.x, rayPos.y, rayPos.z, destination.x, destination.y, destination.z, 4294967295, playerPed, 4)
    local endCoords, entityHit = getResultFromRayCast(rayHandle)

    local distance = #(playerCoords - endCoords)

    return {entityHit, GetEntityType(entityHit) or 0, distance, GetEntityModel(entityHit), endCoords}
end

function getResultFromRayCast(rayHandle) 
    while true do 
        Citizen.Wait(0)
        local result, _, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
        if result ~= 1 then 
            return endCoords, entityHit
        end
    end
end

function interact()
    while targetFound do 
        Citizen.Wait(0)
        if IsDisabledControlJustReleased(0, 24) then
            SetNuiFocus(true, true)
            SetCursorLocation(0.5, 0.5)
            interacting = true
            targetFound = false
        end
    end
end

function disableControls()
    while interactEnabled do 
        Citizen.Wait(0)
        local playerId = PlayerId()
        DisablePlayerFiring(playerId, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 143, true)
        DisableControlAction(0, 45, true)
        DisableControlAction(0, 37, true)
    end
end

function isNearBone(coordsRay, bone, entity)
    local boneId = GetEntityBoneIndexByName(entity, bone) 
    if boneId ~= -1 then 
        local bonePos = GetWorldPositionOfEntityBone(entity, boneId)
        local distance = #(coordsRay - bonePos)
        return distance <= 0.7
    end 

    return false
end

---Source: https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3
function deepcompare(t1,t2,ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepcompare(v1,v2) then return false end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepcompare(v1,v2) then return false end
    end
    return true
end

AddEventHandler('interact:saveTarget', function(entity)
    local entityModel = GetEntityModel(entity)
    TriggerServerEvent('interact:saveTarget', entityModel)
end)

