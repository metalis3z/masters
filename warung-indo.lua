-- [ money ESP ] --
local ShowMoney = false
local MoneyESPObjects = {}

local function FormatRupiah(number)
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1."):reverse()
    if formatted:sub(1,1) == "." then
        formatted = formatted:sub(2)
    end
    return "Rp " .. formatted
end

local function AddMoneyESP(player)
    if player == game.Players.LocalPlayer then return end
    if MoneyESPObjects[player] then return end

    local moneyLabel = Drawing.new("Text")
    moneyLabel.Size = 13
    moneyLabel.Center = true
    moneyLabel.Outline = true
    moneyLabel.Font = 2
    moneyLabel.Color = Color3.fromRGB(0, 255, 0)
    moneyLabel.Visible = false

    MoneyESPObjects[player] = moneyLabel
end

local function RemoveMoneyESP(player)
    if MoneyESPObjects[player] then
        MoneyESPObjects[player]:Remove()
        MoneyESPObjects[player] = nil
    end
end

local function UpdateMoneyESP()
    while ShowMoney do
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                AddMoneyESP(player)
                local label = MoneyESPObjects[player]
                local character = player.Character
                local success, money = pcall(function()
                    return player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money") and player.leaderstats.Money.Value
                end)

                if label and character and character:FindFirstChild("Head") and success and money then
                    local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 1.8, 0))
                    if onScreen then
                        label.Position = Vector2.new(headPos.X, headPos.Y)
                        label.Text = FormatRupiah(money)
                        label.Visible = true
                    else
                        label.Visible = false
                    end
                elseif label then
                    label.Visible = false
                end
            end
        end
        task.wait(0.05)
    end
end

-- Toggle Function
function EnableMoneyESP(state)
    ShowMoney = state
    if state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            AddMoneyESP(player)
        end
        game.Players.PlayerAdded:Connect(AddMoneyESP)
        game.Players.PlayerRemoving:Connect(RemoveMoneyESP)
        task.spawn(UpdateMoneyESP)
    else
        for _, label in pairs(MoneyESPObjects) do
            label:Remove()
        end
        MoneyESPObjects = {}
    end
end

-- [ esp moment ] --
local Settings = {
    Enabled = true,
    ShowBox = false,
    ShowTracer = false,
    ShowName = false,
    RefreshRate = 0.05,
    Colors = {
        Box = Color3.fromRGB(0, 255, 0),
        Name = Color3.fromRGB(0, 255, 0),
        Tracer = Color3.fromRGB(0, 255, 0),
    }
}

local ESPObjects = {}

local function CreateDrawing(Type, Props)
    local Obj = Drawing.new(Type)
    for prop, val in pairs(Props) do
        Obj[prop] = val
    end
    return Obj
end

local function AddESP(player)
    if player == game.Players.LocalPlayer then return end
    if ESPObjects[player] then return end

    ESPObjects[player] = {
        Box = CreateDrawing("Square", {
            Thickness = 1,
            Transparency = 1,
            Color = Settings.Colors.Box,
            Filled = false,
            Visible = false,
        }),
        Name = CreateDrawing("Text", {
            Size = 13,
            Center = true,
            Outline = true,
            Font = 2,
            Color = Settings.Colors.Name,
            Visible = false,
        }),
        Tracer = CreateDrawing("Line", {
            Thickness = 1,
            Color = Settings.Colors.Tracer,
            Transparency = 1,
            Visible = false,
        })
    }
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function UpdateColors()
    for _, drawings in pairs(ESPObjects) do
        drawings.Box.Color = Settings.Colors.Box
        drawings.Name.Color = Settings.Colors.Name
        drawings.Tracer.Color = Settings.Colors.Tracer
    end
end

local function UpdateLoop()
    while Settings.Enabled do
        for player, drawings in pairs(ESPObjects) do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
                local hrp = char.HumanoidRootPart
                local head = char.Head
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                    local feetPos = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headPos.Y - feetPos.Y)
                    local width = height / 2.2

                    if Settings.ShowBox then
                        drawings.Box.Size = Vector2.new(width, height)
                        drawings.Box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
                        drawings.Box.Visible = true
                    else
                        drawings.Box.Visible = false
                    end

                    if Settings.ShowName then
                        drawings.Name.Text = player.Name
                        drawings.Name.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 16)
                        drawings.Name.Visible = true
                    else
                        drawings.Name.Visible = false
                    end

                    if Settings.ShowTracer then
                        drawings.Tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                        drawings.Tracer.To = Vector2.new(screenPos.X, screenPos.Y + height/2)
                        drawings.Tracer.Visible = true
                    else
                        drawings.Tracer.Visible = false
                    end
                else
                    drawings.Box.Visible = false
                    drawings.Name.Visible = false
                    drawings.Tracer.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.Name.Visible = false
                drawings.Tracer.Visible = false
            end
        end
        task.wait(Settings.RefreshRate)
    end
end

function EnableESP(bool)
    Settings.ShowName = bool
end

function EnableHitbox(bool)
    Settings.ShowBox = bool
end

function EnableTracer(bool)
    Settings.ShowTracer = bool
end

for _, p in ipairs(game.Players:GetPlayers()) do
    AddESP(p)
end

game.Players.PlayerAdded:Connect(AddESP)
game.Players.PlayerRemoving:Connect(RemoveESP)

task.spawn(UpdateLoop)



function RunDeliveryExploit(total)

    local Event = game:GetService("ReplicatedStorage").Uber.acceptOrder
    Event:FireServer(table.unpack({
        total,
        game:GetService("Players").LocalPlayer.PlayerGui.uberEatsGUI.deliveryLocation.Value,
        game:GetService("Players").LocalPlayer.PlayerGui.uberEatsGUI.restaurantLocation.Value
    }))

end
function RunMoneyExploit(amount)

    local Event = game:GetService("ReplicatedStorage").ToolShopEvent
    Event:FireServer(table.unpack({
        "Purchase",
        "Wallet",
        -amount
    }))

end

-- Variables --
local DeliveryExploit = 0
local MoneyExploit = 0
local IsLooping = false
local MoneyGiverDelayed = 0.1

-- UI library --
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "Lunar [ Warung Indo ]",
    Icon = "moon-star",
    Author = "Warung Indo | discord.gg/Lunarpride",
    Folder = "LunarCode",
    Size = UDim2.fromOffset(550, 300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    Background = ""
})

local Tab = Window:Tab({
    Title = "Money Exploit",
    Locked = false,
})

local Section = Tab:Section({ 
    Title = "Money Exploit",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Input = Tab:Input({
    Title = "Enter Money",
    Desc = " ",
    Value = 100000,
    Placeholder = "Enter the money...",
    Callback = function(input) 
        MoneyExploit = tonumber(input)
    end
})

local Button = Tab:Button({
    Title = "Get Money",
    Desc = " ",
    Locked = false,
    Callback = function()
        RunMoneyExploit(MoneyExploit)
    end
})

local Input = Tab:Input({
    Title = "Loop Delayed",
    Desc = "small value can might be laggy",
    Value = 0.1,
    Placeholder = "Enter the money...",
    Callback = function(input) 
        MoneyGiverDelayed = tonumber(input)
    end
})

local Toggle = Tab:Toggle({
    Title = "Loop Exploit",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        IsLooping = state 

        if IsLooping then
            task.spawn(function()
                while IsLooping do
                    RunMoneyExploit(MoneyExploit)
                    task.wait(MoneyGiverDelayed or 0)
                end
            end)
        end
    end
})

local Section = Tab:Section({ 
    Title = "Money Exploit [ Delivery Job ]",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Paragraph = Tab:Paragraph({
    Title = "How To Use\n1) Make sure you already set the amount\n2) Get Delivery Job\n3) After you accept the delivery order, click Dupe Money\n4) Delivery the item and you will duped the money",
    Color = "Orange",
})

local Input = Tab:Input({
    Title = "Dupe Amount",
    Desc = " ",
    Value = 100000,
    Placeholder = "Enter the money...",
    Callback = function(input) 
        DeliveryExploit = tonumber(input)
    end
})


local Button = Tab:Button({
    Title = "Dupe Money",
    Desc = " ",
    Locked = false,
    Callback = function()
        RunDeliveryExploit(DeliveryExploit)
    end
})

local ESP = Window:Tab({
    Title = "Players ESP",
    Locked = false,
})

local Section = ESP:Section({ 
    Title = "Color Conifgurations",
    TextXAlignment = "Left",
    TextSize = 17,
})

ESP:Colorpicker({
    Title = "Hitbox Color",
    Default = Settings.Colors.Box,
    Callback = function(color)
        Settings.Colors.Box = color
        UpdateColors()
    end
})

ESP:Colorpicker({
    Title = "ESP Name Color",
    Default = Settings.Colors.Name,
    Callback = function(color)
        Settings.Colors.Name = color
        UpdateColors()
    end
})

ESP:Colorpicker({
    Title = "Tracer Color",
    Default = Settings.Colors.Tracer,
    Callback = function(color)
        Settings.Colors.Tracer = color
        UpdateColors()
    end
})

local Section = ESP:Section({ 
    Title = "ESP",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Toggle = ESP:Toggle({
    Title = "Enable ESP",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        EnableESP(state) 
    end
})

local Toggle = ESP:Toggle({
    Title = "Tracer ESP",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        EnableTracer(state)
    end
})

local Toggle = ESP:Toggle({
    Title = "Hitbox ESP",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        EnableHitbox(state)
    end
})

local Toggle = ESP:Toggle({
    Title = "Money ESP",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        EnableMoneyESP(state)
    end
})
