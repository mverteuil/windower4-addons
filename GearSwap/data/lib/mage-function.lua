function precast(spell, action)

	local eventArgs = {	handled = false, cancel = false	}
	local spellMap = spell_map[spell.english]
	
	if job_precast then
		job_precast(spell, action, spellMap, eventArgs)
	end
	
	if eventArgs.cancel then
		print('cancelled')
		cancel_spell()
		return
	end
	
	if eventArgs.handled then
		print('handled')
		return
	end
	
	if handled_magic[spell.skill] then
		build_precast_magic_set(spell, action, spellMap, eventArgs)
		build_midcast_magic_set(spell, action, spellMap, eventArgs)
		
		equip(sets.Casting.Precast)
	elseif sets.JA[spell.english] then
		equip(sets.JA[spell.english])
	end

end

function build_precast_magic_set(spell, action, spellMap, eventArgs)

	sets.Casting.Precast = sets.FC
	
	if sets.FC[spell.skill] then
		sets.Casting.Precast = set_combine(sets.Casting.Precast, sets.FC[spell.skill])
		
		if sets.FC[spell.skill][spell.english] then
			sets.Casting.Precast = set_combine(sets.Casting.Precast, sets.FC[spell.skill][spell.english])
		elseif sets.FC[spell.skill][spellMap] then
			sets.Casting.Precast = set_combine(sets.Casting.Precast, sets.FC[spell.skill][spellMap])
		end
		
		if sets.Staves.CastTime[spell.element] then
			sets.Casting.Precast = set_combine(sets.Casting.Precast, sets.Staves.CastTime[spell.element])
		end
		
	end

end

function build_midcast_magic_set(spell, action, spellMap, eventArgs)

	sets.Casting.Midcast = sets[spell.skill] or {}
	
	if spell.skill == 'Elemental Magic' then
		build_elemental_magic_set(spell, action, spellMap)
	elseif spell.skill == 'Healing Magic' then
		build_healing_magic_set(spell, action, spellMap)
	elseif spell.skill == 'Dark Magic' then
		build_dark_magic_set(spell, action, spellMap)
	elseif spell.skill == 'Enhancing Magic' then
		build_enhancing_magic_set(spell, aciton, spellMap)
	elseif spell.skill == 'Enfeebling Magic' then
		build_enfeebling_magic_set(spell, action, spellMap)
	elseif spell.skill == 'Divine Magic' then
		build_divine_magic_set(spell, action, spellMap)
	elseif spell.skill == 'Ninjutsu' then
		build_ninjutsu_set(spell, action, spellMap)
	end
	
	if (spell.skill == 'Elemental Magic' and spellMap ~= 'Debuff') or spellMap == 'Cure' or spell.english:find('Drain') or spell.english:find('Aspir') or (spell.skill == 'Divine Magic' and not spell.english == 'Flash') then
		weather_check(spell, spellMap)
	end

	if build_post_midcast_set then
		build_post_midcast_set(spell, action, spellMap)
	end
	
end

function build_elemental_magic_set(spell, action, spellMap)
	
	if sets['Elemental Magic'][spell.english] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Elemental Magic'][spell.english])
	elseif sets['Elemental Magic'][spellMap] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Elemental Magic'][spellMap])
	else
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Elemental Magic'].Damage)
	end
	
	if spellMap ~= 'Debuff' and spell.element == 'Earth' then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Elemental Magic'].Earth)
	end

end

function build_healing_magic_set(spell, action, spellMap)

	if sets['Healing Magic'][spell.english] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Healing Magic'][spell.english])
	elseif sets['Healing Magic'][spellMap] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Healing Magic'][spellMap])
	end

end

function build_dark_magic_set(spell, action, spellMap)
	
	if sets['Dark Magic'][spell.english] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Dark Magic'][spell.english])
	elseif sets['Dark Magic'][spellMap] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Dark Magic'][spellMap])
	else
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Dark Magic'].Damage)
	end
	
end

function build_enhancing_magic_set(spell, action, spellMap)

	if sets['Enhancing Magic'][spell.name] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Enhancing Magic'][spell.name])
	elseif sets['Enhancing Magic'][spellMap] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Enhancing Magic'][spellMap])
	end

end

function build_enfeebling_magic_set(spell, action, spellMap)

	if spellMap == 'Potency' then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Enfeebling Magic'][spell.type])
	end

end

function build_divine_magic_set(spell, action, spellMap)

	if sets['Divine Magic'][spell.name] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Divine Magic'][spell.name])
	elseif sets['Divine Magic'][spellMap] then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Divine Magic'][spellMap])
	else
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets['Divine Magic'].Damage)
	end

end

function build_ninjutsu_set(spell, action, spellMap)

	-- TODO: Build Ninjutsu Sets for midcast

end

function weather_check(spell, spellMap)

	if spell.element == world.day_element or spell.element == world.weather_element then
		sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Obis.Default)
		
		if spellMap ~= 'Helix' then
			sets.Casting.Midcast = set_combine(sets.Casting.Midcast, sets.Obis[spell.element])
		end
	end

end

function midcast(spell, action)

	if handled_magic[spell.skill] then
		equip(sets.Casting.Midcast)
	end

end

function aftercast(spell, action)

	if T{'Idle', 'Resting', 'Engaged'}:contains(player.status) then
		equip(sets[player.status])
	end

end

function buff_change(buff, gain)
	
	if job_buff_change then
		job_buff_change(buff, gain)
	end
	
	if buff == 'Sandstorm' then
		update_idle_set()
	end
	
end

function status_change(new, old)

	if T{'Zoning', 'Fishing', 'Event', 'Dead'}:contains(old) then
		return
	end

	if T{'Idle', 'Resting', 'Engaged'}:contains(new) then
		equip(sets[new])
	end

end

function self_command(command)
	
	local commandParams = command:split(' ')
	local eventArgs = {	handled = false	}
	
	if job_self_command then
		job_self_command(commandParams, eventArgs)
	end
	
	if eventArgs.handled then return end
	
	-- Handles matching spell element to day element
	if spell_type[commandParams[1]] then
		cast_element_match(commandParams)
	elseif commandParams[1] == 'update' then
		if commandParams[2] == 'idle' then
			update_idle_set()
		end
	end
	
end

--[[ cast_element_match info
	spell_type: mapped table containing stype, description, default_tier, max_tier, default_target
	cmdParams: parameters passed from the self_command function,
		expected values are <tier> <target> in that order, both values are optional
--]]
function cast_element_match(cmdParams)

	local sType = spell_type[cmdParams[1]].stype
	local tier = spell_type[cmdParams[1]].default_tier
	local max_tier = spell_type[cmdParams[1]].max_tier
	local target = spell_type[cmdParams[1]].default_target
	local spell = element_match[world.day_element][sType]
	
	if not cmdParams[2] then
		if tier ~= 1 then
			windower.add_to_chat(123, 'Placeholder')
			spell = spell .. ' ' .. tier_map[tier]
		end
	elseif tonumber(cmdParams[2]) then
		temp_tier = tonumber(cmdParams[2])
		if temp_tier > 1 and temp_tier < max_tier then
			spell = spell .. ' ' .. tier_map[temp_tier]
		elseif temp_tier ~= 1 then
			windower.add_to_chat(123, 'Invalid tier passed to function for [' .. sType .. '], defaulting to tier [' .. tier .. '].')
			
			if tier ~= 1 then
				spell = spell .. ' ' .. tier_map[tier]
			end
		end
		
		target = cmdParams[3] or target
	else
		target = cmdParams[2]
	end
	
	windower.send_command('input /ma "' .. spell .. '" ' .. target)
end

--[[ update_idle_set()
	updates Idle set with Desert Boots if used and keeps Sublimation set if sublimation active
	--]]
function update_idle_set()

	if world.weather_element == 'Earth' or buffactive.Sandstorm then
		sets.Idle = set_combine(sets.Idle, sets.Kite)
	else
		sets.Idle = sets.Idle.Default
	end
	
	if buffactive['Sublimation: Activated'] then
		sets.Idle = set_combine(sets.Idle, sets.Sublimation)
	end

end

--[[ alias_element_match()
	adds alias commands for casting spells matching the element of the day
--]]
function alias_element_match()

	for i,v in pairs(spell_type) do
		windower.send_command('alias ' .. i .. ' gs c ' .. i)
	end
	
end

--[[ unalias_element_match()
	removes alias commands for casting spells matching the element of the day
--]]
function unalias_element_match()

	for i,v in pairs(spell_type) do
		windower.send_command('unalias ' .. i)
	end
	
end

function file_unload()

	unalias_element_match()

end

--[[ This function can be removed if you don't use desert boots
	calls Idle set update on any weather change to accomodate Desert Boots usage
	
windower.register_event('weather change', function(id, name)
	
	if player.status == 'Zoning' then return end
	
	windower.send_command('gs c update idle')
		
end)
--]]