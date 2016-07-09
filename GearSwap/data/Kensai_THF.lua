--[[
Kensai
Thief

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
    }    
end

function precast(spell)
    if spell.prefix == "/weaponskill" then
       send_command("input /ja 'Sneak Attack' <me>;")
    end
end

function midcast(spell)
    
end

function aftercast(spell)
    
end

function status_change(new, old)
    
end

function self_command(command)

end