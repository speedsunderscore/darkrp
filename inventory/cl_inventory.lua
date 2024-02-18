net.Receive("Inventory:Initialize", function()
    local inventoryTable = net.ReadTable()
    LocalPlayer().Inventory = inventoryTable

    if F4.Frame then
        inventoryLayout:Clear()
        CreateInventoryScrollingPanel()
    end
end)


net.Receive("Inventory:DrugEffect", function()
    local class = net.ReadString()

    if class == "amphetamine" then
        hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
        hook.Add("RenderScreenspaceEffects", "Inventory:DrugEffect", function()
            Inventory.Items[class].rendereffects()
        end)

        timer.Simple(30, function()
            hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
        end)

    elseif class == "morphine" then
        hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
        hook.Add("RenderScreenspaceEffects", "Inventory:DrugEffect", function()
            Inventory.Items[class].rendereffects()
        end)

        timer.Simple(45, function()
            hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
        end)

    elseif class == "radiationpill" then
        hook.Remove("HUDPaint", "Inventory:DrugEffect")
        hook.Add("HUDPaint", "Inventory:DrugEffect", function()
            Inventory.Items[class].hudpaint()
        end)

        hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
        hook.Add("RenderScreenspaceEffects", "Inventory:DrugEffect", function()
            Inventory.Items[class].rendereffects()
        end)

        timer.Simple(5, function()
            hook.Remove("HUDPaint", "Inventory:DrugEffect")
            hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
        end)
    end
end)


net.Receive("Inventory:RemoveDrugEffect", function()
    hook.Remove("RenderScreenspaceEffects", "Inventory:DrugEffect")
    hook.Remove("HUDPaint", "Inventory:DrugEffect")
end)


concommand.Add("inventory_equip", function(ply, cmd, args)
    local class = args[1]

    net.Start("Inventory:UseItem")
        net.WriteString(class)
    net.SendToServer()
end)


net.Receive("Inventory:SuitOverlay", function()
    local class = net.ReadString()

    if class == "suit_juggernaut" then
        hook.Remove("HUDPaint", "Inventory:SuitOverlay")
        hook.Add("HUDPaint", "Inventory:SuitOverlay", function()
            Inventory.Items[class].hudpaint()
        end)

        hook.Remove("RenderScreenspaceEffects", "Inventory:SuitOverlay")
        hook.Add("RenderScreenspaceEffects", "Inventory:SuitOverlay", function()
            Inventory.Items[class].rendereffects()
        end)
    end
end)


net.Receive("Inventory:RemoveSuitOverlay", function()
    hook.Remove("RenderScreenspaceEffects", "Inventory:SuitOverlay")
    hook.Remove("HUDPaint", "Inventory:SuitOverlay")
end)