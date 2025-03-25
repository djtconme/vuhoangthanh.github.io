-- Script Lua hack Dead Rails Roblox với menu GUI

-- Khai báo các biến và dịch vụ
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local godButton = Instance.new("TextButton")
local noclipButton = Instance.new("TextButton")
local speedButton = Instance.new("TextButton")
local countdownLabel = Instance.new("TextLabel")

-- Trạng thái các chức năng
local godMode = false
local noclip = false
local speedEnabled = false
local countdownTime = 600 -- 10 phút tính bằng giây

-- Thiết lập GUI
screenGui.Parent = player:WaitForChild("PlayerGui")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0.5, -100, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0

title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Dead Rails Hack Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

godButton.Parent = frame
godButton.Size = UDim2.new(0, 180, 0, 40)
godButton.Position = UDim2.new(0, 10, 0, 40)
godButton.Text = "God Mode: OFF"
godButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
godButton.TextColor3 = Color3.fromRGB(255, 255, 255)
godButton.Font = Enum.Font.SourceSans
godButton.TextSize = 18

noclipButton.Parent = frame
noclipButton.Size = UDim2.new(0, 180, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 90)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.SourceSans
noclipButton.TextSize = 18

speedButton.Parent = frame
speedButton.Size = UDim2.new(0, 180, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 140)
speedButton.Text = "Speed (20): OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.SourceSans
speedButton.TextSize = 18

countdownLabel.Parent = frame
countdownLabel.Size = UDim2.new(1, 0, 0, 30)
countdownLabel.Position = UDim2.new(0, 0, 0, 200)
countdownLabel.Text = "Time: 10m 0s"
countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
countdownLabel.Font = Enum.Font.SourceSans
countdownLabel.TextSize = 16

-- Bộ đếm ngược
local function startCountdown()
    while countdownTime > 0 do
        wait(1)
        countdownTime = countdownTime - 1
        local minutes = math.floor(countdownTime / 60)
        local seconds = countdownTime % 60
        countdownLabel.Text = "Time: " .. minutes .. "m " .. seconds .. "s"
    end
    countdownLabel.Text = "Time: Expired"
end

-- Chế độ bất tử (God Mode)
local function toggleGodMode()
    godMode = not godMode
    if godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if godMode then
                humanoid.Health = math.huge
            end
        end)
        godButton.Text = "God Mode: ON"
        godButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        godButton.Text = "God Mode: OFF"
        godButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end

-- Chạy xuyên tường (Noclip)
local function toggleNoclip()
    noclip = not noclip
    if noclip then
        noclipButton.Text = "Noclip: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        noclipButton.Text = "Noclip: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end

runService.Stepped:Connect(function()
    if noclip and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif not noclip and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Tốc độ chạy
local function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled then
        humanoid.WalkSpeed = 20
        speedButton.Text = "Speed (20): ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        humanoid.WalkSpeed = 16 -- Tốc độ mặc định
        speedButton.Text = "Speed (20): OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end

-- Gán sự kiện cho nút
godButton.MouseButton1Click:Connect(toggleGodMode)
noclipButton.MouseButton1Click:Connect(toggleNoclip)
speedButton.MouseButton1Click:Connect(toggleSpeed)

-- Khởi động bộ đếm ngược
spawn(startCountdown)

-- Xử lý khi nhân vật respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if godMode then toggleGodMode(); toggleGodMode() end -- Reapply God Mode
    if noclip then toggleNoclip(); toggleNoclip() end -- Reapply Noclip
    if speedEnabled then toggleSpeed(); toggleSpeed() end -- Reapply Speed
end)

print("Hack menu loaded!")
