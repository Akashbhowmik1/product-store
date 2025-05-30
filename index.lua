-- Educational Lua Script for Grow a Garden (Roblox) - Money Hack with UI
-- For learning purposes only; violates Roblox ToS, use at your own risk

-- Services
local success, err = pcall(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterGui = game:GetService("StarterGui")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")

    -- Local player and variables
    local LocalPlayer = Players.LocalPlayer
    local leaderstats = nil
    local isRunning = false
    local ui = nil

    -- Wait for game and player to load
    repeat
        wait(0.1)
        leaderstats = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Coins")
    until game:IsLoaded() and LocalPlayer and leaderstats or (function()
        StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Failed to find Coins in leaderstats.",
            Duration = 5
        })
        return false
    end)()

    -- Notification function
    local function notify(title, text, duration)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration or 5
            })
        end)
    end

    -- Function to add money
    local function addMoney(amount)
        local success, errorMessage = pcall(function()
            local remotes = {"UpdateCoins", "AddCurrency", "GrantMoney"} -- Common remote names
            local remote = nil
            for _, name in pairs(remotes) do
                remote = ReplicatedStorage:FindFirstChild(name)
                if remote then break end
            end
            if not remote then
                error("No valid remote event found for adding money.")
            end
            remote:FireServer(amount)
        end)
        if not success then
            notify("Error", "Failed to add money: " .. errorMessage, 5)
            return false
        end
        return true
    end

    -- Function to create UI
    local function createUI()
        if ui then ui:Destroy() end
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.Name = "MoneyHackUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 150, 0, 120)
        Frame.Position = UDim2.new(0.5, -75, 0.5, -60)
        Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Frame.BorderSizePixel = 0
        Frame.Parent = ScreenGui
        Frame.BackgroundTransparency = 0.3
        Frame.Active = true
        Frame.Draggable = true

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = Frame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 25)
        Title.Position = UDim2.new(0, 0, 0, 5)
        Title.Text = "Money Hack"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1
        Title.Font = Enum.Font.Gotham
        Title.TextSize = 16
        Title.Parent = Frame

        local StartButton = Instance.new("TextButton")
        StartButton.Size = UDim2.new(0, 60, 0, 30)
        StartButton.Position = UDim2.new(0, 15, 0, 40)
        StartButton.Text = "Start"
        StartButton.TextColor3 = Color3.fromRGB(0, 255, 0)
        StartButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        StartButton.Font = Enum.Font.Gotham
        StartButton.TextSize = 14
        StartButton.Parent = Frame

        local StopButton = Instance.new("TextButton")
        StopButton.Size = UDim2.new(0, 60, 0, 30)
        StopButton.Position = UDim2.new(0, 75, 0, 40)
        StopButton.Text = "Stop"
        StopButton.TextColor3 = Color3.fromRGB(255, 0, 0)
        StopButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        StopButton.Font = Enum.Font.Gotham
        StopButton.TextSize = 14
        StopButton.Parent = Frame

        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1, 0, 0, 20)
        StatusLabel.Position = UDim2.new(0, 0, 0, 80)
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.TextSize = 12
        StatusLabel.Parent = Frame

        for _, button in pairs({StartButton, StopButton}) do
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 5)
            UICorner.Parent = button
        end

        return ScreenGui, StartButton, StopButton, StatusLabel
    end

    -- Money loop
    local function moneyLoop()
        while isRunning do
            if not addMoney(1000) then
                isRunning = false
                notify("Error", "Money loop stopped.", 5)
                break
            end
            notify("Success", "Added 1000 coins!", 2)
            wait(2) -- Increased delay for mobile stability
        end
    end

    -- Main execution
    local function init()
        local success, errorMessage = pcall(function()
            ui, local StartButton, StopButton, StatusLabel = createUI()
            notify("Success", "UI loaded! Ready to use.", 3)

            StartButton.MouseButton1Click:Connect(function()
                if not isRunning then
                    isRunning = true
                    StatusLabel.Text = "Status: Running"
                    notify("Started", "Money hack started!", 3)
                    spawn(moneyLoop)
                end
            end)

            StopButton.MouseButton1Click:Connect(function()
                if isRunning then
                    isRunning = false
                    StatusLabel.Text = "Status: Stopped"
                    notify("Stopped", "Money hack stopped.", 3)
                end
            end)

            UserInputService.TouchTapInWorld:Connect(function()
                if isRunning then
                    addMoney(1000)
                end
            end)
        end)

        if not success then
            notify("Error", "Script failed: " .. errorMessage, 5)
        end
    end

    if leaderstats then
        init()
    else
        notify("Error", "Cannot find Coins. Script stopped.", 5)
    end
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Script initialization failed: " .. err,
        Duration = 5
    })
end
