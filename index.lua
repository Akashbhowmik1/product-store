-- Script Farmer by Akash
-- Load the Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Script Farmer by Akash",
    LoadingTitle = "Garden Hub",
    LoadingSubtitle = "by Akash",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "GardenHub"
    },
    Discord = {
        Enabled = false,
        Invite = "vegax",
        RememberJoins = true
    },
    KeySystem = false
})

-- Create tabs and sections
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Hacks")
local AntiCheatTab = Window:CreateTab("Anti-Cheat Bypass", nil)
local AntiCheatSection = AntiCheatTab:CreateSection("Bypass Settings")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Variables for hack toggles
local autoHarvestEnabled = false
local autoSellEnabled = false
local autoPlantEnabled = false
local dupeItemsEnabled = false
local destroyPlantsEnabled = false
local dupePetsEnabled = false
local bypassAntiCheatEnabled = false
local spoofClientData = false
local antiKickEnabled = false
local antiBanEnabled = false

-- Anti-Cheat Bypass Variables
local originalConnections = {}
local spoofedPlayerData = {
    Sheckles = 0,
    Inventory = {},
    LastAction = tick()
}
local fakeClientTick = tick()
local bypassHeartbeat = nil

-- Helper function to find the player's garden
local function findPlayerGarden()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == player.Name then
            return obj
        end
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("Model") and child.Name == player.Name then
                return child
            end
        end
    end
    return nil
end

-- Helper function to find the Seed Shop
local function findSeedShop()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:match("Shop") or obj.Name:match("Market") or obj.Name:match("Seed")) then
            return obj
        end
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("Model") and (child.Name:match("Shop") or child.Name:match("Market") or child.Name:match("Seed")) then
                return child
            end
        end
    end
    return nil
end

-- Helper function to find the Sell Shop
local function findSellShop()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:match("Sell") or obj.Name:match("Merchant")) then
            return obj
        end
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("Model") and (child.Name:match("Sell") or child.Name:match("Merchant")) then
                return child
            end
        end
    end
    return nil
end

-- Helper function to find the Egg Shop
local function findEggShop()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:match("Egg") or obj.Name:match("Pet")) then
            return obj
        end
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("Model") and (child.Name:match("Egg") or child.Name:match("Pet")) then
                return child
            end
        end
    end
    return nil
end

-- Anti-Cheat Bypass: Spoof client data
local function spoofClient()
    if spoofClientData then
        local fakeData = HttpService:JSONEncode(spoofedPlayerData)
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage").Events.PlayerDataUpdate:FireServer(fakeData)
        end)
        if not success then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to spoof client data: " .. tostring(err),
                Duration = 5,
                Image = nil
            })
        end
    end
end

-- Anti-Cheat Bypass: Disable client-side checks
local function disableClientChecks()
    for _, script in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
        if script:IsA("LocalScript") and script.Name:match("AntiCheat") then
            script.Disabled = true
        end
    end
end

-- Anti-Cheat Bypass: Hook RemoteEvents to prevent detection
local function hookRemotes()
    local oldNameCall
    oldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name:match("AntiCheat") then
            return
        end
        return oldNameCall(self, ...)
    end)
end

-- Anti-Cheat Bypass: Simulate legitimate client heartbeat
local function startHeartbeat()
    if bypassHeartbeat then
        bypassHeartbeat:Disconnect()
    end
    bypassHeartbeat = RunService.Heartbeat:Connect(function()
        if bypassAntiCheatEnabled then
            fakeClientTick = tick()
            spoofedPlayerData.LastAction = fakeClientTick
            spoofClient()
        end
    end)
end

-- Anti-Cheat Bypass: Prevent kicks
local function preventKicks()
    if antiKickEnabled then
        local oldKick
        oldKick = hookmetamethod(game.Players.LocalPlayer, "Kick", function(self, ...)
            return
        end)
    end
end

-- Anti-Cheat Bypass: Spoof network activity
local function spoofNetwork()
    if antiBanEnabled then
        local oldFire
        oldFire = hookmetamethod(game:GetService("ReplicatedStorage"), "FireServer", function(self, ...)
            if self.Name:match("Ban") or self.Name:match("Kick") then
                return
            end
            return oldFire(self, ...)
        end)
    end
end

-- Auto Harvest Function
local function autoHarvest()
    while autoHarvestEnabled do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
            return
        end
        for _, object in pairs(Workspace:GetDescendants()) do
            if object:IsA("ProximityPrompt") and object.Parent:IsA("BasePart") then
                if object.Parent.Parent:FindFirstChild("Crop") or object.Parent.Name:match("Harvest") then
                    local distance = (player.Character.HumanoidRootPart.Position - object.Parent.Position).Magnitude
                    if distance <= object.MaxActivationDistance then
                        local success, err = pcall(function()
                            fireproximityprompt(object)
                        end)
                        if not success then
                            Rayfield:Notify({
                                Title = "Error",
                                Content = "Failed to harvest: " .. tostring(err),
                                Duration = 5,
                                Image = nil
                            })
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end

-- Auto Sell Function
local function autoSell()
    while autoSellEnabled do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
            return
        end
        local sellShop = findSellShop()
        if sellShop then
            for _, prompt in pairs(sellShop:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local distance = (player.Character.HumanoidRootPart.Position - prompt.Parent.Position).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        local success, err = pcall(function()
                            fireproximityprompt(prompt)
                        end)
                        if not success then
                            Rayfield:Notify({
                                Title = "Error",
                                Content = "Failed to sell: " .. tostring(err),
                                Duration = 5,
                                Image = nil
                            })
                        end
                    end
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Sell Shop not found in workspace!",
                Duration = 5,
                Image = nil
            })
        end
        task.wait(0.5)
    end
end

-- Auto Plant Function
local function autoPlant()
    while autoPlantEnabled do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
            return
        end
        local garden = findPlayerGarden()
        if not garden then
            Rayfield:Notify({
                Title = "Error",
                Content = "Your garden not found in workspace!",
                Duration = 5,
                Image = nil
            })
            task.wait(2)
            return
        end
        local seed = player.Backpack:FindFirstChildOfClass("Tool")
        if not seed then
            Rayfield:Notify({
                Title = "Error",
                Content = "No seeds found in backpack!",
                Duration = 5,
                Image = nil
            })
            task.wait(2)
            return
        end
        for _, plot in pairs(garden:GetDescendants()) do
            if plot:IsA("BasePart") and plot.Name:match("Soil") and not plot:FindFirstChild("Crop") then
                seed.Parent = player.Character
                local args = {plot}
                local success, err = pcall(function()
                    game:GetService("ReplicatedStorage").Events.PlantSeed:FireServer(unpack(args))
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Failed to plant seed: " .. tostring(err),
                        Duration = 5,
                        Image = nil
                    })
                end
            end
        end
        task.wait(0.1)
    end
end

-- Destroy Plants Function
local function destroyPlants()
    if destroyPlantsEnabled then
        local garden = findPlayerGarden()
        if not garden then
            Rayfield:Notify({
                Title = "Error",
                Content = "Your garden not found in workspace!",
                Duration = 5,
                Image = nil
            })
            return
        end
        for _, plot in pairs(garden:GetDescendants()) do
            if plot:IsA("BasePart") and plot:FindFirstChild("Crop") then
                local args = {plot}
                local success, err = pcall(function()
                    game:GetService("ReplicatedStorage").Events.RemovePlant:FireServer(unpack(args))
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Failed to destroy plant: " .. tostring(err),
                        Duration = 5,
                        Image = nil
                    })
                end
            end
        end
        Rayfield:Notify({
            Title = "Success",
            Content = "Destroyed all plants in your garden!",
            Duration = 5,
            Image = nil
        })
    end
end

-- Dupe Items (Seeds, Eggs - Usable)
local function dupeItems()
    if dupeItemsEnabled then
        local backpack = player:WaitForChild("Backpack")
        local items = {"Seed", "Egg"} -- Target seeds and eggs
        local foundItem = false
        for _, itemName in ipairs(items) do
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:match(itemName) then
                    foundItem = true
                    for i = 1, 5 do
                        local clonedItem = item:Clone()
                        clonedItem.Parent = backpack
                        -- Sync with server to ensure usability
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage").Events.EquipItem:FireServer(clonedItem)
                            task.wait(0.1)
                            game:GetService("ReplicatedStorage").Events.UnequipItem:FireServer(clonedItem)
                        end)
                        if not success then
                            Rayfield:Notify({
                                Title = "Error",
                                Content = "Failed to sync cloned item: " .. tostring(err),
                                Duration = 5,
                                Image = nil
                            })
                        end
                    end
                end
            end
        end
        if foundItem then
            Rayfield:Notify({
                Title = "Success",
                Content = "Duplicated seeds and eggs in backpack (usable).",
                Duration = 5,
                Image = nil
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No seeds or eggs found in backpack!",
                Duration = 5,
                Image = nil
            })
        end
    end
end

-- Dupe Pets (Hatched, Sellable)
local function dupePets()
    if dupePetsEnabled then
        local petFolder = player:WaitForChild("Pets", 5)
        if not petFolder then
            Rayfield:Notify({
                Title = "Error",
                Content = "Pet folder not found!",
                Duration = 5,
                Image = nil
            })
            return
        end
        local foundPet = false
        for _, pet in pairs(petFolder:GetChildren()) do
            if pet:IsA("Model") or pet:IsA("ObjectValue") then
                foundPet = true
                for i = 1, 3 do
                    local clonedPet = pet:Clone()
                    clonedPet.Parent = petFolder
                    -- Sync with server to make pet sellable
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage").Events.ActivatePet:FireServer(clonedPet)
                        task.wait(0.1)
                        game:GetService("ReplicatedStorage").Events.RegisterPet:FireServer(clonedPet)
                    end)
                    if not success then
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "Failed to sync cloned pet: " .. tostring(err),
                            Duration = 5,
                            Image = nil
                        })
                    end
                end
            end
        end
        if foundPet then
            Rayfield:Notify({
                Title = "Success",
                Content = "Duplicated hatched pets (sellable).",
                Duration = 5,
                Image = nil
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No hatched pets found!",
                Duration = 5,
                Image = nil
            })
        end
    end
end

-- Auto Harvest Toggle
MainTab:CreateToggle({
    Name = "Auto Harvest",
    CurrentValue = false,
    Callback = function(Value)
        autoHarvestEnabled = Value
        if autoHarvestEnabled then
            Rayfield:Notify({
                Title = "Auto Harvest",
                Content = "Auto harvesting enabled!",
                Duration = 5,
                Image = nil
            })
            spawn(autoHarvest)
        else
            Rayfield:Notify({
                Title = "Auto Harvest",
                Content = "Auto harvesting disabled.",
                Duration = 5,
                Image = nil
            })
        end
    end
})

-- Auto Sell Toggle
MainTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Callback = function(Value)
        autoSellEnabled = Value
        if autoSellEnabled then
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto selling enabled!",
                Duration = 5,
                Image = nil
            })
            spawn(autoSell)
        else
            Rayfield:Notify({
                Title = "Auto Sell",
                Content = "Auto selling disabled.",
                Duration = 5,
                Image = nil
            })
        end
    end
})

-- Auto Plant Toggle
MainTab:CreateToggle({
    Name = "Auto Plant",
    CurrentValue = false,
    Callback = function(Value)
        autoPlantEnabled = Value
        if autoPlantEnabled then
            Rayfield:Notify({
                Title = "Auto Plant",
                Content = "Auto planting enabled!",
                Duration = 5,
                Image = nil
            })
            spawn(autoPlant)
        else
            Rayfield:Notify({
                Title = "Auto Plant",
                Content = "Auto planting disabled.",
                Duration = 5,
                Image = nil
            })
        end
    end
})

-- Dupe Items Toggle (Seeds, Eggs - Usable)
MainTab:CreateToggle({
    Name = "Dupe Seeds & Eggs (Usable)",
    CurrentValue = false,
    Callback = function(Value)
        dupeItemsEnabled = Value
        if dupeItemsEnabled then
            Rayfield:Notify({
                Title = "Dupe Items",
                Content = "Duplicating seeds and eggs enabled (usable).",
                Duration = 5,
                Image = nil
            })
            spawn(function()
                while dupeItemsEnabled do
                    dupeItems()
                    task.wait(5)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Dupe Items",
                Content = "Duplicating seeds and eggs disabled.",
                Duration = 5,
                Image = nil
            })
        end
    end
})

-- Dupe Pets Toggle (Hatched, Sellable)
MainTab:CreateToggle({
    Name = "Dupe Hatched Pets (Sellable)",
    CurrentValue = false,
    Callback = function(Value)
        dupePetsEnabled = Value
        if dupePetsEnabled then
            Rayfield:Notify({
                Title = "Dupe Pets",
                Content = "Duplicating hatched pets enabled (sellable).",
                Duration = 5,
                Image = nil
            })
            spawn(function()
                while dupePetsEnabled do
                    dupePets()
                    task.wait(5)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Dupe Pets",
                Content = "Duplicating hatched pets disabled.",
                Duration = 5,
                Image = nil
            })
        end
    end
})

-- Destroy Plants Toggle
MainTab:CreateToggle({
    Name = "Destroy Plants",
    CurrentValue = false,
    Callback = function(Value)
        destroyPlantsEnabled = Value
        if destroyPlantsEnabled then
            Rayfield:Notify({
                Title = "Destroy Plants",
                Content = "Destroying plants enabled!",
                Duration = 5,
                Image = nil
            })
            spawn(function()
                while destroyPlantsEnabled do
                    destroyPlants()
                    task.wait(5)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Destroy Plants",
                Content = "Destroying plants disabled.",
                Duration = 5,
                Image =
