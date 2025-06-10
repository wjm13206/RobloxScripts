-- 死亡球脚本 by Chronix
-- Update in 2025.2.9

if game.GameId ~= 5166944221 then
    warn("⛔ Current Game ID " .. game.GameId .. ", Not in Deathball game, script loading terminated.")
    return
end
if _G.DeathBallScriptLoaded then
    warn("⛔ Deathball Script Already loaded! Please do not repeat the execution.")
    return
end
 
_G.DeathBallScriptLoaded = true

print("Deathball Script Loading...")
print("")
local Players = game:GetService("Players")
print("✅ Service - Players Get Done.")
local LocalPlayer = Players.LocalPlayer
print("✅ Service - LocalPlayer Get Done.")
local Workspace = game:GetService("Workspace")
print("✅ Service - Workspace Get Done.")
local UserInputService = game:GetService("UserInputService")
print("✅ Service - UserInputService Get Done.")
local VirtualInputManager = game:GetService("VirtualInputManager")
print("✅ Service - VirtualInputMnager Get Done.")
local StarterGui = game:GetService("StarterGui")
print("✅ Service - StarterGui Get Done.")
local TweenService = game:GetService("TweenService")
print("✅ Service - TweenService Get Done.")
local SoundService = game:GetService("SoundService")
print("✅ Service - SoundService Get Done.")

local NotifGui = Instance.new("ScreenGui")
NotifGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
    notificationFrame.BackgroundTransparency = 0.7 -- 背景透明度降低
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 999
    notificationFrame.Parent = NotifGui

    local uiCorner = Instance.new("UICorner", notificationFrame)
    uiCorner.CornerRadius = UDim.new(0, 8)

    -- 标题
    local titleLabel = Instance.new("TextLabel", notificationFrame)
    titleLabel.Size = UDim2.new(0.95, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 标题文字颜色
    titleLabel.TextSize = 18
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
    textLabel.TextSize = 16
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
print("✅ NotifGui Create.")

-- 辅助函数：创建并配置 TextLabel
local function CreateTextLabel(parent, text, textColor3, position, textSize)
    local textLabel = Instance.new("TextLabel", parent)
    textLabel.Text = text
    textLabel.TextColor3 = textColor3 or Color3.new(1, 1, 1) -- 默认白色
    textLabel.Position = position or UDim2.new(0.5, 0, 0.5, 0) -- 默认居中
    textLabel.TextSize = textSize or 14 -- 默认字体大小
    textLabel.BackgroundTransparency = 1 -- 默认背景透明
    print("✅ UI - " .. text .. " Create.")
    return textLabel
end

-- 创建 ScreenGui 并作为 LocalPlayer.PlayerGui 的子对象
local Gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
print("✅ ScreenGui Create.")

-- 使用辅助函数创建 TextLabel 实例
local Text1 = CreateTextLabel(Gui, "游戏未开始", Color3.fromRGB(230, 230, 250), UDim2.new(0.529, -40, 0.1, 0), 25)
local Text2 = CreateTextLabel(Gui, "", Color3.fromRGB(166, 166, 166), UDim2.new(0.529, -40, 0.14, 0), 15)
local Text3 = CreateTextLabel(Gui, "Auto Parry (OFF)", Color3.fromRGB(230, 230, 250), UDim2.new(0.949, -40, -0.04, 0), 20)

local RB = Color3.new(1, 0, 0)
local BALLLINEDIYCOLOR = Color3.new(0, 1, 0)
local BALLFILLDIYCOLOR = Color3.new(1, 1, 0)
local AutoValue = false

-- 查找球的函数
function FindBall()
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "Part" and child:IsA("BasePart") then -- 假设球是一个BasePart
            return child
        end
    end
    return nil
end

-- 更新 UI 的函数
local function UpdateUI()
    if AutoValue and isLocked and distance < 15 then
        VirtualInputManager:SendKeyEvent(true, "F", false, game)
    end

    local playerPos = (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new()
    local ball = FindBall()

    if not ball then
        Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
        Text1.Text = "游戏未开始"
        Text2.Text = ""
        return
    end

    local isSpectating = playerPos.Z < -777.55 and playerPos.Y > 279.17
    if isSpectating then
        Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
        Text1.Text = "观战中"
        Text2.Text = ""
    else
        if ball.Highlight and ball.Highlight.FillColor == RB then
            ball.Highlight.OutlineColor = BALLLINEDIYCOLOR
            ball.Highlight.FillColor = BALLFILLDIYCOLOR
        end
        local isLocked = ball.Highlight and ball.Highlight.FillColor == BALLFILLDIYCOLOR
        Text1.Text = isLocked and "已被球锁定" or "未被球锁定"
        Text1.TextColor3 = isLocked and Color3.fromRGB(238, 17, 17) or Color3.fromRGB(17, 238, 17)

        local dx, dy, dz = ball.CFrame.X - playerPos.X, ball.CFrame.Y - playerPos.Y, ball.CFrame.Z - playerPos.Z
        local distance = math.sqrt(dx^2 + dy^2 + dz^2)
        Text2.Text = string.format("%.0f", distance)
    end
end

CreateNotification("提示", "死亡球辅助已启动", 5, true)
wait(0.5)
CreateNotification("提示", "按下 K 启动自动格挡", 5.5, false)
wait(0.5)
CreateNotification("提示", "按下 Delete 卸载脚本", 6, false)

print("⚠️ Service VirtualInputManager Loading problem occurred!")
print("✅ Module NotificationSystem Load.")
print("")
print("Dealthball Script Load!")
print("使用提醒: 按下K切换自动格挡, 按下Delete卸载脚本")

-- 主循环
while true do
    wait(0.05)
    if UserInputService:IsKeyDown(Enum.KeyCode.K) then
        AutoValue = not AutoValue
        Text3.Text = AutoValue and "Auto Parry (ON)" or "Auto Parry (OFF)"
        CreateNotification("提示", AutoValue and "自动格挡已开启" or "自动格挡已关闭", 5, true)
        wait(0.5)
    elseif UserInputService:IsKeyDown(Enum.KeyCode.Delete) then
        _G.DeathBallScriptLoaded = false
        print("Dealthball Script Unload!")
        Gui:Destroy()
        NotifGui:Destroy()
        break
    end

    UpdateUI()
end