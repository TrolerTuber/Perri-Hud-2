local accounts = {}
local spawn, hud = false, false


function startthread()
    CreateThread(function()
        while true do
            local PlayerData = ESX.PlayerData       
            local hunger, thirst 
            TriggerEvent('esx_status:getStatus', 'hunger', function(status) 
                hunger = status.val / 10000 
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status) 
                thirst = status.val / 10000 
            end)
            
            
            for i=1, #PlayerData.accounts do
                accounts[PlayerData.accounts[i].name] = PlayerData.accounts[i]
            end
            
            SendNUIMessage({
                action = 'act',
                id = GetPlayerServerId(cache.playerId),
                health = math.ceil(GetEntityHealth(cache.ped) - 100),
                armour = GetPedArmour(cache.ped),
                hunger = hunger,
                thirst = thirst,
                stamina = (100 - GetPlayerSprintStaminaRemaining(cache.playerId)),
                accounts = accounts,
                hablando = NetworkIsPlayerTalking(cache.playerId)

            })
            
            SendNUIMessage({
                action = 'map',
                mapa = not IsRadarHidden(),
                anchor = GetMinimapAnchor()
            })
            
            Wait(500)
        end
    end)
end

RegisterNetEvent('esx:setJob', function(job)
    SendNUIMessage({
        action = "job",
        job_label = job.label,
        job_grade_label = job.grade_label
    })
end)

function updatecolors()
    SendNUIMessage({
        action = 'updatecolors',
        colorvida = Config.Colors.Health,
        colorcomida = Config.Colors.Hunger,
        colorbebida = Config.Colors.Thirst,
        colorarmadura = Config.Colors.Armour,
        colorestamina = Config.Colors.Stamina,    
        colormicrophone = Config.Colors.Microphone
        
    })
end

RegisterCommand(Config.ToggleHudCommand, function()
    hud = not hud
    SendNUIMessage({
        action = 'toggle',
        toggle = hud
    })
end)

RegisterNetEvent('esx:playerLoaded', function()
    if not spawn then
        SendNUIMessage({
            action = 'show'
        })
        
        startthread()
        updatecolors()
        getJob()
        
        spawn = true
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

function getJob()
    SendNUIMessage({
        action = "job",
        job_label = ESX.PlayerData.job.label,
        job_grade_label = ESX.PlayerData.job.grade_name
    })
end

