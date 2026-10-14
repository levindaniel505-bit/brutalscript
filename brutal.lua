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
local IS_MOBILE = game:GetService("UserInputService").TouchEnabled

-- ================= KEY SYSTEM =================
local VALID_KEYS = {
    ["BRUTAL-K7X9M2QF"] = true, ["BRUTAL-P3N8R5VZ"] = true, ["BRUTAL-D6H1T4LY"] = true,
    ["BRUTAL-W8B2C7JX"] = true, ["BRUTAL-M5F9A3QE"] = true, ["BRUTAL-R2V6Y1KN"] = true,
    ["BRUTAL-T7G4P8HW"] = true, ["BRUTAL-X9L3D5ZB"] = true, ["BRUTAL-N1Q7M4FK"] = true,
    ["BRUTAL-Y6J2S9VA"] = true, ["BRUTAL-C4H8W1RN"] = true, ["BRUTAL-Z5K3B7MP"] = true,
    ["BRUTAL-F9T6D2XL"] = true, ["BRUTAL-V1P4N8QY"] = true, ["BRUTAL-G7R3H5JW"] = true,
    ["BRUTAL-B8M1K6SZ"] = true, ["BRUTAL-J4X9C2TV"] = true, ["BRUTAL-Q6W7F3LD"] = true,
    ["BRUTAL-S2Y5P8HN"] = true, ["BRUTAL-L9D4R1KX"] = true, ["BRUTAL-H3V7M6BQ"] = true,
    ["BRUTAL-E8N2J5WT"] = true, ["BRUTAL-U1C6F9PZ"] = true, ["BRUTAL-A5K8L4YH"] = true,
    ["BRUTAL-P7Q2D1NX"] = true, ["BRUTAL-IX9W3C6RM"] = true, ["BRUTAL-O4H8V5JT"] = true,
    ["BRUTAL-K1M7B2QF"] = true, ["BRUTAL-R6T3Z9LD"] = true, ["BRUTAL-W2S5P1KH"] = true,
}

local MAX_ACCOUNTS = 1
local SAVE_FILE = "brutal_keys.txt"
local KeyVerified = false

local function loadData()
    local data = {}
    if not isfile or not readfile then return data end
    if not isfile(SAVE_FILE) then return data end
    local ok, raw = pcall(readfile, SAVE_FILE)
    if not ok or not raw then return data end
    for line in string.gmatch(raw, "[^\r\n]+") do
        local key, ids = string.match(line, "^(.+)=(.+)$")
        if key and ids then
            data[key] = {}
            for id in string.gmatch(ids, "%d+") do
                table.insert(data[key], tonumber(id))
            end
        end
    end
    return data
end

local function saveData(data)
    if not writefile then return end
    local lines = {}
    for key, ids in pairs(data) do
        local strIds = {}
        for _, id in ipairs(ids) do
            table.insert(strIds, tostring(id))
        end
        lines[#lines + 1] = key .. "=" .. table.concat(strIds, ",")
    end
    pcall(writefile, SAVE_FILE, table.concat(lines, "\n"))
end

local function checkKeyWithBinding(key, userId)
    if not VALID_KEYS[key] then return false, "Invalid key" end
    local data = loadData()
    local boundIds = data[key]
    if not boundIds then
        data[key] = { userId }
        saveData(data)
        return true, "Key activated!"
    end
    for _, id in ipairs(boundIds) do
        if id == userId then return true, "Welcome back!" end
    end
    if #boundIds >= MAX_ACCOUNTS then return false, "Key already used on another account" end
    table.insert(boundIds, userId)
    saveData(data)
    return true, "Key activated!"
end

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
    version.Text = "v1.0"
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
    logo.Size = UDim2.fromOffset(120, 120)
    logo.Position = UDim2.new(0.5, -60, 0.5, -210)
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_ID
    logo.Parent = bg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0.5, -110)
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
    version.Position = UDim2.new(0, 0, 0.5, -60)
    version.BackgroundTransparency = 1
    version.Text = "v1.0 — Key Required"
    version.TextColor3 = Color3.fromRGB(200, 200, 200)
    version.Font = Enum.Font.GothamBold
    version.TextSize = 14
    version.Parent = bg

    local box = Instance.new("TextBox")
    box.Size = UDim2.fromOffset(340, 40)
    box.Position = UDim2.new(0.5, -170, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = "Enter your key..."
    box.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Text = ""
    box.ClearTextOnFocus = false
    box.Parent = bg

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(180, 80, 255)
    boxStroke.Thickness = 1
    boxStroke.Parent = box

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(340, 40)
    btn.Position = UDim2.new(0.5, -170, 0.5, 45)
    btn.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    btn.Text = "SUBMIT"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = bg

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(340, 20)
    status.Position = UDim2.new(0.5, -170, 0.5, 95)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.Font = Enum.Font.Gotham
    status.TextSize = 13
    status.Parent = bg

    btn.MouseButton1Click:Connect(function()
        local key = box.Text
        if key == "" then status.Text = "Enter a key" return end
        status.TextColor3 = Color3.fromRGB(200, 200, 200)
        status.Text = "Checking..."
        task.wait(0.3)
        local userId = game:GetService("Players").LocalPlayer.UserId
        local valid, message = checkKeyWithBinding(key, userId)
        if valid then
            status.TextColor3 = Color3.fromRGB(100, 255, 120)
            status.Text = message
            task.wait(0.6)
            gui:Destroy()
            KeyVerified = true
        else
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            status.Text = message
        end
    end)
end

local loadingGui, barFill, percentLabel, statusLabel = ShowLoadingScreen()

local steps = {
    { 0.15, "Initializing..." }, { 0.35, "Loading libraries..." },
    { 0.55, "Loading UI..." }, { 0.75, "Preparing features..." }, { 1.00, "Ready" },
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
    if tick() - startTime > 180 then return end
until KeyVerified

-- ================= MAIN SCRIPT =================

local WindowSize = IS_MOBILE and UDim2.fromOffset(340, 300) or UDim2.fromOffset(600, 400)

local Window = Library:CreateWindow({
    Title = "BRUTALSCRIPT",
    Footer = "BRUTALSCRIPT - Violence District",
    Icon = LOGO_ID,
    IconSize = UDim2.fromOffset(40, 40),
    CornerRadius = 0,
    NotifySide = IS_MOBILE and "Left" or "Right",
    ShowCustomCursor = not IS_MOBILE,
    ShowMobileButtons = IS_MOBILE,
    ToggleKeybind = Enum.KeyCode.RightShift,
    Size = WindowSize,
    EnableSidebarResize = false,
    EnableCompacting = IS_MOBILE,
    SidebarCompacted = IS_MOBILE,
})

if IS_MOBILE then
    task.spawn(function()
        task.wait(2)
        local obsidian = game:GetService("CoreGui"):FindFirstChild("Obsidian")
        if not obsidian then return end
        if obsidian:FindFirstChild("BrutalOpenButton") then return end

        local btn = Instance.new("TextButton")
        btn.Name = "BrutalOpenButton"
        btn.Size = UDim2.fromOffset(60, 60)
        btn.Position = UDim2.new(0, 15, 0.5, -30)
        btn.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        btn.BackgroundTransparency = 0.15
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = obsidian

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 2
        stroke.Parent = btn

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.fromScale(0.75, 0.75)
        img.Position = UDim2.fromScale(0.125, 0.125)
        img.BackgroundTransparency = 1
        img.Image = LOGO_ID
        img.Parent = btn

        btn.MouseButton1Click:Connect(function() Library:Toggle() end)
        Library:MakeDraggable(btn, btn, true)
    end)
end

local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Watermark = Library:AddDraggableLabel("BRUTALSCRIPT")

task.spawn(function()
    task.wait(1.5)
    local CoreGui = game:GetService("CoreGui")
    local function findLabel()
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
        label = findLabel()
        if label then break end
        task.wait(0.3)
    end
    if not label then return end
    local node = label
    for level = 1, 4 do
        node = node.Parent
        if not node or node == CoreGui then break end
        for _, child in ipairs(node:GetChildren()) do
            if child:IsA("UIStroke") then child:Destroy()
            elseif child:IsA("UICorner") then child:Destroy() end
        end
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = node
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(180, 80, 255)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = node
        if node:IsA("Frame") then break end
    end
end)

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

                    if not IS_MOBILE then
                        local bgImage = Instance.new("ImageLabel")
                        bgImage.Name = "BrutalLogo"
                        bgImage.Size = UDim2.fromScale(0.55, 0.55)
                        bgImage.Position = UDim2.fromScale(0.225, 0.225)
                        bgImage.BackgroundTransparency = 1
                        bgImage.Image = LOGO_ID
                        bgImage.ImageTransparency = 0.82
                        bgImage.ZIndex = 0
                        bgImage.Parent = obj
                    end
                    break
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
        local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Watermark:SetText(string.format("BRUTALSCRIPT | FPS: %d | PING: %d ms", FPS, Ping))
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

local CarryEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("CarrySurvivorEvent")
local HookEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Carry"):WaitForChild("HookEvent")
local AttackEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Attacks"):WaitForChild("BasicAttack")

local ESP = { Survivor = false, Killer = false, Generator = false, Pallet = false, Window = false, SCP = false, Distance = 100 }
local ESPStatus = { Enabled = false, ShowName = true, ShowDistance = true, ShowHealth = false, Radius = 100 }
local TeamColors = { Killer = Color3.fromRGB(255, 60, 60), Survivor = Color3.fromRGB(60, 255, 120) }

local Auto = { SkillCheck = false, Parry = false, ParryDistance = 15, FaceSensitivity = 0.7, RequireFacing = true, Wiggle = false, WiggleSpam = 5 }
local AutoFlee = { Enabled = false, DetectDistance = 50, Cooldown = 0.1 }
local LastFlee = 0

local GunAim = { Enabled = false, Holding = false, TargetMode = "Killer", Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, VisibilityCheck = true, Target = nil, AimPart = "HumanoidRootPart" }
local AttackAim = { Enabled = false, Holding = false, Strength = 1, Predict = true, PredictStrength = 0.12, FOV = 250, VisibilityCheck = true, AimPart = "HumanoidRootPart" }
local Killer = { KillAll = false, AutoAttack = false, AutoCarry = false, KillRange = 500, AttackDelay = 0.45 }
local KillerBusy = false
local KillerTarget = nil
local ParryActive = false
local Masked = { Enabled = false, CurrentPower = "Cobra" }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

local Moonwalk = { Enabled = false, ShowButton = false, SpamSpeed = 30, Intensity = 35, SlowSpeed = 20, UseSlow = true }
local MoonwalkConnection = nil
local MoonwalkButton = nil

-- ============== SIDE STEP (evade killer, walk imitation) ==============
local Evade = {
    Enabled = false,
    Radius = 15,
    SafeDistance = 10,
    Duration = 0.9,
    Cooldown = 2,
    Direction = -1,
    Angle = 160,
    Active = false,
    LastTrigger = 0,
    RequireApproach = true,
    FullBehind = true,
    BehindOffset = 0,
}

local CameraZoom = { UnlimitedZoom = false, MaxDistance = 1000, MinDistance = 0, FOVEnabled = false, FOV = 70, DefaultFOV = workspace.CurrentCamera.FieldOfView }
local AutoStalk = { Enabled = false, StalkRange = 150, Target = nil }

local KillerAnims = {
    ["rbxassetid://105374834496520"] = true, ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://118907603246885"] = true, ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://117042998468241"] = true, ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true, ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://78432063483146"] = true, ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://133963973694098"] = true, ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://80411309607666"] = true, ["rbxassetid://98163597193511"] = true,
    ["rbxassetid://82666958311998"] = true, ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true, ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true, ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://117070354890871"] = true, ["rbxassetid://106871536134254"] = true,
    ["rbxassetid://138720291317243"] = true
}

local ParryRangeVisual = { Enabled = false, Color = Color3.fromRGB(255, 80, 80), Transparency = 0.9 }
local ParryCircle = nil
local PlayerMods = { GodMode = false }
local Movement = { JumpPowerEnabled = false, JumpPowerValue = 50, OriginalJumpPower = 50, WalkSpeedEnabled = false, WalkSpeedValue = 17.6, OriginalWalkSpeed = 16, NoClip = false }

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ============== SIDE STEP LOGIC ==============
local function performEvade(killerRoot)
    local myRoot = getRoot()
    local hum = getHum()
    if not myRoot or not hum or not killerRoot then return end

    local center = Vector3.new(killerRoot.Position.X, myRoot.Position.Y, killerRoot.Position.Z)
    local startPos = myRoot.Position

    local toMe = startPos - center
    local flat = Vector3.new(toMe.X, 0, toMe.Z)
    local currentR = flat.Magnitude
    local r = math.max(currentR, Evade.SafeDistance)

    local startAngle = math.atan2(flat.Z, flat.X)
    local totalAngle
    local endAngle

    if Evade.FullBehind then
        local killerLook = killerRoot.CFrame.LookVector
        local behindAngle = math.atan2(-killerLook.Z, -killerLook.X) + math.rad(Evade.BehindOffset)

        local diff = behindAngle - startAngle
        while diff > math.pi do diff -= math.pi * 2 end
        while diff < -math.pi do diff += math.pi * 2 end

        local sign = Evade.Direction < 0 and -1 or 1
        totalAngle = sign * math.pi * 2

        endAngle = startAngle + totalAngle
        local errAngle = behindAngle - endAngle
        while errAngle > math.pi do errAngle -= math.pi * 2 end
        while errAngle < -math.pi do errAngle += math.pi * 2 end
        totalAngle = totalAngle + errAngle
    else
        totalAngle = math.rad(Evade.Angle) * Evade.Direction
        endAngle = startAngle + totalAngle
    end

    local duration = Evade.Duration
    local startTick = tick()

    Evade.Active = true

    while tick() - startTick < duration do
        if not myRoot.Parent or not killerRoot.Parent then break end

        local progress = (tick() - startTick) / duration
        local eased = progress < 0.5 and 2 * progress * progress or 1 - ((-2 * progress + 2) ^ 2) / 2
        local angle = startAngle + totalAngle * eased

        local targetPos = Vector3.new(
            center.X + math.cos(angle) * r,
            startPos.Y,
            center.Z + math.sin(angle) * r
        )

        local direction = targetPos - myRoot.Position
        direction = Vector3.new(direction.X, 0, direction.Z)
        if direction.Magnitude > 0.1 then
            hum:Move(direction.Unit)
        end

        RunService.RenderStepped:Wait()
    end

    hum:Move(Vector3.zero)
    Evade.Active = false
end

task.spawn(function()
    while task.wait(0.05) do
        if not Evade.Enabled or Evade.Active then continue end
        if tick() - Evade.LastTrigger < Evade.Cooldown then continue end

        local myRoot = getRoot()
        local myHum = getHum()
        if not myRoot or not myHum then continue end

        local target = nil
        local shortest = Evade.Radius
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Team and plr.Team.Name == "Killer" and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if hrp and h and h.Health > 0 then
                    local d = (hrp.Position - myRoot.Position).Magnitude
                    if d < shortest and d > 4 then
                        local dirTo = (hrp.Position - myRoot.Position).Unit
                        local flatDir = Vector3.new(dirTo.X, 0, dirTo.Z).Unit
                        local flatLook = Vector3.new(myRoot.CFrame.LookVector.X, 0, myRoot.CFrame.LookVector.Z).Unit
                        local dot = flatLook:Dot(flatDir)

                        if dot < -0.1 then
                            local killerVel = hrp.AssemblyLinearVelocity
                            local flatVel = Vector3.new(killerVel.X, 0, killerVel.Z)
                            local approaching = true
                            if Evade.RequireApproach and flatVel.Magnitude > 2 then
                                local toMe = (myRoot.Position - hrp.Position)
                                local flatToMe = Vector3.new(toMe.X, 0, toMe.Z).Unit
                                local velDot = flatVel.Unit:Dot(flatToMe)
                                if velDot < 0.3 then
                                    approaching = false
                                end
                            end

                            if approaching then
                                shortest = d
                                target = hrp
                            end
                        end
                    end
                end
            end
        end

        if target then
            Evade.LastTrigger = tick()
            task.spawn(function() performEvade(target) end)
        end
    end
end)

local lastParry = 0
local PARRY_DEBOUNCE = 0.2

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
                if d < dist then dist = d best = p.Character end
            end
        end
    end
    return best
end

local function GetHook()
    local root = getRoot()
    if not root then return nil end
    local bestHook, shortest = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "HookPoint" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < shortest and dist < 400 then shortest = dist bestHook = obj end
        end
    end
    return bestHook
end

local function applyJumpPower()
    if not Movement.JumpPowerEnabled then return end
    local hum = getHum()
    if hum then hum.JumpPower = Movement.JumpPowerValue end
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
    if hum and (hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true) then
        return true
    end
    return false
end

local WalkSpeedConnection = nil

local function applyWalkSpeed()
    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() WalkSpeedConnection = nil end
    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        if not Movement.WalkSpeedEnabled then return end
        local hum = getHum()
        if not hum then return end
        if shouldDisableWalkSpeed() then return end
        if hum.WalkSpeed ~= Movement.WalkSpeedValue then hum.WalkSpeed = Movement.WalkSpeedValue end
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
        if v:IsA("BasePart") and v.CanCollide then v.CanCollide = not Movement.NoClip end
    end
end

local function toggleNoClip(state)
    Movement.NoClip = state
    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RunService.RenderStepped:Connect(function()
            if Movement.NoClip then applyNoClip() end
        end)
    else
        if NoClipConnection then NoClipConnection:Disconnect() NoClipConnection = nil end
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    applyJumpPower()
    if Movement.NoClip then task.wait(0.3) toggleNoClip(true) end
end)

local function applyGodMode()
    if not PlayerMods.GodMode then return end
    local hum = getHum()
    if not hum then return end
    if hum.Health < hum.MaxHealth then pcall(function() hum.Health = hum.MaxHealth end) end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    if ParryCircle then ParryCircle:Destroy() ParryCircle = nil end
end)

local ESPObjects = {}
local CachedSCP = {}

for _, obj in ipairs(workspace:GetDescendants()) do
    if string.find(string.lower(obj.Name), "scp") then CachedSCP[obj] = true end
end

workspace.DescendantAdded:Connect(function(obj)
    if string.find(string.lower(obj.Name), "scp") then CachedSCP[obj] = true end
end)

local function removeESP(obj)
    if ESPObjects[obj] then ESPObjects[obj]:Destroy() ESPObjects[obj] = nil end
end

workspace.DescendantRemoving:Connect(function(obj)
    CachedSCP[obj] = nil
    removeESP(obj)
end)

local function createESP(obj, color)
    if not obj then return end
    if ESPObjects[obj] then
        ESPObjects[obj].FillColor = color
        ESPObjects[obj].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPObjects[obj] = h
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

local GeneratorColor = Color3.fromRGB(255, 170, 0)
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)
local MAX_DISTANCE = function() return ESP.Distance end

local function GetGameValue(obj, name)
    if not obj then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        local ok, val = pcall(function() return child.Value end)
        if ok then return val end
    end
    return nil
end

local function ApplyGenHighlight(object, color)
    local h = object:FindFirstChild("GenHighlight") or Instance.new("Highlight")
    h.Name = "GenHighlight"
    h.Adornee = object
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.9
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = object
end

local function CreateBillboard(text, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GenESP"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = billboard
    return billboard
end

local function UpdateGenerator(generator)
    if not generator or not generator.Parent then return end
    if not ESP.Generator then
        local old = generator:FindFirstChild("GenESP")
        if old then old:Destroy() end
        local h = generator:FindFirstChild("GenHighlight")
        if h then h:Destroy() end
        return
    end
    local percent = GetGameValue(generator, "RepairProgress") or GetGameValue(generator, "Progress") or 0
    local billboard = generator:FindFirstChild("GenESP")
    if percent >= 100 then
        if billboard then billboard:Destroy() end
        return
    end
    local cp = math.clamp(percent, 0, 100)
    local color = GeneratorColor:Lerp(Color3.fromRGB(0,255,120), cp / 100)
    local text = string.format("[%.0f%%]", percent)
    if not billboard then
        billboard = CreateBillboard(text, color)
        billboard.Adornee = generator
        billboard.Parent = generator
    else
        local lbl = billboard:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.Text = text lbl.TextColor3 = color end
    end
    ApplyGenHighlight(generator, color)
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end
    local pos
    if obj:IsA("Model") then pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then pos = obj.Position end
    if not pos then return end
    local distance = (pos - root.Position).Magnitude
    if obj.Name == "Window" then
        if ESP.Window and distance <= MAX_DISTANCE() then createESP(obj, WindowColor) else removeESP(obj) end
    end
    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet and distance <= MAX_DISTANCE() then createESP(obj, PalletColor) else removeESP(obj) end
    end
end

local StatusESP = {}

local function removeStatusESP(char)
    if StatusESP[char] then StatusESP[char]:Destroy() StatusESP[char] = nil end
end

local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then removeStatusESP(char) return end
    if not root then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    local isDown = hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
    local dist = (head.Position - root.Position).Magnitude
    if dist > ESPStatus.Radius then removeStatusESP(char) return end
    local text = ""
    if isDown then text = "🔻 DOWN\n" end
    if ESPStatus.ShowName then text = text .. player.Name .. "\n" end
    if ESPStatus.ShowDistance then text = text .. string.format("Dist: %.0f\n", dist) end
    if ESPStatus.ShowHealth then text = text .. string.format("HP: %.0f\n", hum.Health) end
    if text == "" then removeStatusESP(char) return end
    local billboard = StatusESP[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        local teamColor = Color3.new(1,1,1)
        if player.Team then
            if player.Team.Name == "Killer" then teamColor = TeamColors.Killer
            elseif player.Team.Name == "Survivors" then teamColor = TeamColors.Survivor end
        end
        if isDown then teamColor = Color3.fromRGB(255, 0, 0) end
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Text = text
        label.Parent = billboard
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = char
        StatusESP[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then label.Text = text end
    end
end

local function UpdateSCPEsp(root)
    if not ESP.SCP then for obj in pairs(CachedSCP) do removeESP(obj) end return end
    for obj in pairs(CachedSCP) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then pos = obj.Position end
            if pos then
                local dist = (pos - root.Position).Magnitude
                if dist <= ESP.Distance then createESP(obj, SCPColor) else removeESP(obj) end
            end
        end
    end
end

local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team and plr.Team.Name == "Killer" and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < shortest then shortest = dist closest = hrp end
            end
        end
    end
    return closest, shortest
end

local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint, farthestDistance = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthestDistance then farthestDistance = dist bestPoint = obj end
        end
    end
    return bestPoint
end

local function AutoWiggle()
    if not Auto.Wiggle then return end
    local char = LocalPlayer.Character
    if not char then return end
    local carried = (char:FindFirstChild("IsCarried") and char.IsCarried.Value)
        or (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)
    if not carried then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local carry = remotes:FindFirstChild("Carry")
    if not carry then return end
    local event = carry:FindFirstChild("SelfUnHookEvent")
    if not event then return end
    for i = 1, Auto.WiggleSpam do event:FireServer() end
end

local function pressRightClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local AttackPaths = {
    "Slasher-mob.Controls.attack",
    "Masked-mob.Controls.attack",
    "Killer-mob.Controls.attack"
}

local function GetParryButton()
    local current = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function GetAttackAimButton()
    for _, path in ipairs(AttackPaths) do
        local current = PlayerGui
        for segment in string.gmatch(path, "[^%.]+") do
            current = current and current:FindFirstChild(segment)
        end
        if current and current:IsA("GuiObject") then return current end
    end
    return nil
end

local function GetGunAimButton()
    local current = PlayerGui
    for segment in string.gmatch("Survivor-mob.Controls.Gui-mob", "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = true
        AttackAim.Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        GunAim.Holding = false
        AttackAim.Holding = false
    end
end)

local function pressParryButton()
    if UserInputService.TouchEnabled then
        local btn = GetParryButton()
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = game:GetService("GuiService"):GetGuiInset()
            local x = pos.X + size.X/2 + inset.X
            local y = pos.Y + size.Y/2 + inset.Y
            VirtualInputManager:SendTouchEvent(8823, 0, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8823, 2, x, y)
        end
    else
        pressRightClick()
    end
end

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_DEBOUNCE then return end
    lastParry = now
    ParryActive = true
    if Moonwalk.Enabled then Moonwalk.Enabled = false end
    pressParryButton()
    task.delay(0.3, function() ParryActive = false end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end
    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    return (enemyRoot.Position - myRoot.Position).Magnitude <= Auto.ParryDistance
end

local function isFacingTarget(targetChar)
    if not Auto.RequireFacing then return true end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local enemyRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not enemyRoot then return false end
    local enemyForward = enemyRoot.CFrame.LookVector
    local directionToMe = (myRoot.Position - enemyRoot.Position).Unit
    local dot = enemyForward:Dot(directionToMe)
    if Auto.FaceSensitivity <= -1 then return true end
    return dot >= Auto.FaceSensitivity
end

local hookedKillers = {}

local function hookKiller(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not Auto.Parry then return end
        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id
        if KillerAnims[fullId] then
            if not isInParryRange(char) then return end
            if not isFacingTarget(char) then return end
            doParry()
        end
    end)
end

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isVisible(part)
    local cam = workspace.CurrentCamera
    RayParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local origin = cam.CFrame.Position
    local direction = (part.Position - origin)
    local result = workspace:Raycast(origin, direction, RayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestGunTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closest, shortest = nil, GunAim.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false
            if GunAim.TargetMode == "Killer" and p.Team.Name == "Killer" then valid = true
            elseif GunAim.TargetMode == "Survivor" and p.Team.Name == "Survivors" then valid = true end
            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            if GunAim.VisibilityCheck and not isVisible(hrp) then continue end
                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end
    if GunAim.TargetMode == "SCP" then
        for obj in pairs(CachedSCP) do
            if obj and obj.Parent then
                local part
                if obj:IsA("Model") then part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                elseif obj:IsA("BasePart") then part = obj end
                if part then
                    local pos, visible = cam:WorldToViewportPoint(part.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then shortest = dist closest = part end
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
                    if dist < shortest then shortest = dist closest = hrp end
                end
            end
        end
    end
    return closest
end

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
        if GunAim.Predict then pos = pos + (target.AssemblyLinearVelocity * GunAim.PredictStrength) end
        local cf = CFrame.new(cam.CFrame.Position, pos)
        cam.CFrame = cam.CFrame:Lerp(cf, GunAim.Strength)
    end)
end

local AttackAimConnection

local function startAttackAim()
    if AttackAimConnection then return end
    AttackAimConnection = RunService.RenderStepped:Connect(function()
        if not AttackAim.Enabled then return end
        if not AttackAim.Holding then return end
        local target = getClosestAttackTarget()
        if not target then return end
        local cam = workspace.CurrentCamera
        local pos = target.Position
        if AttackAim.Predict then pos = pos + (target.AssemblyLinearVelocity * AttackAim.PredictStrength) end
        cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
    end)
end

local function isDowned()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health <= 0 or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true
end

local function createMoonwalkButton()
    if not PlayerGui or not PlayerGui.Parent then return end
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
    corner.CornerRadius = UDim.new(0, 0)
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
        local hum = getHum()
        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(180, 80, 255)
        else
            stroke.Color = Color3.fromRGB(255,255,255)
            if hum then hum.WalkSpeed = Movement.WalkSpeedEnabled and Movement.WalkSpeedValue or 16 end
        end
    end)

    MoonwalkButton = gui
end

local function removeMoonwalkButton()
    if MoonwalkButton then MoonwalkButton:Destroy() MoonwalkButton = nil end
end

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local TouchID = 8822
local ActionPath = "Survivor-mob.Controls.action.check"
local SkillHeartbeat = nil

local function GetActionTarget()
    local current = PlayerGui
    for segment in string.gmatch(ActionPath, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function TriggerMobileButton()
    local b = GetActionTarget()
    if b and b:IsA("GuiObject") then
        local p, s, i = b.AbsolutePosition, b.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(TouchID, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(TouchID, 2, cx, cy)
        end)
    end
end

local busy = false

local function startSkillCheck()
    if SkillHeartbeat then SkillHeartbeat:Disconnect() end
    SkillHeartbeat = RunService.RenderStepped:Connect(function()
        if not Auto.SkillCheck or busy then return end
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end
        local lr = line.Rotation % 360
        local gr = goal.Rotation % 360
        local startRange = (gr + 102) % 360
        local endRange = (gr + 116) % 360
        local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
            or (lr >= startRange and lr <= endRange)
        if success then
            busy = true
            task.spawn(function()
                if UserInputService.TouchEnabled then TriggerMobileButton() else pressSpace() end
                task.wait(0.05)
                busy = false
            end)
        end
    end)
end

local StalkConnection = nil

local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AutoStalk.StalkRange and dist < shortest then shortest = dist closest = plr end
            end
        end
    end
    return closest
end

local function startAutoStalk()
    if StalkConnection then return end
    StalkConnection = RunService.Heartbeat:Connect(function()
        if not AutoStalk.Enabled then return end
        local target = getClosestSurvivorForStalk()
        if not target or not target.Character then return end
        local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true)
            and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
            and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true)
            and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
        if stalkEvent then pcall(function() stalkEvent:FireServer(target) end) end
    end)
end

local function stopAutoStalk()
    if StalkConnection then StalkConnection:Disconnect() StalkConnection = nil end
end

task.spawn(function()
    while task.wait(0.2) do
        if not AutoFlee.Enabled then continue end
        local root = getRoot()
        if not root then continue end
        local killerRoot, distance = GetNearestKiller()
        if killerRoot and distance <= AutoFlee.DetectDistance and tick() - LastFlee > AutoFlee.Cooldown then
            local point = GetFarthestGeneratorPoint(killerRoot)
            if point then LastFlee = tick() root.CFrame = point.CFrame + Vector3.new(0, 5, 0) end
        end
    end
end)

local function GetNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d closest = plr.Character end
            end
        end
    end
    return closest
end

local function applyUnlimitedZoom()
    if CameraZoom.UnlimitedZoom then
        LocalPlayer.CameraMaxZoomDistance = CameraZoom.MaxDistance
        LocalPlayer.CameraMinZoomDistance = CameraZoom.MinDistance
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end

local function applyCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if CameraZoom.FOVEnabled then cam.FieldOfView = CameraZoom.FOV
    else cam.FieldOfView = CameraZoom.DefaultFOV end
end

local JerkTool = { Enabled = false, ToolName = "Jerk Off" }
local currentJerkTool = nil

local function createJerkTool()
    if currentJerkTool then currentJerkTool:Destroy() end
    local speaker = LocalPlayer
    local character = speaker.Character
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local backpack = speaker:FindFirstChildWhichIsA("Backpack")
    if not humanoid or not backpack then return end
    local tool = Instance.new("Tool")
    tool.Name = JerkTool.ToolName
    tool.ToolTip = "in the stripped club."
    tool.RequiresHandle = false
    tool.Parent = backpack
    currentJerkTool = tool
    local jorkin = false
    local track = nil
    local function stopTomfoolery()
        jorkin = false
        if track then track:Stop() track = nil end
    end
    tool.Equipped:Connect(function() jorkin = true end)
    tool.Unequipped:Connect(stopTomfoolery)
    humanoid.Died:Connect(stopTomfoolery)
    task.spawn(function()
        while task.wait() do
            if not JerkTool.Enabled or not jorkin then
                if track then track:Stop() end
                continue
            end
            local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
            if not track then
                local anim = Instance.new("Animation")
                anim.AnimationId = not isR15 and "rb
