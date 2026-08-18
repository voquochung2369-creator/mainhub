local Window = _G.CustomHubWindow


local BloxFruit = Window:MakeTab({
    Name = "BloxFruit"
})


-- Dòng 1
BloxFruit:AddButton({
    Name = "Real Kid",
    Click = "Button",

    Callback = function()

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"
        ))()

    end
})


-- Dòng 2
BloxFruit:AddButton({
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


-- Dòng 3
BloxFruit:AddButton({
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
