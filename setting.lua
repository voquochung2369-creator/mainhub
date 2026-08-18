local Window = _G.CustomHubWindow


local Setting = Window:MakeTab({

    Name = "Setting"

})


Setting:AddButton({

    Name = "Fast Mode",

    Callback = function()

        print("Fast Mode")

    end

})
