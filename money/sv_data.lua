hook.Add("DatabaseInitialized", "Money:CreateDatabase", function()
    Driver:MySQLCreateTable("player_money", {
        steamid = "BIGINT",
        amount = "BIGINT"
    }, "steamid")
end)


hook.Add("PlayerInitialSpawn", "Money:LoadPlayer", function(ply)
    Driver:MySQLSelect("player_money", "steamid=" .. ply:SteamID64(), function(data)
        if not data or #data == 0 then
            Driver:MySQLInsert("player_money", {
                steamid = ply:SteamID64(),
                amount = 5000,
            }, function()
                ply:SetMoney(5000)
            end)
        else
            local amount = data[1]["amount"]
            ply:SetMoney(537256)
        end
    end)
end)