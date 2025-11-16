-- uilib.lua | Hiklo's Aura UI Library
-- Clean, lightweight, lowercase functions, dark theme
-- Usage: local uilib = loadstring(game:HttpGet("RAW_GITHUB_URL"))() or inline it

local uilib = {}

local players = game:GetService("Players")
local me = players.LocalPlayer
local screengui = Instance.new("ScreenGui")
screengui.Name = "HikloAuraUI"
screengui.Parent = me:WaitForChild("PlayerGui")
screengui.ResetOnSpawn = false

-- createwindow(title: string) -> frame
function uilib.createwindow(title)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 220, 0, 180)
	frame.Position = UDim2.new(0.5, -110, 0.3, -90)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	frame.BorderSizePixel = 0
	frame.Draggable = true
	frame.Active = true
	frame.Parent = screengui

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
	}
	grad.Rotation = 90
	grad.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = frame

	local tframe = Instance.new("Frame")
	tframe.Size = UDim2.new(1, 0, 0, 40)
	tframe.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	tframe.Parent = frame

	local tcorner = Instance.new("UICorner")
	tcorner.CornerRadius = UDim.new(0, 16)
	tcorner.Parent = tframe

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = title or "Hiklo's Aura"
	label.TextColor3 = Color3.fromRGB(120, 220, 255)
	label.TextSize = 20
	label.Font = Enum.Font.GothamBold
	label.Parent = tframe

	return frame
end

-- title(parent: frame, text: string)
function uilib.title(parent, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 30)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.Parent = parent
	return label
end

-- button(parent: frame, posY: number, text: string, callback: function) -> btn, grad, stroke
function uilib.button(parent, posy, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, posy)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 16
	btn.Font = Enum.Font.GothamBold
	btn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(140, 40, 40)
	stroke.Thickness = 2
	stroke.Parent = btn

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 80, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 40, 40))
	}
	grad.Rotation = 45
	grad.Parent = btn

	btn.MouseButton1Click:Connect(callback)

	return btn, grad, stroke
end

-- toggle(parent: frame, posY: number, text: string, default: boolean, callback: function(state)) -> btn, grad, stroke
function uilib.toggle(parent, posy, text, default, callback)
	local state = default or false
	local fulltext = text .. ": " .. (state and "ON" or "OFF")

	local btn, grad, stroke = uilib.button(parent, posy, fulltext, function()
		state = not state
		btn.Text = text .. ": " .. (state and "ON" or "OFF")
		if state then
			grad.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 80)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 200, 40))
			}
			stroke.Color = Color3.fromRGB(20, 140, 20)
		else
			grad.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 80, 80)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 40, 40))
			}
			stroke.Color = Color3.fromRGB(140, 40, 40)
		end
		if callback then callback(state) end
	end)

	if state then
		grad.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 255, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 200, 40))
		}
		stroke.Color = Color3.fromRGB(20, 140, 20)
	end

	return btn, grad, stroke, function(newstate)
		if newstate == nil then return state end
		if newstate ~= state then
			btn.MouseButton1Click:Fire()
		end
	end
end

-- label(parent: frame, posY: number, text: string)
function uilib.label(parent, posy, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.9, 0, 0, 25)
	label.Position = UDim2.new(0.05, 0, 0, posy)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(180, 180, 200)
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

-- slider(parent: frame, posY: number, text: string, min: number, max: number, default: number, callback: function(value))
function uilib.slider(parent, posy, text, minval, maxval, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.9, 0, 0, 50)
	frame.Position = UDim2.new(0.05, 0, 0, posy)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. default
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.Parent = frame

	local sliderbg = Instance.new("Frame")
	sliderbg.Size = UDim2.new(1, 0, 0, 8)
	sliderbg.Position = UDim2.new(0, 0, 0, 25)
	sliderbg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	sliderbg.Parent = frame

	local sliderfill = Instance.new("Frame")
	sliderfill.Size = UDim2.new((default - minval) / (maxval - minval), 0, 1, 0)
	sliderfill.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
	sliderfill.Parent = sliderbg

	local corner1 = Instance.new("UICorner")
	corner1.CornerRadius = UDim.new(0, 4)
	corner1.Parent = sliderbg
	local corner2 = Instance.new("UICorner")
	corner2.CornerRadius = UDim.new(0, 4)
	corner2.Parent = sliderfill

	local dragging = false

	sliderbg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	sliderbg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = math.clamp((input.Position.X - sliderbg.AbsolutePosition.X) / sliderbg.AbsoluteSize.X, 0, 1)
			local value = math.floor(minval + rel * (maxval - minval) + 0.5)
			sliderfill.Size = UDim2.new(rel, 0, 1, 0)
			label.Text = text .. ": " .. value
			if callback then callback(value) end
		end
	end)

	return frame
end

return uilib
