-- MM2 V92MEGA | ПОЛНОЕ МЕНЮ + ВЫБОР РОЛИ + WALLHACK + AIMBOT
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== МЕНЮ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 250, 0, 320)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(0, 250, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🔪 MM2 V92MEGA"
title.TextColor3 = Color3.fromRGB(255, 50, 80)
title.BackgroundTransparency = 1
title.TextScaled = true

-- ===== ВЫБОР РОЛИ =====
local roleFrame = Instance.new("Frame")
roleFrame.Parent = mainFrame
roleFrame.Size = UDim2.new(0, 230, 0, 120)
roleFrame.Position = UDim2.new(0, 10, 0, 40)
roleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
roleFrame.BackgroundTransparency = 0.3

local roleLabel = Instance.new("TextLabel")
roleLabel.Parent = roleFrame
roleLabel.Size = UDim2.new(0, 230, 0, 20)
roleLabel.Position = UDim2.new(0, 0, 0, 0)
roleLabel.Text = "ВЫБОР РОЛИ (НАЖМИ)"
roleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
roleLabel.BackgroundTransparency = 1
roleLabel.TextScaled = true

local btnMurderer = Instance.new("TextButton")
btnMurderer.Parent = roleFrame
btnMurderer.Size = UDim2.new(0, 70, 0, 25)
btnMurderer.Position = UDim2.new(0, 5, 0, 25)
btnMurderer.Text = "🔴 МАРДЕР"
btnMurderer.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btnMurderer.TextColor3 = Color3.fromRGB(255, 255, 255)

local btnInnocent = Instance.new("TextButton")
btnInnocent.Parent = roleFrame
btnInnocent.Size = UDim2.new(0, 70, 0, 25)
btnInnocent.Position = UDim2.new(0, 80, 0, 25)
btnInnocent.Text = "🟢 НЕВИННЫЙ"
btnInnocent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
btnInnocent.TextColor3 = Color3.fromRGB(0, 0, 0)

local btnSheriff = Instance.new("TextButton")
btnSheriff.Parent = roleFrame
btnSheriff.Size = UDim2.new(0, 70, 0, 25)
btnSheriff.Position = UDim2.new(0, 155, 0, 25)
btnSheriff.Text = "🔵 ШЕРИФ"
btnSheriff.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
btnSheriff.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ===== НАСТРОЙКИ =====
local settings = {
    Wallhack = true,
    Aimbot = true,
    AutoKill = false
}

local function createToggle(text, y, settingKey)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 230, 0, 25)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text .. " ✅"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        settings[settingKey] = not settings[settingKey]
        btn.Text = text .. (settings[settingKey] and " ✅" or " ❌")
    end)
    return btn
end

createToggle("WALLHACK", 170, "Wallhack")
createToggle("AIMBOT", 200, "Aimbot")
createToggle("AUTO-KILL", 230, "AutoKill")

-- ЗАКРЫТЬ МЕНЮ
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 100, 0, 25)
closeBtn.Position = UDim2.new(0, 75, 0, 275)
closeBtn.Text = "ЗАКРЫТЬ [SHIFT]"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
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

-- ===== ВЫБОР РОЛИ (ФУНКЦИИ) =====
local function setRole(role)
    -- ОТПРАВКА ЗАПРОСА НА СЕРВЕР (РАБОТАЕТ В НЕКОТОРЫХ ВЕРСИЯХ)
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("SetRole")
    if remote then
        remote:FireServer(role)
        print("🎯 РОЛЬ УСТАНОВЛЕНА: " .. role)
    else
        -- ЕСЛИ РЕМОТ НЕТ - ПЫТАЕМСЯ ЧЕРЕЗ АТТРИБУТЫ (ЛОКАЛЬНО)
        LocalPlayer:SetAttribute("Murderer", role == "Murderer")
        LocalPlayer:SetAttribute("Sheriff", role == "Sheriff")
        print("⚠️ РЕМОТ НЕ НАЙДЕН, УСТАНОВЛЕНО ЛОКАЛЬНО (ТОЛЬКО ДЛЯ ESP)")
    end
end

btnMurderer.MouseButton1Click:Connect(function()
    setRole("Murderer")
    btnMurderer.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

btnInnocent.MouseButton1Click:Connect(function()
    setRole("Innocent")
    btnInnocent.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end)

btnSheriff.MouseButton1Click:Connect(function()
    setRole("Sheriff")
    btnSheriff.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end)

-- ===== WALLHACK (ПРАВИЛЬНЫЕ ЦВЕТА) =====
local function createESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    highlight.FillTransparency = 0.25
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    
    local function updateColor()
        if not settings.Wallhack then
            highlight.FillTransparency = 1
            return
        end
        highlight.FillTransparency = 0.25
        
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

-- АКТИВАЦИЯ ESP ДЛЯ ВСЕХ
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end
Players.PlayerAdded:Connect(createESP)

-- ===== AIMBOT НА МАРДЕРА (ДЛЯ ШЕРИФА) =====
local function getMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player:GetAttribute("Murderer") then
            return player
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not settings.Aimbot then return end
    if not LocalPlayer:GetAttribute("Sheriff") then return end
    
    local murderer = getMurderer()
    if not murderer then return end
    
    local head = murderer.Character:FindFirstChild("Head")
    if not head then return end
    
    local direction = (head.Position - Camera.CFrame.Position).unit
    local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction * 100)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.25)
end)

print("✅ MM2 V92MEGA ЗАГРУЖЕН!")
print("🔴 МАРДЕР = КРАСНЫЙ | 🟢 НЕВИННЫЙ = ЗЕЛЁНЫЙ | 🔵 ШЕРИФ = СИНИЙ")
print("🎯 ШЕРИФ АВТОМАТИЧЕСКИ НАВОДИТСЯ НА МАРДЕРА")
print("📌 [SHIFT] - ОТКРЫТЬ/ЗАКРЫТЬ МЕНЮ")
print("🎮 ВЫБЕРИ РОЛЬ В МЕНЮ ПЕРЕД РАУНДОМ")
