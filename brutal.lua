local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.Scheme.AccentColor     = Color3.fromRGB(180, 80, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(12, 12, 12)
Library.Scheme.MainColor       = Color3.fromRGB(35, 35, 35)
Library.Scheme.OutlineColor    = Color3.fromRGB(180, 80, 255)
Library.Scheme.FontColor       = Color3.fromRGB(240, 240, 240)

local LOGO_ID = "rbxassetid://83643298666145"

-- ================= LOADING + KEY SYSTEM =================

local VALID_KEYS = {
    ["BRUTAL-FREE-0001"] = true,
    ["BRUTAL-7D-0002"]   = true,
    ["BRUTAL-30D-0003"]  = true,
    ["BRUTAL-VIP-0004"]  = true,
    ["BRUTAL-TEST-0005"] = true,
}

local KeyVerified = false

local function ShowLoadingScreen()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BrutalLoading"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game:GetService("CoreGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.fromOffset(120, 120)
    logo.Position = UDim2.new(0.5, -60, 0.5, -160)
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_ID
    logo.Parent = bg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0.5, -60)
    title.BackgroundTransparency = 1
    title.Text = "BRUTALSCRIPT"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 42
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3 = Color3.fromRGB(120, 20, 20)
    title.Parent = bg

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, 0, 0, 24)
    version.Position = UDim2.new(0, 0, 0.5, -10)
    version.BackgroundTransparency = 1
    version.Text = "v1.0 - PC"
    version.TextColor3 = Color3.fromRGB(200, 200, 200)
    version.Font = Enum.Font.GothamBold
    version.TextSize = 16
    version.Parent = bg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.fromOffset(300, 8)
    barBg.Position = UDim2.new(0.5, -150, 0.5, 40)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg

    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(180, 80, 255)
    barStroke.Thickness = 1
    barStroke.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg

    local percent = Instance.new("TextLabel")
    percent.Size = UDim2.new(1, 0, 0, 20)
    percent.Position = UDim2.new(0, 0, 0.5, 60)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.TextColor3 = Color3.fromRGB(200, 200, 200)
    percent.Font = Enum.Font.Gotham
    percent.TextSize = 12
    percent.Parent = bg

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.5, 85)
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.Parent = bg

    return gui, barFill, percent, status
end

local function ShowKeyPrompt()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BrutalKeyGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = game:GetService("CoreGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.fromOffset(100, 100)
    logo.Position = UDim2.new(0.5, -50, 0.5, -190)
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_ID
    logo.Parent = bg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0.5, -100)
    title.BackgroundTransparency = 1
    title.Text = "BRUTALSCRIPT"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 36
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3 = Color3.fromRGB(120, 20, 20)
    title.Parent = bg

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, 0, 0, 24)
    version.Position = UDim2.new(0, 0, 0.5, -55)
    version.BackgroundTransparency = 1
    version.Text = "Key Required"
    version.TextColor3 = Color3.fromRGB(200, 200, 200)
    version.Font = Enum.Font.GothamBold
    version.TextSize = 14
    version.Parent = bg

    local box = Instance.new("TextBox")
    box.Size = UDim2.fromOffset(300, 48)
    box.Position = UDim2.new(0.5, -150, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = "Enter key..."
    box.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.Text = ""
    box.ClearTextOnFocus = false
    box.Parent = bg

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(180, 80, 255)
    boxStroke.Thickness = 1
    boxStroke.Parent = box

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(300, 48)
    btn.Position = UDim2.new(0.5, -150, 0.5, 50)
    btn.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    btn.Text = "SUBMIT"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = bg

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(300, 20)
    status.Position = UDim2.new(0.5, -150, 0.5, 105)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.Font = Enum.Font.Gotham
    status.TextSize = 13
    status.Parent = bg

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.fromOffset(300, 20)
    hint.Position = UDim2.new(0.5, -150, 0.5, 140)
    hint.BackgroundTransparency = 1
    hint.Text = "Test: BRUTAL-FREE-0001 / BRUTAL-VIP-0004"
    hint.TextColor3 = Color3.fromRGB(120, 120, 120)
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 11
    hint.Parent = bg

    btn.MouseButton1Click:Connect(function()
        local key = box.Text
        if key == "" then
            status.Text = "Enter a key"
            return
        end

        status.TextColor3 = Color3.fromRGB(200, 200, 200)
        status.Text = "Checking..."

        task.wait(0.4)

        if VALID_KEYS[key] then
            status.TextColor3 = Color3.fromRGB(100, 255, 120)
            status.Text = "Key accepted!"
            task.wait(0.6)
            gui:Destroy()
            KeyVerified = true
        else
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            status.Text = "Invalid key"
        end
    end)
end

local loadingGui, barFill, percentLabel, statusLabel = ShowLoadingScreen()

local steps = {
    { 0.15, "Initializing..." },
    { 0.35, "Loading libraries..." },
    { 0.55, "Loading UI..." },
    { 0.75, "Preparing features..." },
    { 1.00, "Ready" },
}

for _, step in ipairs(steps) do
    local target = step[1]
    local text = step[2]

    statusLabel.Text = text

    local current = barFill.Size.X.Scale
    while current < target do
        current = math.min(current + 0.02, target)
        barFill.Size = UDim2.new(current, 0, 1, 0)
        percentLabel.Text = math.floor(current * 100) .. "%"
        task.wait(0.02)
    end
end

task.wait(0.5)
loadingGui:Destroy()

ShowKeyPrompt()

local startTime = tick()
repeat
    task.wait(0.1)
    if tick() - startTime > 180 then
        return
    end
until KeyVerified

-- ================= MAIN SCRIPT (PC) =================

local WindowSize = UDim2.fromOffset(600, 400)

local Window = Library:CreateWindow({
    Title = "BRUTALSCRIPT",
    Footer = "BRUTALSCRIPT - Violence District",
    Icon = LOGO_ID,
    IconSize = UDim2.fromOffset(40, 40),
    CornerRadius = 12,
    NotifySide = "Right",
    ShowCustomCursor = true,
    ToggleKeybind = Enum.KeyCode.RightShift,
    Size = WindowSize,
})

local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Watermark = Library:AddDraggableLabel("BRUTALSCRIPT")

-- ============== WATERMARK STYLING ==============
task.spawn(function()
    task.wait(1.5)

    local CoreGui = game:GetService("CoreGui")

    local function findWatermarkLabel()
        for _, gui in ipairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name == "Obsidian" then
                for _, obj in ipairs(gui:GetDescendants()) do
                    if obj:IsA("TextLabel") and obj.Text:find("BRUTALSCRIPT") then
                        return obj
                    end
                end
            end
        end
        return nil
    end

    local label
    for i = 1, 25 do
        label = findWatermarkLabel()
        if label then break end
        task.wait(0.3)
    end

    if not label then return end

    local node = label
    for level = 1, 4 do
        node = node.Parent
        if not node or node == CoreGui then break end

        for _, child in ipairs(node:GetChildren()) do
            if child:IsA("UIStroke") then
                child:Destroy()
            elseif child:IsA("UICorner") then
                child:Destroy()
            end
        end

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = node

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(180, 80, 255)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = node

        if node:IsA("Frame") then
            break
        end
    end
end)

-- ============== MAIN MENU STYLING ==============
task.spawn(function()
    task.wait(1.5)

    local CoreGui = game:GetService("CoreGui")

    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "Obsidian" then
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "Window") then
                    local outer = Instance.new("UIStroke")
                    outer.Color = Color3.fromRGB(255, 255, 255)
                    outer.Thickness = 2
                    outer.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    outer.Parent = obj

                    local inner = Instance.new("UIStroke")
                    inner.Color = Color3.fromRGB(180, 80, 255)
                    inner.Thickness = 1
                    inner.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    inner.Transparency = 0.2
                    inner.Parent = obj

                    local bgImage = Instance.new("ImageLabel")
                    bgImage.Name = "BrutalLogo"
                    bgImage.Size = UDim2.fromScale(0.55, 0.55)
                    bgImage.Position = UDim2.fromScale(0.225, 0.225)
                    bgImage.BackgroundTransparency = 1
                    bgImage.Image = LOGO_ID
                    bgImage.ImageTransparency = 0.82
                    bgImage.ZIndex = 0
                    bgImage.Parent = obj

                    break
                end
            end
            break
        end
    end
end)

-- ============== WINDOW ICON ==============
task.spawn(function()
    task.wait(2)

    local CoreGui = game:GetService("CoreGui")

    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "Obsidian" then

            for _, obj in ipairs(gui:GetDescendants()) do
                if (obj:IsA("ImageLabel") or obj:IsA("ImageButton"))
                and string.lower(obj.Name) == "icon" then
                    obj.Image = LOGO_ID
                    obj.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    obj.ImageTransparency = 0
                end
            end

            break
        end
    end
end)

local FPS = 0
local Frames = 0
local LastTick = tick()

RunService.RenderStepped:Connect(function()
    Frames += 1

    if tick() - LastTick >= 1 then
        FPS = Frames
        Frames = 0
        LastTick = tick()

        local Ping = math.floor(
            Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        )

        Watermark:SetText(
            string.format(
                "BRUTALSCRIPT | FPS: %d | PING: %d ms",
                FPS,
                Ping
            )
        )
    end
end)

local Tabs = {
    Info = Window:AddTab("Info", "info"),
    ESP = Window:AddTab("ESP", "eye"),
    Player = Window:AddTab("Player", "user"),
    Misc = Window:AddTab("Misc", "sliders-horizontal"),
    Visual = Window:AddTab("Visual", "sparkles"),
    UISettings = Window:AddTab("UI Settings", "settings-2")
}

local InfoBox = Tabs.Info:AddLeftGroupbox("Script Info", "info")
local CreditsBox = Tabs.Info:AddRightGroupbox("Credits", "user")
local ESPBox = Tabs.ESP:AddLeftGroupbox("ESP Cham", "scan-eye")
local ESPStatusBox = Tabs.ESP:AddRightGroupbox("ESP Status", "scan-eye")

local RightTabBox = Tabs.Player:AddRightTabbox()
local AbilityTab = RightTabBox:AddTab("Survivor", "user")
local KillerTab = RightTabBox:AddTab("Killer", "skull")
local AimlockBox = Tabs.Player:AddLeftGroupbox("AimBot", "crosshair")
local ParryBox = Tabs.Player:AddLeftGroupbox("Parry", "swords")
local CrosshairBox = Tabs.Player:AddLeftGroupbox("Crosshair", "crosshair")
local MovementBox = Tabs.Misc:AddLeftGroupbox("Movement", "move")
local EmoteBox = Tabs.Misc:AddRightGroupbox("Emote", "music")
local FunBox = Tabs.Misc:AddRightGroupbox("fun", "smile")
local VisualBox = Tabs.Visual:AddLeftGroupbox("Graphics", "sun")
local TimeBox = Tabs.Visual:AddRightGroupbox("Clock & Ambient", "alarm-clock-check")
local ZoomBox = Tabs.Visual:AddRightGroupbox("Zoom Out", "fullscreen")
local SettingBox = Tabs.UISettings:AddLeftGroupbox("Menu", "wrench")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local CarryEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("CarrySurvivorEvent")
local HookEvent  = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookEvent")
local AttackEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")
local SkillCheckRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Generator")
    :WaitForChild("SkillCheckResultEvent")

local ESP = {
    Survivor = false,
    Killer = false,
    Generator = false,
    Pallet = false,
    Window = false,
    SCP = false,
    Distance = 100
}

local ESPStatus = {
    Enabled = false,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = false,
    Radius = 100
}

local TeamColors = {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120)
}

local Auto = {
    SkillCheck = false,
    Parry = false,
    ParryDelay = 0,
    ParryCooldown = 1,
    ParryDistance = 15,
    FaceSensitivity = 0.7,
    RequireFacing = true,
    Wiggle = false,
    WiggleSpam = 5
}

local AutoFlee = {
    Enabled = false,
    DetectDistance = 50,
    Cooldown = 0.1
}

local LastFlee = 0

local GunAim = {
    Enabled = false,
    Holding = false,
    TargetMode = "Killer",
    Strength = 1,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    VisibilityCheck = true,
    Target = nil,
    AimPart = "HumanoidRootPart"
}

local AttackAim = {
    Enabled = false,
    Holding = false,
    Strength = 1,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    VisibilityCheck = true,
    AimPart = "HumanoidRootPart"
}

local Killer = {
    KillAll = false,
    AutoAttack = false,
    AutoCarry = false,
    KillRange = 500,
    AttackDelay = 0.45
}

local KillerBusy = false
local KillerTarget = nil
local ParryActive = false

local Masked = {
    Enabled = false,
    CurrentPower = "Cobra"
}

local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

local Moonwalk = {
    Enabled = false,
    ShowButton = false,
    SpamSpeed = 30,
    Intensity = 35,
    SlowSpeed = 20,
    UseSlow = true
}

local MoonwalkConnection = nil
local MoonwalkButton = nil

local CameraZoom = {
    UnlimitedZoom = false,
    MaxDistance = 1000,
    MinDistance = 0,
    FOVEnabled = false,
    FOV = 70,
    DefaultFOV = workspace.CurrentCamera.FieldOfView
}

local AutoStalk = {
    Enabled = false,
    StalkRange = 150,
    Target = nil
}

local KillerAnims = {
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true,
    ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"] = true,
    ["rbxassetid://98163597193511"] = true,
    ["rbxassetid://82666958311998"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://117070354890871"] = true,
    ["rbxassetid://106871536134254"] = true,
    ["rbxassetid://138720291317243"] = true
}

local ParryRangeVisual = {
    Enabled = false,
    Color = Color3.fromRGB(255, 80, 80),
    Transparency = 0.9
}

local ParryCircle = nil

local PlayerMods = {
    GodMode = false
}

local Movement = {
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    OriginalJumpPower = 50,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 17.6,
    OriginalWalkSpeed = 16,
    NoClip = false
}

local function GetNil(Name, DebugId)
    if not getnilinstances then return nil end

    for _, Object in pairs(getnilinstances()) do
        if Object.Name == Name then
            if not DebugId or Object:GetDebugId() == DebugId then
                return Object
            end
        end
    end
end

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getAnimId(id)
    return tostring(id):match("%d+")
end

local function GetDowned()
    local root = getRoot()
    if not root then return nil end

    local best, dist = nil, math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 0 and hum.Health <= hum.MaxHealth * 0.25 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    best = p.Character
                end
            end
        end
    end

    return best
end

local function GetHook()
    local root = getRoot()
    if not root then return nil end

    local bestHook = nil
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < shortestDistance and dist < 400 then
                shortestDistance = dist
                bestHook = obj
            end
        end
    end

    return bestHook
end

local function applyJumpPower()
    if not Movement.JumpPowerEnabled then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = Movement.JumpPowerValue
    end
end

local function shouldDisableWalkSpeed()
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")

        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local anim = track.Animation

                if anim and anim.AnimationId then
                    if anim.AnimationId == "rbxassetid://127096285501517" then return true end
                    if anim.AnimationId == "rbxassetid://112166042383605" then return true end
                    if anim.AnimationId == "http://www.roblox.com/asset/?id=126965695851149" then return true end
                    if anim.AnimationId == "http://www.roblox.com/asset/?id=135084204086504" then return true end
                    if anim.AnimationId == "rbxassetid://123047897844134" then return true end

                    local id = anim.AnimationId:match("%d+")
                    if id then
                        local fullId = "rbxassetid://" .. id
                        if KillerAnims[fullId] then return true end
                    end
                end
            end
        end
    end

    if hum and (
        hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
    ) then
        return true
    end

    return false
end

local WalkSpeedConnection = nil

local function applyWalkSpeed()
    if WalkSpeedConnection then
        WalkSpeedConnection:Disconnect()
        WalkSpeedConnection = nil
    end

    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        if not Movement.WalkSpeedEnabled then return end

        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if shouldDisableWalkSpeed() then return end

        if hum.WalkSpeed ~= Movement.WalkSpeedValue then
            hum.WalkSpeed = Movement.WalkSpeedValue
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    applyJumpPower()
    applyWalkSpeed()
end)

local NoClipConnection = nil

local function applyNoClip()
    local char = LocalPlayer.Character
    if not char then return end

    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = not Movement.NoClip
        end
    end
end

local function toggleNoClip(state)
    Movement.NoClip = state

    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end

        NoClipConnection = RunService.RenderStepped:Connect(function()
            if Movement.NoClip then
                applyNoClip()
            end
        end)
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end

        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    applyJumpPower()
    if Movement.NoClip then
        task.wait(0.3)
        toggleNoClip(true)
    end
end)

local function applyGodMode()
    if not PlayerMods.GodMode then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if hum.Health < hum.MaxHealth then
        pcall(function() hum.Health = hum.MaxHealth end)
    end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Dead
    or state == Enum.HumanoidStateType.FallingDown
    or state == Enum.HumanoidStateType.Ragdoll then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.5)

    if ParryCircle then
        ParryCircle:Destroy()
        ParryCircle = nil
    end
end)

if LocalPlayer.Character then
    applyJumpPower()
    applyWalkSpeed()
end

-- ============== AI TARGETING ==============
local function getClosestGunTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    local closest, shortest = nil, GunAim.FOV

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false

            if GunAim.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif GunAim.TargetMode == "Survivors" and p.Team.Name == "Survivors" then valid = true end

            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")

                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)

                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end

    return closest
end

local function getClosestAttackTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    local closest, shortest = nil, AttackAim.FOV

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local hrp = p.Character:FindFirstChild(AttackAim.AimPart)
            local hum = p.Character:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local pos, visible = cam:WorldToViewportPoint(hrp.Position)

                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = hrp
                    end
                end
            end
        end
    end

    return closest
end

-- ============== AIMBOT CONNECTIONS ==============
local GunAimConnection = nil

local function startGunAim()
    if GunAimConnection then return end

    GunAimConnection = RunService.RenderStepped:Connect(function()
        if not GunAim.Enabled then GunAim.Target = nil return end
        if not GunAim.Holding then GunAim.Target = nil return end

        local cam = workspace.CurrentCamera
        local target = getClosestGunTarget()
        if not target then return end

        local pos = target.Position

        if GunAim.Predict then
            pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength)
        end

        local cf = CFrame.new(cam.CFrame.Position, pos)
        cam.CFrame = cam.CFrame:Lerp(cf, GunAim.Strength)
    end)
end

local AttackAimConnection = nil

local function startAttackAim()
    if AttackAimConnection then return end

    AttackAimConnection = RunService.RenderStepped:Connect(function()
        if not AttackAim.Enabled then return end
        if not AttackAim.Holding then return end

        local target = getClosestAttackTarget()
        if not target then return end

        local cam = workspace.CurrentCamera
        local pos = target.Position

        if AttackAim.Predict then
            pos = pos + (target.AssemblyLinearVelocity * AttackAim.PredictStrength)
        end

        cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
    end)
end

-- ============== MOONWALK (PC) ==============
local lastMoonwalkTime = 0

local function createMoonwalkButton()
    if MoonwalkButton then MoonwalkButton:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonwalkGui"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.65, 0, 0.75, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = btn

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.fromScale(0.8, 0.8)
    img.Position = UDim2.fromScale(0.1, 0.1)
    img.BackgroundTransparency = 1
    img.Image = LOGO_ID
    img.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Moonwalk.Enabled = not Moonwalk.Enabled

        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(180, 80, 255)
        else
            stroke.Color = Color3.fromRGB(255,255,255)

            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
                hum.WalkSpeed = Movement.WalkSpeedEnabled and Movement.WalkSpeedValue or 16
            end
        end
    end)

    MoonwalkButton = gui
end

local function removeMoonwalkButton()
    if MoonwalkButton then MoonwalkButton:Destroy() MoonwalkButton = nil end
end

-- ============== MAIN RENDER LOOP ==============
RunService.RenderStepped:Connect(function(dt)
    -- Moonwalk
    if Moonwalk.Enabled and not ParryActive then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera

            if humanoid and hrp and cam then
                if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
                    humanoid.WalkSpeed = Moonwalk.SlowSpeed
                end

                if humanoid.AutoRotate then
                    humanoid.AutoRotate = false
                end

                local moveDir = humanoid.MoveDirection
                local flatMove = Vector3.new(moveDir.X, 0, moveDir.Z)

                local targetLookDir
                if flatMove.Magnitude > 0.1 then
                    targetLookDir = -flatMove.Unit
                else
                    local camLook = cam.CFrame.LookVector
                    local flatCam = Vector3.new(camLook.X, 0, camLook.Z)
                    if flatCam.Magnitude > 0.01 then
                        targetLookDir = -flatCam.Unit
                    end
                end

                if targetLookDir then
                    local currentPos = hrp.Position
                    local currentCF = hrp.CFrame
                    local targetCF = CFrame.new(currentPos, currentPos + targetLookDir)
                    local newRotation = targetCF - targetCF.Position + currentCF.Position
                    hrp.CFrame = currentCF:Lerp(newRotation, 0.5)
                end
            end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid.AutoRotate then
                humanoid.AutoRotate = true
                if Movement.WalkSpeedEnabled then
                    humanoid.WalkSpeed = Movement.WalkSpeedValue
                end
            end
        end
    end
end)

-- ============== UI ==============

InfoBox:AddLabel("Script: BRUTALSCRIPT")
InfoBox:AddLabel("Version: 1.0.0")
InfoBox:AddLabel("Game: Violence District")
InfoBox:AddLabel("Platform: PC")

CreditsBox:AddLabel("Developer: BRUTALSCRIPT")
CreditsBox:AddDivider()
CreditsBox:AddLabel("Library: Obsidian UI")

-- ESP
local SurvivorESP = ESPBox:AddCheckbox("SurvivorESP", {
    Text = "ESP Survivor",
    Default = false,
    Callback = function(v) ESP.Survivor = v end
})
SurvivorESP:AddColorPicker("SurvivorESPColor", {
    Default = TeamColors.Survivor,
    Title = "Survivor Color",
    Callback = function(color) TeamColors.Survivor = color end
})

local KillerESP = ESPBox:AddCheckbox("KillerESP", {
    Text = "ESP Killer",
    Default = false,
    Callback = function(v) ESP.Killer = v end
})
KillerESP:AddColorPicker("KillerESPColor", {
    Default = TeamColors.Killer,
    Title = "Killer Color",
    Callback = function(color) TeamColors.Killer = color end
})

local ESPGeneratorToggle = ESPBox:AddCheckbox("ESPGenerator", {
    Text = "Generator",
    Default = false,
    Callback = function(v) ESP.Generator = v end
})

local ESPSCPToggle = ESPBox:AddCheckbox("ESPSCP", {
    Text = "SCP",
    Default = false,
    Callback = function(v) ESP.SCP = v end
})

local ESPPalletToggle = ESPBox:AddCheckbox("ESPPallet", {
    Text = "Pallet",
    Default = false,
    Callback = function(v) ESP.Pallet = v end
})

local ESPWindowToggle = ESPBox:AddCheckbox("ESPWindow", {
    Text = "Window",
    Default = false,
    Callback = function(v) ESP.Window = v end
})

ESPBox:AddSlider("ESPDistance", {
    Text = "ESP Radius",
    Default = 100,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Callback = function(v) ESP.Distance = v end
})

ESPStatusBox:AddCheckbox("EnableStatus", {
    Text = "Enable Status ESP",
    Default = false,
    Callback = function(v) ESPStatus.Enabled = v end
})
ESPStatusBox:AddCheckbox("ShowName", {
    Text = "Show Name",
    Default = true,
    Callback = function(v) ESPStatus.ShowName = v end
})
ESPStatusBox:AddCheckbox("ShowDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v) ESPStatus.ShowDistance = v end
})
ESPStatusBox:AddCheckbox("ShowHealth", {
    Text = "Show Health",
    Default = false,
    Callback = function(v) ESPStatus.ShowHealth = v end
})
ESPStatusBox:AddSlider("StatusRadius", {
    Text = "Status Radius",
    Default = 100,
    Min = 20,
    Max = 500,
    Rounding = 0,
    Callback = function(v) ESPStatus.Radius = v end
})

-- CROSSHAIR
local CrosshairToggle = CrosshairBox:AddCheckbox("CrosshairEnabled", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(v) end
})
CrosshairToggle:AddColorPicker("CrosshairColor", {
    Default = Color3.fromRGB(255,255,255),
    Title = "Crosshair Color",
    Transparency = 0,
    Callback = function(color) end
})
CrosshairBox:AddDropdown("Style", {
    Values = {"Plus","Dot","Circle"},
    Default = 1,
    Multi = false,
    Text = "Style",
    Callback = function(v) end
})
CrosshairBox:AddSlider("CrosshairPosX", {
    Text = "Position X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Callback = function(v) end
})
CrosshairBox:AddSlider("CrosshairPosY", {
    Text = "Position Y",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Callback = function(v) end
})

-- ABILITY
AbilityTab:AddCheckbox("Skill", {
    Text = "Auto Skill Check",
    Default = false,
    Callback = function(v) Auto.SkillCheck = v end
})
AbilityTab:AddCheckbox("AutoWiggle", {
    Text = "Auto Wiggle",
    Default = false,
    Callback = function(v) Auto.Wiggle = v end
})
AbilityTab:AddCheckbox("AutoFleeKiller", {
    Text = "Auto Flee Killer",
    Default = false,
    Callback = function(v) AutoFlee.Enabled = v end
})
AbilityTab:AddCheckbox("GodMode", {
    Text = "Anti KnockDown",
    Default = false,
    Callback = function(v) PlayerMods.GodMode = v end
})

AbilityTab:AddDivider()

AbilityTab:AddCheckbox("MoonwalkButton", {
    Text = "MoonwalkButton",
    Default = false,
    Callback = function(v)
        Moonwalk.ShowButton = v
        if v then createMoonwalkButton() else removeMoonwalkButton() end
    end
})

AbilityTab:AddLabel("Moonwalk Keybind"):AddKeyPicker("MoonwalkKey", {
    Default = "V",
    Mode = "Toggle",
    Text = "Moonwalk (pc)",
    Callback = function(state)
        Moonwalk.Enabled = state
        if not state then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
                hum.WalkSpeed = 16
            end
        end
    end
})

AbilityTab:AddSlider("MoonwalkSlowSpeed", {
    Text = "Moonwalk Speed",
    Default = Moonwalk.SlowSpeed,
    Min = 5,
    Max = 32,
    Rounding = 1,
    Callback = function(Value) Moonwalk.SlowSpeed = Value end
})
AbilityTab:AddToggle("MoonwalkUseSlow", {
    Text = "Slow on Moonwalk",
    Default = true,
    Callback = function(v) Moonwalk.UseSlow = v end
})
AbilityTab:AddButton({
    Text = "instant escape",
    Func = function() end
})

-- KILLER
KillerTab:AddCheckbox("AutoStalk", {
    Text = "Auto Stalk",
    Default = false,
    Callback = function(v) AutoStalk.Enabled = v end
})
KillerTab:AddCheckbox("AttackAim", {
    Text = "AimLock Attack",
    Default = false,
    Callback = function(v)
        AttackAim.Enabled = v
        if v then startAttackAim() end
    end
})
KillerTab:AddCheckbox("KillAll", {
    Text = "Auto Kill All",
    Default = false,
    Callback = function(v) Killer.KillAll = v end
})
KillerTab:AddCheckbox("AutoAttack", {
    Text = "Auto Spam Attack",
    Default = false,
    Callback = function(v) Killer.AutoAttack = v end
})
KillerTab:AddSlider("AttackDelay", {
    Text = "Attack Delay",
    Default = 0.45,
    Min = 0.1,
    Max = 1,
    Rounding = 2,
    Callback = function(v) Killer.AttackDelay = v end
})

KillerTab:AddDivider()

KillerTab:AddDropdown("MaskedPowerSelect", {
    Text = "Select Power",
    Values = MaskedPowers,
    Default = 1,
    Multi = false,
    Callback = function(val) Masked.CurrentPower = val end
})
KillerTab:AddButton("Activate Power", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
    if Event then Event:FireServer(Masked.CurrentPower) end
end)
KillerTab:AddButton("Deactivate Power", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
    if Event then Event:FireServer() end
end)

-- PARRY
local AutoParryToggle = ParryBox:AddCheckbox("AutoParry", {
    Text = "Auto Parry",
    Default = false,
    Callback = function(v)
        Auto.Parry = v
        ParryRangeVisual.Enabled = v
    end
})
AutoParryToggle:AddColorPicker("ParryRangeColor", {
    Default = Color3.fromRGB(255, 80, 80),
    Transparency = 0,
    Title = "Parry Range Color",
    Callback = function(color)
        ParryRangeVisual.Color = color
        if ParryCircle then ParryCircle.Color = color end
    end
})
ParryBox:AddCheckbox("ShowParryRange", {
    Text = "Show Parry Range",
    Default = true,
    Callback = function(Value)
        ParryRangeVisual.Enabled = Value
        if not Value and ParryCircle then ParryCircle:Destroy() ParryCircle = nil end
    end
})
ParryBox:AddSlider("ParryDistance", {
    Text = "Distance",
    Default = 15,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Callback = function(v) Auto.ParryDistance = v end
})
ParryBox:AddSlider("FaceSensitivity", {
    Text = "Face Sensitivity Killer",
    Default = 0.7,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(v) Auto.FaceSensitivity = v end
})

-- AIMBOT
AimlockBox:AddToggle("GunAimEnabled", {
    Text = "Aim Lock",
    Default = false,
    Callback = function(v) GunAim.Enabled = v end
})
AimlockBox:AddDropdown("GunAimTarget", {
    Values = { "Killer", "Survivors", "SCP" },
    Default = 1,
    Text = "Target",
    Callback = function(v) GunAim.TargetMode = v end
})
AimlockBox:AddDropdown("GunAimPart", {
    Text = "Aim Part",
    Values = { "Head", "HumanoidRootPart", "Torso" },
    Default = 2,
    Callback = function(Value) GunAim.AimPart = Value end
})
AimlockBox:AddSlider("GunAimFOV", {
    Text = "FOV",
    Default = 250,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Callback = function(v) GunAim.FOV = v end
})
AimlockBox:AddSlider("GunAimPredict", {
    Text = "Prediction",
    Default = 0.12,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(v) GunAim.PredictStrength = v end
})

-- MOVEMENT
MovementBox:AddCheckbox("WalkSpeedToggle", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(v)
        Movement.WalkSpeedEnabled = v
        if v then applyWalkSpeed()
        else
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Movement.OriginalWalkSpeed end
        end
    end
})
MovementBox:AddSlider("WalkSpeedSlider", {
    Text = "Walk Speed Value",
    Default = 17.6,
    Min = 16,
    Max = 32,
    Rounding = 1,
    Callback = function(v)
        Movement.WalkSpeedValue = v
        if Movement.WalkSpeedEnabled then applyWalkSpeed() end
    end
})
MovementBox:AddCheckbox("NoClipToggle", {
    Text = "No Clip",
    Default = false,
    Callback = function(v) toggleNoClip(v) end
})
MovementBox:AddCheckbox("JumpPowerToggle", {
    Text = "Custom Jump Power",
    Default = false,
    Callback = function(v)
        Movement.JumpPowerEnabled = v
        if v then applyJumpPower()
        else
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = Movement.OriginalJumpPower end
        end
    end
})
MovementBox:AddSlider("JumpPowerSlider", {
    Text = "Jump Power Value",
    Default = 50,
    Min = 0,
    Max = 300,
    Rounding = 0,
    Callback = function(v)
        Movement.JumpPowerValue = v
        if Movement.JumpPowerEnabled then applyJumpPower() end
    end
})

-- EMOTES
EmoteBox:AddDropdown("SelectEmote", {
    Values = {"Mannrobics", "Arm Swing", "Schadenfreude", "Kyoufuu", "Backflip", "Griddy", "Friday Night", "Floating Rest", "OnePlays", "Quick Combo", "WarCry", "Wave"},
    Default = 1,
    Multi = false,
    Text = "Select Emote",
    Callback = function(v) end
})

-- FUN
FunBox:AddToggle("JerkTool", {
    Text = "Jerk Tool",
    Default = false,
    Callback = function(v) end
})

-- GRAPHICS
VisualBox:AddCheckbox("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v) end
})
VisualBox:AddCheckbox("NoShadow", {
    Text = "No Shadow",
    Default = false,
    Callback = function(v) end
})
VisualBox:AddCheckbox("LowGraphics", {
    Text = "Low Graphics",
    Default = false,
    Callback = function(v) end
})
VisualBox:AddCheckbox("NoScreenEffects", {
    Text = "No Screen Effects",
    Default = false,
    Callback = function(v) end
})
VisualBox:AddCheckbox("CleanSky", {
    Text = "Clean Sky",
    Default = false,
    Callback = function(v) end
})

-- CAMERA
ZoomBox:AddToggle("UnlimitedZoom", {
    Text = "Unlimited Zoom Out",
    Default = false,
    Callback = function(v) end
})
ZoomBox:AddSlider("MaxZoomDistance", {
    Text = "Max Zoom Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Callback = function(v) end
})
ZoomBox:AddToggle("CustomFOV", {
    Text = "Custom FOV",
    Default = false,
    Callback = function(Value) end
})
ZoomBox:AddSlider("CameraFOV", {
    Text = "Camera FOV",
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Callback = function(Value) end
})

-- LIGHTING
TimeBox:AddSlider("ClockTime", {
    Text = "Clock Time",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(v) end
})
TimeBox:AddSlider("Brightness", {
    Text = "Brightness",
    Default = 2,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(v) end
})

-- UI SETTINGS
SettingBox:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value) end
})
SettingBox:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value) end
})
SettingBox:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "85%", "100%", "125%", "150%" },
    Default = "85%%",
    Text = "DPI Scale",
    Callback = function(Value) end
})
SettingBox:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = 12,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value) end
})
SettingBox:AddToggle("WatermarkToggle", {
    Text = "Watermark",
    Default = true,
    Callback = function(Value) end
})

SettingBox:AddDivider()

SettingBox:AddButton("Unload script", function() Library:Unload() end)

-- ============== SAVE / THEME ==============
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("BRUTALSCRIPT")
SaveManager:SetFolder("BRUTALSCRIPT/configs")
SaveManager:BuildConfigSection(Tabs.UISettings)
