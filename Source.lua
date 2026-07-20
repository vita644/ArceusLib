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
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer.PlayerGui) or CoreGui

    -- // ============ LOADING FRAME ============
    -- // Bar panjang kiri-kanan, pendek atas-bawah. Kiri: Logo + HubName + Description.
    -- // Kanan atas: Loading Number %. MainFrame baru muncul setelah 100%.
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Colors.MainBlack
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingFrame.Size = UDim2.new(0, 500, 0, 70)
    LoadingFrame.ClipsDescendants = true
    LoadingFrame.ZIndex = 10

    local LoadingCorner = Instance.new("UICorner", LoadingFrame)
    LoadingCorner.CornerRadius = UDim.new(0, 10)

    local LoadingStroke = Instance.new("UIStroke", LoadingFrame)
    LoadingStroke.Color = Colors.Cyan
    LoadingStroke.Transparency = 0.7
    LoadingStroke.Thickness = 1

    -- // Logo (kiri)
    local LoadLogo = Instance.new("ImageLabel")
    LoadLogo.Parent = LoadingFrame
    LoadLogo.BackgroundTransparency = 1
    LoadLogo.Position = UDim2.new(0, 12, 0.5, -20)
    LoadLogo.Size = UDim2.new(0, 40, 0, 40)
    LoadLogo.Image = Assets.Logo
    LoadLogo.ZIndex = 11

    -- // HubName (kiri, sebelah logo)
    local LoadTitle = Instance.new("TextLabel")
    LoadTitle.Parent = LoadingFrame
    LoadTitle.BackgroundTransparency = 1
    LoadTitle.Position = UDim2.new(0, 62, 0, 15)
    LoadTitle.Size = UDim2.new(0, 260, 0, 20)
    LoadTitle.Font = Enum.Font.GothamBold
    LoadTitle.Text = HubName
    LoadTitle.TextColor3 = Colors.Cyan
    LoadTitle.TextSize = 16
    LoadTitle.TextXAlignment = Enum.TextXAlignment.Left
    LoadTitle.ZIndex = 11

    -- // Description (kiri, di bawah HubName)
    local LoadDesc = Instance.new("TextLabel")
    LoadDesc.Parent = LoadingFrame
    LoadDesc.BackgroundTransparency = 1
    LoadDesc.Position = UDim2.new(0, 62, 0, 35)
    LoadDesc.Size = UDim2.new(0, 260, 0, 15)
    LoadDesc.Font = Enum.Font.Gotham
    LoadDesc.Text = Description
    LoadDesc.TextColor3 = Colors.Gray
    LoadDesc.TextSize = 12
    LoadDesc.TextXAlignment = Enum.TextXAlignment.Left
    LoadDesc.ZIndex = 11

    -- // Loading Number % (kanan atas)
    local LoadPercent = Instance.new("TextLabel")
    LoadPercent.Parent = LoadingFrame
    LoadPercent.BackgroundTransparency = 1
    LoadPercent.Position = UDim2.new(1, -80, 0, 10)
    LoadPercent.Size = UDim2.new(0, 65, 0, 20)
    LoadPercent.Font = Enum.Font.GothamBold
    LoadPercent.Text = "0%"
    LoadPercent.TextColor3 = Colors.Cyan
    LoadPercent.TextSize = 16
    LoadPercent.TextXAlignment = Enum.TextXAlignment.Right
    LoadPercent.ZIndex = 11

    -- // Progress bar tipis di bawah, dari 0 sampai 100%
    local LoadBarBG = Instance.new("Frame")
    LoadBarBG.Parent = LoadingFrame
    LoadBarBG.BackgroundColor3 = Colors.SecondBlack
    LoadBarBG.BorderSizePixel = 0
    LoadBarBG.Position = UDim2.new(0, 0, 1, -4)
    LoadBarBG.Size = UDim2.new(1, 0, 0, 4)
    LoadBarBG.ZIndex = 11

    local LoadBarFill = Instance.new("Frame")
    LoadBarFill.Parent = LoadBarBG
    LoadBarFill.BackgroundColor3 = Colors.Cyan
    LoadBarFill.BorderSizePixel = 0
    LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadBarFill.ZIndex = 12
    
-- // Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.MainBlack
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false -- // Baru muncul setelah loading selesai

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10) -- // Melengkung sedikit

    -- // Background Image (Asset ID)
    local BgImage = Instance.new("ImageLabel")
    BgImage.Parent = MainFrame
    BgImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BgImage.BackgroundTransparency = 1.000
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.Image = Assets.Background
    BgImage.ImageTransparency = 0.8
    BgImage.ScaleType = Enum.ScaleType.Crop

    -- // Floating Icon (Melengkung, gak lancip, no outline)
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

    local FloatingCorner = Instance.new("UICorner", FloatingIcon)
    FloatingCorner.CornerRadius = UDim.new(0, 12) -- // Rounded, bukan kotak lancip, bukan bulat penuh

    -- // Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Colors.SecondBlack
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 50)
    MakeDraggable(Header, MainFrame)

    local HeaderCorner = Instance.new("UICorner", Header)
    HeaderCorner.CornerRadius = UDim.new(0, 10)

    -- // Patch supaya bagian bawah Header gak ikut melengkung (nutup sudut MainFrame)
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Parent = Header
    HeaderFix.BackgroundColor3 = Colors.SecondBlack
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 1, -10)
    HeaderFix.Size = UDim2.new(1, 0, 0, 10)
    HeaderFix.ZIndex = Header.ZIndex
    
    local Logo = Instance.new("ImageLabel")
    Logo.Parent = Header
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Image = Assets.Logo
    Logo.ZIndex = 2
    
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
    Title.ZIndex = 2

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
    DescText.ZIndex = 2

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Parent = Header
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Colors.White
    MinimizeBtn.TextSize = 20
    MinimizeBtn.ZIndex = 2

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

    -- // ============ NOTIFICATION SYSTEM (FIXED) ============
    -- // Sekarang muncul di setengah-atas kanan layar, bukan mepet bawah terus.
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotifFrame"
    NotifFrame.Parent = ScreenGui
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.AnchorPoint = Vector2.new(1, 0)
    NotifFrame.Position = UDim2.new(1, -20, 0, 90) -- // Kanan atas, di bawah sedikit dari pojok atas
    NotifFrame.Size = UDim2.new(0, 220, 0, 500)
    NotifFrame.ClipsDescendants = false
    NotifFrame.ZIndex = 20

    local NotifList = Instance.new("UIListLayout", NotifFrame)
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.Padding = UDim.new(0, 10)
    NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Top -- // Stack dari atas ke bawah

    function Library:Notify(title, text, duration)
        duration = duration or 3

        -- // Wrapper supaya animasi slide gak bentrok sama UIListLayout
        local NoteWrap = Instance.new("Frame")
        NoteWrap.Parent = NotifFrame
        NoteWrap.BackgroundTransparency = 1
        NoteWrap.Size = UDim2.new(1, 0, 0, 60)
        NoteWrap.ClipsDescendants = true
        NoteWrap.ZIndex = 20

        local Note = Instance.new("Frame")
        Note.Parent = NoteWrap
        Note.BackgroundColor3 = Colors.SecondBlack
        Note.BorderSizePixel = 0
        Note.AnchorPoint = Vector2.new(0, 0)
        Note.Position = UDim2.new(1.3, 0, 0, 0) -- // Mulai dari luar sisi kanan
        Note.Size = UDim2.new(1, 0, 1, 0)
        Note.ZIndex = 21
        Instance.new("UICorner", Note).CornerRadius = UDim.new(0, 8)

        local NoteStroke = Instance.new("UIStroke", Note)
        NoteStroke.Color = Colors.Cyan
        NoteStroke.Transparency = 0.75
        NoteStroke.Thickness = 1
        
        local NoteTitle = Instance.new("TextLabel", Note)
        NoteTitle.BackgroundTransparency = 1
        NoteTitle.Position = UDim2.new(0, 10, 0, 5)
        NoteTitle.Size = UDim2.new(1, -20, 0, 20)
        NoteTitle.Font = Enum.Font.GothamBold
        NoteTitle.Text = title
        NoteTitle.TextColor3 = Colors.Cyan
        NoteTitle.TextSize = 14
        NoteTitle.TextXAlignment = Enum.TextXAlignment.Left
        NoteTitle.ZIndex = 22
        
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
        NoteText.ZIndex = 22

        TweenService:Create(Note, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.delay(duration, function()
            local OutTween = TweenService:Create(Note, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.3, 0, 0, 0)})
            OutTween:Play()
            OutTween.Completed:Wait()
            NoteWrap:Destroy()
        end)
    end

    -- // ============ LOADING SEQUENCE ============
    -- // Tunggu sampai 100% baru MainFrame muncul
    task.spawn(function()
        for i = 1, 100 do
            LoadPercent.Text = i .. "%"
            LoadBarFill.Size = UDim2.new(i / 100, 0, 1, 0)
            task.wait(0.02)
        end

        task.wait(0.2)

        local FadeOut = TweenService:Create(LoadingFrame, TweenInfo.new(0.4), {
            Position = UDim2.new(0.5, 0, 0.5, -20),
            BackgroundTransparency = 1
        })
        FadeOut:Play()
        FadeOut.Completed:Wait()
        LoadingFrame.Visible = false
        MainFrame.Visible = true
    end)

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
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabName.."_Content"
        TabContent.Parent = Container
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Colors.Cyan
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        
        local ContentList = Instance.new("UIListLayout", TabContent)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        
        local ContentPadding = Instance.new("UIPadding", TabContent)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)

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
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            
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
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", ToggleFrame)
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Font = Enum.Font.GothamBold
            Label.Text = TogText
            Label.TextColor3 = Colors.White
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            -- // Switch track
            local ToggleBtn = Instance.new("TextButton", ToggleFrame)
            ToggleBtn.BackgroundColor3 = State and Colors.Cyan or Colors.MainBlack
            ToggleBtn.Position = UDim2.new(1, -46, 0.5, -10)
            ToggleBtn.Size = UDim2.new(0, 36, 0, 20)
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

            -- // Knob bulat yang geser
            local Knob = Instance.new("Frame", ToggleBtn)
            Knob.BackgroundColor3 = Colors.White
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = State and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            if State then pcall(Callback, State) end

            ToggleBtn.MouseButton1Click:Connect(function()
                State = not State
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = State and Colors.Cyan or Colors.MainBlack}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = State and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0)}):Play()
                pcall(Callback, State)
            end)
        end

        function Elements:CreateSlider(SlidText, Min, Max, Default, Callback)
            local SliderFrame = Instance.new("Frame", TabContent)
            SliderFrame.BackgroundColor3 = Colors.SecondBlack
            SliderFrame.Size = UDim2.new(1, -15, 0, 50)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

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
