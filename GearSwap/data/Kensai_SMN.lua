--[[
Kensai
Red Mage

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
    
    -- Macros Be Here
    send_command("alias g13_m1g1 input /carbuncle")
    send_command("alias g13_m1g2 input /titan")
    send_command("alias g13_m1g3 input /leviathan")
    send_command("alias g13_m1g4 input /garuda")
    send_command("alias g13_m1g5 input /shiva")
    send_command("alias g13_m1g6 input /ramuh")
    send_command("alias g13_m1g7 input /caitsith")
    send_command("alias g13_m1g8 input /atomos")
    send_command("alias g13_m1g9 input /cure st")
    send_command("alias g13_m1g10 input /cure2 st")
    send_command("alias g13_m1g11 input /assault")
    send_command("alias g13_m1g12 input /release")
    send_command("alias g13_m1g13 input /echo nothing")
    send_command("alias g13_m1g14 input /elementalseal")
    send_command("alias g13_m1g15 input /composure")
    send_command("alias g13_m1g16 input /haste2 st")
    send_command("alias g13_m1g17 input /refresh2 st")
    send_command("alias g13_m1g18 input /stoneskin")
    send_command("alias g13_m1g19 input /phalanx2")
    send_command("alias g13_m1g20 input /blink")
    send_command("alias g13_m1g21 input /cure4 st")
    send_command("alias g13_m1g22 input /cure4 me")

    send_command("alias stp_m1 input /spontaneity")
    send_command("alias stp_m2 input /saboteur")
    send_command("alias stp_m3 input /stymie")
    send_command("alias stp_m4 input /temper")
    send_command("alias stp_m5 input /gainstr")
    send_command("alias stp_m6 input /savageblade")
    send_command("alias stp_m7 input /sanguineblade")
    send_command("alias stp_m8 input /enfire2")
    send_command("alias stp_m9 input /dispel")
    send_command("alias stp_m10 input /enthunder")
    send_command("alias stp_m11 input //invert")
    send_command("alias stp_m12 input /cure4 st")
    send_command("alias stp_m13 input /cure4 me")
    send_command("alias stp_m14 input /valaineral")
    send_command("alias stp_m15 input /zeid2")
    send_command("alias stp_m16 input /shantotto2")
    send_command("alias stp_m17 input /excenmilles")
    send_command("alias stp_m18 input /lilisette")
    send_command("alias stp_m19 input /qultada")
    send_command("alias stp_m20 input /ayame uc")
    send_command("alias stp_m21 input /kupipi")

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