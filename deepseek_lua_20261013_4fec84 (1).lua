local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ESP_KILLER = false
local ESP_PALLET = false
local ESP_GENERATOR = false

local KILLER_COLOR = Color3.fromRGB(255, 0, 0)
local PALLET_COLOR = Color3.fromRGB(255, 255, 255)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 255)

local killerESP = {}
local palletESP = {}
local generatorESP = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrutalScriptMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 540)
mainFrame.Position = UDim2.new(0, 30, 0.5, -270)
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
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
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
openBtn.Text = "+"
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
openBtn.Active = true
openBtn.Draggable = true

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
    openBtn.Text = "B"
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
    openBtn.Text = "+"
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 40)
tabBar.Position = UDim2.new(0, 10, 0, 55)
tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame
local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabBar

local espTab = Instance.new("TextButton")
espTab.Size = UDim2.new(0.45, 0, 0, 30)
espTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espTab.Text = "ESP"
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.Font = Enum.Font.GothamBold
espTab.TextSize = 14
espTab.Parent = tabBar
local espTabCorner = Instance.new("UICorner")
espTabCorner.CornerRadius = UDim.new(0, 8)
espTabCorner.Parent = espTab

local visualTab = Instance.new("TextButton")
visualTab.Size = UDim2.new(0.45, 0, 0, 30)
visualTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
visualTab.Text = "Visual"
visualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
visualTab.Font = Enum.Font.GothamBold
visualTab.TextSize = 14
visualTab.Parent = tabBar
local visualTabCorner = Instance.new("UICorner")
visualTabCorner.CornerRadius = UDim.new(0, 8)
visualTabCorner.Parent = visualTab

local espPage = Instance.new("ScrollingFrame")
espPage.Size = UDim2.new(1, -20, 1, -165)
espPage.Position = UDim2.new(0, 10, 0, 105)
espPage.BackgroundTransparency = 1
espPage.BorderSizePixel = 0
espPage.ScrollBarThickness = 5
espPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
espPage.CanvasSize = UDim2.new(0, 0, 0, 500)
espPage.Visible = true
espPage.Parent = mainFrame

local espLayout = Instance.new("UIListLayout")
espLayout.Padding = UDim.new(0, 8)
espLayout.SortOrder = Enum.SortOrder.LayoutOrder
espLayout.Parent = espPage

local visualPage = Instance.new("ScrollingFrame")
visualPage.Size = UDim2.new(1, -20, 1, -165)
visualPage.Position = UDim2.new(0, 10, 0, 105)
visualPage.BackgroundTransparency = 1
visualPage.BorderSizePixel = 0
visualPage.ScrollBarThickness = 5
visualPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
visualPage.CanvasSize = UDim2.new(0, 0, 0, 500)
visualPage.Visible = false
visualPage.Parent = mainFrame

local visualLayout = Instance.new("UIListLayout")
visualLayout.Padding = UDim.new(0, 8)
visualLayout.SortOrder = Enum.SortOrder.LayoutOrder
visualLayout.Parent = visualPage

espTab.MouseButton1Click:Connect(function()
    espPage.Visible = true
    visualPage.Visible = false
    espTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    visualTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

visualTab.MouseButton1Click:Connect(function()
    espPage.Visible = false
    visualPage.Visible = true
    espTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    visualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. "   [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(80, 80, 80)
    s.Thickness = 1
    s.Parent = btn

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. "   [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            s.Color = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. "   [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            s.Color = Color3.fromRGB(80, 80, 80)
        end
        callback(state)
    end)
end

local function createColorButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = parent
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

local function createDropdownSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.95, 0, 0, 40)
    container.Position = UDim2.new(0.025, 0, 0, 0)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BorderSizePixel = 0
    container.Parent = parent
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = container
    local cs = Instance.new("UIStroke")
    cs.Color = Color3.fromRGB(80, 80, 80)
    cs.Thickness = 1
    cs.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text .. "  ▼"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = container
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingLeft = UDim.new(0, 12)
    btnPadding.Parent = btn

    local expanded = false
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(0.95, 0, 0, 50)
    sliderContainer.Position = UDim2.new(0.025, 0, 0, 0)
    sliderContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Visible = false
    sliderContainer.Parent = parent
    local scCorner = Instance.new("UICorner")
    scCorner.CornerRadius = UDim.new(0, 10)
    scCorner.Parent = sliderContainer
    local scStroke = Instance.new("UIStroke")
    scStroke.Color = Color3.fromRGB(80, 80, 80)
    scStroke.Thickness = 1
    scStroke.Parent = sliderContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderContainer
    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(1, 0)
    sbCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false

    local function updateFromInput(input)
        local rel = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
        if rel < 0 then rel = 0 end
        if rel > 1 then rel = 1 end
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, -8)
        local value = math.floor(minVal + (maxVal - minVal) * rel)
        label.Text = text .. ": " .. value
        callback(value)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        sliderContainer.Visible = expanded
        if expanded then
            btn.Text = text .. "  ▲"
        else
            btn.Text = text .. "  ▼"
        end
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
    if hum.MaxHealth > 500 then return true end
    if plr.Team and plr.Team.Name:lower():find("killer") then return true end
    if plr:GetAttribute("Role") == "Killer" then return true end
    return false
end

local function isPallet(obj)
    if not obj:IsA("Model") and not obj:IsA("BasePart") then return false end
    local n = obj.Name:lower()
    if not (n:find("pallet") or n:find("palka") or n:find("паллет")) then return false end
    if obj:IsA("Model") and not obj.PrimaryPart then
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("BasePart") then return true end
        end
        return false
    end
    return true
end

local function isGenerator(obj)
    if not obj:IsA("Model") and not obj:IsA("BasePart") then return false end
    local n = obj.Name:lower()
    if not (n:find("generator") or n:find("generat") or n:find("генератор")) then return false end
    if obj:IsA("Model") and not obj.PrimaryPart then
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("BasePart") then return true end
        end
        return false
    end
    return true
end

local function clearKillerESP()
    for plr, esp in pairs(killerESP) do
        if esp.h then esp.h:Destroy() end
        if esp.bg then esp.bg:Destroy() end
        killerESP[plr] = nil
    end
end

local function clearPalletESP()
    for obj, esp in pairs(palletESP) do
        if esp.h then esp.h:Destroy() end
        palletESP[obj] = nil
    end
end

local function clearGeneratorESP()
    for obj, esp in pairs(generatorESP) do
        if esp.h then esp.h:Destroy() end
        generatorESP[obj] = nil
    end
end

local function updateKillerESP()
    if not ESP_KILLER then
        clearKillerESP()
        return
    end
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
    if not ESP_PALLET then
        clearPalletESP()
        return
    end
    for obj, esp in pairs(palletESP) do
        if not obj.Parent then
            esp.h:Destroy()
            palletESP[obj] = nil
        else
            esp.h.FillColor = PALLET_COLOR
            esp.h.OutlineColor = PALLET_COLOR
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isPallet(obj) and not palletESP[obj] then
            local h = createHighlight(obj, PALLET_COLOR)
            palletESP[obj] = { h = h }
        end
    end
end

local function updateGeneratorESP()
    if not ESP_GENERATOR then
        clearGeneratorESP()
        return
    end
    for obj, esp in pairs(generatorESP) do
        if not obj.Parent then
            esp.h:Destroy()
            generatorESP[obj] = nil
        else
            esp.h.FillColor = GENERATOR_COLOR
            esp.h.OutlineColor = GENERATOR_COLOR
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isGenerator(obj) and not generatorESP[obj] then
            local h = createHighlight(obj, GENERATOR_COLOR)
            generatorESP[obj] = { h = h }
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateKillerESP()
end)

task.spawn(function()
    while task.wait(2) do
        updatePalletESP()
        updateGeneratorESP()
    end
end)

createToggle(espPage, "ESP Убийцы", function(v) ESP_KILLER = v end)
createColorButton(espPage, "Цвет Убийцы", function(c) KILLER_COLOR = c end)

createToggle(espPage, "ESP Палеток", function(v) ESP_PALLET = v end)
createColorButton(espPage, "Цвет Палеток", function(c) PALLET_COLOR = c end)

createToggle(espPage, "ESP Генераторов", function(v) ESP_GENERATOR = v end)
createColorButton(espPage, "Цвет Генераторов", function(c) GENERATOR_COLOR = c end)

local defaultFOV = 70
Workspace.CurrentCamera.FieldOfView = defaultFOV

createDropdownSlider(visualPage, "FOV", 30, 120, defaultFOV, function(v)
    Workspace.CurrentCamera.FieldOfView = v
end)

print("[Brutal Script] loaded")
