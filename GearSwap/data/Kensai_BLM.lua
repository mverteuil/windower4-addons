--[[
Kensai
Black Mage

=================================================

Set Template
------------
sets.new = {
    main  = "",
    sub   = "",
    range = "",
    ammo  = "",
    head  = "",
    neck  = "",
    lear  = "",
    rear  = "",
    body  = "",
    hands = "",
    ring1 = "",
    ring2 = "",
    back  = "",
    waist = "",
    legs  = "",
    feet  = "",
}
]]--

--[[ Utilities ]]--

local function to_windower_api(str)
    return str:lower():gsub(" ","_")
end

--[[ GearSwap Defined Callbacks ]]--

-- Called once on load to initialize `sets`
function get_sets()
    set_language("english")
    sets = {}
    sets.idle = {
        main  = "Iridial staff",
        sub   = "",
        range = "",
        ammo  = "Morion tathlum",
        head  = "",
        neck  = "Mohbwa scarf +1",
        lear  = "Moldavite earring",
        rear  = "Antivenom earring",
        body  = "Black cotehardie",
        hands = "Zenith mitts",
        ring1 = "Genius ring",
        ring2 = "Genius ring",
        back  = "Red cape +1",
        waist = "Mohbwa sash +1",
        legs  = "Warlock's tights",
        feet  = "Mountain Gaiters",
    }    
end

function precast(spell)
    
end

function midcast(spell)
    
end

function aftercast(spell)
    
end

function status_change(new, old)
    
end

function self_command(command)

end