-- ✅ FIXED Grow a Garden - Coin UI
-- ⚠️ Educational purpose only

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer or Players:GetPlayers()[1]
local coins = nil
local isRunning = false
local gui = nil

-- ✅ Helper: Notify
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

-- ✅ Add money via RemoteEvent
local function addMoney(amount)
    local remote = ReplicatedStorage:FindFirstChild("UpdateCoins") or ReplicatedStorage:FindFirstChild("AddCurrency")
    if remote then
        pcall(function()
            remote:FireServer(amount)
        end)
        return true
    else
        warn("❌ RemoteEvent not found")
        notify("❌ Error", "No money RemoteEvent found!")
        return false
    end
end

-- ✅ Create the Coin UI
local function createUI()
    if gui then gui:Destroy() end

    gui = Instance.new("ScreenGui")
    gui.Name = "CoinUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui", 5) or player:FindFirstChildOfClass("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 140)
    frame.Position = UDim2.new(0.5, -110, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "💰 Coin Giver"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = frame

    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 90, 0, 40)
    startBtn.Position = UDim2.new(0, 15, 0, 50)
    startBtn.Text = "▶ Start"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    startBtn.TextColor3 = Color3.new(1, 1, 1)
    startBtn.Font = Enum.Font.SourceSans
    startBtn.TextSize = 16
    startBtn.Parent = frame

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 90, 0, 40)
    stopBtn.Position = UDim2.new(0, 115, 0, 50)
    stopBtn.Text = "■ Stop"
    stopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    stopBtn.TextColor3 = Color3.new(1, 1, 1)
    stopBtn.Font = Enum.Font.SourceSans
    stopBtn.TextSize = 16
    stopBtn.Parent = frame

    -- ✅ Button Events
    startBtn.MouseButton1Click:Connect(function()
        if not isRunning then
            isRunning = true
            notify("✅ Started", "Adding coins...")
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
        notify("🛑 Stopped", "Stopped coin loop")
    end)
end

-- ✅ Call UI
createUI()
