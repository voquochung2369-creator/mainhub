local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local SAVE_FILE = "CustomHubUI_Settings.json"
local SavedData = {}

local function CanUseFileSystem()
    return type(isfile) == "function"
        and type(readfile) == "function"
        and type(writefile) == "function"
end

local function LoadSavedData()
    SavedData = {}

    if not CanUseFileSystem() then
        return
    end

    if not isfile(SAVE_FILE) then
        return
    end

    local success, result = pcall(function()
        return readfile(SAVE_FILE)
    end)

    if not success or not result or result == "" then
        return
    end

    local decodeSuccess, decoded = pcall(function()
        return HttpService:JSONDecode(result)
    end)

    if decodeSuccess and type(decoded) == "table" then
        SavedData = decoded
    end
end

local function SaveAllData()
    if not CanUseFileSystem() then
        return
    end

    local success, encoded = pcall(function()
        return HttpService:JSONEncode(SavedData)
    end)

    if success then
        pcall(function()
            writefile(SAVE_FILE, encoded)
        end)
    end
end

local function GetSavedValue(key)
    return SavedData[key]
end

local function SetSavedValue(key, value)
    SavedData[key] = value
    SaveAllData()
end

LoadSavedData()

--------------------------------------------------
-- XÓA GUI CŨ
--------------------------------------------------

for _, name in ipairs({
    "HubUi",
    "MenuUi",
    "CloseGui"
}) do
    local old = CoreGui:FindFirstChild(name)

    if old then
        pcall(function()
            old:Destroy()
        end)
    end
end

--------------------------------------------------
-- DRAG
--------------------------------------------------

local function MakeDraggable(frame, dragObject)
    local dragging = false
    local dragStart
    local startPosition

    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

--------------------------------------------------
-- HUB UI
--------------------------------------------------

local HubUi = Instance.new("ScreenGui")
HubUi.Name = "HubUi"
HubUi.ResetOnSpawn = false
HubUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
HubUi.Parent = CoreGui

local HubButton = Instance.new("TextButton")
HubButton.Name = "HubButton"
HubButton.Parent = HubUi
HubButton.Size = UDim2.new(0, 45, 0, 45)
HubButton.Position = UDim2.new(0, 25, 0.5, -22)
HubButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HubButton.BackgroundTransparency = 0.18
HubButton.BorderSizePixel = 0
HubButton.Text = "H"
HubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HubButton.TextStrokeTransparency = 1
HubButton.TextSize = 20
HubButton.Font = Enum.Font.GothamBold
HubButton.AutoButtonColor = false

local HubCorner = Instance.new("UICorner")
HubCorner.CornerRadius = UDim.new(1, 0)
HubCorner.Parent = HubButton

--------------------------------------------------
-- VIỀN TRÒN HUBUI
--------------------------------------------------

local HubStroke = Instance.new("UIStroke")
HubStroke.Name = "HubCircleStroke"
HubStroke.Color = Color3.fromRGB(255, 255, 255)
HubStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
HubStroke.Parent = HubButton

-- Khi đang ẩn:
-- viền nhỏ và hơi mờ
HubStroke.Thickness = 1
HubStroke.Transparency = 0.45

--------------------------------------------------
-- MENU UI
--------------------------------------------------

local MenuUi = Instance.new("ScreenGui")
MenuUi.Name = "MenuUi"
MenuUi.ResetOnSpawn = false
MenuUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MenuUi.Enabled = false
MenuUi.Parent = CoreGui

local MenuContainer = Instance.new("Frame")
MenuContainer.Name = "MenuContainer"
MenuContainer.Parent = MenuUi
MenuContainer.Size = UDim2.new(0, 650, 0, 400)
MenuContainer.Position = UDim2.new(0.5, -325, 0.5, -200)
MenuContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuContainer.BorderSizePixel = 0

--------------------------------------------------
-- MENU SCALE ONLY
--------------------------------------------------

local MenuScale = Instance.new("UIScale")
MenuScale.Parent = MenuContainer

local function UpdateMenuScale()
    local Camera = workspace.CurrentCamera

    if not Camera then
        return
    end

    local Viewport = Camera.ViewportSize

local Scale = math.min(
    Viewport.X / 1600,
    Viewport.Y / 900
)

if Scale < 0.75 then
    Scale = 0.75
end

if Scale > 1.25 then
    Scale = 1.25
end

MenuScale.Scale = Scale
end

UpdateMenuScale()

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    task.wait()

    UpdateMenuScale()
end)

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        UpdateMenuScale()
    end)
end

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MenuContainer

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(120, 120, 120)
MenuStroke.Thickness = 1
MenuStroke.Parent = MenuContainer

--------------------------------------------------
-- TOP BAR
--------------------------------------------------

local MenuTopBar = Instance.new("Frame")
MenuTopBar.Parent = MenuContainer
MenuTopBar.Size = UDim2.new(1, 0, 0, 50)
MenuTopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MenuTopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = MenuTopBar

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Parent = MenuTopBar
MenuTitle.Size = UDim2.new(1, -110, 1, 0)
MenuTitle.Position = UDim2.new(0, 15, 0, 0)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "Hub Menu"
MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuTitle.TextStrokeTransparency = 1
MenuTitle.TextSize = 18
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = MenuTopBar
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -85, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextStrokeTransparency = 1
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.AutoButtonColor = false

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Color3.fromRGB(0, 0, 0)
MinimizeStroke.Thickness = 1
MinimizeStroke.Parent = MinimizeButton

--------------------------------------------------
-- X
--------------------------------------------------

local XButton = Instance.new("TextButton")
XButton.Parent = MenuTopBar
XButton.Size = UDim2.new(0, 35, 0, 35)
XButton.Position = UDim2.new(1, -45, 0, 7)
XButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
XButton.BorderSizePixel = 0
XButton.Text = "X"
XButton.TextColor3 = Color3.fromRGB(255, 255, 255)
XButton.TextStrokeTransparency = 1
XButton.TextSize = 16
XButton.Font = Enum.Font.GothamBold
XButton.AutoButtonColor = false

local XCorner = Instance.new("UICorner")
XCorner.CornerRadius = UDim.new(0, 8)
XCorner.Parent = XButton

local XStroke = Instance.new("UIStroke")
XStroke.Color = Color3.fromRGB(0, 0, 0)
XStroke.Thickness = 1
XStroke.Parent = XButton

--------------------------------------------------
-- HOTBAR
--------------------------------------------------

local HotbarGui = Instance.new("Frame")
HotbarGui.Name = "HotbarGui"
HotbarGui.Parent = MenuContainer
HotbarGui.Size = UDim2.new(0, 150, 1, -65)
HotbarGui.Position = UDim2.new(0, 10, 0, 60)
HotbarGui.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
HotbarGui.BorderSizePixel = 0

local HotbarCorner = Instance.new("UICorner")
HotbarCorner.CornerRadius = UDim.new(0, 10)
HotbarCorner.Parent = HotbarGui

local HotbarStroke = Instance.new("UIStroke")
HotbarStroke.Color = Color3.fromRGB(110, 110, 110)
HotbarStroke.Thickness = 1
HotbarStroke.Parent = HotbarGui

local HotbarTitle = Instance.new("TextLabel")
HotbarTitle.Parent = HotbarGui
HotbarTitle.Size = UDim2.new(1, -20, 0, 35)
HotbarTitle.Position = UDim2.new(0, 10, 0, 5)
HotbarTitle.BackgroundTransparency = 1
HotbarTitle.Text = "MENU"
HotbarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HotbarTitle.TextStrokeTransparency = 1
HotbarTitle.TextSize = 16
HotbarTitle.Font = Enum.Font.GothamBold
HotbarTitle.TextXAlignment = Enum.TextXAlignment.Left

local HotbarContent = Instance.new("ScrollingFrame")
HotbarContent.Parent = HotbarGui
HotbarContent.Size = UDim2.new(1, -10, 1, -50)
HotbarContent.Position = UDim2.new(0, 5, 0, 45)
HotbarContent.BackgroundTransparency = 1
HotbarContent.BorderSizePixel = 0
HotbarContent.ScrollBarThickness = 3
HotbarContent.CanvasSize = UDim2.new(0, 0, 0, 0)

local HotbarLayout = Instance.new("UIListLayout")
HotbarLayout.Parent = HotbarContent
HotbarLayout.Padding = UDim.new(0, 7)

--------------------------------------------------
-- MAIN GUI
--------------------------------------------------

local MainGui = Instance.new("Frame")
MainGui.Name = "MainGui"
MainGui.Parent = MenuContainer
MainGui.Size = UDim2.new(1, -175, 1, -65)
MainGui.Position = UDim2.new(0, 165, 0, 60)
MainGui.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MainGui.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 120, 120)
MainStroke.Thickness = 1
MainStroke.Parent = MainGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Parent = MainGui
MainTitle.Size = UDim2.new(1, -20, 0, 40)
MainTitle.Position = UDim2.new(0, 10, 0, 5)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "Select a Tab"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextStrokeTransparency = 1
MainTitle.TextSize = 18
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextXAlignment = Enum.TextXAlignment.Left

local MainContent = Instance.new("ScrollingFrame")
MainContent.Parent = MainGui
MainContent.Size = UDim2.new(1, -20, 1, -55)
MainContent.Position = UDim2.new(0, 10, 0, 48)
MainContent.BackgroundTransparency = 1
MainContent.BorderSizePixel = 0
MainContent.ScrollBarThickness = 4
MainContent.CanvasSize = UDim2.new(0, 0, 0, 0)

local MainLayout = Instance.new("UIListLayout")
MainLayout.Parent = MainContent
MainLayout.Padding = UDim.new(0, 8)

--------------------------------------------------
-- CLOSE GUI
--------------------------------------------------

local CloseGui = Instance.new("ScreenGui")
CloseGui.Name = "CloseGui"
CloseGui.ResetOnSpawn = false
CloseGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CloseGui.Enabled = false
CloseGui.Parent = CoreGui

local CloseFrame = Instance.new("Frame")
CloseFrame.Parent = CloseGui
CloseFrame.Size = UDim2.new(0, 350, 0, 140)
CloseFrame.Position = UDim2.new(0.5, -175, 0.5, -70)
CloseFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
CloseFrame.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 12)
CloseCorner.Parent = CloseFrame

local CloseFrameStroke = Instance.new("UIStroke")
CloseFrameStroke.Color = Color3.fromRGB(0, 0, 0)
CloseFrameStroke.Thickness = 2
CloseFrameStroke.Parent = CloseFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Parent = CloseFrame
ConfirmText.Size = UDim2.new(1, -20, 0, 55)
ConfirmText.Position = UDim2.new(0, 10, 0, 5)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "You want close Menu?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.TextStrokeTransparency = 1
ConfirmText.TextSize = 17
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextXAlignment = Enum.TextXAlignment.Center
ConfirmText.TextYAlignment = Enum.TextYAlignment.Center

local Cannel = Instance.new("TextButton")
Cannel.Parent = CloseFrame
Cannel.Size = UDim2.new(0, 134, 0, 44)
Cannel.Position = UDim2.new(0, 18, 1, -57)
Cannel.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Cannel.BorderSizePixel = 0
Cannel.Text = "Cannel"
Cannel.TextColor3 = Color3.fromRGB(255, 255, 255)
Cannel.TextStrokeTransparency = 1
Cannel.TextSize = 16
Cannel.Font = Enum.Font.GothamBold

local CannelCorner = Instance.new("UICorner")
CannelCorner.CornerRadius = UDim.new(0, 8)
CannelCorner.Parent = Cannel

local CannelStroke = Instance.new("UIStroke")
CannelStroke.Color = Color3.fromRGB(0, 0, 0)
CannelStroke.Thickness = 2
CannelStroke.Parent = Cannel

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = CloseFrame
CloseButton.Size = UDim2.new(0, 134, 0, 44)
CloseButton.Position = UDim2.new(1, -152, 1, -57)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextStrokeTransparency = 1
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 8)
CloseButtonCorner.Parent = CloseButton

local CloseButtonStroke = Instance.new("UIStroke")
CloseButtonStroke.Color = Color3.fromRGB(0, 0, 0)
CloseButtonStroke.Thickness = 2
CloseButtonStroke.Parent = CloseButton

--------------------------------------------------
-- WINDOW
--------------------------------------------------

local Window = {
    Tabs = {},
    CurrentTab = nil
}

--------------------------------------------------
-- UPDATE CANVAS
--------------------------------------------------

local function UpdateMainCanvas()
    task.defer(function()
        MainContent.CanvasSize = UDim2.new(
            0,
            0,
            0,
            MainLayout.AbsoluteContentSize.Y + 10
        )
    end)
end

local function UpdateHotbarCanvas()
    task.defer(function()
        HotbarContent.CanvasSize = UDim2.new(
            0,
            0,
            0,
            HotbarLayout.AbsoluteContentSize.Y + 10
        )
    end)
end

--------------------------------------------------
-- CLEAR MAIN
--------------------------------------------------

local function ClearMain()
    for _, child in ipairs(MainContent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

--------------------------------------------------
-- SELECT TAB
--------------------------------------------------

local function SelectTab(tab)
    Window.CurrentTab = tab

    ClearMain()

    MainTitle.Text = tab.Name

    table.sort(tab.Buttons, function(a, b)
        if a.Order == b.Order then
            return a.Sequence < b.Sequence
        end

        return a.Order < b.Order
    end)

    for index, data in ipairs(tab.Buttons) do
        local button = Instance.new("TextButton")

        button.Name = data.Name
        button.Parent = MainContent
        button.LayoutOrder = index
        button.Size = UDim2.new(1, 0, 0, 45)
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
        button.BackgroundTransparency = 0.05
        button.BorderSizePixel = 0
        button.Text = "   " .. data.Name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextStrokeTransparency = 1
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.TextXAlignment = Enum.TextXAlignment.Left

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(120, 120, 120)
        stroke.Thickness = 1
        stroke.Transparency = 0.25
        stroke.Parent = button

        if data.Click == "Button" then
            local clickLabel = Instance.new("TextLabel")

            clickLabel.Parent = button
            clickLabel.Size = UDim2.new(0, 65, 1, 0)
            clickLabel.Position = UDim2.new(1, -70, 0, 0)
            clickLabel.BackgroundTransparency = 1
            clickLabel.Text = "Click"
            clickLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            clickLabel.TextStrokeTransparency = 1
            clickLabel.TextSize = 12
            clickLabel.Font = Enum.Font.GothamBold
            clickLabel.TextXAlignment = Enum.TextXAlignment.Center

            button.MouseButton1Click:Connect(function()
                if typeof(data.Callback) == "function" then
                    task.spawn(function()
                        pcall(data.Callback)
                    end)
                end
            end)

        elseif data.Click == "Lever" then
            local leverBackground = Instance.new("Frame")

            leverBackground.Parent = button
            leverBackground.Size = UDim2.new(0, 65, 0, 28)
            leverBackground.Position = UDim2.new(1, -75, 0.5, -14)
            leverBackground.BorderSizePixel = 0

            local leverCorner = Instance.new("UICorner")
            leverCorner.CornerRadius = UDim.new(1, 0)
            leverCorner.Parent = leverBackground

            local leverStroke = Instance.new("UIStroke")
            leverStroke.Color = Color3.fromRGB(160, 160, 160)
            leverStroke.Thickness = 1
            leverStroke.Parent = leverBackground

            local leverText = Instance.new("TextLabel")
            leverText.Parent = leverBackground
            leverText.Size = UDim2.new(1, 0, 1, 0)
            leverText.BackgroundTransparency = 1
            leverText.TextColor3 = Color3.fromRGB(255, 255, 255)
            leverText.TextStrokeTransparency = 1
            leverText.TextSize = 12
            leverText.Font = Enum.Font.GothamBold
            leverText.TextXAlignment = Enum.TextXAlignment.Center

            local circle = Instance.new("Frame")
            circle.Parent = leverBackground
            circle.Size = UDim2.new(0, 22, 0, 22)
            circle.BorderSizePixel = 0
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = circle

            local function UpdateLever()
                if data.Enabled then
                    leverBackground.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                    leverText.Text = "ON"
                    circle.Position = UDim2.new(1, -25, 0.5, -11)
                else
                    leverBackground.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    leverText.Text = "OFF"
                    circle.Position = UDim2.new(0, 3, 0.5, -11)
                end
            end

            button.MouseButton1Click:Connect(function()
                data.Enabled = not data.Enabled

                UpdateLever()

                if data.Save then
                    SetSavedValue(data.SaveKey, data.Enabled)
                end

                if typeof(data.Callback) == "function" then
                    task.spawn(function()
                        pcall(data.Callback, data.Enabled)
                    end)
                end
            end)

            UpdateLever()
        end
    end

    UpdateMainCanvas()
end

--------------------------------------------------
-- TẠO TAB
--------------------------------------------------

function Window:MakeTab(data)
    data = data or {}

    local tab = {
        Name = data.Name or "Tab",
        Icon = data.Icon or "",
        PremiumOnly = data.PremiumOnly or false,
        Buttons = {},
        Sequence = 0
    }

    table.insert(Window.Tabs, tab)

    local tabButton = Instance.new("TextButton")

    tabButton.Name = tab.Name
    tabButton.Parent = HotbarContent
    tabButton.LayoutOrder = #Window.Tabs
    tabButton.Size = UDim2.new(1, -5, 0, 42)
    tabButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    tabButton.BackgroundTransparency = 0.05
    tabButton.BorderSizePixel = 0
    tabButton.Text = "   " .. tab.Name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextStrokeTransparency = 1
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextXAlignment = Enum.TextXAlignment.Left

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 7)
    tabCorner.Parent = tabButton

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Color3.fromRGB(120, 120, 120)
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.3
    tabStroke.Parent = tabButton

    tabButton.MouseButton1Click:Connect(function()
        SelectTab(tab)
    end)

    function tab:AddButton(buttonData, forcedOrder)
        buttonData = buttonData or {}

        tab.Sequence = tab.Sequence + 1

        local info = {
            Name = buttonData.Name or "Button",
            Click = buttonData.Click or "Button",
            Callback = buttonData.Callback,
            Default = buttonData.Default == true,
            Save = buttonData.Save == true,
            Order = forcedOrder or tab.Sequence,
            Sequence = tab.Sequence
        }

        if info.Click ~= "Button" and info.Click ~= "Lever" then
            info.Click = "Button"
        end

        info.SaveKey = tab.Name .. "_" .. info.Order .. "_" .. info.Name

        local saved = GetSavedValue(info.SaveKey)

        if info.Click == "Lever" then
            if info.Save and saved ~= nil then
                info.Enabled = saved
            else
                info.Enabled = info.Default
            end
        end

        table.insert(tab.Buttons, info)

        if Window.CurrentTab == tab then
            SelectTab(tab)
        end

        return info
    end

    UpdateHotbarCanvas()

    return tab
end

--------------------------------------------------
-- TỰ TẠO SETTING2, SETTING3...
--------------------------------------------------

local function CreateAliases(baseName, tab)
    _G[baseName] = tab

    for i = 2, 100 do
        _G[baseName .. tostring(i)] = tab
    end
end

--------------------------------------------------
-- TẠO TABS
--------------------------------------------------

local Bloxfruit = Window:MakeTab({
    Name = "Blox Fruit",
    Icon = "",
    PremiumOnly = false
})

CreateAliases("Bloxfruit", Bloxfruit)

local Setting = Window:MakeTab({
    Name = "Setting",
    Icon = "",
    PremiumOnly = false
})

CreateAliases("Setting", Setting)

--------------------------------------------------
-- ALIAS
--------------------------------------------------

local Bloxfruit2 = _G.Bloxfruit2
local Bloxfruit3 = _G.Bloxfruit3
local Bloxfruit4 = _G.Bloxfruit4
local Bloxfruit5 = _G.Bloxfruit5

local Setting2 = _G.Setting2
local Setting3 = _G.Setting3
local Setting4 = _G.Setting4
local Setting5 = _G.Setting5

--------------------------------------------------
-- BLOX FRUIT
--------------------------------------------------

Bloxfruit:AddButton({
    Name = "Real Kid",
    Click = "Button",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))()
    end
})

Bloxfruit2:AddButton({
    Name = "Onion",
    Click = "Button",
    Callback = function()
	loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/cc815ef92aaf3ed41a37aa4d87cd93ff.lua"))()
    end
})

Bloxfruit3:AddButton({
    Name = "Hermanos'DEV | PVP",
    Click = "Button",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))()
    end
})

--Bloxfruit2:AddButton({
 --   Name = "Test Lever",
  --  Click = "Lever",
 --   Default = false,
 --   Save = false,
 --  Callback = function(Value)
 --       if Value then
 --       else
  --      end
  --  end
--})

--------------------------------------------------
-- SETTING
--------------------------------------------------

Setting:AddButton({
    Name = "Fast Mode",
    Click = "Button",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/voquochung2369-creator/ScriptFastmode/refs/heads/main/Fastmode"))()
    end
})

Setting2:AddButton({
    Name = "Auto Fast Mode",
    Click = "Lever",
    Default = false,
    Save = true,
   Callback = function(Value)
        if Value then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/voquochung2369-creator/ScriptFastmode/refs/heads/main/Fastmode"))()
        else
        end
    end
})

Setting3:AddButton({
    Name = "Test Lever",
    Click = "Lever",
    Default = false,
    Save = true,
   Callback = function(Value)
        if Value then
        else
        end
    end
})

--------------------------------------------------
-- DRAG
--------------------------------------------------

MakeDraggable(MenuContainer, MenuTopBar)
MakeDraggable(HubButton, HubButton)

--------------------------------------------------
-- HUB UI
--------------------------------------------------

HubButton.MouseButton1Click:Connect(function()
    MenuUi.Enabled = not MenuUi.Enabled

    if MenuUi.Enabled then
        -- BẬT:
        -- viền trắng đậm và dày
        HubStroke.Thickness = 2.5
        HubStroke.Transparency = 0.05
    else
        -- ẨN:
        -- viền trắng mỏng và hơi mờ
        HubStroke.Thickness = 1
        HubStroke.Transparency = 0.45
    end
end)

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

MinimizeButton.MouseButton1Click:Connect(function()
    MenuUi.Enabled = false

    HubStroke.Thickness = 1
    HubStroke.Transparency = 0.45
end)

--------------------------------------------------
-- X
--------------------------------------------------

XButton.MouseButton1Click:Connect(function()
    MenuUi.Enabled = false
    CloseGui.Enabled = true

    HubStroke.Thickness = 1
    HubStroke.Transparency = 0.45
end)

--------------------------------------------------
-- CANNEL
--------------------------------------------------

Cannel.MouseButton1Click:Connect(function()
    CloseGui.Enabled = false
    MenuUi.Enabled = true

    HubStroke.Thickness = 2.5
    HubStroke.Transparency = 0.05
end)

--------------------------------------------------
-- CLOSE
--------------------------------------------------

CloseButton.MouseButton1Click:Connect(function()
    pcall(function()
        HubUi:Destroy()
    end)

    pcall(function()
        MenuUi:Destroy()
    end)

    pcall(function()
        CloseGui:Destroy()
    end)
end)

--------------------------------------------------
-- TAB MẶC ĐỊNH
--------------------------------------------------

if Window.Tabs[1] then
    SelectTab(Window.Tabs[1])
end

-- Mặc định Menu đang ẩn
HubStroke.Thickness = 1
HubStroke.Transparency = 0.45
