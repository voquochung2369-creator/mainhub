--// CustomHub Main.lua
--// Core GUI + Window System + External Tabs Loader


local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")


--------------------------------------------------
-- SAVE
--------------------------------------------------

local SAVE_FILE = "CustomHub_Settings.json"

local SavedData = {}


local function CanUseFileSystem()

    return type(isfile) == "function"
    and type(readfile) == "function"
    and type(writefile) == "function"

end



local function LoadSavedData()

    if not CanUseFileSystem() then
        return
    end


    if not isfile(SAVE_FILE) then
        return
    end


    pcall(function()

        SavedData = HttpService:JSONDecode(
            readfile(SAVE_FILE)
        )

    end)

end



local function SaveData()

    if not CanUseFileSystem() then
        return
    end


    pcall(function()

        writefile(
            SAVE_FILE,
            HttpService:JSONEncode(SavedData)
        )

    end)

end



local function GetSave(key)

    return SavedData[key]

end



local function SetSave(key,value)

    SavedData[key] = value

    SaveData()

end



LoadSavedData()



--------------------------------------------------
-- REMOVE OLD GUI
--------------------------------------------------

for _,v in ipairs({

    "HubUi",
    "MenuUi"

}) do


    local old = CoreGui:FindFirstChild(v)


    if old then

        pcall(function()

            old:Destroy()

        end)

    end

end




--------------------------------------------------
-- DRAG
--------------------------------------------------


local function MakeDraggable(frame,drag)


    local dragging = false

    local start

    local pos



    drag.InputBegan:Connect(function(input)


        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then


            dragging = true

            start = input.Position

            pos = frame.Position



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


            local delta = input.Position - start



            frame.Position = UDim2.new(

                pos.X.Scale,
                pos.X.Offset + delta.X,

                pos.Y.Scale,
                pos.Y.Offset + delta.Y

            )

        end


    end)


end





--------------------------------------------------
-- HUB BUTTON
--------------------------------------------------


local HubUi = Instance.new("ScreenGui")

HubUi.Name = "HubUi"

HubUi.ResetOnSpawn = false

HubUi.Parent = CoreGui



local HubButton = Instance.new("TextButton")


HubButton.Parent = HubUi

HubButton.Size = UDim2.new(0,45,0,45)

HubButton.Position = UDim2.new(0,25,0.5,-22)

HubButton.BackgroundColor3 =
Color3.fromRGB(25,25,25)

HubButton.Text = "H"

HubButton.TextColor3 =
Color3.new(1,1,1)

HubButton.TextSize = 20

HubButton.Font =
Enum.Font.GothamBold



local HubCorner = Instance.new("UICorner")

HubCorner.CornerRadius =
UDim.new(1,0)

HubCorner.Parent = HubButton




local HubStroke = Instance.new("UIStroke")

HubStroke.Color =
Color3.new(1,1,1)

HubStroke.Thickness = 1

HubStroke.Transparency = .45

HubStroke.Parent = HubButton






--------------------------------------------------
-- MENU
--------------------------------------------------


local MenuUi = Instance.new("ScreenGui")


MenuUi.Name = "MenuUi"

MenuUi.ResetOnSpawn = false

MenuUi.Enabled = false

MenuUi.Parent = CoreGui





local MenuContainer = Instance.new("Frame")


MenuContainer.Parent = MenuUi

MenuContainer.Size =
UDim2.new(0,650,0,400)


MenuContainer.Position =
UDim2.new(.5,-325,.5,-200)


MenuContainer.BackgroundColor3 =
Color3.fromRGB(60,60,60)


MenuContainer.BorderSizePixel = 0





local MenuScale = Instance.new("UIScale")

MenuScale.Parent = MenuContainer



local function UpdateScale()


    local cam = workspace.CurrentCamera


    if not cam then
        return
    end


    local size = cam.ViewportSize



    local scale = math.min(

        size.X / 1600,

        size.Y / 900

    )



    if scale < .75 then

        scale = .75

    end



    if scale > 1.15 then

        scale = 1.15

    end



    MenuScale.Scale = scale


end



UpdateScale()



workspace.CurrentCamera:GetPropertyChangedSignal(
"ViewportSize"
):Connect(UpdateScale)

--------------------------------------------------
-- MENU DECORATION
--------------------------------------------------

local MenuCorner = Instance.new("UICorner")

MenuCorner.CornerRadius =
UDim.new(0,12)

MenuCorner.Parent = MenuContainer



local MenuStroke = Instance.new("UIStroke")

MenuStroke.Color =
Color3.fromRGB(120,120,120)

MenuStroke.Thickness = 1

MenuStroke.Parent = MenuContainer




--------------------------------------------------
-- TOP BAR
--------------------------------------------------

local MenuTopBar = Instance.new("Frame")

MenuTopBar.Parent = MenuContainer

MenuTopBar.Size =
UDim2.new(1,0,0,50)

MenuTopBar.BackgroundColor3 =
Color3.fromRGB(50,50,50)

MenuTopBar.BorderSizePixel = 0




local TopCorner = Instance.new("UICorner")

TopCorner.CornerRadius =
UDim.new(0,12)

TopCorner.Parent = MenuTopBar




local MenuTitle = Instance.new("TextLabel")


MenuTitle.Parent = MenuTopBar

MenuTitle.Size =
UDim2.new(1,-110,1,0)

MenuTitle.Position =
UDim2.new(0,15,0,0)

MenuTitle.BackgroundTransparency = 1

MenuTitle.Text = "CustomHub"

MenuTitle.TextColor3 =
Color3.new(1,1,1)

MenuTitle.TextSize = 18

MenuTitle.Font =
Enum.Font.GothamBold

MenuTitle.TextXAlignment =
Enum.TextXAlignment.Left






--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

local MinimizeButton = Instance.new("TextButton")


MinimizeButton.Parent = MenuTopBar

MinimizeButton.Size =
UDim2.new(0,35,0,35)

MinimizeButton.Position =
UDim2.new(1,-85,0,7)

MinimizeButton.BackgroundColor3 =
Color3.fromRGB(100,100,100)

MinimizeButton.Text = "-"

MinimizeButton.TextColor3 =
Color3.new(1,1,1)

MinimizeButton.TextSize = 20

MinimizeButton.Font =
Enum.Font.GothamBold



local MinCorner = Instance.new("UICorner")

MinCorner.CornerRadius =
UDim.new(0,8)

MinCorner.Parent = MinimizeButton




--------------------------------------------------
-- CLOSE
--------------------------------------------------

local XButton = Instance.new("TextButton")


XButton.Parent = MenuTopBar

XButton.Size =
UDim2.new(0,35,0,35)

XButton.Position =
UDim2.new(1,-45,0,7)

XButton.BackgroundColor3 =
Color3.fromRGB(100,100,100)

XButton.Text = "X"

XButton.TextColor3 =
Color3.new(1,1,1)

XButton.TextSize = 16

XButton.Font =
Enum.Font.GothamBold



local XCorner = Instance.new("UICorner")

XCorner.CornerRadius =
UDim.new(0,8)

XCorner.Parent = XButton





--------------------------------------------------
-- HOTBAR
--------------------------------------------------

local HotbarGui = Instance.new("Frame")


HotbarGui.Name = "HotbarGui"

HotbarGui.Parent = MenuContainer

HotbarGui.Size =
UDim2.new(0,150,1,-65)

HotbarGui.Position =
UDim2.new(0,10,0,60)

HotbarGui.BackgroundColor3 =
Color3.fromRGB(55,55,55)

HotbarGui.BorderSizePixel = 0




local HotCorner = Instance.new("UICorner")

HotCorner.CornerRadius =
UDim.new(0,10)

HotCorner.Parent = HotbarGui




local HotbarTitle = Instance.new("TextLabel")


HotbarTitle.Parent = HotbarGui

HotbarTitle.Size =
UDim2.new(1,-20,0,35)

HotbarTitle.Position =
UDim2.new(0,10,0,5)

HotbarTitle.BackgroundTransparency = 1

HotbarTitle.Text = "MENU"

HotbarTitle.TextColor3 =
Color3.new(1,1,1)

HotbarTitle.TextSize = 16

HotbarTitle.Font =
Enum.Font.GothamBold

HotbarTitle.TextXAlignment =
Enum.TextXAlignment.Left





local HotbarContent = Instance.new("ScrollingFrame")


HotbarContent.Parent = HotbarGui

HotbarContent.Size =
UDim2.new(1,-10,1,-50)

HotbarContent.Position =
UDim2.new(0,5,0,45)

HotbarContent.BackgroundTransparency = 1

HotbarContent.BorderSizePixel = 0

HotbarContent.ScrollBarThickness = 3




local HotbarLayout = Instance.new("UIListLayout")

HotbarLayout.Parent = HotbarContent

HotbarLayout.Padding =
UDim.new(0,7)






--------------------------------------------------
-- MAIN CONTENT
--------------------------------------------------

local MainGui = Instance.new("Frame")


MainGui.Name = "MainGui"

MainGui.Parent = MenuContainer


MainGui.Size =
UDim2.new(1,-175,1,-65)


MainGui.Position =
UDim2.new(0,165,0,60)


MainGui.BackgroundColor3 =
Color3.fromRGB(70,70,70)


MainGui.BorderSizePixel = 0





local MainCorner = Instance.new("UICorner")

MainCorner.CornerRadius =
UDim.new(0,10)

MainCorner.Parent = MainGui





local MainTitle = Instance.new("TextLabel")


MainTitle.Parent = MainGui

MainTitle.Size =
UDim2.new(1,-20,0,40)

MainTitle.Position =
UDim2.new(0,10,0,5)

MainTitle.BackgroundTransparency = 1

MainTitle.Text = "Select Tab"

MainTitle.TextColor3 =
Color3.new(1,1,1)

MainTitle.TextSize = 18

MainTitle.Font =
Enum.Font.GothamBold

MainTitle.TextXAlignment =
Enum.TextXAlignment.Left





local MainContent = Instance.new("ScrollingFrame")


MainContent.Parent = MainGui


MainContent.Size =
UDim2.new(1,-20,1,-55)


MainContent.Position =
UDim2.new(0,10,0,48)


MainContent.BackgroundTransparency = 1

MainContent.BorderSizePixel = 0

MainContent.ScrollBarThickness = 4





local MainLayout = Instance.new("UIListLayout")


MainLayout.Parent = MainContent


MainLayout.Padding =
UDim.new(0,8)






--------------------------------------------------
-- WINDOW SYSTEM
--------------------------------------------------


local Window = {

    Tabs = {},

    CurrentTab = nil

}



-- cho file ngoài dùng

_G.CustomHubWindow = Window





--------------------------------------------------
-- CLEAR
--------------------------------------------------

local function ClearMain()


    for _,v in ipairs(MainContent:GetChildren()) do


        if v:IsA("GuiObject") then

            v:Destroy()

        end


    end


end





--------------------------------------------------
-- CANVAS
--------------------------------------------------

local function UpdateCanvas()


    task.defer(function()


        MainContent.CanvasSize =
        UDim2.new(

            0,

            0,

            0,

            MainLayout.AbsoluteContentSize.Y + 10

        )


    end)


end





--------------------------------------------------
-- SELECT TAB
--------------------------------------------------

local function SelectTab(tab)


    Window.CurrentTab = tab


    ClearMain()


    MainTitle.Text = tab.Name



    for _,data in ipairs(tab.Buttons) do


        local button = Instance.new("TextButton")


        button.Parent = MainContent

        button.Size =
        UDim2.new(1,0,0,45)


        button.BackgroundColor3 =
        Color3.fromRGB(90,90,90)


        button.Text =
        "   "..data.Name


        button.TextColor3 =
        Color3.new(1,1,1)


        button.Font =
        Enum.Font.GothamBold


        button.TextSize = 16


        button.TextXAlignment =
        Enum.TextXAlignment.Left




        local corner = Instance.new("UICorner")

        corner.CornerRadius =
        UDim.new(0,8)

        corner.Parent = button





        button.MouseButton1Click:Connect(function()


            if typeof(data.Callback) == "function" then


                task.spawn(function()

                    pcall(data.Callback)

                end)


            end


        end)


    end



    UpdateCanvas()


end

--------------------------------------------------
-- MAKE TAB
--------------------------------------------------

function Window:MakeTab(data)


    data = data or {}



    local tab = {


        Name = data.Name or "Tab",


        Buttons = {}


    }




    table.insert(

        Window.Tabs,

        tab

    )





    local tabButton = Instance.new("TextButton")



    tabButton.Parent = HotbarContent



    tabButton.Size =

    UDim2.new(1,-5,0,42)



    tabButton.BackgroundColor3 =

    Color3.fromRGB(75,75,75)



    tabButton.Text =

    "   "..tab.Name



    tabButton.TextColor3 =

    Color3.new(1,1,1)



    tabButton.Font =

    Enum.Font.GothamBold



    tabButton.TextSize = 14



    tabButton.TextXAlignment =

    Enum.TextXAlignment.Left






    local corner = Instance.new("UICorner")


    corner.CornerRadius =

    UDim.new(0,7)


    corner.Parent = tabButton






    tabButton.MouseButton1Click:Connect(function()


        SelectTab(tab)


    end)






    --------------------------------------------------
    -- ADD BUTTON
    --------------------------------------------------


    function tab:AddButton(info)


        info = info or {}



        table.insert(

            tab.Buttons,

            {


                Name = info.Name or "Button",


                Callback = info.Callback


            }


        )



        if Window.CurrentTab == tab then


            SelectTab(tab)


        end



    end






    return tab


end






--------------------------------------------------
-- DRAG
--------------------------------------------------


MakeDraggable(

    MenuContainer,

    MenuTopBar

)



MakeDraggable(

    HubButton,

    HubButton

)







--------------------------------------------------
-- HUB OPEN
--------------------------------------------------


HubButton.MouseButton1Click:Connect(function()


    MenuUi.Enabled =

    not MenuUi.Enabled



    if MenuUi.Enabled then


        HubStroke.Thickness = 2.5

        HubStroke.Transparency = 0.05



    else


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
-- CLOSE
--------------------------------------------------


XButton.MouseButton1Click:Connect(function()


    MenuUi.Enabled = false


end)







--------------------------------------------------
-- LOAD EXTERNAL TABS
--------------------------------------------------

local Modules = {
    "https://raw.githubusercontent.com/voquochung2369-creator/mainhub/refs/heads/main/setting.lua"
}




for _,url in ipairs(Modules) do



    pcall(function()


        loadstring(

            game:HttpGet(url)

        )()



    end)



end






--------------------------------------------------
-- DEFAULT TAB
--------------------------------------------------


task.wait(0.2)



if Window.Tabs[1] then


    SelectTab(

        Window.Tabs[1]

    )


end
