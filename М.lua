-- RIVALS V92MEGA | WALLHACK + AIMBOT + МЕНЮ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ===== НАСТРОЙКИ =====
local settings = {
    Wallhack = true,
    Aimbot = true,
    AimSmoothness = 0.25, -- ПЛАВНОСТЬ (0.1 = МГНОВЕННО, 0.5 = ПЛАВНО)
    AimFOV = 120, -- УГОЛ ОБЗОРА ДЛЯ АИМА (ГРАДУСЫ)
    TeamColor = true -- ЦВЕТ ПО КОМАНДАМ (КРАСНЫЙ/СИНИЙ)
}

-- ===== СОЗДАНИЕ МЕНЮ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 240, 0, 280)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(0, 240, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🎯 RIVALS V92MEGA"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.BackgroundTransparency = 1
title.TextScaled = true

-- КНОПКИ ВКЛЮЧЕНИЯ
local function createToggle(text, y, settingKey)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 220, 0, 28)
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

createToggle("WALLHACK", 40, "Wallhack")
createToggle("AIMBOT", 75, "Aimbot")
createToggle("ЦВЕТ ПО КОМАНДАМ", 110, "TeamColor")

-- ПОЛЗУНОК ПЛАВНОСТИ
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Parent = mainFrame
smoothLabel.Size = UDim2.new(0, 100, 0, 20)
smoothLabel.Position = UDim2.new(0, 10, 0, 150)
smoothLabel.Text = "ПЛАВНОСТЬ: 0.25"
smoothLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothLabel.BackgroundTransparency = 1
smoothLabel.TextScaled = true

local smoothSlider = Instance.new("TextBox")
smoothSlider.Parent = mainFrame
smoothSlider.Size = UDim2.new(0, 100, 0, 25)
smoothSlider.Position = UDim2.new(0, 120, 0, 148)
smoothSlider.Text = "0.25"
smoothSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
smoothSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothSlider.FocusLost:Connect(function()
    local val = tonumber(smoothSlider.Text)
    if val then
        settings.AimSmoothness = math.clamp(val, 0.05, 1)
        smoothLabel.Text = "ПЛАВНОСТЬ: " .. string.format("%.2f", settings.AimSmoothness)
    end
end)

-- ЗАКРЫТИЕ
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 120, 0, 28)
closeBtn.Position = UDim2.new(0, 60, 0, 240)
closeBtn.Text = "ЗАКРЫТЬ [SHIFT]"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ===== ОТКРЫТИЕ/ЗАКРЫТИЕ ПО SHIFT =====
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ===== WALLHACK (ESP) =====
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
        
        if settings.TeamColor then
            if player.Team == LocalPlayer.Team then
                highlight.FillColor = Color3.fromRGB(0, 100, 255) -- СИНИЙ (СОЮЗНИКИ)
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- КРАСНЫЙ (ВРАГИ)
            end
        else
            highlight.FillColor = Color3.fromRGB(255, 255, 0) -- ЖЁЛТЫЙ (ВСЕ)
        end
    end
    
    player:GetPropertyChangedSignal("Team"):Connect(updateColor)
    player.CharacterAdded:Connect(function(char)
        highlight.Parent = char
        wait(0.2)
        updateColor()
    end)
    updateColor()
end

-- АКТИВАЦИЯ ESP ДЛЯ ВСЕХ
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end
Players.PlayerAdded:Connect(createESP)

-- ОБНОВЛЕНИЕ ESP КАЖДЫЙ ФРЕЙМ (ДЛЯ ВКЛ/ВЫКЛ)
RunService.Heartbeat:Connect(function()
    for player, highlight in pairs(espObjects) do
        if highlight then
            highlight.Enabled = settings.Wallhack
        end
    end
end)

-- ===== AIMBOT =====
local function getClosestEnemy()
    local closest = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character or not player.Character:FindFirstChild("Head") then continue end
        if player.Team == LocalPlayer.Team then continue end -- НЕ СТРЕЛЯЕМ ПО СВОИМ
        
        local headPos = player.Character.Head.Position
        local screenPos, onScreen = Camera:WorldToScreenPoint(headPos)
        if not onScreen then continue end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
        if dist < closestDist and dist < settings.AimFOV * 5 then
            closestDist = dist
            closest = player
        end
    end
    return closest
end

-- АИМБОТ
RunService.Heartbeat:Connect(function()
    if not settings.Aimbot then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return end
    
    local target = getClosestEnemy()
    if not target then return end
    
    local head = target.Character.Head
    if not head then return end
    
    -- ПЛАВНОЕ НАВЕДЕНИЕ
    local direction = (head.Position - Camera.CFrame.Position).unit
    local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction * 100)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, settings.AimSmoothness)
end)

print("✅ RIVALS V92MEGA ЗАГРУЖЕН!")
print("📌 [SHIFT] - МЕНЮ")
print("🔴 ВРАГИ - КРАСНЫЕ | 🔵 СОЮЗНИКИ - СИНИЕ")
print("🎯 АИМБОТ НАВОДИТСЯ НА БЛИЖАЙШЕГО ВРАГА")
