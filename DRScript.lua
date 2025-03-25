-- Khai báo biến cơ bản
local Players = game:GetService("Players")
local p = Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local r = c:WaitForChild("HumanoidRootPart")
local h = c:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- Tọa độ đích
local endPosition = Vector3.new(-346, 50, -49050)

-- Biến thời gian (10 phút = 600 giây)
local CountdownTime = 600

-- Biến trạng thái NoClip
local NoClipEnabled = false
local NoClipConnection = nil

-- Hàm bật/tắt NoClip
local function toggleNoClip()
    NoClipEnabled = not NoClipEnabled
    if NoClipEnabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            for _, v in pairs(c:GetDescendants()) do 
                if v:IsA("BasePart") then 
                    v.CanCollide = false 
                end 
            end
        end)
        print("NoClip: BẬT")
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        for _, v in pairs(c:GetDescendants()) do 
            if v:IsA("BasePart") then 
                v.CanCollide = true 
            end 
        end
        if h then
            h:ChangeState(Enum.HumanoidStateType.GettingUp) -- Đặt lại trạng thái đứng
        end
        print("NoClip: TẮT")
    end
end

-- Hack bất tử (giữ máu tối đa)
RunService.Heartbeat:Connect(function()
    if h then
        h.Health = h.MaxHealth
    end
end)

-- Hàm di chuyển nhanh đến tọa độ đích
local function moveToEnd()
    if not r then
        warn("Không tìm thấy HumanoidRootPart!")
        return
    end

    -- Bật NoClip trong quá trình di chuyển
    if not NoClipEnabled then
        toggleNoClip()
    end

    local startPosition = r.Position
    local distance = (endPosition - startPosition).Magnitude
    local speed = 200 -- Tốc độ di chuyển (đơn vị mỗi giây)
    local steps = math.floor(distance / speed)
    local stepTime = 1 / 120 -- 120 FPS

    print("Bắt đầu di chuyển nhanh đến tọa độ (-346, 50, -49050)...")

    -- Di chuyển nhanh từng bước nhỏ
    for i = 1, steps do
        local t = i / steps
        local newPos = startPosition:Lerp(endPosition, t)
        r.CFrame = CFrame.new(newPos)
        task.wait(stepTime)
    end

    -- Đặt vị trí cuối cùng và giữ NoClip để tránh rơi
    r.CFrame = CFrame.new(endPosition)
    print("Đã đến tọa độ đích (-346, 50, -49050)! NoClip vẫn bật để tránh reset. Bạn có thể điều khiển bằng WASD.")
end

-- Xóa giao diện cũ (nếu có)
local playerGui = p:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("DeadRailsHackMenu")
if oldGui then
    oldGui:Destroy()
    print("Đã xóa giao diện cũ!")
end

-- Tạo menu GUI mới
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsHackMenu"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 220)
Frame.Position = UDim2.new(0.5, -100, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

local MoveButton = Instance.new("TextButton")
MoveButton.Size = UDim2.new(0.8, 0, 0, 40)
MoveButton.Position = UDim2.new(0.1, 0, 0.08, 0)
MoveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MoveButton.Text = "Move to End"
MoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveButton.TextSize = 16
MoveButton.Parent = Frame

local NoClipButton = Instance.new("TextButton")
NoClipButton.Size = UDim2.new(0.8, 0, 0, 40)
NoClipButton.Position = UDim2.new(0.1, 0, 0.28, 0)
NoClipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.TextSize = 16
NoClipButton.Parent = Frame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.8, 0, 0, 30)
TimerLabel.Position = UDim2.new(0.1, 0, 0.48, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TimerLabel.Text = "Timer: 10:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = 16
TimerLabel.Parent = Frame

local CoordLabel = Instance.new("TextLabel")
CoordLabel.Size = UDim2.new(0.8, 0, 0, 30)
CoordLabel.Position = UDim2.new(0.1, 0, 0.68, 0)
CoordLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CoordLabel.Text = "Coords: 0, 0, 0"
CoordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordLabel.TextSize = 14
CoordLabel.Parent = Frame

-- Gán sự kiện cho các nút
MoveButton.MouseButton1Click:Connect(function()
    spawn(moveToEnd)
end)

NoClipButton.MouseButton1Click:Connect(function()
    toggleNoClip()
    NoClipButton.Text = "NoClip: " .. (NoClipEnabled and "ON" or "OFF")
end)

-- Hàm cập nhật bộ đếm ngược
local function updateTimer()
    while CountdownTime > 0 do
        task.wait(1)
        CountdownTime = CountdownTime - 1
        local minutes = math.floor(CountdownTime / 60)
        local seconds = CountdownTime % 60
        TimerLabel.Text = string.format("Timer: %02d:%02d", minutes, seconds)
    end
    TimerLabel.Text = "Timer: Expired"
end

-- Hàm cập nhật tọa độ
local function updateCoords()
    while true do
        if r then
            local pos = r.Position
            CoordLabel.Text = string.format("Coords: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
        task.wait(0.1)
    end
end

-- Chạy bộ đếm ngược và tọa độ ngay lập tức
spawn(updateTimer)
spawn(updateCoords)

-- Thông báo khi script chạy
print("Dead Rails Script đã được kích hoạt! Tọa độ đích: (-346, 50, -49050), giữ NoClip để tránh reset.")
