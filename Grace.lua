local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local notifications = {}

_G.ChronixGraceMenuisMin = false
_G.ChronixGraceAutoLever = false
_G.ChronixGraceEntitieControl = false
_G.ChronixGraceDeleteEye = false
_G.ChronixGraceDeleteSmile = false
_G.ChronixGraceDeleteRush = false
_G.ChronixGraceDeleteWorm = false
_G.ChronixGraceDeleteSorrow = false
_G.ChronixGraceDeleteGoatman = false

local Gui = Instance.new("ScreenGui")
Gui.Parent = game.CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false

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

local window = Instance.new("Frame")
window.Size = UDim2.new(0, 190, 0, 337)
window.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
window.BackgroundColor3 = Color3.new(1, 1, 1)
window.BackgroundTransparency = 0.8
window.BorderSizePixel = 0
window.ZIndex = 10
window.Parent = Gui
window.Draggable = true

local uiCorner = Instance.new("UICorner", window)
uiCorner.CornerRadius = UDim.new(0, 5)

local titleBar = Instance.new("Frame", window)
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.ZIndex = window.ZIndex + 1

local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 5)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "Grace by Chronix"
titleText.TextColor3 = Color3.new(0, 0, 0)
titleText.TextSize = 14
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Position = UDim2.new(0.05, 0, 0, 0)

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.new(0, 15, 0, 15)
close.Text = "×"
close.TextColor3 = Color3.new(1, 0, 0)
close.TextSize = 14
close.BackgroundTransparency = 1
close.TextXAlignment = Enum.TextXAlignment.Right
close.Position = UDim2.new(1, 0, 0, 0)

local min = Instance.new("TextButton", titleBar)
min.Size = UDim2.new(0, 15, 0, 15)
min.Text = "↑"
min.TextColor3 = Color3.new(0, 1, 0)
min.TextSize = 18
min.BackgroundTransparency = 1
min.TextXAlignment = Enum.TextXAlignment.Right
min.Position = UDim2.new(0.88, 0, 0, 0)

local button = Instance.new("TextButton", window)
button.Size = UDim2.new(0, 140, 0, 25)
button.Text = "自动拉杆(关)"
button.TextColor3 = Color3.new(0, 0, 0)
button.TextSize = 14
button.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button.BorderSizePixel = 0
button.Position = UDim2.new(0, 22, 0, 53)

local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 9)

local Text = Instance.new("TextLabel", window)
Text.Size = UDim2.new(0, 39, 0, 25)
Text.Text = "实体控制"
Text.TextColor3 = Color3.new(1, 1, 1)
Text.TextSize = 23
Text.Font = Enum.Font.GothamBold
Text.BackgroundTransparency = 1
Text.BorderSizePixel = 0
Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text.Position = UDim2.new(0, 22, 0, 82)

local Text2 = Instance.new("TextLabel", window)
Text2.Size = UDim2.new(0, 39, 0, 25)
Text2.Text = "基础控制"
Text2.TextColor3 = Color3.new(1, 1, 1)
Text2.TextSize = 23
Text2.Font = Enum.Font.GothamBold
Text2.BackgroundTransparency = 1
Text2.BorderSizePixel = 0
Text2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Text2.Position = UDim2.new(0, 22, 0, 22)

local button2 = Instance.new("TextButton", window)
button2.Size = UDim2.new(0, 140, 0, 25)
button2.Text = "总开关(关)"
button2.TextColor3 = Color3.new(0, 0, 0)
button2.TextSize = 14
button2.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button2.BorderSizePixel = 0
button2.Position = UDim2.new(0, 22, 0, 113)

local button2Corner = Instance.new("UICorner", button2)
button2Corner.CornerRadius = UDim.new(0, 9)

local button3 = Instance.new("TextButton", window)
button3.Size = UDim2.new(0, 140, 0, 25)
button3.Text = "删除Eye(关)"
button3.TextColor3 = Color3.new(0, 0, 0)
button3.TextSize = 14
button3.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button3.BorderSizePixel = 0
button3.Position = UDim2.new(0, 22, 0, 143)

local button3Corner = Instance.new("UICorner", button3)
button3Corner.CornerRadius = UDim.new(0, 9)

local button4 = Instance.new("TextButton", window)
button4.Size = UDim2.new(0, 140, 0, 25)
button4.Text = "删除Smile(关)"
button4.TextColor3 = Color3.new(0, 0, 0)
button4.TextSize = 14
button4.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button4.BorderSizePixel = 0
button4.Position = UDim2.new(0, 22, 0, 173)

local button4Corner = Instance.new("UICorner", button4)
button4Corner.CornerRadius = UDim.new(0, 9)

local button5 = Instance.new("TextButton", window)
button5.Size = UDim2.new(0, 140, 0, 25)
button5.Text = "删除Rush(关)"
button5.TextColor3 = Color3.new(0, 0, 0)
button5.TextSize = 14
button5.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button5.BorderSizePixel = 0
button5.Position = UDim2.new(0, 22, 0, 203)

local button5Corner = Instance.new("UICorner", button5)
button5Corner.CornerRadius = UDim.new(0, 9)

local button6 = Instance.new("TextButton", window)
button6.Size = UDim2.new(0, 140, 0, 25)
button6.Text = "删除Worm(关)"
button6.TextColor3 = Color3.new(0, 0, 0)
button6.TextSize = 14
button6.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button6.BorderSizePixel = 0
button6.Position = UDim2.new(0, 22, 0, 233)

local button6Corner = Instance.new("UICorner", button6)
button6Corner.CornerRadius = UDim.new(0, 9)

local button7 = Instance.new("TextButton", window)
button7.Size = UDim2.new(0, 140, 0, 25)
button7.Text = "删除Sorrow(关)"
button7.TextColor3 = Color3.new(0, 0, 0)
button7.TextSize = 14
button7.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button7.BorderSizePixel = 0
button7.Position = UDim2.new(0, 22, 0, 263)

local button7Corner = Instance.new("UICorner", button7)
button7Corner.CornerRadius = UDim.new(0, 9)

local button8 = Instance.new("TextButton", window)
button8.Size = UDim2.new(0, 140, 0, 25)
button8.Text = "删除Goatman(关)"
button8.TextColor3 = Color3.new(0, 0, 0)
button8.TextSize = 14
button8.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
button8.BorderSizePixel = 0
button8.Position = UDim2.new(0, 22, 0, 293)

local button8Corner = Instance.new("UICorner", button8)
button8Corner.CornerRadius = UDim.new(0, 9)

pe = workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ParticleEmitter") then
        descendant.Rate = descendant.Rate * 10
    end
end)

local count = 0

al = workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "base" and descendant:IsA("BasePart") and _G.ChronixGraceAutoLever then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            descendant.CFrame = player.Character.HumanoidRootPart.CFrame
            count = count + 1
            if count >= 3 then
                CreateNotification("提示", "全部拉杆已被激活\n门已打开", 5, true)
                count = 0
            end
            task.wait(1)
            descendant.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end)

ds = workspace.DescendantAdded:Connect(function(descendant)
    if _G.ChronixGraceEntitieControl then
    if descendant.Name == "eye" or descendant.Name == "elkman" or descendant.Name == "Rush" or descendant.Name == "Worm" or descendant.Name == "eyePrime" then
        descendant:Destroy()
    end
    end
end)

local isDragging = false
local dragStartPos
local windowStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        windowStartPos = window.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        window.Position = UDim2.new(
            windowStartPos.X.Scale,
            windowStartPos.X.Offset + delta.X,
            windowStartPos.Y.Scale,
            windowStartPos.Y.Offset + delta.Y
        )
    end
end)


Stepped = game:GetService("RunService").Stepped:Connect(function()
    if _G.ChronixGraceEntitieControl then 
    local RS = game:GetService("ReplicatedStorage")
    if _G.ChronixGraceDeleteEye then RS.eyegui:Destroy() end
    if _G.ChronixGraceDeleteSmile then RS.smilegui:Destroy() end
    if _G.ChronixGraceDeleteRush then RS.SendRush:Destroy() end
    if _G.ChronixGraceDeleteWorm then RS.SendWorm:Destroy() end
    if _G.ChronixGraceDeleteSorrow then RS.SendSorrow:Destroy() end
    if _G.ChronixGraceDeleteGoatman then RS.SendGoatman:Destroy() end
    wait(0.1)
    if _G.ChronixGraceDeleteWorm then RS.Worm:Destroy() end
    RS.elkman:Destroy()
    wait(0.1)
    if _G.ChronixGraceDeleteEye then RS.QuickNotes.Eye:Destroy() end
    if _G.ChronixGraceDeleteRush then RS.QuickNotes.Rush:Destroy() end
    if _G.ChronixGraceDeleteSorrow then RS.QuickNotes.Sorrow:Destroy() end
    RS.QuickNotes.elkman:Destroy()  
    RS.QuickNotes.EyePrime:Destroy()
    RS.QuickNotes.SlugFish:Destroy()
    RS.QuickNotes.FakeDoor:Destroy()
    RS.QuickNotes.SleepyHead:Destroy()
    local SmileGui = player:FindFirstChild("PlayerGui"):FindFirstChild("smilegui")
    if SmileGui and _G.ChronixGraceDeleteSmile then
        SmileGui:Destroy()
    end
    end
end)

button.MouseButton1Click:Connect(function()
    _G.ChronixGraceAutoLever = not _G.ChronixGraceAutoLever
    button.Text = _G.ChronixGraceAutoLever and "自动拉杆(开)" or "自动拉杆(关)"
    CreateNotification("提示", _G.ChronixGraceAutoLever and "自动激活拉杆已开启" or "自动激活拉杆已关闭", 5, true)
end)

button2.MouseButton1Click:Connect(function()
    _G.ChronixGraceEntitieControl = not _G.ChronixGraceEntitieControl
    button2.Text = _G.ChronixGraceEntitieControl and "总开关(开)" or "总开关(关)"
    CreateNotification("提示", _G.ChronixGraceEntitieControl and "实体控制已开启" or "实体控制已关闭", 5, true)
end)

button3.MouseButton1Click:Connect(function()
    _G.ChronixGraceDeleteEye = not _G.ChronixGraceDeleteEye
    button3.Text = _G.ChronixGraceDeleteEye and "删除Eye(开)" or "删除Eye(关)"
    CreateNotification("提示", _G.ChronixGraceDeleteEye and "删除Eye已开启" or "删除Eye已关闭", 5, true)
end)

button4.MouseButton1Click:Connect(function()
    _G.ChronixGraceDeleteSmile = not _G.ChronixGraceDeleteSmile
    button4.Text = _G.ChronixGraceDeleteSmile and "删除Smile(开)" or "删除Smile(关)"
    CreateNotification("提示", _G.ChronixGraceDeleteSmile and "删除Smile已开启" or "删除Smile已关闭", 5, true)
end)

button5.MouseButton1Click:Connect(function()
    _G.ChronixGraceDeleteRush = not _G.ChronixGraceDeleteRush
    button5.Text = _G.ChronixGraceDeleteRush and "删除Rush(开)" or "删除Rush(关)"
    CreateNotification("提示", _G.ChronixGraceDeleteRush and "删除Rush已开启" or "删除Rush已关闭", 5, true)
end)

button6.MouseButton1Click:Connect(function()
    _G.ChronixGraceDeleteWorm = not _G.ChronixGraceDeleteWorm
    button6.Text = _G.ChronixGraceDeleteWorm and "删除Worm(开)" or "删除Worm(关)"
    CreateNotification("提示", _G.ChronixGraceDeleteWorm and "删除Worm已开启" or "删除Worm已关闭", 5, true)
end)

button7.MouseButton1Click:Connect(function()
    _G.ChronixGraceDeleteSorrow = not _G.ChronixGraceDeleteSorrow
    button7.Text = _G.ChronixGraceDeleteSorrow and "删除Sorrow(开)" or "删除Sorrow(关)"
    CreateNotification("提示", _G.ChronixGraceDeleteSorrow and "删除Sorrow已开启" or "删除Sorrow已关闭", 5, true)
end)

button8.MouseButton1Click:Connect(function()
    _G.ChronixGraceDeleteGoatman = not _G.ChronixGraceDeleteGoatman
    button8.Text = _G.ChronixGraceDeleteGoatman and "删除Goatman(开)" or "删除Goatman(关)"
    CreateNotification("提示", _G.ChronixGraceDeleteGoatman and "删除Goatman已开启" or "删除Goatman已关闭", 5, true)
end)

min.MouseButton1Click:Connect(function()
    _G.ChronixGraceMenuisMin = not _G.ChronixGraceMenuisMin
    if _G.ChronixGraceMenuisMin then
        min.Text = "↓"
        button.Parent = nil
        Text.Parent = nil
        Text2.Parent = nil
        button2.Parent = nil
        button3.Parent = nil
        button4.Parent = nil
        button5.Parent = nil
        button6.Parent = nil
        button7.Parent = nil
        button8.Parent = nil
        window.Size = UDim2.new(0, 190, 0, 20)
    else
        min.Text = "↑"
        button.Parent = window
        Text.Parent = window
        Text2.Parent = window
        button2.Parent = window
        button3.Parent = window
        button4.Parent = window
        button5.Parent = window
        button6.Parent = window
        button7.Parent = window
        button8.Parent = window
        window.Size = UDim2.new(0, 190, 0, 337)
    end
end)

close.MouseButton1Click:Connect(function()
    _G.ChronixGraceEntitieControl = false
    pe:Disconnect()
    al:Disconnect()
    ds:Disconnect()
    Stepped:Disconnect()
    Gui:Destroy()
end)

CreateNotification("提示", "Grace脚本已启动\n作者: Chronix", 5, true)