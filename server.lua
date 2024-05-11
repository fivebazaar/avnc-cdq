local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

QBCore.Functions.CreateUseableItem(config.TabletItem, function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)
	if not Player.Functions.GetItemByName(item.name) then return end
	TriggerClientEvent('avnc-panel:client:openpanel', source)
    print("sa")
end)

RegisterNetEvent('avnc-panel:server:findlocation', function(citizenid)
    local source = source
    local PlayerByCitizenID = QBCore.Functions.GetPlayerByCitizenId(citizenid.citizenid)
    
    if PlayerByCitizenID ~= nil then
        local playerPed = GetPlayerPed(PlayerByCitizenID.PlayerData.source)
        
        if playerPed ~= 0 then
            local coords = GetEntityCoords(playerPed)
            local position = vector3(coords.x, coords.y, coords.z)
            TriggerClientEvent('avnc-panel:client:waypointlocation', source, position)
        else
            print("Player ped not found for the specified player.")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'Yerini tespit etmeye çalıştığın kişinin telefonu açık değil', 'error', 5000)
    end
end)



RegisterNetEvent('avnc-panel:server:SearchPlayer', function(playerName, job)
    local source = source
    if playerName then
        local firstName = playerName.firstname
        local lastName = playerName.lastname
        if firstName then
            exports.oxmysql:execute('SELECT *, citizenid, charinfo, job, money FROM players WHERE charinfo LIKE @firstname', {
                ['@firstname'] = '%' .. firstName .. '%'
            }, function(result)
                if result then
                    TriggerClientEvent('avnc-panel:client:menucreate', source, result, job)
                else
                    print("sonuç yok")
                end
            end)
        else
            print("Geçersiz isim formatı")
        end
    else
        print("Geçersiz giriş")
    end
end, true)

RegisterNetEvent('avnc-panel:server:SearchPlayerforCitizenid', function(citizenid)
    local source = source
    if citizenid then
        exports.oxmysql:execute('SELECT *, citizenid, job, money FROM players WHERE citizenid = @citizenid', {
            ['@citizenid'] = citizenid.citizenid
        }, function(result)
            if result then
                TriggerClientEvent('avnc-panel:client:menucreate', source, result)
            else
                print("Sonuç bulunamadı")
            end
        end)
    else
        print("Geçersiz isim formatı")
    end
end)


RegisterNetEvent('avnc-panel:server:SearchVehicle', function(plaka)
    print(plaka)
    local source = source
        if plaka then
            exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = @plate', {
                ['@plate'] = plaka
            }, function(result)
                if result then
                    TriggerClientEvent('avnc-panel:client:vehiclemenucreate', source, result, plaka)
                else
                    print("Database Error")
                end
            end)
        else
            print("Geçersiz isim formatı")
        end
end, true)

RegisterNetEvent('avnc-panel:server:phonequery', function(phone)
    local source = source
        if phone then
            exports.oxmysql:execute('SELECT * FROM players WHERE charinfo LIKE @phone', {
                ['@phone'] = '%' .. phone .. '%' -- Telefon numarasının herhangi bir yere eşleşmesini sağlamak için % işaretlerini ekledik
            }, function(result)
                if result then
                    TriggerClientEvent('avnc-panel:client:menucreate', source, result)
                else
                    print("Database Error")
                end
            end)
        else
            print("Geçersiz isim formatı")
        end
end, true)

RegisterNetEvent('avnc-panel:server:arabasorgula', function(citizenid, type)
    local source = source
    local citizenidd
    citizenidd = citizenid.citizenid
    if citizenidd then
        exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid', {['@citizenid'] = citizenidd}, function(result)
            if result then
                exports.oxmysql:execute('SELECT charinfo FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenidd}, function(charinfoResult)
                    if charinfoResult then
                        local charinfo = charinfoResult[1].charinfo
                        print(charinfoResult[1].charinfo)
                        local charinfodecoded = json.decode(charinfo)
                        local isimsoyisim = charinfodecoded.firstname.." "..charinfodecoded.lastname
                        TriggerClientEvent('avnc-panel:client:arabasorgula', source, result, citizenidd, isimsoyisim)
                    else
                        print('Belirtilen citizenid\'ye sahip karakter bilgisi bulunamadı.')
                    end
                end)
            else
                print('Belirtilen citizenid\'ye sahip araç bulunamadı.')
            end
        end)
    end
end, true)

function getRandomActivePlayerCitizenID()
    local players = QBCore.Functions.GetQBPlayers()
    if #players > 0 then
        local randomIndex = math.random(1, #players)
        local randomPlayer = players[randomIndex]
        local citizenID = randomPlayer.PlayerData.citizenid
        return citizenID
    else
        print("Aktif oyuncu bulunamadı.")
        return nil
    end
end

RegisterNetEvent('avnc-panel:server:randomplayer', function()
    local source = source
    local randomCitizenID = getRandomActivePlayerCitizenID(source)
    local Player = QBCore.Functions.GetPlayer(source)

    if randomCitizenID then
        if randomCitizenID == Player.PlayerData.citizenid then
            -- Yeniden çek
            randomCitizenID = getRandomActivePlayerCitizenID()
            if randomCitizenID and randomCitizenID == Player.PlayerData.citizenid then
                TriggerClientEvent('QBCore:Notify', source, locale("bankahesabinasiznohuman"), "error", 5000)
                return
            end
        end

        local randomPlayer = QBCore.Functions.GetPlayerByCitizenId(randomCitizenID)
        if randomPlayer then
            if randomPlayer.Functions.RemoveMoney('bank', 10) then
                Player.Functions.AddMoney('bank', 5)
                TriggerClientEvent('QBCore:Notify', randomPlayer.PlayerData.source, locale("bankahesabinawithdraw"), 'error', 10000)
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, locale("bankahesabinadeposit"), 'success', 10000)
            end
        end
    end
end)
