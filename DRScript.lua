-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = Library:MakeWindow({Name = "Dead Rails Hack", HidePremium = false, SaveConfig = true, ConfigFolder = "DeadRails"})

-- Người chơi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChild("Humanoid")

-- Biến trạng thái
local GodMode = false
local AutoCollect = false

-- Bật/Tắt Bất Tử
function ToggleGodMode(state)
    GodMode = state
    while GodMode do
        if humanoid then
            humanoid.Health = math.huge
        end
        wait(0.5)
    end
end

-- Dịch chuyển đến Bonds
function TeleportToBonds()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Part") and v.Name == "Bond" then
            rootPart.CFrame = v.CFrame
            wait(0.5)
        end
    end
end

-- Auto Collect Bonds
function AutoCollectBonds(state)
    AutoCollect = state
    while AutoCollect do
        TeleportToBonds()
        wait(3)
    end
end

-- Tạo Tab chính
local MainTab = Window:MakeTab({ Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false })

-- Nút Bật/Tắt Bất Tử
MainTab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(state)
        ToggleGodMode(state)
    end
})

-- Nút Teleport đến Bonds
MainTab:AddButton({
    Name = "Teleport to Bonds",
    Callback = function()
        TeleportToBonds()
    end
})

-- Nút Auto Collect Bonds
MainTab:AddToggle({
    Name = "Auto Collect Bonds",
    Default = false,
    Callback = function(state)
        AutoCollectBonds(state)
    end
})

-- Hiển thị GUI
Library:Init()
