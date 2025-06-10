local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

-- 判断是否为旧聊天系统
local isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

local chatControl = {}

-- 发送消息的函数
function chatControl:chat(str)
    str = tostring(str)
    if not isLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- 获取玩家头像
local thumbnailType = Enum.ThumbnailType.HeadShot -- 头像类型
local thumbnailSize = Enum.ThumbnailSize.Size100x100 -- 头像尺寸

-- 接收消息的函数
function chatControl:MessageReceiver(callback)
    TextChatService.MessageReceived:Connect(function(message)
        local player = Players:GetPlayerByUserId(message.TextSource.UserId)
        if not player then return end
        local success, thumbnailUrl = pcall(function()
            return Players:GetUserThumbnailAsync(message.TextSource.UserId, thumbnailType, thumbnailSize)
        end)
        local msgData = {}
        msgData["sender"] = player.Name
        msgData["nickname"] = player.DisplayName
        msgData["head"] = thumbnailUrl
        msgData["text"] = message.Text
        callback(msgData)
    end)
end

return chatControl