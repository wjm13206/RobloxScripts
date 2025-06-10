local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local music = Instance.new("Sound")
music.Parent = SoundService
music.SoundId = "rbxassetid://1837879082"

local CONFIG = {
    lockSpeed = false,
    Speed = LocalPlayer.Character.Humanoid.WalkSpeed,
    NoClip = false,
    InfJump = false,
    ESP = false,
    AirWalk = false,
    floorY = nil,
    Music_Play = false,
    Music_Pause = false,
    Music_PlayLocation = 0,
    Music_ID = "1837879082"
}

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
    CONFIG.floorY = HumanoidRootPart.Position.Y - HumanoidRootPart.Size.Y / 2 - floorPart.Size.Y / 2 - 1.8
    floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, CONFIG.floorY, HumanoidRootPart.Position.Z)
end

-- 删除地板
local function destroyFloor()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
        CONFIG.floorY = nil
    end
end

-- 切换空中行走状态
local function toggleAirWalk()
    if CONFIG.AirWalk then
        createFloor() -- 启用时创建地板
    else
        destroyFloor() -- 禁用时删除地板
    end
end

-- 更新地板位置
RunService.Heartbeat:Connect(function()
    if CONFIG.AirWalk and floorPart and CONFIG.floorY then
        -- 将地板的 X 和 Z 轴与玩家对齐，Y 轴固定
        floorPart.Position = Vector3.new(HumanoidRootPart.Position.X, CONFIG.floorY, HumanoidRootPart.Position.Z)
    end
end)

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

Players.PlayerAdded:Connect(function(player)
    if CONFIG.ESP then
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

Players.PlayerRemoving:Connect(function(player)
    if CONFIG.ESP then
        removePlayerEffects(player)
    end
end)

-- 创建 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建日志框
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(0.29, 0, 0.3, 0) -- 设置大小
logFrame.Position = UDim2.new(0.005, 0, 0.95, 0) -- 设置位置（聊天框上方）
logFrame.AnchorPoint = Vector2.new(0, 1) -- 锚点左下角
logFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
logFrame.BackgroundTransparency = 0.5 -- 半透明
logFrame.BorderSizePixel = 0 -- 无边框
logFrame.ScrollBarThickness = 6 -- 滚动条宽度
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- 自动调整内容高度
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 初始内容大小
logFrame.Visible = false -- 初始隐藏
logFrame.Parent = screenGui

-- 创建日志内容的 UIListLayout
local logLayout = Instance.new("UIListLayout")
logLayout.SortOrder = Enum.SortOrder.LayoutOrder -- 按顺序排列
logLayout.Parent = logFrame

-- 创建日志内容的 Padding
local logPadding = Instance.new("UIPadding")
logPadding.PaddingLeft = UDim.new(0, 5) -- 左边距
logPadding.PaddingTop = UDim.new(0, 5) -- 上边距
logPadding.Parent = logFrame

-- 滚动到最下方
local function scrollToBottom()
    -- 等待一帧以确保 CanvasSize 更新
    task.wait()
    logFrame.CanvasPosition = Vector2.new(0, 2147483647)
end

-- 定义 log 函数
local function log(message, color)
    -- 默认颜色为白色
    local textColor = Color3.new(1, 1, 1) -- 白色

    -- 根据传入的 color 参数设置颜色
    if type(color) == "string" then
        if color == "warning" then
            textColor = Color3.new(1, 1, 0) -- 黄色
        elseif color == "error" then
            textColor = Color3.new(1, 0, 0) -- 红色
        elseif color == "info" then
            textColor = Color3.new(0.5, 0.8, 1) -- 淡蓝色
        end
    elseif type(color) == "table" and #color == 3 then
        -- 如果传入的是 RGB 色值
        textColor = Color3.new(color[1], color[2], color[3])
    end

    -- 创建日志标签
    local logLabel = Instance.new("TextLabel")
    logLabel.Text = message
    logLabel.TextColor3 = textColor -- 设置文字颜色
    logLabel.BackgroundTransparency = 1 -- 透明背景
    logLabel.TextXAlignment = Enum.TextXAlignment.Left -- 文字左对齐
    logLabel.Font = Enum.Font.GothamBold -- 字体
    logLabel.TextSize = 14 -- 文字大小
    logLabel.Size = UDim2.new(1, -10, 0, 20) -- 设置大小（减去滚动条宽度）
    logLabel.LayoutOrder = #logFrame:GetChildren() -- 按顺序排列
    logLabel.Parent = logFrame

    scrollToBottom()
end


-- 传送玩家
local function teleportPlayer(player, targetPlayer)
    local playerCharacter = player.Character
    local targetCharacter = targetPlayer.Character
    if playerCharacter and targetCharacter then
        local playerRoot = playerCharacter:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        if playerRoot and targetRoot then
            playerRoot.CFrame = targetRoot.CFrame
            log("已将玩家 " .. player.Name .. " 传送到玩家 " .. targetPlayer.Name, "info")
        else
            log("传送失败：玩家或目标玩家没有 HumanoidRootPart！", "error")
        end
    else
        log("传送失败：玩家或目标玩家没有角色！", "error")
    end
end

-- 根据 ID、玩家名或昵称获取玩家
local function getPlayerByIdOrName(identifier)
    -- 尝试按玩家名查找
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == identifier then
            return p
        end
    end

    -- 尝试按昵称查找
    for _, p in ipairs(Players:GetPlayers()) do
        if p.DisplayName == identifier then
            return p
        end
    end

    -- 最后尝试按 ID 查找
    local playerId = tonumber(identifier)
    if playerId then
        return Players:GetPlayerByUserId(playerId)
    end

    return nil -- 未找到玩家
end

game:GetService("RunService").Stepped:Connect(function()
    if CONFIG.lockSpeed then LocalPlayer.Character.Humanoid.WalkSpeed = CONFIG.Speed end
    if CONFIG.NoClip then
        for a, b in pairs(Workspace:GetChildren()) do
            if b.Name == Players.LocalPlayer.Name then
                for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end end end end
	end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if CONFIG.InfJump then
        local c = LocalPlayer.Character
        if c and c.Parent then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState("Jumping")
            end
        end
    end
end)

-- 处理指令
local function handleCommand(commandParts)
    local command = commandParts[1] -- 第一个部分是指令
    if command == "tp" then
        if #commandParts == 2 then
            -- 只有一个参数：将自己传送到目标玩家
            local target = commandParts[2]
            local targetPlayer = getPlayerByIdOrName(target)
            if targetPlayer then
                teleportPlayer(LocalPlayer, targetPlayer)
            else
                log("传送失败：未找到玩家 " .. target, "error")
            end
        elseif #commandParts == 3 then
            -- 有两个参数：将第一个玩家传送到第二个玩家
            local player1 = getPlayerByIdOrName(commandParts[2])
            local player2 = getPlayerByIdOrName(commandParts[3])
            if player1 and player2 then
                teleportPlayer(player1, player2)
            else
                log("传送失败：未找到玩家", "error")
            end
        elseif #commandParts == 4 then
            local x, y, z = tonumber(commandParts[2]), tonumber(commandParts[3]), tonumber(commandParts[4])
            if x and y and z then
                LocalPlayer.Character:MoveTo(Vector3.new(x, y, z))
                log("已传送到: " .. x .. ", " .. y .. ", " .. z, "info")
            else
                log("坐标无效！", "error")
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "speed" then
        if #commandParts == 2 then
            LocalPlayer.Character.Humanoid.WalkSpeed = commandParts[2]
            CONFIG.Speed = commandParts[2]
            log("速度已更改为 " .. commandParts[2], "info")
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "jump" then
        if #commandParts == 2 then
            LocalPlayer.Character.Humanoid.JumpPower = commandParts[2]
            log("跳跃高度已更改为 " .. commandParts[2], "info")
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "maxhealth" then
        if #commandParts == 2 then
            LocalPlayer.Character.Humanoid.MaxHealth = commandParts[2]
            log("最大血量已更改为 " .. commandParts[2], "info")
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "health" then
        if #commandParts == 2 then
            LocalPlayer.Character.Humanoid.Health = commandParts[2]
            log("血量已更改为 " .. commandParts[2], "info")
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "gravity" then
        if #commandParts == 2 then
            LocalPlayer.Character.Humanoid.Gravity = commandParts[2]
            log("重力已更改为 " .. commandParts[2], "info")
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "lockspeed" then
        CONFIG.lockSpeed = not CONFIG.lockSpeed
        log(CONFIG.lockSpeed and "速度已锁定" or "速度已解锁", "info")
    elseif command == "antiafk" then
        local bb=game:service'VirtualUser'
        game:service'Players'.LocalPlayer.Idled:connect(function()bb:CaptureController()bb:ClickButton2(Vector2.new())end)
        log("防挂机被踢开启", "info")
    elseif command == "healthme" then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth 
        log("已回满血(客户端)", "info")
    elseif command == "killme" then
        LocalPlayer.Character.Humanoid.Health = 0
        log("已自杀", "info")
    elseif command == "nightvision" then
        if #commandParts == 2 then
            if commandParts[2] == "true" then
                game.Lighting.Ambient = Color3.new(1, 1, 1)
                log("夜视开启", "info")
            elseif commandParts[2] == "false" then
                game.Lighting.Ambient = Color3.new(0, 0, 0)
                log("夜视关闭", "info")
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "noclip" then
        if #commandParts == 2 then
            if commandParts[2] == "true" then
                CONFIG.NoClip = true
                log("穿墙开启", "info")
            elseif commandParts[2] == "false" then
                CONFIG.NoClip = false
                for a, b in pairs(Workspace:GetChildren()) do
                    if b.Name == Players.LocalPlayer.Name then
                        for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                end end end end
                log("穿墙关闭", "info")
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "infjump" then
        if #commandParts == 2 then
            if commandParts[2] == "true" then
                CONFIG.InfJump = true
                log("连跳开启", "info")
            elseif commandParts[2] == "false" then
                CONFIG.InfJump = false
                log("连跳关闭", "info")
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "airwalk" then
        if #commandParts == 2 then
            if commandParts[2] == "true" then
                CONFIG.AirWalk = true
                toggleAirWalk()
                log("空中行走开启", "info")
            elseif commandParts[2] == "false" then
                CONFIG.AirWalk = false
                toggleAirWalk()
                log("空中行走关闭", "info")
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "esp" then
        if #commandParts == 2 then
            if commandParts[2] == "true" then
                CONFIG.ESP = true
                log("透视开启", "info")
                for _, player in ipairs(Players:GetPlayers()) do
                    addHighlight(player)
                    addUsernameLabel(player)
                end
            elseif commandParts[2] == "false" then
                CONFIG.ESP = false
                log("透视关闭", "info")
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
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "time" then
        if #commandParts == 3 then
            if commandParts[2] == "set" then
                if commandParts[3] == "day" then
                    setDay()
                    log("时间已切换为 白昼", "info")
                elseif commandParts[3] == "night" then
                    setNight()
                    log("时间已切换为 黑夜", "info")
                else
                    log("无效的值", "warning")
                end
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "pt" then
        if #commandParts == 3 then
            if commandParts[2] == "delete" then
                if commandParts[3] == "捕兽夹" then
                    local deletedCount = 0
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model.Name == "__SnarePhysical" then
                            model:Destroy()
                            deletedCount = deletedCount + 1
                        end
                    end
                    log("[Project Transfur] 已删除" .. deletedCount .. "个捕兽夹", "info")
                elseif commandParts[3] == "阔剑地雷" then
                    local deletedCount = 0
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model.Name == "__ClaymorePhysical" then
                            model:Destroy()
                            deletedCount = deletedCount + 1
                        end
                    end
                    log("[Project Transfur] 已删除" .. deletedCount .. "个阔剑地雷", "info")
                elseif commandParts[3] == "地雷" then
                    local deletedCount = 0
                    for _, model in ipairs(Workspace:GetDescendants()) do
                        if model:IsA("Model") and model.Name == "Landmine" then
                            model:Destroy()
                            deletedCount = deletedCount + 1
                        end
                    end
                    log("[Project Transfur] 已删除" .. deletedCount .. "个地雷", "info")
                else
                    log("无效的值", "warning")
                end
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "playsound" then
        if #commandParts == 3 then
            if commandParts[2] == "setrbxid" then
                music.SoundId = "rbxassetid://" .. commandParts[3]
                CONFIG.Music_ID = commandParts[3]
                log("[音乐播放器] 音乐ID更改为" .. commandParts[3],"info")
            elseif commandParts[2] == "volume" then
                music.Volume = commandParts[3]
                log("[音乐播放器] 音量更改为" .. commandParts[3],"info")
            elseif commandParts[2] == "pitch" then
                music.Pitch = commandParts[3]
                log("[音乐播放器] 音速更改为" .. commandParts[3],"info")
            elseif commandParts[2] == "loop" then
                if commandParts[3] == "true" then
                    music.Looped = true
                    log("[音乐播放器] 循环已开启","info")
                elseif commandParts[3] == "false" then
                    music.Looped = false
                    log("[音乐播放器] 循环已关闭","info")
                end
            end
        elseif #commandParts == 2 then
            if commandParts[2] == "play" then
                local success, productInfo = pcall(function()
                    return MarketplaceService:GetProductInfo(CONFIG.Music_ID)
                end)
                music:Play()
                CONFIG.Music_Play = true
                log("正在播放:","info")
                log("-----------------------------------------------------")
                log("")
                log("")
                log("")
                log(productInfo.Name .. "\n" .. productInfo.Description,"warning")
                log("")
                log("")
                log("")
                log("-----------------------------------------------------")
            elseif commandParts[2] == "pause" then
                CONFIG.Music_Pause = true
                CONFIG.Music_PlayLocation = music.TimePosition
                music:Stop()
                log("音乐已暂停", "info")
            elseif commandParts[2] == "resume" then
                music.TimePosition = CONFIG.Music_PlayLocation
                CONFIG.Music_Pause = false
                music:Play()
                log("音乐已恢复", "info")
            elseif commandParts[2] == "stop" then
                music.TimePosition = nil
                CONFIG.Music_Play = false
                music:Stop()
                log("音乐已停止", "info")
            end
        else
            log("无效的参数数量！", "error")
        end
    elseif command == "gettptool" then
        mouse = game.Players.LocalPlayer:GetMouse() tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "手持点击传送" tool.Activated:connect(function() local pos = mouse.Hit+Vector3.new(0,2.5,0) pos = CFrame.new(pos.X,pos.Y,pos.Z) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos end) tool.Parent = game.Players.LocalPlayer.Backpack
        log("已添加点击传送工具", "info")
    elseif command == "log" then
        logFrame.Visible = not logFrame.Visible
        log(logFrame.Visible and "开启日志." or "关闭日志.", "info")
    elseif command == "help" then
        local function showhelp(page)
            if page == nil or page == 1 then
                log("-----------帮助页面(第1页/共4页)-----------","info")
                log("[]为可选参数, {}为必选参数.")
                log("help - 进入帮助页面.")
                log("log - 开启日志.")
                log("exit - 卸载脚本")
                log("tp {玩家名} - 传送到玩家.")
                log("tp {玩家名1} {玩家名2} - 将玩家1传送到玩家2.")
                log("tp {X} {Y} {Z} - 传送到指定坐标.")
                log("------------------------------------------","info")
            elseif page == 2 then
                log("-----------帮助页面(第2页/共4页)-----------","info")
                log("speed {速度} - 更改移速.")
                log("jump {跳跃高度} - 更改跳跃高度.")
                log("maxhealth {最大血量} - 更改最大血量.")
                log("health {血量} - 更改当前血量.")
                log("gravity {重力} - 更改重力.")
                log("lockspeed - 锁定移速.")
                log("antiafk - 开启反挂机被踢.")
                log("------------------------------------------","info")
            elseif page == 3 then
                log("-----------帮助页面(第3页/共4页)-----------","info")
                log("healthme - 回满血.")
                log("killme - 自杀.")
                log("nightvision {true/false} - 开关夜视.")
                log("gettptool - 获得点击传送工具.")
                log("noclip {true/false} - 开关穿墙.")
                log("infjump {true/false} - 开关连跳.")
                log("time {set} {day/night}- 切换时间.")
                log("------------------------------------------","info")
            elseif page == 4 then
                log("-----------帮助页面(第4页/共4页)-----------","info")
                log("esp {true/false} - 开关透视.")
                log("airwalk {true/false} - 开关空中行走.")
                log("playsound setrbxid {ID} - 设置音乐ID.")
                log("playsound volume {0-1} - 设置音量.")
                log("playsound pitch {0-1} - 设置音速.")
                log("playsound {play/pause/resume/stop} - 播放/暂停/恢复/停止音乐.")
                log("pt {delete} {捕兽夹/阔剑地雷} - 删除指定模型.")
                log("------------------------------------------","info")
            else
                log("错误的参数.", "error")
            end
        end
        if #commandParts == 2 then
            showhelp(tonumber(commandParts[2]))
        else
            showhelp()
        end
    elseif command == "exit" then
        music:Stop() -- 先停止播放
        music:Destroy()
        for _, player in ipairs(Players:GetPlayers()) do
            removePlayerEffects(player)
        end
        screenGui:Destroy() -- 销毁 ScreenGui
        script:Destroy() -- 卸载脚本
    else
        log("未知指令！", "error")
    end
end

local ShowLabel = Instance.new("TextLabel")
ShowLabel.Parent = screenGui
ShowLabel.Text = "Admin Panel(管理员面板)"
ShowLabel.Visible = false
ShowLabel.BackgroundTransparency = 1
ShowLabel.Size = UDim2.new(0.1, 0, 0.03, 0)
ShowLabel.TextColor3 = Color3.new(1, 0, 0)
ShowLabel.Position = UDim2.new(0.9, 0, 0.93, 0)
ShowLabel.Font = Enum.Font.GothamBold
ShowLabel.TextSize = 14

-- 创建聊天输入框
local chatBox = Instance.new("TextBox")
chatBox.Size = UDim2.new(0.99, 0, 0.03, 0) -- 设置大小
chatBox.Position = UDim2.new(0.005, 0, 0.99, 0) -- 设置位置（屏幕下方）
chatBox.AnchorPoint = Vector2.new(0, 1) -- 锚点左下角
chatBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- 背景颜色
chatBox.TextColor3 = Color3.new(1, 1, 1) -- 文字颜色
chatBox.BackgroundTransparency = 0.5
chatBox.TextXAlignment = Enum.TextXAlignment.Left
chatBox.Font = Enum.Font.GothamBold -- 字体
chatBox.TextSize = 18 -- 文字大小
chatBox.PlaceholderText = "输入指令（例如：tp 玩家ID/玩家名/昵称）..." -- 提示文字
chatBox.Visible = false -- 初始隐藏
chatBox.ClearTextOnFocus = false -- 点击输入框时不自动清空内容
chatBox.Parent = screenGui
chatBox.Text = ""

-- 监听按键输入
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- 忽略游戏内输入

    -- 按下 T 键显示或隐藏输入框和日志框
    if input.KeyCode == Enum.KeyCode.T then
        chatBox.Visible = not chatBox.Visible -- 切换输入框的可见性
        ShowLabel.Visible = chatBox.Visible
        if chatBox.Visible then
            chatBox:CaptureFocus() -- 聚焦输入框
        end
    end

    -- 按下回车键返回输入内容并隐藏输入框和日志框
    if input.KeyCode == Enum.KeyCode.Return and chatBox.Visible then
        local message = chatBox.Text -- 获取输入内容
        chatBox.Text = ""
        chatBox.Visible = false -- 隐藏输入框
        ShowLabel.Visible = chatBox.Visible
        chatBox:ReleaseFocus() -- 释放焦点

        -- 处理输入内容
        if message ~= "" then
            -- 以空格为分隔符返回一个集合
            local messageParts = {}
            for part in string.gmatch(message, "%S+") do
                table.insert(messageParts, part)
            end

            log("> " .. message) -- 将输入内容记录到日志
            handleCommand(messageParts) -- 处理指令
        end
    end
end)

-- 监听输入框的焦点变化
chatBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local message = chatBox.Text -- 获取输入内容
        chatBox.Text = "" -- 清空输入框内容
        chatBox.Visible = false -- 隐藏输入框
        ShowLabel.Visible = chatBox.Visible
        -- 处理输入内容
        if message ~= "" then
            -- 以空格为分隔符返回一个集合
            local messageParts = {}
            for part in string.gmatch(message, "%S+") do
                table.insert(messageParts, part)
            end

            log("> " .. message) -- 将输入内容记录到日志
            handleCommand(messageParts) -- 处理指令
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Admin Panel",
    Text = "管理员面板已启动\n按下T输入指令",
    Icon = "rbxassetid://2553092087",
    Duration = 10
})