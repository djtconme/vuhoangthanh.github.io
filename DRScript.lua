-- Script Lua hack Dead Rails Roblox

-- Khai báo các biến và dịch vụ
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

-- Bộ đếm ngược 10 phút (600 giây)
local countdownTime = 600 -- 10 phút tính bằng giây
local function startCountdown()
    while countdownTime > 0 do
        wait(1) -- Chờ 1 giây
        countdownTime = countdownTime - 1
        local minutes = math.floor(countdownTime / 60)
        local seconds = countdownTime % 60
        print("Time remaining: " .. minutes .. "m " .. seconds .. "s")
    end
    print("Countdown finished!")
end

-- Chế độ bất tử (God Mode)
local function enableGodMode()
    if humanoid then
        humanoid.MaxHealth = math.huge -- Máu tối đa vô hạn
        humanoid.Health = math.huge -- Máu hiện tại vô hạn
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            humanoid.Health = math.huge -- Phục hồi máu nếu bị giảm
        end)
    end
end

-- Chạy xuyên tường (Noclip)
local noclip = false
local function enableNoclip()
    noclip = true
    runService.Stepped:Connect(function()
        if noclip and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false -- Tắt va chạm
                end
            end
        end
    end)
end

-- Tăng tốc độ chạy
local function setSpeed()
    if humanoid then
        humanoid.WalkSpeed = 20 -- Tốc độ chạy khoảng 20
    end
end

-- Kích hoạt các chức năng
print("Hack Dead Rails activated!")
spawn(startCountdown) -- Bắt đầu bộ đếm ngược
enableGodMode() -- Kích hoạt chế độ bất tử
enableNoclip() -- Kích hoạt chạy xuyên tường
setSpeed() -- Đặt tốc độ chạy

-- Thông báo khi nhân vật respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    enableGodMode()
    enableNoclip()
    setSpeed()
    print("Character respawned - Hack reapplied!")
end)
