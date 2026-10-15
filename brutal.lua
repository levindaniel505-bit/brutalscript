if Moonwalk.Enabled and not ParryActive and not isDowned() then
    local char = LocalPlayer.Character
    if char and char.Parent then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if humanoid and hrp then
            if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
                humanoid.WalkSpeed = Moonwalk.SlowSpeed
            end

            if humanoid.AutoRotate then
                humanoid.AutoRotate = false
            end

            local moveDir = humanoid.MoveDirection
            local flatMove = Vector3.new(moveDir.X, 0, moveDir.Z)

            if flatMove.Magnitude > 0.05 then
                -- Тело смотрит ПРОТИВ движения (спиной вперёд = moonwalk)
                local baseDir = -flatMove.Unit

                -- Колебание вправо-влево (синусоида)
                local swingAngle = math.sin(tick() * Moonwalk.SpamSpeed) * Moonwalk.Intensity
                local swingRad = math.rad(swingAngle)

                -- Строим CFrame: спиной по движению + болтание
                local baseCF = CFrame.new(hrp.Position, hrp.Position + baseDir)
                local swungCF = baseCF * CFrame.Angles(0, swingRad, 0)

                -- Оставляем rotation, позицию берём из текущего HRP
                local newRotation = swungCF - swungCF.Position + hrp.CFrame.Position

                hrp.CFrame = hrp.CFrame:Lerp(newRotation, 0.5)
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
