Mining = Mining or {}

Mining.Minerals = Mining.Minerals or {}

Mining.Categories = Mining.Categories or {}

Mining.Craftables = Mining.Craftables or {}


function Mining.CreateMineral(name, data)

    data.name = name

    Mining.Minerals[data.class] = data

end

function Mining.CreateCraftable(name, data)

    data.name = name

    Mining.Craftables[data.class] = data

end

function Mining.CreateCategory(name)

    Mining.Categories[name] = name

end


Mining.CreateCategory("Weapons")

Mining.CreateCategory("Miscellaneous")



Mining.CreateMineral("Iron", {

    class = "iron_ore",

    color = Color(168, 162, 162),

    image = "ore/ore.png",

    maxAmt = 100,

    price = 75,

})


Mining.CreateMineral("Gold", {

    class = "gold_ore",

    color = Color(255, 230, 0),

    image = "ore/ore.png",

    maxAmt = 200,

    price = 130,

})


Mining.CreateMineral("Diamond", {

    class = "diamond_ore",

    color = Color(0, 204, 255),

    image = "ore/ore.png",

    maxAmt = 300,

    price = 300,

})


Mining.CreateMineral("Ruby", {

    class = "ruby_ore",

    color = Color(204, 20, 20),

    image = "ore/ore.png",

    maxAmt = 350,

    price = 200,

})


Mining.CreateMineral("Uranium", {

    class = "uranium_ore",

    color = Color(14, 161, 9),

    image = "ore/ore.png",

    maxAmt = 50,

    price = 1250,

})


Mining.CreateMineral("Amethyst", {

    class = "amethyst_ore",

    color = Color(153, 102, 204),

    image = "ore/ore.png",

    maxAmt = 80,

    price = 600,

})


Mining.CreateMineral("Copper", {

    class = "copper_ore",

    color = Color(184, 115, 51),

    image = "ore/ore.png",

    maxAmt = 225,

    price = 120,

})


Mining.CreateMineral("Quartz", {

    class = "quartz_ore",

    color = Color(230, 227, 225),

    image = "ore/ore.png",

    maxAmt = 300,

    price = 105,

})

Mining.CreateMineral("Lapis", {

    class = "lapis_ore",

    color = Color(99, 134, 231),

    image = "ore/ore.png",

    maxAmt = 500,

    price = 215,

})


Mining.CreateMineral("Emerald", {

    class = "emerald_ore",

    color = Color(75, 255, 20),

    image = "ore/ore.png",

    maxAmt = 250,

    price = 185,

})


Mining.CreateMineral("Malachite", {

    class = "malachite_ore",

    color = Color(23, 139, 130),

    image = "ore/ore.png",

    maxAmt = 225,

    price = 155,

})


Mining.CreateCraftable("Bug Bait", {
    
    class = "weapon_bugbait",

    category = "Weapons",

    model = "models/weapons/w_bugbait.mdl",

    settings = {

        fov = 6.78,

        pos = Vector(0, 0, 40),

        rot = Angle(0, 0, 0)

    },

    recipe = {["gold_ore"] = 1, ["iron_ore"] = 1}

})


Mining.CreateCraftable("S.L.A.M", {

    class = "weapon_slam",

    category = "Miscellaneous",

    model = "models/weapons/w_slam.mdl",

    settings = {

        fov = 11.81,

        pos = Vector(0, 0, 41),

        rot = Angle(0, -18, -38)

    },

    recipe = {["gold_ore"] = 3, ["iron_ore"] = 1, ["diamond_ore"] = 5}

})
