local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/uwuware"))()
local Window = Library:CreateWindow("Dead Rails Hack")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local WalkSpeed = 10
local AutoMove = false
local GodMode = false
local NoClip = false

-- 🔹 Xuyên tường
function ToggleNoClip(state)
    NoClip = state
    RunService.Stepped:Connect(function()
        if NoClip then
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

-- 🔹 Bất tử
function ToggleGodMode(state)
    GodMode = state
    while GodMode do
        Humanoid.Health = 100
        task.wait(0.1)
    end
end

-- 🔹 Tự động đi đến điểm cuối
function AutoTeleport(state)
    AutoMove = state
    while AutoMove do
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(CFrame.new(-346, 0, -49060), 0.02)
        task.wait(0.1)
    end
end

-- 🛠️ Thêm các nút vào menu
Window:AddToggle("Xuyên Tường", function(state)
    ToggleNoClip(state)
end)

Window:AddToggle("Bất Tử", function(state)
    ToggleGodMode(state)
end)

Window:AddToggle("Tự động đến điểm cuối", function(state)
    AutoTeleport(state)
end)

Window:AddSlider("Tốc độ di chuyển", {min = 5, max = 50, default = 10}, function(value)
    WalkSpeed = value
    Humanoid.WalkSpeed = value
end)

Library:Init()

