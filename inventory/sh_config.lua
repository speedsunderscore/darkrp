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

    settings = {

        fov = 12.31,

        pos = Vector(-2, 3, 38),

        rot = Angle(0, -99, 0)

    },

})