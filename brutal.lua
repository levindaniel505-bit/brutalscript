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
local PARRY_COOLDOWN = 0.3
local lastParry = 0

local ESP_DISTANCE = true
local SPEED_ENABLED = false
local SPEED_VALUE = 32
local JUMP_ENABLED = false
local JUMP_VALUE = 80
local NOCLIP_ENABLED = false
local FLY_ENABLED = false
local FLY_SPEED = 50

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
local menuMinimized = false
local bindingMode = nil

local BIND_FILE = "brutal_binds.json"

local BINDS = {
    toggleMenu = Enum.KeyCode.Insert,
    espKiller = Enum.KeyCode.F1,
    espPallet = Enum.KeyCode.F2,
    espGenerator = Enum.KeyCode.F3,
    autoParry = Enum.KeyCode.F4,
    fly = Enum.KeyCode.F5,
    noclip = Enum.KeyCode.F6,
    speed = Enum.KeyCode.F7,
}

local bindLabels = {}

local function getKeyName(key)
    if not key then return "None" end
    return key.Name
end

local function saveBinds()
    if not writefile then return end
    local data = {}
    for k, v in pairs(BINDS) do
        data[k] = v.Name
    end
    pcall(function()
        writefile(BIND_FILE, game:GetService("HttpService"):JSONEncode(data))
    end)
end

local function loadBinds()
    if not (readfile and isfile) then return end
    if not isfile(BIND_FILE) then return end
    pcall(function()
        local data = game:GetService("HttpService"):JSONDecode(readfile(BIND_FILE))
        for k, v in pairs(data) do
            if BINDS[k] then
                local key = Enum.KeyCode[v]
                if key then BINDS[k] = key end
            end
        end
    end)
end

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

_G.mainFrame = mainFrame

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

local tabNames = {"ESP", "Visual", "Survivor", "Movement", "Binds"}
local tabButtons = {}

for i, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.18, 0, 0, 30)
    tab.BackgroundColor3 = (i == 1) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 11
    tab.Parent = tabBar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = tab
    tabButtons[name] = tab
end

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -165)
    page.Position = UDim2.new(0, 10, 0, 105)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 5
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.Visible = false
    page.Parent = mainFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    return page
end

local espPage = createPage()
espPage.Visible = true
local visualPage = createPage()
local survivorPage = createPage()
local movementPage = createPage()
local bindsPage = createPage()

local function switchTab(name)
    espPage.Visible = (name == "ESP")
    visualPage.Visible = (name == "Visual")
    survivorPage.Visible = (name == "Survivor")
    movementPage.Visible = (name == "Movement")
    bindsPage.Visible = (name == "Binds")
    for n, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (n == name) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

local function updateBindLabel(id, state)
    local lbl = bindLabels[id]
    if not lbl then return end
    local status = state and " [ON]" or " [OFF]"
    lbl.Text = id .. ": " .. getKeyName(BINDS[id]) .. status
end

local bindActions = {
    toggleMenu = function()
        if _G.mainFrame then
            _G.mainFrame.Visible = not _G.mainFrame.Visible
        end
    end,
    espKiller = function()
        ESP_KILLER = not ESP_KILLER
        updateBindLabel("espKiller", ESP_KILLER)
    end,
    espPallet = function()
        ESP_PALLET = not ESP_PALLET
        updateBindLabel("espPallet", ESP_PALLET)
    end,
    espGenerator = function()
        ESP_GENERATOR = not ESP_GENERATOR
        updateBindLabel("espGenerator", ESP_GENERATOR)
    end,
    autoParry = function()
        AUTO_PARRY = not AUTO_PARRY
        updateBindLabel("autoParry", AUTO_PARRY)
    end,
    fly = function()
        FLY_ENABLED = not FLY_ENABLED
        updateBindLabel("fly", FLY_ENABLED)
    end,
    noclip = function()
        NOCLIP_ENABLED = not NOCLIP_ENABLED
        updateBindLabel("noclip", NOCLIP_ENABLED)
    end,
    speed = function()
        SPEED_ENABLED = not SPEED_ENABLED
        updateBindLabel("speed", SPEED_ENABLED)
    end,
}

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
    return btn
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

local function createSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.Position = UDim2.new(0, 0, 0, 0)
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
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

    return container, label, sliderBg, fill, knob
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

local function createBindButton(parent, id, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text .. ": " .. getKeyName(BINDS[id])
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

    bindLabels[id] = btn

    btn.MouseButton1Click:Connect(function()
        bindingMode = id
        btn.Text = text .. ": НАЖМИ КЛАВИШУ..."
        btn.BackgroundColor3 = Color3.fromRGB(80, 60, 20)
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
        if not isKiller(plr) then continue end

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
                for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                    local animName = t.Animation.Name:lower()
                    if animName:find("attack") or animName:find("swing") or animName:find("lunge") then
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
    while task.wait(0.1) do
        if AUTO_PARRY then
            if getKillerAttacking() then
                local now = tick()
                if now - lastParry >= PARRY_COOLDOWN then
                    lastParry = now
                    VirtualInputManager:SendKeyEvent(true, PARRY_KEY, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, PARRY_KEY, false, game)
                end
            end
        end
    end
end))

local flyVelocity = nil

track(RunService.Stepped:Connect(function(_, dt)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if hum then
        if SPEED_ENABLED then
            hum.WalkSpeed = SPEED_VALUE
        else
            hum.WalkSpeed = 16
        end

        if JUMP_ENABLED then
            hum.JumpPower = JUMP_VALUE
        else
            hum.JumpPower = 50
        end
    end

    if NOCLIP_ENABLED and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    if FLY_ENABLED and root then
        if not flyVelocity or not flyVelocity.Parent then
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyVelocity.P = 1e4
            flyVelocity.Parent = root
        end

        local moveDir = Vector3.new(0, 0, 0)
        local cam = Workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            flyVelocity.Velocity = moveDir.Unit * FLY_SPEED
        else
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    else
        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end
    end
end))

track(UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if bindingMode then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            BINDS[bindingMode] = input.KeyCode
            local btn = bindLabels[bindingMode]
            if btn then
                btn.Text = bindingMode .. ": " .. getKeyName(input.KeyCode)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            bindingMode = nil
            saveBinds()
        end
        return
    end
    for id, key in pairs(BINDS) do
        if input.KeyCode == key then
            local action = bindActions[id]
            if action then action() end
        end
    end
end))

minimizeBtn.MouseButton1Click:Connect(function()
    menuMinimized = not menuMinimized
    tabBar.Visible = not menuMinimized
    for _, page in ipairs({espPage, visualPage, survivorPage, movementPage, bindsPage}) do
        page.Visible = not menuMinimized and page.Visible
    end
    if menuMinimized then
        mainFrame.Size = UDim2.new(0, 380, 0, 50)
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 380, 0, 560)
        minimizeBtn.Text = "—"
        switchTab("ESP")
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
end)

createToggle(espPage, "ESP Killers", function(state)
    ESP_KILLER = state
    updateBindLabel("espKiller", state)
end)
createToggle(espPage, "ESP Pallets", function(state)
    ESP_PALLET = state
    updateBindLabel("espPallet", state)
end)
createToggle(espPage, "ESP Generators", function(state)
    ESP_GENERATOR = state
    updateBindLabel("espGenerator", state)
end)
createToggle(espPage, "Show Distance", function(state)
    ESP_DISTANCE = state
end)

createToggle(survivorPage, "Auto Parry", function(state)
    AUTO_PARRY = state
    updateBindLabel("autoParry", state)
end)
createSlider(survivorPage, "Parry Radius", 5, 30, PARRY_RADIUS, function(val)
    PARRY_RADIUS = val
end)

createToggle(movementPage, "Speed", function(state)
    SPEED_ENABLED = state
    updateBindLabel("speed", state)
end)
createToggle(movementPage, "Speed Off/On", function(state)
    SPEED_ENABLED = state
    updateBindLabel("speed", state)
end)
createSlider(movementPage, "Speed Value", 16, 200, SPEED_VALUE, function(val)
    SPEED_VALUE = val
end)

createToggle(movementPage, "Jump", function(state)
    JUMP_ENABLED = state
end)
createToggle(movementPage, "Jump Off/On", function(state)
    JUMP_ENABLED = state
end)
createSlider(movementPage, "Jump Value", 50, 300, JUMP_VALUE, function(val)
    JUMP_VALUE = val
end)

createToggle(movementPage, "Noclip", function(state)
    NOCLIP_ENABLED = state
    updateBindLabel("noclip", state)
end)
createToggle(movementPage, "Fly", function(state)
    FLY_ENABLED = state
    updateBindLabel("fly", state)
end)
createSlider(movementPage, "Fly Speed", 10, 200, FLY_SPEED, function(val)
    FLY_SPEED = val
end)

createSectionLabel(bindsPage, "Keybinds (click to rebind)")
createBindButton(bindsPage, "toggleMenu", "Toggle Menu")
createBindButton(bindsPage, "espKiller", "ESP Killers")
createBindButton(bindsPage, "espPallet", "ESP Pallets")
createBindButton(bindsPage, "espGenerator", "ESP Generators")
createBindButton(bindsPage, "autoParry", "Auto Parry")
createBindButton(bindsPage, "fly", "Fly")
createBindButton(bindsPage, "noclip", "Noclip")
createBindButton(bindsPage, "speed", "Speed")

loadBinds()
for id, _ in pairs(BINDS) do
    updateBindLabel(id, false)
end

print("[BRUTAL SCRIPT] Loaded successfully.")
