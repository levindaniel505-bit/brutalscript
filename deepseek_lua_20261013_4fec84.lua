local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ESP_KILLER = false
local ESP_PALLET = false
local ESP_GENERATOR = false
local FLY_ENABLED = false

local KILLER_COLOR = Color3.fromRGB(255, 0, 0)
local PALLET_COLOR = Color3.fromRGB(255, 255, 255)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 255)

local killerESP = {}
local palletESP = {}
local generatorESP = {}

local toggleStates = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrutalScriptMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 520)
mainFrame.Position = UDim2.new(0, 30, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local topCover = Instance.new("Frame")
topCover.Size = UDim2.new(1, 0, 0, 25)
topCover.Position = UDim2.new(0, 0, 0, 25)
topCover.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topCover.BorderSizePixel = 0
topCover.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BRUTAL SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(1, -75, 0.5, -16)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = topBar
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = topBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 15, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
openBtn.Text = "B"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.Parent = screenGui
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 12)
openCorner.Parent = openBtn
local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 255, 255)
openStroke.Thickness = 1.5
openStroke.Parent = openBtn

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local function createToggle(id, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. "   [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(80, 80, 80)
    s.Thickness = 1
    s.Parent = btn

    toggleStates[id] = false

    btn.MouseButton1Click:Connect(function()
        toggleStates[id] = not toggleStates[id]
        if toggleStates[id] then
            btn.Text = text .. "   [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            s.Color = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. "   [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            s.Color = Color3.fromRGB(80, 80, 80)
        end
        callback(toggleStates[id])
    end)
end

local function createColorButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(80, 80, 80)
    s.Thickness = 1
    s.Parent = btn

    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 100, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 128, 0)
    }
    local idx = 0

    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #colors then idx = 1 end
        callback(colors[idx])
        btn.Text = text .. "  (" .. idx .. "/" .. #colors .. ")"
    end)
end

local function createHighlight(adornee, color)
    local h = Instance.new("Highlight")
    h.Adornee = adornee
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = adornee
    return h
end

local function createNameTag(adornee, text, color, size)
    local bg = Instance.new("BillboardGui")
    bg.Adornee = adornee
    bg.Size = UDim2.new(0, size or 100, 0, 20)
    bg.StudsOffset = Vector3.new(0, 3.2, 0)
    bg.AlwaysOnTop = true
    bg.Parent = game.CoreGui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bg
    return bg, label
end

local function isKiller(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.MaxHealth > 500
end

local function isPallet(obj)
    local n = obj.Name:lower()
    return n:find("pallet") or n:find("паллет") or n:find("palka")
end

local function isGenerator(obj)
    local n = obj.Name:lower()
    return n:find("generator") or n:find("генератор")
end

local function updateKillerESP()
    if not ESP_KILLER then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and root and hum and hum.Health > 0 and isKiller(plr) then
            if not killerESP[plr] then
                local h = createHighlight(char, KILLER_COLOR)
                local bg, label = createNameTag(root, plr.Name, KILLER_COLOR, 110)
                killerESP[plr] = { h = h, bg = bg, label = label, char = char }
            else
                local e = killerESP[plr]
                if e.char ~= char then
                    e.bg.Adornee = root
                    e.h.Adornee = char
                    e.char = char
                end
                e.h.FillColor = KILLER_COLOR
                e.h.OutlineColor = KILLER_COLOR
                e.label.TextColor3 = KILLER_COLOR
            end
        else
            if killerESP[plr] then
                killerESP[plr].h:Destroy()
                killerESP[plr].bg:Destroy()
                killerESP[plr] = nil
            end
        end
    end
end

local function updatePalletESP()
    for obj, esp in pairs(palletESP) do
        if not obj.Parent then
            esp.h:Destroy()
            palletESP[obj] = nil
        end
    end
    if not ESP_PALLET then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isPallet(obj) and not palletESP[obj] then
            local h = createHighlight(obj, PALLET_COLOR)
            palletESP[obj] = { h = h }
        end
    end
end

local function updateGeneratorESP()
    for obj, esp in pairs(generatorESP) do
        if not obj.Parent then
            esp.h:Destroy()
            generatorESP[obj] = nil
        end
    end
    if not ESP_GENERATOR then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isGenerator(obj) and not generatorESP[obj] then
            local h = createHighlight(obj, GENERATOR_COLOR)
            generatorESP[obj] = { h = h }
        end
    end
end

local flyBV, flyBG
local function toggleFly(state)
    FLY_ENABLED = state
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if state then
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = root
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyBG.P = 1000
        flyBG.D = 50
        flyBG.Parent = root
    else
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
    end
end

RunService.RenderStepped:Connect(function()
    if FLY_ENABLED and flyBV and flyBG then
        local cam = Workspace.CurrentCamera
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        if move.Magnitude > 0 then move = move.Unit * 60 end
        flyBV.Velocity = move
        flyBG.CFrame = cam.CFrame
    end
    updateKillerESP()
end)

task.spawn(function()
    while task.wait(2) do
        updatePalletESP()
        updateGeneratorESP()
    end
end)

createToggle("killer", "ESP Убийцы", function(v) ESP_KILLER = v end)
createColorButton("Цвет Убийцы", function(c) KILLER_COLOR = c end)

createToggle("pallet", "ESP Палеток", function(v) ESP_PALLET = v end)
createColorButton("Цвет Палеток", function(c) PALLET_COLOR = c end)

createToggle("generator", "ESP Генераторов", function(v) ESP_GENERATOR = v end)
createColorButton("Цвет Генераторов", function(c) GENERATOR_COLOR = c end)

createToggle("fly", "Fly (WASD + Space/Ctrl)", function(v) toggleFly(v) end)

print("[Brutal Script] loaded")