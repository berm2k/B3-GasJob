-- https://discord.gg/2mNts9zxdn في حين مواجهة اي مشاكل بالسكربت يرجى فتح تذكرة برمجية 

local trees = {
    {2752.1838378906,1511.7379150391,24.500722885132},
    {2771.5375976563,1520.0869140625,24.500595092773},
    {2751.646484375,1478.5794677734,24.500694274902},
    {2733.7119140625,1498.5236816406,24.500722885132},
    {2763.154296875,1553.0092773438,24.500946044922},
    {2773.2744140625,1565.6348876953,24.50066947937},
    {2775.158203125,1558.6833496094,24.50066947937},
}

local alreadyCut = {}

local processLoc = {
    {1226.7971191406,-3104.2419433594,6.0279517173767}  -- نقطة البيع
}

local isProcessing = false

--[[Citizen.CreateThread(function()
    for k,v in pairs(trees) do
        local x,y,z = table.unpack(v)
        z = z-2
        local tree = CreateObject(GetHashKey("prop_tree_cedar_02"), x, y, z, true, true, false)
        NetworkRequestControlOfEntity(tree)
        FreezeEntityPosition(tree, true)
    end
end)]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(trees) do
            local x,y,z = table.unpack(v)
            z = z-1
            local pCoords = GetEntityCoords(GetPlayerPed(-1))
            local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, x, y, z, true)
            local alpha = math.floor(255 - (distance * 30))
            if alreadyCut[k] ~= nil then
                local timeDiff = GetTimeDifference(GetGameTimer(), alreadyCut[k])
                if timeDiff < 60000 then
                    if distance < 5.0 then
                        local seconds = math.ceil(60 - timeDiff/1000)
                        DrawText3d(x, y, z+1.5, "<FONT FACE = 'A9eelsh'>"..'~w~ﺮﻈﺘﻧﺍ ~r~'..tostring(seconds).."<FONT FACE = 'A9eelsh'>"..'~w~ﻲﻧﺍﻮﺛ.', alpha)  -- مانع سبام بالثواني
                    end
                else
                    alreadyCut[k] = nil
                end
            else
                if distance < 2.0 then
                    DrawText3d(x, y, z+1.5, "<FONT FACE = 'A9eelsh'>"..'~w~ﻂﻐﺿﺍ ~g~[E]~w~ ﺯﺎﻐﻟﺍ ﻊﻨﺼﻟ', alpha)
                    if (IsControlJustPressed(1, 38)) then
                        if alreadyCut[k] ~= nil then
                            if GetTimeDifference(GetGameTimer(), alreadyCut[k]) > 60000 then
                                alreadyCut[k] = GetGameTimer()
                                TriggerServerEvent('damn_lenhador:cutTree')
                            end
                        else
                            alreadyCut[k] = GetGameTimer()
                            TriggerServerEvent('damn_lenhador:cutTree')
                        end
                    end
                elseif distance < 5.0 then
                    DrawText3d(x, y, z+1.5, "<FONT FACE = 'A9eelsh'>"..'~w~ﻊﻴﻨﺼﺘﻟﺍ ﺃﺪﺒﻟ ﺏﺮﺘﻗﺍ', alpha)
                end
            end
        end
    end
end)

local lastProcess = 0

Citizen.CreateThread(function()
    while true do
        if isProcessing then
            if GetTimeDifference(GetGameTimer(), lastProcess) > 4000 then
                for k,v in pairs(processLoc) do
                local x,y,z = table.unpack(v)
                local pCoords = GetEntityCoords(GetPlayerPed(-1))
                local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, x, y, z, true)
                    if distance < 2.0 then
                        lastProcess = GetGameTimer()
                        TriggerServerEvent('damn_lenhador:processWood')
                    end
                end
                
            end 
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(processLoc) do
            local x,y,z = table.unpack(v)
            local pCoords = GetEntityCoords(GetPlayerPed(-1))
            local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, x, y, z, true)
            local alpha = math.floor(255 - (distance * 30))

            DrawMarker(22, x, y, z+0.3, 0, 0, 0, 0.0, 0, 0, 1.4, 2.1, 1.1, 255, 255, 255, 255, 0, 0, 0, 0)

            if isProcessing then
                if distance < 2.0 then
                    DrawText3d(x, y, z+1.8, "<FONT FACE = 'A9eelsh'>"..'~w~ﻂﻐﺿﺍ ~r~[E]~w~ ﺔﻴﻠﻤﻌﻟﺍ ﺀﺎﻐﻟﻹ.', alpha)
                    if (IsControlJustPressed(1, 38)) then
                        TriggerServerEvent('damn_lenhador:enableProcess')
                    end
                elseif distance < 8.0 then
                    DrawText3d(x, y, z+1.8, "<FONT FACE = 'A9eelsh'>"..'~w~ﻊﻴﺒﻟﺍ ﻦﻣ ﺏﺮﺘﻗﺍ.', alpha)
                end
            else
                if distance < 2.0 then
                    DrawText3d(x, y, z+1.8, "<FONT FACE = 'A9eelsh'>"..'~w~ﻂﻐﺿﺍ ~g~[E]~w~ ﺯﺎﻐﻟﺍ ﻊﻴﺒﻟ', alpha)
                    if (IsControlJustPressed(1, 38)) then
                        TriggerServerEvent('damn_lenhador:enableProcess')
                    end
                elseif distance < 8.0 then
                    DrawText3d(x, y, z+1.8, "<FONT FACE = 'A9eelsh'>"..'~w~.ﻊﻴﺒﻟﺍ ﻦﻣ ﺏﺮﺘﻗﺍ.', alpha)
                end
            end
        end
    end
end)

RegisterNetEvent("damn_lenhador:cutTree")
AddEventHandler("damn_lenhador:cutTree", function(tree)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    while (not HasAnimDictLoaded("mini@repair")) do 
        RequestAnimDict("mini@repair")
        Citizen.Wait(5)
    end
    propaxe = CreateObject(GetHashKey(""), x, y, z,  true,  true, true)
    AttachEntityToEntity(propaxe, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.08, -0.4, -0.10, 80.0, -20.0, 175.0, true, true, false, true, 1, true)
    TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    FreezeEntityPosition(GetPlayerPed(-1),true)
    Citizen.Wait(11000)    -- الزمن لصنع انبوبة واحدة
    DetachEntity(propaxe, 1, 1)
    DeleteObject(propaxe)
    FreezeEntityPosition(GetPlayerPed(-1),false)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    TriggerServerEvent('damn_lenhador:rewardWood')
end)

RegisterNetEvent("damn_lenhador:enableProcess")
AddEventHandler("damn_lenhador:enableProcess", function()
    isProcessing = not isProcessing
    if isProcessing then
        Citizen.Wait(100)
        --TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WINDOW_SHOP_BROWSE", 0, true)
        --FreezeEntityPosition(GetPlayerPed(-1),true)
    elseif not isProcessing then
        FreezeEntityPosition(GetPlayerPed(-1),false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end
end)

function DrawText3d(x,y,z, text, alpha)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.5, 0.5)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, alpha)
        SetTextDropshadow(0, 0, 0, 0, alpha)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end