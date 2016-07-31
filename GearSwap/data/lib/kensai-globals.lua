require('sets')
require('strings')

--[[ Zone IDs ]]

ADOULIN = S{256, 257}
SANDORIA = S{230, 231, 232, 233}

function alias_kensai_globals()
    send_command("alias si input /sneak;wait 7;/invisible;")
    send_command("alias warp input /equip R.ring \"Warp Ring\"; wait 9; input /item \"Warp Ring\" <me>;")
    send_command("alias echad input /equip R.ring \"Echad Ring\"; wait 9; input /item \"Echad Ring\" <me>;")
    send_command("alias empress input /equip R.ring \"Empress Ring\"; wait 9; input /item \"Empress Band\" <me>;")
    send_command("alias trizek input /equip R.ring \"Trizek Ring\"; wait 9; input /item \"Trizek Ring\" <me>;")   
end

--[ Additional Event Handlers ]--

windower.register_event('zone change', function (new_id, old_id)
    add_to_chat(22,'zone')
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

function set_common_sets()
    --{{ Movement Speed Gear }}--
    sets.movement = {}
    sets.movement.adoulin = { body="Councilor's Garb" }
    sets.movement.sandoria = { body="Kingdom Aketon" }
end


function set_trusts()
    if world.area:startswith("Dynamis") then
        trusts = {
            "NanaaMihgo",
            "MihliAliapoh",
            "Leonoyne",
            "UkaTotlihn",
            "Tenzen",
            "Ulmia",
            "PieujeUC",
            "Kupipi",
        }

    else
        trusts = TRUSTS or {
            "August",
            "ExcenmilleS",
            "Arciela",
            "ShantottoII",
            "ZeidII",
            "Qultada",
            "PieujeUC",
            "Margret",
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