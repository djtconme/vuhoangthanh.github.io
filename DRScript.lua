local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Menu UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.new(1, 1, 1)

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, 0, 0.3, 0)
TextLabel.Text = "Dead Rails Hack Menu"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1

local CountdownLabel = Instance.new("TextLabel", Frame)
CountdownLabel.Size = UDim2.new(1, 0, 0.3, 0)
CountdownLabel.Position = UDim2.new(0, 0, 0.3, 0)
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

-- God Mode (Bất tử)
Humanoid.Health = math.huge
Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    Humanoid.Health = math.huge
end)

-- NoClip (Xuyên tường)
local NoClip = true
game:GetService("RunService").Stepped:Connect(function()
    if NoClip then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

-- Speed Hack (Chạy nhanh)
Humanoid.WalkSpeed = 30
