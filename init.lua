local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function tween(instance, duration, easingStyle, easingDirection, properties)
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	local t = TweenService:Create(instance, tweenInfo, properties)
	t:Play()
	return t
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function createRipple(parent, x, y)
	local ripple = Instance.new("Frame")
	ripple.Name = "Ripple"
	ripple.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
	ripple.BackgroundTransparency = 0.75
	ripple.BorderSizePixel = 0
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.Position = UDim2.new(0, x, 0, y)
	ripple.Size = UDim2.new(0, 0, 0, 0)
	ripple.ZIndex = parent.ZIndex + 10
	ripple.ClipsDescendants = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = ripple

	ripple.Parent = parent

	local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
	tween(ripple, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
		Size = UDim2.new(0, size, 0, size),
		BackgroundTransparency = 1,
	})

	task.delay(0.5, function()
		ripple:Destroy()
	end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UILibrary"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

local success = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)

if not success then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function Library:CreateWindow(config)
	local windowConfig = config or {}
	local title = windowConfig.Title or "Library"

	local Window = {}
	Window.__index = Window
	Window._toggles = {}
	Window._connections = {}

	local windowWidth = 320
	local windowPadding = 16
	local headerHeight = 52

	local windowFrame = Instance.new("Frame")
	windowFrame.Name = "Window"
	windowFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	windowFrame.BorderSizePixel = 0
	windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	windowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	windowFrame.Size = UDim2.new(0, windowWidth, 0, headerHeight)
	windowFrame.AutomaticSize = Enum.AutomaticSize.Y
	windowFrame.ClipsDescendants = true
	windowFrame.BackgroundTransparency = 1
	windowFrame.ZIndex = 1
	windowFrame.Parent = ScreenGui

	local windowShadow = Instance.new("ImageLabel")
	windowShadow.Name = "Shadow"
	windowShadow.BackgroundTransparency = 1
	windowShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	windowShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
	windowShadow.Size = UDim2.new(1, 40, 1, 40)
	windowShadow.Image = "rbxassetid://6014261993"
	windowShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	windowShadow.ImageTransparency = 0.88
	windowShadow.ScaleType = Enum.ScaleType.Slice
	windowShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	windowShadow.ZIndex = 0
	windowShadow.Parent = windowFrame

	local windowCorner = Instance.new("UICorner")
	windowCorner.CornerRadius = UDim.new(0, 14)
	windowCorner.Parent = windowFrame

	local windowStroke = Instance.new("UIStroke")
	windowStroke.Color = Color3.fromRGB(220, 220, 225)
	windowStroke.Thickness = 1
	windowStroke.Transparency = 0
	windowStroke.Parent = windowFrame

	local header = Instance.new("Frame")
	header.Name = "Header"
	header.BackgroundColor3 = Color3.fromRGB(252, 252, 253)
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, headerHeight)
	header.ZIndex = 2
	header.Parent = windowFrame

	local headerCornerTop = Instance.new("UICorner")
	headerCornerTop.CornerRadius = UDim.new(0, 14)
	headerCornerTop.Parent = header

	local headerFill = Instance.new("Frame")
	headerFill.Name = "BottomFill"
	headerFill.BackgroundColor3 = Color3.fromRGB(252, 252, 253)
	headerFill.BorderSizePixel = 0
	headerFill.Position = UDim2.new(0, 0, 1, -14)
	headerFill.Size = UDim2.new(1, 0, 0, 14)
	headerFill.ZIndex = 2
	headerFill.Parent = header

	local headerDivider = Instance.new("Frame")
	headerDivider.Name = "Divider"
	headerDivider.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
	headerDivider.BorderSizePixel = 0
	headerDivider.Position = UDim2.new(0, 0, 1, -1)
	headerDivider.Size = UDim2.new(1, 0, 0, 1)
	headerDivider.ZIndex = 3
	headerDivider.Parent = header

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, windowPadding, 0, 0)
	titleLabel.Size = UDim2.new(1, -windowPadding * 2, 1, 0)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(15, 15, 20)
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 3
	titleLabel.Parent = header

	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "Content"
	contentContainer.BackgroundTransparency = 1
	contentContainer.Position = UDim2.new(0, 0, 0, headerHeight)
	contentContainer.Size = UDim2.new(1, 0, 0, 0)
	contentContainer.AutomaticSize = Enum.AutomaticSize.Y
	contentContainer.ZIndex = 2
	contentContainer.Parent = windowFrame

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.FillDirection = Enum.FillDirection.Vertical
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 0)
	contentLayout.Parent = contentContainer

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 8)
	contentPadding.PaddingBottom = UDim.new(0, 8)
	contentPadding.PaddingLeft = UDim.new(0, windowPadding)
	contentPadding.PaddingRight = UDim.new(0, windowPadding)
	contentPadding.Parent = contentContainer

	tween(windowFrame, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
		BackgroundTransparency = 0,
	})

	windowFrame.Size = UDim2.new(0, windowWidth, 0, headerHeight)
	windowFrame.BackgroundTransparency = 1

	task.spawn(function()
		tween(windowFrame, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
			BackgroundTransparency = 0,
		})
	end)

	local isDragging = false
	local dragStart = nil
	local startPos = nil

	local function onDragBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			dragStart = input.Position
			startPos = windowFrame.Position
		end
	end

	local function onDragChanged(input)
		if isDragging and dragStart and startPos then
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - dragStart
				local newPos = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
				windowFrame.Position = newPos
			end
		end
	end

	local function onDragEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end

	local conn1 = header.InputBegan:Connect(onDragBegan)
	local conn2 = UserInputService.InputChanged:Connect(onDragChanged)
	local conn3 = UserInputService.InputEnded:Connect(onDragEnded)

	table.insert(Window._connections, conn1)
	table.insert(Window._connections, conn2)
	table.insert(Window._connections, conn3)

	function Window:CreateToggle(toggleConfig)
		local cfg = toggleConfig or {}
		local toggleTitle = cfg.Title or "Toggle"
		local toggleDesc = cfg.Description or nil
		local defaultValue = cfg.Default or false
		local callback = cfg.Callback or function() end

		local Toggle = {}
		Toggle._state = defaultValue
		Toggle._connections = {}

		local itemHeight = toggleDesc and 62 or 46
		local hasDesc = toggleDesc ~= nil

		local itemFrame = Instance.new("Frame")
		itemFrame.Name = "ToggleItem"
		itemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		itemFrame.BorderSizePixel = 0
		itemFrame.Size = UDim2.new(1, 0, 0, itemHeight)
		itemFrame.ClipsDescendants = true
		itemFrame.ZIndex = 3
		itemFrame.LayoutOrder = #Window._toggles + 1
		itemFrame.Parent = contentContainer

		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 10)
		itemCorner.Parent = itemFrame

		local itemStroke = Instance.new("UIStroke")
		itemStroke.Color = Color3.fromRGB(230, 230, 235)
		itemStroke.Thickness = 1
		itemStroke.Transparency = 0
		itemStroke.Parent = itemFrame

		local itemMargin = Instance.new("UIPadding")
		itemMargin.PaddingBottom = UDim.new(0, 6)
		itemMargin.Parent = itemFrame

		local hoverOverlay = Instance.new("Frame")
		hoverOverlay.Name = "HoverOverlay"
		hoverOverlay.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
		hoverOverlay.BackgroundTransparency = 1
		hoverOverlay.BorderSizePixel = 0
		hoverOverlay.Size = UDim2.new(1, 0, 1, 0)
		hoverOverlay.ZIndex = 3
		hoverOverlay.Parent = itemFrame

		local hoverCorner = Instance.new("UICorner")
		hoverCorner.CornerRadius = UDim.new(0, 10)
		hoverCorner.Parent = hoverOverlay

		local textContainer = Instance.new("Frame")
		textContainer.Name = "TextContainer"
		textContainer.BackgroundTransparency = 1
		textContainer.Position = UDim2.new(0, 14, 0, 0)
		textContainer.Size = UDim2.new(1, -80, 1, 0)
		textContainer.ZIndex = 4
		textContainer.Parent = itemFrame

		local titleText = Instance.new("TextLabel")
		titleText.Name = "Title"
		titleText.BackgroundTransparency = 1
		titleText.Font = Enum.Font.Gotham
		titleText.Text = toggleTitle
		titleText.TextColor3 = Color3.fromRGB(15, 15, 20)
		titleText.TextSize = 13.5
		titleText.TextXAlignment = Enum.TextXAlignment.Left
		titleText.ZIndex = 4

		if hasDesc then
			titleText.Position = UDim2.new(0, 0, 0, 12)
			titleText.Size = UDim2.new(1, 0, 0, 18)
		else
			titleText.Position = UDim2.new(0, 0, 0.5, 0)
			titleText.Size = UDim2.new(1, 0, 0, 18)
			titleText.AnchorPoint = Vector2.new(0, 0.5)
		end

		titleText.Parent = textContainer

		if hasDesc then
			local descText = Instance.new("TextLabel")
			descText.Name = "Description"
			descText.BackgroundTransparency = 1
			descText.Position = UDim2.new(0, 0, 0, 32)
			descText.Size = UDim2.new(1, 0, 0, 14)
			descText.Font = Enum.Font.Gotham
			descText.Text = toggleDesc
			descText.TextColor3 = Color3.fromRGB(140, 140, 150)
			descText.TextSize = 11.5
			descText.TextXAlignment = Enum.TextXAlignment.Left
			descText.ZIndex = 4
			descText.Parent = textContainer
		end

		local switchWidth = 44
		local switchHeight = 26
		local thumbSize = 20
		local thumbPadding = 3

		local switchContainer = Instance.new("Frame")
		switchContainer.Name = "SwitchContainer"
		switchContainer.BackgroundTransparency = 1
		switchContainer.AnchorPoint = Vector2.new(1, 0.5)
		switchContainer.Position = UDim2.new(1, -14, 0.5, 0)
		switchContainer.Size = UDim2.new(0, switchWidth, 0, switchHeight)
		switchContainer.ZIndex = 4
		switchContainer.Parent = itemFrame

		local switchTrack = Instance.new("Frame")
		switchTrack.Name = "Track"
		switchTrack.BackgroundColor3 = defaultValue and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(210, 210, 218)
		switchTrack.BorderSizePixel = 0
		switchTrack.Size = UDim2.new(1, 0, 1, 0)
		switchTrack.ZIndex = 4
		switchTrack.Parent = switchContainer

		local trackCorner = Instance.new("UICorner")
		trackCorner.CornerRadius = UDim.new(1, 0)
		trackCorner.Parent = switchTrack

		local thumbOffX = defaultValue and (switchWidth - thumbSize - thumbPadding) or thumbPadding

		local switchThumb = Instance.new("Frame")
		switchThumb.Name = "Thumb"
		switchThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		switchThumb.BorderSizePixel = 0
		switchThumb.AnchorPoint = Vector2.new(0, 0.5)
		switchThumb.Position = UDim2.new(0, thumbOffX, 0.5, 0)
		switchThumb.Size = UDim2.new(0, thumbSize, 0, thumbSize)
		switchThumb.ZIndex = 5
		switchThumb.Parent = switchTrack

		local thumbCorner = Instance.new("UICorner")
		thumbCorner.CornerRadius = UDim.new(1, 0)
		thumbCorner.Parent = switchThumb

		local thumbShadow = Instance.new("ImageLabel")
		thumbShadow.Name = "ThumbShadow"
		thumbShadow.BackgroundTransparency = 1
		thumbShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		thumbShadow.Position = UDim2.new(0.5, 0, 0.5, 1)
		thumbShadow.Size = UDim2.new(1, 8, 1, 8)
		thumbShadow.Image = "rbxassetid://6014261993"
		thumbShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		thumbShadow.ImageTransparency = 0.82
		thumbShadow.ScaleType = Enum.ScaleType.Slice
		thumbShadow.SliceCenter = Rect.new(49, 49, 450, 450)
		thumbShadow.ZIndex = 4
		thumbShadow.Parent = switchThumb

		local function animateToggle(state, animate)
			local targetThumbX = state and (switchWidth - thumbSize - thumbPadding) or thumbPadding
			local targetTrackColor = state and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(210, 210, 218)
			local targetThumbSize = thumbSize

			if animate then
				tween(switchTrack, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
					BackgroundColor3 = targetTrackColor,
				})

				tween(switchThumb, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
					Position = UDim2.new(0, targetThumbX, 0.5, 0),
					Size = UDim2.new(0, targetThumbSize, 0, targetThumbSize),
				})
			else
				switchTrack.BackgroundColor3 = targetTrackColor
				switchThumb.Position = UDim2.new(0, targetThumbX, 0.5, 0)
				switchThumb.Size = UDim2.new(0, targetThumbSize, 0, targetThumbSize)
			end
		end

		animateToggle(defaultValue, false)

		local isHovering = false

		local button = Instance.new("TextButton")
		button.Name = "Hitbox"
		button.BackgroundTransparency = 1
		button.Size = UDim2.new(1, 0, 1, 0)
		button.Text = ""
		button.ZIndex = 6
		button.Parent = itemFrame

		local c1 = button.MouseEnter:Connect(function()
			isHovering = true
			tween(hoverOverlay, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				BackgroundTransparency = 0.96,
			})
			tween(itemStroke, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				Color = Color3.fromRGB(180, 200, 240),
			})
		end)

		local c2 = button.MouseLeave:Connect(function()
			isHovering = false
			tween(hoverOverlay, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				BackgroundTransparency = 1,
			})
			tween(itemStroke, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				Color = Color3.fromRGB(230, 230, 235),
			})
		end)

		local c3 = button.MouseButton1Down:Connect(function()
			tween(switchThumb, 0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				Size = UDim2.new(0, thumbSize + 4, 0, thumbSize - 2),
			})
			tween(itemFrame, 0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				BackgroundColor3 = Color3.fromRGB(248, 248, 252),
			})
		end)

		local c4 = button.MouseButton1Up:Connect(function()
			tween(itemFrame, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			})
		end)

		local c5 = button.MouseButton1Click:Connect(function()
			Toggle._state = not Toggle._state

			animateToggle(Toggle._state, true)

			local relX = Mouse.X - itemFrame.AbsolutePosition.X
			local relY = Mouse.Y - itemFrame.AbsolutePosition.Y
			createRipple(itemFrame, relX, relY)

			task.spawn(function()
				local ok, err = pcall(callback, Toggle._state)
				if not ok then
					warn("[UILibrary] Toggle callback error: " .. tostring(err))
				end
			end)
		end)

		local c6 = button.TouchTap:Connect(function(touchPositions)
			Toggle._state = not Toggle._state
			animateToggle(Toggle._state, true)

			if #touchPositions > 0 then
				local touch = touchPositions[1]
				local relX = touch.X - itemFrame.AbsolutePosition.X
				local relY = touch.Y - itemFrame.AbsolutePosition.Y
				createRipple(itemFrame, relX, relY)
			end

			task.spawn(function()
				local ok, err = pcall(callback, Toggle._state)
				if not ok then
					warn("[UILibrary] Toggle callback error: " .. tostring(err))
				end
			end)
		end)

		table.insert(Toggle._connections, c1)
		table.insert(Toggle._connections, c2)
		table.insert(Toggle._connections, c3)
		table.insert(Toggle._connections, c4)
		table.insert(Toggle._connections, c5)
		table.insert(Toggle._connections, c6)

		function Toggle:Set(value)
			if type(value) ~= "boolean" then return end
			if Toggle._state == value then return end
			Toggle._state = value
			animateToggle(value, true)
			task.spawn(function()
				pcall(callback, value)
			end)
		end

		function Toggle:Get()
			return Toggle._state
		end

		function Toggle:Destroy()
			for _, conn in ipairs(Toggle._connections) do
				conn:Disconnect()
			end
			Toggle._connections = {}
			tween(itemFrame, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
			})
			task.delay(0.22, function()
				itemFrame:Destroy()
			end)
		end

		table.insert(Window._toggles, Toggle)

		return Toggle
	end

	function Window:Destroy()
		for _, conn in ipairs(Window._connections) do
			conn:Disconnect()
		end
		Window._connections = {}

		for _, toggle in ipairs(Window._toggles) do
			if toggle._connections then
				for _, conn in ipairs(toggle._connections) do
					conn:Disconnect()
				end
				toggle._connections = {}
			end
		end

		tween(windowFrame, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, windowWidth * 0.92, 0, headerHeight * 0.85),
		})

		task.delay(0.27, function()
			windowFrame:Destroy()
		end)
	end

	task.spawn(function()
		windowFrame.BackgroundTransparency = 1
		windowFrame.Size = UDim2.new(0, windowWidth * 0.94, 0, headerHeight)
		tween(windowFrame, 0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
			BackgroundTransparency = 0,
			Size = UDim2.new(0, windowWidth, 0, headerHeight),
		})
	end)

	return Window
end

return Library