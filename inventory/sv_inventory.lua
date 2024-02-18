Inventory = Inventory or {}

util.AddNetworkString("Inventory:UseItem")
util.AddNetworkString("Inventory:DrugEffect")
util.AddNetworkString("Inventory:RemoveDrugEffect")
util.AddNetworkString("Inventory:SuitOverlay")
util.AddNetworkString("Inventory:RemoveSuitOverlay")
util.AddNetworkString("Inventory:MoveItem")
util.AddNetworkString("Inventory:RefreshInventory")
util.AddNetworkString("Inventory:DropItem")

Inventory.EquipFunction = {
    weapon = function(class, ply)
        if not ply:Alive() then return false end
        if ply:HasWeapon(class) then 
            ply:SelectWeapon(class)
            return false 
        end

        ply:Give(class)
        ply:SelectWeapon(class)
        ply:GiveAmmo(ply:GetActiveWeapon():GetMaxClip1() * 2, ply:GetActiveWeapon():GetPrimaryAmmoType(), false)

        ply:AddInventory("case_blue", 100)

        return true
    end,

    suit = function(class, ply)
        if not ply:Alive() then return false end

        if ply.Suit then 
            ply:SetModel(ply.OldModel)
            ply:SetHealth(ply.OldHealth)
            ply:SetMaxHealth(ply.OldMaxHealth)
            ply:SetArmor(ply.OldArmor)
            ply:SetMaxArmor(ply.OldMaxArmor)
            ply:SetRunSpeed(ply.OldRunSpeed)
            ply:SetWalkSpeed(ply.OldWalkSpeed)
            ply:SetJumpPower(ply.OldJumpPower)
            ply:SetColor(ply.OldColor)
            ply.Suit = nil

            net.Start("Inventory:RemoveSuitOverlay")
            net.Send(ply)

            ply.suitCooldown = CurTime() + 5

            return false 
        end

        if ply.usingDrugs then
            ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
            return false
        end

        if ply.suitCooldown and ply.suitCooldown > CurTime() then
            ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You can't do this for another %ss.", math.Round(ply.suitCooldown - CurTime())))
            return false
        end

        ply.OldModel = ply:GetModel()
        ply.OldHealth = ply:Health()
        ply.OldMaxHealth = ply:GetMaxHealth()
        ply.OldArmor = ply:Armor()
        ply.OldMaxArmor = ply:GetMaxArmor()
        ply.OldRunSpeed = ply:GetRunSpeed()
        ply.OldWalkSpeed = ply:GetWalkSpeed()
        ply.OldJumpPower = ply:GetJumpPower()
        ply.OldColor = ply:GetColor()

        ply:SetModel(Inventory.Items[class].model)
        ply:SetHealth(Inventory.Items[class].health)
        ply:SetMaxHealth(Inventory.Items[class].health)
        ply:SetArmor(Inventory.Items[class].armor)
        ply:SetMaxArmor(Inventory.Items[class].armor)
        ply:SetRunSpeed(ply.OldRunSpeed * Inventory.Items[class].runSpeed)
        ply:SetWalkSpeed(ply.OldWalkSpeed * Inventory.Items[class].walkSpeed)
        ply:SetJumpPower(ply.OldJumpPower * Inventory.Items[class].jumpPower)
        ply:SetColor(Inventory.Items[class].color or Color(255,255,255))

        ply.Suit = class

        net.Start("Inventory:SuitOverlay")
            net.WriteString(class)
        net.Send(ply)

        return false
    end,

    drug = function(class, ply)
        if not ply:Alive() then return false end
        local func = Inventory.Items[class].callback(ply)

        if func then
            net.Start("Inventory:DrugEffect")
                    net.WriteString(class)
            net.Send(ply)
            return true
        else
            return false
        end
    end,

    case = function(class, ply)
        local totalChance = 0

        for _, reward in pairs(Inventory.Items[class].rewards) do
            totalChance = totalChance + reward.chance
        end

        local roll = math.random(1, totalChance)
        local cumulativeChance = 0

        for k, reward in pairs(Inventory.Items[class].rewards) do
            cumulativeChance = cumulativeChance + reward.chance

            if roll <= cumulativeChance then
                ply:AddInventory(k, reward.amount)
                ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You unboxed %sx %s.", reward.amount, Inventory.Items[k].name))
                return true
            end
        end
    end,
}


net.Receive("Inventory:UseItem", function(len, ply)
    local class = net.ReadString()
    
    if Inventory.Items[class].category == "upgrade" then return end

    if ply.Inventory[class] then
        local equipFunction = Inventory.EquipFunction[Inventory.Items[class].category](class, ply)
        if equipFunction then
            ply:AddInventory(class, -1)
        end
    end
end)

Inventory.DropFunction = {
    weapon = function(class, ply)
        if not ply:Alive() then return false end

        local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 85,
            filter = ply
        })

        local itemEntity = ents.Create("inventory_base_item")
        itemEntity:SetPos(tr.HitPos)
        itemEntity:SetAngles(Angle(0,0,0))
        itemEntity:Spawn()

        itemEntity:SetItem(class, Inventory.Items[class].model)

        return true
    end,

    suit = function(class, ply)
        if not ply:Alive() then return false end

        local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 85,
            filter = ply
        })

        local itemEntity = ents.Create("inventory_base_item")
        itemEntity:SetPos(tr.HitPos)
        itemEntity:SetAngles(Angle(0,0,0))
        itemEntity:Spawn()

        itemEntity:SetItem(class, "models/items/item_item_crate.mdl")

        return true
    end,

    drug = function(class, ply)
        if not ply:Alive() then return false end

        local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 85,
            filter = ply
        })

        local itemEntity = ents.Create("inventory_base_item")
        itemEntity:SetPos(tr.HitPos)
        itemEntity:SetAngles(Angle(0,0,0))
        itemEntity:Spawn()

        itemEntity:SetItem(class, Inventory.Items[class].model)
        itemEntity:SetColor(Inventory.Items[class].color)

        return true
    end,

    upgrade = function(class, ply)
        if not ply:Alive() then return false end

        local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 85,
            filter = ply
        })

        local itemEntity = ents.Create("inventory_base_item")
        itemEntity:SetPos(tr.HitPos)
        itemEntity:SetAngles(Angle(0,0,0))
        itemEntity:Spawn()

        itemEntity:SetItem(class, "models/props_lab/reciever01a.mdl")

        return true
    end,

    case = function(class, ply)
        if not ply:Alive() then return false end

        local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = ply:EyePos() + ply:GetAimVector() * 85,
            filter = ply
        })

        local itemEntity = ents.Create("inventory_base_item")
        itemEntity:SetPos(tr.HitPos)
        itemEntity:SetAngles(Angle(0,0,0))
        itemEntity:Spawn()

        itemEntity:SetItem(class, "models/items/item_item_crate.mdl")

        return true
    end
}

net.Receive("Inventory:DropItem", function(len, ply)
    local class = net.ReadString()

    if ply.Inventory[class] then

        if ply.droppedItems and ply.droppedItems >= 5 then
            ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't drop more than 5 items.")
            return
        end

        local dropFunction = Inventory.DropFunction[Inventory.Items[class].category](class, ply)
        ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You have dropped a %s.", Inventory.Items[class].name))
        ply.droppedItems = ply.droppedItems and ply.droppedItems + 1 or 1
        if dropFunction then
            ply:AddInventory(class, -1)
        end
    end
end)

local function slotToItem(ply, slot)
    for k, v in pairs(ply.Inventory) do
        if v.slot == slot then
            return k
        end
    end
end

net.Receive("Inventory:MoveItem", function(len, ply)
    local draggingSlot = net.ReadInt(8)
    local droppedSlot = net.ReadInt(8)

    if draggingSlot == droppedSlot then return end
    if droppedSlot > Inventory.MaxSlots or droppedSlot < 0 then return end

    local draggingItem = slotToItem(ply, draggingSlot)
    local droppedItem = slotToItem(ply, droppedSlot)

    local oldDraggingSlot = ply.Inventory[draggingItem]
    local oldDroppedSlot = ply.Inventory[droppedItem]

    if not oldDroppedSlot then
        ply.Inventory[draggingItem].slot = droppedSlot
    else
        ply.Inventory[draggingItem].slot = droppedSlot
        ply.Inventory[droppedItem].slot = draggingSlot
    end

    Driver:MySQLUpdate("player_inventory", {data = util.TableToJSON(ply.Inventory)}, "steamid=" .. ply:SteamID64(), function()
        net.Start("Inventory:RefreshInventory")
            net.WriteTable(ply.Inventory)
        net.Send(ply)
    end)
end)


hook.Add("PlayerDeath", "Inventory:PlayerDeath", function(victim, inflictor, attacker)
    if victim.Suit then
        victim:SetModel(victim.OldModel)
        victim:SetHealth(victim.OldHealth)
        victim:SetMaxHealth(victim.OldMaxHealth)
        victim:SetArmor(victim.OldArmor)
        victim:SetMaxArmor(victim.OldMaxArmor)
        victim:SetRunSpeed(victim.OldRunSpeed)
        victim:SetWalkSpeed(victim.OldWalkSpeed)
        victim:SetJumpPower(victim.OldJumpPower)
        victim:SetColor(victim.OldColor)
        victim:AddInventory(victim.Suit, -1)

        net.Start("Inventory:RemoveSuitOverlay")
        net.Send(victim)

        if attacker:IsPlayer() and attacker:IsValid() and attacker != victim then
            victim:ChatMessage("SUIT RIP", Color(156,3,3), string.format("%s ripped a %s.", attacker:Nick(), Inventory.Items[victim.Suit].name))
        end

        victim.Suit = nil
        victim.suitCooldown = CurTime() + 5
    end

    if victim.usingDrugs then
        victim.usingDrugs = false
        timer.Remove("drug_" .. victim:SteamID64())

        net.Start("Inventory:RemoveDrugEffect")
        net.Send(victim)
    end
end)


hook.Add("PlayerSay", "Inventory:PlayerSay", function(ply, text)
    if text == "/holster" then
        local class = ply:Alive() and ply:GetActiveWeapon():GetClass() or ""

        if Inventory.Items[class] then
            ply:ChatMessage("INVENTORY", Color(0,162,255), "You have holstered your weapon into your inventory.")
            ply:AddInventory(class, 1)
            ply:StripWeapon(class)
        else
            ply:ChatMessage("INVENTORY", Color(0,162,255), ply:Alive() and "You can't holster this weapon." or "You can't do this currently.")
        end

        return ""
    end

    if text == "/drop" then
        local class = ply:Alive() and ply:GetActiveWeapon():GetClass() or ""


        if Inventory.Items[class] then
            Inventory.DropFunction[Inventory.Items[class].category](class, ply)
            ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You have dropped a %s.", Inventory.Items[class].name))
            ply:StripWeapon(class)
        else
            ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't drop this weapon.")
        end

        return ""
    end
end)

hook.Add("EntityTakeDamage", "Inventory:EntityTakeDamage", function(target, dmg)
    local attacker = dmg:GetAttacker()

    if not target:IsPlayer() then return end
    if attacker:IsPlayer() and attacker:IsValid() and attacker:HasItem("upgrade_scopeboost") then
        if attacker:GetActiveWeapon().Base == "bobs_scoped_base" then
            dmg:ScaleDamage(2)
        end
    end
end)