getfenv().death = false
loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/refs/heads/ok/dead%20rails"))()
task.wait(1)

local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local r, h = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChild("Humanoid")

-- 🔄 Tắt va chạm để tránh kẹt
game:GetService("RunService").Stepped:Connect(function()
    for _, v in pairs(c:GetDescendants()) do 
        if v:IsA("BasePart") then v.CanCollide = false end 
    end
end)

while task.wait(1) do
    -- 💰 Thu thập Bond
    local bonds, total = 0, 0
    for _, bond in ipairs(workspace:GetChildren()) do 
        if bond:IsA("Part") and bond.Name == "Bond" and bond.Parent and bond.Parent:IsA("Model") and bond.Parent.Name == "BanditHouse" then
            total = total + 1
            
            bond.CanCollide = false
            bond.Anchored = false
            
            -- Bay đến Bond
            r.CFrame = bond.CFrame + Vector3.new(0, 1, 0)
            task.wait(0.1)
            
            -- Chạm vào Bond
            firetouchinterest(r, bond, 0)
            firetouchinterest(r, bond, 1)

            -- Di chuyển humanoid đến Bond
            h:MoveTo(bond.Position + Vector3.new(0, 1, 0))
            task.wait(0.5)
            
            bonds = bonds + 1
            task.wait(0.2)
        end 
    end

    -- ⚰️ Reset nếu lấy hết Bond
    if bonds > 0 and bonds == total and h then 
        task.wait(1) 
        h.Health = 0 
    end
end
