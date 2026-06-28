local UILibrary = {}
UILibrary.__index = UILibrary

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function Create(class, properties)
    local obj = Instance.new(class)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

local function Tween(obj, info, properties)
    local tween = TweenService:Create(obj, info, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function UILibrary:CreateWindow(config)
    config = config or {}
    local title = config.Title or "UI Library"
    local size = config.Size or UDim2.new(0, 500, 0, 400)
    local theme = config.Theme or "Dark"

    local colors = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 30),
            TopBar    = Color3.fromRGB(30, 30, 45),
            Accent    = Color3.fromRGB(100, 80, 220),
            Button    = Color3.fromRGB(40, 40, 60),
            ButtonHov = Color3.fromRGB(60, 60, 90),
            Text      = Color3.fromRGB(255, 255, 255),
            SubText   = Color3.fromRGB(180, 180, 200),
            Toggle_ON = Color3.fromRGB(100, 80, 220),
            Toggle_OFF= Color3.fromRGB(60, 60, 80),
            Input     = Color3.fromRGB(30, 30, 50),
            Tab       = Color3.fromRGB(35, 35, 55),
            TabActive = Color3.fromRGB(100, 80, 220),
            Separator = Color3.fromRGB(50, 50, 70),
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 250),
            TopBar    = Color3.fromRGB(220, 220, 235),
            Accent    = Color3.fromRGB(100, 80, 220),
            Button    = Color3.fromRGB(200, 200, 215),
            ButtonHov = Color3.fromRGB(180, 180, 200),
            Text      = Color3.fromRGB(20, 20, 30),
            SubText   = Color3.fromRGB(80, 80, 100),
            Toggle_ON = Color3.fromRGB(100, 80, 220),
            Toggle_OFF= Color3.fromRGB(160, 160, 180),
            Input     = Color3.fromRGB(210, 210, 225),
            Tab       = Color3.fromRGB(215, 215, 230),
            TabActive = Color3.fromRGB(100, 80, 220),
            Separator = Color3.fromRGB(190, 190, 210),
        }
    }

    local C = colors[theme] or colors.Dark

    local ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundColor3 = C.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = MainFrame })
    Create("UIStroke", { Color = C.Accent, Thickness = 1.5, Parent = MainFrame })

    Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
    })

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.TopBar,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })

    Create("Frame", {
        Parent = TopBar,
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = C.TopBar,
        BorderSizePixel = 0,
    })

    Create("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local CloseBtn = Create("TextButton", {
        Name = "CloseBtn",
        Parent = TopBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -38, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(200, 60, 60),
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })

    local MinBtn = Create("TextButton", {
        Name = "MinBtn",
        Parent = TopBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -72, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(200, 160, 40),
        Text = "–",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })

    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = C.Tab,
        BorderSizePixel = 0,
    })

    local TabList = Create("ScrollingFrame", {
        Parent = TabContainer,
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    })
    Create("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 5),
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        Size = UDim2.new(1, -125, 1, -45),
        Position = UDim2.new(0, 122, 0, 43),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })

    MakeDraggable(MainFrame, TopBar)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, TweenInfo.new(0.3), { Size = UDim2.new(0, size.X.Offset, 0, 0) })
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, size.X.Offset, 0, 40)
            })
        else
            Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = size
            })
        end
    end)

    local Window = {}
    local Tabs = {}
    local activeTab = nil

    function Window:CreateTab(tabName, icon)
        tabName = tabName or "Tab"
        icon = icon or ""

        local TabBtn = Create("TextButton", {
            Name = tabName,
            Parent = TabList,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = C.Tab,
            BorderSizePixel = 0,
            Text = (icon ~= "" and icon .. "  " or "") .. tabName,
            TextColor3 = C.SubText,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            AutoButtonColor = false,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabBtn })

        local Indicator = Create("Frame", {
            Name = "Indicator",
            Parent = TabBtn,
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = C.Accent,
            BorderSizePixel = 0,
            Visible = false,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Indicator })

        local TabContent = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = C.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
        })
        Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        })
        Create("UIPadding", {
            Parent = TabContent,
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
        })

        TabContent:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

        end)

        local layout = TabContent:FindFirstChildOfClass("UIListLayout")
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)

        local function switchTo()
            if activeTab then
                Tween(activeTab.btn, TweenInfo.new(0.2), { BackgroundColor3 = C.Tab, TextColor3 = C.SubText })
                activeTab.indicator.Visible = false
                activeTab.content.Visible = false
            end
            Tween(TabBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.TabActive, TextColor3 = C.Text })
            Indicator.Visible = true
            TabContent.Visible = true
            activeTab = { btn = TabBtn, indicator = Indicator, content = TabContent }
        end

        TabBtn.MouseButton1Click:Connect(switchTo)

        TabBtn.MouseEnter:Connect(function()
            if activeTab and activeTab.btn ~= TabBtn then
                Tween(TabBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.ButtonHov })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab and activeTab.btn ~= TabBtn then
                Tween(TabBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.Tab })
            end
        end)

        if #Tabs == 0 then
            switchTo()
        end

        table.insert(Tabs, { btn = TabBtn, content = TabContent })
        TabList.CanvasSize = UDim2.new(0, 0, 0, layout and layout.AbsoluteContentSize.Y or 0)

        local Tab = {}

        local function updateCanvas()
            local l = TabContent:FindFirstChildOfClass("UIListLayout")
            if l then
                TabContent.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 20)
            end
        end

        function Tab:AddLabel(text)
            local Label = Create("TextLabel", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = text or "Label",
                TextColor3 = C.SubText,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            Create("UIPadding", {
                Parent = Label,
                PaddingLeft = UDim.new(0, 8),
            })
            updateCanvas()
            return Label
        end

        function Tab:AddSeparator()
            local Sep = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = C.Separator,
                BorderSizePixel = 0,
            })
            updateCanvas()
            return Sep
        end

        function Tab:AddButton(config)
            config = config or {}
            local btnText = config.Text or "Button"
            local callback = config.Callback or function() end

            local BtnFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = C.Button,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = BtnFrame })

            local Btn = Create("TextButton", {
                Parent = BtnFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = btnText,
                TextColor3 = C.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false,
            })

            Btn.MouseEnter:Connect(function()
                Tween(BtnFrame, TweenInfo.new(0.15), { BackgroundColor3 = C.ButtonHov })
            end)
            Btn.MouseLeave:Connect(function()
                Tween(BtnFrame, TweenInfo.new(0.15), { BackgroundColor3 = C.Button })
            end)
            Btn.MouseButton1Click:Connect(function()
                Tween(BtnFrame, TweenInfo.new(0.1), { BackgroundColor3 = C.Accent })
                task.wait(0.1)
                Tween(BtnFrame, TweenInfo.new(0.15), { BackgroundColor3 = C.Button })
                callback()
            end)

            updateCanvas()
            return Btn
        end

        function Tab:AddToggle(config)
            config = config or {}
            local toggleText = config.Text or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end

            local state = default

            local ToggleFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = C.Button,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ToggleFrame })

            Create("TextLabel", {
                Parent = ToggleFrame,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = toggleText,
                TextColor3 = C.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local ToggleBg = Create("Frame", {
                Parent = ToggleFrame,
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -56, 0.5, -12),
                BackgroundColor3 = state and C.Toggle_ON or C.Toggle_OFF,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleBg })

            local ToggleCircle = Create("Frame", {
                Parent = ToggleBg,
                Size = UDim2.new(0, 18, 0, 18),
                Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleCircle })

            local ToggleBtn = Create("TextButton", {
                Parent = ToggleFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
            })

            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                Tween(ToggleBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and C.Toggle_ON or C.Toggle_OFF
                })
                Tween(ToggleCircle, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                })
                callback(state)
            end)

            updateCanvas()

            local toggleObj = {}
            function toggleObj:Set(val)
                state = val
                Tween(ToggleBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and C.Toggle_ON or C.Toggle_OFF
                })
                Tween(ToggleCircle, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                })
                callback(state)
            end
            function toggleObj:Get() return state end
            return toggleObj
        end

        function Tab:AddSlider(config)
            config = config or {}
            local sliderText = config.Text or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end
            local suffix = config.Suffix or ""

            local value = math.clamp(default, min, max)

            local SliderFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = C.Button,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = SliderFrame })

            Create("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0.6, 0, 0, 28),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = sliderText,
                TextColor3 = C.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0.4, -12, 0, 28),
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(value) .. suffix,
                TextColor3 = C.Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            local SliderBg = Create("Frame", {
                Parent = SliderFrame,
                Size = UDim2.new(1, -24, 0, 8),
                Position = UDim2.new(0, 12, 0, 36),
                BackgroundColor3 = C.Toggle_OFF,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderBg })

            local fillPercent = (value - min) / (max - min)
            local SliderFill = Create("Frame", {
                Parent = SliderBg,
                Size = UDim2.new(fillPercent, 0, 1, 0),
                BackgroundColor3 = C.Accent,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })

            local SliderThumb = Create("Frame", {
                Parent = SliderBg,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(fillPercent, -8, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderThumb })
            Create("UIStroke", { Color = C.Accent, Thickness = 2, Parent = SliderThumb })

            local sliding = false

            local function updateSlider(input)
                local sliderPos = SliderBg.AbsolutePosition.X
                local sliderWidth = SliderBg.AbsoluteSize.X
                local mouseX = math.clamp(input.Position.X, sliderPos, sliderPos + sliderWidth)
                local percent = (mouseX - sliderPos) / sliderWidth
                value = math.floor(min + (max - min) * percent)
                value = math.clamp(value, min, max)

                Tween(SliderFill, TweenInfo.new(0.05), { Size = UDim2.new(percent, 0, 1, 0) })
                Tween(SliderThumb, TweenInfo.new(0.05), { Position = UDim2.new(percent, -8, 0.5, -8) })
                ValueLabel.Text = tostring(value) .. suffix
                callback(value)
            end

            SliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)

            updateCanvas()

            local sliderObj = {}
            function sliderObj:Set(val)
                value = math.clamp(val, min, max)
                local percent = (value - min) / (max - min)
                Tween(SliderFill, TweenInfo.new(0.1), { Size = UDim2.new(percent, 0, 1, 0) })
                Tween(SliderThumb, TweenInfo.new(0.1), { Position = UDim2.new(percent, -8, 0.5, -8) })
                ValueLabel.Text = tostring(value) .. suffix
                callback(value)
            end
            function sliderObj:Get() return value end
            return sliderObj
        end

        function Tab:AddInput(config)
            config = config or {}
            local inputText = config.Text or "Input"
            local placeholder = config.Placeholder or "Type here..."
            local callback = config.Callback or function() end

            local InputFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = C.Button,
                BorderSizePixel = 0,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = InputFrame })

            Create("TextLabel", {
                Parent = InputFrame,
                Size = UDim2.new(1, -12, 0, 26),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = inputText,
                TextColor3 = C.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local InputBox = Create("TextBox", {
                Parent = InputFrame,
                Size = UDim2.new(1, -24, 0, 26),
                Position = UDim2.new(0, 12, 0, 26),
                BackgroundColor3 = C.Input,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = placeholder,
                PlaceholderColor3 = C.SubText,
                TextColor3 = C.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = InputBox })
            Create("UIPadding", {
                Parent = InputBox,
                PaddingLeft = UDim.new(0, 8),
            })

            InputBox.FocusLost:Connect(function(enter)
                if enter then
                    callback(InputBox.Text)
                end
            end)

            updateCanvas()
            return InputBox
        end

        function Tab:AddDropdown(config)
            config = config or {}
            local dropText = config.Text or "Dropdown"
            local options = config.Options or {}
            local callback = config.Callback or function() end

            local selected = options[1] or "Select..."
            local open = false

            local DropFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = C.Button,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 10,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = DropFrame })

            Create("TextLabel", {
                Parent = DropFrame,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = dropText,
                TextColor3 = C.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 11,
            })

            local SelectedLabel = Create("TextLabel", {
                Parent = DropFrame,
                Size = UDim2.new(0.5, -40, 1, 0),
                Position = UDim2.new(0.5, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = C.Accent,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 11,
            })

            local Arrow = Create("TextLabel", {
                Parent = DropFrame,
                Size = UDim2.new(0, 24, 1, 0),
                Position = UDim2.new(1, -30, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = C.SubText,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ZIndex = 11,
            })

            local DropBtn = Create("TextButton", {
                Parent = DropFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 12,
            })

            local OptionsFrame = Create("Frame", {
                Parent = DropFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = C.Input,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 20,
                Visible = false,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = OptionsFrame })
            Create("UIStroke", { Color = C.Accent, Thickness = 1, Parent = OptionsFrame })

            local OptionsList = Create("Frame", {
                Parent = OptionsFrame,
                Size = UDim2.new(1, 0, 0, #options * 34 + 8),
                BackgroundTransparency = 1,
                ZIndex = 21,
            })
            Create("UIListLayout", {
                Parent = OptionsList,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
            })
            Create("UIPadding", {
                Parent = OptionsList,
                PaddingTop = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            })

            for _, opt in ipairs(options) do
                local OptBtn = Create("TextButton", {
                    Parent = OptionsList,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = C.Button,
                    BorderSizePixel = 0,
                    Text = opt,
                    TextColor3 = C.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    ZIndex = 22,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = OptBtn })

                OptBtn.MouseEnter:Connect(function()
                    Tween(OptBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.TabActive })
                end)
                OptBtn.MouseLeave:Connect(function()
                    Tween(OptBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.Button })
                end)
                OptBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    SelectedLabel.Text = opt
                    open = false
                    Tween(OptionsFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 0) })
                    task.wait(0.2)
                    OptionsFrame.Visible = false
                    Arrow.Text = "▼"
                    callback(opt)
                end)
            end

            local targetHeight = #options * 34 + 8

            DropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    OptionsFrame.Visible = true
                    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                    Tween(OptionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    })
                    Arrow.Text = "▲"
                else
                    Tween(OptionsFrame, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 0) })
                    task.wait(0.2)
                    OptionsFrame.Visible = false
                    Arrow.Text = "▼"
                end
            end)

            updateCanvas()

            local dropObj = {}
            function dropObj:Set(val)
                selected = val
                SelectedLabel.Text = val
                callback(val)
            end
            function dropObj:Get() return selected end
            return dropObj
        end

        return Tab
    end

    return Window
end

return UILibrary
