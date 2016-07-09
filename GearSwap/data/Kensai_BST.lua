--[[ Kensai - Red Mage ]]--

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

    sets = {}
    sets.axe = {}
    sets.axe.Idle = {
        main="Faizzeer +2", ranged="Composite Bow", ammo="Silver Arrow",
        head="Yaoyotl Helm", neck="Chivalrous Chain", left_ear={ name="Moonshade Earring", augments={'Attack+4','Latent effect: "Regain"+1',}}, right_ear="Bladeborn Earring",
        body="Espial Gambison", hands="Espial Bracers", left_ring="Woodsman Ring", right_ring="Rajas Ring",
        back="Buquwik Cape", waist="Hurch'lan Sash", legs="Outrider Hose", feet="Espial Socks",
    }


    sets.scythe = {}
    sets.scythe.Idle = set_combine(sets.axe.Idle, {
        main="Eminent Sickle", sub="Axe Grip",
    })

    --{{ Movement Speed Gear }}--
    sets.movement = {}
    sets.movement.adoulin = {body="Councilor's Garb"}
    sets.movement.sandoria = {body="Kingdom Aketon"}

    --{{ Weapon Skills By Weapon }}--
    ws_by_weapon = {}
    ws_by_weapon.axe = {'Rampage', 'MistralAxe', 'BoraAxe'}
    ws_by_weapon.scythe = {'VorpalScythe', 'SpinningScythe', 'NightmareScythe'}

    self_command('axe')
end

windower.register_event('zone change', function (new_id, old_id)
    send_command('wait 5;input /echo ZONE ID '..new_id)
    current_idle_set = sets[current_weapon].Idle
    -- Create the movement set
    if ADOULIN:contains(new_id) then
        movement_set = set_combine(current_idle_set, sets.movement.adoulin)
    elseif SANDORIA:contains(new_id) then
        movement_set = set_combine(current_idle_set, sets.movement.sandoria)
    else
        movement_set = current_idle_set
    end
    -- Apply the movement set
    equip(movement_set)

    -- Set trusts based on zone
    set_trusts()
end)

function precast(spell)
    
end

function midcast(spell)
    
end

function aftercast(spell)
    
end

windower.register_event('target change', function(mob_idx)
    if windower.ffxi.get_player().status == 1 then
        bt = windower.ffxi.get_mob_by_target('bt')
        send_command("input /echo ".. bt.name)    
    end
end)

function status_change(new, old)
    if new == "Engaged" then
        local pet = windower.ffxi.get_mob_by_target('pet')
        if pet and pet.name and pet.status == 0 then
            send_command("wait 1; input /fight")
        end
    end
end

function set_aliases(weapon)
    send_command("alias g13_m1g1 input /callbeast")
    send_command("alias g13_m1g2 input /bestialloyalty")
    send_command("alias g13_m1g3 input /gauge")
    send_command("alias g13_m1g4 input /charm")
    send_command("alias g13_m1g5 input /tame")
    send_command("alias g13_m1g6 input /reward")
    send_command("alias g13_m1g7 input /feralhowl")
    send_command("alias g13_m1g8 input /equip ammo 'Pale Sap'; input /echo Hurler Percival (Beetle)")
    send_command("alias g13_m1g9 input /equip ammo 'Airy Broth'; input /echo Amiable Roche (Black Pugil)")
    send_command("alias g13_m1g10 input /equip ammo 'Slimy Webbing'; input /echo Gussy Hachirobe (Spider HQ)")
    send_command("alias g13_m1g11 input /equip ammo 'Blackwater Broth'; input /echo Headbreaker Ken (Red Damselfly)")
    send_command("alias g13_m1g12 input /equip ammo 'Sugary Broth'; input /echo Colibri Familiar")
    send_command("alias g13_m1g13 input /equip ammo 'Fizzy Broth'; input /echo Caring Kiyomaro (Boar)")
    send_command("alias g13_m1g14 input /equip ammo 'Pet Food Theta'; input /echo Pet Food")
    send_command("alias g13_m1g15 input /equip ammo 'Salburious Broth'; input /echo Attentive Ibuki (Big Bird)")
    send_command("alias g13_m1g16 input /equip ammo 'Windy Greens'; input /echo Swooping Zhivago (Big Bird HQ)")
    send_command("alias g13_m1g17 input /equip ammo 'Vis. Broth'; input /echo Pondering Peter (Rabbit)")
    send_command("alias g13_m1g18 input /equip ammo 'Spicy Broth'; input /echo Scissorleg Xerin (Grasshopper)")
    send_command("alias g13_m1g19 input /equip ammo 'Shimmering Broth'; input /echo Sunburst Malfik (Crab)")
    send_command("alias g13_m1g20 input /feralhowl")
    send_command("alias g13_m1g21 input /familiar")
    send_command("alias g13_m1g22 input /spur")

    send_command("alias stp_m1 input /bstpet 1")
    send_command("alias stp_m2 input /bstpet 2")
    send_command("alias stp_m3 input /bstpet 3")
    send_command("alias stp_m4 input /bstpet 4")
    send_command("alias stp_m5 input /bstpet 5")
    send_command("alias stp_m6 input /" .. ws_by_weapon[weapon][1])
    send_command("alias stp_m7 input /" .. ws_by_weapon[weapon][3])

    send_command("alias stp_m11 input /fight")
    send_command("alias stp_m12 input /" .. ws_by_weapon[weapon][2])
    send_command("alias stp_m13 input /heel")

    subjob = windower.ffxi.get_player().sub_job
    if subjob == 'WAR' then
        send_command("alias stp_m8 input /berserk")
        send_command("alias stp_m9 input /warcry")
        send_command("alias stp_m10 input /defender")
    elseif subjob == 'DNC' then
        send_command("alias stp_m8 input /drainsamba2")
        send_command("alias stp_m9 input /boxstep")
        send_command("alias stp_m10 input /curingwaltz3 st")
        
        send_command("alias si input /spectraljig")
    elseif subjob == 'THF' then
        send_command("alias stp_m8 input /steal")
        send_command("alias stp_m9 input /sneakattack")
        send_command("alias stp_m10 input /flee")
    end
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
            'Halver',
            'ExcenmilleS',
            'Lilisette',
            'ShantottoII',
            'Ulmia',
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

function self_command(command)
    if command == 'scythe' then
        current_weapon = 'scythe'
    elseif command == 'axe' then
        current_weapon = 'axe'
    end

    set_aliases(current_weapon)
    set_trusts()
    equip(sets[current_weapon].Idle)
end