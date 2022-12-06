local QBCore = exports['qb-core']:GetCoreObject()
local Vehicle = nil
local VehicleSpawned = false

-- spawn vehicle
RegisterNetEvent('mt-policegarage:client:SpawnVehicle', function(data)
    QBCore.Functions.SpawnVehicle(data.SpawnName, function(veh)
        SetVehicleNumberPlateText(veh, "LSPD"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        Vehicle = veh
        VehicleSpawned = true
    end, data.SpawnCoords, true)
end)

RegisterNetEvent('mt-policegarage:client:DeleteVehicle', function()
    if Vehicle ~= nil then
        DeleteVehicle(Vehicle)
        DeleteEntity(Vehicle)
        VehicleSpawned = false
    elseif IsPedInAnyVehicle(PlayerPedId()) then
        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
        VehicleSpawned = false
    else
        QBCore.Functions.Notify('You need  to be in any vehicle!', 'error', 5000)
    end
end)

RegisterNetEvent('mt-policegarage:clientOpenMenu', function(Current)
    local Menu = {
        {
            header = 'Police Garage',
            isMenuHeader = true,
            icon = 'fas fa-car',
        },
        {
            header = 'Close Menu',
            icon = 'fas fa-close',
            params = {
                event = 'qb-menu:closeMenu',
            },
        },
    }
    for a, i in pairs(Config.Locations[Current]['Vehicles']) do
        if QBCore.Functions.GetPlayerData().job.grade.level >= tonumber(i['Grade']) then
            Menu[#Menu + 1] = {
                header = i['VehicleName'],
                icon = 'fas fa-car',
                params = {
                    event = 'mt-policegarage:client:SpawnVehicle',
                    args = {
                        SpawnName = i['VehicleSpawnName'],
                        SpawnCoords = Config.Locations[Current]['SpawnCoords'],
                    },
                }
            }
        end
    end
    if VehicleSpawned == true then
        Menu[#Menu + 1] = {
            header = 'Store Vehicle',
            icon = 'fas fa-ban',
            params = {
                event = 'mt-policegarage:client:DeleteVehicle',
            }
        }
    end
    Wait(500)
    exports['qb-menu']:openMenu(Menu)
end)

-- Target export and menu event
CreateThread(function()
    for k ,v in pairs(Config.Locations) do
        exports['qb-target']:AddBoxZone(k.."-garage-"..v['Job'], v['Coords'], 10, 10, {
            name = k.."-garage-"..v['Job'],
            heading = v['Heading'],
            debugPoly = false,
        }, {
            options = {
                {
                    type = "Client",
                    action = function()
                        TriggerEvent('mt-policegarage:clientOpenMenu', k)
                    end,
                    icon = "fas fa-car",
                    label = 'Open Garage',
                    job = v['Job'],
                },
            },
            distance = 10
        })
    end
end)