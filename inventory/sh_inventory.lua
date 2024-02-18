Inventory = Inventory or {}
Inventory.MaxSlots = 32
Inventory.Items = Inventory.Items or {}

Inventory.Rarity = {
    [1] = {name = "Common", color = Color(70,72,70)},
    [2] = {name  = "Uncommon", color = Color(63,141,63)},
    [3] = {name  = "Rare", color = Color(65,127,151)},
    [4] = {name  = "Epic", color = Color(137,65,151)},
    [5] = {name  = "Legendary", color = Color(221,70,10)},
}

local META = FindMetaTable("Player")

function META:ChatMessage(nam,col,msg)
	umsg.Start("DarkRpChat", self)
		umsg.String(nam)
		umsg.Vector(Vector(col.r,col.g,col.b))
		umsg.String(msg)
	umsg.End()

	if CLIENT then
		chat.AddText(col,"[" .. nam .. "] ",Color(255,255,255),msg)
	end
end


if CLIENT then
	local self = LocalPlayer()

	local function Chat(um)
		local nam = um:ReadString()
		local vcol = um:ReadVector()
		local col = Color(vcol.x,vcol.y,vcol.z)
		local msg = um:ReadString()
		chat.AddText(unpack({col,"[" .. nam .. "] ",Color(255,255,255),msg}))
		chat.PlaySound()
	end
	usermessage.Hook("DarkRpChat", Chat)
end


function Inventory:CreateItem(name, data)
    data.name = name
    Inventory.Items[data.class] = data
end



Inventory:CreateItem("Shotgun", {
	class = "weapon_shotgun",
	model = "models/weapons/w_shotgun.mdl",
	rarity = 2,
	description = "A shotgun",
	category = "weapon",
	settings = {
		fov = 27.89,
		pos = Vector(0, 0, 38),
		rot = Angle(0, -56, 0)
	}
})

Inventory:CreateItem("Gluon Gun", {
	class = "weapon_gluongun",
	model = "models/weapons/w_physics.mdl",
	rarity = 5,
	description = "A an awesome gluon gun",
	category = "weapon",
	settings = {
		fov = 24.87,
		pos = Vector(0, -14, 40),
		rot = Angle(0, 99, 0)
	}
})

Inventory:CreateItem("Amphetamine", {
	class = "amphetamine",
	model = "models/props_lab/jar01a.mdl",
	rarity = 1,
	description = "2x Runspeed for 30 seconds.",
	category = "drug",
	color = Color(101,217,238),
	callback = function(ply)
		if ply.Suit then
			ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
			return false
		end

		if ply.usingDrugs then
			ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
			return false 
		end

		if ply.nextAmphetamine and ply.nextAmphetamine > CurTime() then
			ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You can't do this for another %ss.", math.Round(ply.nextAmphetamine - CurTime())))
			return false 
		end


		ply.oldAmphetamineRunSpeed = ply:GetRunSpeed()
		ply.oldAmphetamineWalkSpeed = ply:GetWalkSpeed()
		ply:SetRunSpeed(ply.oldAmphetamineRunSpeed * 2)
		ply:SetWalkSpeed(ply.oldAmphetamineWalkSpeed * 2)
		ply.usingDrugs = true
		ply:EmitSound("items/medshot4.wav")
		ply:ChatMessage("INVENTORY", Color(0,162,255), "You used an amphetamine.")


		timer.Create("drug_" .. ply:SteamID64(), 30, 1, function()
			if ply:IsValid() then
				ply:SetRunSpeed(ply.oldAmphetamineRunSpeed)
				ply:SetWalkSpeed(ply.oldAmphetamineWalkSpeed)
			end

			ply:ChatMessage("INVENTORY", Color(0,162,255), "Your amphetamine effect has worn off.")
			ply.usingDrugs = false
			timer.Remove("drug_" .. ply:SteamID64())

			ply.nextAmphetamine = CurTime() + 30
		end)

		return true
	end,

	rendereffects = function()
		DrawSharpen(1.5, 1.5)
	end,

	settings = {
		fov = 20.85,
		pos = Vector(0, 0, 40),
		rot = Angle(0, 136, 0)
	}
})

Inventory:CreateItem("Morphine", {
	class = "morphine",
	model = "models/props_lab/jar01a.mdl",
	rarity = 1,
	description = "Increased health for 45 seconds.",
	category = "drug",
	color = Color(34,15,15),
	callback = function(ply)
		if ply.Suit then
			ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
			return false
		end

		if ply.usingDrugs then
			ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
			return false 
		end

		if ply.nextMorphine and ply.nextMorphine > CurTime() then
			ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You can't do this for another %ss.", math.Round(ply.nextMorphine - CurTime())))
			return false 
		end


		ply.oldMorphineHealth = ply:Health()
		ply:SetHealth(350)
		ply.usingDrugs = true
		ply:EmitSound("items/medshot4.wav")
		ply:ChatMessage("INVENTORY", Color(0,162,255), "You used a morphine.")


		timer.Create("drug_" .. ply:SteamID64(), 45, 1, function()
			if ply:IsValid() then
				ply:SetHealth(ply.oldMorphineHealth)
			end

			ply:ChatMessage("INVENTORY", Color(0,162,255), "Your morphine effect has worn off.")
			ply.usingDrugs = false
			timer.Remove("drug_" .. ply:SteamID64())
			ply.nextMorphine = CurTime() + 30
		end)

		return true
	end,

	rendereffects = function()
		DrawMotionBlur(0.1, 0.65, 0.01)
	end,

	settings = {
		fov = 20.85,
		pos = Vector(0, 0, 40),
		rot = Angle(0, 136, 0)
	}
})

Inventory:CreateItem("Radiation Pill", {
	class = "radiationpill",
	model = "models/props_lab/jar01a.mdl",
	rarity = 3,
	description = "hulk man 5 seconds",
	category = "drug",
	color = Color(8,94,22),
	callback = function(ply)
		if ply.Suit then
			ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
			return false
		end

		if ply.usingDrugs then
			ply:ChatMessage("INVENTORY", Color(0,162,255), "You can't do this currently.")
			return false 
		end

		if ply.nextRadiation and ply.nextRadiation > CurTime() then
			ply:ChatMessage("INVENTORY", Color(0,162,255), string.format("You can't do this for another %ss.", math.Round(ply.nextRadiation - CurTime())))
			return false 
		end


		ply:SetHealth(10000)
		ply:SetMaxHealth(10000)
		ply:SetRunSpeed(ply:GetRunSpeed() * 2)
		ply:SetWalkSpeed(ply:GetWalkSpeed() * 2)
		ply.usingDrugs = true
		ply:EmitSound("items/medshot4.wav")
		ply:ChatMessage("INVENTORY", Color(0,162,255), "You used a radiation pill.")

		timer.Create("drug_" .. ply:SteamID64(), 5, 1, function()
			if ply:IsValid() then
				ply:Kill()
				ply:SetMaxHealth(100)
			end

			ply.usingDrugs = false
			timer.Remove("drug_" .. ply:SteamID64())
			ply.nextRadiation = CurTime() + 5
			ply:EmitSound("ambient/explosions/explode_2.wav")
		end)

		return true
	end,
	rendereffects = function()
		DrawMotionBlur(0.1, 0.65, 0.01)
		DrawSharpen(1.5, 1.5)
	end,
	hudpaint = function()
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(17, 161, 41, 173))
	end,
	settings = {
		fov = 20.85,
		pos = Vector(0, 0, 40),
		rot = Angle(0, 136, 0)
	}
})

Inventory:CreateItem("Juggernaut Suit", {
	class = "suit_juggernaut",
	model = "models/epangelmatikes/warhammer/space_marine_default.mdl",
	color = Color(102, 133, 225),
	rarity = 4,
	description = "An armor suit for zarpgin.",
	category = "suit",
	health = 400,
	armor = 1200,
	runSpeed = 0.6,
	walkSpeed = 1,
	jumpPower = 2,
	rendereffects = function()
		DrawMaterialOverlay("effects/combine_binocoverlay", 0.3)
	end,
	hudpaint = function()
		draw.SimpleText("Juggernaut", CheadleUI.GetFont("Montserrat", 15), ScrW() / 2, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end,
	settings = {
		fov = 72.11,
		pos = Vector(0, 0, 0),
		rot = Angle(0, 47, 0)
	}
})

Inventory:CreateItem("Scope Boost Upgrade", {
	class = "upgrade_scopeboost",
	image = "items/scope_boost_tier3.png",
	scale = 0.8,
	posx = 10,
	posy = 15,
	rarity = 1,
	description = "Increase damage on scoped weapons.",
	category = "upgrade",

})

Inventory:CreateItem("Blue Case", {
	class = "case_blue",
	image = "items/case.png",
	color = Color(0, 162, 255),
	posy = 10,
	scale = 1,
	rarity = 1,
	description = "Blue Case",
	category = "case",
	rewards = {
		["weapon_gluongun"] = {chance = 0, amount = 1},
		["morphine"] = {chance = 0, amount = 3},
		["radiationpill"] = {chance = 100, amount = 50},
	}
})
