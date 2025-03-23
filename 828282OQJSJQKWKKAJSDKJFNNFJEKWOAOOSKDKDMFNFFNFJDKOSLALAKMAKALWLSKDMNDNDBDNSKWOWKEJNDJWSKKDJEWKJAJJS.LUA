local UILibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Creates a unique ScreenGui for each window instance
local function CreateBaseGui(windowId)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NiniUI_" .. windowId
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    return ScreenGui
end

-- Theme settings
local Themes = {
    Dark = {
        OuterFrame = Color3.fromRGB(15, 15, 15),
        Window = Color3.fromRGB(25, 25, 25),
        TitleBar = Color3.fromRGB(20, 20, 20),
        TabContainer = Color3.fromRGB(20, 20, 20),
        Button = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(180, 180, 180),
        Stroke = Color3.fromRGB(40, 40, 40),
        Shadow = Color3.fromRGB(10, 10, 10),
    },
    Light = {
        OuterFrame = Color3.fromRGB(240, 240, 240),
        Window = Color3.fromRGB(255, 255, 255),
        TitleBar = Color3.fromRGB(230, 230, 230),
        TabContainer = Color3.fromRGB(245, 245, 245),
        Button = Color3.fromRGB(220, 220, 220),
        Text = Color3.fromRGB(50, 50, 50),
        Stroke = Color3.fromRGB(180, 180, 180),
        Shadow = Color3.fromRGB(200, 200, 200),
    }
}

-- Creates a draggable and resizable window with advanced features
function UILibrary:CreateWindow(title, width, height)
    local windowId = tostring(math.random(1000, 9999))
    local ScreenGui = CreateBaseGui(windowId)
    local currentTheme = "Dark"
    local windowWidth = width or 400
    local windowHeight = height or 500

    -- Load saved config
    local savedData = {}
    if getgenv().NiniUISavedData then
        local success, result = pcall(function()
            return HttpService:JSONDecode(getgenv().NiniUISavedData)
        end)
        if success then savedData = result end
    end
    local savedPos = savedData.Position or UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    local savedSize = savedData.Size or UDim2.new(0, windowWidth, 0, windowHeight)
    currentTheme = savedData.Theme or "Dark"
    local lastTab = savedData.LastTab or nil

    -- Custom hotkeys
    local hotkeys = savedData.Hotkeys or {
        ToggleUI = Enum.KeyCode.RightShift,
        ESP = Enum.KeyCode.H,
        Aimbot = Enum.KeyCode.J
    }

    -- Outer Frame with shadow
    local OuterFrame = Instance.new("Frame")
    OuterFrame.Size = savedSize
    OuterFrame.Position = savedPos
    OuterFrame.BackgroundColor3 = Themes[currentTheme].OuterFrame
    OuterFrame.BackgroundTransparency = 1
    OuterFrame.BorderSizePixel = 0
    local OuterCorner = Instance.new("UICorner")
    OuterCorner.CornerRadius = UDim.new(0, 12)
    OuterCorner.Parent = OuterFrame
    local OuterStroke = Instance.new("UIStroke")
    OuterStroke.Color = Themes[currentTheme].Stroke
    OuterStroke.Thickness = 2
    OuterStroke.Parent = OuterFrame
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageTransparency = 0.7
    Shadow.ImageColor3 = Themes[currentTheme].Shadow
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = OuterFrame
    OuterFrame.Parent = ScreenGui

    -- Inner Window
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(1, -10, 1, -10)
    Window.Position = UDim2.new(0, 5, 0, 5)
    Window.BackgroundColor3 = Themes[currentTheme].Window
    Window.BorderSizePixel = 0
    local InnerCorner = Instance.new("UICorner")
    InnerCorner.CornerRadius = UDim.new(0, 8)
    InnerCorner.Parent = Window
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Themes[currentTheme].Window), ColorSequenceKeypoint.new(1, Themes[currentTheme].Window:Lerp(Color3.fromRGB(50, 50, 50), 0.2))}
    Gradient.Parent = Window
    Window.Parent = OuterFrame

    -- Title Bar (Draggable area)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Themes[currentTheme].TitleBar
    TitleBar.BorderSizePixel = 0
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    TitleBar.Parent = Window

    -- Player Avatar
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 30, 0, 30)
    Avatar.Position = UDim2.new(0, 5, 0, 2)
    Avatar.BackgroundTransparency = 1
    Avatar.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 15)
    AvatarCorner.Parent = Avatar
    Avatar.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 1, 0)
    TitleLabel.Position = UDim2.new(0, 40, 0, 0)
    TitleLabel.Text = title or "Nini UI"
    TitleLabel.TextColor3 = Themes[currentTheme].Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    CloseButton.Parent = TitleBar

    -- Animation for opening
    TweenService:Create(OuterFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = savedPos
    }):Play()

    -- Close Button functionality
    local function CloseUI()
        TweenService:Create(OuterFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -windowWidth/2, 1, 0)
        }):Play()
        task.wait(0.5)
        ScreenGui:Destroy()
    end
    CloseButton.MouseButton1Click:Connect(CloseUI)

    -- Dragging with flexible bounds
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = OuterFrame.Position
            OuterFrame.ZIndex = 10
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = UserInputService:GetMouseLocation() - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            OuterFrame.Position = newPos
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            OuterFrame.ZIndex = 1
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local newPos = OuterFrame.Position
            local clampedX = math.clamp(newPos.X.Offset, -OuterFrame.Size.X.Offset + 50, viewportSize.X - 50)
            local clampedY = math.clamp(newPos.Y.Offset, -OuterFrame.Size.Y.Offset + 50, viewportSize.Y - 50)
            local finalPos = UDim2.new(0, clampedX, 0, clampedY)
            TweenService:Create(OuterFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = finalPos}):Play()
            savedPos = finalPos
            getgenv().NiniUISavedData = HttpService:JSONEncode({
                Position = finalPos,
                Size = OuterFrame.Size,
                Theme = currentTheme,
                LastTab = lastTab,
                Hotkeys = hotkeys
            })
        end
    end)

    -- Resize Button
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Size = UDim2.new(0, 20, 0, 20)
    ResizeButton.Position = UDim2.new(1, -25, 1, -25)
    ResizeButton.BackgroundColor3 = Themes[currentTheme].Stroke
    ResizeButton.Text = "↔"
    ResizeButton.TextColor3 = Themes[currentTheme].Text
    ResizeButton.Font = Enum.Font.SourceSans
    ResizeButton.TextSize = 14
    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 4)
    ResizeCorner.Parent = ResizeButton
    ResizeButton.Parent = OuterFrame

    local resizing, resizeStart, startSize
    ResizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = OuterFrame.Size
        end
    end)

    ResizeButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
            getgenv().NiniUISavedData = HttpService:JSONEncode({
                Position = OuterFrame.Position,
                Size = OuterFrame.Size,
                Theme = currentTheme,
                LastTab = lastTab,
                Hotkeys = hotkeys
            })
        end
    end)

    RunService.RenderStepped:Connect(function()
        if resizing then
            local delta = UserInputService:GetMouseLocation() - resizeStart
            local newWidth = math.max(300, startSize.X.Offset + delta.X)
            local newHeight = math.max(350, startSize.Y.Offset + delta.Y)
            OuterFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            windowWidth = newWidth
            windowHeight = newHeight
        end
    end)

    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 120, 1, -35)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = Themes[currentTheme].TabContainer
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Themes[currentTheme].Stroke
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Window

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -120, 1, -35)
    ContentContainer.Position = UDim2.new(0, 120, 0, 35)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Window

    local tabs = {}
    local currentTab = nil

    -- Function to create a new tab with slide animation
    local function CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.Text = tabName
        TabButton.BackgroundColor3 = Themes[currentTheme].Button
        TabButton.TextColor3 = Themes[currentTheme].Text
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Themes[currentTheme].Stroke
        TabStroke.Thickness = 1
        TabStroke.Parent = TabButton
        TabButton.Parent = TabContainer

        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local ContentListLayout = Instance.new("UIListLayout")
        ContentListLayout.Padding = UDim.new(0, 5)
        ContentListLayout.Parent = TabContent

        -- Hotkey customization for "Settings" tab
        if tabName == "Settings" then
            local function CreateHotkeySetter(name, key)
                local HotkeyFrame = Instance.new("Frame")
                HotkeyFrame.Size = UDim2.new(1, -10, 0, 35)
                HotkeyFrame.BackgroundTransparency = 1
                HotkeyFrame.Parent = TabContent

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.Text = name .. ":"
                Label.TextColor3 = Themes[currentTheme].Text
                Label.BackgroundTransparency = 1
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = HotkeyFrame

                local HotkeyButton = Instance.new("TextButton")
                HotkeyButton.Size = UDim2.new(0.4, 0, 1, 0)
                HotkeyButton.Position = UDim2.new(0.6, 0, 0, 0)
                HotkeyButton.BackgroundColor3 = Themes[currentTheme].Button
                HotkeyButton.Text = key.Name
                HotkeyButton.TextColor3 = Themes[currentTheme].Text
                HotkeyButton.Font = Enum.Font.Gotham
                HotkeyButton.TextSize = 14
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = HotkeyButton
                local Stroke = Instance.new("UIStroke")
                Stroke.Color = Themes[currentTheme].Stroke
                Stroke.Thickness = 1
                Stroke.Parent = HotkeyButton
                HotkeyButton.Parent = HotkeyFrame

                HotkeyButton.MouseButton1Click:Connect(function()
                    HotkeyButton.Text = "Press a key..."
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            hotkeys[name] = input.KeyCode
                            HotkeyButton.Text = input.KeyCode.Name
                            getgenv().NiniUISavedData = HttpService:JSONEncode({
                                Position = OuterFrame.Position,
                                Size = OuterFrame.Size,
                                Theme = currentTheme,
                                LastTab = lastTab,
                                Hotkeys = hotkeys
                            })
                            connection:Disconnect()
                        end
                    end)
                end)

                HotkeyButton.MouseEnter:Connect(function()
                    TweenService:Create(HotkeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
                end)
                HotkeyButton.MouseLeave:Connect(function()
                    TweenService:Create(HotkeyButton, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button}):Play()
                end)
            end

            CreateHotkeySetter("ToggleUI", hotkeys.ToggleUI)
            CreateHotkeySetter("ESP", hotkeys.ESP)
            CreateHotkeySetter("Aimbot", hotkeys.Aimbot)
        end

        TabButton.MouseEnter:Connect(function()
            if TabContent ~= currentTab then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, ugenix
                TabContent.BackgroundTransparency = 1
                TabContent.Visible = false
                TabContent.Parent = ContentContainer

        local ContentListLayout = Instance.new("UIListLayout")
        ContentListLayout.Padding = UDim.new(0, 5)
        ContentListLayout.Parent = TabContent

        TabButton.MouseEnter:Connect(function()
            if TabContent ~= currentTab then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.1)}):Play()
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if TabContent ~= currentTab then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button}):Play()
            end
        end)

        TabButton.MouseButton1Click:Connect(function()
            if currentTab ~= TabContent then
                if currentTab then
                    TweenService:Create(currentTab, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(-1, 0, 0, 5)}):Play()
                    task.wait(0.15)
                    currentTab.Visible = false
                    TweenService:Create(tabs[currentTab].Button, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button}):Play()
                end
                TabContent.Position = UDim2.new(1, 0, 0, 5)
                TabContent.Visible = true
                TweenService:Create(TabContent, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 5, 0, 5)}):Play()
                currentTab = TabContent
                lastTab = tabName
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
                getgenv().NiniUISavedData = HttpService:JSONEncode({
                    Position = OuterFrame.Position,
                    Size = OuterFrame.Size,
                    Theme = currentTheme,
                    LastTab = lastTab,
                    Hotkeys = hotkeys
                })
            end
        end)

        tabs[TabContent] = {Button = TabButton, Content = TabContent, Name = tabName}
        if not currentTab or (lastTab and lastTab == tabName) then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)
        end

        return TabContent
    end

    -- Dark/Light Mode Toggle
    local ThemeToggle = Instance.new("TextButton")
    ThemeToggle.Size = UDim2.new(0, 60, 0, 25)
    ThemeToggle.Position = UDim2.new(1, -95, 0, 5)
    ThemeToggle.BackgroundColor3 = Themes[currentTheme].Button
    ThemeToggle.Text = currentTheme
    ThemeToggle.TextColor3 = Themes[currentTheme].Text
    ThemeToggle.Font = Enum.Font.Gotham
    ThemeToggle.TextSize = 14
    local ThemeCorner = Instance.new("UICorner")
    ThemeCorner.CornerRadius = UDim.new(0, 6)
    ThemeCorner.Parent = ThemeToggle
    ThemeToggle.Parent = TitleBar

    local function UpdateTheme()
        OuterFrame.BackgroundColor3 = Themes[currentTheme].OuterFrame
        OuterStroke.Color = Themes[currentTheme].Stroke
        Shadow.ImageColor3 = Themes[currentTheme].Shadow
        Window.BackgroundColor3 = Themes[currentTheme].Window
        Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Themes[currentTheme].Window), ColorSequenceKeypoint.new(1, Themes[currentTheme].Window:Lerp(Color3.fromRGB(50, 50, 50), 0.2))}
        TitleBar.BackgroundColor3 = Themes[currentTheme].TitleBar
        TitleLabel.TextColor3 = Themes[currentTheme].Text
        TabContainer.BackgroundColor3 = Themes[currentTheme].TabContainer
        TabContainer.ScrollBarImageColor3 = Themes[currentTheme].Stroke
        ResizeButton.BackgroundColor3 = Themes[currentTheme].Stroke
        ResizeButton.TextColor3 = Themes[currentTheme].Text
        for _, tab in pairs(tabs) do
            tab.Button.BackgroundColor3 = (tab.Content == currentTab) and Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2) or Themes[currentTheme].Button
            tab.Button.TextColor3 = Themes[currentTheme].Text
            tab.Button:FindFirstChild("UIStroke").Color = Themes[currentTheme].Stroke
        end
    end

    ThemeToggle.MouseEnter:Connect(function()
        TweenService:Create(ThemeToggle, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
    end)
    ThemeToggle.MouseLeave:Connect(function()
        TweenService:Create(ThemeToggle, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button}):Play()
    end)
    ThemeToggle.MouseButton1Click:Connect(function()
        currentTheme = (currentTheme == "Dark") and "Light" or "Dark"
        ThemeToggle.Text = currentTheme
        UpdateTheme()
        getgenv().NiniUISavedData = HttpService:JSONEncode({
            Position = OuterFrame.Position,
            Size = OuterFrame.Size,
            Theme = currentTheme,
            LastTab = lastTab,
            Hotkeys = hotkeys
        })
    end)

    -- Toggle UI (RightShift and Mobile)
    local isVisible = true
    local function ToggleUI()
        isVisible = not isVisible
        if isVisible then
            TweenService:Create(OuterFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = savedPos,
                BackgroundTransparency = 0
            }):Play()
        else
            TweenService:Create(OuterFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0, savedPos.X.Offset, 1, 0),
                BackgroundTransparency = 1
            }):Play()
        end
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == hotkeys.ToggleUI then
            ToggleUI()
        elseif input.KeyCode == hotkeys.ESP then
            UILibrary:CreateNotification("ESP Toggled!", 2)
        elseif input.KeyCode == hotkeys.Aimbot then
            UILibrary:CreateNotification("Aimbot Toggled!", 2)
        end
    end)

    -- Mobile toggle button
    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Size = UDim2.new(0, 40, 0, 40)
    MobileToggle.Position = UDim2.new(0, 10, 0, 10)
    MobileToggle.BackgroundColor3 = Themes[currentTheme].Button
    MobileToggle.Text = "☰"
    MobileToggle.TextColor3 = Themes[currentTheme].Text
    MobileToggle.Font = Enum.Font.SourceSansBold
    MobileToggle.TextSize = 20
    local MobileCorner = Instance.new("UICorner")
    MobileCorner.CornerRadius = UDim.new(0, 10)
    MobileCorner.Parent = MobileToggle
    MobileToggle.Parent = ScreenGui
    MobileToggle.Visible = UserInputService.TouchEnabled

    MobileToggle.MouseEnter:Connect(function()
        TweenService:Create(MobileToggle, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
    end)
    MobileToggle.MouseLeave:Connect(function()
        TweenService:Create(MobileToggle, TweenInfo.new(0.2), {BackgroundColor3 = Themes[currentTheme].Button}):Play()
    end)
    MobileToggle.MouseButton1Click:Connect(ToggleUI)

    return { Window = Window, OuterFrame = OuterFrame, CreateTab = CreateTab }
end

-- Creates a button
function UILibrary:CreateButton(container, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Text = text or "Button"
    Button.BackgroundColor3 = Themes.Dark.Button
    Button.TextColor3 = Themes.Dark.Text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Themes.Dark.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = Button
    Button.Parent = container

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Themes.Dark.Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Themes.Dark.Button}):Play()
    end)

    Button.MouseButton1Click:Connect(callback or function() print("Button clicked!") end)
    return Button
end

-- Creates a notification with stacking
function UILibrary:CreateNotification(message, duration)
    local ScreenGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("NiniUI_Notification") or Instance.new("ScreenGui")
    ScreenGui.Name = "NiniUI_Notification"
    ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

    local existingNotifs = ScreenGui:GetChildren()
    local offsetY = 40 + (#existingNotifs * 55) -- Stack vertically

    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 200, 0, 50)
    Notification.Position = UDim2.new(1, -210, 0, offsetY)
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Notification.BorderSizePixel = 0
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Notification
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1
    Stroke.Parent = Notification
    Notification.Parent = ScreenGui

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -10, 1, -10)
    Text.Position = UDim2.new(0, 5, 0, 5)
    Text.Text = message or "Notification"
    Text.TextColor3 = Color3.fromRGB(180, 180, 180)
    Text.BackgroundTransparency = 1
    Text.TextSize = 14
    Text.Font = Enum.Font.Gotham
    Text.TextWrapped = true
    Text.Parent = Notification

    Notification.BackgroundTransparency = 1
    TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    task.wait(duration or 3)
    TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    Notification:Destroy()

    -- Adjust positions of remaining notifications
    for i, notif in ipairs(ScreenGui:GetChildren()) do
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -210, 0, 40 + ((i-1) * 55))}):Play()
    end
end

return UILibrary