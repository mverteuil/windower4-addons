--Copyright (c) 2013, Banggugyangu
--All rights reserved.

--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:

--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of <addon name> nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.

--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


windower.register_event('load',function ()
	version = '2.1.2'
	delay = 3
	ammo_delay = 0
	retrn = 0
	halt_on_tp = true
	windower.send_command('unbind ^d')
	windower.send_command('unbind !d')
	windower.send_command('bind ^d ara start')
	windower.send_command('bind !d ara stop')
	windower.send_command('alias ara lua c autora')
	
end)
	
function start()
	windower.add_to_chat(16, 'ARA ++')	
	player = windower.ffxi.get_player()
	if player.status == 1 then
		auto = 1
	elseif player.status == 0 then
		auto = 0
	end
	shoot()
end

function stop()
	windower.add_to_chat(16, 'ARA--')	
	auto = 0
end

function shoot()
	windower.send_command('input /ra <t>;')
end

function shootOnce()
	windower.send_command('input /ra <t>')
end

--Function Author:  Byrth
function split(msg, match)
	local length = msg:len()
	local splitarr = {}
	local u = 1
	while u <= length do
		local nextanch = msg:find(match,u)
		if nextanch ~= nil then
			splitarr[#splitarr+1] = msg:sub(u,nextanch-match:len())
			if nextanch~=length then
				u = nextanch+match:len()
			else
				u = lengthlua 
			end
		else
			splitarr[#splitarr+1] = msg:sub(u,length)
			u = length+1
		end
	end
	return splitarr
end

function haltontp()
	
	if halt_on_tp == true then
		windower.add_to_chat(16, 'AutoRA will no longer halt upon reaching 1000 TP')
		halt_on_tp = false
	elseif halt_on_tp == false then
		windower.add_to_chat(16, 'AutoRA will halt upon reaching 1000 TP')
 		halt_on_tp = true
	end

end

windower.register_event('action',function (act)
	local actor = act.actor_id
	local category = act.category
	local player = windower.ffxi.get_player()
	
	if ((actor == (player.id or player.index))) then
		if category == 2 then
			if player.vitals['tp'] < 1000 then
				if auto == 1 then
					if  player.status == 1 then
						auto = 1
					elseif  player.status == 0 then
						auto = 0
						return
					end
				end
				if auto == 1 then
					windower.send_command('@wait '..delay..';input /ra <t>')
				elseif auto == 0 then
				end
			else
				if halt_on_tp == true then
					windower.add_to_chat(17, '> 1000 TP')
					return
				else
					if auto == 1 then
						if  player.status == 1 then
							auto = 1
						elseif  player.status == 0 then
							auto = 0
							return
						end
					end
					if auto == 1 then
						windower.send_command('@wait '..delay..';input /ra <t>')
					elseif auto == 0 then
					end
				end
			end
		end
	end
end)

--Function Designer:  Byrth
windower.register_event('addon command',function (...)
    local term = table.concat({...}, ' ')
    local splitarr = split(term,' ')
	if splitarr[1]:lower() == 'start' then
		start()
	elseif splitarr[1]:lower() == 'stop' then
		stop()
	elseif splitarr[1]:lower() == 'shoot' then
		shoot()
	elseif splitarr[1]:lower() == 'reload' then
		setDelay()
	elseif splitarr[1]:lower() == 'haltontp' then
		haltontp()
	elseif splitarr[1]:lower() == 'help' then
		windower.add_to_chat(16, 'AutoRA  v'..version..'commands:')
		windower.add_to_chat(16, '//ara [options]')
		windower.add_to_chat(16, '    start  	- Starts auto attack with ranged weapon')
		windower.add_to_chat(16, '    stop   	- Stops auto attack with ranged weapon')
		windower.add_to_chat(16, '    haltontp	- Toggles automatic halt upon reaching 1000 TP')
		windower.add_to_chat(16, '    help   	- Displays this help text')
		windower.add_to_chat(16, ' ')
		windower.add_to_chat(16, 'AutoRA will only automate ranged attacks if your status is "Engaged".  Otherwise it will always fire a single ranged attack.')
		windower.add_to_chat(16, 'To start auto ranged attacks without commands use the key:  Ctrl+d')
		windower.add_to_chat(16, 'To stop auto ranged attacks in the same manner:  Atl+d')
	end
end)
