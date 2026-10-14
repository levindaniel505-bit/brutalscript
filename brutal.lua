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
    ["BRUTAL-K7X9M2QF"] = true,
    ["BRUTAL-P3N8R5VZ"] = true,
    ["BRUTAL-D6H1T4LY"] = true,
    ["BRUTAL-W8B2C7JX"] = true,
    ["BRUTAL-M5F9A3QE"] = true,
    ["BRUTAL-R2V6Y1KN"] = true,
    ["BRUTAL-T7G4P8HW"] = true,
    ["BRUTAL-X9L3D5ZB"] = true,
    ["BRUTAL-N1Q7M4FK"] = true,
    ["BRUTAL-Y6J2S9VA"] = true,
    ["BRUTAL-C4H8W1RN"] = true,
    ["BRUTAL-Z5K3B7MP"] = true,
    ["BRUTAL-F9T6D2XL"] = true,
    ["BRUTAL-V1P4N8QY"] = true,
    ["BRUTAL-G7R3H5JW"] = true,
    ["BRUTAL-B8M1K6SZ"] = true,
    ["BRUTAL-J4X9C2TV"] = true,
    ["BRUTAL-Q6W7F3LD"] = true,
    ["BRUTAL-S2Y5P8HN"] = true,
    ["BRUTAL-L9D4R1KX"] = true,
    ["BRUTAL-H3V7M6BQ"] = true,
    ["BRUTAL-E8N2J5WT"] = true,
    ["BRUTAL-U1C6F9PZ"] = true,
    ["BRUTAL-A5K8L4YH"] = true,
    ["BRUTAL-P7Q2D1NX"] = true,
    ["BRUTAL-IX9W3C6RM"] = true,
    ["BRUTAL-O4H8V5JT"] = true,
    ["BRUTAL-K1M7B2QF"] = true,
    ["BRUTAL-R6T3Z9LD"] = true,
    ["BRUTAL-W2S5P1KH"] = true,
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
    if not VALID_KEYS[key] then
        return false, "Invalid key"
    end

    local data = loadData()
    local boundIds = data[key]

    if not boundIds then
        data[key] = { userId }
        saveData(data)
        return true, "Key activated!"
    end

    for _, id in ipairs(boundIds) do
        if id == userId then
            return true, "Welcome back!"
        end
    end

    if #boundIds >= MAX_ACCOUNTS then
        return false, "Key already used on another account"
    end

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
        if key == "" then
            status.Text = "Enter a key"
            return
        end

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

        btn.MouseButton1Click:Connect(function()
            Library:Toggle()
        end)

        Library:MakeDraggable(btn, btn, true)
    end)
end

local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Watermark = Library:AddDraggableLabel("BRUTALSCRIPT")

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

            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("Frame")
                and obj.AbsolutePosition.X < 250
                and obj.AbsolutePosition.Y < 250
                and obj.AbsoluteSize.X >= 30
                and obj.AbsoluteSize.X <= 50
                and obj.AbsoluteSize.Y >= 30
                and obj.AbsoluteSize.Y <= 50
                and not obj:FindFirstChild("BrutalLogoIcon") then

                    local img = Instance.new("ImageLabel")
                    img.Name = "BrutalLogoIcon"
                    img.Size = UDim2.fromScale(0.9, 0.9)
                    img.Position = UDim2.fromScale(0.05, 0.05)
                    img.BackgroundTransparency = 1
                    img.Image = LOGO_ID
                    img.ZIndex = 50
                    img.Parent = obj
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

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function GetDowned()
local root = getRoot()
if not root then return nil end

local best, dist = nil, math.huge

for _,p in pairs(Players:GetPlayers()) do
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
    if not char then
        return false
    end

local hum = char:FindFirstChildOfClass("Humanoid")
if hum then

    local animator = hum:FindFirstChildOfClass("Animator")

    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do

            local anim = track.Animation

            if anim and anim.AnimationId then

                if anim.AnimationId == "rbxassetid://127096285501517" then
                    return true
                end

                if anim.AnimationId == "rbxassetid://112166042383605" then
                    return true
                end

                if anim.AnimationId == "http://www.roblox.com/asset/?id=126965695851149" then
                    return true
                end

                if anim.AnimationId == "http://www.roblox.com/asset/?id=135084204086504" then
                    return true
                end

                if anim.AnimationId == "rbxassetid://123047897844134" then
                    return true
                end

                local id = anim.AnimationId:match("%d+")

                if id then
                    local fullId = "rbxassetid://" .. id
                    if KillerAnims[fullId] then
                        return true
                    end
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

    WalkSpeedConnection =
        RunService.Heartbeat:Connect(function()

            if not Movement.WalkSpeedEnabled then
                return
            end

            local char = LocalPlayer.Character
            if not char then
                return
            end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then
                return
            end

            if shouldDisableWalkSpeed() then
                return
            end

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
            if Movement.NoClip then
                v.CanCollide = false
            else
                v.CanCollide = true
            end
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
        pcall(function()
            hum.Health = hum.MaxHealth
        end)
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

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    GunAim.Target = nil
    GunAim.Holding = false
    applyCameraFOV()
end)

local ESPObjects = {}
local CachedSCP = {}

for _, obj in ipairs(workspace:GetDescendants()) do
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end

workspace.DescendantAdded:Connect(function(obj)
    local name = string.lower(obj.Name)
    if string.find(name, "scp") then
        CachedSCP[obj] = true
    end
end)

local function removeESP(obj)
    if ESPObjects[obj] then
        ESPObjects[obj]:Destroy()
        ESPObjects[obj] = nil
    end
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
        if not parent then
            removeESP(obj)
        end
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
        local success, val = pcall(function() return child.Value end)
        if success then return val end
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

    local percent =
        GetGameValue(generator, "RepairProgress") or
        GetGameValue(generator, "Progress") or 0

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
        if lbl then
            lbl.Text = text
            lbl.TextColor3 = color
        end
    end

    ApplyGenHighlight(generator, color)
end

local function UpdateMapESP(obj, root)
    if not obj or not root then return end

    local pos
    if obj:IsA("Model") then
        pos = obj:GetPivot().Position
    elseif obj:IsA("BasePart") then
        pos = obj.Position
    end

    if not pos then return end

    local distance = (pos - root.Position).Magnitude

    if obj.Name == "Window" then
        if ESP.Window and distance <= MAX_DISTANCE() then
            createESP(obj, WindowColor)
        else
            removeESP(obj)
        end
    end

    if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        if ESP.Pallet and distance <= MAX_DISTANCE() then
            createESP(obj, PalletColor)
        else
            removeESP(obj)
        end
    end
end

local StatusESP = {}

local function removeStatusESP(char)
    if StatusESP[char] then
        StatusESP[char]:Destroy()
        StatusESP[char] = nil
    end
end

local function createStatusESP(player, char, root)
    if not ESPStatus.Enabled then
        removeStatusESP(char)
        return
    end
    if not root then return end

    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local isDown =
        hum.Health <= 0
        or hum.Health < 2
        or char:GetAttribute("Downed") == true
        or char:GetAttribute("IsDown") == true
        or char:GetAttribute("Knocked") == true

    local dist = (head.Position - root.Position).Magnitude

    if dist > ESPStatus.Radius then
        removeStatusESP(char)
        return
    end

    local text = ""

    if isDown then
        text = "🔻 DOWN\n"
    end

    if ESPStatus.ShowName then
        text = text .. player.Name .. "\n"
    end

    if ESPStatus.ShowDistance then
        text = text .. string.format("Dist: %.0f\n", dist)
    end

    if ESPStatus.ShowHealth then
        text = text .. string.format("HP: %.0f\n", hum.Health)
    end

    if text == "" then
        removeStatusESP(char)
        return
    end

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
            if player.Team.Name == "Killer" then
                teamColor = TeamColors.Killer
            elseif player.Team.Name == "Survivors" then
                teamColor = TeamColors.Survivor
            end
        end

        if isDown then
            teamColor = Color3.fromRGB(255, 0, 0)
        end

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
        if label then
            label.Text = text

            local teamColor = Color3.new(1,1,1)

            if player.Team then
                if player.Team.Name == "Killer" then
                    teamColor = TeamColors.Killer
                elseif player.Team.Name == "Survivors" then
                    teamColor = TeamColors.Survivor
                end
            end

            if isDown then
                teamColor = Color3.fromRGB(255, 0, 0)
            end

            label.TextColor3 = teamColor
        end
    end
end

local function UpdateSCPEsp(root)
    if not ESP.SCP then
        for obj in pairs(CachedSCP) do
            removeESP(obj)
        end
        return
    end

    for obj in pairs(CachedSCP) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then
                pos = obj:GetPivot().Position
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end

            if pos then
                local dist = (pos - root.Position).Magnitude
                if dist <= ESP.Distance then
                    createESP(obj, SCPColor)
                else
                    removeESP(obj)
                end
            end
        end
    end
end

local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil end

    local closest = nil
    local shortest = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and plr.Team
        and plr.Team.Name == "Killer"
        and plr.Character then

            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude

                if dist < shortest then
                    shortest = dist
                    closest = hrp
                end
            end
        end
    end

    return closest, shortest
end

local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end

    local bestPoint = nil
    local farthestDistance = 0

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart")
        and string.match(obj.Name, "^GeneratorPoint%d+$") then

            local dist = (obj.Position - killerRoot.Position).Magnitude

            if dist > farthestDistance then
                farthestDistance = dist
                bestPoint = obj
            end
        end
    end

    return bestPoint
end

local function AutoWiggle()
    if not Auto.Wiggle then return end

    local char = LocalPlayer.Character
    if not char then return end

    local carried =
        (char:FindFirstChild("IsCarried") and char.IsCarried.Value) or
        (char:FindFirstChild("IsCarrying") and char.IsCarrying.Value)

    if not carried then return end

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end

    local carry = remotes:FindFirstChild("Carry")
    if not carry then return end

    local event = carry:FindFirstChild("SelfUnHookEvent")
    if not event then return end

    for i = 1, Auto.WiggleSpam do
        event:FireServer()
    end
end

local lastParry = 0
local PARRY_DEBOUNCE = 0.2

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

        if current and current:IsA("GuiObject") then
            return current
        end
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

    if Moonwalk.Enabled then
        Moonwalk.Enabled = false
    end

    pressParryButton()

    task.delay(0.3, function()
        ParryActive = false
    end)
end

local function isInParryRange(killerChar)
    local myRoot = getRoot()
    if not myRoot or not killerChar then return false end

    local enemyRoot = killerChar:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end

    local dist = (enemyRoot.Position - myRoot.Position).Magnitude
    return dist <= Auto.ParryDistance
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

    if Auto.FaceSensitivity <= -1 then
        return true
    end

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

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestGunTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    local closest = nil
    local shortest = GunAim.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Team then
            local valid = false

            if GunAim.TargetMode == "Killer" and p.Team.Name == "Killer" then
                valid = true
            elseif GunAim.TargetMode == "Survivor" and p.Team.Name == "Survivors" then
                valid = true
            end

            if valid then
                local hrp = p.Character:FindFirstChild(GunAim.AimPart)
                local hum = p.Character:FindFirstChildOfClass("Humanoid")

                if hrp and hum and hum.Health > 0 then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)

                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude

                        if dist < shortest then
                            if GunAim.VisibilityCheck then
                                if not isVisible(hrp) then
                                    continue
                                end
                            end

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
                if obj:IsA("Model") then
                    part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                elseif obj:IsA("BasePart") then
                    part = obj
                end

                if part then
                    local pos, visible = cam:WorldToViewportPoint(part.Position)

                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude

                        if dist < shortest then
                            shortest = dist
                            closest = part
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

    local closest = nil
    local shortest = AttackAim.FOV

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

local GunAimConnection = nil

local function startGunAim()
    if GunAimConnection then return end

    GunAimConnection =
        RunService.RenderStepped:Connect(function()
            if not GunAim.Enabled then
                GunAim.Target = nil
                return
            end

            if not GunAim.Holding then
                GunAim.Target = nil
                return
            end

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

local AttackAimConnection

local function startAttackAim()
    if AttackAimConnection then return end

    AttackAimConnection =
        RunService.RenderStepped:Connect(function()
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

local function isDowned()
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    return hum.Health <= 0
        or hum.Health < 2
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

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if Moonwalk.Enabled then
            stroke.Color = Color3.fromRGB(180, 80, 255)
            if not MoonwalkConnection then
                startMoonwalk()
            end
        else
            stroke.Color = Color3.fromRGB(255,255,255)
            if hum then
                if Movement.WalkSpeedEnabled then
                    hum.WalkSpeed = Movement.WalkSpeedValue
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    end)

    MoonwalkButton = gui
end

local function removeMoonwalkButton()
    if MoonwalkButton then
        MoonwalkButton:Destroy()
        MoonwalkButton = nil
    end
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
        local endRange   = (gr + 116) % 360

        local success =
            (startRange > endRange and (lr >= startRange or lr <= endRange))
            or (lr >= startRange and lr <= endRange)

        if success then
            busy = true

            task.spawn(function()
                if UserInputService.TouchEnabled then
                    TriggerMobileButton()
                else
                    pressSpace()
                end
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
                if dist <= AutoStalk.StalkRange and dist < shortest then
                    shortest = dist
                    closest = plr
                end
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

        if stalkEvent then
            pcall(function()
                stalkEvent:FireServer(target)
            end)
        end
    end)
end

local function stopAutoStalk()
    if StalkConnection then
        StalkConnection:Disconnect()
        StalkConnection = nil
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if not AutoFlee.Enabled then
            continue
        end

        local root = getRoot()
        if not root then continue end

        local killerRoot, distance = GetNearestKiller()

        if killerRoot
        and distance <= AutoFlee.DetectDistance
        and tick() - LastFlee > AutoFlee.Cooldown then

            local point = GetFarthestGeneratorPoint(killerRoot)

            if point then
                LastFlee = tick()
                root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
            end
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
                if d < shortest then
                    shortest = d
                    closest = plr.Character
                end
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

    if CameraZoom.FOVEnabled then
        cam.FieldOfView = CameraZoom.FOV
    else
        cam.FieldOfView = CameraZoom.DefaultFOV
    end
end

local JerkTool = {
    Enabled = false,
    ToolName = "Jerk Off"
}

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
    tool.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's just say. My peanits."
    tool.RequiresHandle = false
    tool.Parent = backpack

    currentJerkTool = tool

    local jorkin = false
    local track = nil

    local function stopTomfoolery()
        jorkin = false
        if track then
            track:Stop()
            track = nil
        end
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
                anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
                track = humanoid:LoadAnimation(anim)
            end

            track:Play()
            track:AdjustSpeed(isR15 and 0.7 or 0.65)
            track.TimePosition = 0.6
            task.wait(0.1)
            while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do
                task.wait(0.1)
            end
            if track then track:Stop() end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if JerkTool.Enabled then
        createJerkTool()
    end
end)

local function teleportToFinishLine()
    local root = getRoot()
    if not root then return end

    local found = nil

    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
            found = obj
            break
        end
    end

    if not found then
        warn("fininshline not found")
        return
    end

    root.CFrame = found.CFrame + Vector3.new(0, 5, 0)
end

local Visual = {
    Fullbright = false,
    NoShadow = false,
    Ambient = false,
    AmbientColor = Color3.fromRGB(255,255,255),
    ClockTimeEnabled = true,
    Brightness = 2,
    ClockTime = 14,
    LowGraphics = false,
    NoFog = false,
    CleanSky = false,
    NoScreenEffects = false
}

local original = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows
}

local LastVisualState = {
    Fullbright = nil,
    NoShadow = nil,
    Ambient = nil,
    AmbientColor = nil,
    Brightness = nil,
    ClockTime = nil
}

local function applyVisual(force)
    if force or LastVisualState.Fullbright ~= Visual.Fullbright then
        LastVisualState.Fullbright = Visual.Fullbright

        if Visual.Fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Color3.new(1,1,1)
        else
            Lighting.Brightness = original.Brightness
            Lighting.ClockTime = original.ClockTime
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient
        end
    end

    if force or LastVisualState.NoShadow ~= Visual.NoShadow then
        LastVisualState.NoShadow = Visual.NoShadow
        Lighting.GlobalShadows = not Visual.NoShadow
    end

    local ambientChanged =
        LastVisualState.Ambient ~= Visual.Ambient
        or LastVisualState.AmbientColor ~= Visual.AmbientColor
        or LastVisualState.Brightness ~= Visual.Brightness
        or LastVisualState.ClockTime ~= Visual.ClockTime

    if force or ambientChanged then
        LastVisualState.Ambient = Visual.Ambient
        LastVisualState.AmbientColor = Visual.AmbientColor
        LastVisualState.Brightness = Visual.Brightness
        LastVisualState.ClockTime = Visual.ClockTime

        if Visual.Ambient then
            Lighting.Ambient = Visual.AmbientColor
            Lighting.OutdoorAmbient = Visual.AmbientColor
            Lighting.Brightness = Visual.Brightness
            Lighting.ClockTime = Visual.ClockTime
        elseif not Visual.Fullbright then
            Lighting.Brightness = original.Brightness
            Lighting.ClockTime = original.ClockTime
            Lighting.Ambient = original.Ambient
            Lighting.OutdoorAmbient = original.OutdoorAmbient
        end
    end
end

local Crosshair = {
    Enabled = false,
    Size = 8,
    Thickness = 2,
    Color = Color3.fromRGB(255,255,255),
    Style = "Plus",
    OffsetX = 0,
    OffsetY = 0
}

local CrosshairDrawings = {}

local function clearCrosshair()
    for _,v in pairs(CrosshairDrawings) do
        if v.Remove then v:Remove() end
    end
    CrosshairDrawings = {}
end

local created = false
local LastCrosshairStyle = nil

local function drawCrosshair()
    if not Crosshair.Enabled then
        for _,v in pairs(CrosshairDrawings) do
            if v then
                v.Visible = false
            end
        end
        return
    end

    if LastCrosshairStyle ~= Crosshair.Style then
        clearCrosshair()
        created = false
        LastCrosshairStyle = Crosshair.Style
    end

    local cam = workspace.CurrentCamera
    local center = Vector2.new(
        cam.ViewportSize.X / 2 + Crosshair.OffsetX,
        cam.ViewportSize.Y / 2 + Crosshair.OffsetY
    )

    if not created then
        created = true

        if Crosshair.Style == "Plus" then
            for i = 1,4 do
                local line = Drawing.new("Line")
                line.Visible = true
                table.insert(CrosshairDrawings, line)
            end
        elseif Crosshair.Style == "Dot" then
            local dot = Drawing.new("Circle")
            dot.Filled = true
            dot.Visible = true
            table.insert(CrosshairDrawings, dot)
        elseif Crosshair.Style == "Circle" then
            local circle = Drawing.new("Circle")
            circle.Filled = false
            circle.Visible = true
            table.insert(CrosshairDrawings, circle)
        end
    end

    if Crosshair.Style == "Plus" then
        for _,line in pairs(CrosshairDrawings) do
            line.Color = Crosshair.Color
            line.Thickness = Crosshair.Thickness
        end

        CrosshairDrawings[1].From = center + Vector2.new(-Crosshair.Size,0)
        CrosshairDrawings[1].To   = center + Vector2.new(-2,0)
        CrosshairDrawings[2].From = center + Vector2.new(Crosshair.Size,0)
        CrosshairDrawings[2].To   = center + Vector2.new(2,0)
        CrosshairDrawings[3].From = center + Vector2.new(0,-Crosshair.Size)
        CrosshairDrawings[3].To   = center + Vector2.new(0,-2)
        CrosshairDrawings[4].From = center + Vector2.new(0,Crosshair.Size)
        CrosshairDrawings[4].To   = center + Vector2.new(0,2)
    elseif Crosshair.Style == "Dot" then
        local dot = CrosshairDrawings[1]
        dot.Position = center
        dot.Radius = Crosshair.Size / 2
        dot.Color = Crosshair.Color
    elseif Crosshair.Style == "Circle" then
        local circle = CrosshairDrawings[1]
        circle.Position = center
        circle.Radius = Crosshair.Size
        circle.Color = Crosshair.Color
        circle.Thickness = Crosshair.Thickness
    end
end

local function updateParryCircle()
    local root = getRoot()

    if not ParryRangeVisual.Enabled or not root then
        if ParryCircle then
            ParryCircle:Destroy()
            ParryCircle = nil
        end
        return
    end

    if not ParryCircle then
        ParryCircle = Instance.new("Part")
        ParryCircle.Shape = Enum.PartType.Cylinder
        ParryCircle.Anchored = true
        ParryCircle.CanCollide = false
        ParryCircle.Material = Enum.Material.Neon
        ParryCircle.Name = "ParryRangeCircle"
        ParryCircle.Parent = workspace
    end

    local size = Auto.ParryDistance * 2
    ParryCircle.Size = Vector3.new(0.2, size, size)
    local yOffset = root.Size.Y / 2 + 1.5

    ParryCircle.CFrame =
        CFrame.new(root.Position - Vector3.new(0, yOffset, 0))
        * CFrame.Angles(0, 0, math.rad(90))

    ParryCircle.Color = ParryRangeVisual.Color
    ParryCircle.Transparency = ParryRangeVisual.Transparency
end

local LastOptimizationState = {
    LowGraphics = nil,
    CleanSky = nil
}

local function applyOptimization(force)
    if force or LastOptimizationState.LowGraphics ~= Visual.LowGraphics then
        LastOptimizationState.LowGraphics = Visual.LowGraphics
        pcall(function()
            if Visual.LowGraphics then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            else
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end
        end)
    end

    if force or LastOptimizationState.CleanSky ~= Visual.CleanSky then
        LastOptimizationState.CleanSky = Visual.CleanSky

        if Visual.CleanSky then
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("Sky") then
                    v:Destroy()
                end
            end
        end
    end
end

local ScreenEffectTypes = {
    "ColorCorrectionEffect",
    "DepthOfFieldEffect",
    "BlurEffect",
    "SunRaysEffect",
    "BloomEffect"
}

local DisabledEffects = {}

local function applyNoScreenEffects()
    if Visual.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            for _, t in pairs(ScreenEffectTypes) do
                if v:IsA(t) then
                    DisabledEffects[v] = v.Enabled
                    v.Enabled = false
                end
            end
        end
    else
        for obj, state in pairs(DisabledEffects) do
            if obj and obj.Parent then
                obj.Enabled = state
            end
        end
        DisabledEffects = {}
    end
end

Lighting.ChildAdded:Connect(function(v)
    if not Visual.NoScreenEffects then return end
    task.wait()
    for _, t in pairs(ScreenEffectTypes) do
        if v:IsA(t) then
            DisabledEffects[v] = v.Enabled
            v.Enabled = false
        end
    end
end)

local Cached = {
    Generators = {},
    Windows = {},
    Pallets = {}
}

local function cacheObject(obj)
    if obj.Name == "Generator" then
        Cached.Generators[obj] = true
    elseif obj.Name == "Window" then
        Cached.Windows[obj] = true
    elseif obj.Name == "Pallet" or obj.Name == "Palletwrong" then
        Cached.Pallets[obj] = true
    end
end

local function removeCache(obj)
    Cached.Generators[obj] = nil
    Cached.Windows[obj] = nil
    Cached.Pallets[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    cacheObject(obj)
end

workspace.DescendantAdded:Connect(cacheObject)
workspace.DescendantRemoving:Connect(removeCache)

local Emote = {
    Selected = "Mannrobics"
}

local EmoteButton = {
    Show = false,
    GuiInstance = nil
}

local EmoteList = {
    "Mannrobics",
    "Arm Swing",
    "Schadenfreude",
    "Kyoufuu",
    "Backflip",
    "Griddy",
    "Friday Night",
    "Floating Rest",
    "OnePlays",
    "Quick Combo",
    "WarCry",
    "Wave"
}

local EmoteRemote =
    ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("EmoteHandler")

local function playEmote(name)
    pcall(function()
        EmoteRemote:FireServer(name)
    end)
end

local function createEmoteButton()
    if EmoteButton.GuiInstance then
        EmoteButton.GuiInstance:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "EmoteButtonGui"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.55, 0, 0.75, 0)
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 20)
    label.Position = UDim2.new(0.5, -50, -0.6, 0)
    label.BackgroundTransparency = 1
    label.Text = Emote.Selected
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = btn

    btn.MouseButton1Click:Connect(function()
        playEmote(Emote.Selected)

        stroke.Color = Color3.fromRGB(180, 80, 255)
        task.delay(0.3, function()
            stroke.Color = Color3.fromRGB(255, 255, 255)
        end)
    end)

    EmoteButton.GuiInstance = gui
    EmoteButton.LabelRef = label
end

local function removeEmoteButton()
    if EmoteButton.GuiInstance then
        EmoteButton.GuiInstance:Destroy()
        EmoteButton.GuiInstance = nil
        EmoteButton.LabelRef = nil
    end
end

local lastESPUpdate = 0
local lastKillerUpdate = 0
local lastGodMode = 0

RunService.Heartbeat:Connect(function()
    local now = tick()

    if now - lastGodMode >= 0.1 then
        lastGodMode = now
        applyGodMode()
        AutoWiggle()
    end

    if now - lastKillerUpdate >= 0.05 then
        lastKillerUpdate = now

        if Killer.AutoAttack then
            pcall(function()
                AttackEvent:FireServer(false)
            end)
        end

        if Killer.AutoCarry and not KillerBusy then
            KillerBusy = true
            local target = GetDowned()
            local root = getRoot()

            if target and root then
                local tRoot = target:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 3, -2)
                    task.wait(0.4)
                    for i = 1, 4 do
                        CarryEvent:FireServer(target)
                        task.wait(0.2)
                    end
                    task.wait(0.6)
                    local hook = GetHook()
                    if hook then
                        root.CFrame = hook.CFrame * CFrame.new(0, 4, -3)
                        task.wait(0.7)
                        for i = 1, 6 do
                            HookEvent:FireServer(hook)
                            task.wait(0.15)
                        end
                    end
                end
            end

            task.delay(2, function() KillerBusy = false end)
        end

        if Killer.KillAll then
            local root = getRoot()
            if root then
                if not KillerTarget
                or not KillerTarget:FindFirstChild("Humanoid")
                or KillerTarget.Humanoid.Health <= 35 then
                    KillerTarget = GetNearestAliveSurvivor()
                end

                if KillerTarget then
                    local targetHRP = KillerTarget:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local velocity = targetHRP.AssemblyLinearVelocity
                        local predict = velocity * 0.15
                        local targetPos = targetHRP.Position + predict
                        local behind = targetHRP.CFrame.LookVector * -3
                        root.CFrame = CFrame.new(targetPos + behind, targetPos)
                    end
                    pcall(function() AttackEvent:FireServer(false) end)
                end
            end
        end

        if Movement.WalkSpeedEnabled and not Moonwalk.Enabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if shouldDisableWalkSpeed() then
                    if hum.WalkSpeed == Movement.WalkSpeedValue then
                        hum.WalkSpeed = Movement.OriginalWalkSpeed
                    end
                else
                    if hum.WalkSpeed ~= Movement.WalkSpeedValue then
                        hum.WalkSpeed = Movement.WalkSpeedValue
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local root = getRoot()
    if not root then return end

    local now = tick()

    if now - lastESPUpdate >= 0.05 then
        lastESPUpdate = now

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")

                if hum and hum.Health > 0 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - root.Position).Magnitude
                        if distance <= ESP.Distance then
                            if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                                createESP(char, TeamColors.Survivor)
                            elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                                createESP(char, TeamColors.Killer)
                            else
                                removeESP(char)
                            end
                        else
                            removeESP(char)
                        end
                    end
                    createStatusESP(p, char, root)
                else
                    removeESP(char)
                end
            end
        end

        if ESP.Generator then
            for gen in pairs(Cached.Generators) do
                UpdateGenerator(gen)
            end
        end

        for obj in pairs(Cached.Windows) do UpdateMapESP(obj, root) end
        for obj in pairs(Cached.Pallets) do UpdateMapESP(obj, root) end

        UpdateSCPEsp(root)
        applyVisual()
        applyNoScreenEffects()
        updateParryCircle()
    end

    drawCrosshair()

    if Moonwalk.Enabled and not ParryActive and not isDowned() then
        local char = LocalPlayer.Character
        if char and char.Parent then
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

                local lookDir
                if flatMove.Magnitude > 0.05 then
                    lookDir = flatMove.Unit
                else
                    local look = cam.CFrame.LookVector
                    lookDir = Vector3.new(look.X, 0, look.Z)
                    if lookDir.Magnitude > 0 then
                        lookDir = lookDir.Unit
                    end
                end

                if lookDir and lookDir.Magnitude > 0 then
                    local baseCF = CFrame.new(hrp.Position, hrp.Position - lookDir)
                    local angle = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
                    local finalCF = baseCF * CFrame.Angles(0, math.rad(angle), 0)
                    local targetRotation = CFrame.new(hrp.Position) * (finalCF - finalCF.Position)
                    hrp.CFrame = hrp.CFrame:Lerp(targetRotation, 0.25)
                end
            end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid.AutoRotate then
                humanoid.AutoRotate = true
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if CameraZoom.FOVEnabled then
        local cam = workspace.CurrentCamera
        if cam and cam.FieldOfView ~= CameraZoom.FOV then
            cam.FieldOfView = CameraZoom.FOV
        end
    end
end)

local FastVault = {
    Enabled = false,
    Speed = 1.2,
    ReplaceMap = {
        ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779"
    }
}

local VaultTracks = {}

local function normalizeId(id)
    local num = tostring(id):match("%d+")
    return num and ("rbxassetid://" .. num)
end

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not FastVault.Enabled then return end

        local anim = track.Animation
        if not anim or not anim.AnimationId then return end

        local id = normalizeId(anim.AnimationId)
        if not id then return end

        local replaceId = FastVault.ReplaceMap[id]
        if not replaceId then return end

        if VaultTracks[track] then return end
        VaultTracks[track] = true

        track:Stop()

        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId

        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play()
        newTrack:AdjustSpeed(FastVault.Speed)

        newTrack.Stopped:Connect(function()
            VaultTracks[track] = nil
        end)
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyUnlimitedZoom()
    hookVault(char)
end)

if LocalPlayer.Character then
    hookVault(LocalPlayer.Character)
    startGunAim()
end

task.spawn(function()
    while true do
        task.wait(0.8)

        if Auto.Parry then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                    hookKiller(p.Character)
                end
            end
        end
    end
end)

InfoBox:AddLabel("Script: BRUTALSCRIPT")
InfoBox:AddLabel("Version: 1.0.0")
InfoBox:AddLabel("Game: Violence District")
InfoBox:AddLabel("Dev: BRUTALSCRIPT TEAM")
InfoBox:AddLabel("Key bound to account")

CreditsBox:AddLabel("Developer:")
CreditsBox:AddLabel("• BRUTALSCRIPT")
CreditsBox:AddDivider()
CreditsBox:AddLabel("Library:")
CreditsBox:AddLabel("• Obsidian UI")

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

ESPGeneratorToggle:AddColorPicker("GeneratorColor", {
    Default = GeneratorColor,
    Title = "Generator Color",
    Callback = function(v) GeneratorColor = v end
})

local ESPSCPToggle = ESPBox:AddCheckbox("ESPSCP", {
    Text = "SCP",
    Default = false,
    Callback = function(v) ESP.SCP = v end
})

ESPSCPToggle:AddColorPicker("SCPColor", {
    Default = SCPColor,
    Title = "SCP Color",
    Callback = function(v) SCPColor = v end
})

local ESPPalletToggle = ESPBox:AddCheckbox("ESPPallet", {
    Text = "Pallet",
    Default = false,
    Callback = function(v) ESP.Pallet = v end
})

ESPPalletToggle:AddColorPicker("PalletColor", {
    Default = PalletColor,
    Title = "Pallet Color",
    Callback = function(v) PalletColor = v end
})

local ESPWindowToggle = ESPBox:AddCheckbox("ESPWindow", {
    Text = "Window",
    Default = false,
    Callback = function(v) ESP.Window = v end
})

ESPWindowToggle:AddColorPicker("WindowColor", {
    Default = WindowColor,
    Title = "Window Color",
    Callback = function(v) WindowColor = v end
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

local CrosshairToggle = CrosshairBox:AddCheckbox("CrosshairEnabled", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(v) Crosshair.Enabled = v end
})

CrosshairToggle:AddColorPicker("CrosshairColor", {
    Default = Color3.fromRGB(255,255,255),
    Title = "Crosshair Color",
    Transparency = 0,
    Callback = function(color) Crosshair.Color = color end
})

CrosshairBox:AddDropdown("Style", {
    Values = {"Plus","Dot","Circle"},
    Default = 1,
    Multi = false,
    Text = "Style",
    Callback = function(v) Crosshair.Style = v end
})

CrosshairBox:AddSlider("CrosshairPosX", {
    Text = "Position X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Callback = function(v) Crosshair.OffsetX = v end
})

CrosshairBox:AddSlider("CrosshairPosY", {
    Text = "Position Y",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 0,
    Callback = function(v) Crosshair.OffsetY = v end
})

AbilityTab:AddCheckbox("Skill", {
    Text = "Auto Skill Check",
    Default = false,
    Callback = function(v)
        Auto.SkillCheck = v
        if v then startSkillCheck() end
    end
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

AbilityTab:AddCheckbox("FastVault", {
    Text = "Fast Vault",
    Default = false,
    Callback = function(v) FastVault.Enabled = v end
})

AbilityTab:AddSlider("VaultSpeed", {
    Text = "Animation Speed",
    Default = 1.2,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(v) FastVault.Speed = v end
})

AbilityTab:AddDivider()

AbilityTab:AddCheckbox("MoonwalkButton", {
    Text = "MoonwalkButton",
    Default = false,
    Callback = function(v)
        Moonwalk.ShowButton = v
        if v then
            createMoonwalkButton()
        else
            removeMoonwalkButton()
        end
    end
})

AbilityTab:AddLabel("Moonwalk Keybind"):AddKeyPicker("MoonwalkKey", {
    Default = "V",
    Mode = "Toggle",
    Text = "Moonwalk (pc)",
    Callback = function(state)
        Moonwalk.Enabled = state

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if state then
            startMoonwalk()
        else
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
})

AbilityTab:AddSlider("MoonwalkSpamSpeed", {
    Text = "Spam Speed",
    Default = Moonwalk.SpamSpeed,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(Value) Moonwalk.SpamSpeed = Value end
})

AbilityTab:AddSlider("MoonwalkIntensity", {
    Text = "Intensity",
    Default = Moonwalk.Intensity,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value) Moonwalk.Intensity = Value end
})

AbilityTab:AddButton({
    Text = "instant escape",
    Func = function()
        teleportToFinishLine()
    end
})

KillerTab:AddCheckbox("AutoStalk", {
    Text = "Auto Stalk",
    Default = false,
    Callback = function(v)
        AutoStalk.Enabled = v
        if v then
            startAutoStalk()
        else
            stopAutoStalk()
        end
    end
})

KillerTab:AddCheckbox("AttackAim", {
    Text = "AimLock Attack",
    Default = false,
    Callback = function(v)
        AttackAim.Enabled = v
        if v then
            startAttackAim()
        end
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

    if Event then
        Event:FireServer(Masked.CurrentPower)
    end
end)

KillerTab:AddButton("Deactivate Power", function()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")

    if Event then
        Event:FireServer()
    end
end)

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
        if ParryCircle then
            ParryCircle.Color = color
        end
    end
})

ParryBox:AddCheckbox("ShowParryRange", {
    Text = "Show Parry Range",
    Default = true,
    Callback = function(Value)
        ParryRangeVisual.Enabled = Value
        if not Value and ParryCircle then
            ParryCircle:Destroy()
            ParryCircle = nil
        end
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

AimlockBox:AddToggle("GunAimEnabled", {
    Text = "Aim Lock",
    Default = false,
    Callback = function(v) GunAim.Enabled = v end
})

AimlockBox:AddDropdown("GunAimTarget", {
    Values = { "Killer", "Survivor", "SCP" },
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

MovementBox:AddCheckbox("WalkSpeedToggle", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(v)
        Movement.WalkSpeedEnabled = v
        if v then
            applyWalkSpeed()
        else
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Movement.OriginalWalkSpeed
            end
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
        if Movement.WalkSpeedEnabled then
            applyWalkSpeed()
        end
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
        if v then
            applyJumpPower()
        else
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = Movement.OriginalJumpPower
            end
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
        if Movement.JumpPowerEnabled then
            applyJumpPower()
        end
    end
})

EmoteBox:AddDropdown("SelectEmote", {
    Values = EmoteList,
    Default = 1,
    Multi = false,
    Text = "Select Emote",
    Callback = function(v)
        Emote.Selected = v
        if EmoteButton.LabelRef then
            EmoteButton.LabelRef.Text = v
        end
    end
})

EmoteBox:AddButton({
    Text = "Play Emote",
    Func = function()
        playEmote(Emote.Selected)
    end
})

EmoteBox:AddToggle("ShowEmoteButton", {
    Text = "Show Emote Button",
    Default = false,
    Callback = function(v)
        EmoteButton.Show = v
        if v then
            createEmoteButton()
        else
            removeEmoteButton()
        end
    end
})

FunBox:AddToggle("JerkTool", {
    Text = "Jerk Tool",
    Default = false,
    Callback = function(v)
        JerkTool.Enabled = v
        if v then
            createJerkTool()
        else
            if currentJerkTool then
                currentJerkTool:Destroy()
                currentJerkTool = nil
            end
        end
    end
})

VisualBox:AddCheckbox("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(v)
        Visual.Fullbright = v
        applyVisual()
    end
})

VisualBox:AddCheckbox("NoShadow", {
    Text = "No Shadow",
    Default = false,
    Callback = function(v) Visual.NoShadow = v end
})

VisualBox:AddCheckbox("LowGraphics", {
    Text = "Low Graphics",
    Default = false,
    Callback = function(v)
        Visual.LowGraphics = v
        applyOptimization()
    end
})

VisualBox:AddCheckbox("NoScreenEffects", {
    Text = "No Screen Effects",
    Default = false,
    Callback = function(v)
        Visual.NoScreenEffects = v
        applyNoScreenEffects()
    end
})

VisualBox:AddCheckbox("CleanSky", {
    Text = "Clean Sky",
    Default = false,
    Callback = function(v)
        Visual.CleanSky = v
        applyOptimization()
    end
})

ZoomBox:AddToggle("UnlimitedZoom", {
    Text = "Unlimited Zoom Out",
    Default = false,
    Callback = function(v)
        CameraZoom.UnlimitedZoom = v
        applyUnlimitedZoom()
    end
})

ZoomBox:AddSlider("MaxZoomDistance", {
    Text = "Max Zoom Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Callback = function(v)
        CameraZoom.MaxDistance = v
        if CameraZoom.UnlimitedZoom then
            applyUnlimitedZoom()
        end
    end
})

ZoomBox:AddToggle("CustomFOV", {
    Text = "Custom FOV",
    Default = false,
    Callback = function(Value)
        CameraZoom.FOVEnabled = Value
        applyCameraFOV()
    end
})

ZoomBox:AddSlider("CameraFOV", {
    Text = "Camera FOV",
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        CameraZoom.FOV = Value
        if CameraZoom.FOVEnabled then
            applyCameraFOV()
        end
    end
})

TimeBox:AddSlider("ClockTime", {
    Text = "Clock Time",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(v)
        Visual.ClockTime = v
        Visual.Ambient = true
        applyVisual()
    end
})

TimeBox:AddSlider("Brightness", {
    Text = "Brightness",
    Default = 2,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Callback = function(v)
        Visual.Brightness = v
        Visual.Ambient = true
        applyVisual()
    end
})

SettingBox:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = not IS_MOBILE,
    Callback = function(Value) Library.ShowCustomCursor = Value end
})

SettingBox:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = IS_MOBILE and "Left" or "Right",
    Text = "Notification Side",
    Callback = function(Value) Library:SetNotifySide(Value) end
})

SettingBox:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "85%", "100%", "125%", "150%" },
    Default = "85%%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end
})

SettingBox:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value) Window:SetCornerRadius(value) end
})

SettingBox:AddToggle("WatermarkToggle", {
    Text = "Watermark",
    Default = true,
    Callback = function(Value) Watermark.Visible = Value end
})

SettingBox:AddDivider()

SettingBox:AddButton("Join Discord", function()
    setclipboard("https://discord.gg/3kmTx8Aeew")
    Library:Notify({
        Title = "link discord telah di copy!!",
        Duration = 6
    })
end)

SettingBox:AddButton("Unload script", function()
    Library:Unload()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("BRUTALSCRIPT")
SaveManager:SetFolder("BRUTALSCRIPT/configs")
SaveManager:BuildConfigSection(Tabs.UISettings)
