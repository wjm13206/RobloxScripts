if not game:IsLoaded() then
	game.Loaded:Wait()
end

if _G.ChronixHubisLoaded then
    warn("⛔ ChronixHub Already loaded! Please do not repeat the execution.")
    return
end

-- 启动加载动画
loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/LoadAnimation.lua"))()

local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()bb:CaptureController()bb:ClickButton2(Vector2.new())end)
 
_G.ChronixHubisLoaded = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Gui = Instance.new("ScreenGui")
-- Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Gui.Parent = game.CoreGui
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- 获取玩家信息
local playerName = LocalPlayer.Name -- 玩家名
local displayName = LocalPlayer.DisplayName -- 显示名
local userId = LocalPlayer.UserId -- 用户 ID
-- 获取玩家头像
local thumbnailType = Enum.ThumbnailType.HeadShot -- 头像类型
local thumbnailSize = Enum.ThumbnailSize.Size100x100 -- 头像尺寸
local success, thumbnailUrl = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbnailType, thumbnailSize)
end)
-- 获取玩家角色外观信息
local success, appearanceInfo = pcall(function()
    return Players:GetCharacterAppearanceInfoAsync(LocalPlayer.UserId)
end)

-- 定义白天和黑夜的光照属性
local daySettings = {
    ClockTime = 14, -- 白天时间（14:00）
    GeographicLatitude = 41.73, -- 纬度（影响太阳高度）
    -- Ambient = Color3.new(0.5, 0.5, 0.5), -- 环境光
    -- OutdoorAmbient = Color3.new(0.5, 0.5, 0.5), -- 室外环境光
    -- Brightness = 2, -- 亮度
    -- FogColor = Color3.new(0.8, 0.8, 0.8), -- 雾颜色
    -- FogEnd = 1000 -- 雾结束距离
}

local nightSettings = {
    ClockTime = 2, -- 黑夜时间（02:00）
    GeographicLatitude = 41.73, -- 纬度
    -- Ambient = Color3.new(0.1, 0.1, 0.1), -- 环境光
    -- OutdoorAmbient = Color3.new(0.1, 0.1, 0.1), -- 室外环境光
    -- Brightness = 0.2, -- 亮度
    -- FogColor = Color3.new(0.1, 0.1, 0.1), -- 雾颜色
    -- FogEnd = 500 -- 雾结束距离
}

-- 切换为白天
local function setDay()
    for property, value in pairs(daySettings) do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Lighting, tweenInfo, { [property] = value })
        tween:Play()
    end
end

-- 切换为黑夜
local function setNight()
    for property, value in pairs(nightSettings) do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Lighting, tweenInfo, { [property] = value })
        tween:Play()
    end
end

local function resetBianLiang()
    _G.ChronixHubisNightVisiton = false
    _G.ChronixHubisChuanQiang = false
    _G.ChronixHubisInfJump = false
    _G.ChronixHubisTime = false
    _G.ChronixHubExecuteText = "print(\"Hello world!\")"
    _G.ChronixHubMusicID = "1837879082"
    _G.ChronixHubMusicisPlay = false
    _G.ChronixHubMusicisPause = false
    _G.ChronixHubMusicPlayLocation = 0
    _G.ChronixHubHLEnable = false
    _G.ChronixHubisAirWalking = false
    _G.ChronixHubfloorFixedY = nil
    _G.ChronixhubAntiFallDown = false
    _G.ChronixHubAntiDead = false
end

resetBianLiang()

local floorPart = nil

-- 创建地板
local function createFloor()
    if floorPart then return end -- 如果地板已存在，则不重复创建
    
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- 创建地板
    floorPart = Instance.new("Part")
    floorPart.Size = Vector3.new(10, 1, 10) -- 地板大小
    floorPart.Transparency = 1 -- 完全透明
    floorPart.Anchored = true -- 固定位置
    floorPart.CanCollide = true -- 允许碰撞
    floorPart.Parent = workspace

    -- 添加发光特效
    local glow = Instance.new("SurfaceGui", floorPart)
    glow.Face = Enum.NormalId.Top
    local frame = Instance.new("Frame", glow)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 1, 0) -- 白色发光
    frame.BackgroundTransparency = 0.4 -- 半透明
    frame.BorderSizePixel = 0

    -- 记录当前地板的 Y 轴高度
    _G.ChronixHubfloorFixedY = HumanoidRootPart.Position.Y - HumanoidRootPart.Size.Y / 2 - floorPart.Size.Y / 2 - 1.8
    floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, _G.ChronixHubfloorFixedY, HumanoidRootPart.Position.Z)
end

-- 删除地板
local function destroyFloor()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
        _G.ChronixHubfloorFixedY = nil
    end
end

-- 切换空中行走状态
local function toggleAirWalk()
    _G.ChronixHubisAirWalking = not _G.ChronixHubisAirWalking
    if _G.ChronixHubisAirWalking then
        createFloor() -- 启用时创建地板
    else
        destroyFloor() -- 禁用时删除地板
    end
end

-- 更新地板位置
RunService.Heartbeat:Connect(function()
    if _G.ChronixHubisAirWalking and floorPart and _G.ChronixHubfloorFixedY then
        -- 将地板的 X 和 Z 轴与玩家对齐，Y 轴固定
        floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, _G.ChronixHubfloorFixedY, HumanoidRootPart.Position.Z)
    end
end)

local boundKey = Enum.KeyCode.F1 -- 默认快捷键为 Delete
local keyText = "F1"
local isMenuVisible = false
local CheckBox1_isChecked = false
local GD_speed = LocalPlayer.Character.Humanoid.WalkSpeed

local SoundService = game:GetService("SoundService")

local notifications = {}

-- 创建 Sound 对象
local sound = Instance.new("Sound")
sound.Parent = SoundService

local uiclicker = Instance.new("Sound")
uiclicker.SoundId = "rbxassetid://535716488"
uiclicker.Volume = 0.3
uiclicker.Parent = SoundService

-- 加载成就音效
local achievementSound = Instance.new("Sound")
achievementSound.SoundId = "rbxassetid://4590662766" -- 替换为你的音频ID
achievementSound.Volume = 0.5 -- 音量大小
achievementSound.Parent = SoundService

-- 存储高亮和用户名标签
local highlights = {}
local usernameLabels = {}

-- 为玩家添加高亮
local function addHighlight(player)
    if player == LocalPlayer then return end -- 排除自己和未启用时

    local character = player.Character
    if character then
        -- 创建 Highlight 对象
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.FillTransparency = 0.8
        highlight.OutlineColor = Color3.new(1, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- 隔墙显示
        highlight.Parent = character

        -- 如果只描边，则隐藏整体覆盖颜色
        if onlyOutline then
            highlight.FillTransparency = 1
        end

        -- 存储高亮对象
        highlights[player] = highlight
    end
end

-- 为玩家添加用户名标签
local function addUsernameLabel(player)
    if player == LocalPlayer then return end -- 排除自己和未启用时

    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            -- 创建 BillboardGui
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0) -- 在头顶上方显示
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            -- 创建 TextLabel
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            if player.DisplayName == player.Name then label.Text = player.DisplayName else label.Text = player.DisplayName .. " (@" .. player.Name .. ")" end -- 显示用户名
            label.TextColor3 = Color3.new(1, 1, 1) -- 白色文字
            label.BackgroundTransparency = 1 -- 透明背景
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 18
            label.Parent = billboard

            -- 存储用户名标签
            usernameLabels[player] = billboard
        end
    end
end

-- 移除玩家的高亮和用户名标签
local function removePlayerEffects(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
    if usernameLabels[player] then
        usernameLabels[player]:Destroy()
        usernameLabels[player] = nil
    end
end

local function GetDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return "Mobile" -- 移动端
    elseif UserInputService.MouseEnabled and not UserInputService.TouchEnabled then
        return "Desktop" -- 桌面端
    elseif UserInputService.GamepadEnabled then
        return "Console" -- 控制台
    else
        return "Unknown" -- 未知设备
    end
end

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
    notificationFrame.BackgroundTransparency = 0.8 -- 背景透明度降低
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
    textLabel.TextSize = 18
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

-- 配置常量
local CONFIG = {
    ARROW_SIZE = UDim2.new(0.5, 0, 0.03, 0), -- 更小的箭头
    ARROW_POSITION_HIDDEN = UDim2.new(0.5, 0, 1.1, 0), -- 初始隐藏在屏幕下方
    ARROW_POSITION_VISIBLE = UDim2.new(0.5, 0, 0.97, 0), -- 贴近屏幕底部
    MENU_SIZE = UDim2.new(0.4, 0, 0.5, 0),
    MENU_POSITION_HIDDEN = UDim2.new(0.3, 0, 1.1, 0), -- 初始隐藏在屏幕下方
    MENU_POSITION_VISIBLE = UDim2.new(0.3, 0, 0.4, 0), -- 点击箭头后弹出
    BACKGROUND_COLOR = Color3.fromRGB(40, 40, 40),
    BUTTON_COLOR = Color3.fromRGB(60, 60, 60),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    ARROW_TRANSPARENCY = 0.5, -- 半透明箭头
    TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Quad),
    CATEGORY_BUTTON_SIZE = UDim2.new(0.15, 0, 1, 0), -- 更大的分类按钮
    CATEGORY_BUTTON_SPACING = 38, -- 按钮之间的间距
    CATEGORY_BUTTON_INSET = 10 -- 按钮向内偏移
}

local tbz = {
    lcp1 = "备注",
    lcp2 = "备注",
    lcp3 = "备注",
    lcp4 = "备注",
    lcp5 = "备注",
    lcp6 = "备注",
    lcp7 = "备注",
    lcp8 = "备注",
    lcp9 = "备注",
    lcp10 = "备注",
    lcp11 = "备注",
    lcp12 = "备注",
    lcp13 = "备注",
    lcp14 = "备注"
}

local teleportpoint = {
    locate1 = nil,
    locate2 = nil,
    locate3 = nil,
    locate4 = nil,
    locate5 = nil,
    locate6 = nil,
    locate7 = nil,
    locate8 = nil,
    locate9 = nil,
    locate10 = nil,
    locate11 = nil,
    locate12 = nil,
    locate13 = nil,
    locate14 = nil
}

local function CreateLabel(parent, text, size, position, textSize)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.TEXT_COLOR
    label.TextSize = textSize
    label.Parent = parent
    return label
end

local function CreateButton(parent, text, size, position, textSize)
    -- 创建渐变背景
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.7, 0.7, 0.7))
    })
    local button = Instance.new("TextButton")
    button.Size = size -- 按钮大小
    button.Position = position -- 按钮位置
    button.BackgroundColor3 = CONFIG.BUTTON_COLOR
    button.Text = text
    button.TextColor3 = CONFIG.TEXT_COLOR
    button.TextSize = textSize
    button.Parent = parent
    gradient.Rotation = 75 -- 渐变方向（从上到下）
    gradient.Parent = button
    button.MouseButton1Click:Connect(function()
        uiclicker:Play()
    end)
    return button
end

local function CreateTextBox(parent, text, size, position, textSize)
    local textBox = Instance.new("TextBox")
    textBox.Size = size -- 输入框大小
    textBox.Position = position -- 输入框位置
    textBox.BackgroundColor3 = CONFIG.BUTTON_COLOR
    textBox.TextColor3 = CONFIG.TEXT_COLOR
    textBox.TextSize = textSize
    textBox.Text = text
    textBox.Parent = parent
    return textBox
end

local function CreateFrame(parent, size, position)
    local slider = Instance.new("Frame")
    slider.Size = size -- 滑轮背景大小
    slider.Position = position -- 滑轮背景位置
    slider.BackgroundColor3 = CONFIG.BUTTON_COLOR
    slider.Parent = parent
    return slider
end

-- 创建箭头按钮
local arrowButton = Instance.new("TextButton")
arrowButton.Size = CONFIG.ARROW_SIZE
arrowButton.Position = CONFIG.ARROW_POSITION_HIDDEN
arrowButton.AnchorPoint = Vector2.new(0.5, 0.5)
arrowButton.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
arrowButton.BackgroundTransparency = CONFIG.ARROW_TRANSPARENCY
arrowButton.Text = "▲"
arrowButton.TextColor3 = CONFIG.TEXT_COLOR
arrowButton.TextSize = 14
arrowButton.ZIndex = 2
arrowButton.Parent = Gui

-- 创建菜单
local menuFrame = Instance.new("Frame")
menuFrame.Size = CONFIG.MENU_SIZE
menuFrame.Position = CONFIG.MENU_POSITION_HIDDEN
menuFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
menuFrame.ZIndex = 1
menuFrame.Parent = Gui

-- 圆角
local uiCorner = Instance.new("UICorner", menuFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- 创建菜单标题
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
titleLabel.Position = UDim2.new(0.04, 0, 0.01, 0) -- 左上角
titleLabel.Text = "ChronixHub"
titleLabel.TextColor3 = CONFIG.TEXT_COLOR
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = menuFrame

-- 创建类型标签
local categoryText = Instance.new("TextLabel")
categoryText.Size = UDim2.new(0.8, 0, 0.1, 0)
categoryText.Position = UDim2.new(0, 55, 0.07, 0) -- 左上角
categoryText.Text = ""
categoryText.TextColor3 = CONFIG.TEXT_COLOR
categoryText.TextSize = 25
categoryText.Font = Enum.Font.GothamBold
categoryText.BackgroundTransparency = 1
categoryText.Parent = menuFrame

-- 创建分类按钮区域
local categoryButtonsFrame = Instance.new("Frame")
categoryButtonsFrame.Size = UDim2.new(1, 0, 0.1, 0) -- 占菜单高度的 10%
categoryButtonsFrame.Position = UDim2.new(0, 0, 0.1, 0) -- 在标题下方
categoryButtonsFrame.BackgroundTransparency = 1 -- 透明背景
categoryButtonsFrame.Parent = menuFrame

-- 创建内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.75, 0) -- 占菜单高度的 80%
contentFrame.Position = UDim2.new(0, 0, 0, 53) -- 在分类按钮下方
contentFrame.BackgroundTransparency = 1 -- 透明背景
contentFrame.Parent = menuFrame

-- 添加菜单内容
local function AddMenuContent(category)
    -- 清空内容区域
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    categoryText.Text = category

    -- 根据分类添加内容
    if category == "基础" then
        -- 添加标签
        local label = CreateLabel(contentFrame, "移速", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, -200, 0, 10), 15)
        local label2 = CreateLabel(contentFrame, "跳跃高度", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, -200, 0, 50), 15)
        local label3 = CreateLabel(contentFrame, "最大血量", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, -200, 0, 90), 15)
        local label4 = CreateLabel(contentFrame, "当前血量", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, -200, 0, 130), 15)
        local label5 = CreateLabel(contentFrame, "重力", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, -200, 0, 170), 15)

        -- 添加按钮
        local button = CreateButton(contentFrame, "设置", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 430, 0, 10), 14)
        local button2 = CreateButton(contentFrame, "设置", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 430, 0, 50), 14)
        local button3 = CreateButton(contentFrame, "设置", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 430, 0, 90), 14)
        local button4 = CreateButton(contentFrame, "设置", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 430, 0, 130), 14)
        local button5 = CreateButton(contentFrame, "设置", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 430, 0, 170), 14)

        local CheckBox1 = CreateButton(contentFrame, CheckBox1_isChecked and "●" or "", UDim2.new(0.04, 0, 0.08, 0), UDim2.new(0, 570, 0, 12), 25)
        CheckBox1.TextColor3 = Color3.new(1, 1, 1)

        -- 添加输入框
        local textBox = CreateTextBox(contentFrame, string.format("%.2f", LocalPlayer.Character.Humanoid.WalkSpeed), UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 90, 0, 10), 14)
        local textBox2 = CreateTextBox(contentFrame, string.format("%.2f", LocalPlayer.Character.Humanoid.JumpPower), UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 90, 0, 50), 14)
        local textBox3 = CreateTextBox(contentFrame, LocalPlayer.Character.Humanoid.MaxHealth, UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 90, 0, 90), 14)
        local textBox4 = CreateTextBox(contentFrame, LocalPlayer.Character.Humanoid.Health, UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 90, 0, 130), 14)
        local textBox5 = CreateTextBox(contentFrame, string.format("%.2f", game.Workspace.Gravity), UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 90, 0, 170), 14)

        -- 添加滑轮
        local slider = CreateFrame(contentFrame, UDim2.new(0.3, 0, 0.05, 0), UDim2.new(0, 230, 0, 16))
        local slider2 = CreateFrame(contentFrame, UDim2.new(0.3, 0, 0.05, 0), UDim2.new(0, 230, 0, 56))
        local slider3 = CreateFrame(contentFrame, UDim2.new(0.3, 0, 0.05, 0), UDim2.new(0, 230, 0, 96))
        local slider4 = CreateFrame(contentFrame, UDim2.new(0.3, 0, 0.05, 0), UDim2.new(0, 230, 0, 136))
        local slider5 = CreateFrame(contentFrame, UDim2.new(0.3, 0, 0.05, 0), UDim2.new(0, 230, 0, 176))

        -- 滑轮滑块
        local sliderButton = CreateButton(slider, "", UDim2.new(0.1, 0, 1, 0), UDim2.new(LocalPlayer.Character.Humanoid.WalkSpeed / 100 or 0, 0, 0, 0), 0)
        local sliderButton2 = CreateButton(slider2, "", UDim2.new(0.1, 0, 1, 0), UDim2.new(LocalPlayer.Character.Humanoid.JumpPower / 100 or 0, 0, 0, 0), 0)
        local sliderButton3 = CreateButton(slider3, "", UDim2.new(0.1, 0, 1, 0), UDim2.new(LocalPlayer.Character.Humanoid.MaxHealth / 1000 or 0, 0, 0, 0), 0)
        local sliderButton4 = CreateButton(slider4, "", UDim2.new(0.1, 0, 1, 0), UDim2.new(LocalPlayer.Character.Humanoid.Health / textBox3.Text or 0, 0, 0, 0), 0)
        local sliderButton5 = CreateButton(slider5, "", UDim2.new(0.1, 0, 1, 0), UDim2.new(game.Workspace.Gravity / 500 or 0, 0, 0, 0), 0)
        sliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton3.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton4.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderButton5.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

        -- 滑轮逻辑
        local isDragging = false
        local function updateSlider(input)
            local sliderSize = slider.AbsoluteSize.X
            local sliderPosition = math.clamp((input.Position.X - slider.AbsolutePosition.X) / sliderSize, 0, 1)
            sliderButton.Position = UDim2.new(sliderPosition, 0, 0, 0)
            local speed = math.floor(sliderPosition * 100) -- 将滑轮值映射到 0-100
            textBox.Text = tostring(speed) -- 更新输入框的值
        end

        local isDragging2 = false
        local function updateSlider2(input)
            local sliderSize2 = slider2.AbsoluteSize.X
            local sliderPosition2 = math.clamp((input.Position.X - slider2.AbsolutePosition.X) / sliderSize2, 0, 1)
            sliderButton2.Position = UDim2.new(sliderPosition2, 0, 0, 0)
            local jump = math.floor(sliderPosition2 * 100) -- 将滑轮值映射到 0-100
            textBox2.Text = tostring(jump) -- 更新输入框的值
        end

        local isDragging3 = false
        local function updateSlider3(input)
            local sliderSize3 = slider3.AbsoluteSize.X
            local sliderPosition3 = math.clamp((input.Position.X - slider3.AbsolutePosition.X) / sliderSize3, 0, 1)
            sliderButton3.Position = UDim2.new(sliderPosition3, 0, 0, 0)
            local mh = math.floor(sliderPosition3 * 1000) -- 将滑轮值映射到 0-100
            textBox3.Text = tostring(mh) -- 更新输入框的值
        end

        local isDragging4 = false
        local function updateSlider4(input)
            local sliderSize4 = slider4.AbsoluteSize.X
            local sliderPosition4 = math.clamp((input.Position.X - slider4.AbsolutePosition.X) / sliderSize4, 0, 1)
            sliderButton4.Position = UDim2.new(sliderPosition4, 0, 0, 0)
            local heal = math.floor(sliderPosition4 * textBox3.Text) -- 将滑轮值映射到 0-100
            textBox4.Text = tostring(heal) -- 更新输入框的值
        end

        local isDragging5 = false
        local function updateSlider5(input)
            local sliderSize5 = slider5.AbsoluteSize.X
            local sliderPosition5 = math.clamp((input.Position.X - slider5.AbsolutePosition.X) / sliderSize5, 0, 1)
            sliderButton5.Position = UDim2.new(sliderPosition5, 0, 0, 0)
            local grav = math.floor(sliderPosition5 * 500) -- 将滑轮值映射到 0-100
            textBox5.Text = tostring(grav) -- 更新输入框的值
        end

        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
            end
        end)

        sliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)

        sliderButton2.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging2 = true
            end
        end)

        sliderButton2.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging2 = false
            end
        end)

        sliderButton3.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging3 = true
            end
        end)

        sliderButton3.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging3 = false
            end
        end)

        sliderButton4.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging4 = true
            end
        end)

        sliderButton4.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging4 = false
            end
        end)

        sliderButton5.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging5 = true
            end
        end)

        sliderButton5.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging5 = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end

            if isDragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider2(input)
            end

            if isDragging3 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider3(input)
            end

            if isDragging4 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider4(input)
            end

            if isDragging5 and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider5(input)
            end
        end)

        -- 按钮点击逻辑
        button.MouseButton1Click:Connect(function()
            local speed = tonumber(textBox.Text)
            GD_speed = speed
            if speed then
                LocalPlayer.Character.Humanoid.WalkSpeed = speed
            end
        end)

        button2.MouseButton1Click:Connect(function()
            local JumpPower = tonumber(textBox2.Text)
            if JumpPower then
                LocalPlayer.Character.Humanoid.JumpPower = JumpPower
            end
        end)

        button3.MouseButton1Click:Connect(function()
            local mh = tonumber(textBox3.Text)
            if mh then
                LocalPlayer.Character.Humanoid.MaxHealth = mh
            end
        end)

        button4.MouseButton1Click:Connect(function()
            local heal = tonumber(textBox4.Text)
            if heal then
                LocalPlayer.Character.Humanoid.Health = heal
            end
        end)

        button5.MouseButton1Click:Connect(function()
            local grav = tonumber(textBox5.Text)
            if grav then
                game.Workspace.Gravity = grav
            end
        end)

        -- 滑轮值改变时执行命令
        sliderButton:GetPropertyChangedSignal("Position"):Connect(function()
            local speed = tonumber(textBox.Text)
            GD_speed = speed
            if speed then
                LocalPlayer.Character.Humanoid.WalkSpeed = speed
            end
        end)

        sliderButton2:GetPropertyChangedSignal("Position"):Connect(function()
            local JumpPower = tonumber(textBox2.Text)
            if JumpPower then
                LocalPlayer.Character.Humanoid.JumpPower = JumpPower
            end
        end)

        sliderButton3:GetPropertyChangedSignal("Position"):Connect(function()
            local mh = tonumber(textBox3.Text)
            if mh then
                LocalPlayer.Character.Humanoid.MaxHealth = mh
            end
        end)

        sliderButton4:GetPropertyChangedSignal("Position"):Connect(function()
            local heal = tonumber(textBox4.Text)
            if heal then
                LocalPlayer.Character.Humanoid.Health = heal
            end
        end)

        sliderButton5:GetPropertyChangedSignal("Position"):Connect(function()
            local grav = tonumber(textBox5.Text)
            if grav then
                game.Workspace.Gravity = grav
            end
        end)

        CheckBox1.MouseButton1Click:Connect(function()
            CheckBox1_isChecked = not CheckBox1_isChecked
            if CheckBox1_isChecked then CheckBox1.Text = "●" else CheckBox1.Text = "" end
            Stepped1 = game:GetService("RunService").Stepped:Connect(function()
                if not CheckBox1_isChecked then
                    Stepped1:Disconnect()
                else
                    LocalPlayer.Character.Humanoid.WalkSpeed = GD_speed
                end
            end)
        end)
    elseif category == "工具" then
        -- 添加按钮
        local button = CreateButton(contentFrame, "回满血", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 25), 14)
        local button2 = CreateButton(contentFrame, "自杀", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 65), 14)
        local button3 = CreateButton(contentFrame, _G.ChronixHubisNightVisiton and "夜视(开)" or "夜视(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 25), 14)
        local button4 = CreateButton(contentFrame, "点击传送工具", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 105), 14)
        local button5 = CreateButton(contentFrame, _G.ChronixHubisChuanQiang and "穿墙(开)" or "穿墙(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 65), 14)
        local button6 = CreateButton(contentFrame, _G.ChronixHubisInfJump and "连跳(开)" or "连跳(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 105), 14)
        local button7 = CreateButton(contentFrame, _G.ChronixHubisTime and "切换时间(黑夜)" or "切换时间(白天)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 293, 0, 25), 14)
        local button8 = CreateButton(contentFrame, _G.ChronixHubHLEnable and "高级透视(开)" or "高级透视(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 293, 0, 65), 14)
        local button9 = CreateButton(contentFrame, "解锁鼠标(F5)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 423, 0, 25), 14)
        local button10 = CreateButton(contentFrame, _G.ChronixHubisAirWalking and "空中移动(开)" or "空中移动(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 293, 0, 105), 14)
        local button11 = CreateButton(contentFrame, _G.ChronixhubAntiFallDown and "防击倒(开)" or "防击倒(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 145), 14)
        local button12 = CreateButton(contentFrame, _G.ChronixHubAntiDead and "阻止死亡(开)" or "阻止死亡(关)", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 185), 14)

        -- 按钮点击逻辑
        button.MouseButton1Click:Connect(function()
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth 
        end)

        button2.MouseButton1Click:Connect(function()
            LocalPlayer.Character.Humanoid.Health = 0
            HumanDied = true
        end)

        button3.MouseButton1Click:Connect(function()
            if _G.ChronixHubisNightVisiton then
                game.Lighting.Ambient = Color3.new(0, 0, 0)
                button3.Text = "夜视(关)"
                _G.ChronixHubisNightVisiton = false
            else
                game.Lighting.Ambient = Color3.new(1, 1, 1)
                button3.Text = "夜视(开)"
                _G.ChronixHubisNightVisiton = true
            end
        end)

        button4.MouseButton1Click:Connect(function()
            mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "手持点击传送" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
        end)

        button5.MouseButton1Click:Connect(function()
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            _G.ChronixHubisChuanQiang = not _G.ChronixHubisChuanQiang
            button5.Text = _G.ChronixHubisChuanQiang and "穿墙(开)" or "穿墙(关)"
            Stepped = game:GetService("RunService").Stepped:Connect(function()
	            if not _G.ChronixHubisChuanQiang == false then
		            for a, b in pairs(Workspace:GetChildren()) do
                        if b.Name == Players.LocalPlayer.Name then
                            for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end end end end
	            else
                    for a, b in pairs(Workspace:GetChildren()) do
                        if b.Name == Players.LocalPlayer.Name then
                            for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = true
                                end end end end
		        Stepped:Disconnect()
	            end
            end)
        end)

        button6.MouseButton1Click:Connect(function()
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            local lp = Players.LocalPlayer
            _G.ChronixHubisInfJump = not _G.ChronixHubisInfJump
            button6.Text = _G.ChronixHubisInfJump and "连跳(开)" or "连跳(关)"
            JR = game:GetService("UserInputService").JumpRequest:Connect(function()
                if not _G.ChronixHubisInfJump then
                    JR:Disconnect()
                end
                if _G.ChronixHubisInfJump then
                    local c = lp.Character
                    if c and c.Parent then
                        local hum = c:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:ChangeState("Jumping")
                        end
                    end
                end
            end)
        end)

        button7.MouseButton1Click:Connect(function()
            _G.ChronixHubisTime = not _G.ChronixHubisTime
            button7.Text = _G.ChronixHubisTime and "切换时间(黑夜)" or "切换时间(白天)"
            if _G.ChronixHubisTime then setNight() else setDay() end
        end)

        button8.MouseButton1Click:Connect(function()
            _G.ChronixHubHLEnable = not _G.ChronixHubHLEnable
            button8.Text = _G.ChronixHubHLEnable and "高级透视(开)" or "高级透视(关)"
	        if not _G.ChronixHubHLEnable then
                -- 关闭功能时移除所有高亮和用户名标签
                for _, player in ipairs(Players:GetPlayers()) do
                    removePlayerEffects(player)
                end
                for player, highlight in pairs(highlights) do
                    highlight:Destroy()
                end
                for player, label in pairs(usernameLabels) do
                    billboard:Destroy()
                end
                highlights = {}
                usernameLabels = {}
            else
                for _, player in ipairs(Players:GetPlayers()) do
                    addHighlight(player)
                    addUsernameLabel(player)
                end
            end
        end)

        button10.MouseButton1Click:Connect(function()
            toggleAirWalk()
            button10.Text = _G.ChronixHubisAirWalking and "空中移动(开)" or "空中移动(关)"
        end)

        button11.MouseButton1Click:Connect(function()
            _G.ChronixhubAntiFallDown = not _G.ChronixhubAntiFallDown
            button11.Text = _G.ChronixhubAntiFallDown and "防击倒(开)" or "防击倒(关)"
        end)

        button12.MouseButton1Click:Connect(function()
            _G.ChronixHubAntiDead = not _G.ChronixHubAntiDead
            button12.Text = _G.ChronixHubAntiDead and "阻止死亡(开)" or "阻止死亡(关)"
            Stepped6 = game:GetService("RunService").Stepped:Connect(function()
	            if not _G.ChronixHubAntiDead == false then
		            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	            else
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		            Stepped6:Disconnect()
	            end
            end)
        end)
    elseif category == "脚本中心" then
        -- 添加按钮
        local button = CreateButton(contentFrame, "飞行 V4", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 25), 14)
        local button2 = CreateButton(contentFrame, "通用自瞄", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 65), 14)
        local button3 = CreateButton(contentFrame, "Doors扫描器", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 105), 14)
        local button4 = CreateButton(contentFrame, "通用ESP", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 145), 14)
        local button5 = CreateButton(contentFrame, "冬凌中心", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 185), 14)
        local button6 = CreateButton(contentFrame, "OldMSPaint", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 225), 14)
        local button7 = CreateButton(contentFrame, "玩家控制", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 25), 14)
        local button8 = CreateButton(contentFrame, "死亡球", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 65), 14)
        local button9 = CreateButton(contentFrame, "格蕾丝", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 33, 0, 105), 14)
        local button10 = CreateButton(contentFrame, "情云中心", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 65), 14)
        local button11 = CreateButton(contentFrame, "DEX", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 105), 14)
        local button12 = CreateButton(contentFrame, "ProjectTransfur", UDim2.new(0.2, 0, 0.1, 0), UDim2.new(0, 163, 0, 105), 14)

        -- 按钮点击逻辑
        button.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 飞行 V4 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/FlyV4.lua"))()
            CreateNotification("提示", "飞行 V4 已经成功启动!", 10, true)
        end)

        button2.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 通用自瞄 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/Zimiao.lua"))()
            CreateNotification("提示", "通用自瞄 已经成功启动!", 10, true)
        end)

        button3.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 Doors扫描器 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/DoorsNVC3000.lua"))()
            CreateNotification("提示", "Doors扫描器 已经成功启动!", 10, true)
        end)

        button4.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 通用ESP 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/ESP.lua"))()
            CreateNotification("提示", "通用ESP 已经成功启动!", 10, true)
        end)

        button5.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 冬凌中心 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/DongLingLobby.lua"))()
            CreateNotification("提示", "冬凌中心 已经成功启动!", 10, true)
        end)

        button6.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 OldMSPaint 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/mspaint/main/main.lua"))()
            CreateNotification("提示", "OldMSPaint 已经成功启动!", 10, true)
        end)

        button7.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 玩家控制 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/ScriptStorage/raw/main/PlayerControl.lua"))()
            CreateNotification("提示", "玩家控制 已经成功启动!", 10, true)
        end)

        button8.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 死亡球 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/Deathball.lua"))()
            CreateNotification("提示", "死亡球 已经成功启动!", 10, true)
        end)

        button9.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 格蕾丝 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/Grace.lua"))()
            CreateNotification("提示", "格蕾丝 已经成功启动!", 10, true)
        end)

        button10.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 情云中心 脚本，请耐心等待.", 10, true)
            loadstring(utf8.char((function() return table.unpack({108,111,97,100,115,116,114,105,110,103,40,103,97,109,101,58,72,116,116,112,71,101,116,40,34,104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,67,104,105,110,97,81,89,47,45,47,109,97,105,110,47,37,69,54,37,56,51,37,56,53,37,69,52,37,66,65,37,57,49,34,41,41,40,41})end)()))()
            CreateNotification("提示", "情云中心 已经成功启动!", 10, true)
        end)

        button11.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 DEX 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
            CreateNotification("提示", "DEX 已经成功启动!", 10, true)
        end)

        button12.MouseButton1Click:Connect(function()
            CreateNotification("提示", "正在启动 ProjectTransfur 脚本，请耐心等待.", 10, true)
            loadstring(game:HttpGet("https://raw.gitcode.com/Furrycalin/RobloxScripts/raw/main/ProjectTransfur.lua"))()
            CreateNotification("提示", "ProjectTransfur 已经成功启动!", 10, true)
        end)
    elseif category == "设置" then
        -- 添加“卸载菜单”按钮
        local unloadButton = CreateButton(contentFrame, "卸载菜单 (DELETE)", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0.1, 0, 0.1, 0), 14)

        -- 点击按钮卸载菜单
        unloadButton.MouseButton1Click:Connect(function()
            destroyFloor()
            resetBianLiang()
            _G.ChronixHubisLoaded = false
            Gui:Destroy() -- 卸载整个菜单系统
            for _, player in ipairs(Players:GetPlayers()) do
                removePlayerEffects(player)
            end
            highlight:Destroy()
            billboard:Destroy()
            sound:Stop() -- 先停止播放
            sound:Destroy()
        end)

                -- 添加快捷键绑定功能
        local shortcutLabel = CreateLabel(contentFrame, "绑定快捷键", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0.1, 0, 0.3, 0), 15)
        local shortcutTextBox = CreateTextBox(contentFrame, keyText, UDim2.new(0.35, 0, 0.1, 0), UDim2.new(0.1, 0, 0.4, 0), 14)
        local saveShortcutButton = CreateButton(contentFrame, "保存快捷键", UDim2.new(0.35, 0, 0.1, 0), UDim2.new(0.55, 0, 0.4, 0), 14)

        -- 保存快捷键绑定
        saveShortcutButton.MouseButton1Click:Connect(function()
            keyText = shortcutTextBox.Text
            local keyCode = Enum.KeyCode[keyText]
            if keyCode then
                boundKey = Enum.KeyCode[keyText]
                CreateNotification("提示", "快捷键已绑定为: " .. keyText, 5, true)
            else
                CreateNotification("错误", "无效的快捷键: " .. keyText, 5, true)
            end
        end)
    elseif category == "执行器" then
        -- 添加多行文本框
        local scriptTextBox = Instance.new("TextBox")
        scriptTextBox.Size = UDim2.new(0.9, 0, 0.94, 0) -- 文本框大小
        scriptTextBox.Position = UDim2.new(0.05, 0, 0.05, 0) -- 文本框位置
        scriptTextBox.BackgroundColor3 = CONFIG.BUTTON_COLOR
        scriptTextBox.TextColor3 = CONFIG.TEXT_COLOR
        scriptTextBox.TextSize = 14
        scriptTextBox.TextWrapped = true -- 允许多行输入
        scriptTextBox.MultiLine = true -- 允许多行输入
        scriptTextBox.ClearTextOnFocus = false
        scriptTextBox.TextXAlignment = Enum.TextXAlignment.Left -- 文本靠左对齐
        scriptTextBox.TextYAlignment = Enum.TextYAlignment.Top -- 文本靠左对齐
        scriptTextBox.Parent = contentFrame
        scriptTextBox.Text = _G.ChronixHubExecuteText

        -- 添加执行按钮
        local saveButton = CreateButton(contentFrame, "保存", UDim2.new(0.45, 0, 0.1, 0), UDim2.new(0.05, 0, 1, 0), 18)
        saveButton.MouseButton1Click:Connect(function()
            CreateNotification("提示", "脚本保存成功! 卸载脚本将会丢失", 5, true)
            _G.ChronixHubExecuteText = scriptTextBox.Text
        end)
        local executeButton = CreateButton(contentFrame, "执行", UDim2.new(0.45, 0, 0.1, 0), UDim2.new(0.5, 0, 1, 0), 18)
        executeButton.MouseButton1Click:Connect(function()
            local script = scriptTextBox.Text
            if script and script ~= "" then
                -- 尝试执行脚本
                local success, errorMessage = pcall(function()
                    loadstring(script)()
                end)
                if not success then
                    CreateNotification("错误", "脚本执行失败: " .. errorMessage, 5, true)
                else
                    CreateNotification("提示", "脚本执行成功!", 5, true)
                end
            else
                CreateNotification("错误", "请输入有效的脚本!", 5, true)
            end
        end)
    elseif category == "播放器" then
        local labeltitle = CreateLabel(contentFrame, "输入正确的rbxassetid", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0.1, 0, 0.12, 0), 15)
        local rbxassetidinputbox = CreateTextBox(contentFrame, _G.ChronixHubMusicID, UDim2.new(0.55, 0, 0.1, 0), UDim2.new(0.22, 0, 0.22, 0), 14)
        local playbutton = CreateButton(contentFrame, _G.ChronixHubMusicisPlay and "停止" or "播放", UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.07, 0, 1, 0), 18)
        local loopbutton = CreateButton(contentFrame, sound.Looped and "不循环播放" or "循环播放", UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.67, 0, 1, 0), 18)
        local labeltitle2 = CreateLabel(contentFrame, "音量", UDim2.new(0.3, 0, 0.1, 0), UDim2.new(0.1, 0, 0.35, 0), 18)
        local vinputbox = CreateLabel(contentFrame, string.format("%.0f", sound.Volume*100) .. "%", UDim2.new(0.15, 0, 0.1, 0), UDim2.new(0.28, 0, 0.355, 0), 14)
        local volumeup = CreateButton(contentFrame, "+", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.55, 0, 0.355, 0), 14)
        local volumedown = CreateButton(contentFrame, "-", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.67, 0, 0.355, 0), 14)
        local pausebutton = CreateButton(contentFrame, _G.ChronixHubMusicisPause and "继续" or "暂停", UDim2.new(0.25, 0, 0.1, 0), UDim2.new(0.37, 0, 1, 0), 18)
        local labeltitle3 = CreateLabel(contentFrame, "音高", UDim2.new(0.3, 0, 0.1, 0), UDim2.new(0.1, 0, 0.45, 0), 18)
        local pinputbox = CreateLabel(contentFrame, string.format("%.1f", sound.Pitch), UDim2.new(0.15, 0, 0.1, 0), UDim2.new(0.28, 0, 0.455, 0), 14)
        local Pitchup = CreateButton(contentFrame, "+", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.55, 0, 0.455, 0), 14)
        local Pitchdown = CreateButton(contentFrame, "-", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.67, 0, 0.455, 0), 14)

        playbutton.MouseButton1Click:Connect(function()
            sound.SoundId = "rbxassetid://" .. rbxassetidinputbox.Text
            _G.ChronixHubMusicisPlay = not _G.ChronixHubMusicisPlay
            playbutton.Text = _G.ChronixHubMusicisPlay and "停止" or "播放"
            if _G.ChronixHubMusicisPlay then
                local success, productInfo = pcall(function()
                    return MarketplaceService:GetProductInfo(rbxassetidinputbox.Text)
                end)
                if success then
                    _G.ChronixHubMusicID = rbxassetidinputbox.Text
                    CreateNotification("正在播放...", productInfo.Name .. "\n" .. productInfo.Description, 20, true)
                    wait(1)
                    sound:play()
                else
                    _G.ChronixHubMusicisPlay = false
                    playbutton.Text = "播放"
                    pausebutton.Text = "暂停"
                    CreateNotification("播放失败", rbxassetidinputbox.Text .. "\n不是一个有效的rbxassetid", 20, true)
                end
            else
                sound:Stop()
                pausebutton.Text = "暂停"
                _G.ChronixHubMusicisPause = false
            end
        end)

        pausebutton.MouseButton1Click:Connect(function()
            if _G.ChronixHubMusicisPlay then
                _G.ChronixHubMusicisPause = not _G.ChronixHubMusicisPause
                pausebutton.Text = _G.ChronixHubMusicisPause and "继续" or "暂停"
                if _G.ChronixHubMusicisPause == true then
                    _G.ChronixHubMusicPlayLocation = sound.TimePosition
                    sound:Stop()
                elseif _G.ChronixHubMusicisPause == false then
                    sound.TimePosition = _G.ChronixHubMusicPlayLocation
                    sound:Play()
                end
            end
        end)

        volumeup.MouseButton1Click:Connect(function()
            sound.Volume = sound.Volume + 0.1
            vinputbox.Text = string.format("%.0f", sound.Volume*100) .. "%"
        end)

        volumedown.MouseButton1Click:Connect(function()
            if sound.Volume ~= 0 then sound.Volume = sound.Volume - 0.1 end
            vinputbox.Text = string.format("%.0f", sound.Volume*100) .. "%"
        end)

        Pitchup.MouseButton1Click:Connect(function()
            sound.Pitch = sound.Pitch + 0.1
            pinputbox.Text = string.format("%.1f", sound.Pitch)
        end)

        Pitchdown.MouseButton1Click:Connect(function()
            if sound.Pitch ~= 0 then sound.Pitch = sound.Pitch - 0.1 end
            pinputbox.Text = string.format("%.1f", sound.Pitch)
        end)

        loopbutton.MouseButton1Click:Connect(function()
            sound.Looped = not sound.Looped
            loopbutton.Text = sound.Looped and "不循环播放" or "循环播放"
        end)
    elseif category == "传送器" then
        local lcp1 = CreateTextBox(contentFrame, tbz.lcp1, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 10), 14)
        local lcpb1 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 10), 15)
        local lcpt1 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 10), 15)
        local lcp2 = CreateTextBox(contentFrame, tbz.lcp2, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 50), 14)
        local lcpb2 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 50), 15)
        local lcpt2 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 50), 15)
        local lcp3 = CreateTextBox(contentFrame, tbz.lcp3, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 90), 14)
        local lcpb3 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 90), 15)
        local lcpt3 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 90), 15)
        local lcp4 = CreateTextBox(contentFrame, tbz.lcp4, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 130), 14)
        local lcpb4 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 130), 15)
        local lcpt4 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 130), 15)
        local lcp5 = CreateTextBox(contentFrame, tbz.lcp5, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 170), 14)
        local lcpb5 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 170), 15)
        local lcpt5 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 170), 15)
        local lcp6 = CreateTextBox(contentFrame, tbz.lcp6, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 210), 14)
        local lcpb6 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 210), 15)
        local lcpt6 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 210), 15)
        local lcp7 = CreateTextBox(contentFrame, tbz.lcp7, UDim2.new(0, 113, 0, 32), UDim2.new(0, 13, 0, 250), 14)
        local lcpb7 = CreateButton(contentFrame, "记录", UDim2.new(0, 73, 0, 32), UDim2.new(0, 133, 0, 250), 15)
        local lcpt7 = CreateButton(contentFrame, "传送", UDim2.new(0, 73, 0, 32), UDim2.new(0, 213, 0, 250), 15)
        local teleportto = CreateButton(contentFrame, "传送至", UDim2.new(0, 255, 0, 32), UDim2.new(0, 317, 0, 250), 15)
        local selectplayer = ""
        -- 创建 ScrollingFrame
        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Size = UDim2.new(0, 250, 0, 230) -- 设置大小
        scrollingFrame.Position = UDim2.new(0.52, 0, 0.04, 0) -- 设置位置
        scrollingFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
        scrollingFrame.BorderSizePixel = 0 -- 边框大小
        scrollingFrame.ScrollBarThickness = 10 -- 滚动条宽度
        scrollingFrame.Parent = contentFrame
        -- 设置 CanvasSize（内容区域大小）
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 初始大小为 0
        -- 按钮高度和间距
        local buttonHeight = 30
        local padding = 5

        -- 创建玩家按钮
        local function createPlayerButton(playerName, index)
            local button = Instance.new("TextButton")
            button.Text = playerName
            button.Size = UDim2.new(1, -scrollingFrame.ScrollBarThickness, 0, buttonHeight)
            button.Position = UDim2.new(0, 0, 0, (buttonHeight + padding) * (index - 1))
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 18
            button.Parent = scrollingFrame

            -- 点击按钮触发代码
            button.MouseButton1Click:Connect(function()
                selectplayer = button.Text
                teleportto.Text = "传送至 " .. button.Text
            end)
        end

        -- 更新玩家列表
        local function updatePlayerList()
            -- 清空现有按钮
            for _, child in ipairs(scrollingFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end

            -- 获取所有玩家并创建按钮
            local players = Players:GetPlayers()
            for i, player in ipairs(players) do
                createPlayerButton(player.Name, i)
            end

            -- 更新 CanvasSize
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, (buttonHeight + padding) * #players)
        end

        -- 初始化玩家列表
        updatePlayerList()

        -- 监听玩家加入和离开事件
        Players.PlayerAdded:Connect(updatePlayerList)
        Players.PlayerRemoving:Connect(updatePlayerList)

        -- 根据玩家名传送自己到目标玩家位置
        local function teleportToPlayerByName(playerName)
            -- 获取目标玩家
            local targetPlayer
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name == playerName then
                    targetPlayer = player
                    break
                end
            end

            if not targetPlayer then
                warn("未找到目标玩家:", playerName)
                return
            end

            -- 获取目标玩家的位置
            local targetCharacter = targetPlayer.Character
            if not targetCharacter then
                warn("目标玩家没有角色！")
                return
            end

            local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
            if not targetRootPart then
                warn("目标玩家没有 HumanoidRootPart！")
                return
            end

            -- 获取自己的角色
            local localCharacter = LocalPlayer.Character
            if not localCharacter then
                warn("自己还没有角色！")
                return
         end

            local localRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
            if not localRootPart then
                warn("自己还没有 HumanoidRootPart！")
                return
            end

            -- 传送自己到目标位置
            localRootPart.CFrame = targetRootPart.CFrame
        end

        local function showjilulocation() CreateNotification("已记录位置", "X:" .. string.format("%.2f", HumanoidRootPart.Position.X) .. ", Y:" .. string.format("%.2f", HumanoidRootPart.Position.Y) .. ", Z:" .. string.format("%.2f", HumanoidRootPart.Position.Z), 5, true) end
        local function showtplocation(key) CreateNotification("已传送到", "X:" .. string.format("%.2f", teleportpoint[key].X) .. ", Y:" .. string.format("%.2f", teleportpoint[key].Y) .. ", Z:" .. string.format("%.2f", teleportpoint[key].Z), 5, true) end

        teleportto.MouseButton1Click:Connect(function()
            if selectplayer ~= "" then
                teleportToPlayerByName(selectplayer)
            end
        end)

        -- 定义 TextBox 和 tbz 键的映射关系
        local textBoxMap = {
            {textBox = lcp1, key = "lcp1"},
            {textBox = lcp2, key = "lcp2"},
            {textBox = lcp3, key = "lcp3"},
            {textBox = lcp4, key = "lcp4"},
            {textBox = lcp5, key = "lcp5"},
            {textBox = lcp6, key = "lcp6"},
            {textBox = lcp7, key = "lcp7"}
        }

        local lcbpMap = {
            {textBox = lcpb1, key = "locate1"},
            {textBox = lcpb2, key = "locate2"},
            {textBox = lcpb3, key = "locate3"},
            {textBox = lcpb4, key = "locate4"},
            {textBox = lcpb5, key = "locate5"},
            {textBox = lcpb6, key = "locate6"},
            {textBox = lcpb7, key = "locate7"},
            {textBox = lcpb8, key = "locate8"}
        }

        local lcbtMap = {
            {textBox = lcpt1, key = "locate1"},
            {textBox = lcpt2, key = "locate2"},
            {textBox = lcpt3, key = "locate3"},
            {textBox = lcpt4, key = "locate4"},
            {textBox = lcpt5, key = "locate5"},
            {textBox = lcpt6, key = "locate6"},
            {textBox = lcpt7, key = "locate7"},
            {textBox = lcpt8, key = "locate8"}
        }

        -- 封装 FocusLost 事件逻辑
        local function onFocusLost(textBox, key)
            textBox.FocusLost:Connect(function(enterPressed)
                if not enterPressed then
                    tbz[key] = textBox.Text
                end
            end)
        end
        local function onFocusLost2(textBox, key)
            textBox.MouseButton1Click:Connect(function()
                teleportpoint[key] = HumanoidRootPart.Position
                showjilulocation()
            end)
        end
        local function onFocusLost3(textBox, key)
            textBox.MouseButton1Click:Connect(function()
                if teleportpoint[key] ~= nil then HumanoidRootPart.CFrame = CFrame.new(teleportpoint[key]) showtplocation(key) end
            end)
        end

        -- 为每个 TextBox 绑定事件
        for _, item in ipairs(textBoxMap) do
            onFocusLost(item.textBox, item.key)
        end
        for _, item in ipairs(lcbpMap) do
           onFocusLost2(item.textBox, item.key)
        end
        for _, item in ipairs(lcbtMap) do
           onFocusLost3(item.textBox, item.key)
        end

    elseif category == "关于" then
        local l1 = CreateLabel(contentFrame, "作者: Chronix", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, 55, 0, 50), 14)
        l1.TextXAlignment = Enum.TextXAlignment.Left
        local l2 = CreateLabel(contentFrame, "好像没什么可以写的了", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, 55, 0, 75), 14)
        l2.TextXAlignment = Enum.TextXAlignment.Left
        local d1 = CreateLabel(contentFrame, "所有代码均为Chronix编写, 可以参考学习，严禁盗用", UDim2.new(0.8, 0, 0.1, 0), UDim2.new(0, 55, 1, 0), 14)
    end
end

-- 添加分类按钮
local categories = {"基础", "工具", "脚本中心", "传送器", "执行器", "播放器", "设置", "关于"}
for i, cat in ipairs(categories) do
    local button = Instance.new("TextButton")
    button.Size = CONFIG.CATEGORY_BUTTON_SIZE
    button.Position = UDim2.new(
        0, 
        -100, 
        (i - 1) * (CONFIG.CATEGORY_BUTTON_SIZE.Y.Scale + CONFIG.CATEGORY_BUTTON_SPACING / menuFrame.AbsoluteSize.Y) + CONFIG.CATEGORY_BUTTON_INSET / menuFrame.AbsoluteSize.Y, 
        0
    )
    button.BackgroundColor3 = CONFIG.BUTTON_COLOR
    button.Text = cat
    button.TextColor3 = CONFIG.TEXT_COLOR
    button.TextSize = 18
    button.Parent = categoryButtonsFrame

    button.MouseButton1Click:Connect(function()
        AddMenuContent(cat) -- 切换菜单内容
    end)
end

-- 默认内容
AddMenuContent("关于")

-- 箭头按钮滑入滑出逻辑
local function ToggleArrow(visible)
    local targetPosition = visible and CONFIG.ARROW_POSITION_VISIBLE or CONFIG.ARROW_POSITION_HIDDEN
    local tween = TweenService:Create(arrowButton, CONFIG.TWEEN_INFO, { Position = targetPosition })
    tween:Play()
end

-- 菜单弹出逻辑
local function ToggleMenu(visible)
    local targetPosition = visible and CONFIG.MENU_POSITION_VISIBLE or CONFIG.MENU_POSITION_HIDDEN
    local tween = TweenService:Create(menuFrame, CONFIG.TWEEN_INFO, { Position = targetPosition })
    tween:Play()
    if visible then
        ToggleArrow(false) -- 弹出菜单后隐藏箭头
    end
end

-- 鼠标移动检测
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and not isMenuVisible then
        local mouseY = input.Position.Y
        local screenHeight = Gui.AbsoluteSize.Y
        if mouseY > screenHeight * 0.95 then -- 鼠标在屏幕底部 5% 区域
            ToggleArrow(true)
        else
            ToggleArrow(false)
        end
    end
end)

-- 点击菜单外部关闭菜单
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and isMenuVisible then
        local mousePosition = input.Position
        local menuPosition = menuFrame.AbsolutePosition
        local menuSize = menuFrame.AbsoluteSize
        if not (mousePosition.X >= menuPosition.X - 100 and mousePosition.X <= menuPosition.X + menuSize.X and
                mousePosition.Y >= menuPosition.Y and mousePosition.Y <= menuPosition.Y + menuSize.Y) then
            isMenuVisible = not isMenuVisible
            ToggleMenu(isMenuVisible)
        end
    end
end)

-- 点击箭头按钮弹出菜单
arrowButton.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    ToggleMenu(isMenuVisible)
end)

-- 监听快捷键
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == boundKey then
        isMenuVisible = not isMenuVisible
        ToggleMenu(isMenuVisible)
    end
end)

-- 按下 Delete 键卸载菜单
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        destroyFloor()
        resetBianLiang()
        _G.ChronixHubisLoaded = false
        Gui:Destroy() -- 卸载整个菜单系统
        for _, player in ipairs(Players:GetPlayers()) do
            removePlayerEffects(player)
        end
        highlight:Destroy()
        billboard:Destroy()
        sound:Stop() -- 先停止播放
        sound:Destroy()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default -- 解锁鼠标
        if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then CreateNotification("警告", "解锁失败, 第一人称无法解锁或已被作者刻意锁定.", 5, true) else CreateNotification("提示", "已解锁鼠标.", 5, true) end
    end
end)

if GetDeviceType() == "Desktop" then
    CreateNotification("欢迎使用，电脑用户" .. displayName, "ChronixHub已启动!\n反挂机系统已自动开启", 10, true)
elseif GetDeviceType() == "Mobile" then
    CreateNotification("欢迎使用，手机用户" .. displayName, "ChronixHub已启动!\n反挂机系统已自动开启", 10, true)
end
wait(1)
CreateNotification("启用方法", "按下F1开关菜单, 鼠标移动到屏幕正下方点击弹出\n手机端点击悬浮球开关菜单", 10, true)

-- 监听玩家加入
Players.PlayerAdded:Connect(function(player)
    if _G.ChronixHubHLEnable then
        for _, player in ipairs(Players:GetPlayers()) do
            removePlayerEffects(player)
            addHighlight(player)
            addUsernameLabel(player)
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(function()
                        removePlayerEffects(player)
                        addHighlight(player)
                        addUsernameLabel(player)
                    end)
                end
            end
        end
        -- 监听玩家角色加载
        player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                removePlayerEffects(player)
                addHighlight(player)
                addUsernameLabel(player)
            end)
        end)
    end
end)

-- 监听玩家死亡事件
local function onCharacterDied()
    if _G.ChronixHubisAirWalking then
        _G.ChronixHubisAirWalking = false
        button10.Text = "空中移动(关)"
        destroyFloor()
    end
end

-- 监听角色变化
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- 重新绑定死亡事件
    Humanoid.Died:Connect(onCharacterDied)
end)

-- 初始绑定死亡事件
Humanoid.Died:Connect(onCharacterDied)

-- 监听玩家离开
Players.PlayerRemoving:Connect(function(player)
    if _G.ChronixHubHLEnable then
        removePlayerEffects(player)
    end
end)

-- 监听状态变化
Humanoid.StateChanged:Connect(function(oldState, newState)
    if _G.ChronixhubAntiFallDown then
        if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- 强制恢复站立状态
            CreateNotification("提示", "检测到被击倒，已恢复站立状态", 5, true)
        end
    end
end)

local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(0.045, 0, 0.09, 0) -- 圆形悬浮窗大小
dragButton.Position = UDim2.new(0.4, 0, 0.1, 0) -- 初始位置
dragButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- 背景颜色
dragButton.Text = "☄" -- 悬浮窗图标
dragButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- 文字颜色
dragButton.BackgroundTransparency = 0.2
dragButton.TextSize = 20
dragButton.ZIndex = 999
if GetDeviceType() == "Mobile" then
    dragButton.Parent = Gui
    CreateNotification("提示", "检测到使用设备为移动端，已启用悬浮窗", 10, false)
end

-- 圆角效果
local uiCorner = Instance.new("UICorner", dragButton)
uiCorner.CornerRadius = UDim.new(1, 0) -- 完全圆形

-- 悬浮窗拖动逻辑
local isDragging = false
local ismenuopen = false
local dragStartPos
local dragStartMousePos

dragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = dragButton.Position
        dragStartMousePos = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

dragButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartMousePos
        dragButton.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)

-- 点击悬浮窗开关菜单
dragButton.MouseButton1Click:Connect(function()
    if isMenuVisible == false and ismenuopen == false then
        isMenuVisible = true
        ismenuopen = true
        ToggleMenu(true)
    elseif ismenuopen == true then
        isMenuVisible = false
        ismenuopen = false
        ToggleMenu(false)
    end
end)