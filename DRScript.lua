getfenv().death = false
loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/refs/heads/ok/dead%20rails"))()
task.wait(1)

local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local r, h, g = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChild("Humanoid"), c:FindFirstChild("Revolver") or p.Backpack:FindFirstChild("Revolver")

local xuyênTường = false -- Biến lưu trạng thái đi xuyên tường

local function setXuyenTuong(state)
    for _, v in pairs(c:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state -- Nếu `state` là true, tắt va chạm; nếu false, bật lại va chạm
        end
    end
end

local function shoot(b) 
    if g and b:FindFirstChild("HumanoidRootPart") then 
        local e = g:FindFirstChild("FireEvent") or game.ReplicatedStorage:FindFirstChild("FireEvent")
        if e then 
            e:FireServer(b.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)) 
        end 
    end 
end

-- Tạo GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)

-- Bộ đếm thời gian
local timerLabel = Instance.new("TextLabel", screenGui)
timerLabel.Size = UDim2.new(0, 200, 0, 50)
timerLabel.Position = UDim2.new(0.5, -100, 0, 20)
timerLabel.BackgroundTransparency = 0.5
timerLabel.BackgroundColor3 = Color3.new(0, 0, 0)
timerLabel.TextColor3 = Color3.new(1, 1, 1)
timerLabel.TextSize = 20
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.Text = "10:00"

-- Nút bật/tắt đi xuyên tường
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0, 80)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Đi xuyên tường: Tắt"

-- Xử lý khi bấm nút
toggleButton.MouseButton1Click:Connect(function()
    xuyênTường = not xuyênTường
    setXuyenTuong(xuyênTường)
    toggleButton.Text = "Đi xuyên tường: " .. (xuyênTường and "Bật" or "Tắt")
end)

-- Bộ đếm ngược thời gian
task.spawn(function()
    local timeLeft = 600
    while timeLeft > 0 do
        local minutes = math.floor(timeLeft / 60)
        local seconds = timeLeft % 60
        timerLabel.Text = string.format("%02d:%02d", minutes, seconds)
        task.wait(1)
        timeLeft = timeLeft - 1
    end
    timerLabel.Text = "Hết thời gian!"
end)

while task.wait(1.5) do -- Giảm lag bằng cách tăng thời gian chờ
    local targets = {}

    -- Lọc trước các mục tiêu hợp lệ
    for _, b in ipairs(workspace:GetChildren()) do 
        if b:IsA("Model") and b:FindFirstChild("Humanoid") and b ~= c then 
            table.insert(targets, b)
        end
    end

    -- Tấn công mục tiêu đã lọc
    for _, b in ipairs(targets) do 
        shoot(b) 
        task.wait(0.5) 
    end

    local bonds, total = 0, 0
    for _, bond in ipairs(workspace:GetChildren()) do 
        if bond:IsA("Part") and bond.Name == "Bond" and bond.Parent and bond.Parent:IsA("Model") and bond.Parent.Name == "BanditHouse" then
            total = total + 1
            bond.CanCollide = false
            bond.Anchored = false

            r.CFrame = bond.CFrame + Vector3.new(0, 1, 0)
            firetouchinterest(r, bond, 0)
            firetouchinterest(r, bond, 1)

            h:MoveTo(bond.Position + Vector3.new(0, 1, 0))
            task.wait(0.5)
            
            bonds = bonds + 1
            task.wait(0.2)
        end 
    end

    if bonds > 0 and bonds == total and h then 
        task.wait(1) 
        h.Health = 0 
    end
end
