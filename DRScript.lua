-- Khai báo thư viện và biến
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

-- Biến trạng thái NoClip
local NoClipEnabled = false

-- Thời gian đếm ngược (10 phút = 600 giây)
local CountdownTime = 600
local TimerRunning = false

-- Tạo menu GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "DeadRailsHackMenu"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0.5, -100, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Dead Rails Hack Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = Frame

-- Nút bật/tắt NoClip
local NoClipButton = Instance.new("TextButton")
NoClipButton.Size = UDim2.new(0.9, 0, 0, 40)
NoClipButton.Position = UDim2.new(0.05, 0, 0.15, 0)
NoClipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.TextSize = 16
NoClipButton.Parent = Frame

-- Nút dịch chuyển đến tọa độ
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0.9, 0, 0, 40)
TeleportButton.Position = UDim2.new(0.05, 0, 0.35, 0)
TeleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TeleportButton.Text = "Teleport to (-346, 50, -49060)"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 16
TeleportButton.Parent = Frame

-- Hiển thị bộ đếm ngược
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.9, 0, 0, 30)
TimerLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TimerLabel.Text = "Timer: 10:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = 16
TimerLabel.Parent = Frame

-- Nút bật/tắt bộ đếm ngược
local TimerButton = Instance.new("TextButton")
TimerButton.Size = UDim2.new(0.9, 0, 0, 40)
TimerButton.Position = UDim2.new(0.05, 0, 0.75, 0)
TimerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TimerButton.Text = "Start Timer"
TimerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerButton.TextSize = 16
TimerButton.Parent = Frame

-- Hàm NoClip
local function ToggleNoClip()
    NoClipEnabled = not NoClipEnabled
    NoClipButton.Text = "NoClip: " .. (NoClipEnabled and "ON" or "OFF")
    if NoClipEnabled then
        RunService:BindToRenderStep("NoClip", Enum.RenderPriority.Character.Value, function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("NoClip")
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Hàm dịch chuyển
local function TeleportToCoords()
    if RootPart then
        RootPart.CFrame = CFrame.new(-346, 50, -49060)
    end
end

-- Hàm cập nhật bộ đếm ngược
local function UpdateTimer()
    if TimerRunning then
        while CountdownTime > 0 and TimerRunning do
            wait(1)
            CountdownTime = CountdownTime - 1
            local minutes = math.floor(CountdownTime / 60)
            local seconds = CountdownTime % 60
            TimerLabel.Text = string.format("Timer: %02d:%02d", minutes, seconds)
        end
        if CountdownTime <= 0 then
            TimerLabel.Text = "Timer: Expired"
            TimerRunning = false
            TimerButton.Text = "Start Timer"
        end
    end
end

-- Hàm bật/tắt bộ đếm ngược
local function ToggleTimer()
    if not TimerRunning then
        TimerRunning = true
        CountdownTime = 600 -- Reset về 10 phút
        TimerButton.Text = "Stop Timer"
        spawn(UpdateTimer) -- Chạy bộ đếm ngược trong luồng riêng
    else
        TimerRunning = false
        TimerButton.Text = "Start Timer"
    end
end

-- Gán sự kiện cho các nút
NoClipButton.MouseButton1Click:Connect(ToggleNoClip)
TeleportButton.MouseButton1Click:Connect(TeleportToCoords)
TimerButton.MouseButton1Click:Connect(ToggleTimer)

-- Đảm bảo menu có thể kéo được
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Thông báo khi script chạy
print("Dead Rails Hack Menu đã được kích hoạt!")
