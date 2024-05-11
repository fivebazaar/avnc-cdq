local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

RegisterCommand('panel', function()
    TriggerEvent('avnc-panel:client:openpanel')
end)
RegisterNetEvent('avnc-panel:client:openpanel',function()

    local Mainmenu = {
        id = 'main_menu',
        title = config.MainMenu.Title,
        options = {}
    }

    if config.MainMenu.Kisisorgula then
        Mainmenu.options[#Mainmenu.options+1] = {
            title = locale("person_query"),
            description = locale("person_query_description"),
            icon = 'user',
            iconAnimation = "fade",
            arrow = true,
            onSelect = function()
                local jobLabels = {}
            
                for jobName, jobData in pairs(QBCore.Shared.Jobs) do
                    table.insert(jobLabels, { label = jobData.label, value = jobName })
                end
            
                local inputs = {
                    { type = 'input', label = locale("name_surname"), description = locale("name_surname_filter"), required = true, min = 3, max = 16 },
                    -- { type = 'input', label = 'Soyİsim', description = 'Some input description', required = false, min = 3, max = 16 },
                }
            
                if config.Kisisorgula.Meslek then
                    table.insert(inputs, {
                        type = 'select',
                        label = locale("occupation"),
                        options = jobLabels,
                        description = locale("occupation_filter"),
                        required = false
                    })
                end
            
                local input = lib.inputDialog(config.Kisisorgula.Title, inputs)
            
                local playerName = {}
                local job
            
                playerName.firstname = input[1]
                job = input[2]
            
                TriggerServerEvent('avnc-panel:server:SearchPlayer', playerName, job)
            end
        }
    end

    if config.MainMenu.phonequery then
        Mainmenu.options[#Mainmenu.options+1] = {
            title = locale("phone_query"),
            description = locale("phone_query_description"),
            icon = 'phone',
            iconAnimation = 'fade',
            arrow = true,
            onSelect = function()
                local input = lib.inputDialog(config.PlakaSorgula.InputTitle, {
                    {type = 'input', label = locale("phone_query"), description = locale("phone_query_prompt"), required = true, min = 10, max = 10},
                  })
                  local phone
                  phone = input[1]
                TriggerServerEvent('avnc-panel:server:phonequery', phone)
                end
            }
        
    end

    if config.MainMenu.PlakaSorgula then
        Mainmenu.options[#Mainmenu.options+1] = {
            title = locale("plate_query"),
            description = locale("plate_query_description"),
            icon = 'car',
            iconAnimation = 'fade',
            arrow = true,
            onSelect = function()
                local jobLabels = {}

                for jobName, jobData in pairs(QBCore.Shared.Jobs) do
                    table.insert(jobLabels, { label = jobData.label, value = jobName })
                end

                local input = lib.inputDialog(config.PlakaSorgula.InputTitle, {
                    {type = 'input', label = locale("plate"), description = locale("enter_plate"), required = true, min = 8, max = 8},
                  })
                  local plaka
                  plaka = input[1]
                TriggerServerEvent('avnc-panel:server:SearchVehicle', plaka)
                end
            }
    end

    if config.MainMenu.BankaHesabinasiz then
        Mainmenu.options[#Mainmenu.options+1] = {
            title = locale("hack_bank_account"),
            description = locale("hack_bank_account_description"),
            icon = 'building-columns',
            iconAnimation = 'fade',
            arrow = true,
            event = 'avnc=panel:client:randomplayer',
        }
    end

    if config.MainMenu.SahteIhbar then
        Mainmenu.options[#Mainmenu.options+1] = {
            title = locale("send_fake_tip"),
            description = locale("send_fake_tip_description"),
            icon = 'people-robbery',
            iconAnimation = 'fade',
            arrow = true,
            event = 'avnc-panel:client:fakedispatchmenu',
        }
    end

    if config.MainMenu.cctv then
        Mainmenu.options[#Mainmenu.options+1] = {
            title = locale("cctv_access"),
            description = locale("cctv_access_description"),
            icon = 'camera',
            iconAnimation = 'fade',
            arrow = true,
            event = 'avnc-panel:client:cctvmenu',
        }
    end


    lib.registerContext(Mainmenu)
    local Player = QBCore.Functions.GetPlayerData()
    local PlayerJob = Player.job.name
    if config.Job.job then
        if config.Job.jobName == PlayerJob then
            lib.showContext(Mainmenu.id)
            doAnimation()
        else
            QBCore.Functions.Notify(locale("what_is_this_tablet_for"), 'error', 5000)
        end
    else
        lib.showContext(Mainmenu.id)
        doAnimation()
    end
end)


RegisterNetEvent('avnc-panel:client:phonequery', function()



end)

RegisterNetEvent('avnc-panel:client:cctvmenu',function()
    local cctvmenu = {
        id = 'cctv_menu',
        title = locale("cctv_access"),
        options = {}
    }
    for k, camera in ipairs(Config.SecurityCameras.cameras) do
        cctvmenu.options[#cctvmenu.options + 1] = {
            title = camera.label,
            description = locale("rotateable") .. (camera.canRotate and locale("yes") or locale("no")),
            icon = config.cctv.icon,
            iconAnimation = 'fade',
            arrow = true,
            onSelect = function()
                TriggerEvent('police:client:ActiveCamera', k)
            end
        }
    end    

    if #cctvmenu.options < 1 then 
        cctvmenu.options[#cctvmenu.options+1] = {
            title = locale("not_found"),
            disabled = true
        }
    end
    
    
    if #cctvmenu.options > 0 then 
        cctvmenu.options[#cctvmenu.options+1] = {
            title = locale("go_back"),
            arrow = true,
            onSelect = function()
                lib.showContext("main_menu")
            end
        }
    end

    lib.registerContext(cctvmenu)
    lib.showContext(cctvmenu.id)

end)

local tabletObj = nil
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = 'prop_cs_tablet'
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)
local menulist = {
    "main_menu",
    'fakedispatch_menu',
    'araci_Menu',
    'panel_menu',
    'car_menu',
    "cctv_menu"
}

function doAnimation()
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Citizen.Wait(100) end
    
    -- Model
    RequestModel(tabletProp)
    while not HasModelLoaded(tabletProp) do Citizen.Wait(100) end

    local plyPed = PlayerPedId()
    tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
    local tabletBoneIndex = GetPedBoneIndex(plyPed, tabletBone)

    AttachEntityToEntity(tabletObj, plyPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)

    while true do
        Wait(500)
        local isOpen = false
        for _, menuName in ipairs(menulist) do
            if lib.getOpenContextMenu() == menuName then
                isOpen = true
                break
            end
        end
        if isOpen then
            if not IsEntityPlayingAnim(plyPed, tabletDict, tabletAnim, 3) then
                TaskPlayAnim(plyPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        else
            ClearPedSecondaryTask(plyPed)
            Citizen.Wait(250)
            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
            break
        end
    end
end


    -- lib.registerContext({
    --     id = 'main_menu',
    --     title = config.MainMenu.Title,
    --     options = {}





-- local ihbarlar = {
--     {name = "Resim Müzesi Soygunu", export = "ArtGalleryRobbery"},
--     {name = "Uyuşturucu Satışı", export = "DrugSale"},
--     {name = "Patlama", export = "Explosion"},
--     {name = "Kavga", export = "Fight"},
--     {name = "Ev Soygunu", export = "HouseRobbery"},
--     {name = "Humane Labs Soygunu", export = "HumaneRobery"},
--     {name = "Avlanma", export = "Hunting"},
--     {name = "Vatandaş Düştü", export = "InjuriedPerson"},
--     {name = "Polis Memuru Düştü", export = "OfficerDown"},
--     {name = "Ems Düştü", export = "EmsDown"},
--     {name = "Polis Destek Çağrısı", export = "OfficerBackup"},
--     {name = "Hapisten Kaçma", export = "PrisonBreak"},
--     {name = "Silah Ateşleme", export = "Shooting"},
--     {name = "Yol Tabelası Soygunu", export = "SignRobbery"},
--     {name = "Şüpheli Aktivite", export = "SuspiciousActivity"},
--     {name = "Tren Soygunu", export = "TrainRobbery"}
-- }


    RegisterNetEvent('avnc-panel:client:fakedispatchmenu',function()
local fakedispatchmenu = {
    id = 'fakedispatch_menu',
    title = config.SahteIhbar.Title,
    options = {}
}

for _, ihbar in ipairs(config.SahteIhbar.ihbarlar) do
    local ihbarexport = ihbar.export
    fakedispatchmenu.options[#fakedispatchmenu.options+1] = {

        title = ihbar.name,
        icon = ihbar.icon,
        iconAnimation = "fade",
        description = ihbar.description,
        onSelect = function()
            exports["ps-dispatch"][ihbarexport]()
        end
    }
end

if #fakedispatchmenu.options < 1 then 
    fakedispatchmenu.options[#fakedispatchmenu.options+1] = {
        title = locale("not_found"),
        disabled = true
    }
end


if #fakedispatchmenu.options > 0 then 
    fakedispatchmenu.options[#fakedispatchmenu.options+1] = {
        title = locale("go_back"),
        arrow = true,
        onSelect = function()
            lib.showContext("main_menu")
        end
    }
end


lib.registerContext(fakedispatchmenu)
lib.showContext(fakedispatchmenu.id)
    end)


    local startTimeout = true
    local normalTimeout = false
    
    Citizen.CreateThread(function()
        Wait(config.BankaHesabinasiz.baslangictimeout * 60000)
        startTimeout = false
    end)
    
    RegisterNetEvent('avnc=panel:client:randomplayer', function()
        if not startTimeout then
            if not normalTimeout then
                normalTimeout = true
                Citizen.SetTimeout(config.BankaHesabinasiz.timeout * 60000, function() -- 30 dakika (30 * 60 * 1000)
                    normalTimeout = false
                end)
        
                TriggerEvent("mhacking:show")
                TriggerEvent('mhacking:start', config.HackingMinigame.codecharacter, config.HackingMinigame.timeout, function(success)
                    if success then
                        TriggerServerEvent('avnc-panel:server:randomplayer')
                        TriggerEvent('mhacking:hide')
                        TriggerEvent('avnc-panel:client:openpanel')
                    else
                        TriggerEvent('mhacking:hide')
                        TriggerEvent('avnc-panel:client:openpanel')
                    end
                end)
            else
                QBCore.Functions.Notify(locale("usage_limit"), "error", 5000)
            end
        else
            QBCore.Functions.Notify(locale("start_timeout"), "error", 5000)
        end
    end)

    RegisterNetEvent('avnc-panel:client:aracimenu', function(playerData)
        local PlayerData = playerData.playerData -- Doğru değişken adını kullanıyoruz
        local araciMenu = {
            id = 'araci_Menu',
            title = ""..PlayerData.charinfo.firstname.." "..PlayerData.charinfo.lastname,
            options = {}
        }
        araciMenu.options[#araciMenu.options+1] = {
            title = locale("vehicle_query"),
            icon = "car",
            iconAnimation = "fade",
            description = locale("vehicle_query_description"),
            serverEvent = 'avnc-panel:server:arabasorgula',
            args = {
                citizenid = PlayerData.citizenid
            }
        }
        araciMenu.options[#araciMenu.options+1] = {
            title = locale("locate_from_phone"),
            icon = "phone",
            iconAnimation = "fade",
            description = locale("locate_from_phone_description"),
            serverEvent = 'avnc-panel:server:findlocation',
            args = {
                citizenid = PlayerData.citizenid
            }
        }

        lib.registerContext(araciMenu)
        lib.showContext(araciMenu.id)
    end)
    
    


    RegisterNetEvent('avnc-panel:client:menucreate', function(result, job)
        local menuData = {
            id = 'panel_menu',
            title = locale("avnc_cdv"),
            options = {}
        }
        for _, playerData in ipairs(result) do
            local playerDatadecharinfo = json.decode(playerData.charinfo)
            local playerDatademoney = json.decode(playerData.money)
            local playerDatadejob = json.decode(playerData.job)
            local citizenid = playerData.citizenid
            
            local gender = playerDatadecharinfo.gender == 0 and locale("male") or locale("female")
            local playerDataa = {}
            playerDataa.charinfo = playerDatadecharinfo
            playerDataa.money = playerDatademoney
            playerDataa.job = playerDatadejob
            playerDataa.citizenid = citizenid
        
            if playerDatadejob.name == job then
            menuData.options[#menuData.options+1] = {
                title = ""..playerDatadecharinfo.firstname.." "..playerDatadecharinfo.lastname,
                icon = "user",
                iconAnimation = "fade",
                description = locale("click_to_view_persons_vehicles"),
                -- onSelect = function()
                --     TriggerServerEvent('avnc-panel:server:arabasorgula', citizenid)
                -- end,
                event = 'avnc-panel:client:aracimenu',
                args = {
                    playerData = playerDataa
                },
                metadata = {
                    { label = locale("citizen_id"), value = citizenid},
                    { label = locale("gender"), value = gender},
                    { label = locale("phone_number"), value = playerDatadecharinfo.phone},
                    { label = locale("ethnicity"), value = playerDatadecharinfo.nationality},
                    { label = locale("bank_balance"), value = playerDatademoney.bank},
                    { label = locale("occupation"), value = playerDatadejob.label},
                    { label = locale("rank"), value = playerDatadejob.grade.name}
                }
            }
        elseif job == nil then
            menuData.options[#menuData.options+1] = {
                title = ""..playerDatadecharinfo.firstname.." "..playerDatadecharinfo.lastname,
                icon = "user",
                iconAnimation = "fade",
                description = locale("click_to_view_persons_vehicles"),
                event = 'avnc-panel:client:aracimenu',
                args = {
                    playerData = playerDataa
                },
                metadata = {
                    { label = locale("citizen_id"), value = citizenid},
                    { label = locale("gender"), value = gender},
                    { label = locale("phone_number"), value = playerDatadecharinfo.phone},
                    { label = locale("ethnicity"), value = playerDatadecharinfo.nationality},
                    { label = locale("bank_balance"), value = playerDatademoney.bank},
                    { label = locale("occupation"), value = playerDatadejob.label},
                    { label = locale("rank"), value = playerDatadejob.grade.name}
                }
            }
        end
        end
        if #menuData.options < 1 then 
            menuData.options[#menuData.options+1] = {
                title = locale("not_found"),
                disabled = true
            }
        end
        if #menuData.options > 0 then 
            menuData.options[#menuData.options+1] = {
                title = locale("go_back"),
                arrow = true,
                onSelect = function()
                    lib.showContext("main_menu")
                end
            }
        end
        lib.registerContext(menuData)
        lib.showContext(menuData.id)
    end)

    RegisterNetEvent('avnc-panel:client:vehiclemenucreate', function(result, plakaa)
        local menuData = {
            id = 'panel_menu',
            title = locale("avnc_cdv"),
            options = {}
        }
        for _, vehicleData in ipairs(result) do
            local vehiclesmods = json.decode(vehicleData.mods)
            local citizenid = vehicleData.citizenid
            
        
            menuData.options[#menuData.options+1] = {
                title = QBCore.Shared.Vehicles[vehicleData.vehicle].name,
                icon = "car",
                iconAnimation = "fade",
                description = locale("click_to_view_vehicle_owner"),
                -- onSelect = function()
                --     TriggerServerEvent('avnc-panel:server:arabasorgula', citizenid)
                -- end,
                serverEvent = 'avnc-panel:server:SearchPlayerforCitizenid',
                args = {
                    citizenid = citizenid
                },
                metadata = {
                    { label = locale("plate"), value = vehicleData.plate},
                    { label = locale("primary_color"), value = config.Renk[tostring(vehiclesmods.color1)]},
                    { label = locale("secondary_color"), value = config.Renk[tostring(vehiclesmods.color2)]},
                    { label = locale("pearlescent"), value = config.Renk[tostring(vehiclesmods.pearlescentColor)]}
                }
            }
        end
        if #menuData.options < 1 then 
            menuData.options[#menuData.options+1] = {
                title = locale("not_found"),
                disabled = true
            }
        end
        if #menuData.options > 0 then 
            menuData.options[#menuData.options+1] = {
                title = locale("goback"),
                arrow = true,
                onSelect = function()
                    lib.showContext("main_menu")
                end
            }
        end
        lib.registerContext(menuData)
        lib.showContext(menuData.id)
    end)

    RegisterNetEvent('avnc-panel:client:arabasorgula',function(result, citizenid, isimsoyisim)
        local arabaMenu = {
            id = 'car_menu',
            title = isimsoyisim,
            options = {}
        }
            for _, vehicleInfo in ipairs(result) do
                local vehiclesmods = json.decode(vehicleInfo.mods)
                arabaMenu.title = isimsoyisim
                arabaMenu.options[#arabaMenu.options+1] = {
                    title = QBCore.Shared.Vehicles[vehicleInfo.vehicle].name,
                    icon = "car",
                    iconAnimation = "fade",
                    metadata = {
                        { label = locale("plate"), value = vehicleInfo.plate},
                        { label = locale("primary_color"), value = config.Renk[tostring(vehiclesmods.color1)]},
                        { label = locale("secondary_color"), value = config.Renk[tostring(vehiclesmods.color2)]},
                        { label = locale("pearlescent"), value = config.Renk[tostring(vehiclesmods.pearlescentColor)]}
                    }
                    }
            end
            if #arabaMenu.options < 1 then 
                arabaMenu.options[#arabaMenu.options+1] = {
                    title = locale("not_found"),
                    disabled = true
                }
            end
            if #arabaMenu.options > 0 then 
                arabaMenu.options[#arabaMenu.options+1] = {
                    title = locale("goback"),
                    arrow = true,
                    onSelect = function()
                        lib.showContext("main_menu")
                    end
                }
            end
            lib.registerContext(arabaMenu)
            lib.showContext(arabaMenu.id)
    end)
    

RegisterNetEvent('avnc-panel:client:waypointlocation',function(position)
    if position then
        TriggerEvent("mhacking:show")
        TriggerEvent('mhacking:start', config.HackingMinigame.codecharacter, config.HackingMinigame.timeout, function(success)
            if success then
                TriggerEvent('showCoordinates', position)
                TriggerEvent('mhacking:hide')
            else
                QBCore.Functions.Notify(locale("fail_message"), 'error', 5000)
                TriggerEvent('mhacking:hide')
            end
        end)
    else
        print("Geçersiz koordinatlar. Lütfen doğru bir şekilde giriniz.")
    end

end)
local blip

RegisterNetEvent('showCoordinates')
AddEventHandler('showCoordinates', function(coords)
    blip = AddBlipForRadius(coords.x, coords.y, coords.z, config.locatephone.radius) -- 500.0 birim yarıçapı olan bir çember ekler
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1) -- Kırmızı renk
    SetBlipAlpha(blip, 120)
    removeblip()
end)
function removeblip()
    Wait(config.locatephone.wait)
    RemoveBlip(blip)
end

