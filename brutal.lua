local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local ESP_KILLER = false
local ESP_PALLET = false
local ESP_GENERATOR = false
local AUTO_PARRY = false
local PARRY_RADIUS = 15
local PARRY_KEY = Enum.KeyCode.Q
local PARRY_COOLDOWN = 1
local lastParry = 0

local ESP_DISTANCE = true
local SPEED_ENABLED = false
local SPEED_VALUE = 32
local JUMP_ENABLED = false
local JUMP_VALUE = 80
local NOCLIP_ENABLED = false
local FLY_ENABLED = false
local FLY_SPEED = 50
local INFINITE_JUMP = false

local KILLER_COLOR = Color3.fromRGB(255, 0, 0)
local PALLET_COLOR = Color3.fromRGB(255, 255, 255)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 255)

local killerESP = {}
local palletESP = {}
local generatorESP = {}

local connections = {}
local loops = {}

local currentFOV = 70
local fovLocked = true

local function track(conn)
    table.insert(connections, conn)
    return conn
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrutalScriptMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 560)
mainFrame.Position = UDim2.new(0, 30, 0.5, -280)
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
espTab.Size = UDim2.new(0.22, 0, 0, 30)
espTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espTab.Text = "ESP"
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.Font = Enum.Font.GothamBold
espTab.TextSize = 12
espTab.Parent = tabBar
local espTabCorner = Instance.new("UICorner")
espTabCorner.CornerRadius = UDim.new(0, 8)
espTabCorner.Parent = espTab

local visualTab = Instance.new("TextButton")
visualTab.Size = UDim2.new(0.22, 0, 0, 30)
visualTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
visualTab.Text = "Visual"
visualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
visualTab.Font = Enum.Font.GothamBold
visualTab.TextSize = 12
visualTab.Parent = tabBar
local visualTabCorner = Instance.new("UICorner")
visualTabCorner.CornerRadius = UDim.new(0, 8)
visualTabCorner.Parent = visualTab

local survivorTab = Instance.new("TextButton")
survivorTab.Size = UDim2.new(0.22, 0, 0, 30)
survivorTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
survivorTab.Text = "Survivor"
survivorTab.TextColor3 = Color3.fromRGB(255, 255, 255)
survivorTab.Font = Enum.Font.GothamBold
survivorTab.TextSize = 12
survivorTab.Parent = tabBar
local survivorTabCorner = Instance.new("UICorner")
survivorTabCorner.CornerRadius = UDim.new(0, 8)
survivorTabCorner.Parent = survivorTab

local movementTab = Instance.new("TextButton")
movementTab.Size = UDim2.new(0.22, 0, 0, 30)
movementTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
movementTab.Text = "Movement"
movementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
movementTab.Font = Enum.Font.GothamBold
movementTab.TextSize = 12
movementTab.Parent = tabBar
local movementTabCorner = Instance.new("UICorner")
movementTabCorner.CornerRadius = UDim.new(0, 8)
movementTabCorner.Parent = movementTab

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

local survivorPage = Instance.new("ScrollingFrame")
survivorPage.Size = UDim2.new(1, -20, 1, -165)
survivorPage.Position = UDim2.new(0, 10, 0, 105)
survivorPage.BackgroundTransparency = 1
survivorPage.BorderSizePixel = 0
survivorPage.ScrollBarThickness = 5
survivorPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
survivorPage.CanvasSize = UDim2.new(0, 0, 0, 500)
survivorPage.Visible = false
survivorPage.Parent = mainFrame

local survivorLayout = Instance.new("UIListLayout")
survivorLayout.Padding = UDim.new(0, 8)
survivorLayout.SortOrder = Enum.SortOrder.LayoutOrder
survivorLayout.Parent = survivorPage

local movementPage = Instance.new("ScrollingFrame")
movementPage.Size = UDim2.new(1, -20, 1, -165)
movementPage.Position = UDim2.new(0, 10, 0, 105)
movementPage.BackgroundTransparency = 1
movementPage.BorderSizePixel = 0
movementPage.ScrollBarThickness = 5
movementPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
movementPage.CanvasSize = UDim2.new(0, 0, 0, 500)
movementPage.Visible = false
movementPage.Parent = mainFrame

local movementLayout = Instance.new("UIListLayout")
movementLayout.Padding = UDim.new(0, 8)
movementLayout.SortOrder = Enum.SortOrder.LayoutOrder
movementLayout.Parent = movementPage

local function switchTab(tabName)
    espPage.Visible = (tabName == "esp")
    visualPage.Visible = (tabName == "visual")
    survivorPage.Visible = (tabName == "survivor")
    movementPage.Visible = (tabName == "movement")
    espTab.BackgroundColor3 = (tabName == "esp") and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    visualTab.BackgroundColor3 = (tabName == "visual") and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    survivorTab.BackgroundColor3 = (tabName == "survivor") and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    movementTab.BackgroundColor3 = (tabName == "movement") and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
end

espTab.MouseButton1Click:Connect(function() switchTab("esp") end)
visualTab.MouseButton1Click:Connect(function() switchTab("visual") end)
survivorTab.MouseButton1Click:Connect(function() switchTab("survivor") end)
movementTab.MouseButton1Click:Connect(function() switchTab("movement") end)

local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text .. "   [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
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
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            s.Color = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. "   [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            s.Color = Color3.fromRGB(80, 80, 80)
        end
        callback(state)
    end)
end

local function createColorButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
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

local function createExpandableESP(parent, titleText, toggleText, onToggle, colorText, onColor)
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
    btn.Text = titleText .. "  ▼"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = container
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingLeft = UDim.new(0, 12)
    btnPadding.Parent = btn

    local expanded = false
    local content = Instance.new("Frame")
    content.Size = UDim2.new(0.95, 0, 0, 80)
    content.Position = UDim2.new(0.025, 0, 0, 0)
    content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    content.BorderSizePixel = 0
    content.Visible = false
    content.Parent = parent
    local conCorner = Instance.new("UICorner")
    conCorner.CornerRadius = UDim.new(0, 10)
    conCorner.Parent = content
    local conStroke = Instance.new("UIStroke")
    conStroke.Color = Color3.fromRGB(80, 80, 80)
    conStroke.Thickness = 1
    conStroke.Parent = content

    local conLayout = Instance.new("UIListLayout")
    conLayout.Padding = UDim.new(0, 6)
    conLayout.SortOrder = Enum.SortOrder.LayoutOrder
    conLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    conLayout.Parent = content
    local conPadding = Instance.new("UIPadding")
    conPadding.PaddingTop = UDim.new(0, 6)
    conPadding.PaddingBottom = UDim.new(0, 6)
    conPadding.Parent = content

    createToggle(content, toggleText, onToggle)
    createColorButton(content, colorText, onColor)

    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        content.Visible = expanded
        if expanded then
            btn.Text = titleText .. "  ▲"
        else
            btn.Text = titleText .. "  ▼"
        end
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

    track(sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end))
    track(sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end))

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

local function createSectionLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.95, 0, 0, 24)
    label.Position = UDim2.new(0.025, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 34)
    btn.Position = UDim2.new(0.025, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(80, 80, 80)
    s.Thickness = 1
    s.Parent = btn

    btn.MouseButton1Click:Connect(callback)
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

local function getDistance(root)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if myRoot and root then
        return math.floor((myRoot.Position - root.Position).Magnitude)
    end
    return nil
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
            local distText = ESP_DISTANCE and (" [" .. (getDistance(root) or "?") .. "m]") or ""
            if not killerESP[plr] then
                local h = createHighlight(char, KILLER_COLOR)
                local bg, label = createNameTag(root, plr.Name .. distText, KILLER_COLOR, 110)
                killerESP[plr] = { h = h, bg = bg, label = label, char = char, root = root }
            else
                local e = killerESP[plr]
                if e.char ~= char then
                    e.bg.Adornee = root
                    e.h.Adornee = char
                    e.char = char
                    e.root = root
                end
                e.h.FillColor = KILLER_COLOR
                e.h.OutlineColor = KILLER_COLOR
                e.label.TextColor3 = KILLER_COLOR
                e.label.Text = plr.Name .. distText
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

local function getKillerAttacking()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local isKillerRole = hum.MaxHealth > 500
            or (plr.Team and plr.Team.Name:lower():find("killer"))
            or plr:GetAttribute("Role") == "Killer"

        if not isKillerRole then continue end

        local myRoot = LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local killerRoot = char:FindFirstChild("HumanoidRootPart")

        if myRoot and killerRoot then
            local dist = (myRoot.Position - killerRoot.Position).Magnitude
            if dist <= PARRY_RADIUS then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Attacking
                    or state == Enum.HumanoidStateType.Lunge
                    or state == Enum.HumanoidStateType.Physics then
                    return true
                end
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                    local animName = track.Animation.Name:lower()
                    if animName:find("attack")
                        or animName:find("swing")
                        or animName:find("lunge") then
                        return true
                    end
                end
            end
        end
    end
    return false
end

track(RunService.RenderStepped:Connect(function()
    updateKillerESP()
    if fovLocked then
        local cam = Workspace.CurrentCamera
        if cam and cam.FieldOfView ~= currentFOV then
            cam.FieldOfView = currentFOV
        end
    end
end))

table.insert(loops, task.spawn(function()
    while task.wait(2) do
        updatePalletESP()
        updateGeneratorESP()
    end
end))

table.insert(loops, task.spawn(function()
    while task.wait(0.05) do
        if not AUTO_PARRY then continue end
        if tick() - lastParry < PARRY_COOLDOWN then continue end

        if getKillerAttacking() then
            lastParry = tick()
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, PARRY_KEY, false, game)
                task.wait(0.03)
                VirtualInputManager:SendKeyEvent(false, PARRY_KEY, false, game)
            end)
        end
    end
end))

table.insert(loops, task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if SPEED_ENABLED then
                hum.WalkSpeed = SPEED_VALUE
            else
                hum.WalkSpeed = 16
            end
            if JUMP_ENABLED then
                hum.UseJumpPower = true
                hum.JumpPower = JUMP_VALUE
            end
        end
    end
end))

track(RunService.Stepped:Connect(function()
    if not NOCLIP_ENABLED then return end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end))

local flyBodyVelocity
local flyBodyGyro

local function startFly()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 1000
    flyBodyGyro.D = 50
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
end

local function stopFly()
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
end

local function updateFly()
    if not FLY_ENABLED then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not flyBodyVelocity or not flyBodyGyro then return end
    local cam = Workspace.CurrentCamera
    local moveDir = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
    if moveDir.Magnitude > 0 then
        flyBodyVelocity.Velocity = moveDir.Unit * FLY_SPEED
    else
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    flyBodyGyro.CFrame = cam.CFrame
end

track(RunService.RenderStepped:Connect(updateFly))

table.insert(loops, task.spawn(function()
    while task.wait(0.1) do
        if FLY_ENABLED then
            if not flyBodyVelocity then startFly() end
        else
            if flyBodyVelocity then stopFly() end
        end
    end
end))

table.insert(loops, task.spawn(function()
    while task.wait(0.1) do
        if INFINITE_JUMP then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end))

createExpandableESP(espPage, "ESP Убийцы", "Включить", function(v) ESP_KILLER = v end, "Цвет", function(c) KILLER_COLOR = c end)
createExpandableESP(espPage, "ESP Палеток", "Включить", function(v) ESP_PALLET = v end, "Цвет", function(c) PALLET_COLOR = c end)
createExpandableESP(espPage, "ESP Генераторов", "Включить", function(v) ESP_GENERATOR = v end, "Цвет", function(c) GENERATOR_COLOR = c end)

createSectionLabel(espPage, "ДОПОЛНИТЕЛЬНО")
createToggle(espPage, "Показывать дистанцию", function(v) ESP_DISTANCE = v end)

createSectionLabel(visualPage, "НАСТРОЙКИ FOV")
createDropdownSlider(visualPage, "FOV", 30, 120, 70, function(v)
    currentFOV = v
    Workspace.CurrentCamera.FieldOfView = v
end)
createToggle(visualPage, "Зафиксировать FOV", function(v)
    fovLocked = v
end)

createSectionLabel(survivorPage, "AUTO PARRY")
createToggle(survivorPage, "Auto Parry", function(v) AUTO_PARRY = v end)
createDropdownSlider(survivorPage, "Радиус Parry", 5, 30, PARRY_RADIUS, function(v)
    PARRY_RADIUS = v
end)

createSectionLabel(movementPage, "СКОРОСТЬ")
createToggle(movementPage, "Ускорение", function(v) SPEED_ENABLED = v end)
createDropdownSlider(movementPage, "WalkSpeed", 16, 100, 32, function(v)
    SPEED_VALUE = v
end)

createSectionLabel(movementPage, "ПРЫЖОК")
createToggle(movementPage, "Увеличенный прыжок", function(v) JUMP_ENABLED = v end)
createDropdownSlider(movementPage, "JumpPower", 50, 200, 80, function(v)
    JUMP_VALUE = v
end)
createToggle(movementPage, "Бесконечный прыжок", function(v) INFINITE_JUMP = v end)

createSectionLabel(movementPage, "NOCLIP")
createToggle(movementPage, "Noclip", function(v) NOCLIP_ENABLED = v end)

createSectionLabel(movementPage, "FLY")
createToggle(movementPage, "Fly", function(v) FLY_ENABLED = v end)
createDropdownSlider(movementPage, "Скорость полёта", 20, 200, 50, function(v)
    FLY_SPEED = v
end)

closeBtn.MouseButton1Click:Connect(function()
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, thread in ipairs(loops) do
        pcall(function() task.cancel(thread) end)
    end
    clearKillerESP()
    clearPalletESP()
    clearGeneratorESP()
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    Workspace.CurrentCamera.FieldOfView = 70
    screenGui:Destroy()
    print("[Brutal Script] unloaded")
end)

print("[Brutal Script] loaded")
