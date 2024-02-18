hook.Add("PlayerDisconnected", "Money:PlayerDisconnected", function(ply)
    local money = ply:GetMoney()

    Driver:MySQLUpdate("player_money", {amount = money}, "steamid=" .. ply:SteamID64(), function()
        print("Player disconnected... Setting money in database to ", money)
    end)
end)