--[[ Kensai - Red Mage ]]--

--[[ Zone IDs for Movement Speed Gear ]]

ADOULIN = {256, 257}
SANDORIA = {230, 231, 232, 233}

--[[ Utilities ]]--

local function to_windower_api(str)
    return str:lower():gsub(" ","_")
end

local function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

--[[ GearSwap Defined Callbacks ]]--

-- Called once on load to initialize `sets`
function get_sets()
    set_language("english")
    sets = {}
    
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

    --{{ Movement Speed Gear }}--
    sets.movement = {}
    sets.movement.adoulin = {body="Councilor's Garb"}
    sets.movement.sandoria = {body="Kingdom Aketon"}

    -- Macros Be Here
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
    send_command("alias g13_m1g16 input /haste2 st")
    send_command("alias g13_m1g17 input /refresh2 st")
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
    send_command("alias stp_m14 input /valaineral")
    send_command("alias stp_m15 input /zeid2")
    send_command("alias stp_m16 input /shantotto2")
    send_command("alias stp_m17 input /korumoru")
    send_command("alias stp_m18 input /ulmia")
    send_command("alias stp_m19 input /qultada")
    send_command("alias stp_m20 input /ayame uc")
    send_command("alias stp_m21 input /kupipi")

    send_command("alias si input /sneak;wait 7;/invisible;")

 end

windower.register_event('zone change', function (new_id, old_id)
    send_command('wait 5;input /echo ZONE ID '..new_id)
    -- Create the movement set
    if contains(ADOULIN, new_id) then
        movement_set = set_combine(sets.Idle, sets.movement.adoulin)
    elseif contains(SANDORIA, new_id) then
        movement_set = set_combine(sets.Idle, sets.movement.sandoria)
    else
        movement_set = sets.Idle
    end
    -- Apply the movement set
    equip(movement_set)
end)

function precast(spell)
    
end

function midcast(spell)
    
end

function aftercast(spell)
    
end

function status_change(new, old)
   equip(sets[new]) 
end

function self_command(command)

end