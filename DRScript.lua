-- 🛠 Tạo GUI Menu
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local NoClipButton = Instance.new("TextButton")
local TeleportButton = Instance.new("TextButton")
local GodModeButton = Instance.new("TextButton")
local TimerLabel = Instance.new("TextLabel")

-- 🎨 Thiết lập GUI
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Size = UDim2.new(0, 200, 0, 200)
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)

-- 🔲 Nút bật/tắt NoClip
NoClipButton.Parent = Frame
NoClipButton.Size = UDim2.new(0, 180, 0, 50)
NoClipButton.Position = UDim2.new(0, 10, 0, 10)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ✈️ Nút bay đến cuối game
TeleportButton.Parent = Frame
TeleportButton.Size = UDim2.new(0, 180, 0, 50)
TeleportButton.Position = UDim2.new(0, 10, 0, 70)
TeleportButton.Text = "Bay đến cuối game"
TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 💖 Nút bất tử
GodModeButton.Parent = Frame
GodModeButton.Size = UDim2.new(0, 180, 0, 50)
GodModeButton.Position = UDim2.new(0, 10, 0, 130)
GodModeButton.Text = "Bất Tử: OFF"
GodModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ⏳ Nhãn đếm ngược 10 phút
TimerLabel.Parent = Frame
TimerLabel.Size = UDim2.new(0, 180, 0, 30)
TimerLabel.Position = UDim2.new(0, 10, 0, 180)
TimerLabel.Text = "Thời gian còn: 10:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.BackgroundTransparency = 1

-- 🏃‍♂️ Nhân vật của người chơi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- 🚀 Biến điều khiển NoClip
local noclip = false
NoClipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoClipButton.Text = "NoClip: " .. (noclip and "ON" or "OFF")
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _, v in ipairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- ✈️ Bay đến tọa độ cuối map
TeleportButton.MouseButton1Click:Connect(function()
    local endPosition = Vector3.new(-346, 50, -49060) -- 🔥 Điểm đến cuối game
    local speed = 10 -- 🚀 Tốc độ bay (Đã chỉnh xuống 10)

    while (rootPart.Position - endPosition).Magnitude > 5 do
        rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.new(endPosition), 0.05) -- Di chuyển mượt mà
        task.wait(0.1) -- Chờ 0.1 giây mỗi lần cập nhật (tốc độ 10)
    end

    print("✅ Đã đến vị trí cuối game!")
end)

-- 💖 Bất tử
local godmode = false
GodModeButton.MouseButton1Click:Connect(function()
    godmode = not godmode
    GodModeButton.Text = "Bất Tử: " .. (godmode and "ON" or "OFF")
end)

task.spawn(function()
    while true do
        if godmode then
            humanoid.Health = humanoid.MaxHealth
        end
        task.wait(0.1)
    end
end)

-- ⏳ Đếm ngược 10 phút từ khi game bắt đầu
local startTime = tick()
task.spawn(function()
    while true do
        local elapsed = tick() - startTime
        local remaining = math.max(600 - elapsed, 0)
        local minutes = math.floor(remaining / 60)
        local seconds = remaining % 60
        TimerLabel.Text = string.format("Thời gian còn: %02d:%02d", minutes, seconds)

        if remaining <= 0 then
            TimerLabel.Text = "Hết thời gian!"
            break
        end
        task.wait(1)
    end
end)
