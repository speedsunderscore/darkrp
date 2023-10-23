Inventory = Inventory or {}

Inventory.Items = Inventory.Items or {}

Inventory.MaxSlots = 20

Inventory.Raritys = {

    [1] = {name  = "Common", color = Color(70,72,70)},
    
    [2] = {name  = "Uncommon", color = Color(63,141,63)},

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

    description = "A toolgun",

})

Inventory.CreateInventoryItem("Shotun", {

    class = "weapon_shotgun",

    category = "weapon",

    model = "models/weapons/w_shotgun.mdl",

    rarity = 1,

    description = "A shotgun",

})