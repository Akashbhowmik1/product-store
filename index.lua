-- Educational Lua Script for Grow a Garden (Roblox) - Money Hack with UI
-- For learning purposes only; use at your own risk as it violates Roblox ToS

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Local player
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
        Text = "Failed to find leaderstats or Coins. Game may not support this.",
        Duration = 5
    })
    return false
end)()

-- Function to create a notification
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- Function to add money (hypothetical remote call)
local function addMoney(amount)
    local success, errorMessage = pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("UpdateCoins") or ReplicatedStorage:FindFirstChild("AddCurrency")
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
    if ui then ui:Destroy() end -- Destroy existing UI to prevent duplicates
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "MoneyHackUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.BackgroundTransparency = 0.2
    Frame.Active = true
    Frame.Draggable = true -- Make UI draggable for mobile

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 5)
    Title.Text = "Money Hack - Grow a Garden"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = Frame

    local StartButton = Instance.new("TextButton")
    StartButton.Size = UDim2.new(0, 80, 0, 40)
    StartButton.Position = UDim2.new(0, 20, 0, 50)
    StartButton.Text = "Start"
    StartButton.TextColor3 = Color3.fromRGB(0, 255, 0)
    StartButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    StartButton.Font = Enum.Font.SourceSans
    StartButton.TextSize = 16
    StartButton.Parent = Frame

    local StopButton = Instance.new("TextButton")
    StopButton.Size = UDim2.new(0, 80, 0, 40)
    StopButton.Position = UDim2.new(0, 100, 0, 50)
    StopButton.Text = "Stop"
    StopButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    StopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    StopButton.Font = Enum.Font.SourceSans
    StopButton.TextSize = 16
    StopButton.Parent = Frame

    local AmountLabel = Instance.new("TextLabel")
    AmountLabel.Size = UDim2.new(1, 0, 0, 20)
    AmountLabel.Position = UDim2.new(0, 0, 0, 100)
    AmountLabel.Text = "Amount per click: 1000"
    AmountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AmountLabel.BackgroundTransparency = 1
    AmountLabel.Font = Enum.Font.SourceSans
    AmountLabel.TextSize = 14
    AmountLabel.Parent = Frame

    -- Button effects
    for _, button in pairs({StartButton, StopButton}) do
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = button
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end

    return ScreenGui, StartButton, StopButton
end

-- Main loop for adding money
local function moneyLoop()
    while isRunning do
        if not addMoney(1000) then
            isRunning = false
            notify("Error", "Money loop stopped due to an error.", 5)
            break
        end
        notify("Success", "Added 1000 coins!", 3)
        wait(1) -- Prevent server overload
    end
end

-- Main execution
local function init()
    local success, errorMessage = pcall(function()
        -- Create UI
        ui, local StartButton, StopButton = createUI()

        -- Start button functionality
        StartButton.MouseButton1Click:Connect(function()
            if not isRunning then
                isRunning = true
                notify("Started", "Money hack started!", 3)
                spawn(moneyLoop) -- Run in a separate thread
            end
        end)

        -- Stop button functionality
        StopButton.MouseButton1Click:Connect(function()
            if isRunning then
                isRunning = false
                notify("Stopped", "Money hack stopped.", 3)
            end
        end)

        -- Mobile touch support
        UserInputService.TouchTapInWorld:Connect(function()
            if isRunning then
                addMoney(1000) -- Allow manual taps on mobile
            end
        end)

        -- Cleanup on script re-injection
        game:GetService("CoreGui").ChildRemoved:Connect(function(child)
            if child.Name == "MoneyHackUI" then
                isRunning = false
                script:Destroy()
            end
        end)
    end)

    if not success then
        notify("Error", "Script initialization failed: " .. errorMessage, 5)
    end
end

-- Run the script
if leaderstats then
    init()
else
    notify("Error", "Cannot find Coins in leaderstats. Script stopped.", 5)
end
