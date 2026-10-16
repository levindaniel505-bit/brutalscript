local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

Library.Scheme.AccentColor     = Color3.fromRGB(60, 160, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(12, 12, 12)
Library.Scheme.MainColor       = Color3.fromRGB(35, 35, 35)
Library.Scheme.OutlineColor    = Color3.fromRGB(60, 160, 255)
Library.Scheme.FontColor       = Color3.fromRGB(240, 240, 240)

local LOGO_ID = "rbxassetid://83643298666145"
local IS_MOBILE = game:GetService("UserInputService").TouchEnabled

local Window = Library:CreateWindow({
    Title = "EVADE",
    Footer = "Evade - Violence District",
    Icon = LOGO_ID,
    IconSize = UDim2.fromOffset(40, 40),
    CornerRadius = 12,
    NotifySide = "Right",
    ShowCustomCursor = true,
    ToggleKeybind = Enum.KeyCode.RightShift,
    Size = UDim2.fromOffset(450, 350),
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Tab = Window:AddTab("Evade", "shield")
local Box = Tab:AddLeftGroupbox("Evade", "shield")

-- ============== EVADE STATE ==============
local Evade = {
    Enabled = false,
    Side = "Auto",
    Distance = 12,
    Speed = 55,
    Duration = 0.22,
    Cooldown = 0.3,
    Range = 12,
    Active = false,
    LastTime = 0,
    LastSide = 1,
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

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
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

-- ============== РЕАЛЬНЫЙ УВОРОТ ЧЕРЕЗ ХОДЬБУ ==============
local function performDodge(killerRoot)
    local myRoot = getRoot()
    local hum = getHum()
    if not myRoot or not hum or not killerRoot then return end

    Evade.Active = true

    local toKiller = killerRoot.Position - myRoot.Position
    local flatToKiller = Vector3.new(toKiller.X, 0, toKiller.Z)
    if flatToKiller.Magnitude < 0.01 then flatToKiller = Vector3.new(0, 0, -1) end
    flatToKiller = flatToKiller.Unit

    local right = Vector3.new(-flatToKiller.Z, 0, flatToKiller.X)

    local sideSign
    if Evade.Side == "Auto" then
        sideSign = -Evade.LastSide
    elseif Evade.Side == "Right" then
        sideSign = 1
    else
        sideSign = -1
    end
    Evade.LastSide = sideSign

    local dodgeDir = right * sideSign

    local myPos = myRoot.Position
    local targetPos = myPos + dodgeDir * Evade.Distance
    targetPos = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = { LocalPlayer.Character }

    local function isFree(pos)
        local origin = pos + Vector3.new(0, 3, 0)
        local result = workspace:Raycast(origin, Vector3.new(0, -6, 0), rayParams)
        return result ~= nil
    end

    if not isFree(targetPos) then
        targetPos = myPos - dodgeDir * Evade.Distance
        targetPos = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
        if not isFree(targetPos) then
            Evade.Active = false
            return
        end
    end

    local origSpeed = hum.WalkSpeed
    local origAutoRotate = hum.AutoRotate

    hum.WalkSpeed = Evade.Speed
    hum.AutoRotate = false

    local look = killerRoot.Position - myPos
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude > 0.01 then
        myRoot.CFrame = CFrame.new(myPos, myPos + look.Unit)
    end

    local startTick = tick()
    while tick() - startTick < Evade.Duration do
        if not myRoot.Parent or not hum.Parent then break end
        local cur = myRoot.Position
        local rem = Vector3.new(targetPos.X - cur.X, 0, targetPos.Z - cur.Z)
        if rem.Magnitude < 0.4 then break end
        hum:Move(rem.Unit)
        RunService.RenderStepped:Wait()
    end
    hum:Move(Vector3.zero)

    task.wait(0.03)

    if hum and hum.Parent then
        hum.WalkSpeed = origSpeed
        hum.AutoRotate = origAutoRotate
    end

    Evade.Active = false
end

-- ============== ХУК НА АНИМАЦИИ УДАРОВ КИЛЛЕРОВ ==============
local hookedKillers = {}

local function hookKillerForEvade(char)
    if hookedKillers[char] then return end
    hookedKillers[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = hum:WaitForChild("Animator", 5)
        if not animator then return end
    end

    animator.AnimationPlayed:Connect(function(track)
        if not Evade.Enabled or Evade.Active then return end

        local now = tick()
        if now - Evade.LastTime < Evade.Cooldown then return end

        local anim = track.Animation
        if not anim then return end
        local id = anim.AnimationId:match("%d+")
        if not id then return end
        local fullId = "rbxassetid://" .. id

        if not KillerAnims[fullId] then return end

        local killerRoot = char:FindFirstChild("HumanoidRootPart")
        local myRoot = getRoot()
        if not killerRoot or not myRoot then return end

        local dist = (killerRoot.Position - myRoot.Position).Magnitude
        if dist > Evade.Range then return end

        Evade.LastTime = now
        task.spawn(function()
            performDodge(killerRoot)
        end)
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if Evade.Enabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                    hookKillerForEvade(p.Character)
                end
            end
        end
    end
end)

-- ============== UI ==============
Box:AddLabel("Evade Keybind"):AddKeyPicker("EvadeBind", {
    Default = "Z",
    Mode = "Toggle",
    Text = "Evade (toggle)",
    Callback = function(state)
        Evade.Enabled = state
        Library:Notify({
            Title = state and "Evade ON" or "Evade OFF",
            Duration = 1.5
        })
    end
})

Box:AddCheckbox("EvadeEnable", {
    Text = "Evade",
    Default = false,
    Callback = function(v)
        Evade.Enabled = v
        Library:Notify({
            Title = v and "Evade ON" or "Evade OFF",
            Duration = 1.5
        })
    end
})

Box:AddDropdown("EvadeSide", {
    Text = "Dodge Side",
    Values = { "Auto", "Left", "Right" },
    Default = 1,
    Multi = false,
    Callback = function(v) Evade.Side = v end
})

Box:AddSlider("EvadeDistance", {
    Text = "Dodge Distance",
    Default = 12,
    Min = 5,
    Max = 25,
    Rounding = 0,
    Callback = function(v) Evade.Distance = v end
})

Box:AddSlider("EvadeSpeed", {
    Text = "Dodge Speed",
    Default = 55,
    Min = 25,
    Max = 100,
    Rounding = 0,
    Callback = function(v) Evade.Speed = v end
})

Box:AddSlider("EvadeDuration", {
    Text = "Dodge Duration",
    Default = 0.22,
    Min = 0.1,
    Max = 0.5,
    Rounding = 2,
    Callback = function(v) Evade.Duration = v end
})

Box:AddSlider("EvadeCooldown", {
    Text = "Cooldown",
    Default = 0.3,
    Min = 0.1,
    Max = 1,
    Rounding = 2,
    Callback = function(v) Evade.Cooldown = v end
})

Box:AddSlider("EvadeRange", {
    Text = "Reaction Range",
    Default = 12,
    Min = 5,
    Max = 25,
    Rounding = 0,
    Callback = function(v) Evade.Range = v end
})
