if Config.EnableOnlinejobs then
RegisterNetEvent('Perri_OnlineJobs:server:load', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
        TriggerClientEvent('Perri_OnlineJobs:client:load', playerId, Config.Jobs)
    if GetJobFromConfig(xPlayer.job.name) then
        Config.Jobs[GetJobIndexFromConfig(xPlayer.job.name)].count = GetCountFromJob(xPlayer.job.name)


        TriggerClientEvent('Perri_OnlineJobs:client:sync', -1, Config.Jobs)
    end
end)

RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer and GetJobFromConfig(xPlayer.job.name) then
        Config.Jobs[GetJobIndexFromConfig(xPlayer.job.name)].count = GetCountFromJob(xPlayer.job.name)

        TriggerClientEvent('Perri_OnlineJobs:client:sync', -1, Config.Jobs)
    end
end)

RegisterNetEvent('esx:setJob', function(playerId, job, lastJob)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if GetJobFromConfig(job.name) then
        Config.Jobs[GetJobIndexFromConfig(job.name)].count = GetCountFromJob(job.name)
    end
    if GetJobFromConfig(lastJob.name) then
        Config.Jobs[GetJobIndexFromConfig(lastJob.name)].count = GetCountFromJob(lastJob.name)
    end

    TriggerClientEvent('Perri_OnlineJobs:client:sync', -1, Config.Jobs)
end)


function GetJobFromConfig(jobName)
    for k,v in pairs(Config.Jobs) do
        if v.name == jobName then
            return v
        end
    end

    return false
end

function GetJobIndexFromConfig(jobName)
    for k,v in pairs(Config.Jobs) do
        if v.name == jobName then
            return k
        end
    end

    return false
end

function GetCountFromJob(jobName)
    return #ESX.GetExtendedPlayers('job', jobName)
end

end