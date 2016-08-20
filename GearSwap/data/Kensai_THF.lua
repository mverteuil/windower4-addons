--[[ Kensai - Thief ]]--

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
 
    require('lib/kensai-globals.lua')

    -- Get Kensai Common Sets
    set_common_sets()    
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
    send_command("alias g13_m1g1 exec sa_sharkbite.txt")
    send_command("alias g13_m1g2 exec ta_sharkbite.txt")
    send_command("alias g13_m1g3 input /assassinscharge")
    send_command("alias g13_m1g4 input /larceny")
    send_command("alias g13_m1g5 input /feint")
    send_command("alias g13_m1g6 input /bully")
    send_command("alias g13_m1g7 input /spectraljig")

    send_command("alias g13_m1g8 input /drainsamba")
    send_command("alias g13_m1g9 input /hastesamba")
    send_command("alias g13_m1g10 input /boxstep")
    send_command("alias g13_m1g11 input /quickstep")
    send_command("alias g13_m1g12 input /violentflourish")
    send_command("alias g13_m1g13 input /reverseflourish")
    send_command("alias g13_m1g14 ")

    send_command("alias g13_m1g15 input /curingwaltz <me>") 
    send_command("alias g13_m1g16 input /curingwaltz2 <me>")
    send_command("alias g13_m1g17 input /curingwaltz3 <me>")
    send_command("alias g13_m1g18 input /divinewaltz <me>")
    send_command("alias g13_m1g19 ")

    send_command("alias g13_m1g20")
    send_command("alias g13_m1g21")
    send_command("alias g13_m1g22")

    send_command("alias stp_m1 ")
    send_command("alias stp_m2 ")
    send_command("alias stp_m3 ")
    send_command("alias stp_m4 ")
    send_command("alias stp_m5 ")

    send_command("alias stp_m6 ")
    send_command("alias stp_m7 ")
    send_command("alias stp_m8 ")
    send_command("alias stp_m9 ")
    send_command("alias stp_m10")

    send_command("alias stp_m11 input /steal")
    send_command("alias stp_m12 input /despoil")
    send_command("alias stp_m13 input /mug")
end