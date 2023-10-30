Mining = Mining or {}

Mining.Minerals = Mining.Minerals or {}


function Mining.CreateMineral(name, data)

    data.name = name

    Mining.Minerals[data.class] = data

end


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