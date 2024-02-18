Zones = Zones or {}
Zones.MapZones = Zones.MapZones or {}

hook.Add("Zones:PlayerEnteredZone", "Zones:HandlePlayerEnteredZone", function(ply, zone)
    print("ENTERING: ", zone)
end)

hook.Add("Zones:PlayerLeftZone", "Zones:HandlePlayerLeftZone", function(ply, zone)
    print("LEAVING: ", zone)
end)
