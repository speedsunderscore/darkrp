local META = FindMetaTable("Player")

Inventory = Inventory or {}
Inventory.Items = Inventory.Items or {}

function META:AddInventory(class, amount)
    if not Inventory.Items[class] then return end

    local nextSlotIndex = 1
    local usedSlots = {}

    for _, v in pairs(self.Inventory) do
        local slot = v.slot
        usedSlots[slot] = true
    end

    for i = 1, Inventory.MaxSlots do
        if not usedSlots[i] then
            nextSlotIndex = i
            break
        end
    end

    if not self.Inventory[class] then
        self.Inventory[class] = {amount = amount, slot = nextSlotIndex}
    else
        local current = self.Inventory[class].amount
        if current + amount <= 0 then
            self.Inventory[class] = nil
            current = 0
        else
            current = current + amount
        end
        if self.Inventory[class] then
            self.Inventory[class] = {amount = current, slot = self.Inventory[class].slot}
        end
    end

     Driver:MySQLUpdate("player_inventory", {data = util.TableToJSON(self.Inventory)}, "steamid=" .. self:SteamID64(), function()
        net.Start("Inventory:RefreshInventory")
            net.WriteTable(self.Inventory)
        net.Send(self)
    end)
end

function META:HasItem(class)
    if not self.Inventory[class] then return false end
    return true
end