Inventory = Inventory or {}


// Create an inventory on the local player
net.Receive("Inventory.Initialize", function()

    LocalPlayer().Inventory = {}

end)


// Add an item to the local players inventory
net.Receive("Inventory.AddItem", function()

    local slot = net.ReadUInt(8)

    local item = net.ReadString()

    local amount = net.ReadUInt(16)


    LocalPlayer().Inventory[slot] = {item = item, amount = amount}

end)


local function InventoryToggle()

    if Inventory.Frame then 

        Inventory.Frame:Remove()

        Inventory.Frame = nil

    end


    Inventory.Frame = Inventory.Frame or CheadleUI.Frame(ScrW() * 0.5, ScrH() * 0.5, "Inventory", CheadleUI.GetFont("Montserrat", 30), Color(20,20,20), Color(40,40,40), false, false)

    Inventory.Boolean = !Inventory.Boolean

    Inventory.Frame:SetVisible(Inventory.Boolean)

    gui.EnableScreenClicker(Inventory.Boolean)

    function Inventory.Frame:OnKeyCodePressed(key)

        local lookup = input.LookupBinding("gm_showspare2")

        local keyBind = input.GetKeyName(key)

        if lookup == keyBind then

            Inventory.Boolean = !Inventory.Boolean

            Inventory.Frame:SetVisible(Inventory.Boolean)

            gui.EnableScreenClicker(Inventory.Boolean)

            Inventory.Frame:Remove()

            Inventory.Frame = nil

        end

    end


    local backPanel = CheadleUI.Panel(Inventory.Frame, Color(15,15,15))

    CheadleUI.SetSize(backPanel, 99.2, 86)

    CheadleUI.SetPos(backPanel, 0.5, 0, 99.2, 4)


    local searchbar = CheadleUI.Textbox(Inventory.Frame, CheadleUI.GetFont("Montserrat", 18), Color(15,15,15))
    
    CheadleUI.SetSize(searchbar, 30, 5)

    CheadleUI.SetPos(searchbar, 0.5, 0, 7.3, 3)

    searchbar:SetPlaceholderText("Search...")

    searchbar:SetCursorColor(Color(255,255,255))


    local scrollPanel = vgui.Create("DScrollPanel", backPanel)

    scrollPanel:Dock(FILL)

    scrollPanel:GetVBar():SetWide(0)


    local layoutPanel = vgui.Create("DIconLayout", scrollPanel)

    layoutPanel:Dock(FILL)

    layoutPanel:DockMargin(5,5,5,0)

    layoutPanel:SetSpaceY(5)

    layoutPanel:SetSpaceX(5)


    for i = 1, Inventory.MaxSlots do
        
        local inInventory = LocalPlayer().Inventory[i]

        local itemData


        if inInventory then

            itemData = Inventory.Items[inInventory.item]

        end


        local itemPanel = layoutPanel:Add("DPanel")

        itemPanel:SetSize(backPanel:GetWide() / 9 - 5, backPanel:GetWide()/9)

        itemPanel.Paint = function(self, w, h)
                
                draw.RoundedBox(0,0,0,w,h,Color(40,40,40))

        end


        if inInventory then

            local image = vgui.Create("DImage", itemPanel)
            
            image:SetImage(itemData.background)

            image:SetImageColor(Inventory.Raritys[itemData.rarity].color)

            image:SetSize(itemPanel:GetTall(), itemPanel:GetTall())

            CheadleUI.SetPos(image, 50, 1, itemData.pos or 0, 0)

                
            local icon = vgui.Create("DModelPanel", itemPanel)

            CheadleUI.SetSize(icon, 100, 85)

            CheadleUI.SetPos(icon, 0, 0, 100, 4)

            icon:SetModel(itemData.model)

            icon:SetFOV(itemData.settings and itemData.settings.fov or 25)

            icon.Entity:SetPos(itemData.settings and itemData.settings.pos or Vector(0,0,0))

            function icon:LayoutEntity(entity)

                entity:SetAngles(itemData.settings and itemData.settings.rot or Angle(0,0,0))

            end


            local itemName = CheadleUI.Panel(itemPanel, Color(255,255,255))

            CheadleUI.SetSize(itemName, 100, 15)

            itemName.Paint = function(self, w, h)

                local size = 15

                while size >=1 do 

                    surface.SetFont(CheadleUI.GetFont("Montserrat", size))

                    local textWidth, textHeight = surface.GetTextSize(itemData.name)

                    if textWidth <= w and textHeight <= h then 
                        
                        break 
                    
                    end

                    size = size - 1

                end

                draw.RoundedBoxEx(0, 0, 0, w, h, Color(0,0,0,255), true, true, false, false)

                draw.SimpleText(itemData.name, CheadleUI.GetFont("Montserrat", size), w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            end


            local itemAmount = CheadleUI.Panel(itemPanel, Color(255,255,255))

            CheadleUI.SetSize(itemAmount, 100, 15)

            CheadleUI.SetPos(itemAmount, 1, 0, 100, 4)

            itemAmount.Paint = function(self, w, h)

                surface.SetFont(CheadleUI.GetFont("Montserrat", 15))

                local textWidth, textHeight = surface.GetTextSize(inInventory.amount .. "x")

                draw.SimpleText(inInventory.amount .. "x", CheadleUI.GetFont("Montserrat", 15), 1, h - textHeight/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            end



        end

        local buttonPanel = vgui.Create("DButton", itemPanel)
            
        buttonPanel:SetSize(itemPanel:GetWide(), itemPanel:GetTall())

        buttonPanel:SetText("")

        buttonPanel.Paint = function(self, w, h)

        end

        buttonPanel.DoRightClick = function()

            if not inInventory then return end

            local menu = DermaMenu()

            if itemData.category == "weapon" then

                menu:AddOption("Equip " .. itemData.name, function()

                    net.Start("Inventory.EquipItem")

                    net.WriteUInt(i, 8)

                    net.WriteString(inInventory.item)

                    net.SendToServer()

                end)

            end


            for k, v in pairs(menu:GetCanvas():GetChildren()) do
                
                v:SetTextColor(Color(255,255,255))

                v.Paint = function(self, w, h)

                    draw.RoundedBox(0, 0, 0, w, h, Color(20,20,20))

                    if self.Hovered then
                            
                        draw.RoundedBox(0, 3, 3, w - 6, h - 6, Color(25,25,25))

                    end

                end

            end

            menu:Open(gui.MouseX(), gui.MouseY())

        end

        buttonPanel.Slot = i

        if inInventory then
            
            buttonPanel:SetCursor("sizeall")

            
            CheadleUI.Popup(buttonPanel, function(x, y)

                surface.SetFont(CheadleUI.GetFont("Montserrat", 18))

                local textWidth, textHeight = surface.GetTextSize(itemData.name)

                surface.SetFont(CheadleUI.GetFont("Montserrat", 12))

                local rarityWidth, rarityHeight = surface.GetTextSize(Inventory.Raritys[itemData.rarity].name)
                

                local padding = 3

                draw.RoundedBox(4, x - padding + 15, y - padding - 6 - rarityHeight, textWidth + padding * 2, textHeight + padding * 2 + rarityHeight, Color(20,20,20))

                draw.SimpleText(itemData.name, CheadleUI.GetFont("Montserrat", 18), x + 15, y - 6 - rarityHeight, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                draw.SimpleText(Inventory.Raritys[itemData.rarity].name, CheadleUI.GetFont("Montserrat", 12), x + 15, y , Inventory.Raritys[itemData.rarity].color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            end)

        end

    end


    searchbar.OnValueChange = function(self, value)

        for i = 1, Inventory.MaxSlots do
            
            local inInventory = LocalPlayer().Inventory[i]

            local itemData

            if inInventory then
                
                itemData = Inventory.Items[inInventory.item]

                local shouldShow = string.find(string.lower(itemData.name), string.lower(value)) or value == ""

                local itemPanel = layoutPanel:GetChildren()[i]

                itemPanel:SetAlpha(shouldShow and 255 or 20)

            end

        end

    end

end


local dragged

local draggingSlot

hook.Add("CreateMove", "Inventory.DragAndDrop", function()

    if not Inventory.Boolean then return end

    if gui.IsConsoleVisible() then return end


    if input.WasMousePressed(MOUSE_LEFT) and not dragged then
        
        local hovered = vgui.GetHoveredPanel()

        if LocalPlayer().Inventory[hovered.Slot] then

            dragged = LocalPlayer().Inventory[hovered.Slot].item

            draggingSlot = hovered.Slot

        end


    elseif input.WasMouseReleased(MOUSE_LEFT) and dragged then

        
        local dropped = vgui.GetHoveredPanel()

        if dropped and dropped.Slot then

            local droppedItemSlot = LocalPlayer().Inventory[dropped.Slot]

            if draggingSlot ~= dropped.Slot then
                
                net.Start("Inventory.DraggedItem")

                net.WriteUInt(draggingSlot, 8)

                net.WriteUInt(dropped.Slot, 8)

                net.SendToServer()

            end


            dragged = nil 

            draggingSlot = nil

        end
        
    end

end)


net.Receive("Inventory.DraggedItem", function()

    local oldSlot = net.ReadUInt(8)

    local slot = net.ReadUInt(8)

    local oldSlotData = LocalPlayer().Inventory[oldSlot]

    local slotData = LocalPlayer().Inventory[slot]


    LocalPlayer().Inventory[oldSlot] = nil 

    LocalPlayer().Inventory[slot] = nil 

    LocalPlayer().Inventory[slot] = {item = oldSlotData.item, amount = oldSlotData.amount}


    if slotData then
        
        LocalPlayer().Inventory[oldSlot] = {item = slotData.item, amount = slotData.amount}

    end

    if Inventory.Frame then
            
        InventoryToggle()

        InventoryToggle()

    end

end)


net.Receive("Inventory.RemoveItem", function()

    local slot = net.ReadUInt(8)

    local item = net.ReadString()

    local amount = net.ReadUInt(32)


    if amount == 0 then
        
        LocalPlayer().Inventory[slot] = nil

    else
        
        LocalPlayer().Inventory[slot] = {item = item, amount = amount}

    end

    if Inventory.Frame then
            
        InventoryToggle()

        InventoryToggle()

    end

end)

hook.Add("PlayerBindPress", "Inventory.F4", function(ply, bind, pressed)

    if bind == "gm_showspare2" then
        
        InventoryToggle()

    end

end)