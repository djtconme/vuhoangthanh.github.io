-- Khai báo biến cơ bản
local Players = game:GetService("Players")
local p = Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local r = c:WaitForChild("HumanoidRootPart")
local h = c:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- Tọa độ đích cuối cùng
local endPosition = Vector3.new(-346, 50, -49060)

-- Biến thời gian (10 phút = 600 giây)
local CountdownTime = 600

-- Tính năng NoClip (đi xuyên tường)
RunService.Stepped:Connect(function()
    for _, v in pairs(c:GetDescendants()) do 
        if v:IsA("BasePart") then 
            v.CanCollide = false 
        end 
    end
end)

-- Hàm di chuyển từ từ đến tọa độ đích
local function moveToEnd()
    if not r then
        warn("Không tìm thấy HumanoidRootPart!")
        return
    end

    local startPosition = r.Position
    local distance = (endPosition - startPosition).Magnitude
    local speed = 50 -- Tốc độ di chuyển (đơn vị mỗi giây, có thể điều chỉnh)
    local steps = math.floor(distance / speed) -- Số bước di chuyển
    local stepTime = 1 / 60 -- Thời gian mỗi bước (60 FPS)

    print("Bắt đầu di chuyển đến tọa độ (-346, 50, -49060)...")

    for i = 1, steps do
        local t = i / steps
        local newPos = startPosition:Lerp(endPosition, t)
        r.CFrame = CFrame.new(newPos)
        task.wait(stepTime)
    end

    r.CFrame = CFrame.new(endPosition)
    print("Đã đến tọa độ đích (-346, 50, -49060)!")
end

-- Xóa giao diện cũ nếu tồn tại
local oldGui = p:WaitForChild("PlayerGui"):FindFirstChild("DeadRailsHackMenu")
if oldGui then
    oldGui:Destroy()
    print("Đã xóa giao diện cũ!")
end

-- Tạo menu GUI mới
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = p:WaitForChild("PlayerGui")
ScreenGui.Name = "DeadRailsHackMenu"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

local MoveButton = Instance.new("TextButton")
MoveButton.Size = UDim2.new(0.8, 0, 0, 40)
MoveButton.Position = UDim2.new(0.1, 0, 0.15, 0)
MoveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MoveButton.Text = "Move to End"
MoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveButton.TextSize = 16
MoveButton.Parent = Frame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.8, 0, 0, 30)
TimerLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TimerLabel.Text = "Timer: 10:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = 16
TimerLabel.Parent = Frame

-- Gán sự kiện cho nút Move
MoveButton.MouseButton1Click:Connect(function()
    spawn(moveToEnd)
end)

-- Hàm cập nhật bộ đếm ngược (chạy ngay khi script khởi động)
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

-- Chạy bộ đếm ngược ngay lập tức
spawn(updateTimer)

-- Thông báo khi script chạy
print("Dead Rails Script đã được kích hoạt! Giao diện mới đã tải, bộ đếm ngược bắt đầu.")
