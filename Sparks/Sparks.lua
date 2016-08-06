_addon.name = 'Sparks'

_addon.author = 'Brax'

_addon.version = '1.0.0.1'

_addon.command = 'sparks'




require('chat')

require('logger')

packets = require('packets')

json  = require('json')

files = require('files')

config = require('config')

db = require('map')

res = require('resources')




pkt = {}







valid_zones = T{"Western Adoulin","Southern San d'Oria","Windurst Woods","Bastok Markets"}

valid_zones = {

	[256] = {npc="Eternal Flame", menu=5081}, -- Western Adoulin

	[230] = {npc="Rolandienne", menu=995}, -- Southern San d'Oria

	[235] = {npc="Isakoth", menu=26}, -- Bastok Markets

	[241] = {npc="Fhelm Jobeizat", menu=850}} -- Windurst Woods

	




defaults = {}

settings = config.load(defaults)




busy = false




windower.register_event('addon command', function(...)

    local args = T{...}

    local cmd = args[1]

	args:remove(1)

	for i,v in pairs(args) do args[i]=windower.convert_auto_trans(args[i]) end

	local item = table.concat(args," "):lower()

	

	if cmd == 'buy' then

		if not busy then

			pkt = validate(item)

			if pkt then

				busy = true

				--print(pkt['Target'].."-"..pkt['Target Index'])

				poke_npc(pkt['Target'],pkt['Target Index'])

			else 

				windower.add_to_chat(2,"Can't find item in menu")

			end

		else

			windower.add_to_chat(2,"Still buying last item")

		end

	elseif cmd == 'find' then

		table.vprint(fetch_db(item))

	end

end)




function validate(item)

	local zone = windower.ffxi.get_info()['zone']

	local me,target_index,target_id,distance

	local result = {}

	if valid_zones[zone] then

		for i,v in pairs(windower.ffxi.get_mob_array()) do

			if v['name'] == windower.ffxi.get_player().name then

				result['me'] = i

			elseif v['name'] == valid_zones[zone].npc then

				target_index = i

				target_id = v['id']

				result['Menu ID'] = valid_zones[zone].menu

				distance = windower.ffxi.get_mob_by_id(target_id).distance

			end

		end

		if math.sqrt(distance)<6 then

            local ite = fetch_db(item)

			if ite then

				result['Target'] = target_id

				result['Option Index'] = ite['Option']

				result['_unknown1'] = ite['Index']

				result['Target Index'] = target_index

				result['Zone'] = zone 

			end

		else

		windower.add_to_chat(10,"Too far from npc")

		end

	else

	windower.add_to_chat(10,"Not in a zone with sparks npc")

	end

	if result['Zone'] == nil then result = nil end

	return result

end




function fetch_db(item)

 for i,v in pairs(db) do

  if string.lower(v.Name) == string.lower(item) then

	return v

  end

 end

end







windower.register_event('incoming chunk',function(id,data,modified,injected,blocked)

	if id == 0x034 or id == 0x032 then

	 if busy == true and pkt then

		local packet = packets.new('outgoing', 0x05B)

		packet["Target"]=pkt['Target']

		--print(pkt['Target'])

		packet["Option Index"]=pkt['Option Index']

		--print(pkt['Option Index'])

		packet["_unknown1"]=pkt['_unknown1']

		--print(pkt['_unknown1'])

		packet["Target Index"]=pkt['Target Index']

		--print(pkt['Target Index'])

		packet["Automated Message"]=false

		packet["_unknown2"]=0

		packet["Zone"]=pkt['Zone']

		--print(pkt['Zone'])

		packet["Menu ID"]=pkt['Menu ID']

		--print(pkt['Menu ID'])

		packets.inject(packet)

		--print("sent")

		local packet = packets.new('outgoing', 0x016, {

		["Target Index"]=pkt['me'],

		})

		packets.inject(packet)

		busy = false

		pkt = {}

		return true

	 end

	end

	

end)




function poke_npc(npc,target_index)

	if npc and target_index then

		local packet = packets.new('outgoing', 0x01A, {

			["Target"]=npc,

			["Target Index"]=target_index,

			["Category"]=0,

			["Param"]=0,

			["_unknown1"]=0})

		packets.inject(packet)

	end

end







--[[

]]