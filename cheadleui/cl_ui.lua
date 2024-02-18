-- UI Utility library fully coded by codabro#2146, https://github.com/codabro

CheadleUI = CheadleUI or {}
CheadleUI.Fonts = CheadleUI.Fonts or {}
CheadleUI.Materials = CheadleUI.Materials or {}

local color_transparent = Color(0, 0, 0, 0)
local color_hover = Color(255, 255, 255, 5)
local color_100 = Color(100, 100, 100)
local color_250 = Color(250, 250, 250)

function CheadleUI.GetMaterial(mat)
    local cached = CheadleUI.Materials[mat]
    if cached and cached:IsError() then
        if file.Exists("materials/" .. mat, "GAME") then
            local newMat = Material(mat)
            CheadleUI.Materials[mat] = newMat
        end
    end
    if cached then return CheadleUI.Materials[mat] end
    local newMat = Material(mat)
    CheadleUI.Materials[mat] = newMat
    return newMat
end

function CheadleUI.CreateFont(face, size)
    surface.CreateFont("CheadleUI_" .. face .. size, {
        font = face,
        extended = false,
        size = ScrH()*(size/1000),
        weight = 500,
        antialias = true,
    })
    CheadleUI.Fonts[size] = true
end

function CheadleUI.GetFont(face, size)
    if not CheadleUI.Fonts[size] then
        CheadleUI.CreateFont(face, size)
    end
    return "CheadleUI_" .. face .. size
end

function CheadleUI.SetX(panel, percent, align)
    local parent = panel:GetParent()
    local _, oldY = panel:GetPos()
    local offset = 0
    if align == TEXT_ALIGN_CENTER then offset = panel:GetWide()/2 end
    if align == TEXT_ALIGN_RIGHT then offset = panel:GetWide() end
    panel:SetPos(parent:GetWide() * (percent/100) - offset, oldY)
end

function CheadleUI.SetY(panel, percent, align)
    local parent = panel:GetParent()
    local oldX = panel:GetPos()
    local offset = 0
    if align == TEXT_ALIGN_CENTER then offset = panel:GetTall()/2 end
    if align == TEXT_ALIGN_BOTTOM then offset = panel:GetTall() end
    panel:SetPos(oldX, parent:GetTall() * (percent/100) - offset)
end

function CheadleUI.SetPos(panel, x, xAlign, y, yAlign)
    CheadleUI.SetX(panel, x, xAlign)
    CheadleUI.SetY(panel, y, yAlign)
end

function CheadleUI.SetW(panel, percent)
    local parent = panel:GetParent()
    local _, oldH = panel:GetSize()
    panel:SetSize(parent:GetWide() * (percent/100), oldH)
end

function CheadleUI.SetH(panel, percent)
    local parent = panel:GetParent()
    local oldW = panel:GetSize()
    panel:SetSize(oldW, parent:GetTall() * (percent/100))
end

function CheadleUI.SetSize(panel, percentW, percentH)
    CheadleUI.SetW(panel, percentW)
    CheadleUI.SetH(panel, percentH)
end

function CheadleUI.CenterW(panel)
    CheadleUI.SetX(panel, 50, TEXT_ALIGN_CENTER)
end

local mat_blur = CheadleUI.GetMaterial("pp/blurscreen")
function CheadleUI.Frame(w, h, title, font, color, color_top, closeBtn, blur)
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(w, h)
    frame:Center()
    frame:MakePopup()
    gui.EnableScreenClicker(true)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)

    surface.SetFont(font)
    local titleW, titleH = surface.GetTextSize(title)

    local start = SysTime()
    frame.Paint = function(s, w1, h1)
        if blur then
            local x, y = s:LocalToScreen(0, 0)
            surface.SetMaterial(mat_blur)
            surface.SetDrawColor(255, 255, 255)
            for i=0.33, 1, 0.33 do
                mat_blur:SetFloat("$blur", 10 * i) -- Increase number 5 for more blur
                mat_blur:Recompute()
                render.UpdateScreenEffectTexture()
                surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
            end
        end
        draw.RoundedBox(4, 0, 0, w1, h1, color)
        if color_top then
            --draw.RoundedBox(4, 0, 0, w1, titleH, color_top)
            draw.RoundedBoxEx(4, 0, 0, w1, titleH, color_top, true, true, false, false)
        end
    end

    local title = CheadleUI.Label(frame, title, font, color_white)
    CheadleUI.CenterW(title)
    //CheadleUI.SetY(title, titleH/2, TEXT_ALIGN_CENTER)
    title:SetY(titleH/2-title:GetTall()/2)
    frame.title = title

    if closeBtn then
        local closeButton = CheadleUI.Button(frame, "x", CheadleUI.GetFont("Montserrat", 20), color_transparent)
        CheadleUI.SetX(closeButton, 99, TEXT_ALIGN_RIGHT)
        //CheadleUI.SetY(closeButton, 3.5, TEXT_ALIGN_CENTER)
        closeButton:SetY(titleH/2-closeButton:GetTall()/2)

        closeButton.DoClick = function()
            frame:Remove()
            gui.EnableScreenClicker(false)
        end
    end
    return frame
end

function CheadleUI.Panel(parent, color)
    local panel = vgui.Create("DPanel", parent)
    panel.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, color)
    end
    return panel
end

function CheadleUI.Label(parent, text, font, color)
    local label = vgui.Create("DLabel", parent)
    label:SetText(text)
    label:SetColor(color)
    label:SetFont(font)
    label:SizeToContents()
    return label
end

function CheadleUI.Button(parent, text, font, color, textColor)
    local button = vgui.Create("DButton", parent)
    button:SetText(text)
    button:SetFont(font)
    button:SetTextColor(textColor or color_white)
    button:SizeToContents()
    button.hover = 0
    button.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, color)
    end
    return button
end

function CheadleUI.HoverEffect(panel, color, oColor, maxOpacity)
    panel.Hover = panel.Hover or 0

    local doHover = function(s, w, h)
        local frames = 1/FrameTime()
        local max = w-6
        if panel:IsHovered() then
            panel.Hover = math.Approach(panel.Hover, maxOpacity and maxOpacity or max, 1000/frames)
        else
            panel.Hover = math.Approach(panel.Hover, 0, 1000/frames)
        end
        if panel.selected then panel.Hover = max end
    end
    
    if not color then
        panel.PaintOver = function(s, w, h)
            local max = w-6
            doHover(s, w, h)
            draw.RoundedBox(0, 3, h*.94-1, max, h*.06, color_100)
            draw.RoundedBox(0, 3, h*.94-1, panel.Hover, h*.06, color_250)

            if panel.selected and not color then
                draw.RoundedBox(0, 0, 0, w, h, color_hover)
            end
        end
    else
        panel.Paint = function(s, w, h)
            draw.RoundedBox(4, 0, 0, w, h, oColor)
            doHover(s, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(color.r, color.g, color.b, s.Hover))
            if panel.selected then
                draw.RoundedBox(4, 0, 0, w, h, color)
            end
        end
    end
end

function CheadleUI.Combobox(panel, bgcolor, hovercolor, bordercolor, font)
    local combo = vgui.Create("DComboBox", panel)
    CheadleUI.SetPos(combo, 100, 2, 50, 1)
    combo.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, bgcolor)
    end
    combo:SetTextColor(color_white)
    if font then
        combo:SetFont(font)
    end
    local oldOpen = combo.OpenMenu
    combo.OpenMenu = function(s, pControlOpener)
        oldOpen(s, pControlOpener)
        if not combo.Menu then return end
        combo.Menu.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, bordercolor or hovercolor)
            draw.RoundedBox(0, 2, 2, w-4, h-4, bgcolor)
        end
        for k, v in ipairs(combo.Menu:GetChildren()[1]:GetChildren()) do
            v.Paint = function(s, w, h)
                if v:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, hovercolor)
                end
            end
            v:SetTextColor(color_white)
        end
    end
    return combo
end

function CheadleUI.Textbox(panel, font, bgColor)
    local input = vgui.Create("DTextEntry", panel)
    input:SetFont(font)
    input.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, bgColor)

        if (s.GetPlaceholderText && s.GetPlaceholderColor && s:GetPlaceholderText() && s:GetPlaceholderText():Trim() != "" && s:GetPlaceholderColor() && (!s:GetText() || s:GetText() == "")) then
            local oldText = s:GetText()
    
            local str = s:GetPlaceholderText()
            if str:StartWith("#") then str = str:sub(2) end
            str = language.GetPhrase(str)
    
            s:SetText(str)
            s:DrawTextEntryText(s:GetPlaceholderColor(), s:GetHighlightColor(), s:GetCursorColor())
            s:SetText(oldText)
            return
        end
    
        s:DrawTextEntryText(color_white, s:GetHighlightColor(), s:GetCursorColor())

    end

    return input
end

function CheadleUI.Checkbox(panel, text, font, bgColor, markedColor, textColor)
    textColor = textColor or color_white

    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)

    local bgPanel = CheadleUI.Panel(panel, color_transparent)
    bgPanel:SetSize(w + h + 5, h)
    bgPanel.OnChange = function() end

    local checkPanel = CheadleUI.Panel(bgPanel, color_white)
    checkPanel:SetSize(h, h)
    checkPanel.checked = false

    checkPanel.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        if checkPanel.checked then
            draw.RoundedBox(4, 4, 4, w-8, h-8, markedColor)
        end
    end

    local label = CheadleUI.Label(bgPanel, text, font, textColor)
    CheadleUI.SetPos(label, 100, 2, 0, 0)

    local buttonPanel = vgui.Create("DButton", bgPanel)
    buttonPanel:SetText("")
    buttonPanel.Paint = function() end
    CheadleUI.SetSize(buttonPanel, 100, 100)
    buttonPanel.DoClick = function(s)
        checkPanel.checked = !checkPanel.checked
        bgPanel:OnChange(checkPanel.checked)

        --CheadleUI.PlaySound(checkPanel.checked and "sound/cheadlepurge/check.mp3" or "sound/cheadlepurge/uncheck.mp3")
    end

    bgPanel.SetValue = function(s, value)
        checkPanel.checked = value
    end

    bgPanel.GetValue = function(s)
        return checkPanel.checked
    end

    return bgPanel
end

function CheadleUI.Slider(panel, text, font, min, max, width, color, initialValue)
    local con = CheadleUI.Panel(panel, Color(0, 0, 0, 0)) //vgui.Create("EditablePanel", panel)
    CheadleUI.SetW(con, width)
    con:SetTall(30)

    local slider = vgui.Create("DNumSlider", con)
    slider:SetText(text)
    slider.Label:SetFont(font)
    slider.Label:SetColor(color)
    slider:SetMin(min)
    slider:SetMax(max)
    slider:SetDecimals(0)
    CheadleUI.SetW(slider, 100)
    
    con.OnValueChanged = function() end
    slider.OnValueChanged = function(s, value)
        con:OnValueChanged(value)
    end

    con.SetValue = function(s, value)
        slider:SetValue(value)
    end

    con.GetValue = function(s)
        return math.Round(slider:GetValue(),0)
    end

    con:SetValue(initialValue or 0)
    return con
end

function CheadleUI.Popup(panel, text, font, bgColor, textColor)
    if type(text) == "function" then
        panel.popupDraw = text
        return
    end

    panel.popupText = text
    panel.popupFont = font
    panel.popupColor = bgColor
    panel.popupTextColor = textColor
end

hook.Add("DrawOverlay", "CheadleUI_Popups", function()
    local hovered = vgui.GetHoveredPanel()
    if not IsValid(hovered) then return end

    if hovered.popupDraw then
        local x, y = input.GetCursorPos()
        hovered.popupDraw(x, y)
        return
    end

    local text = hovered.popupText
    local bgColor = hovered.popupColor
    local textColor = hovered.popupTextColor
    if text then
        local font = hovered.popupFont
        surface.SetFont(font)

        local w, h = surface.GetTextSize(text)
        local x, y = input.GetCursorPos()
        draw.RoundedBox(4, x, y, w + 20, h+5, bgColor)
        draw.SimpleText(text, font, x + w/2 + 15, y + (h+5)/2, textColor, 1, 1)
    end
end)

function CheadleUI.PlaySound(soundName)
        sound.PlayFile(soundName, "", function() end)
end


function CheadleUI.DermaQuery(title, message, firstOption, firstCallback, secondOption, secondCallback)

    local frame = CheadleUI.Frame(ScrW() * 0.16, ScrH() * 0.1, title, CheadleUI.GetFont("Montserrat", 20), Color(20,20,20), Color(40,40,40), false, false)

    local backPanel = CheadleUI.Panel(frame, Color(15,15,15))

    CheadleUI.SetSize(backPanel, 98.2, 75)

    CheadleUI.SetPos(backPanel, 1, 0, 98, 4)


    backPanel.Paint = function(self, w, h)

        draw.RoundedBox(4, 0, 0, w, h, Color(15,15,15))

        draw.SimpleText(message, CheadleUI.GetFont("Montserrat", 15), w/2, h*0.25, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    local firstButton = CheadleUI.Button(backPanel, firstOption, CheadleUI.GetFont("Montserrat", 15), Color(40,40,40), Color(255,255,255))

    CheadleUI.SetSize(firstButton, 25, 25)

    CheadleUI.SetPos(firstButton, 5, 0, 80, 4)

    CheadleUI.HoverEffect(firstButton, Color(15,15,15), Color(35,35,35), 200)

    firstButton.DoClick = function()

        firstCallback()

        frame:Remove()

    end


    local secondButton = CheadleUI.Button(backPanel, secondOption, CheadleUI.GetFont("Montserrat", 15), Color(40,40,40), Color(255,255,255))

    CheadleUI.SetSize(secondButton, 25, 25)

    CheadleUI.SetPos(secondButton, 95, 2, 80, 4)

    CheadleUI.HoverEffect(secondButton, Color(15,15,15), Color(35,35,35), 200)

    secondButton.DoClick = function()

        secondCallback()

        frame:Remove()

    end

end