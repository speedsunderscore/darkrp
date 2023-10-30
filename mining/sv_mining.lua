Mining = Mining or {}

sql.Query("CREATE TABLE IF NOT EXISTS mining_minerals (sid BIGINT, mineral VARCHAR(40), amount BIGINT)")

local META = FindMetaTable("Player")


util.AddNetworkString("Mining.AddMinerals")


hook.Add("PlayerInitialSpawn", "Mining.Initialize", function(ply)

    timer.Simple(1, function()

        local sid = ply:SteamID64()

        ply.Mining = {}

        ply.Mining.Minerals = {}

        for k, v in pairs(Mining.Minerals) do

            local query = sql.Query(string.format("SELECT amount FROM mining_minerals WHERE sid = '%s' AND mineral = '%s'", sid, v.class))

            if not query then
                
                sql.Query(string.format("INSERT INTO mining_minerals (sid, mineral, amount) VALUES ('%s', '%s', '%s')", sid, v.class, 0))

            end

            local amount = query and query[1].amount or 0

            ply.Mining.Minerals[v.class] = amount

        end


        net.Start("Mining.AddMinerals")

        net.WriteTable(ply.Mining.Minerals)

        net.Send(ply)
        
    end)

end)


function META:GiveMineral(mineral, amount)

    local sid = self:SteamID64()

    if not Mining.Minerals[mineral] then print("invalid mineral") return end

    local currentAmount = self.Mining.Minerals[mineral]

    local maxAmount = Mining.Minerals[mineral].maxAmt

    local wantedAmount = currentAmount + amount

    local toset = 0


    if wantedAmount >= maxAmount then
        
        toset = maxAmount

    elseif wantedAmount <= 0 then
        
        toset = 0

    else

        toset = wantedAmount

    end


    self.Mining.Minerals[mineral] = toset

    sql.Query(string.format("UPDATE mining_minerals SET amount = '%s' WHERE sid = '%s' AND mineral = '%s'", toset, sid, mineral))

    net.Start("Mining.AddMinerals")

    net.WriteTable(self.Mining.Minerals)

    net.Send(self)

end


concommand.Add("addmineral", function(ply, cmd, args)

    ply:GiveMineral(tostring(args[1]), tonumber(args[2]))

end)