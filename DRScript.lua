-- Khai báo biến cơ bản
local Players = game:GetService("Players")
local p = Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local r = c:WaitForChild("HumanoidRootPart")
local h = c:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- Tọa độ đích ban đầu
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
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

-- Hack bất tử (giữ máu tối đa)
RunService.Heartbeat:Connect(function()
    if h then
        h.Health = h.MaxHealth
    end
end)

-- Hàm di chuyển đến đích và kiểm tra reset
local function moveToEnd(statusLabel)
    if not r then
        statusLabel.Text = "Lỗi: Không tìm thấy nhân vật!"
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

    statusLabel.Text = "Di chuyển đến (-346, 50, -49050)..."

    -- Di chuyển nhanh từng bước nhỏ
    for i = 1, steps do
        local t = i / steps
        local newPos = startPosition:Lerp(endPosition, t)
        r.CFrame = CFrame.new(newPos)
        task.wait(stepTime)
    end

    r.CFrame = CFrame.new(endPosition)
    statusLabel.Text = "Đã đến (-346, 50, -49050)! NoClip bật, tắt để kiểm tra X/Z."

    -- Kiểm tra reset khi NoClip tắt
    spawn(function()
        while NoClipEnabled do
            task.wait(0.1) -- Chờ NoClip tắt
        end

        statusLabel.Text = "NoClip tắt, kiểm tra X từ -346..."
        local currentX = -346
        local stepX = 5 -- Thử tăng X từng 5 đơn vị
        local safeY = 50 -- Giữ Y = 50
        while currentX <= -300 do
            local testPos = Vector3.new(currentX, safeY, -49050)
            r.CFrame = CFrame.new(testPos)
            statusLabel.Text = "Kiểm tra X=" .. math.floor(currentX) .. "..."
            task.wait(1)

            if (r.Position - testPos).Magnitude > 50 then
                local resetPos = r.Position
                statusLabel.Text = "Bị reset tại X=" .. math.floor(currentX) .. "! Reset: " .. math.floor(resetPos.X) .. ", " .. math.floor(resetPos.Y) .. ", " .. math.floor(resetPos.Z)
                return
            end
            currentX = currentX + stepX
        end

        statusLabel.Text = "X=" .. math.floor(currentX) .. " an toàn, kiểm tra Z từ -49050..."
        local currentZ = -49050
        local stepZ = 10 -- Thử tăng Z từng 10 đơn vị
        while currentZ <= -49000 do
            local testPos = Vector3.new(currentX, safeY, currentZ)
            r.CFrame = CFrame.new(testPos)
            statusLabel.Text = "Kiểm tra Z=" .. math.floor(currentZ) .. "..."
            task.wait(1)

            if (r.Position - testPos).Magnitude > 50 then
                local resetPos = r.Position
                statusLabel.Text = "Bị reset tại Z=" .. math.floor(currentZ) .. "! Reset: " .. math.floor(resetPos.X) .. ", " .. math.floor(resetPos.Y) .. ", " .. math.floor(resetPos.Z)
                return
            end
            currentZ = currentZ + stepZ
        end

        -- Nếu không reset, thử hạ Y tại vị trí mới
        statusLabel.Text = "Z=" .. math.floor(currentZ) .. " an toàn, kiểm tra Y từ 50..."
        local currentY = 50
        local stepY = -0.1 -- Hạ Y từng 0.1
        while currentY >= 3 do
            local testPos = Vector3.new(currentX, currentY, currentZ)
            r.CFrame = CFrame.new(testPos)
            statusLabel.Text = "Kiểm tra Y=" .. string.format("%.1f", currentY) .. "..."
            task.wait(1)

            if (r.Position - testPos).Magnitude > 50 then
                local resetPos = r.Position
                statusLabel.Text = "Bị reset tại Y=" .. string.format("%.1f", currentY) .. "! Reset: " .. math.floor(resetPos.X) .. ", " .. math.floor(resetPos.Y) .. ", " .. math.floor(resetPos.Z)
                return
            end
            currentY = currentY + stepY
        end

        statusLabel.Text = "Vị trí (" .. math.floor(currentX) .. ", " .. string.format("%.1f", currentY) .. ", " .. math.floor(currentZ) .. ") an toàn!"
    end)
end

-- Xóa giao diện cũ (nếu có)
local playerGui = p:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("DeadRailsHackMenu")
if oldGui then
    oldGui:Destroy()
end

-- Tạo menu GUI mới
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsHackMenu"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 260)
Frame.Position = UDim2.new(0.5, -100, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

local MoveButton = Instance.new("TextButton")
MoveButton.Size = UDim2.new(0.8, 0, 0, 40)
MoveButton.Position = UDim2.new(0.1, 0, 0.06, 0)
MoveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MoveButton.Text = "Move to End"
MoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MoveButton.TextSize = 16
MoveButton.Parent = Frame

local NoClipButton = Instance.new("TextButton")
NoClipButton.Size = UDim2.new(0.8, 0, 0, 40)
NoClipButton.Position = UDim2.new(0.1, 0, 0.23, 0)
NoClipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.TextSize = 16
NoClipButton.Parent = Frame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.8, 0, 0, 30)
TimerLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TimerLabel.Text = "Timer: 10:00"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = 16
TimerLabel.Parent = Frame

local CoordLabel = Instance.new("TextLabel")
CoordLabel.Size = UDim2.new(0.8, 0, 0, 30)
CoordLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
CoordLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CoordLabel.Text = "Coords: 0, 0, 0"
CoordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordLabel.TextSize = 14
CoordLabel.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0, 40)
StatusLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
StatusLabel.Text = "Trạng thái: Chưa di chuyển"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Parent = Frame

-- Gán sự kiện cho các nút
MoveButton.MouseButton1Click:Connect(function()
    spawn(function() moveToEnd(StatusLabel) end)
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
