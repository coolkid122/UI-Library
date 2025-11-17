-- Hiklo's Aura Mini UI Lib | Compact, Animated, Draggable, Beautiful | Pure Luau
-- ~180 lines, fully working, no repeats

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")

local me = Players.LocalPlayer
local pgui = me:WaitForChild("PlayerGui")

local tweenIn = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local hoverIn = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

local Lib = {}
Lib.Windows = {}

-- Create Window
function Lib:Window(title)
	local screen = Instance.new("ScreenGui")
	screen.Name = "HikloAura_"..tostring(tick())
	screen.Parent = pgui
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local win = Instance.new("Frame")
	win.Size = UDim2.new(0, 310, 0, 420)
	win.Position = UDim2.fromScale(0.5, 0.5)
	win.AnchorPoint = Vector2.new(0.5, 0.5)
	win.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	win.ClipsDescendants = true
	win.Parent = screen

	local glow = Instance.new("ImageLabel")
	glow.Size = UDim2.new(1, 70, 1, 70)
	glow.Position = UDim2.new(0, -35, 0, -35)
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://4996891970"
	glow.ImageColor3 = Color3.fromRGB(80, 160, 255)
	glow.ImageTransparency = 0.75
	glow.ScaleType = Enum.ScaleType.Slice
	glow.SliceCenter = Rect.new(20,20,280,280)
	glow.ZIndex = 0
	glow.Parent = win

	local glass = Instance.new("Frame")
	glass.Size = UDim2.new(1,0,1,0)
	glass.BackgroundColor3 = Color3.fromRGB(30,30,45)
	glass.BackgroundTransparency = 0.35
	glass.ZIndex = 1
	glass.Parent = win

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,35))
	}
	grad.Rotation = 135
	grad.Parent = glass

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = win

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70,70,100)
	stroke.Thickness = 1.2
	stroke.Transparency = 0.4
	stroke.Parent = win

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1,0,0,48)
	titleBar.BackgroundColor3 = Color3.fromRGB(12,12,22)
	titleBar.ZIndex = 3
	titleBar.Parent = win

	local tgrad = Instance.new("UIGradient")
	tgrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,18))
	}
	tgrad.Rotation = 90
	tgrad.Parent = titleBar

	local tcorner = Instance.new("UICorner")
	tcorner.CornerRadius = UDim.new(0, 16)
	tcorner.Parent = titleBar

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,-70,1,0)
	titleLbl.Position = UDim2.new(0,18,0,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title or "Hiklo's Aura"
	titleLbl.TextColor3 = Color3.fromRGB(130,210,255)
	titleLbl.Font = Enum.Font.GothamBlack
	titleLbl.TextSize = 18
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 4
	titleLbl.Parent = titleBar

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0,36,0,36)
	close.Position = UDim2.new(1,-45,0.5,-18)
	close.BackgroundTransparency = 1
	close.Text = "×"
	close.TextColor3 = Color3.fromRGB(255,90,90)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 26
	close.ZIndex = 5
	close.Parent = titleBar

	close.MouseEnter:Connect(function()
		TS:Create(close, hoverIn, {TextColor3 = Color3.fromRGB(255,140,140)}):Play()
	end)
	close.MouseLeave:Connect(function()
		TS:Create(close, hoverIn, {TextColor3 = Color3.fromRGB(255,90,90)}):Play()
	end)
	close.MouseButton1Click:Connect(function()
		TS:Create(win, tweenIn, {Size = UDim2.new(0,0,0,0)}):Play()
		task.delay(0.25, function() screen:Destroy() end)
	end)

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-24,1,-70)
	content.Position = UDim2.new(0,12,0,58)
	content.BackgroundTransparency = 1
	content.ZIndex = 2
	content.Parent = win

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0,9)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = content

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0,6)
	pad.Parent = content

	-- Draggable
	local dragging, dragStart, startPos
	titleBar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = inp.Position
			startPos = win.Position
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = inp.Position - dragStart
			win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Pop-in animation
	win.Size = UDim2.new(0,0,0,0)
	TS:Create(win, tweenIn, {Size = UDim2.new(0,310,0,420)}):Play()

	local window = {content = content}
	setmetatable(window, {__index = Lib})
	table.insert(Lib.Windows, screen)
	return window
end

-- Button
function Lib:Button(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,40)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,75)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.AutoButtonColor = false
	btn.ZIndex = 3
	btn.Parent = self.content

	local bcorner = Instance.new("UICorner")
	bcorner.CornerRadius = UDim.new(0,12)
	bcorner.Parent = btn

	local bgrad = Instance.new("UIGradient")
	bgrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(70,70,100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,65))
	}
	bgrad.Rotation = 45
	bgrad.Parent = btn

	local ripple = Instance.new("Frame")
	ripple.Size = UDim2.new(0,0,0,0)
	ripple.Position = UDim2.new(0.5,0,0.5,0)
	ripple.AnchorPoint = Vector2.new(0.5,0.5)
	ripple.BackgroundColor3 = Color3.fromRGB(100,180,255)
	ripple.BackgroundTransparency = 0.6
	ripple.ZIndex = 2
	ripple.Visible = false
	ripple.Parent = btn

	local rcorner = Instance.new("UICorner")
	rcorner.CornerRadius = UDim.new(1,0)
	rcorner.Parent = ripple

	btn.MouseButton1Click:Connect(function()
		ripple.Size = UDim2.new(0,0,0,0)
		ripple.Visible = true
		TS:Create(ripple, TweenInfo.new(0.55, Enum.EasingStyle.Quint), {Size = UDim2.new(0,180,0,180), BackgroundTransparency = 1}):Play()
		TS:Create(btn, tweenIn, {Size = UDim2.new(1,0,0,42)}):Play()
		task.delay(0.1, function()
			TS:Create(btn, tweenIn, {Size = UDim2.new(1,0,0,40)}):Play()
		end)
		if callback then callback() end
	end)

	btn.MouseEnter:Connect(function()
		TS:Create(bgrad, hoverIn, {Rotation = 60}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TS:Create(bgrad, hoverIn, {Rotation = 45}):Play()
	end)

	return btn
end

-- Toggle
function Lib:Toggle(text, default, callback)
	local state = default or false
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,0,0,40)
	container.BackgroundTransparency = 1
	container.ZIndex = 3
	container.Parent = self.content

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.68,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(220,220,240)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 15
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 4
	label.Parent = container

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0,62,0,30)
	switch.Position = UDim2.new(1,-68,0.5,-15)
	switch.BackgroundColor3 = state and Color3.fromRGB(60,170,60) or Color3.fromRGB(55,55,70)
	switch.ZIndex = 4
	switch.Parent = container

	local scorner = Instance.new("UICorner")
	scorner.CornerRadius = UDim.new(1,0)
	scorner.Parent = switch

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,24,0,24)
	knob.Position = UDim2.new(0, state and 34 or 4, 0.5, -12)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.ZIndex = 5
	knob.Parent = switch

	local kcorner = Instance.new("UICorner")
	kcorner.CornerRadius = UDim.new(1,0)
	kcorner.Parent = knob

	local kglow = Instance.new("ImageLabel")
	kglow.Size = UDim2.new(1,14,1,14)
	kglow.Position = UDim2.new(0,-7,0,-7)
	kglow.BackgroundTransparency = 1
	kglow.Image = "rbxassetid://4996891970"
	kglow.ImageColor3 = state and Color3.fromRGB(120,255,120) or Color3.fromRGB(100,200,255)
	kglow.ImageTransparency = 0.65
	kglow.ScaleType = Enum.ScaleType.Slice
	kglow.SliceCenter = Rect.new(20,20,280,280)
	kglow.ZIndex = 4
	kglow.Parent = knob

	local function update(s)
		state = s
		TS:Create(switch, tweenIn, {BackgroundColor3 = s and Color3.fromRGB(60,170,60) or Color3.fromRGB(55,55,70)}):Play()
		TS:Create(knob, tweenIn, {Position = UDim2.new(0, s and 34 or 4, 0.5, -12)}):Play()
		TS:Create(kglow, tweenIn, {ImageColor3 = s and Color3.fromRGB(120,255,120) or Color3.fromRGB(100,200,255)}):Play()
		if callback then callback(s) end
	end

	container.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			update(not state)
		end
	end)

	if state then update(true) end

	return {set = update, get = function() return state end}
end

-- Example (uncomment to test)
--[[
local win = Lib:Window("Hiklo's Aura v2")
win:Button("Kill All", function() print("boom") end)
local god = win:Toggle("God Mode", false, function(s) print("God:", s) end)
win:Button("Toggle God", function() god.set(not god.get()) end)
--]]

return Lib
