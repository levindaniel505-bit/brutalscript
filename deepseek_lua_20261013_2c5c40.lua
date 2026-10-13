local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local PLAYER_ESP = true
local GENERATOR_ESP = true

local PLAYER_COLOR = Color3.fromRGB(255, 60, 60)
local GENERATOR_COLOR = Color3.fromRGB(255, 255, 0)

local playerHighlights = {}
local generatorHighlights = {}

local function createHighlight(adornee, color)
    local h = Instance.new("Highlight")
    h.Adornee = adornee
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.55
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

local function updatePlayerESP()
    if not PLAYER_ESP then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end

        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if char and root and humanoid and humanoid.Health > 0 then
            if not playerHighlights[plr] then
                local h = createHighlight(char, PLAYER_COLOR)
                local bg, label = createBillboard(root, plr.Name, PLAYER_COLOR)
                playerHighlights[plr] = { Highlight = h, Billboard = bg, Label = label, Char = char }
            else
                local esp = playerHighlights[plr]
                if esp.Char ~= char then
                    esp.Billboard.Adornee = root
                    esp.Highlight.Adornee = char
                    esp.Char = char
                end
            end
        else
            if playerHighlights[plr] then
                if playerHighlights[plr].Highlight then playerHighlights[plr].Highlight:Destroy() end
                if playerHighlights[plr].Billboard then playerHighlights[plr].Billboard:Destroy() end
                playerHighlights[plr] = nil
            end
        end
    end
end

local function isGenerator(obj)
    local name = obj.Name:lower()
    return name:find("generator") or name:find("palka") or name:find("gen")
end

local function updateGeneratorESP()
    if not GENERATOR_ESP then return end

    for obj, esp in pairs(generatorHighlights) do
        if not obj.Parent then
            if esp.Highlight then esp.Highlight:Destroy() end
            if esp.Billboard then esp.Billboard:Destroy() end
            generatorHighlights[obj] = nil
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isGenerator(obj) and not generatorHighlights[obj] then
            local adornee = obj
            if obj:IsA("Model") and obj.PrimaryPart then
                adornee = obj.PrimaryPart
            elseif obj:IsA("BasePart") then
                adornee = obj
            else
                continue
            end

            local h = createHighlight(obj, GENERATOR_COLOR)
            local bg, label = createBillboard(adornee, "GENERATOR", GENERATOR_COLOR)
            generatorHighlights[obj] = { Highlight = h, Billboard = bg, Label = label }
        end
    end
end

RunService.RenderStepped:Connect(updatePlayerESP)

task.spawn(function()
    while task.wait(3) do
        updateGeneratorESP()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerHighlights[plr] then
        if playerHighlights[plr].Highlight then playerHighlights[plr].Highlight:Destroy() end
        if playerHighlights[plr].Billboard then playerHighlights[plr].Billboard:Destroy() end
        playerHighlights[plr] = nil
    end
end)

print("[ESP] loaded")