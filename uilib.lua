-- Simple UI Library in pure Luau
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)

local lib = {}

function lib.Window(title)
    local screen = Instance.new("ScreenGui")
    screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screen.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Window"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = frame

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local yPos = 0
    local function addElement(element)
        element.Position = UDim2.new(0, 0, 0, yPos)
        element.Parent = content
        yPos = yPos + element.Size.Y.Offset + 10
    end

    -- Dragging
    local dragging = false
    local dragStart, startPos
    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return {
        add = addElement,
        frame = frame
    }
end

function lib.Button(win, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TS:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
    end)

    win.add(btn)
    return btn
end

function lib.Toggle(win, text, default, callback)
    local state = default or false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 70)
    toggle.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, state and 28 or 3, 0.5, -10)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = toggle

    local kcorner = Instance.new("UICorner")
    kcorner.CornerRadius = UDim.new(1, 0)
    kcorner.Parent = knob

    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            callback(state)
            TS:Create(toggle, tweenInfo, {BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 70)}):Play()
            TS:Create(knob, tweenInfo, {Position = UDim2.new(0, state and 28 or 3, 0.5, -10)}):Play()
        end
    end)

    win.add(container)
end

-- Example usage (comment out if not needed)
--[[
local win = lib.Window("Simple UI")
lib.Button(win, "Click Me", function() print("Clicked!") end)
lib.Toggle(win, "God Mode", false, function(state) print("Toggle:", state) end)
--]]

return lib
