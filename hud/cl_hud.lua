hook.Add("HUDShouldDraw", "HUD:HideOriginal", function(name)
    for k, v in pairs ({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSeccondaryAmmo"}) do
        if name == v then
            return false 
        end
    end
end)


local lastAmmoPerc = 1
local lastAmmoColor = Color(255, 255, 0, 255)

local lastHealthPerc = 1
local lastHealthColor = Color(19, 194, 19, 255)

local lastArmorPerc = 1
local lastArmorColor = Color(0, 132, 255)

hook.Add("HUDPaint", "HUD:HUDPaint", function()
    local ply = LocalPlayer()
    if not ply:Alive() then return end

    local scrw, scrh = ScrW(), ScrH()
    local boxWidth = 300
    local padding = 20
    local boxHeight = 15
    local boxX = scrw - boxWidth - padding
    local boxY = scrh - boxHeight - padding

    // AMMO BAR
    local wep = ply:GetActiveWeapon()
    local clip = IsValid(wep) and wep:Clip1() or 0
    local maxClip = IsValid(wep) and wep:GetMaxClip1() or -1
    local ammoPerc = maxClip > 0 and clip / maxClip or 1
    local ammoTargetColor = Color(255, 255, 0, 255)

    if ammoPerc < 0.3 then
        ammoTargetColor = Color(255, 0, 0, 255)
    elseif ammoPerc < 0.6 then
        ammoTargetColor = Color(202, 141, 9, 255)
    end

    local lerpFactor = FrameTime() * 5
    lastAmmoPerc = Lerp(lerpFactor, lastAmmoPerc, ammoPerc)
    local ammoBarWidth = lastAmmoPerc * boxWidth

    lastAmmoColor.r = Lerp(lerpFactor, lastAmmoColor.r, ammoTargetColor.r)
    lastAmmoColor.g = Lerp(lerpFactor, lastAmmoColor.g, ammoTargetColor.g)
    lastAmmoColor.b = Lerp(lerpFactor, lastAmmoColor.b, ammoTargetColor.b)

    draw.RoundedBox(16, boxX, boxY, boxWidth, boxHeight, Color(0, 0, 0, 220))
    draw.RoundedBox(16, boxX, boxY, ammoBarWidth, boxHeight, lastAmmoColor)
    // END OF AMMO BAR

    // HEALTH BAR
    local health = ply:Health()
    local maxHealth = ply:GetMaxHealth()
    local healthPerc = math.Clamp(health / maxHealth, 0, 1)
    local healthBarWidth = lastHealthPerc * boxWidth
    local healthTargetColor = Color(19, 194, 19, 255)

    if healthPerc < 0.3 then
        healthTargetColor = Color(255, 0, 0, 255)
    elseif healthPerc < 0.6 then
        healthTargetColor = Color(202, 141, 9, 255)
    end

    local lerpFactor = FrameTime() * 5
    lastHealthPerc = Lerp(lerpFactor, lastHealthPerc, healthPerc)
    lastHealthColor.r = Lerp(lerpFactor, lastHealthColor.r, healthTargetColor.r)
    lastHealthColor.g = Lerp(lerpFactor, lastHealthColor.g, healthTargetColor.g)
    lastHealthColor.b = Lerp(lerpFactor, lastHealthColor.b, healthTargetColor.b)

    draw.RoundedBox(16, padding*2, boxY, boxWidth / 2, boxHeight, Color(0, 0, 0, 220))
    draw.RoundedBox(16, padding*2, boxY, healthBarWidth / 2, boxHeight, lastHealthColor)

    draw.SimpleText(health > 0 and health .. "HP" or "", CheadleUI.GetFont("Montserrat", 15), padding*2 + healthBarWidth /2, boxY - 10, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    // END OF HEALTH BAR

    // ARMOR BAR
    local armor = ply:Armor()
    local maxArmor = ply:GetMaxArmor()
    local armorPerc = math.Clamp(armor / maxArmor, 0, 1)
    local armorBarWidth = lastArmorPerc * boxWidth
    local armorTargerColor = Color(0, 132, 255)

    if armorPerc < 0.3 then
        armorTargerColor = Color(255, 0, 0, 255)
    elseif armorPerc < 0.6 then
        armorTargerColor = Color(0, 132, 255)
    end

    local lerpFactor = FrameTime() * 5
    lastArmorPerc = Lerp(lerpFactor, lastArmorPerc, armorPerc)
    lastArmorColor.r = Lerp(lerpFactor, lastArmorColor.r, armorTargerColor.r)
    lastArmorColor.g = Lerp(lerpFactor, lastArmorColor.g, armorTargerColor.g)
    lastArmorColor.b = Lerp(lerpFactor, lastArmorColor.b, armorTargerColor.b)

    draw.RoundedBox(16, padding*3 + boxWidth/2, boxY, boxWidth/2, boxHeight, Color(0, 0, 0, 220))
    draw.RoundedBox(16, padding*3 + boxWidth/2, boxY, armorBarWidth/2, boxHeight, lastArmorColor)

    draw.SimpleText(armor > 0 and armor .. "AP" or "", CheadleUI.GetFont("Montserrat", 15), padding*3 + armorBarWidth/2 + boxWidth/2, boxY - 10, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    // END OF ARMOR BAR

    draw.SimpleText(IsValid(wep) and wep:GetPrintName() or "", CheadleUI.GetFont("Montserrat", 30), boxX + boxWidth / 1.7, boxY - 30, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Current Weapon", CheadleUI.GetFont("Montserrat", 20), boxX + boxWidth / 1.7, boxY - 60, Color(180, 180, 180), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    draw.RoundedBox(30, boxX + boxWidth / 1.55, boxY - 65, 6, 50, Color(255, 255, 255, 255))

    local clipText = (clip == -1 or IsValid(wep) and wep:GetClass() == "weapon_physcannon") and "∞" or IsValid(wep) and clip
    draw.SimpleText(clipText, CheadleUI.GetFont("Montserrat", 50), boxX + boxWidth / 1.4, boxY - 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    draw.SimpleText(LocalPlayer():Name(), CheadleUI.GetFont("Montserrat", 20), scrw - padding*3, boxY - 140, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText(LocalPlayer():GetZone(), CheadleUI.GetFont("Montserrat", 20), scrw - padding*3, boxY - 120, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    draw.SimpleText(formatMoney(LocalPlayer():GetMoney()), CheadleUI.GetFont("Montserrat", 20), scrw - padding*3, boxY - 100, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

end)