	require('luau')

	-- Variables
	MAGIC_LIST = {
		"Protect III",
		"Shell III",
		"Ice Spikes",
		"Blaze Spikes",
		"Phalanx",
		"Stoneskin",
		"Enthunder",
		"Enstone",
	}
	STATUS_EFFECT_RECEIPT_IDS = T{230, 75}
	PLAYER = windower.ffxi.get_player()
	ROTATIONS = 10
	DELAY = 1
	HALT = false

	-- Utilities
	function table.contains(table, element)
	  for _, value in pairs(table) do
	    if value == element then
	      return true
	    end
	  end
	  return false
	end

	function event_affects_me(event)
		return event["target_count"] == 1 and event["actor_id"] == PLAYER.id
	end

	function cast_spell_and_enqueue(spell_index, rotation_index)
		-- Casts the spell at the given index, for the given rotation
		-- and schedules the next spellcast after the configured delay
		if HALT then
			log("halting cycle")
			return
		end

		if spell_index == #MAGIC_LIST then
			log("rotation ".. rotation_index .." complete")
			rotation_index = rotation_index + 1	
		end

		spell_index = (spell_index + 1) % (#MAGIC_LIST + 1)
		next_spell_index = (spell_index + 1) % (#MAGIC_LIST + 1)
		log('casting:', MAGIC_LIST[spell_index], ', next:', MAGIC_LIST[next_spell_index])
		local spell_name = MAGIC_LIST[spell_index]
		--windower.send_command("input /ma "..spell_name.." <me>")

		if rotation_index < ROTATIONS then
			-- slightly different than normal circular array access because
			-- lua is 1-indexed
			
			coroutine.schedule(function() 
				cast_spell_and_enqueue(spell_index, rotation_index)
			end, DELAY)
		end
	end

	-- Event handlers
	windower.register_event('load',function()
		log("skillup loaded")
	end)

	windower.register_event('addon command', function(command)
		if command == 'halt' then
			HALT = true
		elseif command == 'resume' then
			HALT = false
		elseif commands == 'reset' then
			ROTATIONS = 0
			DELAY = 6
		elseif command == 'start' then
			cast_spell_and_enqueue(0,0)
		end
	end)

	windower.register_event('action',function(event)
		if event_affects_me(event) then
			if table.contains(STATUS_EFFECT_RECEIPT_IDS, event.targets[1].actions[1].message) then
				log('status magic finished casting')
			end
		end
	end)