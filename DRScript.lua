-- Import thư viện GUI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Khởi tạo menu
local Window = OrionLib:MakeWindow({Name = "Dead Rails Hack Menu", HidePremium = false, SaveConfig = true, ConfigFolder = "DeadRailsHack"})

-- Tạo tab chính
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Chức năng bất tử
local function godMode()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.MaxHealth = math.huge
        character.Humanoid.Health = math.huge
        print("Bất tử đã được kích hoạt!")
    else
        print("Không tìm thấy Humanoid!")
    end
end

MainTab:AddButton({
    Name = "Bật Bất Tử",
    Callback = function()
        godMode()
    end
})

-- Chức năng di chuyển an toàn (không bị reset)
local function safeTeleport(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        local stepSize = 5  -- Di chuyển theo từng bước nhỏ
        local currentPosition = humanoidRootPart.Position
        local direction = (targetPosition - currentPosition).unit
        
        -- Di chuyển từng bước nhỏ để tránh bị reset
        for i = 1, (targetPosition - currentPosition).magnitude / stepSize do
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + direction * stepSize
            task.wait(0.1)  -- Đợi một chút trước khi di chuyển tiếp
        end
        
        -- Đảm bảo đến đúng vị trí
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
        print("Di chuyển thành công!")
    else
        print("Không tìm thấy nhân vật!")
    end
end

MainTab:AddButton({
    Name = "Teleport đến (-350, 3, -49030)",
    Callback = function()
        safeTeleport(Vector3.new(-350, 3, -49030))
    end
})

-- Hiển thị menu
OrionLib:Init()
