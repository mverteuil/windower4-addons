--[[
Copyright 2014 Seth VanHeulen

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version. 

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

-- addon information

_addon.name = 'fisher'
_addon.version = '3.4.1'
_addon.command = 'fisher'
_addon.author = 'Seth VanHeulen (Acacia@Odin)'

-- modules

config = require('config')
res = require('resources')
require('pack')
require('sets')
require('strings')
require('tables')

-- default settings

defaults = {}
defaults.chat = 1
defaults.log = -1
defaults.random = false
defaults.equip = false
defaults.move = false
defaults.senses = true
defaults.delay = {}
defaults.delay.release = 1
defaults.delay.cast = 4
defaults.delay.equip = 2
defaults.delay.move = 2
defaults.fatigue = {}
defaults.fatigue.date = os.date('!%Y-%m-%d', os.time() + 32400)
defaults.fatigue.remaining = 200
defaults.didnotcatchmax = 20
defaults.fish = {}

-- global variables

fish = T{}
bait = S{}
stats = {casts=0, bites=0, catches=0, didnotcatchcount=0}

running = false
log_file = nil

-- load message constants

require('messages')

-- logging functions

function message(level, message)
    local prefix = 'E'
    local color = 167
    if level == 1 then
        prefix = 'W'
        color = 200
    elseif level == 2 then
        prefix = 'I'
        color = 207
    elseif level == 3 then
        prefix = 'D'
        color = 160
    end
    if settings.log >= level then
        if log_file == nil then
            log_file = io.open('%sdata/%s.log':format(windower.addon_path, windower.ffxi.get_player().name), 'a')
        end
        if log_file == nil then
            settings.log = -1
            windower.add_to_chat(167, 'unable to open log file')
        else
            log_file:write('%s | %s | %s\n':format(os.date(), prefix, message))
            log_file:flush()
        end
    end
    if settings.chat >= level then
        windower.add_to_chat(color, message)
    end
end

-- equipment helper functions

function check_rod()
    local items = windower.ffxi.get_items()
    message(2, 'checking equipped fishing rod')
    if items.equipment.range == 0 then
        message(3, 'item slot: 0')
        return true
    elseif items.equipment.range_bag == 0 then
        message(3, 'inventory slot: %d, id: %d':format(items.equipment.range, items.inventory[items.equipment.range].id))
        return res.items[items.inventory[items.equipment.range].id].skill ~= 48
    else
        message(3, 'wardrobe slot: %d, id: %d':format(items.equipment.range, items.wardrobe[items.equipment.range].id))
        return res.items[items.wardrobe[items.equipment.range].id].skill ~= 48
    end
end

function check_bait()
    local items = windower.ffxi.get_items()
    message(2, 'checking equipped bait')
    if items.equipment.ammo == 0 then
        message(3, 'item slot: 0')
        return false
    elseif items.equipment.ammo_bag == 0 then
        message(3, 'inventory slot: %d, id: %d':format(items.equipment.ammo, items.inventory[items.equipment.ammo].id))
        return bait:contains(items.inventory[items.equipment.ammo].id)
    else
        message(3, 'wardrobe slot: %d, id: %d':format(items.equipment.ammo, items.wardrobe[items.equipment.ammo].id))
        return bait:contains(items.wardrobe[items.equipment.ammo].id)
    end
end

function equip_bait()
    for slot,item in pairs(windower.ffxi.get_items().inventory) do
        if type(item) == 'table' and bait:contains(item.id) and item.status == 0 then
            message(1, 'equipping bait')
            message(3, 'inventory slot: %d, id: %d, status: %d':format(slot, item.id, item.status))
            windower.ffxi.set_equip(slot, 3, 0)
            return true
        end
    end
    for slot,item in pairs(windower.ffxi.get_items().wardrobe) do
        if type(item) == 'table' and bait:contains(item.id) and item.status == 0 then
            message(1, 'equipping bait')
            message(3, 'wardrobe slot: %d, id: %d, status: %d':format(slot, item.id, item.status))
            windower.ffxi.set_equip(slot, 3, 8)
            return true
        end
    end
    return false
end

-- inventory helper functions

function check_inventory()
    local items = windower.ffxi.get_items()
    message(2, 'checking inventory space')
    message(3, 'inventory count: %d, max: %d':format(items.count_inventory, items.max_inventory))
    return (items.max_inventory - items.count_inventory) > 1
end

function move_fish()
    local items = windower.ffxi.get_items()
    message(2, 'checking bag space')
    local empty_satchel = items.max_satchel - items.count_satchel
    message(3, 'satchel count: %d, max: %d':format(items.count_satchel, items.max_satchel))
    local empty_sack = items.max_sack - items.count_sack
    message(3, 'sack count: %d, max: %d':format(items.count_sack, items.max_sack))
    local empty_case = items.max_case - items.count_case
    message(3, 'case count: %d, max: %d':format(items.count_case, items.max_case))
    if (empty_satchel + empty_sack + empty_case) == 0 then
        return false
    end
    message(1, 'moving fish to bags')
    local moved = 0
    for slot,item in pairs(items.inventory) do
        if type(item) == 'table' and fish[item.id] ~= nil and item.status == 0 then
            if empty_satchel > 0 then
                windower.ffxi.put_item(5, slot, item.count)
                empty_satchel = empty_satchel - 1
                moved = moved + 1
            elseif empty_sack > 0 then
                windower.ffxi.put_item(6, slot, item.count)
                empty_sack = empty_sack - 1
                moved = moved + 1
            elseif empty_case > 0 then
                windower.ffxi.put_item(7, slot, item.count)
                empty_sack = empty_sack - 1
                moved = moved + 1
            end
        end
    end
    message(3, 'fish moved: %d':format(moved))
    return moved > 0
end

function move_bait()
    local items = windower.ffxi.get_items()
    message(2, 'checking inventory space')
    local empty = items.max_inventory - items.count_inventory
    message(3, 'inventory count: %d, max: %d':format(items.count_inventory, items.max_inventory))
    local count = 20
    if empty < 2 then
        return false
    elseif empty <= count then
        count = math.floor(empty / 2)
    end
    message(1, 'moving bait to inventory')
    local moved = 0
    for slot,item in pairs(items.satchel) do
        if type(item) == 'table' and bait:contains(item.id) and count > 0 then
            windower.ffxi.get_item(5, slot, item.count)
            count = count - 1
            moved = moved + 1
        end
    end
    for slot,item in pairs(items.sack) do
        if type(item) == 'table' and bait:contains(item.id) and count > 0 then
            windower.ffxi.get_item(6, slot, item.count)
            count = count - 1
            moved = moved + 1
        end
    end
    for slot,item in pairs(items.case) do
        if type(item) == 'table' and bait:contains(item.id) and count > 0 then
            windower.ffxi.get_item(7, slot, item.count)
            count = count - 1
            moved = moved + 1
        end
    end
    message(3, 'bait moved: %d':format(moved))
    return moved > 0
end

-- fatigue helper functions

function update_day()
    local today = os.date('!%Y-%m-%d', os.time() + 32400)
    if settings.fatigue.date ~= today then
        settings.fatigue.date = today
        settings.fatigue.remaining = 200
        settings:save('all')
    end
end

function check_fatigued()
    message(2, 'checking fishing fatigue')
    update_day()
    message(2, 'catches until fatigued: %d':format(settings.fatigue.remaining))
    return settings.fatigue.remaining == 0
end

function update_fatigue()
    message(2, 'updating fishing fatigue')
    settings.fatigue.remaining = settings.fatigue.remaining - current.count
    message(3, 'catches until fatigued: %d':format(settings.fatigue.remaining))
    update_fish()
end

-- fish id helper functions

function find_item_id(name)
    item_id = nil
    for key,value in pairs(res.items) do
        if value.name == name then
            if item_id == nil then
                item_id = key
            elseif not value.flags:contains('No Delivery') then
                return key
            end
        end
    end
    return item_id
end

function get_bite_id(id)
    for bite_id,item_id in pairs(settings.fish) do
        if item_id == id then
            return tonumber(bite_id)
        end
    end
    return nil
end

function update_fish()
    message(2, 'updating fish database')
    if fish[current.item_id] ~= nil then
        fish[current.item_id].bite_id = current.bite_id
    elseif fish:with('bite_id', current.bite_id) then
        fish:with('bite_id', current.bite_id).bite_id = nil
    end
    settings.fish[tostring(current.bite_id)] = current.item_id
    message(3, 'updated fish bite id: %d, item id: %d':format(current.bite_id, current.item_id))
    settings:save('all')
end

-- action functions

function catch(casts)
    if running and stats.casts == tonumber(casts) then
        local player = windower.ffxi.get_player()
        message(1, 'sending catch command')
        windower.packets.inject_outgoing(0x110, 'IIIHH':pack(0xB10, player.id, 0, player.index, 3) .. current.key)
    end
end

function release(casts)
    if running and stats.casts == tonumber(casts) then
        local player = windower.ffxi.get_player()
        message(1, 'sending release command')
        windower.packets.inject_outgoing(0x110, 'IIIHHI':pack(0xB10, player.id, 200, player.index, 3, 0))
    end
end

function cast()
    if running then
		if stats.didnotcatchcount >= settings.didnotcatchmax then
			message(0, 'reached maximum number of casts')
			fisher_command('stop')
        elseif check_fatigued() then
            message(0, 'reached fishing fatigue')
            fisher_command('stop')
        elseif check_rod() then
            message(0, 'no fishing rod equipped')
            fisher_command('stop')
        elseif check_inventory() then
            if check_bait() then
                message(1, 'casting fishing rod')
                windower.send_command('input /fish')
            elseif settings.equip and equip_bait() then
                message(2, 'casting in %d seconds':format(settings.delay.equip))
                windower.send_command('wait %d; lua i fisher cast':format(settings.delay.equip))
            elseif settings.move and move_bait() then
                message(2, 'casting in %d seconds':format(settings.delay.move))
                windower.send_command('wait %d; lua i fisher cast':format(settings.delay.move))
            else
                message(0, 'out of bait')
                fisher_command('stop')
            end
        elseif settings.move and move_fish() then
            message(2, 'casting in %d seconds':format(settings.delay.move))
            windower.send_command('wait %d; lua i fisher cast':format(settings.delay.move))
        else
            message(0, 'inventory is full')
            fisher_command('stop')
        end
    end
end

-- event callback functions

function check_action(action)
    if running then
        local player_id = windower.ffxi.get_player().id
        for _,target in pairs(action.targets) do
            if target.id == player_id then
                message(0, 'action performed on you')
                message(3, 'action category: %d, actor: %d':format(action.category, action.actor_id))
                fisher_command('stop')
                return
            end
        end
    end
end

function check_status_change(new_status_id, old_status_id)
    if running then
        message(0, 'status was changed')
        message(3, 'status new: %d, old: %d':format(new_status_id, old_status_id))
        fisher_command('stop')
    end
end

function check_chat_message(message, sender, mode, gm)
    if running and gm then
        message(0, 'received message from gm')
        message(3, 'chat from: %s, mode: %d':format(sender, mode))
        fisher_command('stop')
    end
end

function check_incoming_text(original, modified, original_mode, modified_mode, blocked)
    if running and (original:find('You cannot fish here.') ~= nil or original:find('You cannot use that command at this time.') ~= nil) then
        message(3, 'recieved error text')
        if error_retry then
            error_retry = false
			message(2, 'casting in %.2f seconds':format(settings.delay.cast + (settings.random and math.random() or 0.0)))
			windower.send_command('wait %.2f; lua i fisher cast':format(settings.delay.cast + (settings.random and math.random() or 0.0)))
		else
            message(0, 'unable to fish')
            fisher_command('stop')
        end
	elseif running and original:find('You didn\'t catch anything.') then
		message(2, 'No catch detected.')
		stats.didnotcatchcount = stats.didnotcatchcount + 1
    end
end

function check_incoming_chunk(id, original, modified, injected, blocked)
    if running then
        if id == 0x36 then
            local zone_id = windower.ffxi.get_info().zone
            local message_id = original:unpack('H', 11) % 0x8000
            if messages[zone_id].small == message_id or messages[zone_id].large == message_id or messages[zone_id].item == message_id then
                message(3, 'incoming fish hooked: ' .. original:hex())
                current.monster = false
            elseif messages[zone_id].monster == message_id then
                message(3, 'incoming monster hooked: ' .. original:hex())
                current.monster = true
            elseif messages[zone_id].time == message_id then
                message(3, 'incoming time warning: ' .. original:hex())
                catch(stats.casts)
            end
        elseif id == 0x2A then
            local zone_id = windower.ffxi.get_info().zone
            local message_id = original:unpack('H', 27) % 0x8000
            if messages[zone_id].senses == message_id then
                message(3, 'incoming fish intuition: ' .. original:hex())
                current.item_id = original:unpack('I', 9)
            end
        elseif id == 0x115 then
            message(3, 'incoming fish info: ' .. original:hex())
            current.bite_id = original:unpack('I', 11)
            if current.item_id ~= nil then
                update_fish()
            elseif settings.senses and settings.fish[tostring(current.bite_id)] then
                local player = windower.ffxi.get_player()
                local zone_id = windower.ffxi.get_info().zone
                windower.packets.inject_incoming(0x2A, 'IIIIIIHHI':pack(0x102A, player.id, settings.fish[tostring(current.bite_id)], 0, 0, 0, player.index, messages[zone_id].senses + 0x8000, 0))
            end
            if current.monster == false and fish:with('bite_id', current.bite_id) then
                current.key = original:sub(21)
                stats.bites = stats.bites + 1
                local delay = fish:with('bite_id', current.bite_id).delay + (settings.random and 1.0 - math.random()*2 or 0.0)
				message(2, 'catching fish in %.2f seconds':format(delay))
				windower.send_command('wait %.2f; lua i fisher catch %.2f':format(delay, stats.casts))
            elseif current.monster == false and fish:with('bite_id', nil) and settings.fish[tostring(current.bite_id)] == nil then
                current.key = original:sub(21)
                stats.bites = stats.bites + 1
                message(2, 'catching fish when low on time')
            else
				local releasedelay = settings.delay.release + (settings.random and math.random() or 0.0)
				message(2, 'releasing fish in %.2f seconds':format(releasedelay))
				windower.send_command('wait %.2f; lua i fisher release %d':format(releasedelay, stats.casts))
            end
        elseif id == 0x27 and windower.ffxi.get_player().id == original:unpack('I', 5) then
            local zone_id = windower.ffxi.get_info().zone
            local message_id = original:unpack('H', 11) % 0x8000
            if messages[zone_id].mcaught == message_id or messages[zone_id].caught == message_id or messages[zone_id].full == message_id then
                message(3, 'incoming fish caught: ' .. original:hex())
                current.item_id = original:unpack('I', 17)
                if messages[zone_id].mcaught == message_id then
                    current.count = original:byte(21)
                else
                    current.count = 1
                end
                stats.catches = stats.catches + 1
				stats.didnotcatchcount = 0
                update_fatigue()
            end
        elseif id == 0x37 then
            local new_status = original:byte(49)
            if new_status == 56 and old_status ~= 56 then
                message(3, 'status changed to fishing')
                current = {}
                stats.casts = stats.casts + 1
                error_retry = true
            elseif new_status == 0 and old_status ~= 0 then
                message(3, 'status changed to idle')
				local castdelay = settings.delay.cast + (settings.random and math.random() or 0.0)
				message(2, 'casting in %.2f seconds':format(castdelay))
				windower.send_command('wait %.2f; lua i fisher cast':format(castdelay))
            end
            old_status = new_status
        end
    end
end

function check_outgoing_chunk(id, original, modified, injected, blocked)
    if running then
        if id == 0x1A then
            if original:unpack('H', 11) == 14 then
                message(3, 'outgoing fish command: ' .. original:hex())
            else
                message(0, 'performed an action')
                fisher_command('stop')
            end
        elseif id == 0x110 then
            message(3, 'outgoing fishing action: ' .. original:hex())
        end
    end
end

function check_login(name)
    settings = config.load('data/%s.xml':format(name), defaults)
end

function check_logout(name)
    settings:save('all')
end

function check_load()
    if windower.ffxi.get_info().logged_in then
        settings = config.load('data/%s.xml':format(windower.ffxi.get_player().name), defaults)
    end
end

function check_unload()
    settings:save('all')
    if running then
        fisher_command('stop')
    end
end

-- command functions

function fish_command(arg)
    if #arg == 4 and arg[2]:lower() == 'add' then
        local item_id = tonumber(arg[3])
        if item_id == nil then
            item_id = find_item_id(arg[3])
            if item_id == nil then
                windower.add_to_chat(167, 'invalid fish name or item id')
                return
            end
        end
        local delay = tonumber(arg[4])
        if delay == nil then
            windower.add_to_chat(167, 'invalid cast delay time')
            return
        end
        fish[item_id] = {delay=delay, bite_id=get_bite_id(item_id)}
        windower.add_to_chat(204, 'added fish:')
        windower.add_to_chat(204, '  name: %s, item id: %d, delay: %d, bite id: %s':format(res.items[item_id].name:lower(), item_id, delay, fish[item_id].bite_id or 'unknown'))
    elseif #arg == 3 and arg[2]:lower() == 'remove' then
        local item_id = tonumber(arg[3])
        if item_id == nil then
            item_id = find_item_id(arg[3])
            if item_id == nil then
                windower.add_to_chat(167, 'invalid fish name or item id')
                return
            end
        end
        fish[item_id] = nil
        windower.add_to_chat(204, 'removed fish:')
        windower.add_to_chat(204, '  name: %s, item id: %d':format(res.items[item_id].name:lower(), item_id))
    elseif #arg == 2 and arg[2]:lower() == 'clear' then
        windower.add_to_chat(204, 'removed all fish')
        fish:clear()
    elseif #arg == 2 and arg[2]:lower() == 'list' then
        windower.add_to_chat(204, 'fish list:')
        for item_id,value in pairs(fish) do
            windower.add_to_chat(204, '  name: %s, item id: %d, delay: %d, bite id: %s':format(res.items[item_id].name:lower(), item_id, value.delay, value.bite_id or 'unknown'))
        end
    else
        windower.add_to_chat(167, 'usage:')
        windower.add_to_chat(167, '  fisher fish add <name or item id> <catch delay>')
        windower.add_to_chat(167, '  fisher fish remove <name or item id>')
        windower.add_to_chat(167, '  fisher fish clear')
        windower.add_to_chat(167, '  fisher fish list')
    end
end

function bait_command(arg)
    if #arg == 3 and arg[2]:lower() == 'add' then
        local item_id = tonumber(arg[3])
        if item_id == nil then
            _,item_id = res.items:with('name', arg[3])
            if item_id == nil then
                windower.add_to_chat(167, 'invalid bait name or item id')
                return
            end
        end
        if res.items[item_id].type == 4 and res.items[item_id].skill == 48 and res.items[item_id].slots[3] then
            bait:add(item_id)
            windower.add_to_chat(204, 'added bait:')
            windower.add_to_chat(204, '  name: %s, item id: %d':format(res.items[item_id].name:lower(), item_id))
        else
            windower.add_to_chat(167, 'invalid bait name or item id')
        end
    elseif #arg == 3 and arg[2]:lower() == 'remove' then
        local item_id = tonumber(arg[3])
        if item_id == nil then
            _,item_id = res.items:with('name', arg[3])
            if item_id == nil then
                windower.add_to_chat(167, 'invalid bait name or item id')
                return
            end
        end
        if res.items[item_id].type == 4 and res.items[item_id].skill == 48 and res.items[item_id].slots[3] then
            bait:remove(item_id)
            windower.add_to_chat(204, 'removed bait:')
            windower.add_to_chat(204, '  name: %s, item id: %d':format(res.items[item_id].name:lower(), item_id))
        else
            windower.add_to_chat(167, 'invalid bait name or item id')
        end
    elseif #arg == 2 and arg[2]:lower() == 'clear' then
        windower.add_to_chat(204, 'removed all bait')
        bait:clear()
    elseif #arg == 2 and arg[2]:lower() == 'list' then
        windower.add_to_chat(204, 'bait list:')
        for item_id,_ in pairs(bait) do
            windower.add_to_chat(204, '  name: %s, item id: %d':format(res.items[item_id].name:lower(), item_id))
        end
    else
        windower.add_to_chat(167, 'usage:')
        windower.add_to_chat(167, '  fisher bait add <name or item id>')
        windower.add_to_chat(167, '  fisher bait remove <name or item id>')
        windower.add_to_chat(167, '  fisher bait clear')
        windower.add_to_chat(167, '  fisher bait list')
    end
end

function fisher_command(...)
    if windower.ffxi.get_info().logged_in == false then
        windower.add_to_chat(167, 'not logged in')
        return
    end
    if #arg >= 1 and arg[1]:lower() == 'fish' then
        fish_command(arg)
    elseif #arg >= 1 and arg[1]:lower() == 'bait' then
        bait_command(arg)
    elseif #arg == 1 and arg[1]:lower() == 'start' then
        if running then
            windower.add_to_chat(167, 'already fishing')
            return
        end
        old_status = windower.ffxi.get_player().status
        if old_status ~= 0 then
            windower.add_to_chat(167, 'status is not idle')
            return
        end
        if fish:empty() or bait:empty() then
            windower.add_to_chat(167, 'no fish or bait configured')
            return
        end
        error_retry = true
        running = true
        message(1, 'started fishing')
        cast()
    elseif #arg == 1 and arg[1]:lower() == 'stop' then
        if not running then
            windower.add_to_chat(167, 'not fishing')
            return
        end
        running = false
        message(1, 'stopped fishing')
        if log_file ~= nil then
            log_file:close()
            log_file = nil
        end
    elseif #arg == 2 and arg[1]:lower() == 'chat' then
        settings.chat = tonumber(arg[2]) or 1
        windower.add_to_chat(204, 'chat message level: %s':format(settings.chat >= 0 and settings.chat or 'off'))
        settings:save('all')
    elseif #arg == 2 and arg[1]:lower() == 'log' then
        settings.log = tonumber(arg[2]) or -1
        windower.add_to_chat(204, 'log message level: %s':format(settings.log >= 0 and settings.log or 'off'))
        settings:save('all')
        if settings.log < 0 and log_file ~= nil then
            log_file:close()
            log_file = nil
        end
    elseif #arg == 2 and arg[1]:lower() == 'equip' then
        settings.equip = (arg[2]:lower() == 'on')
        windower.add_to_chat(204, 'equip bait: %s':format(settings.equip and 'on' or 'off'))
        settings:save('all')
    elseif #arg == 2 and arg[1]:lower() == 'move' then
        settings.move = (arg[2]:lower() == 'on')
        windower.add_to_chat(204, 'move bait and fish: %s':format(settings.move and 'on' or 'off'))
        settings:save('all')
    elseif #arg == 2 and arg[1]:lower() == 'senses' then
        settings.senses = (arg[2]:lower() == 'on')
        windower.add_to_chat(204, 'display hooked fish: %s':format(settings.senses and 'on' or 'off'))
        settings:save('all')
    elseif #arg == 1 and arg[1]:lower() == 'resetdb' then
        settings.fish = {}
        settings:save('all')
        for _,value in pairs(fish) do
            value.bite_id = nil
        end
        windower.add_to_chat(204, 'reset fish database')
    elseif #arg == 1 and arg[1]:lower() == 'stats' then
        local losses = stats.bites - stats.catches
        local bite_rate = 0
        local loss_rate = 0
        local catch_rate = 0
        if stats.casts ~= 0 then
            bite_rate = (stats.bites / stats.casts) * 100
            loss_rate = (losses / stats.casts) * 100
            catch_rate = (stats.catches / stats.casts) * 100
        end
        local loss_bite_rate = 0
        local catch_bite_rate = 0
        if stats.bites ~= 0 then
            loss_bite_rate = (losses / stats.bites) * 100
            catch_bite_rate = (stats.catches / stats.bites) * 100
        end
        if running == false then
            update_day()
        end
        windower.add_to_chat(204, 'casts: %d, remaining fatigue: %d':format(stats.casts, settings.fatigue.remaining))
        windower.add_to_chat(204, 'bites: %d, bite rate: %d%%':format(stats.bites, bite_rate))
        windower.add_to_chat(204, 'catches: %d, catch rate: %d%%, catch/bite rate: %d%%':format(stats.catches, catch_rate, catch_bite_rate))
        windower.add_to_chat(204, 'losses: %d, loss rate: %d%%, loss/bite rate: %d%%':format(losses, loss_rate, loss_bite_rate))
		windower.add_to_chat(204, 'did not catch count: %d/%d':format(stats.didnotcatchcount, settings.didnotcatchmax))
    elseif #arg == 2 and arg[1]:lower() == 'stats' and arg[2]:lower() == 'clear' then
        stats = {casts=0, bites=0, catches=0, didnotcatchcount=0}
        windower.add_to_chat(204, 'reset fishing statistics')
    elseif #arg == 2 and arg[1]:lower() == 'fatigue' then
        local count = tonumber(arg[2])
        if count == nil then
            message(0, 'invalid count')
        elseif count < 0 then
            if running == false then
                update_day()
            end
            settings.fatigue.remaining = settings.fatigue.remaining + count
            windower.add_to_chat(204, 'remaining fatigue: %d':format(settings.fatigue.remaining))
            settings:save('all')
        else
            settings.fatigue.remaining = count
            windower.add_to_chat(204, 'remaining fatigue: %d':format(settings.fatigue.remaining))
            settings:save('all')
        end
	elseif #arg == 2 and arg[1]:lower() == 'random' then
		settings.random = (arg[2]:lower() == 'on')
        windower.add_to_chat(204, 'random catch time: %s':format(settings.random and 'on' or 'off'))
        settings:save('all')
	elseif #arg == 2 and arg[1]:lower() == 'dncmax' then
		settings.didnotcatchmax = tonumber(arg[2])
		settings:save('all')
    else
        windower.add_to_chat(167, 'usage:')
        windower.add_to_chat(167, '  fisher fish ...')
        windower.add_to_chat(167, '  fisher bait ...')
        windower.add_to_chat(167, '  fisher start')
        windower.add_to_chat(167, '  fisher stop')
        windower.add_to_chat(167, '  fisher chat <level>')
        windower.add_to_chat(167, '  fisher log <level>')
        windower.add_to_chat(167, '  fisher equip <on/off>')
        windower.add_to_chat(167, '  fisher move <on/off>')
        windower.add_to_chat(167, '  fisher senses <on/off>')
        windower.add_to_chat(167, '  fisher fatigue <count>')
        windower.add_to_chat(167, '  fisher stats [clear]')
        windower.add_to_chat(167, '  fisher resetdb')
		windower.add_to_chat(167, '  fisher random <on/off>')
		windower.add_to_chat(167, '  fisher dncmax <count>')
    end
end

-- register event callbacks

windower.register_event('action', check_action)
windower.register_event('status change', check_status_change)
windower.register_event('chat message', check_chat_message)
windower.register_event('incoming text', check_incoming_text)
windower.register_event('incoming chunk', check_incoming_chunk)
windower.register_event('outgoing chunk', check_outgoing_chunk)
windower.register_event('login', check_login)
windower.register_event('logout', check_logout)
windower.register_event('load', check_load)
windower.register_event('unload', check_unload)
windower.register_event('addon command', fisher_command)
