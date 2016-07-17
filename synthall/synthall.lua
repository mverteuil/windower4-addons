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
along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]

-- addon information

_addon.name = 'synthall'
_addon.version = '1.0.1'
_addon.command = 'synthall'
_addon.author = 'Seth VanHeulen (Acacia@Odin)'

require('pack')

yes = '\31\204yes\30\1'
no = '\31\167no\30\1'
on = '\31\204on\30\1'
off = '\31\167off\30\1'
results = {[0] = '\31\200success\30\1', [1] = '\31\167break\30\1', [2] = '\31\204high quality\30\1'}

enabled = false
support = true
food = true

function show_status()
    windower.add_to_chat(207, '---- synthall enabled: %s, support: %s, food: %s ----':format(enabled and yes or no, support and on or off, food and on or off))
end

-- event callback functions

function check_lose_buff(buff_id)
    if enabled and support and buff_id >= 236 and buff_id <= 243 then
        enabled = false
        show_status()
    elseif enabled and food and buff_id == 251 then
        enabled = false
        show_status()
    end
end

function check_incoming_text(original, modified, original_mode, modified_mode)
    if enabled and original:find('Synthesis canceled.') == 1 then
        enabled = false
        show_status()
    end
end

function check_incoming_chunk(id, original, modified, injected, blocked)
    if id == 0x30 then
        local id, index, element, result = original:unpack('IHHC', 5)
        if id == windower.ffxi.get_player().id then
            windower.add_to_chat(207, '---- %s ----':format(results[result]))
        end
    elseif id == 0x6F then
        local hq = original:unpack('c', 6)
        if hq > 0 then
            windower.add_to_chat(207, '---- \31\204hq%s\30\1 ----':format(hq))
        end
        if enabled then
            windower.send_command('wait 3.5; input /lastsynth')
        end
    end
end

function synthall_command(...)
    if #arg == 1 then
        if arg[1]:lower() == 'on' then
            enabled = true
        elseif arg[1]:lower() == 'off' then
            enabled = false
        elseif arg[1]:lower() == 'support' then
            support = not support
        elseif arg[1]:lower() == 'food' then
            food = not food
        end
    end
    show_status()
end

-- register event callbacks

windower.register_event('lose buff', check_lose_buff)
windower.register_event('incoming text', check_incoming_text)
windower.register_event('incoming chunk', check_incoming_chunk)
windower.register_event('addon command', synthall_command)
