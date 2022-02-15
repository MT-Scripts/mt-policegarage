local QBCore = exports['qb-core']:GetCoreObject()

-- verificar player
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(Player)
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- verificar job
RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerJob = job
end)

-- spawn veiculo
RegisterNetEvent('mt-policegarage:spawn')
AddEventHandler('mt-policegarage:spawn', function(pd)
    local vehicle = pd.vehicle
    local coords = GetEntityCoords(PlayerPedId())
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "LSPD"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
      --  SetEntityHeading(veh, coords.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)     
end)

-- guardar veiculo
RegisterNetEvent('mt-policegarage:guardar')
AddEventHandler('mt-policegarage:guardar', function()

    QBCore.Functions.Notify('Veiculo guardado!')
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    DeleteVehicle(car)
    DeleteEntity(car)
end)

-- Menu da garagem 
RegisterNetEvent('mt-policegarage:menu', function()
    exports['qb-menu']:openMenu({
        {
            id = 1,
            header = "Garage LSPD",
            txt = ""
        },
        {
            id = 2,
            header = "Police 1",
            txt = "",
            params = {
                event = "mt-policegarage:spawn",
                args = {
                    vehicle = 'police',
                    
                }
            }
        },
        {
            id = 3,
            header = "Police 2",
            txt = "",
            params = {
                event = "mt-policegarage:spawn",
                args = {
                    vehicle = 'police2',
                    
                }
            }
        },
        {
            id = 4,
            header = "Police 3",
            txt = "",
            params = {
                event = "mt-policegarage:spawn",
                args = {
                    vehicle = 'police3',
                    
                }
            }
        },
        {
            id = 5,
            header = "Police 4",
            txt = "",
            params = {
                event = "mt-policegarage:spawn",
                args = {
                    vehicle = 'police4',
                    
                }
            }
        },
        {
            id = 6,
            header = "Police Transport",
            txt = "",
            params = {
                event = "",
                args = {
                    vehicle = 'policet',
                    
                }
            }
        },
        {
            id = 9,
            header = "Store Vehicle",
            txt = "",
            params = {
                event = "mt-policegarage:guardar",
                args = {
                    
                }
            }
        },
    })
end)

-- Trigger para o target
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("policeGarage", vector3(381.59, -1625.03, 29.29), 10, 10, {
        name = "policeGarage",
        heading = 245.84,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = "mt-policegarage:menu",
                icon = "fas fa-car",
                label = 'Open Garage'
            },
        },
        distance = 10
    })
end)
