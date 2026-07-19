-- // Profesional UI Library
-- // Theme: Black & Cyan
local Library = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- // Default Asset IDs (Sudah terpasang di dalam UI)
local Assets = {
    Background = "rbxassetid://13112891398", 
    Logo = "rbxassetid://6031091004",
    FloatingIcon = "rbxassetid://6031091004"
}

-- // Color Config
local Colors = {
    MainBlack = Color3.fromRGB(15, 15, 15),
    SecondBlack = Color3.fromRGB(25, 25, 25),
    Cyan = Color3.fromRGB(0, 255, 255),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(150, 150, 150)
}

-- // Utilities
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(Config)
    local HubName = Config.Name or "Hub Name"
    local Description = Config.Description or "Hub Description"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ProfesionalUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer.PlayerGui) or CoreGui

        -- // Loading Frame
    local LoadFrame = Instance.new("Frame")
    LoadFrame.Name = "LoadFrame"
    LoadFrame.Parent = ScreenGui
    LoadFrame.BackgroundColor3 = Colors.MainBlack
    LoadFrame.BorderSizePixel = 0
    LoadFrame.Position = UDim2.new(0.5, -200, 0.5, -30)
    LoadFrame.Size = UDim2.new(0, 400, 0, 60)
    Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 8)

    local LoadLogo = Instance.new("ImageLabel", LoadFrame)
    LoadLogo.BackgroundTransparency = 1
    LoadLogo.Position = UDim2.new(0, 10, 0, 10)
    LoadLogo.Size = UDim2.new(0, 40, 0, 40)
    LoadLogo.Image = Assets.Logo

    local LoadHubName = Instance.new("TextLabel", LoadFrame)
    LoadHubName.BackgroundTransparency = 1
    LoadHubName.Position = UDim2.new(0, 60, 0, 10)
    LoadHubName.Size = UDim2.new(0, 200, 0, 20)
    LoadHubName.Font = Enum.Font.GothamBold
    LoadHubName.Text = HubName
    LoadHubName.TextColor3 = Colors.Cyan
    LoadHubName.TextSize = 16
    LoadHubName.TextXAlignment = Enum.TextXAlignment.Left

    local LoadDesc = Instance.new("TextLabel", LoadFrame)
    LoadDesc.BackgroundTransparency = 1
    LoadDesc.Position = UDim2.new(0, 60, 0, 30)
    LoadDesc.Size = UDim2.new(0, 200, 0, 15)
    LoadDesc.Font = Enum.Font.Gotham
    LoadDesc.Text = Description
    LoadDesc.TextColor3 = Colors.Gray
    LoadDesc.TextSize = 12
    LoadDesc.TextXAlignment = Enum.TextXAlignment.Left

    local LoadPercent = Instance.new("TextLabel", LoadFrame)
    LoadPercent.BackgroundTransparency = 1
    LoadPercent.Position = UDim2.new(1, -60, 0, 20)
    LoadPercent.Size = UDim2.new(0, 50, 0, 20)
    LoadPercent.Font = Enum.Font.GothamBold
    LoadPercent.Text = "0%"
    LoadPercent.TextColor3 = Colors.Cyan
    LoadPercent.TextSize = 18

    -- // Loading Logic
    MainFrame.Visible = false
    for i = 0, 100, 10 do
        LoadPercent.Text = i .. "%"
        task.wait(0.2)
    end
    LoadFrame:Destroy()
    MainFrame.Visible = true

    -- // Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.MainBlack
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 6)

    -- // Background Image (Asset ID)
    local BgImage = Instance.new("ImageLabel")
    BgImage.Parent = MainFrame
    BgImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BgImage.BackgroundTransparency = 1.000
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.Image = Assets.Background
    BgImage.ImageTransparency = 0.8
    BgImage.ScaleType = Enum.ScaleType.Crop

    -- // Floating Icon (Kotak, Gak Lancip, No Outline)
    local FloatingIcon = Instance.new("ImageButton")
    FloatingIcon.Name = "FloatingIcon"
    FloatingIcon.Parent = ScreenGui
    FloatingIcon.BackgroundColor3 = Colors.MainBlack
    FloatingIcon.BorderSizePixel = 0
    FloatingIcon.Position = UDim2.new(0, 50, 0, 50)
    FloatingIcon.Size = UDim2.new(0, 45, 0, 45)
    FloatingIcon.Image = Assets.FloatingIcon
    FloatingIcon.Visible = false
    MakeDraggable(FloatingIcon, FloatingIcon)

    -- // Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Colors.SecondBlack
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 50)
    MakeDraggable(Header, MainFrame)
    
    local Logo = Instance.new("ImageLabel")
    Logo.Parent = Header
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Image = Assets.Logo
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 60, 0, 5)
    Title.Size = UDim2.new(0, 200, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = HubName
    Title.TextColor3 = Colors.Cyan
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local DescText = Instance.new("TextLabel")
    DescText.Parent = Header
    DescText.BackgroundTransparency = 1
    DescText.Position = UDim2.new(0, 60, 0, 25)
    DescText.Size = UDim2.new(0, 200, 0, 15)
    DescText.Font = Enum.Font.Gotham
    DescText.Text = Description
    DescText.TextColor3 = Colors.Gray
    DescText.TextSize = 12
    DescText.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Parent = Header
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Colors.White
    MinimizeBtn.TextSize = 20

    -- Minimize Logic
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        FloatingIcon.Visible = true
    end)
    FloatingIcon.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        FloatingIcon.Visible = false
    end)

    -- // Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Colors.SecondBlack
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 130, 1, -50)

    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 5)

    local SidebarPadding = Instance.new("UIPadding", Sidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 5)

    -- // Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Container.BackgroundTransparency = 1.000
    Container.Position = UDim2.new(0, 135, 0, 55)
    Container.Size = UDim2.new(1, -140, 1, -60)

    -- // Notification System
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotifFrame"
    NotifFrame.Parent = ScreenGui
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.Position = UDim2.new(1, -220, 1, -150)
    NotifFrame.Size = UDim2.new(0, 200, 0, 400)
    
    local NotifList = Instance.new("UIListLayout", NotifFrame)
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.Padding = UDim.new(0, 10)
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom

    function Library:Notify(title, text, duration)
        duration = duration or 3
        local Note = Instance.new("Frame", NotifFrame)
        Note.BackgroundColor3 = Colors.SecondBlack
        Note.Size = UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", Note).CornerRadius = UDim.new(0, 6)
        
        local NoteTitle = Instance.new("TextLabel", Note)
        NoteTitle.BackgroundTransparency = 1
        NoteTitle.Position = UDim2.new(0, 10, 0, 5)
        NoteTitle.Size = UDim2.new(1, -20, 0, 20)
        NoteTitle.Font = Enum.Font.GothamBold
        NoteTitle.Text = title
        NoteTitle.TextColor3 = Colors.Cyan
        NoteTitle.TextSize = 14
        NoteTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local NoteText = Instance.new("TextLabel", Note)
        NoteText.BackgroundTransparency = 1
        NoteText.Position = UDim2.new(0, 10, 0, 25)
        NoteText.Size = UDim2.new(1, -20, 0, 30)
        NoteText.Font = Enum.Font.Gotham
        NoteText.Text = text
        NoteText.TextColor3 = Colors.White
        NoteText.TextSize = 12
        NoteText.TextXAlignment = Enum.TextXAlignment.Left
        NoteText.TextWrapped = true

        Note.Position = UDim2.new(1, 50, 0, 0)
        TweenService:Create(Note, TweenInfo.new(0.5), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.delay(duration, function()
            TweenService:Create(Note, TweenInfo.new(0.5), {Position = UDim2.new(1, 50, 0, 0)}):Play()
            task.wait(0.5)
            Note:Destroy()
        end)
    end

    local Window = {}
    local FirstTab = true

    function Window:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = TabName.."_Btn"
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Colors.Cyan
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 120, 0, 30)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Colors.Gray
        TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabName.."_Content"
        TabContent.Parent = Container
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.Visible = false
        
        local ContentList = Instance.new("UIListLayout", TabContent)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        
        local ContentPadding = Instance.new("UIPadding", TabContent)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingTop = UDim.new(0, 5)

        if FirstTab then
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = Colors.Cyan
            TabContent.Visible = true
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Colors.Gray}):Play()
                end
            end
            for _, v in pairs(Container:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Colors.Cyan}):Play()
            TabContent.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(BtnText, Callback)
            local Button = Instance.new("TextButton")
            Button.Parent = TabContent
            Button.BackgroundColor3 = Colors.SecondBlack
            Button.Size = UDim2.new(1, -15, 0, 35)
            Button.Font = Enum.Font.GothamBold
            Button.Text = "  " .. BtnText
            Button.TextColor3 = Colors.White
            Button.TextSize = 14
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Cyan}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Colors.SecondBlack}):Play()
                pcall(Callback)
            end)
        end

        function Elements:CreateToggle(TogText, Default, Callback)
            local State = Default
            local ToggleFrame = Instance.new("Frame", TabContent)
            ToggleFrame.BackgroundColor3 = Colors.SecondBlack
            ToggleFrame.Size = UDim2.new(1, -15, 0, 35)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", ToggleFrame)
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Font = Enum.Font.GothamBold
            Label.Text = TogText
            Label.TextColor3 = Colors.White
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleBtn = Instance.new("TextButton", ToggleFrame)
            ToggleBtn.BackgroundColor3 = State and Colors.Cyan or Colors.MainBlack
            ToggleBtn.Position = UDim2.new(1, -40, 0.5, -10)
            ToggleBtn.Size = UDim2.new(0, 30, 0, 20)
            ToggleBtn.Text = ""
            Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)

            if State then pcall(Callback, State) end

            ToggleBtn.MouseButton1Click:Connect(function()
                State = not State
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = State and Colors.Cyan or Colors.MainBlack}):Play()
                pcall(Callback, State)
            end)
        end

        function Elements:CreateSlider(SlidText, Min, Max, Default, Callback)
            local SliderFrame = Instance.new("Frame", TabContent)
            SliderFrame.BackgroundColor3 = Colors.SecondBlack
            SliderFrame.Size = UDim2.new(1, -15, 0, 50)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Font = Enum.Font.GothamBold
            Label.Text = SlidText .. " : " .. tostring(Default)
            Label.TextColor3 = Colors.White
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local SlideBar = Instance.new("Frame", SliderFrame)
            SlideBar.BackgroundColor3 = Colors.MainBlack
            SlideBar.Position = UDim2.new(0, 10, 0, 30)
            SlideBar.Size = UDim2.new(1, -20, 0, 10)
            Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", SlideBar)
            Fill.BackgroundColor3 = Colors.Cyan
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local SlideBtn = Instance.new("TextButton", SlideBar)
            SlideBtn.BackgroundTransparency = 1
            SlideBtn.Size = UDim2.new(1, 0, 1, 0)
            SlideBtn.Text = ""

            local Dragging = false
            SlideBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local SizeScale = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(SizeScale, 0, 1, 0)
                    local Value = math.floor(Min + ((Max - Min) * SizeScale))
                    Label.Text = SlidText .. " : " .. tostring(Value)
                    pcall(Callback, Value)
                end
            end)
        end

        return Elements
    end

    return Window
end

return Library
