local META = FindMetaTable("Player")

function META:AddMoney(amount)
    local current = self:GetMoney()
    local target = current + amount
    local new = math.max(0, target)
    self:SetNWInt("money", new)
    
    Driver:MySQLUpdate("player_money", {amount = new}, "steamid=" .. self:SteamID64(), function()
        print("Adding money: ", new)
    end)
end


function META:SetMoney(amount)
    local new = math.max(0, amount)
    self:SetNWInt("money", new)

    Driver:MySQLUpdate("player_money", {amount = new}, "steamid=" .. self:SteamID64(), function()
        print("Setting money: ", new)
    end)
end