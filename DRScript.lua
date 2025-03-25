if not game:IsLoaded() then game.Loaded:Wait() end -- Đợi game load hoàn toàn

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer.Character -- Đợi nhân vật load

local Character = LocalPlayer.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local WalkSpeed = 10
local NoClip = false
local GodMode = false
local AutoMove = false

local GameStartTime = tick()
local EndTime = GameStartTime + 600 -- 10 phút

-- 🔹 Xuyên tường
RunService.Stepped:Connect(function()
    if NoClip then
        for _, v in ipairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 🔹 Bất tử
task.spawn(function()
    while true do
        if GodMode then
            Humanoid.Health = Humanoid.MaxHealth
        end
        task.wait(0.1)
    end
end)

-- 🔹 Di chuyển đến cuối game
task.spawn(function()
    while true do
        if AutoMove then
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(CFrame.new(-346, 0, -49060), 0.02)
        end
        task.wait(0.1)
    end
end)

-- 🔹 Hiển thị UI đơn giản (Hỗ trợ tốt trên KRNL)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local function CreateButton(name, pos, callback)
    local button = Instance.new("TextButton", ScreenGui)
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0, 10, 0, pos)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.MouseButton1Click:Connect(callback)
end

local CoordLabel = Instance.new("TextLabel", ScreenGui)
CoordLabel.Size = UDim2.new(0, 200, 0, 30)
CoordLabel.Position = UDim2.new(0, 10, 0, 10)
CoordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordLabel.BackgroundTransparency = 1

task.spawn(function()
    while true do
        if HumanoidRootPart then
            local pos = HumanoidRootPart.Position
            CoordLabel.Text = string.format("Tọa độ: X=%.1f, Y=%.1f, Z=%.1f", pos.X, pos.Y, pos.Z)
        end
        task.wait(0.2)
    end
end)

local TimerLabel = Instance.new("TextLabel", ScreenGui)
TimerLabel.Size = UDim2.new(0, 200, 0, 30)
TimerLabel.Position = UDim2.new(0, 10, 0, 40)
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.BackgroundTransparency = 1

task.spawn(function()
    while true do
        local TimeLeft = math.max(0, EndTime - tick())
        local minutes = math.floor(TimeLeft / 60)
        local seconds = TimeLeft % 60
        TimerLabel.Text = string.format("Thời gian còn lại: %02d:%02d", minutes, seconds)
        if TimeLeft <= 0 then
            TimerLabel.Text = "Hết thời gian!"
            break
        end
        task.wait(1)
    end
end)

CreateButton("Xuyên Tường (On/Off)", 80, function() NoClip = not NoClip end)
CreateButton("Bất Tử (On/Off)", 140, function() GodMode = not GodMode end)
CreateButton("Tự Động Đến Cuối (On/Off)", 200, function() AutoMove = not AutoMove end)
CreateButton("Tăng Tốc Độ", 260, function() WalkSpeed = WalkSpeed + 5; Humanoid.WalkSpeed = WalkSpeed end)
CreateButton("Giảm Tốc Độ", 320, function() WalkSpeed = math.max(5, WalkSpeed - 5); Humanoid.WalkSpeed = WalkSpeed end)
