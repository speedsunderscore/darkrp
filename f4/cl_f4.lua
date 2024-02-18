F4 = F4 or {}
F4.Config = F4.Config or {}
F4.Config.Tabs = F4.Config.Tabs or {}

local panelInstances = {}
local inventoryScreen
local inventoryScroller
local inventoryLayout

function F4:CreateMenu()
    F4.Frame = F4.Frame or CheadleUI.Frame(ScrW()*0.5, ScrH()*0.5, GetHostName(), CheadleUI.GetFont("Montserrat", 30), Color(20,20,20), Color(35,35,35), false, false)

    F4.Bool = !F4.Bool
    F4.Frame:SetVisible(F4.Bool)
    gui.EnableScreenClicker(F4.Bool)


    -- To close the menu without breaking Popup
    function F4.Frame:OnKeyCodePressed(key)
        local lookup = input.LookupBinding("gm_showspare2")
        local keyBind = input.GetKeyName(key)

        if lookup == keyBind then
            F4.Bool = !F4.Bool
            F4.Frame:SetVisible(F4.Bool)
            gui.EnableScreenClicker(F4.Bool)
            F4.Frame:Remove()
            F4.Frame = nil
        end
    end

    local sidePanel = CheadleUI.Panel(F4.Frame, Color(35,35,35))
    CheadleUI.SetSize(sidePanel, 24, 93)
    CheadleUI.SetPos(sidePanel, .4, 0, 99.5, 4)

    local inventoryPanel = CheadleUI.Panel(F4.Frame, Color(35,35,35))
    CheadleUI.SetSize(inventoryPanel, 75, 93)
    CheadleUI.SetPos(inventoryPanel, 99.7, 2, 99.5, 4)
    inventoryPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(35,35,35))
        draw.SimpleText("Inventory", CheadleUI.GetFont("Montserrat", 30), w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    function CreateInventoryScrollingPanel()
        inventoryScreen = CheadleUI.Panel(inventoryPanel, Color(30,30,30))
        CheadleUI.SetSize(inventoryScreen, 99, 92)
        CheadleUI.SetPos(inventoryScreen, 50, 1, 99.4, 4)

        inventoryScroller = vgui.Create("DScrollPanel", inventoryScreen)
        inventoryScroller:SetSize(inventoryScreen:GetWide(), inventoryScreen:GetTall())
        inventoryScroller:GetVBar():SetWide(15)
        inventoryScroller:Dock(FILL)

        local vBar = inventoryScroller:GetVBar()

        vBar.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(45,45,45,200))
        end

        vBar.btnGrip.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(150, 150, 150, 100))
        end


        inventoryLayout = vgui.Create("DIconLayout", inventoryScroller)
        inventoryLayout:SetSpaceY(5)
        inventoryLayout:SetSpaceX(5)
        inventoryLayout:Dock(FILL)
        inventoryLayout:DockMargin(5,5,5,5)

        local scrollbarWidth = inventoryScroller:GetVBar():GetWide()
        local itemWidth = (inventoryScreen:GetWide() - inventoryLayout:GetDockMargin() * 2 - (6 - 1) * inventoryLayout:GetSpaceX() - scrollbarWidth) / 6

        for i = 1, Inventory.MaxSlots do
            local itemPanel = inventoryLayout:Add("DPanel")
            itemPanel:SetSize(itemWidth, itemWidth)
            itemPanel.slot = i
            itemPanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(45,45,45))
            end
        end

        for k, v in pairs(LocalPlayer().Inventory) do
            local match

            for _, panel in pairs(inventoryLayout:GetChildren()) do
                if panel.slot == v.slot then
                    match = panel
                    match.slot = panel.slot
                    break
                end
            end

            if match then
                match.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(25,25,25))
                end

                local image = match:Add("DImage")
                image:SetImage("items/polygon.png")
                image:SetImageColor(Inventory.Rarity[Inventory.Items[k].rarity].color)
                image:SetSize(match:GetWide(), match:GetTall())


                if not Inventory.Items[k].image then
                    local modelIcon = match:Add("DModelPanel")
                    CheadleUI.SetSize(modelIcon, 100, 85)
                    CheadleUI.SetPos(modelIcon, 0, 0, 100, 4)
                    modelIcon:SetModel(Inventory.Items[k].model)
                    modelIcon:SetFOV(Inventory.Items[k].settings.fov)
                    modelIcon:SetColor(Inventory.Items[k].color or Color(255,255,255))
                    modelIcon.Entity:SetPos(Inventory.Items[k].settings and Inventory.Items[k].settings.pos or Vector(0,0,0))
                    function modelIcon:LayoutEntity(ent)
                        ent:SetAngles(Inventory.Items[k].settings and Inventory.Items[k].settings.rot or Vector(0,0,0))
                    end
                elseif Inventory.Items[k].image then
                    local image = match:Add("DImage")
                    image:SetImage(Inventory.Items[k].image)
                    image:SetImageColor(Inventory.Items[k].color or Color(255,255,255))
                    image:SetPos(Inventory.Items[k].posx or 0,Inventory.Items[k].posy or 0)
                    image:SetSize(match:GetWide() * Inventory.Items[k].scale, match:GetTall() * Inventory.Items[k].scale)
                end

                local itemName = CheadleUI.Panel(match, Color(255,255,255))
                CheadleUI.SetSize(itemName, 100, 15)
                itemName.Paint = function(self, w, h)
                    local size = 15
                    while size >=1 do 
                        surface.SetFont(CheadleUI.GetFont("Montserrat", size))
                        local textWidth, textHeight = surface.GetTextSize(Inventory.Items[k].name)
                        if textWidth <= w and textHeight <= h then 
                            break 
                        end
                        size = size - 1
                    end
                    draw.RoundedBoxEx(0, 0, 0, w, h, Color(0,0,0,200), true, true, false, false)
                    draw.SimpleText(Inventory.Items[k].name, CheadleUI.GetFont("Montserrat", size), w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end

                local itemAmount = CheadleUI.Panel(match, Color(255,255,255))
                CheadleUI.SetSize(itemAmount, 100, 15)
                CheadleUI.SetPos(itemAmount, 1, 0, 100, 4)
                itemAmount.Paint = function(self, w, h)
                    surface.SetFont(CheadleUI.GetFont("Montserrat", 15))
                    local textWidth, textHeight = surface.GetTextSize(v.amount .. "x")
                    draw.SimpleText(v.amount .. "x", CheadleUI.GetFont("Montserrat", 15), 1, h - textHeight/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local buttonPanel = vgui.Create("DButton", match)
                buttonPanel:SetSize(match:GetWide(), match:GetTall())
                buttonPanel:SetText("")
                buttonPanel.Paint = function(self, w, h)
                end
                buttonPanel.DoRightClick = function()
                    local menu = DermaMenu()

                    if Inventory.Items[k].category != "upgrade" then
                        menu:AddOption("Use " .. Inventory.Items[k].name, function()
                            net.Start("Inventory:UseItem")
                                net.WriteString(k)
                            net.SendToServer()
                        end)
                    end

                    menu:AddOption("Drop " .. Inventory.Items[k].name, function()
                        net.Start("Inventory:DropItem")
                            net.WriteString(k)
                        net.SendToServer()
                    end)

                    menu:Open(gui.MouseX(), gui.MouseY())
                end

                buttonPanel:SetCursor("sizeall")
                buttonPanel.slot = v.slot
            end
            
        end
    end
    CreateInventoryScrollingPanel()
    panelInstances["inventoryPanel"] = inventoryPanel

    local jobsPanel = CheadleUI.Panel(F4.Frame, Color(35,35,35))
    CheadleUI.SetSize(jobsPanel, 75, 93)
    CheadleUI.SetPos(jobsPanel, 99.7, 2, 99.5, 4)
    jobsPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(35,35,35))
        draw.SimpleText("Jobs", CheadleUI.GetFont("Montserrat", 30), w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    panelInstances["jobsPanel"] = jobsPanel

    local storePanel = CheadleUI.Panel(F4.Frame, Color(35,35,35))
    CheadleUI.SetSize(storePanel, 75, 93)
    CheadleUI.SetPos(storePanel, 99.7, 2, 99.5, 4)
    storePanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(35,35,35))
        draw.SimpleText("Store", CheadleUI.GetFont("Montserrat", 30), w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    panelInstances["storePanel"] = storePanel

    local settingsPanel = CheadleUI.Panel(F4.Frame, Color(35,35,35))
    CheadleUI.SetSize(settingsPanel, 75, 93)
    CheadleUI.SetPos(settingsPanel, 99.7, 2, 99.5, 4)
    settingsPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(35,35,35))
        draw.SimpleText("Settings", CheadleUI.GetFont("Montserrat", 30), w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    panelInstances["settingsPanel"] = settingsPanel

    local infoPanel = CheadleUI.Panel(sidePanel, Color(45,45,45))
    CheadleUI.SetSize(infoPanel, 98, 20)
    CheadleUI.SetPos(infoPanel, 50, 1, .4, 3)
    infoPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(45,45,45))
        draw.SimpleText(LocalPlayer():Nick(), CheadleUI.GetFont("Montserrat", 16), 100, 1, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(formatMoney(LocalPlayer():GetMoney()), CheadleUI.GetFont("Montserrat", 16), 100, 20, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local avatar = vgui.Create("AvatarImage", infoPanel)
    avatar:SetSize(90,90)
    avatar:SetPlayer(LocalPlayer(), 80)
    avatar:SetPos(5,5)

    local buttonsPanel = CheadleUI.Panel(F4.Frame, Color(255,255,255))
    CheadleUI.SetSize(buttonsPanel, 24, 74)
    CheadleUI.SetPos(buttonsPanel, .4, 0, 99.5, 4)
    buttonsPanel.Paint = function(self, w, h)
    end

    for i, tab in ipairs(F4.Config.Tabs) do
        local button = CheadleUI.Button(buttonsPanel, tab.name, CheadleUI.GetFont("Montserrat", 30), Color(45,45,45), Color(255,255,255))
        CheadleUI.SetSize(button, 90, 12)
        CheadleUI.SetPos(button, 50, 1, 3 + (i - 1) * 15, 3)
        CheadleUI.HoverEffect(button, Color(15,15,15), Color(45,45,45), 200)
        button.id = tab.id
        button.name = tab.name
        button.panel = panelInstances[tab.panel]

        panelInstances[tab.panel]:SetVisible(false)

        button.DoClick = function()
            for _, otherTab in ipairs(F4.Config.Tabs) do
                if otherTab.id == button.id then
                    button.panel:SetVisible(true)
                else
                    panelInstances[otherTab.panel]:SetVisible(false)
                end
            end
        end

    end

    inventoryPanel:SetVisible(true)

end


hook.Add("PlayerBindPress", "F4:CreateMenu", function(ply, bind, pressed)
    if bind == "gm_showspare2" and pressed then
        F4:CreateMenu()
    end
end)

local function slotToItem(slot)
    for k, v in pairs(LocalPlayer().Inventory) do
        if v.slot == slot then
            return k
        end
    end
end

local dragged
local draggingSlot

hook.Add("CreateMove", "Inventory:DragAndDrop", function()
    if not F4.Frame then return end
    if gui.IsConsoleVisible() then return end

    if input.WasMousePressed(MOUSE_LEFT) and not dragged then
        local hovered = vgui.GetHoveredPanel()

        if hovered and hovered.slot then
            if LocalPlayer().Inventory[slotToItem(hovered.slot)]then
                dragged = slotToItem(hovered.slot)
                draggingSlot = hovered.slot
            end
        end
    elseif input.WasMouseReleased(MOUSE_LEFT) and dragged then
        local dropped = vgui.GetHoveredPanel()

        if dropped ~= dropped.slot and dropped.slot then
            net.Start("Inventory:MoveItem")
                net.WriteInt(draggingSlot, 8)
                net.WriteInt(dropped.slot, 8)
            net.SendToServer()
        end

        dragged = nil
        draggingSlot = nil
    end
end)

net.Receive("Inventory:RefreshInventory", function()
    local inventoryTable = net.ReadTable()
    LocalPlayer().Inventory = inventoryTable

    if F4.Frame then
        inventoryLayout:Clear()
        CreateInventoryScrollingPanel()
    end
end)