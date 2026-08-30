-- MM2 V92MEGA FIXED | РАБОЧИЙ WALLHACK + РОЛИ + МЕНЮ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== ПЕРЕМЕННЫЕ =====
local wallhackEnabled = true
local aimbotEnabled = true
local selectedRole = nil -- "Murderer", "Innocent", "Sheriff"

-- ===== МЕНЮ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 340)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(0, 260, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🔪 MM2 V92MEGA [FIXED]"
title.TextColor3 = Color3.fromRGB(255, 50, 80)
title.BackgroundTransparency = 1
title.TextScaled = true

-- ===== ВЫБОР РОЛИ =====
local roleFrame = Instance.new("Frame")
roleFrame.Parent = mainFrame
roleFrame.Size = UDim2.new(0, 240, 0, 100)
roleFrame.Position = UDim2.new(0, 10, 0, 35)
roleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
roleFrame.BackgroundTransparency = 0.3

local roleLabel = Instance.new("TextLabel")
roleLabel.Parent = roleFrame
roleLabel.Size = UDim2.new(0, 240, 0, 20)
roleLabel.Position = UDim2.new(0, 0, 0, 0)
roleLabel.Text = "ВЫБРАТЬ РОЛЬ (НАЖМИ)"
roleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
roleLabel.BackgroundTransparency = 1
roleLabel.TextScaled = true

local btnMurderer = Instance.new("TextButton")
btnMurderer.Parent = roleFrame
btnMurderer.Size = UDim2.new(0, 75, 0, 30)
btnMurderer.Position = UDim2.new(0, 5, 0, 25)
btnMurderer.Text = "🔴 МАРДЕР"
btnMurderer.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
btnMurderer.TextColor3 = Color3.fromRGB(255, 255, 255)

local btnInnocent = Instance.new("TextButton")
btnInnocent.Parent = roleFrame
btnInnocent.Size = UDim2.new(0, 75, 0, 30)
btnInnocent.Position = UDim2.new(0, 85, 0, 25)
btnInnocent.Text = "🟢 НЕВИННЫЙ"
btnInnocent.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
btnInnocent.TextColor3 = Color3.fromRGB(0, 0, 0)

local btnSheriff = Instance.new("TextButton")
btnSheriff.Parent = roleFrame
btnSheriff.Size = UDim2.new(0, 75, 0, 30)
btnSheriff.Position = UDim2.new(0, 165, 0, 25)
btnSheriff.Text = "🔵 ШЕРИФ"
btnSheriff.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
btnSheriff.TextColor3 = Color3.fromRGB(255, 255, 255)

-- СТАТУС РОЛИ
local roleStatus = Instance.new("TextLabel")
roleStatus.Parent = roleFrame
roleStatus.Size = UDim2.new(0, 240, 0, 20)
roleStatus.Position = UDim2.new(0, 0, 0, 60)
roleStatus.Text = "РОЛЬ НЕ ВЫБРАНА"
roleStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
roleStatus.BackgroundTransparency = 1
roleStatus.TextScaled = true

-- ===== ВКЛЮЧАТЕЛИ =====
local function createToggle(text, y, varName)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 240, 0, 28)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text .. " ✅"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(function()
        if varName == "wallhack" then
            wallhackEnabled = not wallhackEnabled
            btn.Text = text .. (wallhackEnabled and " ✅" or " ❌")
        elseif varName == "aimbot" then
            aimbotEnabled = not aimbotEnabled
            btn.Text = text .. (aimbotEnabled and " ✅" or " ❌")
        end
    end)
    return btn
end

createToggle("WALLHACK", 145, "wallhack")
createToggle("AIMBOT", 178, "aimbot")

-- ЗАКРЫТЬ
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 120, 0, 28)
closeBtn.Position = UDim2.new(0, 70, 0, 295)
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

-- ===== ФУНКЦИЯ ВЫБОРА РОЛИ (ПРИНУДИТЕЛЬНАЯ) =====
local function setRole(role)
    selectedRole = role
    -- ПРИНУДИТЕЛЬНАЯ УСТАНОВКА АТТРИБУТОВ (ДАЖЕ ЕСЛИ СЕРВЕР НЕ ДАЁТ)
    LocalPlayer:SetAttribute("Murderer", role == "Murderer")
    LocalPlayer:SetAttribute("Sheriff", role == "Sheriff")
    
    -- ПОПЫТКА ЧЕРЕЗ РЕМОТ (ЕСЛИ ЕСТЬ)
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("SetRole")
    if remote then
        remote:FireServer(role)
    end
    
    roleStatus.Text = "✅ РОЛЬ: " .. string.upper(role)
    roleStatus.TextColor3 = role == "Murderer" and Color3.fromRGB(255,0,0) or 
                            role == "Sheriff" and Color3.fromRGB(0,150,255) or 
                            Color3.fromRGB(0,255,0)
    print("🎯 УСТАНОВЛЕНА РОЛЬ: " .. role)
end

btnMurderer.MouseButton1Click:Connect(function() setRole("Murderer") end)
btnInnocent.MouseButton1Click:Connect(function() setRole("Innocent") end)
btnSheriff.MouseButton1Click:Connect(function() setRole("Sheriff") end)

-- ===== РАБОЧИЙ WALLHACK (ПОСТОЯННОЕ ОБНОВЛЕНИЕ) =====
local highlights = {}

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        
        local highlight = highlights[player]
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillTransparency = 0.2
            highlight.OutlineTransparency = 0.2
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlights[player] = highlight
        end
        
        -- ОБНОВЛЕНИЕ ЦВЕТА В РЕАЛЬНОМ ВРЕМЕНИ
        if wallhackEnabled then
            highlight.Enabled = true
            highlight.FillTransparency = 0.2
            if player:GetAttribute("Murderer") then
                highlight.FillColor = Color3.fromRGB(255, 0, 0)   -- КРАСНЫЙ
            elseif player:GetAttribute("Sheriff") then
                highlight.FillColor = Color3.fromRGB(0, 150, 255) -- СИНИЙ
            else
                highlight.FillColor = Color3.fromRGB(0, 255, 0)   -- ЗЕЛЁНЫЙ
            end
        else
            highlight.Enabled = false
        end
    end
end

-- ОБНОВЛЕНИЕ КАЖДЫЙ ФРЕЙМ
RunService.Heartbeat:Connect(updateESP)

-- ОБРАБОТКА НОВЫХ ИГРОКОВ
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.2)
        updateESP()
    end)
end)

-- ПРИ РЕСПАВНЕ ИГРОКА
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    if selectedRole then
        setRole(selectedRole) -- ВОССТАНОВЛЕНИЕ РОЛИ ПОСЛЕ СМЕРТИ
    end
end)

-- ===== AIMBOT ДЛЯ ШЕРИФА =====
local function getMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player:GetAttribute("Murderer") then
            return player
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not aimbotEnabled then return end
    if not LocalPlayer:GetAttribute("Sheriff") then return end
    
    local murderer = getMurderer()
    if not murderer or not murderer.Character then return end
    
    local head = murderer.Character:FindFirstChild("Head")
    if not head then return end
    
    local direction = (head.Position - Camera.CFrame.Position).unit
    local newCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction * 100)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 0.2)
end)

print("✅ MM2 V92MEGA [FIXED] ЗАГРУЖЕН!")
print("🔴 МАРДЕР = КРАСНЫЙ | 🟢 НЕВИННЫЙ = ЗЕЛЁНЫЙ | 🔵 ШЕРИФ = СИНИЙ")
print("📌 [SHIFT] - ОТКРЫТЬ/ЗАКРЫТЬ МЕНЮ")
print("🎮 ВЫБЕРИ РОЛЬ В МЕНЮ - ОНА СОХРАНИТСЯ ПОСЛЕ СМЕРТИ")
