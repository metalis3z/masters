-- GUI Teleport ke Pemain di Server (RESPONSIVE RESIZE)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Cleanup
pcall(function()
	if game.CoreGui:FindFirstChild("TeleportUI") then
		game.CoreGui.TeleportUI:Destroy()
	end
end)

-- Setup GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "TeleportUI"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 300, 0, 160)
Frame.Position = UDim2.new(0.5, -150, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Frame).Color = Color3.fromRGB(50, 50, 60)

-- Header
local Header = Instance.new("TextLabel", Frame)
Header.Size = UDim2.new(1, -40, 0, 28)
Header.Position = UDim2.new(0, 10, 0, 10)
Header.BackgroundTransparency = 1
Header.Text = "🧭 Teleport to Player"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.TextColor3 = Color3.new(1,1,1)
Header.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Position = UDim2.new(1, -30, 0, 10)
Close.Text = "×"
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 18
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

-- Dropdown
local Dropdown = Instance.new("TextButton", Frame)
Dropdown.Size = UDim2.new(1, -40, 0, 32)
Dropdown.Position = UDim2.new(0, 20, 0, 60)
Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Dropdown.Text = "Select a player"
Dropdown.TextColor3 = Color3.new(1,1,1)
Dropdown.TextSize = 16
Dropdown.Font = Enum.Font.Ubuntu
Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

local PlayerList = Instance.new("ScrollingFrame", Frame)
PlayerList.Size = UDim2.new(1, -40, 0, 90)
PlayerList.Position = UDim2.new(0, 20, 0, 100)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(25,25,30)
PlayerList.Visible = false
PlayerList.ScrollBarThickness = 4
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 6)
local ListLayout = Instance.new("UIListLayout", PlayerList)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Drag
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
	end
end)

Header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
	end
end)

-- Selected player
local SelectedPlayer = nil

-- Toggle Dropdown
Dropdown.MouseButton1Click:Connect(function()
	PlayerList.Visible = not PlayerList.Visible
	TweenService = game:GetService("TweenService")
	local newSize = PlayerList.Visible and UDim2.new(0, 300, 0, 240) or UDim2.new(0, 300, 0, 160)
	TweenService:Create(Frame, TweenInfo.new(0.25), {Size = newSize}):Play()
end)

local function RefreshPlayers()
	for _, child in ipairs(PlayerList:GetChildren()) do
		if not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 26)
			btn.Text = p.Name
			btn.TextSize = 16
			btn.Font = Enum.Font.Ubuntu
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Parent = PlayerList
			btn.MouseButton1Click:Connect(function()
				SelectedPlayer = p
				Dropdown.Text = "👤 " .. p.Name
				PlayerList.Visible = false
				Frame.Size = UDim2.new(0, 300, 0, 160)
			end)
		end
	end
end

-- Button: Refresh
local RefreshBtn = Instance.new("TextButton", Frame)
RefreshBtn.Size = UDim2.new(0.45, -10, 0, 32)
RefreshBtn.Position = UDim2.new(0, 20, 1, -42)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
RefreshBtn.Text = "🔄 Refresh"
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextColor3 = Color3.new(1,1,1)
RefreshBtn.TextSize = 16
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)

RefreshBtn.MouseButton1Click:Connect(function()
	RefreshPlayers()
end)

-- Button: Teleport
local TeleportBtn = Instance.new("TextButton", Frame)
TeleportBtn.Size = UDim2.new(0.45, -10, 0, 32)
TeleportBtn.Position = UDim2.new(0.55, 10, 1, -42)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
TeleportBtn.Text = "🚀 Teleport"
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextColor3 = Color3.new(1,1,1)
TeleportBtn.TextSize = 16
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)

TeleportBtn.MouseButton1Click:Connect(function()
	if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if HRP then
			HRP.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
		end
	end
end)

-- Awal langsung refresh
RefreshPlayers()
