-- Educational Script for Grow a Garden - Coins UI
-- For learning only. Violates Roblox ToS.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = nil
local coins = nil
local isRunning = false
local gui = nil

-- Wait until the player and coins are available
repeat
    wait()
    player = Players.LocalPlayer
until player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins")

coins = player.leaderstats.Coins

-- Notification helper
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

-- Add money using RemoteEvent
local function addMoney(amount)
    local remote = ReplicatedStorage:FindFirstChild("UpdateCoins") or ReplicatedStorage:FindFirstChild("AddCurrency")
    if remote then
        pcall(function()
            remote:FireServer(amount)
        end)
        return true
    else
        notify("Error", "Money remote not found!")
        return false
    end
end

-- Create simple UI in PlayerGui
local function createUI()
    if gui then gui:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CoinHackUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 130)
    frame.Position = UDim2.new(0.5, -100, 0.5, -65)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "💰 Coin Hack"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = frame

    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 80, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 0, 50)
    startBtn.Text = "▶ Start"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    startBtn.TextColor3 = Color3.new(1, 1, 1)
    startBtn.Font = Enum.Font.SourceSans
    startBtn.TextSize = 16
    startBtn.Parent = frame

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 80, 0, 40)
    stopBtn.Position = UDim2.new(0, 110, 0, 50)
    stopBtn.Text = "■ Stop"
    stopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    stopBtn.TextColor3 = Color3.new(1, 1, 1)
    stopBtn.Font = Enum.Font.SourceSans
    stopBtn.TextSize = 16
    stopBtn.Parent = frame

    -- Connect buttons
    startBtn.MouseButton1Click:Connect(function()
        if not isRunning then
            isRunning = true
            notify("Started", "Money loop started")
            spawn(function()
                while isRunning do
                    local success = addMoney(1000)
                    if not success then
                        isRunning = false
                        break
                    end
                    wait(1)
                end
            end)
        end
    end)

    stopBtn.MouseButton1Click:Connect(function()
        isRunning = false
        notify("Stopped", "Money loop stopped")
    end)

    gui = screenGui
end

createUI()
