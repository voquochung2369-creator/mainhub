local Window = _G.CustomHubWindow


local Bloxfruit = Window:MakeTab({

    Name = "Blox Fruit"

})


Bloxfruit:AddButton({

    Name = "Real Kid",

    Click = "Leaver",
    Default = false,
    Callback = function()

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"
        ))()

    end

})


Bloxfruit:AddButton({

    Name = "lever no save",

    Click = "Lever",

    Default = false,

    Save = false,

    Callback = function(Value)

        print(Value)

    end

})


Bloxfruit:AddButton({

    Name = "lever save",

    Click = "Lever",

    Default = false,

    Save = true,

    Callback = function(Value)

        print(Value)

    end

})
