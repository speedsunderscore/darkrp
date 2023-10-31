Mining = Mining or {}


net.Receive("Mining.AddMinerals", function()

    local minerals = net.ReadTable()

    LocalPlayer().Minerals = {}

    for k, v in pairs(minerals) do

        LocalPlayer().Minerals[k] = v

    end

end)


net.Receive("Mining.UseBench", function()

    if Mining.Frame then
        
        Mining.Frame:Remove()

        Mining.Frame = nil

        Mining.Boolean = false

        gui.EnableScreenClicker(false)

    end

    Mining.Frame = Mining.Frame or CheadleUI.Frame(ScrW() * 0.5, ScrH() * 0.5, "Crafting Bench", CheadleUI.GetFont("Montserrat", 30), Color(20,20,20), Color(40,40,40), true, false)

    Mining.Boolean = !Mining.Boolean

    Mining.Frame:SetVisible(Mining.Boolean)

    gui.EnableScreenClicker(Mining.Boolean)


    local leftPanel = CheadleUI.Panel(Mining.Frame, Color(15,15,15))

    CheadleUI.SetSize(leftPanel, 20, 92.5)

    CheadleUI.SetPos(leftPanel, .5, 0, 99.2, 4)


    local rightPanel = CheadleUI.Panel(Mining.Frame, Color(15,15,15))

    CheadleUI.SetSize(rightPanel, 78.5, 92.5)

    CheadleUI.SetPos(rightPanel, 99.5, 2, 99.2, 4)


    local mineralsScrollPanel = vgui.Create("DScrollPanel", rightPanel)

    mineralsScrollPanel:Dock(FILL)

    mineralsScrollPanel:GetVBar():SetWide(0)



    local mineralsLayoutPanel = vgui.Create("DIconLayout", mineralsScrollPanel)

    mineralsLayoutPanel:Dock(FILL)

    mineralsLayoutPanel:DockMargin(5,5,5,0)

    mineralsLayoutPanel:SetSpaceY(5)

    mineralsLayoutPanel:SetSpaceX(5)

    for k, v in pairs(Mining.Minerals) do

        local oreDraw = mineralsLayoutPanel:Add("DPanel")

        oreDraw:SetSize(rightPanel:GetWide() / 5 - 6, rightPanel:GetWide()/8)

        oreDraw.Paint = function(self, w, h)

            draw.RoundedBox(4, 0, 0, w, h, Color(40,40,40))

            draw.SimpleText(v.name, CheadleUI.GetFont("Montserrat", 20), w - 3, 0, v.color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            draw.SimpleText(LocalPlayer().Minerals[v.class] .. " minerals", CheadleUI.GetFont("Montserrat", 16), w - 3, 18, Color(221,221,221), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            draw.SimpleText(v.maxAmt .. " max", CheadleUI.GetFont("Montserrat", 16), w - 3, 18*2, Color(221,221,221), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            draw.SimpleText("B:" .. formatMoney(Mining.Minerals[v.class].price * 4), CheadleUI.GetFont("Montserrat", 15), 1, h, Color(221,221,221), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

            draw.SimpleText("S:" .. formatMoney(Mining.Minerals[v.class].price), CheadleUI.GetFont("Montserrat", 15), w - 1, h, Color(221,221,221), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

        end


        local image = vgui.Create("DImage", oreDraw)

        image:SetImage(v.image)

        image:SetSize(oreDraw:GetTall() / 2, oreDraw:GetTall() / 2)

        image:SetImageColor(v.color)

        CheadleUI.SetPos(image, 2, 0, 1, 3)


        local sellButton = CheadleUI.Button(oreDraw, "Sell", CheadleUI.GetFont("Montserrat", 20), Color(35,35,35), Color(221,221,221))

        CheadleUI.SetSize(sellButton, 40, 25)

        CheadleUI.SetPos(sellButton, 98, 2, 82, 4)

        CheadleUI.HoverEffect(sellButton, Color(15,15,15), Color(35,35,35), 200)


        local buyButton = CheadleUI.Button(oreDraw, "Buy", CheadleUI.GetFont("Montserrat", 20), Color(35,35,35), Color(221,221,221))

        CheadleUI.SetSize(buyButton, 40, 25)

        CheadleUI.SetPos(buyButton, 2, 0, 82, 4)

        CheadleUI.HoverEffect(buyButton, Color(15,15,15), Color(35,35,35), 200)

    end


    local craftingScrollPanel = vgui.Create("DScrollPanel", rightPanel)

    craftingScrollPanel:Dock(FILL)

    craftingScrollPanel:GetVBar():SetWide(0)



    local craftingLayoutPanel = vgui.Create("DIconLayout", craftingScrollPanel)

    craftingLayoutPanel:Dock(FILL)

    craftingLayoutPanel:DockMargin(5,5,5,0)

    craftingLayoutPanel:SetSpaceY(5)

    craftingLayoutPanel:SetSpaceX(5)



    for k, v in pairs(Mining.Categories) do
        
        local categoryTitle = craftingLayoutPanel:Add("DPanel")

        categoryTitle:SetSize(rightPanel:GetWide() - 10, rightPanel:GetWide() * 0.045)

        categoryTitle.Paint = function(self, w, h)

            draw.RoundedBox(4, 0, 0, w, h, Color(40,40,40))

            draw.SimpleText(v, CheadleUI.GetFont("Montserrat", 25), 5, h/2, Color(221,221,221), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        end


        local categoryPanel = craftingLayoutPanel:Add("DPanel")

        categoryPanel:SetSize(rightPanel:GetWide() - 10, rightPanel:GetWide() * 0.25)

        categoryPanel.Paint = function(self, w, h)

            draw.RoundedBox(4, 0, 0, w, h, Color(30,30,30))

        end

        categoryPanel.category = v


        local categoryScrollPanel = vgui.Create("DScrollPanel", categoryPanel)

        categoryScrollPanel:Dock(FILL)

        categoryScrollPanel:GetVBar():SetWide(0)


        local categoryLayoutPanel = vgui.Create("DIconLayout", categoryScrollPanel)

        categoryLayoutPanel:Dock(FILL)

        categoryLayoutPanel:DockMargin(5,5,5,0)

        categoryLayoutPanel:SetSpaceY(5)

        categoryLayoutPanel:SetSpaceX(5)


        for k, v in pairs(Mining.Craftables) do
            
            if v.category == categoryPanel.category then

                local craftableDraw = categoryLayoutPanel:Add("DPanel")

                craftableDraw:SetSize(categoryPanel:GetWide() * 0.15, categoryPanel:GetWide() * 0.15)
                
                craftableDraw.Paint = function(self, w, h)

                    draw.RoundedBox(4, 0, 0, w, h, Color(20,20,20))

                end


                local icon = vgui.Create("DModelPanel", craftableDraw)

                CheadleUI.SetSize(icon, 100, 85)

                CheadleUI.SetPos(icon, 0, 0, 100, 4)

                icon:SetModel(v.model)

                icon:SetFOV(v.settings and v.settings.fov or 25)

                icon.Entity:SetPos(v.settings and v.settings.pos or Vector(0,0,0))

                function icon:LayoutEntity(entity)

                    entity:SetAngles(v.settings and v.settings.rot or Angle(0,0,0))

                end

            end

        end

    end

    craftingScrollPanel:SetVisible(false)

    craftingLayoutPanel:SetVisible(false)



    local mineralsTab = CheadleUI.Button(leftPanel, "Minerals", CheadleUI.GetFont("Montserrat", 25), Color(40,40,40), Color(255,255,255))

    CheadleUI.SetSize(mineralsTab, 95, 10)

    CheadleUI.SetPos(mineralsTab, 50, 1, 1, 3)

    CheadleUI.HoverEffect(mineralsTab, Color(15,15,15), Color(40,40,40), 200)

    mineralsTab.DoClick = function()

        mineralsScrollPanel:SetVisible(true)

        mineralsLayoutPanel:SetVisible(true)

        craftingScrollPanel:SetVisible(false)
    
        craftingLayoutPanel:SetVisible(false)

    end


    local craftingTab = CheadleUI.Button(leftPanel, "Crafting", CheadleUI.GetFont("Montserrat", 25), Color(40,40,40), Color(255,255,255))

    CheadleUI.SetSize(craftingTab, 95, 10)

    CheadleUI.SetPos(craftingTab, 50, 1, 13, 3)

    CheadleUI.HoverEffect(craftingTab, Color(15,15,15), Color(40,40,40), 200)

    craftingTab.DoClick = function()

        mineralsScrollPanel:SetVisible(false)

        mineralsLayoutPanel:SetVisible(false)


        craftingScrollPanel:SetVisible(true)
    
        craftingLayoutPanel:SetVisible(true)

    end

end)