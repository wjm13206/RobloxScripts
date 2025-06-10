local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local notifications = {}

-- 加载成就音效
local achievementSound = Instance.new("Sound")
achievementSound.SoundId = "rbxassetid://10469938989" -- 替换为你的音频ID
achievementSound.Volume = 1 -- 音量大小
achievementSound.Parent = SoundService

local function UpdatePositions()
    for index, frame in ipairs(notifications) do
        local targetPosition = UDim2.new(0.76, 0, 0.1 + (index - 1) * 0.15, 0) -- 调整位置
        local tween = TweenService:Create(frame, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
            Position = targetPosition
        })
        tween:Play()
    end
end

local function CreateNotification(title, text, duration, isAchievement, subtitle, adccolor, littlecolor, image)
    -- 主提示框
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0.25, 0, 0.11, 0) -- 更大的提示框
    notificationFrame.Position = UDim2.new(1, 0, 0.1 + #notifications * 0.15, 0)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(28, 17, 27) -- 棕色背景
    notificationFrame.BackgroundTransparency = 0.9 -- 90%透明度
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = Gui

    -- 边框
    if adccolor == "default" then adccolor = Color3.fromRGB(248, 219, 192) end
    if adccolor == "warning" then adccolor = Color3.fromRGB(255, 55, 55) end
    local uiStroke = Instance.new("UIStroke", notificationFrame)
    uiStroke.Color = adccolor -- 边框颜色
    uiStroke.Thickness = 4 -- 边框厚度
    uiStroke.Transparency = 0 -- 边框不透明

    -- 圆角
    local uiCorner = Instance.new("UICorner", notificationFrame)
    uiCorner.CornerRadius = UDim.new(0, 9)

    -- 小标题
    if subtitle then
        if littlecolor == "default" then littlecolor = Color3.fromRGB(248, 219, 192) end
        if littlecolor == "warning" then littlecolor = Color3.fromRGB(255, 55, 55) end
        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Size = UDim2.new(0.3, 0, 0.1, 0)
        subtitleLabel.Position = UDim2.new(0.02, 0, -0.25, 0) -- 左上角外侧
        subtitleLabel.Text = subtitle
        subtitleLabel.TextColor3 = littlecolor -- 文字颜色
        subtitleLabel.TextSize = 20 -- 较小的字号
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Font = Enum.Font.GothamSemibold
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.Parent = notificationFrame
    end

    -- 图片
    if image then
        local imageLabel = Instance.new("ImageLabel", notificationFrame)
        imageLabel.Size = UDim2.new(0.2, 0, 0.8, 0)
        imageLabel.Position = UDim2.new(0.01, 0, 0.1, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = image -- 设置图片
        imageLabel.ScaleType = Enum.ScaleType.Fit
    end

    -- 标题
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(image and 0.21 or 0.025, 0, 0.05, 0) -- 如果有图片，调整位置
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(248, 219, 192) -- 文字颜色
    titleLabel.TextSize = 25
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 正文
    local textLabel = Instance.new("TextLabel", notificationFrame)
    textLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
    textLabel.Position = UDim2.new(image and 0.21 or 0.025, 0, 0.2, 0) -- 如果有图片，调整位置
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(192, 162, 148) -- 文字颜色
    textLabel.TextSize = 20
    textLabel.BackgroundTransparency = 1
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(notifications, notificationFrame)

    -- 如果是成就通知，播放音效
    if isAchievement then
        achievementSound:Play()
    end

    -- 滑入动画
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.76, 0, notificationFrame.Position.Y.Scale, 0) -- 调整滑入位置
    })
    tweenIn:Play()

    -- 独立协程处理通知生命周期
    coroutine.wrap(function()
        wait(duration)
        
        -- 滑出动画
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, notificationFrame.Position.Y.Scale, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()

        -- 移除元素并更新队列
        local index = table.find(notifications, notificationFrame)
        if index then
            table.remove(notifications, index)
            notificationFrame:Destroy()
            UpdatePositions()
        end
    end)()
end

-- 使用方法
CreateNotification("Welcome", "第一次进入游戏", 8, true, "已解锁成就", "default", "default", "rbxassetid://6023426923")
wait(2)
CreateNotification("Rush已刷新", "快躲到柜子里面去！", 8, true, "WARNING", "warning", "warning", "rbxassetid://12978732658")