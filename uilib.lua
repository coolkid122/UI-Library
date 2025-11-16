local TweenService = game:GetService("TweenService")
local uilib = {}

local players = game:GetService("Players")
local me = players.LocalPlayer
local screengui = Instance.new("ScreenGui")
screengui.Name = "HikloAuraUI"
screengui.Parent = me:WaitForChild("PlayerGui")
screengui.ResetOnSpawn = false
screengui.DisplayOrder = 999

local tweeninfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function uilib.createwindow(title)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 240, 0, 200)
	frame.Position = UDim2.new(0.5, -120, 0.5, -100)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	frame.BorderSizePixel = 0
	frame.Parent = screengui

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 48)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
	}
	grad.Rotation = 90
	grad.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 50, 70)
	stroke.Thickness = 1
	stroke.Transparency = 0.6
	stroke.Parent = frame

	local tframe = Instance.new("Frame")
	tframe.Size = UDim2.new(1, 0, 0, 44)
	tframe.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
	tframe.BorderSizePixel = 0
	tframe.Parent = frame

	local tcorner = Instance.new("UICorner")
	tcorner.CornerRadius = UDim.new(0, 14)
	tcorner.Parent = tframe

	local tstroke = Instance.new("UIStroke")
	tstroke.Color = Color3.fromRGB(40, 40, 60)
	tstroke.Thickness = 1
	tstroke.Parent = tframe

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = title or "Hiklo's Aura"
	label.TextColor3 = Color3.fromRGB(130, 210, 255)
	label.TextSize = 17
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tframe

	frame.Draggable = true
	frame.Active = true

	return frame
end

function uilib.toggle(parent, posy, text, default, callback)
	local state = default or false
	local fulltext = text .. ": " .. (state and "ON" or "OFF")

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 38)
	btn.Position = UDim2.new(0.06, 0, 0, posy)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.Text = ""
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = state and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(140, 40, 40)
	stroke.Thickness = 1.8
	stroke.Parent = btn

	local grad = Instance.new("UIGradient")
	grad.Color = state and ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 220, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 160, 40))
	} or ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 80, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 40))
	}
	grad.Rotation = 45
	grad.Parent = btn

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = fulltext
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 15
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btn

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 22, 0, 22)
	indicator.Position = UDim2.new(1, -30, 0.5, -11)
	indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	indicator.Parent = btn

	local indcorner = Instance.new("UICorner")
	indcorner.CornerRadius = UDim.new(1, 0)
	indcorner.Parent = indicator

	local indgrad = Instance.new("UIGradient")
	indgrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 255))
	}
	indgrad.Parent = indicator

	local function updatestate(newstate)
		state = newstate
		label.Text = text .. ": " .. (state and "ON" or "OFF")
		TweenService:Create(stroke, tweeninfo, {Color = state and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(140, 40, 40)}):Play()
		TweenService:Create(grad, tweeninfo, {Color = state and ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 220, 70)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 160, 40))
		} or ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 80, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 40))
		}}):Play()
		TweenService:Create(indicator, tweeninfo, {Position = UDim2.new(1, state and -50 or -30, 0.5, -11)}):Play()
		if callback then callback(state) end
	end

	btn.MouseButton1Click:Connect(function()
		updatestate(not state)
	end)

	if state then
		indicator.Position = UDim2.new(1, -50, 0.5, -11)
	end

	return btn, function(newstate)
		if newstate ~= nil and newstate ~= state then
			updatestate(newstate)
		end
		return state
	end
end

function uilib.button(parent, posy, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 38)
	btn.Position = UDim2.new(0.06, 0, 0, posy)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 15
	btn.Font = Enum.Font.GothamBold
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(80, 80, 100)
	stroke.Thickness = 1.5
	stroke.Parent = btn

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 85)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 65))
	}
	grad.Rotation = 45
	grad.Parent = btn

	btn.MouseButton1Click:Connect(callback)

	btn.MouseEnter:Connect(function()
		TweenService:Create(grad, TweenInfo.new(0.2), {Rotation = 60}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 100, 130)}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(grad, TweenInfo.new(0.2), {Rotation = 45}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 100)}):Play()
	end)

	return btn
end

return uilib
