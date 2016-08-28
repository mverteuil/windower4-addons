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
	
	-- Augmented Gear
	HagondesCoat = { name="Hagondes Coat +1", augments={'Phys. dmg. taken -3%','Magic dmg. taken -2%','"Avatar perpetuation cost" -4',}}
	HagondesHat = { name="Hagondes Hat +1", augments={'Phys. dmg. taken -1%',}}
	Lehbrailg = { name="Lehbrailg +2", augments={'DMG:+17','CHR+4','"Mag.Atk.Bns."+18',}}
	MoonshadeEarring = {name="Moonshade Earring", augments={'Attack+4','Latent effect: "Regain"+1'}}		
	
	-- Staff Declarations
	sets.Staves = { main=Lehbrailg, sub="Vivid Strap" }
	sets.Staves.Damage = { main=Lehbrailg }
	sets.Staves.Accuracy = { main=Lehbrailg }
	sets.Staves.CastTime = { main=Lehbrailg }
	
	sets.Staves.Cure = { main="Tamaxchi" }
		
	-- Obi Declarations
	sets.Obis = { back="Twilight Cape" }
	sets.Obis.Fire = { waist="Karin Obi" }
	sets.Obis.Earth = { waist="Dorin Obi" }
	sets.Obis.Water = { waist="Suirin Obi" }
	sets.Obis.Wind = { waist="Furin Obi" }
	sets.Obis.Ice = { waist="Hyorin Obi" }
	sets.Obis.Thunder = { waist="Rairin Obi" }
	sets.Obis.Light = { waist="Korin Obi" }
	sets.Obis.Dark = { waist="Anrin Obi" }
	

	-- BaseSets
	sets.Hagondes = { head=HagondesHat, body=HagondesCoat, hands="Hagondes Cuffs", legs="Hagondes Pants", feet="Hagondes Sabots" }

	sets.Refresh = { head="Wayfarer Circlet", body="Wayfarer Robe", hands="Wayfarer Cuffs", legs="Wayfarer Slops", feet="Wayfarer Clogs" }
	
	sets.Kite = {}-- feet="Desert Boots" }
	
	sets.DT = { ring2="Griffon Ring" }
	sets.PDT = set_combine(sets.DT, { main="Earth Staff", legs="Wayfarer Slops" })
	sets.MDT = set_combine(sets.Hagondes, sets.DT, { waist="Slipor Sash", legs="Espial Hose" })
	
	sets.Haste = set_combine(sets.Hagondes, { waist="Paewr Belt" })
	
	sets.HMP = { main="Iridial Staff", ammo="Clarus Stone" }
	
	sets.INT = set_combine(sets.Hagondes, { ammo="Morion Tathlum", ring1="Acumen Ring", ring2="Weatherspoon Ring" })
	sets.MND = set_combine(sets.Hagondes, { ring1="Perception Ring", ring2="Globidonta Ring", back="Pahtli Cape", waist="Salire Belt" })
	
	sets.Matk = set_combine(sets.Staves.Damage, sets.Hagondes, { ammo="Morion Tathlum", neck="Incanter's Torque", ear2="Moldavite Earring", hands="Yaoyotl Gloves", waist="Salire Belt" })
	
	sets.Macc = set_combine(sets.Staves.Accuracy, sets.Hagondes, { ammo="Morion Tathlum", neck="Incanter's Torque", waist="Salire Belt" })
	
	sets.CurePotency = set_combine(sets.Staves.Cure, { body="Gendewitha Bliaut", hands="Yaoyotl Gloves", back="Pahtli Cape", legs="Wayfarer Slops", feet="Kandza Crackows" })
	
	sets.FC = set_combine(sets.Staves.CastTime, { sub="Vivid Strap", ring2="Weatherspoon Ring", hands="Gendewitha Gages", legs="Orvail Pants +1" })
	sets.FC['Elemental Magic'] = { neck="Incanter's Torque" }
	sets.FC['Elemental Magic'].Impact = {}-- head="", body="Twilight Cloak" }
	sets.FC['Healing Magic'] = {}
	sets.FC['Healing Magic'].Cure = { back="Pahtli Cape" }
	sets.FC['Enhancing Magic'] = {}-- waist="Siegel Sash" }
	sets.FC['Enhancing Magic'].Stoneskin = {}-- hands="Carapacho Mitts" }
	
	sets.MaxCastReduction = { hands="Hagondes Cuffs", legs="Hagondes Pants", feet="Hagondes Sabots" }
	
	sets.Skill = {}
	sets.Skill['Elemental Magic'] = {}
	sets.Skill['Dark Magic'] = {}-- sub="Caecus Grip" }
	sets.Skill['Healing Magic'] = {}-- ring2 = "Sirona's Ring"}
	sets.Skill['Enhancing Magic'] = {}-- sub="Fulcio Grip", body="Anhur Robe", waist="Olympus Sash" }
	sets.Skill['Enfeebling Magic'] = {}-- sub="Macero Grip" }
	sets.Skill['Divine Magic'] = { ring2="Globidonta Ring" }
	sets.Skill.Geomancy = {}
	sets.Skill.Ninjutsu = {}
	sets.Skill.Geomancy = {}
	
	sets.Enhance = {}
	
	sets.Enhance.Drain = sets.Staves['Dark Magic']
	sets.Enhance.Stoneskin = {}-- waist="Siegel Sash" }
	sets.Enhance.Cursna = {}
	sets.Enhance.Regen = {}
	
	sets.JA = {}
	
	--[[ Dynamic Sets
		Do not assign gear to these sets in this section, assignment will be handled in the function
		build_default_sets().  Most of these will be empty in this section and that is ok.
	--]]
	
	-- handled_magic is to let gearswap know which magic "skills" are handled by the set building code
	handled_magic = S{ 'Elemental Magic', 'Dark Magic', 'Healing Magic', 'Enhancing Magic', 'Enfeebling Magic', 'Divine Magic', 'Geomancy', 'Ninjutsu' }
	
	-- Define Base magic skill based sets
	sets['Elemental Magic'] = {}
	sets['Dark Magic'] = {}
	sets['Healing Magic'] = {}
	sets['Enhancing Magic'] = {}
	sets['Enfeebling Magic'] = {}
	sets['Divine Magic'] = {}
	sets.Geomancy = {}
	sets.Ninjutsu = {}
	
	-- Elemental Magic Sets
	sets['Elemental Magic'].Damage = {}
	sets['Elemental Magic'].Helix = {}
	sets['Elemental Magic'].Debuff = {}
	sets['Elemental Magic'].Impact = {}
	
	sets['Elemental Magic'].Earth = {}-- neck="Quanpur Necklace" } -- Declaration is ok for this piece
	
	-- Dark Magic Sets
	sets['Dark Magic'].Damage = {} -- Drain and Aspir set
	sets['Dark Magic'].Stun = {}
	sets['Dark Magic'].Bio = {}
	sets['Dark Magic'].Absorb = {}
	
	-- Healing Magic Sets
	sets['Healing Magic'].Cursna = {}
	sets['Healing Magic'].Cure = {}
	sets['Healing Magic'].StatusRemoval = {}
	
	-- Enhancing Magic Sets
	sets['Enhancing Magic'].Regen = {}
	sets['Enhancing Magic'].Phalanx = {}
	sets['Enhancing Magic'].BarSpell = {}
	sets['Enhancing Magic'].GainSpell = {}
	sets['Enhancing Magic'].Stoneskin = {}
	
	-- Enfeebling Magic Sets
	sets['Enfeebling Magic']['White Magic'] = {}
	sets['Enfeebling Magic']['Black Magic'] = {}
	
	-- Divine Magic Sets
	sets['Divine Magic'].Damage = {}
	sets['Divine Magic'].Flash = {}
	sets['Divine Magic'].Dia = {}
	
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
	sets['Elemental Magic'] = set_combine(sets.Macc, sets.INT)
	sets['Elemental Magic'].Damage = sets.Matk
	sets['Elemental Magic'].Helix = sets.Matk
	sets['Elemental Magic'].Debuff = sets.Macc
	sets['Elemental Magic'].Impact = set_combine(sets.Macc, sets.Matk)--, { head="", body="Twilight Cloak" })
	
	-- Dark Magic Sets
	sets['Dark Magic'] = set_combine(sets.Macc, sets.Skill['Dark Magic'])
	sets['Dark Magic'].Damage = sets.Enhance.Drain
	sets['Dark Magic'].Stun = set_combine(sets.FastCast, sets.MaxCastReduction, sets.Staves.Accuracy)
	sets['Dark Magic'].Bio = sets.Matk
	sets['Dark Magic'].Absorb = {}
	
	-- Healing Magic Sets
	sets['Healing Magic'] = sets.MaxCastReduction
	sets['Healing Magic'].Cursna = set_combine(sets.Skill['Healing Magic'], sets.Enhance.Cursna)
	sets['Healing Magic'].Cure = sets.Skill['Healing Magic']
	sets['Healing Magic'].StatusRemoval = {}
	
	-- Enhancing Magic Sets
	sets['Enhacing Magic'] = sets.MaxCastReduction
	sets['Enhancing Magic'].Regen = sets.Enhance.Regen
	sets['Enhancing Magic'].Phalanx = sets.Skill['Enhancing Magic']
	sets['Enhancing Magic'].BarSpell = sets.Skill['Enhancing Magic']
	sets['Enhancing Magic'].GainSpell = sets.Skill['Enhancing Magic']
	sets['Enhancing Magic'].Stoneskin = set_combine(sets.MND, sets.Skill['Enhancing Magic'], sets.Enhance.Stoneskin)
	
	-- Enfeebling Magic Sets
	sets['Enfeebling Magic'] = set_combine(sets.Macc, sets.Skill['Enfeebling Magic'])
	sets['Enfeebling Magic']['White Magic'] = set_combine(sets.MND, sets.Skill['Enfeebling Magic'])
	sets['Enfeebling Magic']['Black Magic'] = set_combine(sets.INT, sets.Skill['Enfeebling Magic'])
	
	-- Divine Magic Sets
	sets['Divine Magic'] = sets.Macc
	sets['Divine Magic'].Damage = set_combine(sets.MND, sets.Skill['Divine Magic'], set.Matk)
	sets['Divine Magic'].Flash = set_combine(sets.FastCast, sets.MaxCastReduction, sets.Skill['Divine Magic'])
	sets['Divine Magic'].Dia = set_combine(sets.Matk, sets.Skill['Divine Magic'])
	
	-- Ninjutsu Sets
	sets.Ninjutsu = sets.MaxCastReduction
	sets.Ninjutsu.Damage = set_combine(sets.Macc, sets.INT, sets.Matk)
	sets.Ninjutsu.Debuff = sets.Macc
	
	-- Geomancy Sets
	sets.Geomancy = set_combine(sets.MaxCastReduction, sets.Skill.Geomancy)
	
	-- Idle Sets
	sets.Idle.Default = set_combine(sets['Elemental Magic'].Damage, sets.MDT, sets.PDT, sets.Refresh)
	
	sets.Engaged.Melee = set_combine(sets.Haste, { main="Eminent Staff", ear1="Bladeborn Earring", ear2=MoonshadeEarring, ring1="Rajas Ring", ring2="Sun Ring", back="Buquwik Cape" })
	sets.Engaged.Caster = sets.Idle.Default
	
	sets.Resting.Default = sets.HMP
	
	sets.Idle = sets.Idle.Default
	sets.Engaged = sets.Engaged.Melee
	sets.Resting = sets.Resting.Default

end