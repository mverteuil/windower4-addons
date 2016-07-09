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
    send_command("alias g13_m1g1 input /stone2")
    send_command("alias g13_m1g2 input /water2")
    send_command("alias g13_m1g3 input /aero2")
    send_command("alias g13_m1g4 input /fire2")
    send_command("alias g13_m1g5 input /blizzard2")
    send_command("alias g13_m1g6 input /thunder2")
    send_command("alias g13_m1g7 input /berserk")
    send_command("alias g13_m1g8 input /absorb-str")
    send_command("alias g13_m1g9 input /absorb-dex")
    send_command("alias g13_m1g10 input /absorb-vit")
    send_command("alias g13_m1g11 input /absorb-agi")
    send_command("alias g13_m1g12 input /absorb-int")
    send_command("alias g13_m1g13 input /absorb-mnd")
    send_command("alias g13_m1g14 input /warcry")
    send_command("alias g13_m1g15 input /poison")
    send_command("alias g13_m1g16 input /provoke")
    send_command("alias g13_m1g17 input /defender")
    send_command("alias g13_m1g18 input /bio2")
    send_command("alias g13_m1g19 input /absorb-tp")
    send_command("alias g13_m1g20 input /bloodweapon")
    send_command("alias g13_m1g21 input /drain")
    send_command("alias g13_m1g22 input /aspir")

    send_command("alias stp_m1 input /stun")
    send_command("alias stp_m2 input /consumemana")
    send_command("alias stp_m3 input /poison")
    send_command("alias stp_m4 input /bio2")
    send_command("alias stp_m5 input /berserk")
    send_command("alias stp_m6 input /spinningslash")
    send_command("alias stp_m7 input /hardslash")
    send_command("alias stp_m8 input /lastresort")
    send_command("alias stp_m9 input /souleater")
    send_command("alias stp_m10 input /weaponbash")
    send_command("alias stp_m11 input /spinningslash")
    send_command("alias stp_m12 input /stun")
    send_command("alias stp_m13 input /cure2 me")
    send_command("alias stp_m14 input /halver")
    send_command("alias stp_m15 input /excenmilles")
    send_command("alias stp_m16 input /lilisette")
    send_command("alias stp_m17 input /shantotto2")
    send_command("alias stp_m18 input /ulmia")
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