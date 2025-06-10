local floatingWindow = {}

-- 创建悬浮窗的函数
function floatingWindow:createWindow(text, onClick)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local screenGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("FloatingWindowScreenGui")

    -- 创建 ScreenGui
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FloatingWindowScreenGui"
        screenGui.Parent = LocalPlayer.PlayerGui
        screenGui.ResetOnSpawn = false
    end

    -- 创建悬浮窗
    local window = Instance.new("TextButton")
    window.Name = "FloatingWindow"
    window.Size = UDim2.new(0, 70, 0, 70) -- 大小
    window.Position = UDim2.new(0.5, -40, 0.5, -40) -- 初始位置居中
    window.BackgroundTransparency = 0
    window.Parent = screenGui
    window.Text = ""

    -- 圆角效果
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- 完全圆形
    corner.Parent = window

    -- 渐变填充
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.2, 0.8, 1)), -- 浅蓝色
        ColorSequenceKeypoint.new(1, Color3.new(1, 0.5, 0.2))  -- 橙色
    })
    gradient.Rotation = 45 -- 斜向渐变
    gradient.Parent = window

    -- 添加文字
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = text
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
    label.BackgroundTransparency = 1
    label.TextSize = 28
    label.Font = Enum.Font.SourceSansBold
    label.Parent = window

    -- 拖动逻辑
    local isDragging = false
    local dragStartPosition = UDim2.new(0.5, 0, 0.5, 0)
    local dragStartOffset = UDim2.new(0.5, 0, 0.5, 0)
    local clickStartTime = 0

    local function startDrag(input)
        isDragging = true
        dragStartPosition = Vector2.new(window.Position.X.Offset, window.Position.Y.Offset)
        dragStartOffset = Vector2.new(input.Position.X, input.Position.Y)
        clickStartTime = os.clock() -- 记录点击开始时间
    end

    local function updateDrag(input)
        if isDragging then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartOffset
            window.Position = UDim2.new(0, dragStartPosition.X + delta.X, 0, dragStartPosition.Y + delta.Y)
        end
    end

    local function endDrag()
        isDragging = false

         -- 判断是否为点击（点击时间小于 0.2 秒）
        if os.clock() - clickStartTime < 0.2 then
            onClick(label) -- 执行点击事件
        else

            -- 吸附逻辑
            local screenSize = workspace.CurrentCamera.ViewportSize
            local windowPosition = Vector2.new(window.Position.X.Offset, window.Position.Y.Offset)
            local windowSize = Vector2.new(window.AbsoluteSize.X, window.AbsoluteSize.Y)

            -- 判断靠近哪一侧
            local edgeThreshold = 20 -- 吸附阈值
            local targetPosition = windowPosition

            if windowPosition.X < edgeThreshold then
                targetPosition = Vector2.new(-windowSize.X / 2, targetPosition.Y) -- 左边缘
            elseif windowPosition.X + windowSize.X > screenSize.X - edgeThreshold then
                targetPosition = Vector2.new(screenSize.X - windowSize.X / 2, targetPosition.Y) -- 右边缘
            end

            if windowPosition.Y < edgeThreshold then
                targetPosition = Vector2.new(targetPosition.X, -(windowSize.Y + windowSize.Y / 2 - windowSize.Y / 4)) -- 上边缘
            elseif windowPosition.Y + windowSize.Y > screenSize.Y - edgeThreshold then
                targetPosition = Vector2.new(targetPosition.X, screenSize.Y - (windowSize.Y + windowSize.Y / 4)) -- 下边缘
            end

            -- 移动到目标位置
            local tween = TweenService:Create(window, TweenInfo.new(0.2), {
                Position = UDim2.new(0, targetPosition.X, 0, targetPosition.Y)
            })
            tween:Play()
        end
    end

    -- 监听输入事件
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local inputPosition = Vector2.new(input.Position.X, input.Position.Y)
            local windowPosition = Vector2.new(window.AbsolutePosition.X, window.AbsolutePosition.Y)
            local windowSize = Vector2.new(window.AbsoluteSize.X, window.AbsoluteSize.Y)

            -- 判断是否点击在悬浮窗内
            if inputPosition.X >= windowPosition.X and inputPosition.X <= windowPosition.X + windowSize.X and
               inputPosition.Y >= windowPosition.Y and inputPosition.Y <= windowPosition.Y + windowSize.Y then
                startDrag(input)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateDrag(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
            endDrag()
        end
    end)

    return window
end

return floatingWindow