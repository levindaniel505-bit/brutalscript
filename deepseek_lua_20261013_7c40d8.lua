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
local PALLET_COLOR = Color3.fromRGB(0, 255, 255)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 0)

local killerESP = {}
local palletESP = {}
local generatorESP = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyScriptMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.Text = "Brutal Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. "  [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. "  [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
        else
            btn.Text = text .. "  [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
        callback(state)
    end)
end

local function createColorButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 128, 0)
        }
        local idx = 1
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not btn.Parent then conn:Disconnect() end
        end)
        idx = (idx % #colors) + 1
        callback(colors[idx])
        btn.Text = text .. " (нажми ещё)"
    end)
end

local function createHighlight(adornee, color)
    local h = Instance.new("Highlight")
    h.Adornee = adornee
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
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

local function isKiller(plr)
    return plr.Team ~= nil and plr.Team.Name:lower():find("killer")
end

local function isPallet(obj)
    local n = obj.Name:lower()
    return n:find("pallet") or n:find("pallet") or n:find("паллет") or n:find("palka")
end

local function isGenerator(obj)
    local n = obj.Name:lower()
    return n:find("generator") or n:find("gen") or n:find("генератор")
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
                local bg, label = createBillboard(root, plr.Name .. " [KILLER]", KILLER_COLOR)
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
    if not ESP_PALLET then return end
    for obj, esp in pairs(palletESP) do
        if not obj.Parent then
            esp.h:Destroy()
            esp.bg:Destroy()
            palletESP[obj] = nil
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isPallet(obj) and not palletESP[obj] then
            local adornee = obj
            if obj:IsA("Model") and obj.PrimaryPart then adornee = obj.PrimaryPart
            elseif obj:IsA("BasePart") then adornee = obj
            else continue end
            local h = createHighlight(obj, PALLET_COLOR)
            local bg, label = createBillboard(adornee, "PALLET", PALLET_COLOR)
            palletESP[obj] = { h = h, bg = bg, label = label }
        end
    end
end

local function updateGeneratorESP()
    if not ESP_GENERATOR then return end
    for obj, esp in pairs(generatorESP) do
        if not obj.Parent then
            esp.h:Destroy()
            esp.bg:Destroy()
            generatorESP[obj] = nil
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isGenerator(obj) and not generatorESP[obj] then
            local adornee = obj
            if obj:IsA("Model") and obj.PrimaryPart then adornee = obj.PrimaryPart
            elseif obj:IsA("BasePart") then adornee = obj
            else continue end
            local h = createHighlight(obj, GENERATOR_COLOR)
            local bg, label = createBillboard(adornee, "GENERATOR", GENERATOR_COLOR)
            generatorESP[obj] = { h = h, bg = bg, label = label }
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
    updatePalletESP()
    updateGeneratorESP()
end)

createToggle("ESP Убийцы", function(v) ESP_KILLER = v end)
createColorButton("Цвет Убийцы", function(c) KILLER_COLOR = c end)

createToggle("ESP Палеток", function(v) ESP_PALLET = v end)
createColorButton("Цвет Палеток", function(c) PALLET_COLOR = c end)

createToggle("ESP Генераторов", function(v) ESP_GENERATOR = v end)
createColorButton("Цвет Генераторов", function(c) GENERATOR_COLOR = c end)

createToggle("Fly (WASD + Space/Ctrl)", function(v) toggleFly(v) end)

print("[Brutal Script] loaded")