-- Загружаем библиотеку Rayfield для создания меню
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Создаём окно меню
local Window = Rayfield:CreateWindow({
    Name = "VD ESP Hub",
    LoadingTitle = "VD ESP Hub",
    LoadingSubtitle = "by you",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "VD_Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Key System",
        Note = "No key needed",
        FileName = "VDKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Создаём вкладку "ESP"
local ESPTab = Window:CreateTab("ESP", 4483362458) -- ID иконки можно поменять

-- Создаём вкладку "Движение"
local MoveTab = Window:CreateTab("Движение", 4483362458)

-----------------------------------------------------
-- ПЕРЕМЕННЫЕ И ЛОГИКА ESP (из твоего старого кода)
-----------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local PLAYER_ESP = false
local GENERATOR_ESP = false

local PLAYER_COLOR = Color3.fromRGB(255, 60, 60)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 0)

local playerHighlights = {}
local generatorHighlights = {}

local function createHighlight(adornee, color)
    local h = Instance.new("Highlight")
    h.Adornee = adornee
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.55
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = adornee
    return h
end

local function createBillboard(adornee, text, color)
    local bg = Instance.new("BillboardGui")
    bg.Adornee = adornee
    bg.Size = UDim2.new(0, 160, 0, 36)
    bg.StudsOffset = Vector3.new(0, 3.2, 0)
    bg.AlwaysOnTop = true
    bg.Parent = game.CoreGui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = bg
    return bg, label
end

local function updatePlayerESP()
    if not PLAYER_ESP then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if char and root and humanoid and humanoid.Health > 0 then
            if not playerHighlights[plr] then
                local h = createHighlight(char, PLAYER_COLOR)
                local bg, label = createBillboard(root, plr.Name, PLAYER_COLOR)
                playerHighlights[plr] = { Highlight = h, Billboard = bg, Label = label, Char = char }
            else
                local esp = playerHighlights[plr]
                if esp.Char ~= char then
                    esp.Billboard.Adornee = root
                    esp.Highlight.Adornee = char
                    esp.Char = char
                end
            end
        else
            if playerHighlights[plr] then
                if playerHighlights[plr].Highlight then playerHighlights[plr].Highlight:Destroy() end
                if playerHighlights[plr].Billboard then playerHighlights[plr].Billboard:Destroy() end
                playerHighlights[plr] = nil
            end
        end
    end
end

local function isGenerator(obj)
    local name = obj.Name:lower()
    return name:find("generator") or name:find("palka") or name:find("gen")
end

local function updateGeneratorESP()
    if not GENERATOR_ESP then return end
    for obj, esp in pairs(generatorHighlights) do
        if not obj.Parent then
            if esp.Highlight then esp.Highlight:Destroy() end
            if esp.Billboard then esp.Billboard:Destroy() end
            generatorHighlights[obj] = nil
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isGenerator(obj) and not generatorHighlights[obj] then
            local adornee = obj
            if obj:IsA("Model") and obj.PrimaryPart then
                adornee = obj.PrimaryPart
            elseif obj:IsA("BasePart") then
                adornee = obj
            else
                continue
            end
            local h = createHighlight(obj, GENERATOR_COLOR)
            local bg, label = createBillboard(adornee, "GENERATOR", GENERATOR_COLOR)
            generatorHighlights[obj] = { Highlight = h, Billboard = bg, Label = label }
        end
    end
end

RunService.RenderStepped:Connect(updatePlayerESP)
task.spawn(function()
    while task.wait(3) do
        updateGeneratorESP()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerHighlights[plr] then
        if playerHighlights[plr].Highlight then playerHighlights[plr].Highlight:Destroy() end
        if playerHighlights[plr].Billboard then playerHighlights[plr].Billboard:Destroy() end
        playerHighlights[plr] = nil
    end
end)

-----------------------------------------------------
-- ДОБАВЛЯЕМ КНОПКИ И ПЕРЕКЛЮЧАТЕЛИ В МЕНЮ
-----------------------------------------------------

-- Вкладка ESP: Переключатель для игроков
ESPTab:CreateToggle({
    Name = "ESP Игроков",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(value)
        PLAYER_ESP = value
        if not value then
            for plr, esp in pairs(playerHighlights) do
                if esp.Highlight then esp.Highlight:Destroy() end
                if esp.Billboard then esp.Billboard:Destroy() end
                playerHighlights[plr] = nil
            end
        end
    end
})

-- Вкладка ESP: Переключатель для генераторов
ESPTab:CreateToggle({
    Name = "ESP Генераторов",
    CurrentValue = false,
    Flag = "GenESP",
    Callback = function(value)
        GENERATOR_ESP = value
        if not value then
            for obj, esp in pairs(generatorHighlights) do
                if esp.Highlight then esp.Highlight:Destroy() end
                if esp.Billboard then esp.Billboard:Destroy() end
                generatorHighlights[obj] = nil
            end
        end
    end
})

-- Вкладка Движение: Кнопка Moonwalk
MoveTab:CreateButton({
    Name = "Активировать Moonwalk",
    Callback = function()
        -- Пытаемся запустить эмоцию Moonwalk
        -- Если в игре есть своя механика, нужно будет заменить эту строку
        local player = Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Пытаемся проиграть анимацию "moonwalk" или выполнить команду
                -- В разных играх это может работать по-разному
                local moonwalkId = "rbxassetid://1892313913" -- Пример ID анимации Moonwalk
                local anim = Instance.new("Animation")
                anim.AnimationId = moonwalkId
                local track = humanoid:LoadAnimation(anim)
                track:Play()
                
                Rayfield:Notify({
                    Title = "Moonwalk",
                    Content = "Попытка включить Moonwalk...",
                    Duration = 3,
                })
            end
        end
    end
})