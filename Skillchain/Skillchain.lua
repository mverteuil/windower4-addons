        --[[Copyright © 2015, Fiv
All rights reserved.
 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Schillchain nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Fiv BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.]]--
 
--[[
tran = darkness > light
comp = ice > darkness
comp1 = light > darkness
liqu = lightning > fire
liqu1 = earth > fire
scis = fire > earth
scis1 = wind > earth
reve = earth > water
reve1 = light > water
deto = lightning > wind
deto1 = earth > wind
deto2 = darkness > wind
indu = water > ice
impa = ice > lightning
impa1 = water > lightning
grav = wind > darkness
dist = light > earth
fusi = fire > lightning
frag = ice > water
]]--
 
 _addon.name = 'Schillchain'
    _addon.version = '1.0.0.0'
    _addon.author = 'Fiv'
    _addon.command = 'sch'
       
require('tables')
require('strings')
require('logger')
require('sets')
config = require('config')
chat = require('chat')
res = require('resources')
 
Telem = S{"tran","comp","comp1","liqu","liqu1","scis","scis1","reve",
                        "reve1","deto","deto1","deto2","indu","impa","impa1","grav","dist","fusi","frag"}
tier1 = 1
tier2 = 1
--element = {}
windower.register_event('addon command',function (...)
        cmd = {...}
                local player = windower.ffxi.get_player()
                if Telem:contains(cmd[1]) then
                        element = cmd[1]
                        set_elements()
                        windower.add_to_chat(209,'Skillchain Set:' ..element..'')
                elseif cmd[1]:lower() == "opentier" then
                                if cmd[2] ~= nil then
                                        if cmd[2] == "1" then
                                                tier1 = 1
                                                windower.add_to_chat(209,"Opening nuke set to Tier 1 spells.")
                                        elseif cmd[2] == "2" then
                                                tier1 = 2
                                                windower.add_to_chat(209,"Opening nuke set to Tier 2 spells.")
                                        elseif cmd[2] == "3" then
                                                tier1 = 3
                                                windower.add_to_chat(209,"Opening nuke set to Tier 3 spells.")
                                        elseif cmd[2] == "4" then
                                                tier1 = 4
                                                windower.add_to_chat(209,"Opening nuke set to Tier 4 spells.")
                                        elseif cmd[2] == "5" then
                                                tier1 = 5
                                                windower.add_to_chat(209,"Opening nuke set to Tier 5 spells.")
                                        elseif cmd[2] == "6" then
                                                windower.add_to_chat(209,"Wishful thinking or fat fingers?")
                                        else
                                                windower.add_to_chat(209,"Incorrect Value, Please use 1,2,3,4,or 5.")
                                        end
                                end
                elseif cmd[1]:lower() == "closetier" then
                                if cmd[2] ~= nil then
                                        if cmd[2] == "1" then
                                                tier2 = 1
                                                windower.add_to_chat(209,"Closing nuke set to Tier 1 spells.")
                                        elseif cmd[2] == "2" then
                                                tier2 = 2
                                                windower.add_to_chat(209,"Closing nuke set to Tier 2 spells.")
                                        elseif cmd[2] == "3" then
                                                tier2 = 3
                                                windower.add_to_chat(209,"Closing nuke set to Tier 3 spells.")
                                        elseif cmd[2] == "4" then
                                                tier2 = 4
                                                windower.add_to_chat(209,"Closing nuke set to Tier 4 spells.")
                                        elseif cmd[2] == "5" then
                                                tier2 = 5
                                                windower.add_to_chat(209,"Closing nuke set to Tier 5 spells.")
                                        elseif cmd[2] == "6" then
                                                windower.add_to_chat(209,"Wishful thinking or fat fingers?")
                                        else
                                                windower.add_to_chat(209,"Incorrect Value, Please use 1,2,3,4,or 5.")
                                        end
                                end
                elseif cmd[1]:lower() == "start" then
                        local player = windower.ffxi.get_player()
                        if Telem:contains(element) then
                                if S(player.buffs):contains(359) or S(player.buffs):contains(402) then
                                        set_elements()
                                        get_spells()
                                        windower.send_command('input /ja "Immanence" <me>')
                                        windower.send_command('@wait 1.5;input /ma "'..sp1..'" <t>')
                                        windower.send_command('input /p Opening Schillchain '..skillchain..' - [Magic Burst: '..burst..']')
                                else
                                        windower.add_to_chat(209,"Oops! Dark Arts isn't active!")
                                end
                        else
                                windower.add_to_chat(209,"Select an element first.")
                        end
                elseif cmd[1]:lower() == "end" then
                        windower.send_command('input /ja "Immanence" <me>')
                        windower.send_command('@wait 1.5;input /ma "'..sp2..'" <t>')
                        windower.send_command('input /p Closing Schillchain '..skillchain..' - [Magic Burst: '..burst..']')
                end
    end)
 
function set_elements()
        if element == 'trans' then
                skillchain = "Transfixion"
                burst = "Water"
                ele1 = "Earth"
                ele2 = "Water"
        elseif element == 'comp' then
                skillchain = "Compression"
                burst = "Darkness"
                ele1 = "Ice"
                ele2 = "Darkness"
        elseif element == 'comp1' then
                skillchain = "Compression"
                burst = "Darkness"
                ele1 = "Light"
                ele2 = "Darkness"
        elseif element == 'liqu' then
                skillchain = "Liquefication"
                burst = "Fire"
                ele1 = "Lightning"
                ele2 = "Fire"
        elseif element == 'liqu1' then
                skillchain = "Liquefication"
                burst = "Fire"
                ele1 = "Earth"
                ele2 = "Fire"
        elseif element == 'scis' then
                skillchain = "Scission"
                burst = "Earth"
                ele1 = "Fire"
                ele2 = "Earth"
        elseif element == 'scis1' then
                skillchain = "Scission"
                burst = "Earth"
                ele1 = "Wind"
                ele2 = "Earth"
        elseif element == 'reve' then
                skillchain = "Reverberation"
                burst = "Water"
                ele1 = "Earth"
                ele2 = "Water"
        elseif element == 'reve1' then
                skillchain = "Reverberation"
                burst = "Water"
                ele1 = "Light"
                ele2 = "Water"
        elseif element == 'deto' then
                skillchain = "Detonation"
                burst = "Wind"
                ele1 = "Lightning"
                ele2 = "Wind"
        elseif element == 'deto1' then
                skillchain = "Detonation"
                burst = "Wind"
                ele1 = "Earth"
                ele2 = "Wind"
        elseif element == 'deto2' then
                burst = "Wind"
                ele1 = "Darkness"
                ele2 = "Wind"
        elseif element == 'impa' then
                skillchain = "Impaction"
                burst = "Lightning"
                ele1 = "Ice"
                ele2 = "Lightning"
        elseif element == 'impa1' then
                skillchain = "Impaction"
                burst = "Lightning"
                ele1 = "Water"
                ele2 = "Lightning"
        elseif element == 'indu' then
                skillchain = "Induration"
                burst = "Ice"
                ele1 = "Water"
                ele2 = "Ice"
        elseif element == 'grav' then
                skillchain = "Gravitation"
                burst = "Earth/Darkness"
                ele1 = "Wind"
                ele2 = "Darkness"
        elseif element == 'dist' then
                skillchain = "Distortion"
                burst = "Water/Blizzard"
                ele1 = "Light"
                ele2 = "Earth"
        elseif element == 'fusi' then
                skillchain = "Fusion"
                burst = "Fire/Light"
                ele1 = "Fire"
                ele2 = "Lightning"
        elseif element == 'frag' then
                skillchain = "Fragmentation"
                burst = "Wind/Lightning"
                ele1 = "Ice"
                ele2 = "Water"
        end
end
 
function get_spells()
        if ele1 == "Darkness" then
                sp1 = "Noctohelix"
        elseif ele1 == "Light" then
                sp1 = "Luminohelix"
        elseif ele1 == "Earth" then
                sp1 = '"Stone'..tier1..'"'
        elseif ele1 == "Water" then
                sp1 = '"Water'..tier1..'"'
        elseif ele1 == "Wind" then
                sp1 = '"Aero'..tier1..'"'
        elseif ele1 == "Fire" then
                sp1 = '"Fire'..tier1..'"'
        elseif ele1 == "Ice" then
                sp1 = '"Blizzard'..tier1..'"'
        elseif ele1 == "Lightning" then
                sp1 = '"Thunder'..tier1..'"'
        end
        if ele2 == "Darkness" then
                sp2 = "Noctohelix"
        elseif ele2 == "Light" then
                sp2 = "Luminohelix"
        elseif ele2 == "Earth" then
                sp2 = '"Stone'..tier2..'"'
        elseif ele2 == "Water" then
                sp2 = '"Water'..tier2..'"'
        elseif ele2 == "Wind" then
                sp2 = '"Aero'..tier2..'"'
        elseif ele2 == "Fire" then
                sp2 = '"Fire'..tier2..'"'
        elseif ele2 == "Ice" then
                sp2 = '"Blizzard'..tier2..'"'
        elseif ele2 == "Lightning" then
                sp2 = '"Thunder'..tier2..'"'
        end
end