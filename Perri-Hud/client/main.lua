local lastVehicle = nil
local accounts = {} 
local myStats = {
    hunger = 100,
    thirst = 100
}





AddEventHandler('esx_status:onTick', function(data)
    for k, v in pairs(data) do
        if v.name == 'hunger' then
            myStats.hunger = v.val/10000
        elseif v.name == 'thirst' then
            myStats.thirst = v.val/10000
        end
    end
end)


function cargar()
    local player = PlayerId()
    local isTalking = NetworkIsPlayerTalking(player)
    local PlayerData = ESX.PlayerData
    if isTalking ~= wasTalking then
        SendNUIMessage({
            action = 'microfono',
            state = isTalking
        })
        wasTalking = isTalking
    end
    local ped = PlayerPedId()
    for i=1, #PlayerData.accounts do
        accounts[PlayerData.accounts[i].name] = PlayerData.accounts[i]
    end
    SendNUIMessage({
        action = 'act',
        health = GetEntityHealth(ped) -100,
        armour = GetPedArmour(ped),
        hunger = myStats.hunger,
        thirst = myStats.thirst,
        stamina = (100 - GetPlayerSprintStaminaRemaining(player)),
        job_label = PlayerData.job.label,
        job_grade_label = PlayerData.job.grade_name,
        id = GetPlayerServerId(player),
        accounts = accounts,
        anchor = GetMinimapAnchor(),

    })
    if IsRadarEnabled() then
        SendNUIMessage({
            action = 'mapasi',
            anchor = GetMinimapAnchor()
        })
    else
        SendNUIMessage({
            action = 'mapafuera',
            anchor = GetMinimapAnchor()
        })
        
    end
end


function startthread()
CreateThread(function()
    local wasTalking = false
    while true do
        local msec = 500
        local player = PlayerId()
        local isTalking = NetworkIsPlayerTalking(player)
        local PlayerData = ESX.PlayerData
        if isTalking ~= wasTalking then
            SendNUIMessage({
                action = 'microfono',
                state = isTalking
            })
            wasTalking = isTalking
        end
        local ped = PlayerPedId()
        for i=1, #PlayerData.accounts do
            accounts[PlayerData.accounts[i].name] = PlayerData.accounts[i]
        end
        SendNUIMessage({
            action = 'act',
            health = GetEntityHealth(ped) -100,
            armour = GetPedArmour(ped),
            hunger = myStats.hunger,
            thirst = myStats.thirst,
            stamina = (100 - GetPlayerSprintStaminaRemaining(player)),
            job_label = PlayerData.job.label,
            job_grade_label = PlayerData.job.grade_name,
            id = GetPlayerServerId(player),
            accounts = accounts,
            anchor = GetMinimapAnchor(),

        })
        if IsRadarEnabled() then
            SendNUIMessage({
                action = 'mapasi',
                anchor = GetMinimapAnchor()
            })
        else
            SendNUIMessage({
                action = 'mapafuera',
                anchor = GetMinimapAnchor()
            })
            
        end
        Wait(msec)
    end
end)
end




local hud = false

RegisterCommand(Config.ToggleHudCommand, function()
    if hud then
        SendNUIMessage({
            action = 'toggle',
            toggle = false
        })
        hud = false
    else
        SendNUIMessage({
            action = 'toggle',
            toggle = true
        })
        hud = true
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1200)

            if IsPauseMenuActive() and not IsPaused then
                IsPaused = true
                SendNUIMessage({
                    action = 'toggle',
                    toggle = true
                })
        elseif not IsPauseMenuActive() and IsPaused then
            IsPaused = false
            SendNUIMessage({
                action = 'toggle',
                toggle = false
            })
        end
    end
end)







local spawn = false
RegisterNetEvent('esx:playerLoaded', function()
    if not spawn then
        
        SendNUIMessage({
        action = 'show'
        })
        startthread()
        spawn = true
        print('a')
    else
    end
end)





function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end







    
    if Config.EnableOnlinejobs then
    
    CreateThread(function()
        while true do
            Wait(700)
    
            if NetworkIsPlayerActive(PlayerId()) then
                TriggerServerEvent('Perri_OnlineJobs:server:load')
                break
            end
        end
    end)
    
    RegisterNetEvent('Perri_OnlineJobs:client:load', function(jobs)
        SendNUIMessage({
            action = 'load',
            jobs = jobs
        })
    end)
    
    RegisterNetEvent('Perri_OnlineJobs:client:sync', function(jobs)
        SendNUIMessage({
            action = 'update',
            jobs = jobs
        })
    end)
    
    
    end