--[[ Kensai - Red Mage ]]--

--[[ Trusts for Strix Macros ]]--

TRUSTS = {
    'August',
    'ExcenmilleS',
    'Korumoru',
    'ShantottoII',
    'ZeidII',
    'Qultada',
    'PieujeUC',
    'Kupipi',
}

function get_sets()
    --[[
        common-mage-gear.lua
        This file will contain the default gear for the three mage types blm, sch, geo
        After the init function, you can override gear based on your job.
        This must be called first or it might override other gear you might declare.
        
        Additionally, after you have overridden gear, you must call the build_default_sets function to build the casting sets.
        --]]
        require('lib/common-mage-gear.lua')
        init_mage_gear()
        
    -- Gear Overrides
    --[[
        There are 3 ways to override gear
        1. change equipment one piece at a time
            sets.MND.head = "Gende. Caubeen"
        2. use the set_combine function to one or more pieces of gear
            sets.FC  = set_combine(sets.FC, { ammo = "Incantor Stone", hands = "Gendewitha Gages" })
        3. completely override the set with a new one
            sets.MaxCastReduction = { waist = "Goading Belt", legs = hagpantsacc, feet = "Hagondes Sabots" }
            --]]

    sets.Idle.main = "Iztaasu +2"
    sets.Idle.sub = "Ice Shield"
    sets.Engaged.Melee.main = "Iztaasu +2"
    sets.Engaged.Melee.sub = "Ice Shield"
    sets.Engaged = sets.Engaged.Melee

    -- Build Default Sets
    build_default_sets()
    
    -- Include Spell Maps and Mage Functions
    require('lib/spell-map.lua')
    require('lib/mage-function.lua')
    require('lib/kensai-globals.lua')

    -- Get Kensai Common Sets
    set_common_sets()

    alias_element_match()
    alias_kensai_globals()
    set_aliases()
end


function job_self_command(commandParams, eventArgs)
    if commandParams[1] == 'lock' and #commandParams == 1 then
        disable('main', 'sub', 'ammo', 'range')
        add_to_chat(3, 'Locked main/sub/ammo/range')
        eventArgs.handled = true
    elseif commandParams[1] == 'lock' and #commandParams == 2 then
        disable(commandParams[2])
        add_to_chat(3, 'Locked ' .. commandParams[2])
        eventArgs.handled = true
    elseif commandParams[1] == 'unlock' and #commandParams == 1 then
        enable('main', 'sub', 'ammo', 'range')
        add_to_chat(4, 'Unlocked main/sub/ammo/range')
        eventArgs.handled = true
    elseif commandParams[1] == 'unlock' and #commandParams == 2 then
        enable(commandParams[2])
        add_to_chat(3, 'Unlocked ' .. commandParams[2])
        eventArgs.handled = true
    end
end

function set_aliases()
    send_command("alias g13_m1g1 input /dia3")
    send_command("alias g13_m1g2 input /slow2")
    send_command("alias g13_m1g3 input /paralyze2")
    send_command("alias g13_m1g4 input /gravity")
    send_command("alias g13_m1g5 input /distract")
    send_command("alias g13_m1g6 input /bio3")
    send_command("alias g13_m1g7 input /stun")

    send_command("alias g13_m1g8 input /stone4")
    send_command("alias g13_m1g9 input /water4")
    send_command("alias g13_m1g10 input /aero4")
    send_command("alias g13_m1g11 input /fire4")
    send_command("alias g13_m1g12 input /blizzard4")
    send_command("alias g13_m1g13 input /thunder4")
    send_command("alias g13_m1g14 input /elementalseal")

    send_command("alias g13_m1g15 input /composure")
    send_command("alias g13_m1g16 input /haste2 <st>")
    send_command("alias g13_m1g17 input /refresh2 <st>")
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
    send_command("alias stp_m12 input /cure4 <st>")
    send_command("alias stp_m13 input /cure4 me")
end