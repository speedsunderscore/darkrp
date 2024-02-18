Zones = Zones or {}
Zones.MapZones = Zones.MapZones or {}

function Zones:AddZone(name, map, mins, maxs, color, data)
    if (map != game.GetMap()) then return end

    table.insert(Zones.MapZones, {
        name = name,
        map = map,
        mins = mins,
        maxs = maxs,
        cornerx = Vector(maxs.x, mins.y, mins.z),
        cornery = Vector(mins.x, maxs.y, mins.z),
        color = color,
        data = data
    })
end

-- TITS V2 -- 
Zones:AddZone("Suburbs","rp_downtown_tits_v2", Vector(1088.6354980469,-8127.947265625,-415.67663574219), Vector(-4676.96875,-4341.0288085938,302.37734985352), Color(255,93,0))
Zones:AddZone("Suburbs","rp_downtown_tits_v2", Vector(3073.5541992188,-7381.33984375,-323.96875), Vector(1087.8551025391,-7298.03125,-207.19241333008), Color(255,93,0))
Zones:AddZone("Suburbs","rp_downtown_tits_v2", Vector(-189.07548522949,-4341.05078125,-217.06105041504), Vector(-2344.7568359375,-3339.3093261719,360.96875), Color(255,93,0))
Zones:AddZone("Spawn & Suburbs Tunnel","rp_downtown_tits_v2", Vector(-119.96875,-4341.1020507813,-223.90832519531), Vector(274.98699951172,-2091.96875,35.687202453613), Color(33,255,0))
Zones:AddZone("Casino","rp_downtown_tits_v2", Vector(4305.8793945313,-5391.134765625,-336.86584472656), Vector(5368.4067382813,-4592.28515625,-164.03125), Color(255,0,0))
Zones:AddZone("Casino Vault","rp_downtown_tits_v2", Vector(4311.4907226563,-5385.4897460938,-163.96875), Vector(4970.8862304688,-4598.1381835938,0.96874237060547), Color(127,0,0))
Zones:AddZone("Spawn & Beach Tunnel","rp_downtown_tits_v2", Vector(1988.6899414063,-1058.4470214844,-223.96875), Vector(1341.2873535156,-693.03125,35.656532287598), Color(0,255,63))
Zones:AddZone("Suburbs Arena","rp_downtown_tits_v2", Vector(1087.5073242188,-4341.2006835938,-208.96875), Vector(3784.6486816406,-7379.96875,302.92913818359), Color(0,161,255))
Zones:AddZone("Beach District","rp_downtown_tits_v2", Vector(3818.3864746094,-7417.5947265625,-848.96875), Vector(8209.8671875,130.32666015625,195.58892822266), Color(225,255,0))
Zones:AddZone("Beach District","rp_downtown_tits_v2", Vector(3818.37890625,-4336.6704101563,-449.56335449219), Vector(2377.1196289063,-527.03125,195.84349060059), Color(225,255,0))
Zones:AddZone("Beach District","rp_downtown_tits_v2", Vector(3818.044921875,-7381.9794921875,-323.96875), Vector(3073.3859863281,-7298.03125,-207.83399963379), Color(225,255,0))
Zones:AddZone("Beach District","rp_downtown_tits_v2", Vector(3817.6323242188,-527.22186279297,-448.5625), Vector(2956.9113769531,130.31057739258,195.62985229492), Color(225,255,0))
Zones:AddZone("Beach District","rp_downtown_tits_v2", Vector(2377.2521972656,-2576.96875,-205.91192626953), Vector(1989.03125,-619.93334960938,194.74632263184), Color(225,255,0))
Zones:AddZone("Beach & Park Tunnel","rp_downtown_tits_v2", Vector(2472.7873535156,-527.45397949219,-223.96875), Vector(2873.96875,182.38134765625,35.635414123535), Color(0,255,157))
Zones:AddZone("Island District","rp_downtown_tits_v2", Vector(15393.729492188,-12319.416015625,-1362.1212158203), Vector(3590.5659179688,-7419.4482421875,194.3984375), Color(127,255,0))
Zones:AddZone("Island District","rp_downtown_tits_v2", Vector(8209.28125,-488.8212890625,-1363.1398925781), Vector(15392.96875,-7420.7998046875,194.91731262207), Color(127,255,0))
Zones:AddZone("Park District","rp_downtown_tits_v2", Vector(3664.5444335938,182.60719299316,-215.96875), Vector(1983.2137451172,1976.9029541016,187.96875), Color(0,255,255))
Zones:AddZone("Park District","rp_downtown_tits_v2", Vector(1285.1236572266,1882.908203125,-220.16874694824), Vector(1983.6037597656,951.03125,55.428237915039), Color(0,255,255))
Zones:AddZone("Park District","rp_downtown_tits_v2", Vector(3216.2192382813,2466.4389648438,-215.96875), Vector(2850.8156738281,1975.96875,-44.402008056641), Color(0,255,255))
Zones:AddZone("Park District","rp_downtown_tits_v2", Vector(1883.2358398438,-337.91598510742,-195.96875), Vector(2383.96875,181.99780273438,59.82177734375), Color(0,255,255))
Zones:AddZone("Crackhouse District","rp_downtown_tits_v2", Vector(6144.7373046875,2503.7553710938,-215.96875), Vector(2093.0361328125,4211.96875,187.83320617676), Color(0,63,255))
Zones:AddZone("Crackhouse District","rp_downtown_tits_v2", Vector(2544.2404785156,4214.705078125,-436.53479003906), Vector(4089.0588378906,4983.3520507813,186.96875), Color(0,63,255))
Zones:AddZone("Crackhouse District","rp_downtown_tits_v2", Vector(2093.6430664063,3769.0554199219,-215.96875), Vector(1757.03125,2503.1801757813,187.93614196777), Color(0,63,255))
Zones:AddZone("Crackhouse District","rp_downtown_tits_v2", Vector(4097.828125,2503.7026367188,-215.96875), Vector(3217.03125,1982.0671386719,187.78604125977), Color(0,63,255))
Zones:AddZone("Park & Crackhouse Tunnel","rp_downtown_tits_v2", Vector(2431.1120605469,1976.0445556641,-213.96875), Vector(2816.96875,2503.7463378906,35.004020690918), Color(29,0,255))
Zones:AddZone("Fountain & Suburbs Tunnel","rp_downtown_tits_v2", Vector(-2873.96875,-4341.1997070313,-223.91868591309), Vector(-2434.03125,-2432.3381347656,35.533157348633), Color(127,0,255))
Zones:AddZone("Fountain & Warehouse Tunnel","rp_downtown_tits_v2", Vector(-2873.3308105469,-783.55627441406,-213.96875), Vector(-2515.03125,1125.2145996094,36.533123016357), Color(220,0,255))
Zones:AddZone("Spawn District","rp_downtown_tits_v2", Vector(1340.7907714844,-616.11560058594,-215.96875), Vector(-218.79481506348,-2089.96875,195.61476135254), Color(255,0,191))
Zones:AddZone("Spawn District","rp_downtown_tits_v2", Vector(672.22253417969,-6.1647176742554,-215.96875), Vector(1345.7177734375,-616.30090332031,195.96875), Color(255,0,191))
Zones:AddZone("Spawn District","rp_downtown_tits_v2", Vector(-218.8599395752,-1185.7044677734,16.03125), Vector(-345.96875,-611.07299804688,195.88711547852), Color(255,0,191))
Zones:AddZone("Spawn District","rp_downtown_tits_v2", Vector(-151.68000793457,-1754.0430908203,-205.96875), Vector(-679.87939453125,-2982.96875,192.83625793457), Color(255,0,191))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-1461.2159423828,375.96875,-209.83319091797), Vector(-2083.8461914063,-140.96875,138.96105957031), Color(255,0,97))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-2510.6379394531,23.312269210815,10.03125), Vector(-1453.2048339844,1125.96875,241.72666931152), Color(255,0,97))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-1999.3309326172,23.033031463623,-179.96875), Vector(-2510.6040039063,1105.6566162109,17.968748092651), Color(255,0,97))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-1455.3878173828,965.72686767578,7.03125), Vector(-1149.0762939453,1135.96875,207.66160583496), Color(255,0,97))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-1874.2004394531,1105.1596679688,-646.96875), Vector(-2335.4184570313,1208.6234130859,124.53479003906), Color(255,0,97))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-1432.9653320313,-170.71887207031,-209.46875), Vector(-2037.1087646484,-454.6184387207,-68.709358215332), Color(255,0,97))
Zones:AddZone("Police Department","rp_downtown_tits_v2", Vector(-1963.46875,-170.80401611328,-209.05209350586), Vector(-1826.53125,-141.09857177734,-69.722625732422), Color(255,0,97))
Zones:AddZone("Bank Vault","rp_downtown_tits_v2", Vector(-3779.1618652344,-2152.4965820313,-207.96875), Vector(-4480.96875,-1337.3311767578,35.82799911499), Color(127,95,0))
Zones:AddZone("Bank","rp_downtown_tits_v2", Vector(-3778.2683105469,-2187.5866699219,-215.96875), Vector(-2947.1235351563,-1162.3175048828,67.96875), Color(127,63,63))
Zones:AddZone("Fountain District","rp_downtown_tits_v2", Vector(-577.60296630859,-577.904296875,-190.96875), Vector(-510.03125,-371.02203369141,-22.602783203125), Color(255,127,127))
Zones:AddZone("Shopping & Electrical Tunnel","rp_downtown_tits_v2", Vector(63.127517700195,1992.1064453125,-223.96875), Vector(416.96875,2639.5166015625,32.50626373291), Color(63,127,79))
Zones:AddZone("Shopping District","rp_downtown_tits_v2", Vector(953.73773193359,2171.0393066406,-219.96875), Vector(-2027.5856933594,31.968757629395,637.77819824219), Color(127,111,63))
Zones:AddZone("Shopping District","rp_downtown_tits_v2", Vector(672.68084716797,-576.72839355469,-214.96875), Vector(-576.96875,32.660720825195,205.72091674805), Color(127,111,63))
Zones:AddZone("Shopping District","rp_downtown_tits_v2", Vector(-1558.0407714844,2132.8303222656,-300.96875), Vector(-2015.7264404297,1761.6866455078,-190.96875), Color(127,111,63))
Zones:AddZone("Fountain District","rp_downtown_tits_v2", Vector(-295.45161437988,31.638122558594,-210.96875), Vector(-3041.8664550781,-3337.7897949219,601.96875), Color(255,127,127))
Zones:AddZone("Crackhouse & Entertainment Tunnel","rp_downtown_tits_v2", Vector(2143.03125,4211.2036132813,-213.59460449219), Vector(2496.96875,5886.3325195313,32.271293640137), Color(0,31,127))
Zones:AddZone("Nightclub","rp_downtown_tits_v2", Vector(3262.4047851563,7590.3974609375,-191.96875), Vector(2564.1098632813,6724.03125,325.77890014648), Color(127,0,95))
Zones:AddZone("Entertainment District","rp_downtown_tits_v2", Vector(3534.8693847656,5887.1435546875,-215.96875), Vector(-1011.9091796875,8401.54296875,334.96875), Color(63,0,127))
Zones:AddZone("Entertainment District","rp_downtown_tits_v2", Vector(2093.9267578125,5888.4619140625,-205.96875), Vector(448.15826416016,4272.03125,187.833984375), Color(63,0,127))
Zones:AddZone("Outskirts","rp_downtown_tits_v2", Vector(4107.634765625,473.67404174805,-231.12910461426), Vector(7128.5190429688,2499.8044433594,166.55130004883), Color(0,127,31))
Zones:AddZone("Park & Outskirts Tunnel","rp_downtown_tits_v2", Vector(3664.7326660156,1856.6317138672,-213.96875), Vector(4112.603515625,1471.03125,35.678867340088), Color(63,127,0))
Zones:AddZone("Power Plant","rp_downtown_tits_v2", Vector(-520.87866210938,3168.1645507813,-205.96875), Vector(-1039.6904296875,3383.96875,51.799983978271), Color(33,255,0))
Zones:AddZone("Nuclear Reactor Room","rp_downtown_tits_v2", Vector(-537.0478515625,4407.96875,-205.87274169922), Vector(-1474.3254394531,3176.03125,51.923675537109), Color(255,191,0))
Zones:AddZone("Electrical District","rp_downtown_tits_v2", Vector(1527.6889648438,2639.322265625,-215.96875), Vector(-1465.5935058594,4242.96875,198.12640380859), Color(127,63,111))
Zones:AddZone("Electrical District","rp_downtown_tits_v2", Vector(-1469.8153076172,4243.08203125,-215.96875), Vector(-532.2958984375,4412.3393554688,71.96875), Color(127,63,111))
Zones:AddZone("Electrical & Entertainment Tunnel","rp_downtown_tits_v2", Vector(62.142654418945,4240.0649414063,-213.96875), Vector(417.96875,5887.322265625,32.553634643555), Color(63,79,127))
Zones:AddZone("Electrical & Crackhouse Tunnel","rp_downtown_tits_v2", Vector(1527.6510009766,4160.96875,-213.9033203125), Vector(2093.5747070313,3778.03125,35.904834747314), Color(63,127,127))
Zones:AddZone("Park & Shopping Tunnel","rp_downtown_tits_v2", Vector(945.29541015625,872.91217041016,-213.96875), Vector(1983.5560302734,487.03125,32.557228088379), Color(95,127,63))
Zones:AddZone("Warehouse District","rp_downtown_tits_v2", Vector(-6177.6083984375,5715.5952148438,-218.96875), Vector(-1483.2010498047,588.34265136719,525.68273925781), Color(255,127,223))
Zones:AddZone("Warehouse District","rp_downtown_tits_v2", Vector(-4072.03125,1026.5592041016,-323.1291809082), Vector(-5017.7548828125,646.07366943359,-208.74340820313), Color(255,127,223))
Zones:AddZone("Mines","rp_downtown_tits_v2", Vector(5001.8876953125,501.8298034668,-562.74792480469), Vector(2759.3427734375,1871.8859863281,-230.03125), Color(127,159,255))
Zones:AddZone("Underground Lair","rp_downtown_tits_v2", Vector(4315.41015625,4782.513671875,-1241.8848876953), Vector(3081.0192871094,1871.9208984375,-369.6569519043), Color(127,255,255))
Zones:AddZone("Northern Sewage Reservoir","rp_downtown_tits_v2", Vector(-1532.2706298828,4319.8823242188,-705.88464355469), Vector(1131.96875,2452.3564453125,-218.40829467773), Color(255,255,255))
Zones:AddZone("Northern Sewage Reservoir","rp_downtown_tits_v2", Vector(-1504.8201904297,5855.7919921875,-713.96875), Vector(1104.7280273438,4317.6694335938,-443.03125), Color(255,255,255))
Zones:AddZone("Northern Sewage Reservoir","rp_downtown_tits_v2", Vector(-1016.4786987305,6630.9384765625,-668.96875), Vector(136.96875,5853.1713867188,-461.14959716797), Color(255,255,255))
Zones:AddZone("Southern Sewage Reservoir","rp_downtown_tits_v2", Vector(1104.96875,479.0302734375,-1045.6834716797), Vector(-1504.8562011719,2454.7766113281,-215.03125), Color(218,218,218))
Zones:AddZone("Southern Sewage Reservoir","rp_downtown_tits_v2", Vector(244.53971862793,-2080.560546875,-759.96875), Vector(-644.96875,479.87524414063,-444.17913818359), Color(218,218,218))
Zones:AddZone("Northern Sewer Tunnels","rp_downtown_tits_v2", Vector(-3400.1179199219,5970.1176757813,-447.96875), Vector(2760.6257324219,2454.05291748047,-211.03125), Color(191,255,127))
Zones:AddZone("Northern Sewer Tunnels","rp_downtown_tits_v2", Vector(436.10357666016,5904.861328125,-503.78765869141), Vector(62.597290039063,7987.3471679688,-217.27787780762), Color(191,255,127))
Zones:AddZone("Northern Sewer Tunnels","rp_downtown_tits_v2", Vector(-3399.8400878906,4311.9697265625,-388.96875), Vector(-3677.8395996094,4178.6196289063,-205.96875), Color(191,255,127))
Zones:AddZone("Southern Sewer Tunnels","rp_downtown_tits_v2", Vector(-3400.1179199219,2454.05291748047,-447.96875), Vector(2760.6257324219,-734.05291748047,-211.03125), Color(255,223,127))
Zones:AddZone("Southern Sewer Tunnels","rp_downtown_tits_v2", Vector(-3399.7470703125,1400.8132324219,-392.96875), Vector(-4608.859375,3304.96875,-211.52976989746), Color(255,223,127))


function Zones:GetZoneAt(pos)
    for k, zone in ipairs(Zones.MapZones) do
        if pos:WithinAABox(zone.mins, zone.maxs) then 
            return zone.name, k 
        end
    end

    local closestZone, closestKey, closestDist
    for k, zone in ipairs(Zones.MapZones) do
        local dist = math.min(
            pos:DistToSqr(zone.mins),
            pos:DistToSqr(zone.maxs),
            pos:DistToSqr(zone.cornerx),
            pos:DistToSqr(zone.cornery)
        )

        if not closestDist or dist < closestDist then
            closestZone, closestKey, closestDist = zone, k, dist
        end
    end

    return closestZone and closestZone.name or "Spawn District", closestKey or 1
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GetZone()
    return Zones:GetZoneAt(self:GetPos())
end

function PLAYER:IsInZone(name)
    local zoneName = self:GetZone()
    return name == zoneName
end

hook.Add("InitPostEntity", "Zones:StartZoneCheckTimer", function()
    timer.Create("Zones:ZoneCheckTimer", SERVER and 1 or 0.1, 0, function()
        local players = player.GetAll()
        for _, ply in ipairs(players) do
            local zoneName = ply:GetZone()

            if ply.Zone ~= zoneName then
                if ply.Zone then
                    hook.Run("Zones:PlayerLeftZone", ply, ply.Zone)
                end
                hook.Run("Zones:PlayerEnteredZone", ply, zoneName)
                ply.Zone = zoneName
            end
        end
    end)
end)