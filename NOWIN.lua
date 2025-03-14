local NoWin = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local SavedSettings = {}
if getgenv then
    getgenv().NoWinSettings = getgenv().NoWinSettings or {}
    SavedSettings = getgenv().NoWinSettings
end

local function CreateElement(parent, class, props)
    local element = Instance.new(class)
    for prop, value in pairs(props) do
        element[prop] = value
    end
    element.Parent = parent
    return element
end

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://9120386436"
ClickSound.Volume = 0.5
ClickSound.Parent = game.SoundService

function NoWin.CreateLib(title, theme)
    local ScreenGui = CreateElement(game.CoreGui, "ScreenGui", {Name = "NoWin_" .. title, ResetOnSpawn = false})
    local LoadingScreen = CreateElement(ScreenGui, "Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1})
    local LoadingText = CreateElement(LoadingScreen, "TextLabel", {Size = UDim2.new(0, 200, 0, 50), Position = UDim2.new(0.5, -100, 0.5, -25), BackgroundTransparency = 1, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 30, Font = Enum.Font.GothamBold})
    TweenService:Create(LoadingScreen, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    wait(1)
    TweenService:Create(LoadingScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    wait(0.5)
    LoadingScreen:Destroy()

    local MainFrame = CreateElement(ScreenGui, "Frame", {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, -210, 0.5, -192.5), BackgroundColor3 = theme == "DarkTheme" and Color3.fromRGB(25, 25, 25) or Color3.fromRGB(220, 220, 220), BorderSizePixel = 0, BackgroundTransparency = 1, Rotation = -10})
    CreateElement(MainFrame, "UICorner", {CornerRadius = UDim.new(0, 12)})
    CreateElement(MainFrame, "UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme == "DarkTheme" and Color3.fromRGB(25, 25, 25) or Color3.fromRGB(220, 220, 220)), ColorSequenceKeypoint.new(1, theme == "DarkTheme" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(240, 240, 240))}), Rotation = 45})

    local TitleBar = CreateElement(MainFrame, "Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme == "DarkTheme" and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(200, 200, 200), BorderSizePixel = 0})
    CreateElement(TitleBar, "UICorner", {CornerRadius = UDim.new(0, 12)})
    CreateElement(TitleBar, "UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme == "DarkTheme" and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(200, 200, 200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 255))}), Rotation = 90})
    CreateElement(TitleBar, "TextLabel", {Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 20, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left})
    CreateElement(TitleBar, "TextLabel", {Size = UDim2.new(1, -10, 0, 15), Position = UDim2.new(0, 5, 0, 25), BackgroundTransparency = 1, Text = "by NoWin Team", TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left})

    local TabContainer = CreateElement(MainFrame, "Frame", {Size = UDim2.new(0, 100, 0, 345), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = theme == "DarkTheme" and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(210, 210, 210), BorderSizePixel = 0})
    CreateElement(TabContainer, "UICorner", {CornerRadius = UDim.new(0, 12)})

    local ContentFrame = CreateElement(MainFrame, "Frame", {Size = UDim2.new(0, 320, 0, 345), Position = UDim2.new(0, 100, 0, 40), BackgroundTransparency = 1})

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0, Size = UDim2.new(0, 420, 0, 385), Rotation = 0}):Play()

    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game.Lighting

    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = newPos}):Play()
        end
    end)
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local ResizeButton = CreateElement(MainFrame, "TextButton", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -20, 1, -20), BackgroundColor3 = Color3.fromRGB(0, 120, 255), Text = ""})
    CreateElement(ResizeButton, "UICorner", {CornerRadius = UDim.new(0, 5)})
    local resizing, resizeStart, startSize
    ResizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X.Offset + delta.X, 300, 800)
            local\nHeight = math.clamp(startSize.Y.Offset + delta.Y, 400, 1000)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            TabContainer.Size = UDim2.new(0, 100, 0, newHeight - 40)
            ContentFrame.Size = UDim2.new(0, newWidth - 100, 0, newHeight - 40)
        end
    end)
    ResizeButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    local ToggleButton = CreateElement(ScreenGui, "TextButton", {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = Color3.fromRGB(0, 120, 255), Text = "UI", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 20, Font = Enum.Font.GothamBold, BorderSizePixel = 0})
    CreateElement(ToggleButton, "UICorner", {CornerRadius = UDim.new(0, 30)})
    local ToggleGlow = CreateElement(ToggleButton, "UIStroke", {Thickness = 3, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.5})
    CreateElement(ToggleButton, "UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))}), Rotation = 45})

    local hotkey = SavedSettings.Hotkey or Enum.KeyCode.F
    local uiVisible = true
    local function toggleUI()
        uiVisible = not uiVisible
        ClickSound:Play()
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = uiVisible and UDim2.new(0, MainFrame.Size.X.Offset, 0, MainFrame.Size.Y.Offset) or UDim2.new(0, 0, 0, 0), BackgroundTransparency = uiVisible and 0 or 1})
        tween:Play()
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = uiVisible and 20 or 0}):Play()
        ToggleButton.Text = uiVisible and "UI" or "►"
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = uiVisible and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == hotkey then toggleUI() end
    end)
    ToggleButton.MouseButton1Click:Connect(toggleUI)
    ToggleButton.MouseEnter:Connect(function() TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    ToggleButton.MouseLeave:Connect(function() TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {Transparency = 0.5}):Play() end)
    ToggleButton.MouseButton1Down:Connect(function() TweenService:Create(ToggleButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 55, 0, 55)}):Play() end)
    ToggleButton.MouseButton1Up:Connect(function() TweenService:Create(ToggleButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play() end)

    local Window = {Size = UDim2.new(0, 420, 0, 385), Frame = MainFrame, TabContainer = TabContainer, ContentFrame = ContentFrame, Tabs = {}, CurrentTab = nil, YOffset = 10}
    function Window:NewTab(tabName)
        local TabButton = CreateElement(self.TabContainer, "TextButton", {Size = UDim2.new(0, 90, 0, 40), Position = UDim2.new(0, 5, 0, self.YOffset), BackgroundColor3 = theme == "DarkTheme" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(230, 230, 230), Text = tabName, TextColor3 = theme == "DarkTheme" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(0, 0, 0), TextSize = 14, Font = Enum.Font.Gotham})
        CreateElement(TabButton, "UICorner", {CornerRadius = UDim.new(0, 8)})
        local TabContent = CreateElement(self.ContentFrame, "Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false})

        TabButton.MouseButton1Click:Connect(function()
            ClickSound:Play()
            if self.CurrentTab then
                TweenService:Create(self.CurrentTab.Content, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                self.CurrentTab.Content.Visible = false
                self.CurrentTab.Button.BackgroundColor3 = theme == "DarkTheme" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(230, 230, 230)
            end
            TabContent.Visible = true
            TweenService:Create(TabContent, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            self.CurrentTab = {Button = TabButton, Content = TabContent}
        end)

        self.Tabs[tabName] = {Button = TabButton, Content = TabContent, YOffset = 10}
        self.YOffset = self.YOffset + 50
        if not self.CurrentTab then
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            TabContent.Visible = true
            TweenService:Create(TabContent, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            self.CurrentTab = {Button = TabButton, Content = TabContent}
        end
        function self.Tabs[tabName]:NewSection(sectionName)
            local SectionFrame = CreateElement(self.Content, "Frame", {Size = UDim2.new(0, 280, 0, 30), Position = UDim2.new(0, 10, 0, self.YOffset), BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
            CreateElement(SectionFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
            CreateElement(SectionFrame, "TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = sectionName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, Font = Enum.Font.GothamBold})
            self.YOffset = self.YOffset + 40
            return {Content = self.Content, YOffset = self.YOffset}
        end
        return self.Tabs[tabName]
    end
    NoWin.Window = Window
    return Window
end

local function CreateTooltip(parent, text)
    local Tooltip = CreateElement(parent, "Frame", {Size = UDim2.new(0, 100, 0, 20), Position = UDim2.new(0, 0, 1, 5), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Visible = false})
    CreateElement(Tooltip, "UICorner", {CornerRadius = UDim.new(0, 5)})
    CreateElement(Tooltip, "TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.Gotham})
    parent.MouseEnter:Connect(function() Tooltip.Visible = true end)
    parent.MouseLeave:Connect(function() Tooltip.Visible = false end)
end

function NoWin:CreateButton(tab, text, tooltip, callback)
    local Button = CreateElement(tab.Content, "TextButton", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45), Text = text, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham})
    CreateElement(Button, "UICorner", {CornerRadius = UDim.new(0, 8)})
    if tooltip then CreateTooltip(Button, tooltip) end
    local Glow = CreateElement(Button, "UIStroke", {Thickness = 2, Color = Color3.fromRGB(0, 120, 255), Transparency = 1})
    Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 1}):Play() end)
    Button.MouseButton1Down:Connect(function() TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 270, 0, 38)}):Play() end)
    Button.MouseButton1Up:Connect(function() ClickSound:Play() TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 280, 0, 40)}):Play() callback() NoWin:Notify(text .. " Activated!", 2) end)
    tab.YOffset = tab.YOffset + 50
end

function NoWin:CreateToggle(tab, text, tooltip, default, callback)
    local ToggleFrame = CreateElement(tab.Content, "Frame", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    CreateElement(ToggleFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    CreateElement(ToggleFrame, "TextLabel", {Size = UDim2.new(0, 200, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left})
    if tooltip then CreateTooltip(ToggleFrame, tooltip) end
    local ToggleButton = CreateElement(ToggleFrame, "TextButton", {Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -70, 0.5, -12.5), BackgroundColor3 = SavedSettings[text] or default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0), Text = SavedSettings[text] or default and "ON" or "OFF", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBold})
    CreateElement(ToggleButton, "UICorner", {CornerRadius = UDim.new(0, 6)})
    local Glow = CreateElement(ToggleButton, "UIStroke", {Thickness = 2, Color = Color3.fromRGB(0, 120, 255), Transparency = 1})
    local state = SavedSettings[text] or default
    ToggleButton.MouseEnter:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    ToggleButton.MouseLeave:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 1}):Play() end)
    ToggleButton.MouseButton1Click:Connect(function()
        ClickSound:Play()
        state = not state
        ToggleButton.Text = state and "ON" or "OFF"
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)}):Play()
        SavedSettings[text] = state
        if getgenv then getgenv().NoWinSettings = SavedSettings end
        callback(state)
        NoWin:Notify(text .. " " .. (state and "Enabled!" or "Disabled!"), 2)
    end)
    tab.YOffset = tab.YOffset + 50
end

function NoWin:CreateSlider(tab, text, tooltip, min, max, default, callback)
    local SliderFrame = CreateElement(tab.Content, "Frame", {Size = UDim2.new(0, 280, 0, 60), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    CreateElement(SliderFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    local SliderLabel = CreateElement(SliderFrame, "TextLabel", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text .. ": " .. (SavedSettings[text] or default), TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham})
    if tooltip then CreateTooltip(SliderFrame, tooltip) end
    local SliderBar = CreateElement(SliderFrame, "Frame", {Size = UDim2.new(0, 260, 0, 10), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
    CreateElement(SliderBar, "UICorner", {CornerRadius = UDim.new(0, 5)})
    local SliderFill = CreateElement(SliderBar, "Frame", {Size = UDim2.new((SavedSettings[text] or default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 120, 255)})
    CreateElement(SliderFill, "UICorner", {CornerRadius = UDim.new(0, 5)})
    local SliderHandle = CreateElement(SliderFill, "Frame", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0})
    CreateElement(SliderHandle, "UICorner", {CornerRadius = UDim.new(0, 10)})
    local dragging = false
    SliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            ClickSound:Play()
        end
    end)
    SliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X - SliderBar.AbsolutePosition.X
            local percent = math.clamp(mouseX / SliderBar.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
            SliderLabel.Text = text .. ": " .. math.floor(value)
            SavedSettings[text] = math.floor(value)
            if getgenv then getgenv().NoWinSettings = SavedSettings end
            callback(math.floor(value))
        end
    end)
    tab.YOffset = tab.YOffset + 70
end

function NoWin:CreateDropdown(tab, text, tooltip, options, callback)
    local DropdownFrame = CreateElement(tab.Content, "Frame", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    CreateElement(DropdownFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    local DropdownButton = CreateElement(DropdownFrame, "TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text .. ": " .. options[1], TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham})
    if tooltip then CreateTooltip(DropdownFrame, tooltip) end
    local DropdownList = CreateElement(DropdownFrame, "Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Visible = false, ClipsDescendants = true})
    CreateElement(DropdownList, "UICorner", {CornerRadius = UDim.new(0, 8)})
    local isOpen = false
    DropdownButton.MouseButton1Click:Connect(function()
        ClickSound:Play()
        isOpen = not isOpen
        TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = isOpen and UDim2.new(1, 0, 0, #options * 30) or UDim2.new(1, 0, 0, 0)}):Play()
        DropdownList.Visible = true
    end)
    for i, option in pairs(options) do
        local OptionButton = CreateElement(DropdownList, "TextButton", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, (i - 1) * 30), BackgroundTransparency = 1, Text = option, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 14, Font = Enum.Font.Gotham})
        OptionButton.MouseButton1Click:Connect(function()
            ClickSound:Play()
            DropdownButton.Text = text .. ": " .. option
            isOpen = false
            TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.3)
            DropdownList.Visible = false
            callback(option)
        end)
    end
    tab.YOffset = tab.YOffset + 50
end

function NoWin:CreateColorPicker(tab, text, tooltip, default, callback)
    local ColorFrame = CreateElement(tab.Content, "Frame", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    CreateElement(ColorFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    CreateElement(ColorFrame, "TextLabel", {Size = UDim2.new(0, 200, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left})
    if tooltip then CreateTooltip(ColorFrame, tooltip) end
    local ColorButton = CreateElement(ColorFrame, "TextButton", {Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -70, 0.5, -12.5), BackgroundColor3 = SavedSettings[text] or default})
    CreateElement(ColorButton, "UICorner", {CornerRadius = UDim.new(0, 6)})
    local Glow = CreateElement(ColorButton, "UIStroke", {Thickness = 2, Color = Color3.fromRGB(0, 120, 255), Transparency = 1})
    ColorButton.MouseEnter:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    ColorButton.MouseLeave:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 1}):Play() end)
    ColorButton.MouseButton1Click:Connect(function()
        ClickSound:Play()
        local r = tonumber(NoWin:Prompt("Enter R (0-255):", "255")) or 255
        local g = tonumber(NoWin:Prompt("Enter G (0-255):", "255")) or 255
        local b = tonumber(NoWin:Prompt("Enter B (0-255):", "255")) or 255
        local color = Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
        ColorButton.BackgroundColor3 = color
        SavedSettings[text] = color
        if getgenv then getgenv().NoWinSettings = SavedSettings end
        callback(color)
        NoWin:Notify("Color Set: " .. r .. "," .. g .. "," .. b, 2)
    end)
    tab.YOffset = tab.YOffset + 50
end

function NoWin:CreateKeybind(tab, text, tooltip, default, callback)
    local KeybindFrame = CreateElement(tab.Content, "Frame", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    CreateElement(KeybindFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    CreateElement(KeybindFrame, "TextLabel", {Size = UDim2.new(0, 200, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left})
    if tooltip then CreateTooltip(KeybindFrame, tooltip) end
    local KeybindButton = CreateElement(KeybindFrame, "TextButton", {Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -70, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(60, 60, 60), Text = SavedSettings[text] and SavedSettings[text].Name or default.Name, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBold})
    CreateElement(KeybindButton, "UICorner", {CornerRadius = UDim.new(0, 6)})
    local Glow = CreateElement(KeybindButton, "UIStroke", {Thickness = 2, Color = Color3.fromRGB(0, 120, 255), Transparency = 1})
    local key = SavedSettings[text] or default
    KeybindButton.MouseEnter:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    KeybindButton.MouseLeave:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 1}):Play() end)
    KeybindButton.MouseButton1Click:Connect(function()
        ClickSound:Play()
        KeybindButton.Text = "Press a key..."
        local input = UserInputService.InputBegan:Wait()
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            key = input.KeyCode
            KeybindButton.Text = key.Name
            SavedSettings[text] = key
            if getgenv then getgenv().NoWinSettings = SavedSettings end
            NoWin:Notify("Keybind Set: " .. key.Name, 2)
        end
    end)
    UserInputService.InputBegan:Connect(function(input) if input.KeyCode == key then callback() end end)
    tab.YOffset = tab.YOffset + 50
end

function NoWin:CreateTextbox(tab, text, tooltip, default, callback)
    local TextboxFrame = CreateElement(tab.Content, "Frame", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0, 10, 0, tab.YOffset), BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    CreateElement(TextboxFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    CreateElement(TextboxFrame, "TextLabel", {Size = UDim2.new(0, 200, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 16, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left})
    if tooltip then CreateTooltip(TextboxFrame, tooltip) end
    local Textbox = CreateElement(TextboxFrame, "TextBox", {Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -70, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(60, 60, 60), Text = SavedSettings[text] or default, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.Gotham})
    CreateElement(Textbox, "UICorner", {CornerRadius = UDim.new(0, 6)})
    local Glow = CreateElement(Textbox, "UIStroke", {Thickness = 2, Color = Color3.fromRGB(0, 120, 255), Transparency = 1})
    Textbox.MouseEnter:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    Textbox.MouseLeave:Connect(function() TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = 1}):Play() end)
    Textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ClickSound:Play()
            SavedSettings[text] = Textbox.Text
            if getgenv then getgenv().NoWinSettings = SavedSettings end
            callback(Textbox.Text)
            NoWin:Notify(text .. " set to: " .. Textbox.Text, 2)
        end
    end)
    tab.YOffset = tab.YOffset + 50
end

function NoWin:Notify(message, duration)
    if not NoWin.Window then
        warn("NoWin Window not initialized!")
        return
    end
    local NotifyFrame = CreateElement(NoWin.Window.Frame, "Frame", {Size = UDim2.new(0, 200, 0, 50), Position = UDim2.new(0.5, -100, 0, -50), BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
    CreateElement(NotifyFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    CreateElement(NotifyFrame, "TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = message, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.Gotham})
    TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0, 10)}):Play()
    wait(0.3)
    TweenService:Create(NotifyFrame, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5, -100, 0, 15)}):Play()
    wait(duration)
    TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0, -50)}):Play()
    wait(0.3)
    NotifyFrame:Destroy()
end

function NoWin:Prompt(promptText, default)
    if not NoWin.Window then
        warn("NoWin Window not initialized!")
        return default
    end
    local PromptFrame = CreateElement(NoWin.Window.Frame.Parent, "Frame", {Size = UDim2.new(0, 200, 0, 100), Position = UDim2.new(0.5, -100, 0.5, -50), BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
    CreateElement(PromptFrame, "UICorner", {CornerRadius = UDim.new(0, 8)})
    CreateElement(PromptFrame, "TextLabel", {Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 5), BackgroundTransparency = 1, Text = promptText, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, Font = Enum.Font.Gotham})
    local Input = CreateElement(PromptFrame, "TextBox", {Size = UDim2.new(0, 180, 0, 30), Position = UDim2.new(0, 10, 0, 30), BackgroundColor3 = Color3.fromRGB(45, 45, 45), Text = default, TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 14, Font = Enum.Font.Gotham})
    CreateElement(Input, "UICorner", {CornerRadius = UDim.new(0, 6)})
    local value = default
    Input.FocusLost:Connect(function(enterPressed) if enterPressed then value = Input.Text PromptFrame:Destroy() end end)
    wait(5)
    if PromptFrame.Parent then PromptFrame:Destroy() end
    return value
end

return NoWin