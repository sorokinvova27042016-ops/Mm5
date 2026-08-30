-- STEAL AN EGG AUTO-FARM V92MEGA | TITAN TEMPLE + МАКС СКОРОСТЬ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ===== НАСТРОЙКИ =====
local settings = {
    AutoFarm = true,
    Speed = 67000, -- МАКСИМАЛЬНАЯ СКОРОСТЬ
    TargetZone = "Titan Temple",
    CollectAnyEgg = true,
    ReturnToBase = true,
    LoopDelay = 2
}

-- ===== МЕНЮ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 250, 0, 220)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(0, 250, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🥚 STEAL AN EGG V92MEGA"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.BackgroundTransparency = 1
title.TextScaled = true

local function createToggle(text, y, settingKey)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 230, 0, 28)
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

createToggle("AUTO-FARM (TITAN TEMPLE)", 40, "AutoFarm")
createToggle("ВОЗВРАТ НА БАЗУ", 75, "ReturnToBase")

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 120, 0, 28)
closeBtn.Position = UDim2.new(0, 65, 0, 180)
closeBtn.Text = "ЗАКРЫТЬ [SHIFT]"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ===== УСТАНОВКА СКОРОСТИ =====
local function setSpeed(speed)
    if Humanoid then
        Humanoid.WalkSpeed = speed
        print("🚀 СКОРОСТЬ: " .. speed)
    end
end

-- ===== ПОИСК ЯЙЦА В TITAN TEMPLE =====
local function findEgg()
    local eggs = {}
    
    -- ИЩЕМ ВСЕ ЯЙЦА НА КАРТЕ
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name:lower():find("egg") then
            table.insert(eggs, obj)
        elseif obj:IsA("Model") and obj.Name:lower():find("egg") then
            for _, part in pairs(obj:GetChildren()) do
                if part:IsA("Part") then
                    table.insert(eggs, part)
                end
            end
        end
    end
    
    -- ФИЛЬТРУЕМ ПО ЗОНЕ TITAN TEMPLE (ЕСЛИ ЕСТЬ)
    local templeEggs = {}
    for _, egg in pairs(eggs) do
        local pos = egg.Position
        -- ПРОВЕРКА, ЧТО ЯЙЦО РЯДОМ С TITAN TEMPLE (ПО КООРДИНАТАМ)
        if pos.X > -100 and pos.X < 100 and pos.Z > -100 and pos.Z < 100 then
            table.insert(templeEggs, egg)
        else
            table.insert(templeEggs, egg) -- ЕСЛИ НЕТ ТОЧНОЙ ЗОНЫ - БЕРЁМ ЛЮБОЕ
        end
    end
    
    if #templeEggs > 0 then
        return templeEggs[math.random(1, #templeEggs)] -- РАНДОМНОЕ ЯЙЦО
    elseif #eggs > 0 then
        return eggs[math.random(1, #eggs)] -- ЛЮБОЕ ДОСТУПНОЕ
    end
    return nil
end

-- ===== ПОИСК БАЗЫ (СПАВН) =====
local function findBase()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and (obj.Name:lower():find("spawn") or obj.Name:lower():find("base")) then
            return obj
        end
    end
    return nil
end

-- ===== АВТО-ФАРМ =====
local isFarming = false

local function autoFarm()
    if not settings.AutoFarm then return end
    if isFarming then return end
    if not Character or not Humanoid then return end
    
    isFarming = true
    
    -- МАКСИМАЛЬНАЯ СКОРОСТЬ
    setSpeed(settings.Speed)
    
    -- НАХОДИМ ЯЙЦО
    local targetEgg = findEgg()
    local base = findBase()
    local startPos = Character.HumanoidRootPart.Position
    
    if targetEgg then
        local eggPos = targetEgg.Position
        
        print("🥚 ЛЕТИМ К ЯЙЦУ...")
        Character.HumanoidRootPart.CFrame = CFrame.new(eggPos)
        task.wait(0.3)
        
        -- КАСАЕМСЯ ЯЙЦА (СБОР)
        if targetEgg:FindFirstChild("TouchInterest") then
            firetouchinterest(Character.HumanoidRootPart, targetEgg, 0)
            task.wait(0.2)
            firetouchinterest(Character.HumanoidRootPart, targetEgg, 1)
        end
        
        print("✅ ЯЙЦО СОБРАНО!")
        task.wait(0.5)
        
        -- ВОЗВРАТ НА БАЗУ
        if settings.ReturnToBase and base then
            print("🔄 ВОЗВРАЩАЕМСЯ НА БАЗУ...")
            Character.HumanoidRootPart.CFrame = CFrame.new(base.Position)
            task.wait(1)
        else
            -- ВОЗВРАТ НА СТАРТОВУЮ ПОЗИЦИЮ
            Character.HumanoidRootPart.CFrame = CFrame.new(startPos)
            task.wait(1)
        end
        
        print("🔄 ЦИКЛ ЗАВЕРШЁН")
        task.wait(settings.LoopDelay)
    else
        print("❌ ЯЙЦО НЕ НАЙДЕНО, ПОВТОР...")
        task.wait(1)
    end
    
    isFarming = false
end

-- ===== БЕСКОНЕЧНЫЙ ЦИКЛ =====
task.spawn(function()
    while true do
        if settings.AutoFarm then
            autoFarm()
        end
        task.wait(0.5)
    end
end)

-- ===== ОБНОВЛЕНИЕ СКОРОСТИ =====
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    wait(1)
    if settings.AutoFarm then
        setSpeed(settings.Speed)
    end
end)

print("✅ STEAL AN EGG V92MEGA ЗАГРУЖЕН!")
print("📌 [SHIFT] - МЕНЮ")
print("🥚 АВТО-СБОР ЯИЦ АКТИВИРОВАН")
print("🚀 СКОРОСТЬ 67K")
