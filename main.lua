-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window with Key System
local Window = Rayfield:CreateWindow({
   Name = "Brix Script",
   Icon = 0,
   LoadingTitle = "Brix Script Loading",
   LoadingSubtitle = "by Brix",
   ShowText = "Brix Script",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BrixHub",
      FileName = "MainConfig"
   },

   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },

   -- KEY SYSTEM
   KeySystem = true,
   KeySettings = {
      Title = "Brix Script Key",
      Subtitle = "Key System",
      Note = "Enter the correct key to use the script",
      FileName = "BrixKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"brix"}
   }
})

-- =========================
-- CREATE TABS
-- =========================
local MainTab = Window:CreateTab("Main", 4483345998)
local SeedsTab = Window:CreateTab("Seeds", 4483362458)
local GearsTab = Window:CreateTab("Gears", 4483370000)

-- =========================
-- CREATE SECTIONS
-- =========================
local MainSection = MainTab:CreateSection("Main")
local SeedsSection = SeedsTab:CreateSection("Auto Buy Seeds")
local GearsSection = GearsTab:CreateSection("Auto Buy Gears")

-- =========================
-- SELL INVENTORY BUTTON (Main Tab)
-- =========================
MainTab:CreateButton({
   Name = "Sell Inventory",
   Callback = function()
       local success, err = pcall(function()
           game:GetService("ReplicatedStorage").RemoteEvents.SellItems:InvokeServer("SellAll")
       end)
       if success then
           Rayfield:Notify({
               Title = "Inventory Sold",
               Content = "All items sold successfully!",
               Duration = 5,
               Image = 4483345998
           })
       else
           Rayfield:Notify({
               Title = "Error",
               Content = "Failed to sell inventory!",
               Duration = 5,
               Image = 4483345998
           })
       end
   end
})

-- =========================
-- AUTO BUY SEEDS (Seeds Tab)
-- =========================
local selectedSeeds = {"Carrot Seed"} -- default
local autoBuyEnabled = false

SeedsTab:CreateToggle({
   Name = "Enable Auto-Buy Seeds",
   CurrentValue = false,
   Flag = "AutoBuyToggle",
   Callback = function(Value)
       autoBuyEnabled = Value
   end
})

SeedsTab:CreateDropdown({
   Name = "Select Seeds to Auto-Buy",
   Options = {
       "Carrot Seed","Corn Seed","Onion Seed","Strawberry Seed",
       "Mushroom Seed","Beetroot Seed","Tomato Seed","Apple Seed",
       "Rose Seed","Wheat Seed","Banana Seed","Plum Seed",
       "Potato Seed","Cabbage Seed","Cherry Seed"
   },
   CurrentOption = selectedSeeds,
   MultipleOptions = true,
   Flag = "SelectedSeeds",
   Callback = function(Values)
       selectedSeeds = Values
   end
})

spawn(function()
    while true do
        wait(1)
        if autoBuyEnabled then
            for _, seed in ipairs(selectedSeeds) do
                local success, err = pcall(function()
                    game:GetService("ReplicatedStorage").RemoteEvents.PurchaseShopItem:InvokeServer("SeedShop", seed)
                end)
                if success then
                    Rayfield:Notify({
                        Title = "Auto-Buy Seed",
                        Content = seed .. " purchase request sent!",
                        Duration = 3,
                        Image = 4483362458
                    })
                end
            end
        end
    end
end)

-- =========================
-- AUTO BUY GEARS (Gears Tab)
-- =========================
local selectedGears = {"Watering Can"} -- default
local autoBuyGearsEnabled = false

GearsTab:CreateToggle({
    Name = "Enable Auto-Buy Gears",
    CurrentValue = false,
    Flag = "AutoBuyGearsToggle",
    Callback = function(Value)
        autoBuyGearsEnabled = Value
    end
})

GearsTab:CreateDropdown({
    Name = "Select Gears to Auto-Buy",
    Options = {
        "Watering Can",
        "Basic Sprinkler",
        "Harvest Bell",
        "Turbo Sprinkler",
        "Favorite Tool",
        "Super Sprinkler"
    },
    CurrentOption = selectedGears,
    MultipleOptions = true,
    Flag = "SelectedGears",
    Callback = function(Values)
        selectedGears = Values
    end
})

spawn(function()
    while true do
        wait(1)
        if autoBuyGearsEnabled then
            for _, gear in ipairs(selectedGears) do
                local success, err = pcall(function()
                    local args = { "GearShop", gear }
                    game:GetService("ReplicatedStorage").RemoteEvents.PurchaseShopItem:InvokeServer(unpack(args))
                end)
                if success then
                    Rayfield:Notify({
                        Title = "Auto-Buy Gear",
                        Content = gear .. " purchase request sent!",
                        Duration = 3,
                        Image = 4483370000
                    })
                end
            end
        end
    end
end)
