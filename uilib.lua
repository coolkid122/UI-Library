local TweenService = game:GetService("TweenService")
local uilib = {}

local players = game:GetService("Players")
local me = players.LocalPlayer
local screengui = Instance.new("ScreenGui")
screengui.Name = "HikloAuraUI"
screengui.Parent = me:WaitForChild("PlayerGui")
screengui.ResetOnSpawn = false
screengui.DisplayOrder = 999

local tweeninfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local fasttween = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function uilib.createwindow(title)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	frame.BorderSizePixel = 0
	frame.Parent = screengui

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
	}
	grad.Rotation = 90
	grad.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 50, 65)
	stroke.Thickness = 1
	stroke.Transparency = 0.7
	stroke.Parent = frame

	frame:TweenSize(UDim2.new(0, 240, 0, 200), "Out", "Quart", 0.4, true)

	local tframe = Instance.new("Frame")
	tframe.Size = UDim2.new(1, 0, 0, 45)
	tframe.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	tframe.BorderSizePixel = 0
	tframe.Parent = frame

	local tgrad = Instance.new("UIGradient")
	tgrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
	}
	tgrad.Rotation = 90
	tgrad.Parent = tframe

	local tcorner = Instance.new("UICorner")
	tcorner.CornerRadius = UDim.new(0, 16)
	tcorner.Parent = tframe

	local tstroke = Instance.new("UIStroke")
	tstroke.Color = Color3.fromRGB(40, 40, 55)
	tstroke.Thickness = 1
	tstroke.Parent = tframe

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = title or "Hiklo's Aura"
	label.TextColor3 = Color3.fromRGB(140, 220, 255)
	label.TextSize = 18
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tframe

	frame.Draggable = true
	frame.Active = true

	return frame
end

function uilib.title(parent, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 28)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(190, 190, 210)
	label.TextSize = 13
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	local ts = Instance.new("UIStroke")
	ts.Color = Color3.fromRGB(255, 255, 255)
	ts.Thickness = 1.2
	ts.Transparency = 0.8
	ts.Parent = label
	label:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Sine", 0.3, true)
	return label
end

function uilib.button(parent, posy, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 38)
	btn.Position = UDim2.new(0.06, 0, 0, posy)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 15
	btn.Font = Enum.Font.GothamBold
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.TextTransparency = 1
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(65, 65, 80)
	stroke.Thickness = 1.5
	stroke.Parent = btn

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50
