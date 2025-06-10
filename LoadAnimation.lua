local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 创建 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- 创建全屏黑色遮罩
local mask = Instance.new("Frame")
mask.Size = UDim2.new(0, 0, 0, 0) -- 初始大小为 0
mask.Position = UDim2.new(0.5, 0, 0.5, 0) -- 初始位置在屏幕中央
mask.AnchorPoint = Vector2.new(0.5, 0.5) -- 锚点居中
mask.BackgroundColor3 = Color3.new(0, 0, 0) -- 黑色
mask.Parent = screenGui

-- 将遮罩改为圆形
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.5, 0) -- 设置为圆形
uiCorner.Parent = mask

-- 创建标题
local title = Instance.new("TextLabel")
title.Text = "ChronixHub"
title.TextColor3 = Color3.new(1, 1, 1) -- 白色
title.TextSize = 36
title.Font = Enum.Font.GothamBold
title.Size = UDim2.new(0, 300, 0, 50)
title.Position = UDim2.new(0.5, 0, 0.5, -50) -- 居中
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.TextTransparency = 1 -- 初始完全透明
title.Parent = screenGui

local title2 = Instance.new("TextLabel")
title2.Text = "正在加载中..."
title2.TextXAlignment = Enum.TextXAlignment.Left
title2.TextColor3 = Color3.fromRGB(150, 150, 150)
title2.TextSize = 20
title2.Font = Enum.Font.GothamBold
title2.Size = UDim2.new(0, 300, 0, 50)
title2.Position = UDim2.new(0.51, 0, 0.57, -50)
title2.AnchorPoint = Vector2.new(0.5, 0.5)
title2.BackgroundTransparency = 1
title2.TextTransparency = 1
title2.Parent = screenGui

-- 创建进度条背景
local progressBarBackground = Instance.new("Frame")
progressBarBackground.Size = UDim2.new(0, 300, 0, 10)
progressBarBackground.Position = UDim2.new(0.5, 0, 0.5, 20) -- 居中
progressBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
progressBarBackground.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 灰色
progressBarBackground.Parent = screenGui
progressBarBackground.BackgroundTransparency = 1

-- 添加圆角
local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0) -- 圆角
progressBarCorner.Parent = progressBarBackground

-- 创建进度条
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0) -- 初始宽度为 0
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.new(0.5, 0, 0) -- 深红色
progressBar.Parent = progressBarBackground

-- 添加圆角
local progressBarInnerCorner = Instance.new("UICorner")
progressBarInnerCorner.CornerRadius = UDim.new(1, 0) -- 圆角
progressBarInnerCorner.Parent = progressBar

-- 扩散动画（圆形扩散）
local function expandMask()
    local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mask, tweenInfo, {
        Size = UDim2.new(2, 0, 2, 0), -- 扩散到全屏
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
end

-- 显示标题和进度条（透明度渐变）
local function showTitleAndProgressBar()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- 标题透明度渐变
    local titleTween = TweenService:Create(title, tweenInfo, {
        TextTransparency = 0 -- 从不透明到完全可见
    })
    titleTween:Play()

    -- 标题透明度渐变
    local title2Tween = TweenService:Create(title2, tweenInfo, {
        TextTransparency = 0 -- 从不透明到完全可见
    })
    title2Tween:Play()

    -- 进度条背景透明度渐变
    local progressBarBackgroundTween = TweenService:Create(progressBarBackground, tweenInfo, {
        BackgroundTransparency = 0 -- 从不透明到完全可见
    })
    progressBarBackgroundTween:Play()

    titleTween.Completed:Wait()
end

-- 模拟加载进度
local function simulateLoading()
    local duration = 1 -- 加载时间
    local startTime = tick()
    while tick() - startTime < duration do
        local progress = (tick() - startTime) / duration
        progressBar.Size = UDim2.new(progress, 0, 1, 0)
        RunService.RenderStepped:Wait()
    end
    progressBar.Size = UDim2.new(1, 0, 1, 0) -- 确保进度条满
end

-- 隐藏标题和进度条（透明度渐变）
local function hideTitleAndProgressBar()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- 标题透明度渐变
    local titleTween = TweenService:Create(title, tweenInfo, {
        TextTransparency = 1 -- 从完全可见到透明
    })
    titleTween:Play()

    local title2Tween = TweenService:Create(title2, tweenInfo, {
        TextTransparency = 1 -- 从完全可见到透明
    })
    title2Tween:Play()

    -- 进度条背景透明度渐变
    local progressBarBackgroundTween = TweenService:Create(progressBarBackground, tweenInfo, {
        BackgroundTransparency = 1 -- 从完全可见到透明
    })
    progressBarBackgroundTween:Play()

    local progressBarTween = TweenService:Create(progressBar, tweenInfo, {
        BackgroundTransparency = 1 -- 从完全可见到透明
    })
    progressBarTween:Play()

    titleTween.Completed:Wait()
end

-- 缩回动画（圆形缩回）
local function shrinkMask()
    local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mask, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0), -- 缩回到中心
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    screenGui:Destroy() -- 动画完成后移除 UI
end

-- 主流程
expandMask()
showTitleAndProgressBar()
simulateLoading()
title2.Text = "已完成!"
wait(1)
hideTitleAndProgressBar()
shrinkMask()