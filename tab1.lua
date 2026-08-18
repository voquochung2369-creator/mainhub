local Window = _G.CustomHubWindow


--------------------------------------------------
-- Bloxfruit (Dòng 1)
--------------------------------------------------

local Bloxfruit = Window:MakeTab({
    Name = "Bloxfruit"
})


Bloxfruit:AddButton({
    Name = "Real Kid",
    Click = "Button",

    Callback = function()

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"
        ))()

    end
})



--------------------------------------------------
-- Bloxfruit2 (Dòng 2)
--------------------------------------------------

local Bloxfruit2 = Window:MakeTab({
    Name = "Bloxfruit2"
})


Bloxfruit2:AddButton({
    Name = "lever no save",
    Click = "Lever",
    Default = false,
    Save = false,

    Callback = function(Value)

        if Value then
            print("lever no save ON")
        else
            print("lever no save OFF")
        end

    end
})



--------------------------------------------------
-- Bloxfruit3 (Dòng 3)
--------------------------------------------------

local Bloxfruit3 = Window:MakeTab({
    Name = "Bloxfruit3"
})


Bloxfruit3:AddButton({
    Name = "lever save",
    Click = "Lever",
    Default = false,
    Save = true,

    Callback = function(Value)

        if Value then
            print("lever save ON")
        else
            print("lever save OFF")
        end

    end
})
