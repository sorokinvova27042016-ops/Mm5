-- MM2 ULTIMATE AUTO V92MEGA | ФАРМ + WALLHACK + ОБЕЗОРУЖИВАНИЕ + АВТО-ИГРА
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ===== НАСТРОЙКИ =====
local settings = {
    AutoFarm = true,        -- СБОР МОНЕТ
    AutoPlay = true,        -- АВТО-ИГРА (УБЕГАЕТ ОТ УБИЙЦЫ)
    Wallhack = true,        -- ВИДЕТЬ ВСЕХ
    DisarmSheriff = true,   -- ОТОБРАТЬ ПИСТОЛЕТ У ШЕРИФА
    Aimbot = true,          -- АИМБОТ (ДЛЯ ШЕРИФА)
    AutoShoot = true        -- АВТО-ВЫСТРЕЛ В МАРДЕРА
}

-- ===== МЕНЮ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 350)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(0, 260, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🔪 MM2 ULTIMATE V92MEGA"
title.TextColor3 = Color3.fromRGB(255, 50, 80)
title.BackgroundTransparency = 1
title.TextScaled = true

local function createToggle(text, y, settingKey)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 240, 0, 28)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text .. " ✅"
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        settings[settingKey] = not settings[settingKey]
        btn.Text = text .. (settings[settingKey] and " ✅" or " ❌")
    end)
    return btn
end

createToggle("AUTO-FARM (МОНЕТЫ)", 40, "AutoFarm")
createToggle("AUTO-PLAY (УБЕГАТЬ)", 75, "AutoPlay")
createToggle("WALLHACK", 110, "Wallhack")
createToggle("ОТОБРАТЬ ПИСТОЛЕТ", 145, "DisarmSheriff")
createToggle("AIMBOT (ДЛЯ ШЕРИФА)", 180, "Aimbot")
createToggle("AUTO-SHOOT", 215, "AutoShoot")

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 120, 0, 28)
closeBtn.Position = UDim2.new(0, 70, 0, 310)
closeBtn.Text = "ЗАКРЫТЬ [SHIFT]"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ===== WALLHACK (ПРАВИЛЬНЫЕ ЦВЕТА) =====
local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0.2
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    espObjects[player] = highlight
    
    local function updateColor()
        if not settings.Wallhack then
            highlight.Enabled = false
            return
        end
        highlight.Enabled = true
        
        if player:GetAttribute("Murderer") then
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- КРАСНЫЙ
        elseif player:GetAttribute("Sheriff") then
            highlight.FillColor = Color3.fromRGB(0, 150, 255) -- СИНИЙ
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0) -- ЗЕЛЁНЫЙ
        end
    end
    
    player:GetAttributeChangedSignal("Murderer"):Connect(updateColor)
    player:GetAttributeChangedSignal("Sheriff"):Connect(updateColor)
    player.CharacterAdded:Connect(function(char)
        highlight.Parent = char
        wait(0.2)
        updateColor()
    end)
    updateColor()
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end
Players.PlayerAdded:Connect(createESP)

RunService.Heartbeat:Connect(function()
    for player, highlight in pairs(espObjects) do
        if highlight then
            highlight.Enabled = settings.Wallhack
        end
    end
end)

-- ===== ОТОБРАТЬ ПИСТОЛЕТ У ШЕРИФА =====
local function disarmSheriff()
    if not settings.DisarmSheriff then return end
    if not LocalPlayer.Character then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player:GetAttribute("Sheriff") then continue end
        if not player.Character then continue end
        
        -- ИЩЕМ ПИСТОЛЕТ В РУКАХ ШЕРИФА
        local gun = player.Character:FindFirstChildOfClass("Tool")
        if gun and gun.Name:lower():find("gun") or gun.Name:lower():find("pistol") then
            -- ПЫТАЕМСЯ ВЫБРОСИТЬ
            gun.Parent = workspace
            task.wait(0.1)
            gun.Parent = nil
            print("🔫 ПИСТОЛЕТ ОТОБРАН У ШЕРИФА: " .. player.Name)
        end
    end
end

RunService.Heartbeat:Connect(disarmSheriff)

-- ===== АВТО-ФАРМ (СБОР МОНЕТ) =====
local function autoFarm()
    if not settings.AutoFarm then return end
    if not LocalPlayer.Character then return end
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name:lower():find("coin") and obj:FindFirstChild("TouchInterest") then
            local dist = (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if dist < 100 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position)
                task.wait(0.2)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
            end
        end
    end
end

RunService.Heartbeat:Connect(autoFarm)

-- ===== АВТО-ПЛЕЙ (УБЕГАЕТ ОТ УБИЙЦЫ) =====
local function autoPlay()
    if not settings.AutoPlay then return end
    if not LocalPlayer.Character then return end
    
    local murderer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player:GetAttribute("Murderer") and player.Character then
            murderer = player
            break
        end
    end
    
    if not murderer then return end
    
    local murdererPos = murderer.Character.HumanoidRootPart.Position
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local dist = (murdererPos - myPos).magnitude
    
    -- ЕСЛИ УБИЙЦА РЯДОМ - УБЕГАЕМ
    if dist < 50 then
        local direction = (myPos - murdererPos).unit
        local newPos = myPos + direction * 20
        LocalPlayer.Character.Humanoid:MoveTo(newPos)
    end
end

RunService.Heartbeat:Connect(autoPlay)

-- ===== AIMBOT + AUTO-SHOOT ДЛЯ ШЕРИФА =====
local function getMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player:GetAttribute("Murderer") and player.Character then
            return player
        end
    end
    return nil
end

-- АИМБОТ
RunService.Heartbeat:Connect(function()
    if not settings.Aimbot then return end
    if not LocalPlayer:GetAttribute("Sheriff") then return end
    if not LocalPlayer.Character then return end
    
    local murderer = getMurderer()
    if not murderer or not murderer.Character then return end
    
    local head = murderer.Character:FindFirstChild("Head")
    if not head then return end
    
    local direction = (head.Position - Camera.CFrame.Position).unit
    local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction * 100)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.2)
end)

-- АВТО-ВЫСТРЕЛ
RunService.Heartbeat:Connect(function()
    if not settings.AutoShoot then return end
    if not LocalPlayer:GetAttribute("Sheriff") then return end
    if not LocalPlayer.Character then return end
    
    local murderer = getMurderer()
    if not murderer or not murderer.Character then return end
    
    local head = murderer.Character:FindFirstChild("Head")
    if not head then return end
    
    local dist = (head.Position - LocalPlayer.Character.Head.Position).magnitude
    if dist < 100 then
        -- ИМИТАЦИЯ ВЫСТРЕЛА
        local gun = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if gun and gun:FindFirstChild("Handle") then
            gun:Activate()
            task.wait(0.1)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Damage")
            if remote then
                remote:FireServer(head)
                print("🔫 ВЫСТРЕЛ В МАРДЕРА!")
            end
        end
    end
end)

print("✅ MM2 ULTIMATE V92MEGA ЗАГРУЖЕН!")
print("📌 [SHIFT] - МЕНЮ")
print("🔴 МАРДЕР = КРАСНЫЙ | 🔵 ШЕРИФ = СИНИЙ | 🟢 НЕВИННЫЙ = ЗЕЛЁНЫЙ")
print("🎯 ВСЕ ФУНКЦИИ АКТИВНЫ!")
