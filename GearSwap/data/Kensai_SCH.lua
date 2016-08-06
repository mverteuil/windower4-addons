--[ Original Sauce: http://pastebin.com/raw/CL3MrE0z ]--

function get_sets()
	--[[
		common-mage-gear.lua
		This file will contain the default gear for the three mage types blm, sch, geo
		After the init function, you can override gear based on your job.
		This must be called first or it might override other gear you might declare.
		
		Additionally, after you have overridden gear, you must call the build_default_sets function to build the casting sets.
	--]]
	require('lib/common-mage-gear.lua')
	init_mage_gear()
	
	-- Gear Overrides
	--[[
		There are 3 ways to override gear
		1. change equipment one piece at a time
			sets.MND.head = "Gende. Caubeen"
		2. use the set_combine function to one or more pieces of gear
			sets.FC  = set_combine(sets.FC, { ammo = "Incantor Stone", hands = "Gendewitha Gages" })
		3. completely override the set with a new one
			sets.MaxCastReduction = { waist = "Goading Belt", legs = hagpantsacc, feet = "Hagondes Sabots" }
	--]]
	--sets.MND.head = "Gende. Caubeen"
	--
	--sets.Matk.feet = "Gende. Galoshes"
	--
	--sets.CurePotency.head = "Gende. Caubeen"
	--
	--sets.FC  = set_combine(sets.FC, { ammo = "Incantor Stone", hands = "Gendewitha Gages" })
	--
	--sets.MaxCastReduction = { waist = "Goading Belt", legs = hagpantsacc, feet = "Hagondes Sabots" }
	--
	--sets.Skill.EnhancingMagic.head = "Svnt. Bonnet +2"
	--
	--sets.Enhance.Regen.head = "Svnt. Bonnet +2"

	-- Additional Gear
	--sets.Sublimation = { ear2 = "Savant's Earring" }
	
	sets.Grimoire = {}
	sets.Grimoire.CastTime = {} -- Add Academic's Loafers when obtained
	sets.Grimoire['Light Arts'] = {}-- legs = "Scholar's Pants" }
	sets.Grimoire['Dark Arts'] = {} -- Add Scholar's Gown when obtained
	sets.Grimoire.Macc = {} -- Savant's Pants +2
	sets.Grimoire.Celerity = {} -- Add Argute Loafers when obtained
	sets.Grimoire.Alacrity = sets.Grimoire.Celerity
	sets.Grimoire.Perpetuance = {}-- hands = "Svnt. Bracers +2" }
	sets.Grimoire.Immanence = sets.Grimoire.Perpetuance
	sets.Grimoire.Penury = {} -- Add Savant's Pants when obtained
	sets.Grimoire.Parsimony = sets.Grimoire.Penury
	sets.Grimoire.Rapture = {}-- head = "Svnt. Bonnet +2" }
	sets.Grimoire.Ebullience = sets.Grimoire.Rapture
	sets.Grimoire.Klimaform = {} -- Add Savant's Loafers when obtained
	
	-- Build Default Sets
	build_default_sets()
	
	-- Include Spell Maps and Mage Functions
	require('lib/spell-map.lua')
	require('lib/mage-function.lua')
	require('lib/scholar-function.lua')
	require('lib/common_info.skillchain.lua')
	require('lib/scholar-solosc.lua')
	require('lib/caster-buffwatcher.lua')
	require('lib/kensai-globals.lua')

	-- Get Kensai Common Sets
	set_common_sets()

	alias_element_match()
	alias_strategems()
	alias_kensai_globals()
end

function job_self_command(commandParams, eventArgs)
	if commandParams[1] == 'buffWatcher' then
		buffWatch(commandParams[2])
	end
	if commandParams[1] == 'stopBuffWatcher' then
		stopBuffWatcher()
	end
	if commandParams[1] == 'soloSC' then
		print('hi there!')
		if not commandParams[2] or not commandParams[3] then
			errlog('missing required parameters for function soloSkillchain')
			return
		else
			soloSkillchain(commandParams[2],commandParams[3],commandParams[4],commandParams[5])
		end
	end	
end