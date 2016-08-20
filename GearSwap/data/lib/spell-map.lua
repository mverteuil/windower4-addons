element_match = {
	['Fire'] = {	['Helix'] = 'Pyrohelix', ['Storm'] = 'Firestorm', ['Single Target'] = 'Fire', ['Ancient Magic'] = 'Flare', ['AOE Target'] = 'Firaga', ['AOE JA'] = 'Firaja', ['AOE Self'] = 'Fira'	},
	['Earth'] = {	['Helix'] = 'Geohelix', ['Storm'] = 'Sandstorm', ['Single Target'] = 'Stone', ['Ancient Magic'] = 'Quake', ['AOE Target'] = 'Stonega', ['AOE JA'] = 'Stoneja', ['AOE Self'] = 'Stonara'	},
	['Water'] = {	['Helix'] = 'Hydrohelix', ['Storm'] = 'Rainstorm', ['Single Target'] = 'Water', ['Ancient Magic'] = 'Flood', ['AOE Target'] = 'Waterga', ['AOE JA'] = 'Waterja', ['AOE Self'] = 'Watera'	},
	['Wind'] = {	['Helix'] = 'Anemohelix', ['Storm'] = 'Windstorm', ['Single Target'] = 'Aero', ['Ancient Magic'] = 'Tornado', ['AOE Target'] = 'Aeroga', ['AOE JA'] = 'Aeroja', ['AOE Self'] = 'Aerora'	},
	['Ice'] = {	['Helix'] = 'Cryohelix', ['Storm'] = 'Hailstorm', ['Single Target'] = 'Blizzard', ['Ancient Magic'] = 'Freeze', ['AOE Target'] = 'Blizzaga', ['AOE JA'] = 'Blizzaja', ['AOE Self'] = 'Blizzara'	},
	['Thunder'] = {	['Helix'] = 'Ionohelix', ['Storm'] = 'Thunderstorm', ['Single Target'] = 'Thunder', ['Ancient Magic'] = 'Burst', ['AOE Target'] = 'Thundaga', ['AOE JA'] = 'Thundaja', ['AOE Self'] = 'Thundara'	},
	['Light'] = {	['Helix'] = 'Geohelix', ['Storm'] = 'Sandstorm', ['Single Target'] = 'Stone', ['Ancient Magic'] = 'Quake', ['AOE Target'] = 'Stonega', ['AOE JA'] = 'Stoneja', ['AOE Self'] = 'Stonara'	},
	['Dark'] = {	['Helix'] = 'Geohelix', ['Storm'] = 'Sandstorm', ['Single Target'] = 'Stone', ['Ancient Magic'] = 'Quake', ['AOE Target'] = 'Stonega', ['AOE JA'] = 'Stoneja', ['AOE Self'] = 'Stonara'	}
}

spell_type = {
	st = {	stype = "Single Target", description = "Single Target Nuke", default_tier = 1, max_tier = 5, default_target = "<t>"	},
	am = {	stype = "Ancient Magic", description = "Ancient Magic", default_tier = 2, max_tier = 2, default_target = "<t>"	},
	aoet = {	stype = "AOE Target", description = "Area of Effect Nuke Centered on Target", default_tier = 1, max_tier = 3, default_target = "<t>"	},
	aoeja = {	stype = "AOE JA", description = "Area of Effect Nuke, Added Effect increased damage from same element", default_tier = 1, max_tier = 1, default_target = "<t>"	},
	aoes = {	stype = "AOE Self", description = "Area of Effect Nuke Centered on Caster", default_tier = 1, max_tier = 2, default_target = "<me>"	},
	helix = {	stype = "Helix", description = "Helix", default_tier = 1, max_tier = 1, default_target = "<t>"	},
	storm = {	stype = "Storm", description = "Storm", default_tier = 1, max_tier = 1, default_target = "<me>"	}
}

tier_map = {	[2] = "II", [3] = "III", [4] = "IV", [5] = "V", [6] = "VI"	}

spell_map = {
	['Burn'] = 'Debuff', ['Rasp'] = 'Debuff', ['Drown'] = 'Debuff', ['Choke'] = 'Debuff', ['Frost'] = 'Debuff', ['Shock'] = 'Debuff',
	['Pyrohelix'] = 'Helix', ['Geohelix'] = 'Helix', ['HyrdroHelix'] = 'Helix', ['Anemohelix'] = 'Helix', ['Cryohelix'] = 'Helix', ['Ionohelix'] = 'Helix', ['Noctohelix'] = 'Helix', ['Luminohelix'] = 'Helix',
	['Firaja'] = 'JA', ['Stoneja'] = 'JA', ['Waterja'] = 'JA', ['Aeroja'] = 'JA', ['Blizzaja'] = 'JA', ['Thundaja'] = 'JA',
	['Cure'] = 'Cure', ['Cure II'] = 'Cure', ['Cure III'] = 'Cure', ['Cure IV'] = 'Cure', ['Cure V'] = 'Cure', ['Cure VI'] = 'Cure',
	['Curaga'] = 'Cure', ['Curaga II'] = 'Cure', ['Curaga III'] = 'Cure', ['Curaga IV'] = 'Cure', ['Curaga V'] = 'Cure',
	['Cura'] = 'Cure', ['Cura II'] = 'Cure', ['Cura II'] = 'Cure',
	['Firestorm'] = 'Storm', ['Sandstorm'] = 'Storm', ['Rainstorm'] = 'Storm', ['Windstorm'] = 'Storm', ['Hailstorm'] = 'Storm', ['Thunderstorm'] = 'Storm', ['Aurorastorm'] = 'Storm', ['Voidstorm'] = 'Storm',
	['Protect'] = 'Protect', ['Protect II'] = 'Protect', ['Protect III'] = 'Protect', ['Protect IV'] = 'Protect', ['Protect V'] = 'Protect',
	['Shell'] = 'Shell', ['Shell II'] = 'Shell', ['Shell III'] = 'Shell', ['Shell IV'] = 'Shell', ['Shell V'] = 'Shell',
	['Regen'] = 'Regen', ['Regen II'] = 'Regen', ['Regen III'] = 'Regen', ['Regen IV'] = 'Regen', ['Regen V'] = 'Regen',
	['Phalanx'] = 'Phalanx', ['Phalanx II'] = 'Phalanx', 
	['Dia'] = 'Dia', ['Dia II'] = 'Dia', ['Dia II'] = 'Dia', ['Diaga'] = 'Dia', ['Diaga II'] = 'Dia',
	['Bio'] = 'Bio', ['Bio II'] = 'Bio', ['Bio III'] = 'Bio',
	['Poisona'] = 'StatusRemoval', ['Paralyna'] = 'StatusRemoval', ['Silena'] = 'StatusRemoval', ['Blindna'] = 'StatusRemoval', ['Cursna'] = 'StatusRemoval', 
	['Stona'] = 'StatusRemoval', ['Viruna'] = 'StatusRemoval', ['Erase'] = 'StatusRemoval',
	['Barfire'] = 'Barspell', ['Barstone'] = 'Barspell', ['Barwater'] = 'Barspell', ['Baraero'] = 'Barspell', ['Barblizzard'] = 'Barspell', ['Barthunder'] = 'Barspell', 
	['Barfira'] = 'Barspell', ['Barstonra'] = 'Barspell', ['Barwatera'] = 'Barspell', ['Baraera'] = 'Barspell', ['Barblizzara'] = 'Barspell', ['Barthundra'] = 'Barspell',
}

strategems = {}
strategems.alias_list = T{	'addend', 'cost', 'speed', 'aoe', 'power', 'duration', 'skillchain', 'accuracy', 'enmity'	}
strategems['Light Arts'] = {	addend = 'Addendum: White', cost = 'Penury', speed = 'Celerity', aoe = 'Accession', power = 'Rapture', duration = 'Perpetuance', accuracy = 'Altruism', enmity = 'Tranquility'	}
strategems['Dark Arts'] = {	addend = 'Addendum: Black', cost = 'Parsimony', speed = 'Alacrity', aoe = 'Manifestation', power = 'Ebullience', skillchain = 'Immanence', accuracy = 'Focalization', enmity = 'Equanimity'	}
strategems.affected = {}
strategems.affected['Elemental Magic'] = {	'Parsimony', 'Alacrity', 'Ebullience', 'Immanence', 'Focalization', 'Equanimity'	}
strategems.affected['Dark Magic'] = {	'Parsimony', 'Alacrity', 'Ebullience', 'Immanence', 'Focalization', 'Eqanimity'	}
strategems.affected['Enhancing Magic'] = {	'Penury', 'Celerity', 'Accession', 'Perpetuance'	}
strategems.affected['Enfeebling Magic'] = {	'Parsimony', 'Alacrity', 'Manifestation', 'Focalizatin'	}
strategems.affected['Healing Magic'] = {	'Penury', 'Celerity', 'Accession', 'Rapture', 'Tranquility'	}
strategems.affected['Divine Magic'] = {	'Penury', 'Celerity', 'Accession', 'Rapture', 'Tranquility'	}


addendum_spells = {}
addendum_spells['Light Arts'] = S{'Paralyna', 'Blindna', 'Stona', 'Viruna', 'Cursna', 'Erase', 'Poisona', 'Silena', 'Reraise II', 'Reraise III'	}
addendum_spells['Dark Arts'] = S{'Fire IV', 'Fire V', 'Stone IV', 'Stone V', 'Water IV', 'Water V', 'Aero IV', 'Aero V', 'Blizzard IV', 'Blizzard V', 'Thunder IV', 'Thunder V', 'Break', 'Dispel' }
addendum_spells['RDM'] = S{	'Dispel' }
addendum_spells['WHM'] = S{	'Paralyna', 'Blindna', 'Stona', 'Viruna', 'Cursna', 'Erase', 'Poisona', 'Silena' }
addendum_spells.tried_addend = false
addendum_spells.tried_enlighten = false