--Copyright (c) 2016, M. de Verteuil
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

require('logger')
chat   = require('chat')
config = require ('config')
texts  = require('texts')

_addon.name     = 'taps'
_addon.author   = 'mverteuil'
_addon.version  = '0.1'
_addon.commands = {'taps'}



-- [ Defaults ] --

defaults = T{}

default_x = 500
default_y = 500

defaults.inactive_text = {}
defaults.inactive_text.bg = {alpha=0}
defaults.inactive_text.text = {}
defaults.inactive_text.text.size  = 12
defaults.inactive_text.text.font  = 'Arial'
defaults.inactive_text.text.alpha = 255
defaults.inactive_text.text.red   = 255
defaults.inactive_text.text.green = 255
defaults.inactive_text.text.blue  = 255
defaults.inactive_text.pos = {x=default_x, y=default_y}

defaults.active_text = {}
defaults.active_text.bg = {alpha=0}
defaults.active_text.text = {}
defaults.active_text.text.size  = 12
defaults.active_text.text.font  = 'Arial'
defaults.active_text.text.alpha = 255
defaults.active_text.text.red   = 255
defaults.active_text.text.green = 255
defaults.active_text.text.blue  = 255
defaults.active_text.pos = {x=default_x, y=default_y}

defaults.frames_per_tick = 30
	
default_tap_commands = T{}
default_tap_commands.cure = T{'Cure', 'Cure II', 'Cure III', 'Cure IV'}

-- [ Globals ] --

state = {frame_index=0, tap_index=1, tap_command={}, pending_command=nil}

settings = config.load(defaults)

tap_commands = config.load('data\\tap_commands.xml', default_tap_commands)




inactive_text   = texts.new('${pending_command|---}', settings.inactive_text)
active_text     = texts.new('${pending_command|---}', settings.active_text)
inactive_text:show()

-- [ Utilities ] --

function update_text(active)
	if active == true then
		inactive_text:hide()
		active_text:show()
		active_text:update(state)
	elseif active == false then
		active_text:hide()
		inactive_text:show()
		inactive_text:update(state)
	else
		active_text:hide()
		inactive_text:hide()
	end
end


function save()
	config.save(settings)
	config.save(tap_commands)
end


-- [ Event Handlers ] --

tap_commands:register(function(raw_tap_commands)
	for key, value in pairs(raw_tap_commands) do
		new_table = T{}	
		for i, value in pairs(value) do
			new_table[tonumber(i)] = value
		end
		raw_tap_commands[key] = new_table
	end
end)
tap_commands:reload()


windower.register_event('addon command', function(command)
	if command == "#halt" then
		state.pending_command = nil
	elseif command == "#save" then
		save()
	else
		state.tap_command = tap_commands[command]
		state.pending_command = state.tap_command[state.tap_index]
		update_text(false)
		state.tap_index = math.max((state.tap_index + 1) % (state.tap_command:length() + 1), 1)
		state.frame_index = 1
	end
end)

windower.register_event('prerender', function()
	state.frame_index = (state.frame_index + 1) % settings.frames_per_tick
	if state.frame_index == 0 and state.pending_command then
		update_text(true)
		windower.send_command("input /" .. tostring(state.pending_command))
		state.pending_command = nil
		state.tap_index = 1
		coroutine.schedule(function() update_text() end, 3)
	end
end)

