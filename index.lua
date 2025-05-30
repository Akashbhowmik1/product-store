-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Rayfield Mobile UI",
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "Mobile Version",
    Theme = "DarkBlue",
    ToggleUIKeybind = "", -- No keybind for mobile
})

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Auto Features")

-- Auto-Farm Button
Tab:CreateButton({
    Name = "Auto Farm Money",
    Callback = function()
        local remote = nil

        -- Try to find remote by name
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and string.lower(v.Name):find("money") then
                remote = v
                break
            end
        end

        if remote then
            Rayfield:Notify({
                Title = "Money Remote Found!",
                Content = "Starting auto farm...",
                Duration = 3,
                Image = 4483362458,
            })

            -- Auto-farm loop
            while task.wait(1) do
                pcall(function()
                    remote:FireServer()
                end)
            end
        else
            Rayfield:Notify({
                Title = "Remote Not Found",
                Content = "No Money RemoteEvent found!",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

-- Optional: Manual Show Button (mobile toggle)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 250)
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "Open UI"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18
btn.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

btn.MouseButton1Click:Connect(function()
    Rayfield:SetVisibility(true)
end)
