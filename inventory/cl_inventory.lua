Inventory = Inventory or {}


// Create an inventory on the local player
net.Receive("Inventory.Initialize", function()

    LocalPlayer().Inventory = {}

    print("Inventory initialized")

end)


// Add an item to the local players inventory
net.Receive("Inventory.AddItem", function()

    local slot = net.ReadUInt(8)

    local item = net.ReadString()

    local amount = net.ReadUInt(16)

    LocalPlayer().Inventory[slot] = {item = item, amount = amount}

end)


concommand.Add("inventory_print", function()

    PrintTable(LocalPlayer().Inventory)

end)