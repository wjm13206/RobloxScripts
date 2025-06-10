local AdvancedUI = {}

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

function AdvancedUI:CreateButton(parent, config)
    -- 默认配置
    local defaultConfig = {
        Name = "AdvancedButton",
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 200, 0, 50),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Shape = "RoundedRect", -- "RoundedRect", "Circle", "Polygon"
        CornerRadius = 12,
        Sides = 6, -- 用于多边形形状
        BackgroundColor = Color3.fromRGB(0, 120, 215),
        HoverColor = Color3.fromRGB(0, 150, 255),
        PressedColor = Color3.fromRGB(0, 90, 180),
        TextColor = Color3.fromRGB(255, 255, 255),
        Text = "Button",
        TextSize = 18,
        Font = Enum.Font.SourceSans,
        Icon = "", -- 图标ID
        IconSize = 24,
        IconColor = Color3.fromRGB(255, 255, 255),
        IconPadding = 8,
        RippleColor = Color3.fromRGB(255, 255, 255),
        RippleTransparency = 0.7,
        ShadowEnabled = true,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.7,
        ShadowBlur = 8,
        AnimationSpeed = 0.15,
        OnClick = function() end,
        OnHover = function() end,
        OnLeave = function() end
    }
    
    -- 合并配置
    config = setmetatable(config or {}, {__index = defaultConfig})
    
    -- 创建主容器
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = config.Name
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Position = config.Position
    buttonContainer.Size = config.Size
    buttonContainer.AnchorPoint = config.AnchorPoint
    buttonContainer.ClipsDescendants = true
    buttonContainer.Parent = parent
    
    -- 创建阴影
    local shadow
    if config.ShadowEnabled then
        shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Image = "rbxassetid://1316045217" -- 圆形阴影
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.BackgroundTransparency = 1
        shadow.Size = UDim2.new(1, config.ShadowBlur*2, 1, config.ShadowBlur*2)
        shadow.Position = UDim2.new(0, -config.ShadowBlur, 0, -config.ShadowBlur)
        shadow.ImageColor3 = config.ShadowColor
        shadow.ImageTransparency = config.ShadowTransparency
        shadow.ZIndex = 0
        shadow.Parent = buttonContainer
    end
    
    -- 创建按钮主体
    local button = Instance.new("Frame")
    button.Name = "Button"
    button.BackgroundColor3 = config.BackgroundColor
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.ZIndex = 1
    
    -- 根据形状配置按钮
    if config.Shape == "RoundedRect" then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, config.CornerRadius)
        corner.Parent = button
    elseif config.Shape == "Circle" then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        button.Size = UDim2.new(0, math.min(config.Size.X.Offset, config.Size.Y.Offset), 
                        0, math.min(config.Size.X.Offset, config.Size.Y.Offset))
        button.Position = UDim2.new(0.5, -button.Size.X.Offset/2, 0.5, -button.Size.Y.Offset/2)
        corner.Parent = button
    elseif config.Shape == "Polygon" then
        button.BackgroundTransparency = 1
        local polygon = Instance.new("ImageLabel")
        polygon.Name = "Polygon"
        polygon.Image = "rbxassetid://2610133241" -- 多边形遮罩
        polygon.ScaleType = Enum.ScaleType.Fit
        polygon.BackgroundTransparency = 1
        polygon.Size = UDim2.new(1, 0, 1, 0)
        polygon.ImageColor3 = config.BackgroundColor
        polygon.Parent = button
        
        -- 创建多边形遮罩
        local sides = math.max(3, math.min(12, config.Sides or 6))
        local polygonMask = Instance.new("ImageLabel")
        polygonMask.Name = "PolygonMask"
        polygonMask.Image = "rbxassetid://2610133241" -- 多边形遮罩
        polygonMask.ScaleType = Enum.ScaleType.Fit
        polygonMask.BackgroundTransparency = 1
        polygonMask.Size = UDim2.new(1, 0, 1, 0)
        polygonMask.ImageTransparency = 1
        polygonMask.Parent = button
        
        -- 更新多边形形状
        local function updatePolygon()
            local angle = 2 * math.pi / sides
            local points = {}
            
            for i = 1, sides do
                local a = (i - 1) * angle - math.pi / 2
                local x = math.cos(a) * 0.5 + 0.5
                local y = math.sin(a) * 0.5 + 0.5
                table.insert(points, Vector2.new(x, y))
            end
            
            local polygonDrawing = Instance.new("UICorner")
            polygonDrawing.CornerRadius = UDim.new(0, 0)
            polygonDrawing.Parent = polygonMask
        end
        
        updatePolygon()
    end
    
    button.Parent = buttonContainer
    
    -- 创建按钮内容容器
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Position = UDim2.new(0, 0, 0, 0)
    content.ZIndex = 2
    content.Parent = button
    
    -- 创建图标
    local icon
    if config.Icon ~= "" then
        icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Image = config.Icon
        icon.ImageColor3 = config.IconColor
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, config.IconSize, 0, config.IconSize)
        icon.Position = UDim2.new(0, config.IconPadding, 0.5, -config.IconSize/2)
        icon.ZIndex = 3
        icon.Parent = content
    end
    
    -- 创建文本
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Text = config.Text
    textLabel.TextColor3 = config.TextColor
    textLabel.TextSize = config.TextSize
    textLabel.Font = config.Font
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, icon and -(config.IconSize + config.IconPadding * 2) or 0, 1, 0)
    textLabel.Position = UDim2.new(0, icon and (config.IconSize + config.IconPadding * 2) or 0, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.ZIndex = 3
    textLabel.Parent = content
    
    -- 调整文本位置
    if icon then
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Size = UDim2.new(1, -(config.IconSize + config.IconPadding * 3), 1, 0)
        textLabel.Position = UDim2.new(0, config.IconSize + config.IconPadding * 2, 0, 0)
    end
    
    -- 创建波纹效果
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = config.RippleColor
    ripple.BackgroundTransparency = config.RippleTransparency
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = 4
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    ripple.Parent = button
    
    -- 动画变量
    local isHovering = false
    local isPressed = false
    local currentTween
    
    -- 鼠标进入动画
    local function onMouseEnter()
        if isHovering then return end
        isHovering = true
        
        if currentTween then
            currentTween:Cancel()
        end
        
        currentTween = TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = config.HoverColor}
        )
        currentTween:Play()
        
        -- 悬停时轻微放大效果
        local hoverTween = TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 4, 1, 4), Position = UDim2.new(0, -2, 0, -2)}
        )
        hoverTween:Play()
        
        if config.OnHover then
            config.OnHover()
        end
    end
    
    -- 鼠标离开动画
    local function onMouseLeave()
        if not isHovering then return end
        isHovering = false
        
        if currentTween then
            currentTween:Cancel()
        end
        
        currentTween = TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = config.BackgroundColor}
        )
        currentTween:Play()
        
        -- 恢复原始大小
        local resetTween = TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}
        )
        resetTween:Play()
        
        if config.OnLeave then
            config.OnLeave()
        end
    end
    
    -- 鼠标按下动画
    local function onMouseDown()
        isPressed = true
        
        TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = config.PressedColor}
        ):Play()
        
        -- 按下时轻微缩小效果
        TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2)}
        ):Play()
    end
    
    -- 鼠标释放动画
    local function onMouseUp()
        if not isPressed then return end
        isPressed = false
        
        local targetColor = isHovering and config.HoverColor or config.BackgroundColor
        TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = targetColor}
        ):Play()
        
        -- 恢复悬停或原始大小
        local targetSize = isHovering and UDim2.new(1, 4, 1, 4) or UDim2.new(1, 0, 1, 0)
        local targetPos = isHovering and UDim2.new(0, -2, 0, -2) or UDim2.new(0, 0, 0, 0)
        
        TweenService:Create(
            button,
            TweenInfo.new(config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = targetSize, Position = targetPos}
        ):Play()
    end
    
    -- 点击效果
    local function onClick()
        -- 获取鼠标位置相对于按钮的位置
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local x, y = mouse.X, mouse.Y
        local buttonAbsolutePos = button.AbsolutePosition
        local buttonSize = button.AbsoluteSize
        
        -- 计算波纹中心位置
        local rippleX = (x - buttonAbsolutePos.X) / buttonSize.X
        local rippleY = (y - buttonAbsolutePos.Y) / buttonSize.Y
        
        ripple.Position = UDim2.new(rippleX, 0, rippleY, 0)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundTransparency = config.RippleTransparency
        
        -- 计算波纹最大尺寸
        local maxSize = math.max(buttonSize.X, buttonSize.Y) * 2
        
        -- 波纹动画
        local rippleTween1 = TweenService:Create(
            ripple,
            TweenInfo.new(config.AnimationSpeed * 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}
        )
        
        rippleTween1:Play()
        
        -- 执行点击回调
        if config.OnClick then
            config.OnClick()
        end
    end
    
    -- 添加交互事件
    local buttonClickDetector = Instance.new("TextButton")
    buttonClickDetector.Name = "ClickDetector"
    buttonClickDetector.Text = ""
    buttonClickDetector.BackgroundTransparency = 1
    buttonClickDetector.Size = UDim2.new(1, 0, 1, 0)
    buttonClickDetector.Parent = buttonContainer
    
    buttonClickDetector.MouseEnter:Connect(onMouseEnter)
    buttonClickDetector.MouseLeave:Connect(onMouseLeave)
    buttonClickDetector.MouseButton1Down:Connect(onMouseDown)
    buttonClickDetector.MouseButton1Up:Connect(onMouseUp)
    buttonClickDetector.Activated:Connect(onClick)
    
    -- 返回按钮对象以便外部控制
    local buttonAPI = {
        Container = buttonContainer,
        Button = button,
        TextLabel = textLabel,
        Icon = icon,
        
        SetText = function(self, newText)
            textLabel.Text = newText
        end,
        
        SetIcon = function(self, newIcon)
            if icon then
                icon.Image = newIcon
            end
        end,
        
        SetEnabled = function(self, enabled)
            buttonClickDetector.Active = enabled
            button.BackgroundTransparency = enabled and 0 or 0.5
        end,
        
        Destroy = function(self)
            buttonContainer:Destroy()
        end
    }
    
    return buttonAPI
end

return AdvancedUI

-- 示例使用
--[[
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = CreateAdvancedButton(screenGui, {
    Name = "MyButton",
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 200, 0, 50),
    Shape = "RoundedRect",
    CornerRadius = 12,
    BackgroundColor = Color3.fromRGB(0, 120, 215),
    HoverColor = Color3.fromRGB(0, 150, 255),
    PressedColor = Color3.fromRGB(0, 90, 180),
    Text = "Click Me!",
    TextSize = 18,
    Icon = "rbxassetid://3926305904", -- 示例图标ID
    IconSize = 24,
    OnClick = function()
        print("Button clicked!")
    end,
    OnHover = function()
        print("Mouse entered button")
    end,
    OnLeave = function()
        print("Mouse left button")
    end
})
]]