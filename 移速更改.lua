-- 本脚本仅能在Doors中增加5点速度，可绕过部分贪吃蛇类的移速修改，请不要在有反作弊的服务器中使用，否则遭到封禁后果自负
--增加移速脚本 汉化/美化/增强 by Chronix 免费开源
 
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local TextButton_2 = Instance.new("TextButton")
local WalkSpeedControl = Instance.new("TextLabel")
local Close = Instance.new("TextButton")
local Label = Instance.new("TextLabel")
local Open = Instance.new("TextButton")
local CoreGui = game:GetService("StarterGui")
local playerspeed = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
 
--Properties:
 
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

Frame.BorderSizePixel = 3
Frame.Position = UDim2.new(0.468, 0, 0.01, 0)
Frame.Size = UDim2.new(0, 150, 0, 130)
Frame.Active = true
Frame.Draggable = false
 
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 3
TextButton.Position = UDim2.new(0.71206224, 0, 0.63203454, 0)
TextButton.Size = UDim2.new(0, 40, 0, 40)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "➕"
TextButton.TextColor3 = Color3.fromRGB(221, 221, 221)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
 
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(0.33073929, 0, 0.25437235, 0)
TextLabel.Size = UDim2.new(0, 45, 0, 45)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = playerspeed
TextLabel.TextColor3 = Color3.fromRGB(221, 221, 221)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
 
TextButton_2.Parent = Frame
TextButton_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.BorderSizePixel = 3
TextButton_2.Position = UDim2.new(0, 0, 0.63203454, 0)
TextButton_2.Size = UDim2.new(0, 40, 0, 40)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "➖"
TextButton_2.TextColor3 = Color3.fromRGB(221, 221, 221)
TextButton_2.TextScaled = true
TextButton_2.TextSize = 14.000
TextButton_2.TextWrapped = true
 
WalkSpeedControl.Name = "WalkSpeed Control"
WalkSpeedControl.Parent = Frame
WalkSpeedControl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WalkSpeedControl.BorderSizePixel = 3
WalkSpeedControl.Position = UDim2.new(0, 0, 0, 0)
WalkSpeedControl.Size = UDim2.new(0, 150, 0, 25)
WalkSpeedControl.Font = Enum.Font.Highway
WalkSpeedControl.Text = "更改移速"
WalkSpeedControl.TextColor3 = Color3.fromRGB(221, 221, 221)
WalkSpeedControl.TextScaled = true
WalkSpeedControl.TextSize = 14.000
WalkSpeedControl.TextWrapped = true
 
Close.Name = "Close"
Close.Parent = Frame
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.Position = UDim2.new(0.33, 0, -0.44, 0)
Close.Size = UDim2.new(0, 50, 0, 50)
Close.Style = Enum.ButtonStyle.RobloxButtonDefault
Close.Font = Enum.Font.SourceSans
Close.Text = "❌"
Close.TextColor3 = Color3.fromRGB(255, 0, 0)
Close.TextScaled = true
Close.TextSize = 14.000
Close.TextWrapped = true
 
Label.Name = "Label"
Label.Parent = Frame
Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

Label.BorderSizePixel = 3
Label.Position = UDim2.new(0, 0, 1, 0)
Label.Size = UDim2.new(0, 150, 0, 25)
Label.Font = Enum.Font.Highway
Label.Text = "优化by Chronix"
Label.TextColor3 = Color3.fromRGB(221, 221, 221)
Label.TextScaled = true
Label.TextSize = 14.000
Label.TextWrapped = true
 
Open.Name = "Open"
Open.Parent = ScreenGui
Open.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Open.Position = UDim2.new(0.5, 0, -0.067, 0)
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Style = Enum.ButtonStyle.RobloxButton
Open.Font = Enum.Font.SourceSans
Open.Text = "🍃"
Open.TextColor3 = Color3.fromRGB(255, 255, 255)
Open.TextScaled = true
Open.TextSize = 14.000
Open.TextWrapped = true
 
-- Scripts:
 
local function QDTZQ_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)
 
	local label = script.Parent.Parent.TextLabel --- defines the number
 
 
	script.Parent.MouseButton1Click:Connect(function() --- when the button is clicked it calls this function
        playerspeed = playerspeed + 5
		label.Text = playerspeed --- tells the text label that displays walk speed to update
        while true do
            wait(0.01)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = playerspeed
        end
	end)
end
coroutine.wrap(QDTZQ_fake_script)()
local function UCADA_fake_script() -- TextButton_2.LocalScript 
	local script = Instance.new('LocalScript', TextButton_2)
 
	local label = script.Parent.Parent.TextLabel --- defines the number
 
 
	script.Parent.MouseButton1Click:Connect(function() --- when the button is clicked it calls this function
		playerspeed = playerspeed - 5
		label.Text = playerspeed --- tells the text label that displays walk speed to update
        while true do
            wait(0.01)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = playerspeed
        end
	end)
end
coroutine.wrap(UCADA_fake_script)()
local function YDSA_fake_script() -- Close.LocalScript 
	local script = Instance.new('LocalScript', Close)
 
	script.Parent.Parent.Visible = false
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Parent.Visible =  false
		script.Parent.Parent.Parent.Open.Visible = true
	end)
end
coroutine.wrap(YDSA_fake_script)()
local function ZFFOR_fake_script() -- Open.LocalScript 
	local script = Instance.new('LocalScript', Open)
 
	script.Parent.Visible = true
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible = false
		script.Parent.Parent.Frame.Visible = true
	end)
end

coroutine.wrap(ZFFOR_fake_script)()

 CoreGui:SetCore("SendNotification", { 
     Title = "更改移速加载成功", 
     Text = "by Chronix", 
     Duration = 10,  
 })