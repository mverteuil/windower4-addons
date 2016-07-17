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

_addon.name = 'truesight'
_addon.version = '1.0.1'
_addon.command = 'truesight'
_addon.author = 'Seth VanHeulen (Acacia@Odin)'

function bit(p)
    return 2 ^ p
end

function checkbit(x, p)
    return x % (p + p) >= p
end

function clearbit(x, p)
    return checkbit(x, p) and x - p or x
end

function string.clearbits(s, p, c)
    if c and c > 1 then
        s = s:clearbits(p + 1, c - 1)
    end
    local b = math.floor(p / 8)
    return s:sub(1, b) .. string.char(clearbit(s:byte(b + 1), bit(p % 8))) .. s:sub(b + 2)
end

function check_incoming_chunk(id, original, modified, injected, blocked)
    if id == 0x0E then
        return original:clearbits(257, 2)
    elseif id == 0x38 and original:sub(13, 16) == 'kesu' then
        return true
    end
end

windower.register_event('incoming chunk', check_incoming_chunk)
