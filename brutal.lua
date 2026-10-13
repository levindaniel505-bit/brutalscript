local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local CONFIG_DIR = "brutal_configs"
local CURRENT_CONFIG_NAME = "default"

local ESP_KILLER = false
local ESP_PALLET = false
local ESP_GENERATOR = false
local ESP_DISTANCE = true
local AUTO_PARRY = false
local PARRY_RADIUS = 15
local PARRY_KEY = Enum.KeyCode.Q
local PARRY_REACTION_MS = 30
local PARRY_WINDOW_START = 0.1
local PARRY_WINDOW_END = 0.4
local PARRY_PRIORITY = "nearest"
local PARRY_COOLDOWN = 0.4
local lastParry = 0

local SPEED_ENABLED = false
local SPEED_VALUE = 16
local JUMP_ENABLED = false
local JUMP_VALUE = 80
local NOCLIP_ENABLED = false
local FLY_ENABLED = false
local FLY_SPEED = 50
local MOONWALK_ENABLED = false
local MOONWALK_SPEED = 16
local MOONWALK_SIDE_INTERVAL = 1
local MOONWALK_TURN_SPEED = 6
local MOONWALK_ANGLE_STEP = 30
local moonwalkLastSide = 0
local moonwalkSide = 1
local moonwalkTargetAngle = 0
local moonwalkCurrentAngle = 0
local moonwalkGyro = nil
local moonwalkVel = nil

local FOV_ENABLED = false
local FOV_VALUE = 70

local KILLER_COLOR = Color3.fromRGB(255, 0, 0)
local PALLET_COLOR = Color3.fromRGB(255, 255, 255)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 255)

local killerESP = {}
local palletESP = {}
local generatorESP = {}
local palletCache = {}
local generatorCache = {}
local lastPalletScan = 0
local lastGeneratorScan = 0
local SCAN_INTERVAL = 5

local connections = {}
local loops = {}
local bindingMode = nil
local menuMinimized = false
local flyVelocity = nil

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
    moonwalk = Enum.KeyCode.F8,
}

local bindLabels = {}

local BTN_NEUTRAL = Color3.fromRGB(35, 35, 35)
local BTN_HOVER = Color3.fromRGB(55, 55, 55)
local BTN_ACTIVE = Color3.fromRGB(70, 70, 70)
local BTN_ACCENT = Color3.fromRGB(180, 180, 180)
local BTN_DANGER = Color3.fromRGB(140, 40, 40)
local BTN_SUCCESS = Color3.fromRGB(40, 130, 60)
local BTN_INFO = Color3.fromRGB(40, 80, 140)

local ATTACK_ANIM_KEYWORDS = {"attack", "swing", "slash", "lunge", "hit", "punch", "strike", "kick", "stab", "sword"}

local function ensureConfigDir()
    if not (isfolder and makefolder) then return end
    if not isfolder(CONFIG_DIR) then
        pcall(function() makefolder(CONFIG_DIR) end)
    end
end

local function getConfigPath(name)
    return CONFIG_DIR .. "/" .. name .. ".json"
end

local function listConfigs()
    local list = {}
    if not (listfiles and isfolder) then
        return {CURRENT_CONFIG_NAME}
    end
    ensureConfigDir()
    if isfolder(CONFIG_DIR) then
        local ok, files = pcall(function() return listfiles(CONFIG_DIR) end)
        if ok and files then
            for _, f in ipairs(files) do
                local name = f:match("([^/\\]+)%.json$")
                if name then table.insert(list, name) end
            end
        end
    end
    if #list == 0 then table.insert(list, "default") end
    return list
end

local function saveConfig()
    ensureConfigDir()
    local data = {
        espKiller = ESP_KILLER,
        espPallet = ESP_PALLET,
        espGenerator = ESP_GENERATOR,
        espDistance = ESP_DISTANCE,
        autoParry = AUTO_PARRY,
        parryRadius = PARRY_RADIUS,
        parryReactionMs = PARRY_REACTION_MS,
        parryWindowStart = PARRY_WINDOW_START,
        parryWindowEnd = PARRY_WINDOW_END,
        parryPriority = PARRY_PRIORITY,
        fly = FLY_ENABLED,
        flySpeed = FLY_SPEED,
        noclip = NOCLIP_ENABLED,
        speed = SPEED_ENABLED,
        speedValue = SPEED_VALUE,
        jump = JUMP_ENABLED,
        jumpValue = JUMP_VALUE,
        moonwalk = MOONWALK_ENABLED,
        moonwalkSpeed = MOONWALK_SPEED,
        moonwalkSideInterval = MOONWALK_SIDE_INTERVAL,
        moonwalkTurnSpeed = MOONWALK_TURN_SPEED,
        fovEnabled = FOV_ENABLED,
        fovValue = FOV_VALUE,
    }
    local json = game:GetService("HttpService"):JSONEncode(data)
    if writefile then
        pcall(function() writefile(getConfigPath(CURRENT_CONFIG_NAME), json) end)
    end
end

local function applyConfigData(data)
    if not data then return end
    ESP_KILLER = data.espKiller or ESP_KILLER
    ESP_PALLET = data.espPallet or ESP_PALLET
    ESP_GENERATOR = data.espGenerator or ESP_GENERATOR
    ESP_DISTANCE = data.espDistance ~= nil and data.espDistance or ESP_DISTANCE
    AUTO_PARRY = data.autoParry or AUTO_PARRY
    PARRY_RADIUS = data.parryRadius or PARRY_RADIUS
    PARRY_REACTION_MS = data.parryReactionMs or PARRY_REACTION_MS
    PARRY_WINDOW_START = data.parryWindowStart or PARRY_WINDOW_START
    PARRY_WINDOW_END = data.parryWindowEnd or PARRY_WINDOW_END
    PARRY_PRIORITY = data.parryPriority or PARRY_PRIORITY
    FLY_ENABLED = data.fly or FLY_ENABLED
    FLY_SPEED = data.flySpeed or FLY_SPEED
    NOCLIP_ENABLED = data.noclip or NOCLIP_ENABLED
    SPEED_ENABLED = data.speed or SPEED_ENABLED
    SPEED_VALUE = data.speedValue or SPEED_VALUE
    JUMP_ENABLED = data.jump or JUMP_ENABLED
    JUMP_VALUE = data.jumpValue or JUMP_VALUE
    MOONWALK_ENABLED = data.moonwalk or MOONWALK_ENABLED
    MOONWALK_SPEED = data.moonwalkSpeed or MOONWALK_SPEED
    MOONWALK_SIDE_INTERVAL = data.moonwalkSideInterval or MOONWALK_SIDE_INTERVAL
    MOONWALK_TURN_SPEED = data.moonwalkTurnSpeed or MOONWALK_TURN_SPEED
    FOV_ENABLED = data.fovEnabled or FOV_ENABLED
    FOV_VALUE = data.fovValue or FOV_VALUE
end

local function loadConfigByName(name)
    if not (readfile and isfile) then return end
    local path = getConfigPath(name)
    if not isfile(path) then return end
    local ok, json = pcall(function() return readfile(path) end)
    if not ok or not json then return end
    local ok2, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(json)
    end)
    if ok2 and data then
        applyConfigData(data)
        CURRENT_CONFIG_NAME = name
    end
end

local function resetConfig()
    ESP_KILLER = false
    ESP_PALLET = false
    ESP_GENERATOR = false
    ESP_DISTANCE = true
    AUTO_PARRY = false
    PARRY_RADIUS = 15
    PARRY_REACTION_MS = 30
    PARRY_WINDOW_START = 0.1
    PARRY_WINDOW_END = 0.4
    PARRY_PRIORITY = "nearest"
    FLY_ENABLED = false
    FLY_SPEED = 50
    NOCLIP_ENABLED = false
    SPEED_ENABLED = false
    SPEED_VALUE = 16
    JUMP_ENABLED = false
    JUMP_VALUE = 80
    MOONWALK_ENABLED = false
    MOONWALK_SPEED = 16
    MOONWALK_SIDE_INTERVAL = 1
    MOONWALK_TURN_SPEED = 6
    FOV_ENABLED = false
    FOV_VALUE = 70
    saveConfig()
end

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

local function playLoadSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9114221325"
    sound.Volume = 0.5
    sound.PlaybackSpeed = 1.1
    sound.Parent = SoundService
    sound:Play()
    task.delay(3, function()
        if sound then sound:Destroy() end
    end)
end

local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://7242840436"
    sound.Volume = 0.3
    sound.Parent = SoundService
    sound:Play()
    task.delay(1, function()
        if sound then sound:Destroy() end
    end)
end

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "BrutalLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.Parent = game.CoreGui

local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 400, 0, 125)
loadFrame.Position = UDim2.new(0.5, -200, 0.5, -62)
loadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadFrame.BorderSizePixel = 0
loadFrame.Parent = loadingGui

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 14)
loadCorner.Parent = loadFrame

local loadStroke = Instance.new("UIStroke")
loadStroke.Color = Color3.fromRGB(255, 255, 255)
loadStroke.Thickness = 1.5
loadStroke.Parent = loadFrame

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, -20, 0, 30)
loadTitle.Position = UDim2.new(0, 10, 0, 8)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "BRUTAL SCRIPT"
loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.TextSize = 22
loadTitle.TextXAlignment = Enum.TextXAlignment.Left
loadTitle.Parent = loadFrame

local loadVersion = Instance.new("TextLabel")
loadVersion.Size = UDim2.new(1, -20, 0, 14)
loadVersion.Position = UDim2.new(0, 10, 0, 36)
loadVersion.BackgroundTransparency = 1
loadVersion.Text = "v1.0"
loadVersion.TextColor3 = Color3.fromRGB(120, 120, 120)
loadVersion.Font = Enum.Font.Gotham
loadVersion.TextSize = 11
loadVersion.TextXAlignment = Enum.TextXAlignment.Left
loadVersion.Parent = loadFrame

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0.9, 0, 0, 12)
loadBarBg.Position = UDim2.new(0.05, 0, 0, 62)
loadBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadBarBg.BorderSizePixel = 0
loadBarBg.Parent = loadFrame
local loadBarCorner = Instance.new("UICorner")
loadBarCorner.CornerRadius = UDim.new(1, 0)
loadBarCorner.Parent = loadBarBg

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadBarFill.BorderSizePixel = 0
loadBarFill.Parent = loadBarBg
local loadFillCorner = Instance.new("UICorner")
loadFillCorner.CornerRadius = UDim.new(1, 0)
loadFillCorner.Parent = loadBarFill

local loadPercent = Instance.new("TextLabel")
loadPercent.Size = UDim2.new(1, -20, 0, 20)
loadPercent.Position = UDim2.new(0, 10, 0, 82)
loadPercent.BackgroundTransparency = 1
loadPercent.Text = "0%"
loadPercent.TextColor3 = Color3.fromRGB(200, 200, 200)
loadPercent.Font = Enum.Font.GothamBold
loadPercent.TextSize = 14
loadPercent.Parent = loadFrame

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrutalScriptMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui
screenGui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0, 30, 0.5, -30)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.ClipsDescendants = true
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
minimizeBtn.BackgroundColor3 = BTN_NEUTRAL
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
closeBtn.BackgroundColor3 = BTN_DANGER
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
tabLayout.Padding = UDim.new(0, 4)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabBar

local tabNames = {"ESP", "Visual", "Survivor", "Movement", "Config", "Binds"}
local tabButtons = {}

for i, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.155, 0, 0, 30)
    tab.BackgroundColor3 = (i == 1) and BTN_ACTIVE or BTN_NEUTRAL
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 10
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
    page.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
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
local configPage = createPage()
local bindsPage = createPage()

local function switchTab(name)
    espPage.Visible = (name == "ESP")
    visualPage.Visible = (name == "Visual")
    survivorPage.Visible = (name == "Survivor")
    movementPage.Visible = (name == "Movement")
    configPage.Visible = (name == "Config")
    bindsPage.Visible = (name == "Binds")
    for n, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (n == name) and BTN_ACTIVE or BTN_NEUTRAL
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        playClickSound()
        switchTab(name)
    end)
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
        saveConfig()
    end,
    espPallet = function()
        ESP_PALLET = not ESP_PALLET
        updateBindLabel("espPallet", ESP_PALLET)
        saveConfig()
    end,
    espGenerator = function()
        ESP_GENERATOR = not ESP_GENERATOR
        updateBindLabel("espGenerator", ESP_GENERATOR)
        saveConfig()
    end,
    autoParry = function()
        AUTO_PARRY = not AUTO_PARRY
        updateBindLabel("autoParry", AUTO_PARRY)
        saveConfig()
    end,
    fly = function()
        FLY_ENABLED = not FLY_ENABLED
        updateBindLabel("fly", FLY_ENABLED)
        saveConfig()
    end,
    noclip = function()
        NOCLIP_ENABLED = not NOCLIP_ENABLED
        updateBindLabel("noclip", NOCLIP_ENABLED)
        saveConfig()
    end,
    speed = function()
        SPEED_ENABLED = not SPEED_ENABLED
        updateBindLabel("speed", SPEED_ENABLED)
        saveConfig()
    end,
    moonwalk = function()
        MOONWALK_ENABLED = not MOONWALK_ENABLED
        updateBindLabel("moonwalk", MOONWALK_ENABLED)
        saveConfig()
    end,
}

local function createStateButton(parent, text, getState, setState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = getState() and BTN_ACTIVE or BTN_NEUTRAL
    btn.Text = text .. "   [" .. (getState() and "ON" or "OFF") .. "]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = getState() and BTN_ACCENT or Color3.fromRGB(60, 60, 60)
    s.Thickness = 1
    s.Parent = btn

    local function refresh()
        local state = getState()
        btn.Text = text .. "   [" .. (state and "ON" or "OFF") .. "]"
        if state then
            btn.BackgroundColor3 = BTN_ACTIVE
            s.Color = BTN_ACCENT
        else
            btn.BackgroundColor3 = BTN_NEUTRAL
            s.Color = Color3.fromRGB(60, 60, 60)
        end
    end

    btn.MouseButton1Click:Connect(function()
        playClickSound()
        setState(not getState())
        refresh()
    end)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = BTN_HOVER
    end)
    btn.MouseLeave:Connect(function()
        refresh()
    end)

    refresh()
    return btn, refresh
end

local function createCollapsible(parent, titleText, buildContent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.Position = UDim2.new(0, 0, 0, 0)
    container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    container.BorderSizePixel = 0
    container.Parent = parent
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = container
    local cs = Instance.new("UIStroke")
    cs.Color = Color3.fromRGB(70, 70, 70)
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
    content.Size = UDim2.new(1, 0, 0, 80)
    content.Position = UDim2.new(0, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = false
    content.Parent = parent
    local conLayout = Instance.new("UIListLayout")
    conLayout.Padding = UDim.new(0, 6)
    conLayout.SortOrder = Enum.SortOrder.LayoutOrder
    conLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    conLayout.Parent = content

    buildContent(content)

    btn.MouseButton1Click:Connect(function()
        playClickSound()
        expanded = not expanded
        content.Visible = expanded
        if expanded then
            btn.Text = titleText .. "  ▲"
        else
            btn.Text = titleText .. "  ▼"
        end
    end)

    btn.MouseEnter:Connect(function()
        container.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    end)
    btn.MouseLeave:Connect(function()
        container.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    end)

    return container, content, btn
end

local function createSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.Position = UDim2.new(0.05, 0, 0, 0)
    container.BackgroundColor3 = BTN_NEUTRAL
    container.BorderSizePixel = 0
    container.Parent = parent
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = container
    local cs = Instance.new("UIStroke")
    cs.Color = Color3.fromRGB(70, 70, 70)
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
    sliderBg.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(1, 0)
    sbCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = BTN_ACCENT
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
    label.Size = UDim2.new(0.9, 0, 0, 24)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(160, 160, 160)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
end

local function createDropdown(parent, text, options, defaultOption, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 36)
    container.Position = UDim2.new(0.05, 0, 0, 0)
    container.BackgroundColor3 = BTN_NEUTRAL
    container.BorderSizePixel = 0
    container.Parent = parent
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = container
    local cs = Instance.new("UIStroke")
    cs.Color = Color3.fromRGB(70, 70, 70)
    cs.Thickness = 1
    cs.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text .. ": " .. defaultOption .. "  ▼"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = container

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, #options * 30)
    list.Position = UDim2.new(0, 0, 1, 2)
    list.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 5
    list.Parent = container
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 8)
    lc.Parent = list
    local ls = Instance.new("UIStroke")
    ls.Color = Color3.fromRGB(80, 80, 80)
    ls.Thickness = 1
    ls.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.Parent = list

    local current = defaultOption
    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 28)
        ob.BackgroundColor3 = BTN_NEUTRAL
        ob.Text = opt
        ob.TextColor3 = Color3.fromRGB(255, 255, 255)
        ob.Font = Enum.Font.GothamBold
        ob.TextSize = 12
        ob.Parent = list
        local oc = Instance.new("UICorner")
        oc.CornerRadius = UDim.new(0, 6)
        oc.Parent = ob
        ob.MouseButton1Click:Connect(function()
            playClickSound()
            current = opt
            btn.Text = text .. ": " .. opt .. "  ▼"
            list.Visible = false
            callback(opt)
        end)
        ob.MouseEnter:Connect(function()
            ob.BackgroundColor3 = BTN_HOVER
        end)
        ob.MouseLeave:Connect(function()
            ob.BackgroundColor3 = BTN_NEUTRAL
        end)
    end

    btn.MouseButton1Click:Connect(function()
        playClickSound()
        list.Visible = not list.Visible
    end)

    return container
end

local function createBindButton(parent, id, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = BTN_NEUTRAL
    btn.Text = text .. ": " .. getKeyName(BINDS[id])
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(70, 70, 70)
    s.Thickness = 1
    s.Parent = btn

    bindLabels[id] = btn

    btn.MouseButton1Click:Connect(function()
        playClickSound()
        bindingMode = id
        btn.Text = text .. ": НАЖМИ КЛАВИШУ..."
        btn.BackgroundColor3 = Color3.fromRGB(80, 60, 20)
    end)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = BTN_HOVER
    end)
    btn.MouseLeave:Connect(function()
        if bindingMode ~= id then
            btn.BackgroundColor3 = BTN_NEUTRAL
        end
    end)
end

local function createActionButton(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(90, 90, 90)
    s.Thickness = 1
    s.Parent = btn

    btn.MouseButton1Click:Connect(function()
        playClickSound()
        callback()
    end)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.15)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = color
    end)
    return btn
end

local function createTextBox(parent, placeholder, defaultText, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 36)
    box.Position = UDim2.new(0.05, 0, 0, 0)
    box.BackgroundColor3 = BTN_NEUTRAL
    box.Text = defaultText or ""
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = box
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(70, 70, 70)
    s.Thickness = 1
    s.Parent = box

    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
    return box
end

local configListHolder
local function refreshConfigList()
    if not configListHolder then return end
    for _, child in ipairs(configListHolder:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local configs = listConfigs()
    for _, name in ipairs(configs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Position = UDim2.new(0.05, 0, 0, 0)
        btn.BackgroundColor3 = (name == CURRENT_CONFIG_NAME) and BTN_ACCENT or BTN_NEUTRAL
        btn.Text = name .. (name == CURRENT_CONFIG_NAME and "  [ACTIVE]" or "")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = configListHolder
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(70, 70, 70)
        s.Thickness = 1
        s.Parent = btn

        btn.MouseButton1Click:Connect(function()
            playClickSound()
            loadConfigByName(name)
            saveConfig()
            refreshConfigList()
        end)
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = BTN_HOVER
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = (name == CURRENT_CONFIG_NAME) and BTN_ACCENT or BTN_NEUTRAL
        end)
    end
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
    local part
    if obj:IsA("Model") then
        if obj.PrimaryPart then
            part = obj.PrimaryPart
        else
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("BasePart") then part = child break end
            end
        end
    else
        part = obj
    end
    if not part then return false end
    local size = part.Size
    local volume = size.X * size.Y * size.Z
    if volume < 20 then return false end
    return true
end

local function isGenerator(obj)
    if not obj:IsA("Model") and not obj:IsA("BasePart") then return false end
    local n = obj.Name:lower()
    if not (n:find("generator") or n:find("generat") or n:find("генератор")) then return false end
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

local function scanPallets()
    if tick() - lastPalletScan < SCAN_INTERVAL then return end
    lastPalletScan = tick()
    palletCache = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isPallet(obj) then
            table.insert(palletCache, obj)
        end
    end
end

local function scanGenerators()
    if tick() - lastGeneratorScan < SCAN_INTERVAL then return end
    lastGeneratorScan = tick()
    generatorCache = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isGenerator(obj) then
            table.insert(generatorCache, obj)
        end
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
    scanPallets()
    for obj, esp in pairs(palletESP) do
        if not obj.Parent then
            esp.h:Destroy()
            palletESP[obj] = nil
        end
    end
    for _, obj in ipairs(palletCache) do
        if not palletESP[obj] then
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
    scanGenerators()
    for obj, esp in pairs(generatorESP) do
        if not obj.Parent then
            esp.h:Destroy()
            generatorESP[obj] = nil
        end
    end
    for _, obj in ipairs(generatorCache) do
        if not generatorESP[obj] then
            local h = createHighlight(obj, GENERATOR_COLOR)
            generatorESP[obj] = { h = h }
        end
    end
end

local function isAttackAnimation(name)
    local lower = name:lower()
    for _, kw in ipairs(ATTACK_ANIM_KEYWORDS) do
        if lower:find(kw) then return true end
    end
    return false
end

local function getTrackTimeToHit(track)
    local timePos = track.TimePosition
    local length = track.Length
    if length <= 0 then return nil end
    if timePos < PARRY_WINDOW_START or timePos > PARRY_WINDOW_END then
        return nil
    end
    return timePos
end

local function getParryTarget()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local bestPlr, bestRoot, bestDist, bestPriority = nil, nil, math.huge, -1
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not (root and hum and hum.Health > 0) then continue end
        if not isKiller(plr) then continue end
        local dist = (myRoot.Position - root.Position).Magnitude
        if dist > PARRY_RADIUS then continue end

        local priority = 0
        if PARRY_PRIORITY == "nearest" then
            priority = 1000 - dist
        elseif PARRY_PRIORITY == "attacking" then
            priority = 0
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                if isAttackAnimation(track.Animation.Name) then
                    priority = 1000
                    break
                end
            end
        end

        if priority > bestPriority or (priority == bestPriority and dist < bestDist) then
            bestPriority = priority
            bestDist = dist
            bestPlr = plr
            bestRoot = root
        end
    end
    return bestPlr, bestRoot
end

local function tryParry()
    local now = tick()
    if now - lastParry < PARRY_COOLDOWN then return end
    local plr, root = getParryTarget()
    if not plr then return end

    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        if isAttackAnimation(track.Animation.Name) then
            local hitTime = getTrackTimeToHit(track)
            if hitTime then
                if PARRY_REACTION_MS > 0 then
                    task.wait(PARRY_REACTION_MS / 1000)
                end
                lastParry = tick()
                VirtualInputManager:SendKeyEvent(true, PARRY_KEY, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, PARRY_KEY, false, game)
                return
            end
        end
    end
end

track(RunService.RenderStepped:Connect(function()
    updateKillerESP()
    if FOV_ENABLED then
        local cam = Workspace.CurrentCamera
        if cam and cam.FieldOfView ~= FOV_VALUE then
            cam.FieldOfView = FOV_VALUE
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
    while task.wait(0.02) do
        if AUTO_PARRY then
            tryParry()
        end
    end
end))

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
            hum.UseJumpPower = true
        else
            hum.JumpPower = 0
            hum.UseJumpPower = true
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

    if MOONWALK_ENABLED and hum and root then
        local moveDir = hum.MoveDirection

        if moveDir.Magnitude > 0 then
            hum.AutoRotate = false

            if not moonwalkGyro or not moonwalkGyro.Parent then
                moonwalkGyro = Instance.new("BodyGyro")
                moonwalkGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                moonwalkGyro.P = 1e4
                moonwalkGyro.D = 500
                moonwalkGyro.Parent = root
            end

            if not moonwalkVel or not moonwalkVel.Parent then
                moonwalkVel = Instance.new("BodyVelocity")
                moonwalkVel.MaxForce = Vector3.new(1e5, 0, 1e5)
                moonwalkVel.P = 1e4
                moonwalkVel.Parent = root
            end

            local now = tick()
            if now - moonwalkLastSide >= MOONWALK_SIDE_INTERVAL then
                moonwalkLastSide = now
                moonwalkSide = -moonwalkSide
                moonwalkTargetAngle = MOONWALK_ANGLE_STEP * moonwalkSide
            end

            moonwalkCurrentAngle = moonwalkCurrentAngle + (moonwalkTargetAngle - moonwalkCurrentAngle) * math.min(MOONWALK_TURN_SPEED * dt, 1)

            local moveVec = Vector3.new(moveDir.X, 0, moveDir.Z).Unit
            local angleRad = math.rad(moonwalkCurrentAngle)
            local rotatedDir = Vector3.new(
                moveVec.X * math.cos(angleRad) - moveVec.Z * math.sin(angleRad),
                0,
                moveVec.X * math.sin(angleRad) + moveVec.Z * math.cos(angleRad)
            )

            moonwalkVel.Velocity = rotatedDir * MOONWALK_SPEED
            moonwalkGyro.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), -rotatedDir)
        else
            hum.AutoRotate = true
            if moonwalkGyro then moonwalkGyro:Destroy() moonwalkGyro = nil end
            if moonwalkVel then moonwalkVel:Destroy() moonwalkVel = nil end
        end
    else
        if hum then hum.AutoRotate = true end
        if moonwalkGyro then moonwalkGyro:Destroy() moonwalkGyro = nil end
        if moonwalkVel then moonwalkVel:Destroy() moonwalkVel = nil end
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
                btn.BackgroundColor3 = BTN_NEUTRAL
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
    playClickSound()
    menuMinimized = not menuMinimized
    if menuMinimized then
        for _, page in ipairs({espPage, visualPage, survivorPage, movementPage, configPage, bindsPage}) do
            page.Visible = false
        end
        tabBar.Visible = false
        mainFrame.Size = UDim2.new(0, 380, 0, 50)
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 380, 0, 560)
        tabBar.Visible = true
        minimizeBtn.Text = "—"
        switchTab("ESP")
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    _G.mainFrame = nil
    screenGui:Destroy()
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    connections = {}
    for _, t in ipairs(loops) do
        pcall(function() task.cancel(t) end)
    end
    loops = {}
end)

createCollapsible(espPage, "ESP Killers", function(content)
    createStateButton(content, "Killer ESP", function() return ESP_KILLER end, function(v)
        ESP_KILLER = v
        updateBindLabel("espKiller", v)
        saveConfig()
    end)
    createStateButton(content, "Show Distance", function() return ESP_DISTANCE end, function(v)
        ESP_DISTANCE = v
        saveConfig()
    end)
end)

createCollapsible(espPage, "ESP Pallets", function(content)
    createStateButton(content, "Pallet ESP", function() return ESP_PALLET end, function(v)
        ESP_PALLET = v
        updateBindLabel("espPallet", v)
        saveConfig()
    end)
end)

createCollapsible(espPage, "ESP Generators", function(content)
    createStateButton(content, "Generator ESP", function() return ESP_GENERATOR end, function(v)
        ESP_GENERATOR = v
        updateBindLabel("espGenerator", v)
        saveConfig()
    end)
end)

createCollapsible(visualPage, "FOV Changer", function(content)
    createStateButton(content, "FOV Lock", function() return FOV_ENABLED end, function(v)
        FOV_ENABLED = v
        saveConfig()
    end)
    createSlider(content, "FOV Value", 30, 120, FOV_VALUE, function(val)
        FOV_VALUE = val
        saveConfig()
    end)
end)

createCollapsible(survivorPage, "Auto Parry", function(content)
    createStateButton(content, "Auto Parry", function() return AUTO_PARRY end, function(v)
        AUTO_PARRY = v
        updateBindLabel("autoParry", v)
        saveConfig()
    end)
    createSlider(content, "Parry Range", 5, 30, PARRY_RADIUS, function(val)
        PARRY_RADIUS = val
        saveConfig()
    end)
    createSlider(content, "Reaction Delay (ms)", 0, 200, PARRY_REACTION_MS, function(val)
        PARRY_REACTION_MS = val
        saveConfig()
    end)
    createSlider(content, "Window Start (x0.01s)", 1, 50, math.floor(PARRY_WINDOW_START * 100), function(val)
        PARRY_WINDOW_START = val / 100
        saveConfig()
    end)
    createSlider(content, "Window End (x0.01s)", 5, 100, math.floor(PARRY_WINDOW_END * 100), function(val)
        PARRY_WINDOW_END = val / 100
        saveConfig()
    end)
    createDropdown(content, "Priority", {"nearest", "attacking"}, PARRY_PRIORITY, function(opt)
        PARRY_PRIORITY = opt
        saveConfig()
    end)
end)

createCollapsible(movementPage, "Speed", function(content)
    createStateButton(content, "Speed", function() return SPEED_ENABLED end, function(v)
        SPEED_ENABLED = v
        updateBindLabel("speed", v)
        saveConfig()
    end)
    createSlider(content, "Speed Value", 16, 200, SPEED_VALUE, function(val)
        SPEED_VALUE = val
        saveConfig()
    end)
end)

createCollapsible(movementPage, "Jump", function(content)
    createStateButton(content, "Jump", function() return JUMP_ENABLED end, function(v)
        JUMP_ENABLED = v
        saveConfig()
    end)
    createSlider(content, "Jump Value", 50, 300, JUMP_VALUE, function(val)
        JUMP_VALUE = val
        saveConfig()
    end)
end)

createCollapsible(movementPage, "Noclip", function(content)
    createStateButton(content, "Noclip", function() return NOCLIP_ENABLED end, function(v)
        NOCLIP_ENABLED = v
        updateBindLabel("noclip", v)
        saveConfig()
    end)
end)

createCollapsible(movementPage, "Fly", function(content)
    createStateButton(content, "Fly", function() return FLY_ENABLED end, function(v)
        FLY_ENABLED = v
        updateBindLabel("fly", v)
        saveConfig()
    end)
    createSlider(content, "Fly Speed", 10, 200, FLY_SPEED, function(val)
        FLY_SPEED = val
        saveConfig()
    end)
end)

createCollapsible(movementPage, "Moonwalk", function(content)
    createStateButton(content, "Moonwalk", function() return MOONWALK_ENABLED end, function(v)
        MOONWALK_ENABLED = v
        updateBindLabel("moonwalk", v)
        saveConfig()
    end)
    createSlider(content, "Moonwalk Speed", 16, 80, MOONWALK_SPEED, function(val)
        MOONWALK_SPEED = val
        saveConfig()
    end)
    createSlider(content, "Side Interval (x0.1s)", 1, 30, 10, function(val)
        MOONWALK_SIDE_INTERVAL = val / 10
        saveConfig()
    end)
    createSlider(content, "Turn Speed", 1, 20, MOONWALK_TURN_SPEED, function(val)
        MOONWALK_TURN_SPEED = val
        saveConfig()
    end)
end)

createSectionLabel(configPage, "Config Name")
createTextBox(configPage, "Enter config name", CURRENT_CONFIG_NAME, function(text)
    if text and text ~= "" then
        CURRENT_CONFIG_NAME = text
        saveConfig()
        refreshConfigList()
    end
end)

createSectionLabel(configPage, "Saved Configs")
configListHolder = Instance.new("Frame")
configListHolder.Size = UDim2.new(0.9, 0, 0, 200)
configListHolder.Position = UDim2.new(0.05, 0, 0, 0)
configListHolder.BackgroundTransparency = 1
configListHolder.Parent = configPage
local chLayout = Instance.new("UIListLayout")
chLayout.Padding = UDim.new(0, 6)
chLayout.SortOrder = Enum.SortOrder.LayoutOrder
chLayout.Parent = configListHolder

createActionButton(configPage, "Save Current", BTN_SUCCESS, function()
    saveConfig()
    refreshConfigList()
end)
createActionButton(configPage, "Reset Current", BTN_DANGER, function()
    resetConfig()
    refreshConfigList()
end)
createActionButton(configPage, "Reload Current", BTN_INFO, function()
    loadConfigByName(CURRENT_CONFIG_NAME)
    saveConfig()
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
createBindButton(bindsPage, "moonwalk", "Moonwalk")

loadBinds()
loadConfigByName(CURRENT_CONFIG_NAME)
for id, _ in pairs(BINDS) do
    updateBindLabel(id, false)
end
refreshConfigList()

task.spawn(function()
    for i = 0, 100 do
        loadBarFill:TweenSize(UDim2.new(i / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.02, true)
        loadPercent.Text = i .. "%"
        task.wait(0.02)
    end
    task.wait(0.3)
    playLoadSound()
    loadingGui:Destroy()
    screenGui.Enabled = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0, 30, 0.5, -30)
    task.wait(0.05)
    mainFrame:TweenSize(UDim2.new(0, 380, 0, 560), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)
    mainFrame:TweenPosition(UDim2.new(0, 30, 0.5, -280), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)
end)

print("[BRUTAL SCRIPT] Loaded successfully.")
