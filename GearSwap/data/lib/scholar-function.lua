function file_unload()

	unalias_strategems()

end

function job_precast(spell, action, spellMap, eventArgs)
	local cast_addendum = false
	local arts_needed = nil
	local addendum = nil
	
	if spell.type == 'White Magic' then
		arts_needed = 'Light Arts'
		addendum = 'Addendum: White'
	elseif spell.type == 'Black Magic' then
		arts_needed = 'Dark Arts'
		addendum = 'Addendum: Black'
	end
	
	if spell.type == 'White Magic' or spell.type == 'Black Magic' then
		if addendum_spells[arts_needed][spell.name] and not (buffactive[addendum] or buffactive['Enlightenment']) then
			if not (addendum_spells[player.sub_job] and addendum_spells[player.sub_job][spell.english]) then
				windower.add_to_chat(123, 'This spell requires the appropriate Addendum or Enlightenment to cast.')
				cast_addendum = true
			end
		end
		
		if cast_addendum then
			eventArgs.cancel = true
	
			if (not buffactive[arts_needed] or addendum_spells.tried_addend) and not addendum_spells.tried_enlighten then
				windower.add_to_chat(123, 'Opposite or no arts active, trying Enlightenment')
				windower.send_command('input /ja "Enlightenment" <me>; wait 2; input /ma "' .. spell.english .. '" ' .. spell.target.raw)
				addendum_spells.tried_enlighten = true
				return
			elseif buffactive[arts_needed] and not addendum_spells.tried_addend then
				windower.add_to_chat(123, 'Trying Addendum')
				windower.send_command('input /ja "' .. addendum .. '" <me>; wait 2; input /ma "' .. spell.english .. '" ' .. spell.target.raw)
				addendum_spells.tried_addend = true
				return
			else
				windower.add_to_chat(123, 'Unable to cast spell, unable to use Addendum or Enlightenment.')
			end
		end
		
		addendum_spells.tried_addend = false
		addendum_spells.tried_enlighten = false
	end

end

function build_post_precast_set(spell, action, spellMap)

	if not (buffactive['Celerity'] or buffactive['Alacrity']) then
		if buffactive['Light Arts'] or buffactive['Dark Arts'] or buffactive['Addendum: White'] or buffactive['Addendum: Black'] then
			sets.Casting.Precast = set_combine(sets.Casting.Precast, sets.Grimoire.CastTime)
		end
	end

end

function build_post_midcast_set(spell, action, spellMap)

	if spell.skill == 'Enhancing Magic' and (buffactive['Light Arts'] or buffactive['Addendum: White']) and spellMap ~= 'Regen' then
		if (sets['Enhancing Magic'][spell.name] or sets['Enhancing Magic'][spellMap]) then
			sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Grimoire['Light Arts'])
		end
	end
	
	if (spell.skill == 'Dark Magic') and (buffactive['Dark Arts'] or buffactive['Addendum: Black']) then
		if spell.english ~= 'Stun' then
			sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Grimoire['Dark Arts'])
		end
	end
	
	if (spell.skill == 'Enfeebling Magic') and (buffactive['Dark Arts'] or buffactive['Addendum: Black']) then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Grimoire['Dark Arts'])
	end
	
	if spell.skill == 'Elemental Magic' and spellMap ~= 'Debuff' and buffactive.Klimaform then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Grimoire.Klimaform)
	end

	for i = 1, #strategems.affected[spell.skill] do
		if buffactive[strategems.affected[spell.skill][i]] and sets.Grimoire[strategems.affected[spell.skill][i]] then
			sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Grimoire[strategems.affected[spell.skill][i]])
		end
	end

end

function job_buff_change(buff, gain)

	if buff == 'Sublimation: Activated' then
		if gain then
			sets.Idle = set_combine(sets.Idle, sets.Sublimation)
			sets.Engaged = sets.Idle
		else
			sets.Idle = sets.Idle.Default
			sets.Engaged = sets.Idle
		end
		
		if world.weather_element == 'Earth' or buffactive.Sandstorm then
			sets.Idle = set_combine(sets.Idle, sets.Kite)
		end
		
		equip(sets[player.status])
	end
	
end

function job_self_command(cmdParams, eventArgs)

	if cmdParams[1] and strategems.alias_list:contains(cmdParams[1]) then
		use_strategem(cmdParams[1])
		eventArgs.handled = true
	elseif cmdParams[1] and cmdParams[1] == 'help' and cmdParams[2] == 'strat' then
		windower.add_to_chat(80, '********** SCH.lua strat aliases **********')
		windower.add_to_chat(80, 'the following aliases have been defined for SCH.lua')
		windower.add_to_chat(80, 'to aid the use of strategems in their respective arts')
		windower.add_to_chat(80, 'addend, cost, speed, aoe, power, duration,')
		windower.add_to_chat(80, 'skillchain, accuracy, and enmity')
		windower.add_to_chat(80, 'Additionally, if you attempt to cast a spell that')
		windower.add_to_chat(80, 'requires an addendum, SCH.lua will attempt to either')
		windower.add_to_chat(80, 'use the appropriate addendum or use enlightenment')
	end

end

function use_strategem(strat)

	if buffactive['Light Arts'] or buffactive['Addendum: White'] then
		if strategems['Light Arts'][strat] then
			windower.send_command('input /ja "' .. strategems['Light Arts'][strat] .. '" <me>')
		else
			windower.add_to_chat(123, 'Light Arts does not have a strategem for ' .. strat .. '.')
		end
	elseif buffactive['Dark Arts'] or buffactive['Addendum: Black'] then
		if strategems['Dark Arts'][strat] then
			windower.send_command('input /ja "' .. strategems['Dark Arts'][strat] .. '" <me>')
		else
			windower.add_to_chat(123, 'Dark Arts does not have a strategem for ' .. strat .. '.')
		end
	end

end

function alias_strategems()

	print('Adding SCH Stratagem Aliases....')
	for i = 1, #strategems.alias_list do
		windower.send_command('alias ' .. strategems.alias_list[i] .. ' gs c ' .. strategems.alias_list[i])
	end
	print('Finished Adding SCH Strategem Aliases.')

end

function unalias_strategems()

	print('Removing SCH Stratagem Aliases.....')
	for i = 1, #strategems.alias_list do
		windower.send_command('unalias ' .. strategems.alias_list[i])
	end
	print('Finished Removing SCH Stratagem Aliases.')

end