-- Khai báo biến cơ bản
local Players = game:GetService("Players")
local p = Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local r = c:WaitForChild("HumanoidRootPart")
local h = c:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- Tọa độ đích cuối cùng
local endPosition = Vector3.new(-346, 50, -49060)

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

    -- Di chuyển từng bước nhỏ
    for i = 1, steps do
        local t = i / steps
        local newPos = startPosition:Lerp(endPosition, t) -- Tính toán vị trí trung gian
        r.CFrame = CFrame.new(newPos)
        task.wait(stepTime) -- Chờ một khoảng thời gian nhỏ để mô phỏng di chuyển
    end

    -- Đảm bảo đến đúng tọa độ cuối
    r.CFrame = CFrame.new(endPosition)
    print("Đã đến tọa độ đích (-346, 50, -49060)!")
end

-- Tạo menu GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = p:WaitForChild("PlayerGui")
ScreenGui.Name = "DeadRailsHackMenu"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

local MoveButton = Instance.new("TextButton")
MoveButton.Size = UDim2.new(0.8, 0, 0, 40)
MoveButton.Position = UDim2.new(0.1, 0, 0.3, 0)
MoveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MoveButton.Text = "Move to End"
MoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveButton.TextSize = 16
MoveButton.Parent = Frame

-- Gán sự kiện cho nút
MoveButton.MouseButton1Click:Connect(function()
    spawn(moveToEnd) -- Chạy hàm di chuyển trong luồng riêng để không làm treo script
end)

-- Thông báo khi script chạy
print("Dead Rails Move-to-End Script đã được kích hoạt!")
