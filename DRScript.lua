local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- UI Elements
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 230)
Frame.Position = UDim2.new(0.5, -125, 0.1, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.new(1, 1, 1)

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, 0, 0.15, 0)
TextLabel.Text = "Dead Rails Hack Menu"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1

local CountdownLabel = Instance.new("TextLabel", Frame)
CountdownLabel.Size = UDim2.new(1, 0, 0.15, 0)
CountdownLabel.Position = UDim2.new(0, 0, 0.15, 0)
CountdownLabel.TextColor3 = Color3.new(1, 1, 1)
CountdownLabel.BackgroundTransparency = 1

-- Countdown Timer (10 minutes)
local TimeLeft = 600
spawn(function()
    while TimeLeft > 0 do
        CountdownLabel.Text = "Time left: " .. math.floor(TimeLeft / 60) .. "m " .. (TimeLeft % 60) .. "s"
        TimeLeft = TimeLeft - 1
        wait(1)
    end
    ScreenGui:Destroy()
end)

-- Function to create buttons
local function createButton(text, position, callback)
    local button = Instance.new("TextButton", Frame)
    button.Size = UDim2.new(0.9, 0, 0.15, 0)
    button.Position = position
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.MouseButton1Click:Connect(callback)
    return button
end

-- God Mode Toggle
local GodMode = false
local GodButton = createButton("God Mode: OFF", UDim2.new(0.05, 0, 0.3, 0), function()
    GodMode = not GodMode
    GodButton.Text = "God Mode: " .. (GodMode and "ON" or "OFF")
    if GodMode then
        Humanoid.Health = math.huge
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if GodMode then Humanoid.Health = math.huge end
        end)
    end
end)

-- NoClip Toggle
local NoClip = false
local NoClipButton = createButton("NoClip: OFF", UDim2.new(0.05, 0, 0.45, 0), function()
    NoClip = not NoClip
    NoClipButton.Text = "NoClip: " .. (NoClip and "ON" or "OFF")
end)

game:GetService("RunService").Stepped:Connect(function()
    if NoClip then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Speed Input
local Speed = 16
local SpeedLabel = Instance.new("TextLabel", Frame)
SpeedLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
SpeedLabel.Text = "Speed: " .. Speed
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local SpeedInput = Instance.new("TextBox", Frame)
SpeedInput.Size = UDim2.new(0.9, 0, 0.1, 0)
SpeedInput.Position = UDim2.new(0.05, 0, 0.7, 0)
SpeedInput.PlaceholderText = "Enter Speed (10-50)"
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.new(1, 1, 1)
SpeedInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SpeedInput.ClearTextOnFocus = true

local ApplySpeedButton = createButton("Apply Speed", UDim2.new(0.05, 0, 0.85, 0), function()
    local newSpeed = tonumber(SpeedInput.Text)
    if newSpeed and newSpeed >= 10 and newSpeed <= 50 then
        Speed = newSpeed
        Humanoid.WalkSpeed = Speed
        SpeedLabel.Text = "Speed: " .. Speed
    else
        SpeedLabel.Text = "Invalid Speed!"
    end
end)
