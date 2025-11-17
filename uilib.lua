-- Hiklo's Aura Tiny UI Lib | Ultra-Compact (180x220), Draggable, Fixed Toggles, Sleek Animations | Pure Luau

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local me = Players.LocalPlayer
local pgui = me:WaitForChild("PlayerGui")

local tween = TweenInfo.new(0.18, Enum.EasingStyle.Quint)
local hover = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

local Lib = {}

-- Create Tiny Rectangle Window (180x220)
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

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = win

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(60, 60, 90)
	stroke.Thickness = 1
	stroke.Parent = win

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 32)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	titleBar.Parent = win

	local tcorner = Instance.new("UICorner")
	tcorner.CornerRadius = UDim.new(0, 10)
	tcorner.Parent = titleBar

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -40, 1, 0)
	titleLbl.Position = UDim2.new(0, 8, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title or "Aura"
	titleLbl.TextColor3 = Color3.fromRGB(120, 200, 255)
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 14
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = titleBar

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 24, 0, 24)
	close.Position = UDim2.new(1, -28, 0.5, -12)
	close.BackgroundTransparency = 1
	close.Text = "×"
	close.TextColor3 = Color3.fromRGB(255, 100, 100)
	close.Font = Enum.Font.GothamBold
	close.TextSize = 18
	close.Parent = titleBar

	close.MouseButton1Click:Connect(function()
		TS:Create(win, tween, {Size = UDim2.new(0, 0, 0, 0)}):Play()
		task.delay(0.2, function() gui:Destroy() end)
	end)

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -16, 1, -44)
	content.Position = UDim2.new(0, 8, 0, 36)
	content.BackgroundTransparency = 1
	content.Parent = win

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 6)
	list.Parent = content

	-- FIXED DRAGGING (on titlebar only)
	local dragging = false
	local dragStart, startPos
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
			win.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Pop-in
	win.Size = UDim2.new(0, 0, 0, 0)
	TS:Create(win, tween, {Size = UDim2.new(0, 180, 0, 220)}):Play()

	local window = {content = content}
	setmetatable(window, {__index = Lib})
	return window
end

-- Button (Compact, Ripple, Hover Pop)
function Lib:Button(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = self.content

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local ripple = Instance.new("Frame")
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	ripple.BackgroundTransparency = 0.7
	ripple.Visible = false
	ripple.Parent = btn

	local rcorner = Instance.new("UICorner")
	rcorner.CornerRadius = UDim.new(1, 0)
	rcorner.Parent = ripple

	btn.MouseButton1Click:Connect(function()
		local mouse = me:GetMouse()
		ripple.Position = UDim2.new(0, mouse.X - btn.AbsolutePosition.X, 0, mouse.Y - btn.AbsolutePosition.Y)
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Visible = true
		TS:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 120, 0, 120),
			BackgroundTransparency = 1
		}):Play()
		TS:Create(btn, tween, {Size = UDim2.new(1, 0, 0, 30)}):Play()
		task.delay(0.1, function()
			TS:Create(btn, tween, {Size = UDim2.new(1, 0, 0, 28)}):Play()
		end)
		if callback then callback() end
	end)

	btn.MouseEnter:Connect(function()
		TS:Create(btn, hover, {BackgroundColor3 = Color3.fromRGB(65, 65, 90)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TS:Create(btn, hover, {BackgroundColor3 = Color3.fromRGB(45, 45, 70)}):Play()
	end)
end

-- Toggle (FIXED: Works 100%, Smooth Knob, Glow)
function Lib:Toggle(text, default, callback)
	local state = default or false

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 28)
	container.BackgroundTransparency = 1
	container.Parent = self.content

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.65, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(210, 210, 230)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 46, 0, 22)
	switch.Position = UDim2.new(1, -50, 0.5, -11)
	switch.BackgroundColor3 = state and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(60, 60, 70)
	switch.Parent = container

	local scorner = Instance.new("UICorner")
	scorner.CornerRadius = UDim.new(1, 0)
	scorner.Parent = switch

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, state and 25 or 3, 0.5, -9)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.Parent = switch

	local kcorner = Instance.new("UICorner")
	kcorner.CornerRadius = UDim.new(1, 0)
	kcorner.Parent = knob

	local function update(s)
		state = s
		TS:Create(switch, tween, {BackgroundColor3 = s and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(60, 60, 70)}):Play()
		TS:Create(knob, tween, {Position = UDim2.new(0, s and 25 or 3, 0.5, -9)}):Play()
		if callback then callback(s) end
	end

	container.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			update(not state)
		end
	end)

	-- Initial state
	if state then update(true) end

	return {set = update, get = function() return state end}
end

-- Example Usage (Uncomment to test)
--[[
local win = Lib:Window("Tiny Aura")
win:Button("Test", function() print("worked") end)
local t = win:Toggle("Fly", false, function(s) print("Fly:", s) end)
win:Button("Flip", function() t.set(not t.get()) end)
--]]

return Lib
