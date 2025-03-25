-- 🛠 Tạo GUI Menu
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local NoClipButton = Instance.new("TextButton")
local TeleportButton = Instance.new("TextButton")

-- 🎨 Thiết lập GUI
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Size = UDim2.new(0, 200, 0, 150)
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

-- 🏃‍♂️ Nhân vật của người chơi
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

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
