local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local notifications = {}

-- 加载成就音效
local achievementSound = Instance.new("Sound")
achievementSound.SoundId = "rbxassetid://4590662766" -- 替换为你的音频ID
achievementSound.Volume = 0.5 -- 音量大小
achievementSound.Parent = SoundService

local function UpdatePositions()
    for index, frame in ipairs(notifications) do
        local targetPosition = UDim2.new(0.8, 0, 0.1 + (index - 1) * 0.11, 0)
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = targetPosition
        })
        tween:Play()
    end
end

local function CreateNotification(title, text, duration, isAchievement)
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0.2, 0, 0.1, 0)
    notificationFrame.Position = UDim2.new(1, 0, 0.1 + #notifications * 0.11, 0)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- 背景颜色
    notificationFrame.BackgroundTransparency = 0.3 -- 背景透明度降低
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = Gui

    local uiCorner = Instance.new("UICorner", notificationFrame)
    uiCorner.CornerRadius = UDim.new(0, 8)

    -- 标题
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Size = UDim2.new(0.95, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 标题文字颜色
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- 分隔线
    local divider = Instance.new("Frame", notificationFrame)
    divider.Size = UDim2.new(0.95, 0, 0, 1)
    divider.Position = UDim2.new(0.025, 0, 0.35, 0)
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BackgroundTransparency = 0.8
    divider.BorderSizePixel = 0

    -- 正文
    local textLabel = Instance.new("TextLabel", notificationFrame)
    textLabel.Size = UDim2.new(0.95, 0, 0.6, 0)
    textLabel.Position = UDim2.new(0.025, 0, 0.3, 0)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220) -- 正文文字颜色
    textLabel.TextSize = 14
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
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.8, 0, notificationFrame.Position.Y.Scale, 0)
    })
    tweenIn:Play()

    -- 独立协程处理通知生命周期
    coroutine.wrap(function()
        wait(duration)
        
        -- 滑出动画
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
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
CreateNotification("系统提示", "辅助已启动", 5, true)