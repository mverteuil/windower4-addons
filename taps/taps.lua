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

chat   = require('chat')
config = require ('config')
texts  = require('texts')

_addon.name     = 'taps'
_addon.author   = 'mverteuil'
_addon.version  = '0.1'
_addon.commands = {'taps'}



-- [ Defaults ] --

defaults = T{}

defaults.autocolor = true

defaults.pos   = T{}
defaults.pos.x = windower.get_windower_settings().x_res*2/3
defaults.pos.y = windower.get_windower_settings().y_res-17

defaults.bg         = T{}
defaults.bg.alpha   = 255
defaults.bg.red     = 0
defaults.bg.green   = 0
defaults.bg.blue    = 0
defaults.bg.visible = true

defaults.flags        = {}
defaults.flags.right  = false
defaults.flags.bottom = false
defaults.flags.bold   = false
defaults.flags.italic = false

defaults.inactive_text       = {}
defaults.inactive_text.size  = 10
defaults.inactive_text.font  = 'Courier New'
defaults.inactive_text.alpha = 255
defaults.inactive_text.red   = 255
defaults.inactive_text.green = 255
defaults.inactive_text.blue  = 255

defaults.active_text       = {}
defaults.active_text.size  = 10
defaults.active_text.font  = 'Courier New'
defaults.active_text.alpha = 255
defaults.active_text.red   = 255
defaults.active_text.green = 255
defaults.active_text.blue  = 255

defaults.frames_per_tick = 30

default_tap_commands = T{}
default_tap_commands.cure = T{'Cure', 'Cure II', 'Cure III', 'Cure IV'}

-- [ Globals ] --
frame_index     = 0
tap_index       = 1
pending_command = nil

-- [ Event Handlers ] --
windower.register_event('addon command', function(command)
	tap_command = T(tap_commands[command])
	pending_command = tap_command[tap_index]
	windower.add_to_chat(55, pending_command:color(1))
	tap_index = math.max((tap_index + 1) % (tap_command:length() + 1), 1)
	frame_index = 1
end)

windower.register_event('prerender', function()
	frame_index = (frame_index + 1) % settings.frames_per_tick
	if frame_index == 0 and pending_command then
		windower.add_to_chat(55, pending_command:color(2))
		pending_command = nil
		tap_index = 1
	end
end)


windower.register_event('load', function(tap_command)
	settings = config.load(defaults)
	tap_commands = config.load('data\\tap_commands.xml', default_tap_commands)
end)

windower.register_event('unload', function(tap_command)
	config.save(settings)
	config.save(tap_commands)
end)