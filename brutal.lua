-- ================= LOADING SCREEN =================
local LOGO_ID = "rbxassetid://83643298666145"

local function ShowLoadingBar()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BrutalLoading"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game:GetService("CoreGui")

    local container = Instance.new("Frame")
    container.Size = UDim2.fromOffset(320, 100)
    container.Position = UDim2.new(0.5, -160, 0.5, -50)
    container.BackgroundTransparency = 1
    container.Parent = gui

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromOffset(280, 36)
    bar.Position = UDim2.new(0.5, -140, 0, 0)
    bar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    bar.BackgroundTransparency = 0.15
    bar.BorderSizePixel = 0
    bar.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = bar

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = bar

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BRUTALSCRIPT"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = bar

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.fromOffset(280, 4)
    progressBg.Position = UDim2.new(0.5, -140, 0, 44)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = container

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressBg

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg

    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(1, 0)
    progressFillCorner.Parent = progressFill

    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 18)
    percentLabel.Position = UDim2.new(0, 0, 0, 54)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 13
    percentLabel.TextStrokeTransparency = 0.5
    percentLabel.Parent = container

    return gui, label, progressFill, percentLabel, bar, stroke, progressBg, progressFill
end

local loadingGui, loadingLabel, progressFill, percentLabel, loadingBar, loadingStroke, loadingProgressBg, loadingProgressFill = ShowLoadingBar()

-- Загрузка с ЖЁСТКИМ ТАЙМАУТОМ. Обязательно завершится максимум через 6 секунд.
task.spawn(function()
    local startTime = tick()
    local softDuration = 4.0
    local maxDuration = 6.0  -- жёсткий лимит
    local i = 0

    while true do
        i += 1

        local pulse = 0.5 + 0.5 * math.sin(i * 0.12)
        loadingLabel.TextTransparency = 1 - pulse
        loadingLabel.TextStrokeTransparency = 0.4 + (1 - pulse) * 0.4

        local elapsed = tick() - startTime
        local progress

        if elapsed >= maxDuration then
            progress = 1
        else
            local raw = math.min(elapsed / softDuration, 1)
            local eased = raw < 0.5 and 2 * raw * raw or 1 - ((-2 * raw + 2) ^ 2) / 2
            progress = math.min(eased, 0.99)

            if elapsed >= maxDuration - 0.5 then
                progress = 1
            end
        end

        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        percentLabel.Text = math.floor(progress * 100) .. "%"

        if progress >= 1 then
            break
        end

        task.wait(0.03)
    end

    -- Плавное исчезание загрузки
    local fadeDur = 0.4
    local t0 = tick()
    while tick() - t0 < fadeDur do
        local a = (tick() - t0) / fadeDur

        loadingLabel.TextTransparency = a
        loadingLabel.TextStrokeTransparency = a
        percentLabel.TextTransparency = a
        loadingBar.BackgroundTransparency = 0.15 + 0.85 * a
        loadingStroke.Transparency = 0.3 + 0.7 * a
        loadingProgressBg.BackgroundTransparency = a
        loadingProgressFill.BackgroundTransparency = a

        task.wait()
    end

    loadingGui:Destroy()
end)

-- ================= MAIN SCRIPT =================
-- ... дальше идёт твой скрипт с CreateWindow и всем остальным
