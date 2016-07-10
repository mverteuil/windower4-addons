--[[ Kensai - Scholar ]]--

require('sets')
require('strings')

--[[ Zone IDs ]]

ADOULIN = S{256, 257}
DYNAMIS = S{42}
SANDORIA = S{230, 231, 232, 233}

--[[ Utilities ]]--

local function to_windower_api(str)
    return str:lower():gsub(" ","_")
end

--[[ GearSwap Defined Callbacks ]]--

-- Called once on load to initialize `sets`
function get_sets()
    set_language("english")
    
    staves = {
        "Eminent Staff",
        { name="Slaine", augments={'Attack+3',}},
        "Crook",
    }
    current_staff = 1

    sets = {}
    
    --{{ Idle Gear }}--
    sets.Idle = {
        main=staves[current_staff], sub="Axe Grip", ammo="Morion Tathlum",
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
    sets.Spells.Cure = {main='Iridialyo Staff', back="Pahtli Cape", }

    --{{ Movement Speed Gear }}--
    sets.movement = {}
    sets.movement.adoulin = {body="Councilor's Garb"}
    sets.movement.sandoria = {body="Kingdom Aketon"}

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


--[ Additional Event Handlers ]--

windower.register_event('zone change', function (new_id, old_id)
    send_command('wait 5;input /echo ZONE ID '..new_id)

    -- Build movement set by area
    if ADOULIN:contains(new_id) then
        movement_set = set_combine(sets.Idle, sets.movement.adoulin)
    elseif SANDORIA:contains(new_id) then
        movement_set = set_combine(sets.Idle, sets.movement.sandoria)
    else
        movement_set = sets.Idle
    end
    -- Apply the movement set
    equip(movement_set)
    set_trusts()
end)

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
    send_command("alias stp_m13 input /cure4 me")

    send_command("alias stp_m14 input /valaineral")
    send_command("alias stp_m15 input /zeid2")
    send_command("alias stp_m16 input /shantotto2")
    send_command("alias stp_m17 input /arciela2")
    send_command("alias stp_m18 input /ulmia")
    send_command("alias stp_m19 input /qultada")
    send_command("alias stp_m20 input /pieujeuc")
    send_command("alias stp_m21 input /elivira")

    send_command("alias si input /sneak;wait 7;/invisible;")
end

function set_trusts()
    local current_zone = windower.ffxi.get_info().zone
    local trusts = nil
    if DYNAMIS:contains(current_zone) then
        trusts = {
            'NanaaMihgo',
            'MihliAliapoh',
            'Leonoyne',
            'UkaTotlihn',
            'Tenzen',
            'Ulmia',
            'PieujeUC',
            'Kupipi',
        }

    else
        trusts = {
            'Valaineral',
            'ExcenmilleS',
            'Korumoru',
            'ShantottoII',
            'ZeidII',
            'Qultada',
            'PieujeUC',
            'Kupipi',
        }
    end
    send_command("alias stp_m14 input /" .. trusts[1])
    send_command("alias stp_m15 input /" .. trusts[2])
    send_command("alias stp_m16 input /" .. trusts[3])
    send_command("alias stp_m17 input /" .. trusts[4])
    send_command("alias stp_m18 input /" .. trusts[5])
    send_command("alias stp_m19 input /" .. trusts[6])
    send_command("alias stp_m20 input /" .. trusts[7])
    send_command("alias stp_m21 input /" .. trusts[8])
end