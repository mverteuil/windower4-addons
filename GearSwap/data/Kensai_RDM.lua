--[[ Kensai - Red Mage ]]--

require('libs/kensai-globals')

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

ALWAYS_BUFF = {}
ALWAYS_BUFF[419] = "Composure"
ALWAYS_BUFF[33] = "Haste II"
ALWAYS_BUFF[43] = "Refresh II"
ALWAYS_BUFF[432] = "Temper"


--[[ Utilities ]]--

local function to_windower_api(str)
    return str:lower():gsub(" ","_")
end


--[[ GearSwap Defined Callbacks ]]--

-- Called once on load to initialize `sets`
function get_sets()
    set_language("english")

    set_common_sets()
    
    --{{ Idle Gear }}--
    sets.Idle = {
        main="Iztaasu +2", sub="Ice Shield", ammo="Morion Tathlum",
        head="Hagondes Hat +1", neck="Incanter's Torque", left_ear={ name="Moonshade Earring", augments={'Attack+4','Latent effect: "Regain"+1',}}, right_ear="Giant's Earring",
        body="Orvail Robe +1", hands="Yaoyotl Gloves", left_ring="Rajas Ring", right_ring="Weather. Ring",
        back="Buquwik Cape", waist="Salire Belt", legs="Wayfarer Slops", feet="Kandza Crackows",
    }
    
    sets.Engaged ={
        main="Iztaasu +2", sub="Ice Shield", ammo="Morion Tathlum",
        head="Hagondes Hat +1", neck="Incanter's Torque", left_ear={ name="Moonshade Earring", augments={'Attack+4','Latent effect: "Regain"+1',}}, right_ear="Giant's Earring",
        body="Wayfarer Robe", hands="Yaoyotl Gloves", left_ring="Rajas Ring", right_ring="Weather. Ring",
        back="Buquwik Cape", waist="Salire Belt", legs="Wayfarer Slops", feet="Kandza Crackows",
    }

    sets.Casting = set_combine(sets.Engaged, {
        neck="Incanter's Torque"
    })

    sets.Spells = {}
    sets.Spells.Cure = {main='Tamaxchi', back="Pahtli Cape", }

    set_global_aliases()
    set_aliases()
    set_trusts()
end



function precast(spell)
    if spell.type:endswith('Magic') then
        new_set = sets.Casting
        -- Spell Species
        if spell.name:startswith('Cure') then
            new_set = set_combine(new_set, sets.Spells.Cure)
        end
        equip(new_set)
    end
end

function midcast(spell)
    
end

function aftercast(spell)
    for buff_id, re_buff in pairs(ALWAYS_BUFF) do
        if not buffactive[tonumber(buff_id)] then
            send_command("wait 4; input /ma " .. re_buff .. " <me>;")
            break
        end
    end
end

function status_change(new, old)
   equip(sets[new]) 
end

function self_command(command)
    if command == 'lock' then
        disable('main', 'sub', 'ammo', 'range')
        add_to_chat(3, 'Locked main/sub/ammo/range')
    elseif command == 'unlock' then
        enable('main', 'sub', 'ammo', 'range')
        add_to_chat(4, 'Unlocked main/sub/ammo/range')
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