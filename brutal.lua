if Moonwalk.Enabled and not ParryActive and not isDowned() then
    local char = LocalPlayer.Character
    if char and char.Parent then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if humanoid and hrp then
            -- Замедляем скорость
            if Moonwalk.UseSlow and humanoid.WalkSpeed ~= Moonwalk.SlowSpeed then
                humanoid.WalkSpeed = Moonwalk.SlowSpeed
            end

            -- Отключаем авто-разворот, чтобы самим управлять телом
            if humanoid.AutoRotate then
                humanoid.AutoRotate = false
            end

            -- Берём ТОЛЬКО вектор движения игрока (из WASD)
            local moveDir = humanoid.MoveDirection
            local flatMove = Vector3.new(moveDir.X, 0, moveDir.Z)

            if flatMove.Magnitude > 0.05 then
                local lookDir = flatMove.Unit

                -- Тело смотрит ПРОТИВ движения (спиной вперёд)
                local targetLookDir = -lookDir

                -- Строим целевой CFrame: позиция текущая, rotation — от targetLookDir
                local currentPos = hrp.Position
                local currentCF = hrp.CFrame
                local targetCF = CFrame.new(currentPos, currentPos + targetLookDir)
                local newRotation = targetCF - targetCF.Position + currentCF.Position

                -- Плавный поворот
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
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
end
