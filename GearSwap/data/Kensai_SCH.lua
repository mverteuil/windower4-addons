--[[ Kensai - Scholar ]]--

require('sets')
require('strings')
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

--[[ Utilities ]]--

local function to_windower_api(str)
    return str:lower():gsub(" ","_")
end

--[[ GearSwap Defined Callbacks ]]--

-- Called once on load to initialize `sets`
function get_sets()
    set_language("english")
    
    sets = {}
    
    --{{ Idle Gear }}--
    sets.Idle = {}
    sets.Idle = {
        main="Eminent Staff", sub="Vivid Strap", ammo="Morion Tathlum",
        head="Hagondes Hat +1", neck="Caract Choker", left_ear="Moldavite Earring", right_ear={ name="Moonshade Earring", augments={'Attack+4','Latent effect: "Regain"+1',}},
        body="Orvail Robe +1", hands="Yaoyotl Gloves", left_ring="Acumen Ring", right_ring="Weather. Ring",
        back="Bookworm's Cape", waist="Salire Belt", legs="Wayfarer Slops", feet="Kandza Crackows",
    }
    
    sets.Engaged = set_combine(sets.Idle, {
        body="Wayfarer Robe",
    })

    sets.Casting = set_combine(sets.Engaged, {
        neck="Incanter's Torque"
    })

    sets.Spells = {}
    sets.Spells.Cure = {main='Tamaxchi', back="Pahtli Cape", }

    --{{ Movement Speed Gear }}--
    sets.movement = {}
    sets.movement.adoulin = {body="Councilor's Garb"}
    sets.movement.sandoria = {body="Kingdom Aketon"}

    set_global_aliases()
    set_aliases()
    set_trusts()    
end

--[ Windower Events ]--

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
    -- pass
end


function aftercast(spell)
    equip(sets.Engaged)    
end


function status_change(new, old)
    equip(sets[new]) 
end


function self_command(command)
    sets.Idle.main = staves[tonumber(command)]
    sets.Engaged.main = staves[tonumber(command)]
    equip(sets.Idle)
end

--[ User Functions ]--

function set_aliases()
    -- Macros Be Here
    send_command("alias g13_m1g1 input /sandstorm")
    send_command("alias g13_m1g2 input /rainstorm")
    send_command("alias g13_m1g3 input /windstorm")
    send_command("alias g13_m1g4 input /firestorm")
    send_command("alias g13_m1g5 input /hailstorm")
    send_command("alias g13_m1g6 input /thunderstorm")
    send_command("alias g13_m1g7 input /voidstorm")

    send_command("alias g13_m1g8 input /stone4")
    send_command("alias g13_m1g9 input /water4")
    send_command("alias g13_m1g10 input /aero4")
    send_command("alias g13_m1g11 input /fire4")
    send_command("alias g13_m1g12 input /blizzard4")
    send_command("alias g13_m1g13 input /thunder4")
    send_command("alias g13_m1g14 input /aurorastorm")

    send_command("alias g13_m1g15 input /geohelix")
    send_command("alias g13_m1g16 input /hydrohelix")
    send_command("alias g13_m1g17 input /anemohelix")
    send_command("alias g13_m1g18 input /pyrohelix")
    send_command("alias g13_m1g19 input /cryohelix")

    send_command("alias g13_m1g20 input /ionohelix")
    send_command("alias g13_m1g21 input /noctohelix")
    send_command("alias g13_m1g22 input /luminohelix")

    send_command("alias stp_m1 input /addendumwhite")
    send_command("alias stp_m2 input /penury")
    send_command("alias stp_m3 input /celerity")
    send_command("alias stp_m4 input /rapture")
    send_command("alias stp_m5 input /accession")

    send_command("alias stp_m6 input /addendumblack")
    send_command("alias stp_m7 input /parsimony")
    send_command("alias stp_m8 input /alacrity")
    send_command("alias stp_m9 input /ebullience")
    send_command("alias stp_m10 input /manifestation")

    send_command("alias stp_m11 input /sublimation")
    send_command("alias stp_m12 input /darkarts")
    send_command("alias stp_m13 taps cure")
end