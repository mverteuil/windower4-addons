--[ Original Sauce: http://pastebin.com/CXeRNdWQ ]--
--[ Thanks for the shoulders to stand on, Shadowmeld. ]--

function init_mage_gear()
	
	--[[
	
		This include is an effort to consolidate my mage jobs and the gear that they share.
		Ideally this file will be used to simplify gear progression for the 3 mage jobs that I currently have,
		which are BLM, SCH, and GEO.  These three jobs share a LOT of like gear, and as such, any time I get
		and upgrade I have to upgrade three different files.  This one file eliminates a lot of that.
		
		RDM and WHM unfortunately are not jobs that I currently have.  RDM could easily be used with this file 
		with the minor change of the base staves used since RDM can't use Atinian or Eminent.
		Baqil or Skirmish Staff or Voay Staff would work just fine though.  WHM unfortunately doesn't
		use Hagondes gear and as such would be difficult to adapt for this includes, it would probably
		be best to not use this file with a WHM.

	--]]
	
	--[[ Static Sets
		These sets are static, they do not change ever.  They are used as base sets for the dynamic sets
	--]]
	
	-- Staff Declarations
	sets.Staves = { main="Eminent Staff"}
	sets.Staves.Damage = { main="Eminent Staff" }
	sets.Staves.Accuracy = { main="Eminent Staff" }
	sets.Staves.CastTime = { main="Eminent Staff" }
	
	sets.Staves.Cure = { main="Tamaxchi Staff" }
		
	-- Obi Declarations
	sets.Obis = {}-- back="Twilight Cape" }
	sets.Obis.Fire = {}-- waist="Karin Obi" }
	sets.Obis.Earth = {}-- waist="Dorin Obi" }
	sets.Obis.Water = {}-- waist="Suirin Obi" }
	sets.Obis.Wind = {}-- waist="Furin Obi" }
	sets.Obis.Ice = {}-- waist="Hyorin Obi" }
	sets.Obis.Thunder = {}-- waist="Rairin Obi" }
	sets.Obis.Light = {}-- waist="Korin Obi" }
	sets.Obis.Dark = {}-- waist="Anrin Obi" }
	
	-- Augmented Gear
	MoonshadeEarring = {name="Moonshade Earring", augments={'Attack+4','Latent effect: "Regain"+1'}}		
	
	-- BaseSets
	sets.Hagondes = { head="Hagondes Hat +1", body="Wayfarer Robe", hands="Yaoyotl Gloves", legs="Wayfarer Slops", feet="Kandza Crackows" }

	sets.Refresh = { head="Wayfarer Circlet", body="Wayfarer Robe", hands="Wayfarer Cuffs", legs="Wayfarer Slops", feet="Wayfarer Clogs" }
	
	sets.Kite = {}-- feet="Desert Boots" }
	
	sets.DT = {}-- neck="Twilight Torque" }
	sets.PDT = set_combine(sets.DT, { main="Earth Staff", body="Wayfarer Robe", legs="Wayfarer Slops" })
	sets.MDT = set_combine(sets.Hagondes, sets.DT)
	
	sets.Haste = set_combine(sets.Hagondes, { waist="Paewr Belt" })
	
	sets.HMP = { main="Iridial Staff", ammo="Clarus Stone" }
	
	sets.INT = set_combine(sets.Hagondes, { ammo="Morion Tathlum", ring1="Acumen Ring", ring2="Weatherspoon Ring" })
	sets.MND = set_combine(sets.Hagondes, { ring1="Perception Ring", back="Pahtli Cape", waist="Salire Belt" })
	
	sets.Matk = set_combine(sets.Staves.Damage, sets.Hagondes, { ammo="Morion Tathlum", neck="Incanter's Torque", ear2="Moldavite Earring", waist="Salire Belt" })
	
	sets.Macc = set_combine(sets.Staves.Accuracy, sets.Hagondes, { ammo="Morion Tathlum", neck="Incanter's Torque", waist="Salire Belt" })
	
	sets.CurePotency = set_combine(sets.Staves.Cure, { body="Wayfarer Robe", hands="Yaoyotl Gloves", back="Pahtli Cape", legs="Wayfarer Slops", feet="Kandza Crackows" })
	
	sets.FC = set_combine(sets.Staves.CastTime, { sub="Vivid Strap", ring2="Weatherspoon Ring", legs="Orvail Pants +1", feet="Chelona Boots" })
	sets.FC.ElementalMagic = { neck="Incanter's Torque" }
	sets.FC.ElementalMagic.Impact = {}-- head="", body="Twilight Cloak" }
	sets.FC.HealingMagic = {}
	sets.FC.HealingMagic.Cure = { back="Pahtli Cape" }
	sets.FC.EnhancingMagic = {}-- waist="Siegel Sash" }
	sets.FC.EnhancingMagic.Stoneskin = {}-- hands="Carapacho Mitts" }
	
	sets.MaxCastReduction = {}-- hands="Hagondes Cuffs", waist="Goading Belt", legs="Hagondes Pants", feet="Hagondes Sabots" }
	
	sets.Skill = {}
	sets.Skill.ElementalMagic = {}
	sets.Skill.DarkMagic = {}-- sub="Caecus Grip" }
	sets.Skill.HealingMagic = {}-- ring2 = "Sirona's Ring"}
	sets.Skill.EnhancingMagic = {}-- sub="Fulcio Grip", body="Anhur Robe", waist="Olympus Sash" }
	sets.Skill.EnfeeblingMagic = {}-- sub="Macero Grip" }
	sets.Skill.DivineMagic = {}-- sub="Divinus Grip" }
	sets.Skill.Geomancy = {}
	sets.Skill.Ninjutsu = {}
	sets.Skill.Geomancy = {}
	
	sets.Enhance = {}
	
	sets.Enhance.Drain = sets.Staves.DarkMagic
	sets.Enhance.Stoneskin = {}-- waist="Siegel Sash" }
	sets.Enhance.Cursna = {}
	sets.Enhance.Regen = {}
	
	sets.JA = {}
	
	--[[ Dynamic Sets
		Do not assign gear to these sets in this section, assignment will be handled in the function
		build_default_sets().  Most of these will be empty in this section and that is ok.
	--]]
	
	-- handled_magic is to let gearswap know which magic "skills" are handled by the set building code
	handled_magic = S{ 'ElementalMagic', 'DarkMagic', 'HealingMagic', 'EnhancingMagic', 'EnfeeblingMagic', 'DivineMagic', 'Geomancy', 'Ninjutsu' }
	
	-- Define Base magic skill based sets
	sets.ElementalMagic = {}
	sets.DarkMagic = {}
	sets.HealingMagic = {}
	sets.EnhancingMagic = {}
	sets.EnfeeblingMagic = {}
	sets.DivineMagic = {}
	sets.Geomancy = {}
	sets.Ninjutsu = {}
	
	-- Elemental Magic Sets
	sets.ElementalMagic.Damage = {}
	sets.ElementalMagic.Helix = {}
	sets.ElementalMagic.Debuff = {}
	sets.ElementalMagic.Impact = {}
	
	sets.ElementalMagic.Earth = {}-- neck="Quanpur Necklace" } -- Declaration is ok for this piece
	
	-- Dark Magic Sets
	sets.DarkMagic.Damage = {} -- Drain and Aspir set
	sets.DarkMagic.Stun = {}
	sets.DarkMagic.Bio = {}
	sets.DarkMagic.Absorb = {}
	
	-- Healing Magic Sets
	sets.HealingMagic.Cursna = {}
	sets.HealingMagic.Cure = {}
	sets.HealingMagic.StatusRemoval = {}
	
	-- Enhancing Magic Sets
	sets.EnhancingMagic.Regen = {}
	sets.EnhancingMagic.Phalanx = {}
	sets.EnhancingMagic.BarSpell = {}
	sets.EnhancingMagic.GainSpell = {}
	sets.EnhancingMagic.Stoneskin = {}
	
	-- Enfeebling Magic Sets
	sets.EnfeeblingMagic.WhiteMagic = {}
	sets.EnfeeblingMagic.BlackMagic = {}
	
	-- Divine Magic Sets
	sets.DivineMagic.Damage = {}
	sets.DivineMagic.Flash = {}
	sets.DivineMagic.Dia = {}
	
	-- Ninjutsu Sets
	sets.Ninjutsu.Damage = {}
	sets.Ninjutsu.Debuff = {}
	
	-- Geomancy Sets
	
	-- Status Change Sets
	
	sets.Idle = {}
	sets.Engaged = {}
	sets.Resting = {}
	
	-- Idle Sets
	sets.Idle.Default = {}
	
	sets.Engaged.Melee = {}
	sets.Engaged.Caster = {}
	
	sets.Resting.Default = {}
	
	-- Empty Casting Sets
	sets.Casting = {}
	sets.Casting.Precast = {}
	sets.Casting.Midcast = {}
	
end

--[[ build_default_sets()
	This Function is called AFTER the override section in your <job_name>.lua file.  It will build
	your casting sets based on the updated static sets.  For example, this set has a fast cast set
	that uses Repartie Gloves for fast cast.  If you are using SCH and override the fast cast set to
	use Gendewitha Gages, when it builds sets that use fast cast, it build using the fast cast set
	that uses Gendewitha Gages
	
	As such, this is where you would make changes to casting gear sets if you have some oneoff gear that you would use with one spell type.
--]]
function build_default_sets()

	-- Elemental Magic Sets
	sets.ElementalMagic = set_combine(sets.Macc, sets.INT)
	sets.ElementalMagic.Damage = sets.Matk
	sets.ElementalMagic.Helix = sets.Matk
	sets.ElementalMagic.Debuff = sets.Macc
	sets.ElementalMagic.Impact = set_combine(sets.Macc, sets.Matk)--, { head="", body="Twilight Cloak" })
	
	-- Dark Magic Sets
	sets.DarkMagic = set_combine(sets.Macc, sets.Skill.DarkMagic)
	sets.DarkMagic.Damage = sets.Enhance.Drain
	sets.DarkMagic.Stun = set_combine(sets.FastCast, sets.MaxCastReduction, sets.Staves.Accuracy)
	sets.DarkMagic.Bio = sets.Matk
	sets.DarkMagic.Absorb = {}
	
	-- Healing Magic Sets
	sets.HealingMagic = sets.MaxCastReduction
	sets.HealingMagic.Cursna = set_combine(sets.Skill.HealingMagic, sets.Enhance.Cursna)
	sets.HealingMagic.Cure = sets.Skill.HealingMagic
	sets.HealingMagic.StatusRemoval = {}
	
	-- Enhancing Magic Sets
	sets.EnhacingMagic = sets.MaxCastReduction
	sets.EnhancingMagic.Regen = sets.Enhance.Regen
	sets.EnhancingMagic.Phalanx = sets.Skill.EnhancingMagic
	sets.EnhancingMagic.BarSpell = sets.Skill.EnhancingMagic
	sets.EnhancingMagic.GainSpell = sets.Skill.EnhancingMagic
	sets.EnhancingMagic.Stoneskin = set_combine(sets.MND, sets.Skill.EnhancingMagic, sets.Enhance.Stoneskin)
	
	-- Enfeebling Magic Sets
	sets.EnfeeblingMagic = set_combine(sets.Macc, sets.Skill.EnfeeblingMagic)
	sets.EnfeeblingMagic.WhiteMagic = set_combine(sets.MND, sets.Skill.EnfeeblingMagic)
	sets.EnfeeblingMagic.BlackMagic = set_combine(sets.INT, sets.Skill.EnfeeblingMagic)
	
	-- Divine Magic Sets
	sets.DivineMagic = sets.Macc
	sets.DivineMagic.Damage = set_combine(sets.MND, sets.Skill.DivineMagic, set.Matk)
	sets.DivineMagic.Flash = set_combine(sets.FastCast, sets.MaxCastReduction, sets.Skill.DivineMagic)
	sets.DivineMagic.Dia = set_combine(sets.Matk, sets.Skill.DivineMagic)
	
	-- Ninjutsu Sets
	sets.Ninjutsu = sets.MaxCastReduction
	sets.Ninjutsu.Damage = set_combine(sets.Macc, sets.INT, sets.Matk)
	sets.Ninjutsu.Debuff = sets.Macc
	
	-- Geomancy Sets
	sets.Geomancy = set_combine(sets.MaxCastReduction, sets.Skill.Geomancy)
	
	-- Idle Sets
	sets.Idle.Default = set_combine(sets.ElementalMagic.Damage, sets.MDT, sets.PDT, sets.Refresh)
	
	sets.Engaged.Melee = set_combine(sets.Haste, { main="Eminent Dagger", ear1="Bladeborn Earring", ear2=MoonshadeEarring, ring1="Rajas Ring", ring2="Sun Ring", back="Buquwik Cape" })
	sets.Engaged.Caster = sets.Idle.Default
	
	sets.Resting.Default = sets.HMP
	
	sets.Idle = sets.Idle.Default
	sets.Engaged = sets.Engaged.Melee
	sets.Resting = sets.Resting.Default

end