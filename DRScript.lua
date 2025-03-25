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
local CoordLabel
local TimerLabel

-- 🔹 Lấy thời gian game bắt đầu
local GameStartTime = os.time()
local EndTime = GameStartTime + 600 -- 10 phút (600 giây)

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

-- 🔹 Cập nhật tọa độ theo thời gian thực
function UpdateCoordinates()
    while task.wait(0.2) do
        if CoordLabel and HumanoidRootPart then
            local pos = HumanoidRootPart.Position
            CoordLabel:SetText(string.format("Tọa độ: X=%.1f, Y=%.1f, Z=%.1f", pos.X, pos.Y, pos.Z))
        end
    end
end

-- 🔹 Đếm ngược thời gian 10 phút từ lúc game bắt đầu
function StartTimer()
    while true do
        local TimeLeft = math.max(0, EndTime - os.time())
        local minutes = math.floor(TimeLeft / 60)
        local seconds = TimeLeft % 60
        if TimerLabel then
            TimerLabel:SetText(string.format("Thời gian còn lại: %02d:%02d", minutes, seconds))
        end
        if TimeLeft <= 0 then
            TimerLabel:SetText("Hết thời gian!")
            break
        end
        task.wait(1)
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

CoordLabel = Window:AddLabel("Tọa độ: Đang cập nhật...")
TimerLabel = Window:AddLabel("Thời gian còn lại: 10:00")

task.spawn(UpdateCoordinates)
task.spawn(StartTimer)

Library:Init()
