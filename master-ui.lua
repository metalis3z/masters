-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Instances:

local LunarUi = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local stroke = Instance.new("UIStroke")
local ImageLabel = Instance.new("ImageLabel")
local MainText = Instance.new("TextLabel")
local TextLabel = Instance.new("TextLabel")
local Overlay = Instance.new("Frame") 

-- Properties:

LunarUi.Name = "LunarUi"
LunarUi.IgnoreGuiInset = true
LunarUi.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
LunarUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Overlay.Name = "GlassOverlay"
Overlay.Parent = LunarUi
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.ZIndex = 0

TweenService:Create(Overlay, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
	BackgroundTransparency = 0.2
}):Play()

Frame.Parent = LunarUi
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.100
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 1.5, 0)
Frame.Size = UDim2.new(0, 326, 0, 193)

UICorner.Parent = Frame

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.354749441, 0, 0.164281815, 0)
ImageLabel.Size = UDim2.new(0, 95, 0, 76)
ImageLabel.Image = "rbxassetid://81628958072398"

stroke.Name = "UIStroke"
stroke.Parent = Frame
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Thickness = 2
stroke.Transparency = 0

MainText.Name = "MainText"
MainText.Parent = Frame
MainText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainText.BackgroundTransparency = 1.000
MainText.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainText.BorderSizePixel = 0
MainText.Position = UDim2.new(0.0730055347, 0, 0.729062259, 0)
MainText.Size = UDim2.new(0.854823947, 0, -0.122750714, 40)
MainText.Font = Enum.Font.Arial
MainText.Text = getgenv().LoadingText or "Loading Script..."
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.TextScaled = true
MainText.TextSize = 14.000
MainText.TextWrapped = true

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0699380487, 0, 0.844559431, 0)
TextLabel.Size = UDim2.new(0.854823947, 0, -0.130853057, 40)
TextLabel.Font = Enum.Font.Arial
TextLabel.Text = "(discord,gg/PT.BEST)"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true


local tweenIn = TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, 0, 0.5, 0)
})

local tweenOut = TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
	Position = UDim2.new(0.5, 0, -0.5, 0)
})

tweenIn:Play()
tweenIn.Completed:Wait()

task.wait(4)

tweenOut:Play()

TweenService:Create(Overlay, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
	BackgroundTransparency = 1
}):Play()

tweenOut.Completed:Wait()
task.wait(0.2)

LunarUi:Destroy()
