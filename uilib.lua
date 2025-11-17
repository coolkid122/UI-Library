-- Hiklo's Aura Tiny UI Lib v3 | 180x220 Rect, Frame.Draggable, Full Rounded, Fixed Animations | Pure Luau

local TS = game:GetService("TweenService")
local Players = game:GetService("Players")

local me = Players.LocalPlayer
local pgui = me:WaitForChild("PlayerGui")

local tween = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local hover = TweenInfo.new(0.14, Enum.EasingStyle.Quad)

local Lib = {}

-- Create Tiny Rectangular Window (180x220, Rounded, Draggable via Frame props)
function Lib:Window(title)
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.Parent = pgui

	local win = Instance.new("Frame")
	win.Size = UDim2.new(0, 180, 0, 220)
	win.Position = UDim2.fromScale(0.5, 0.5)
	win.AnchorPoint = Vector2.new(0.5, 0.5)
	win.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	win.Parent = gui
	win.Draggable = true  -- Roblox built-in dragging
	win.Active = true      -- Enables dragging

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)  -- Rounded corners
	corner.Parent = win

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(55, 55, 85)
	stroke.Thickness = 1.2
	stroke.Parent = win

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 34)
	titleBar.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
	titleBar.Parent = win

	local tcorner = Instance.new("UICorner")
	tcorner.CornerRadius = UDim.new(0, 12)  -- Rounded
	tcorner.Parent = titleBar

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -40, 1, 0)
	titleLbl.Position = UDim2.new(0, 10, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title or "Aura"
	titleLbl.TextColor3 = Color3.fromRGB(110, 190, 255)
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 14
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = titleBar

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 26, 0, 26)
	close.Position = UDim2.new(1, -30, 0.5, -13)
	close.BackgroundTransparency = 1
	close.Text = "×"
	close.TextColor3 = Color3.fromRGB(255, 80, 80)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 20
	close.Parent = titleBar

	close.MouseButton1Click:Connect(function()
		TS:Create(win, tween, {Size = UDim2.new(0, 0, 0, 0)}):Play()
		task.delay(0.2, function() gui:Destroy() end)
	end)

	close.MouseEnter:Connect(function()
		TS:Create(close, hover, {TextColor3 = Color3.fromRGB(255, 130, 130)}):Play()
	end)
	close.MouseLeave:Connect(function()
		TS:Create(close, hover, {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
	end)

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -16, 1, -46)
	content.Position = UDim2.new(0, 8, 0, 38)
	content.BackgroundTransparency = 1
	content.Parent = win

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 7)
	list.Parent = content

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.Parent = content

	-- Pop-in animation
	win.Size = UDim2.new(0, 0, 0, 0)
	TS:Create(win, tween, {Size = UDim2.new(0, 180, 0, 220)}):Play()

	local window = {content = content}
	setmetatable(window, {__index = Lib})
	return window
end

-- Button (Rounded, Ripple from click pos, Pop animation)
function Lib:Button(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(42, 42, 68)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = self.content

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)  -- Rounded
	corner.Parent = btn

	local ripple = Instance.new("Frame")
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.BackgroundColor3 = Color3.fromRGB(90, 170, 255)
	ripple.BackgroundTransparency = 0.65
	ripple.Visible = false
	ripple.Parent = btn

	local rcorner = Instance.new("UICorner")
	rcorner.CornerRadius = UDim.new(1, 0)
	rcorner.Parent = ripple

	btn.MouseButton1Click:Connect(function()
		local mouse = me:GetMouse()
		local abs = btn.AbsolutePosition
		ripple.Position = UDim2.new(0, mouse.X - abs.X, 0, mouse.Y - abs.Y)
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Visible = true
		TS:Create(ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 110, 0, 110),
			BackgroundTransparency = 1
		}):Play()
		TS:Create(btn, tween, {Size = UDim2.new(1, 0, 0, 32)}):Play()
		task.delay(0.12, function()
			TS:Create(btn, tween, {Size = UDim2.new(1, 0, 0, 30)}):Play()
		end)
		if callback then callback() end
	end)

	btn.MouseEnter:Connect(function()
		TS:Create(btn, hover, {BackgroundColor3 = Color3.fromRGB(60, 60, 88)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TS:Create(btn, hover, {BackgroundColor3 = Color3.fromRGB(42, 42, 68)}):Play()
	end)
end

-- Toggle (100% FIXED: Parallel tweens, no overlap, smooth knob + color)
function Lib:Toggle(text, default, callback)
	local state = default or false

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 30)
	container.BackgroundTransparency = 1
	container.Parent = self.content

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.62, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 230)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 48, 0, 24)
	switch.Position = UDim2.new(1, -52, 0.5, -12)
	switch.BackgroundColor3 = state and Color3.fromRGB(0, 155, 255) or Color3.fromRGB(58, 58, 72)
	switch.Parent = container

	local scorner = Instance.new("UICorner")
	scorner.CornerRadius = UDim.new(1, 0)  -- Pill shape
	scorner.Parent = switch

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new(0, state and 26 or 4, 0.5, -10)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.Parent = switch

	local kcorner = Instance.new("UICorner")
	kcorner.CornerRadius = UDim.new(1, 0)
	kcorner.Parent = knob

	-- Update function with parallel tweens
	local function update(s)
		if s == state then return end
		state = s

		-- Parallel color + position
		local colorTween = TS:Create(switch, tween, {
			BackgroundColor3 = s and Color3.fromRGB(0, 155, 255) or Color3.fromRGB(58, 58, 72)
		})
		local posTween = TS:Create(knob, tween, {
			Position = UDim2.new(0, s and 26 or 4, 0.5, -10)
		})
		colorTween:Play()
		posTween:Play()

		if callback then callback(s) end
	end

	-- Click handler
	container.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			update(not state)
		end
	end)

	-- Init
	if state then update(true) end

	return {
		set = update,
		get = function() return state end
	}
end

-- Example (Uncomment to test)
--[[
local win = Lib:Window("Aura v3")
win:Button("Test", function() print("click") end)
local t = win:Toggle("God", false, function(s) print("God:", s) end)
win:Button("Flip", function() t.set(not t.get()) end)
--]]

return Lib
