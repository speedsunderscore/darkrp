Inventory = Inventory or {}

Inventory.Items = Inventory.Items or {}

Inventory.MaxSlots = 55

Inventory.Raritys = {

    [1] = {name  = "Common", color = Color(70,72,70)},
    
    [2] = {name  = "Uncommon", color = Color(63,141,63)},

    [3] = {name  = "Rare", color = Color(65,127,151)},

}


function Inventory.CreateInventoryItem(name, data)

    data.name = name

    Inventory.Items[data.class] = data

end


// Example items
Inventory.CreateInventoryItem("Toolgun", {

    class = "gmod_tool",

    category = "weapon",

    model = "models/weapons/w_toolgun.mdl",

    rarity = 1,

    background = "items/polygon.png",

    showRarityColor = true,

    pos = 0,

    settings = {

        fov = 12.31,

        pos = Vector(-2, 3, 38),

        rot = Angle(0, -99, 0)

    },

})


Inventory.CreateInventoryItem("Bug Bait", {

    class = "weapon_bugbait",

    category = "weapon",

    model = "models/weapons/w_bugbait.mdl",

    rarity = 3,

    background = "items/polygon.png",

    showRarityColor = true,

    pos = 0,

    settings = {

        fov = 5.78,

        pos = Vector(0, 0, 40),

        rot = Angle(0, 0, 0)

    }

})


Inventory.CreateInventoryItem("S.L.A.M", {

    class = "weapon_slam",

    category = "misc",

    model = "models/weapons/w_slam.mdl",

    rarity = 1,

    background = "items/polygon.png",

    showRarityColor = true,

    pos = 0,

    settings = {

        fov = 11.81,

        pos = Vector(0, 0, 41),

        rot = Angle(0, -18, -38)

    }

})