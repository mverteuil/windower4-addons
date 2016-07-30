--[[
Kensai
Thief

=================================================

Set Template
------------
sets.new = {
    main  = "",
    sub   = "",
    range = "",
    ammo  = "",
    head  = "",
    neck  = "",
    lear  = "",
    rear  = "",
    body  = "",
    hands = "",
    ring1 = "",
    ring2 = "",
    back  = "",
    waist = "",
    legs  = "",
    feet  = "",
}
]]--


require('tables')
packets = require('packets')

buytime = false

--[[ Utilities ]]--

local function to_windower_api(str)
    return str:lower():gsub(" ","_")
end

--[[ GearSwap Defined Callbacks ]]--

-- Called once on load to initialize `sets`
function get_sets()
    set_language("english")
    sets = {}
    sets.idle = {
    }    
end


windower.register_event('incoming chunk', function (id, original, modified, injected, blocked)
    if id == 0x034 and buytime then
        -- NPC BUY
        data["Option Index"] = 32852
        data["Automated Message"] = true
        data["Zone"] = 230
        data["Menu ID"] = 32762
        data["_unknown1"] = 0
        data["_unknown2"] = 0
        buy_packet1 = packets.new('outgoing', 0x05B, data)
        packets.inject(buy_packet1)
        print("0x05B", buy_packet1)
   
        data["Automated Message"] = false
        buy_packet2 = packets.new('outgoing', 0x05B, data)
        packets.inject(buy_packet2)
        print("0x05B", buy_packet2)
        buytime = false
    end
end)

windower.register_event('outgoing chunk', function (id, original, modified, injected, blocked)
    if chattime then
        -- NPC CHAT
        data = {Target=17719397, Category=0}
        data["Target Index"] = 101
        chat_packet = packets.new('outgoing', 0x01A, data)
        packets.inject(chat_packet)
        print("0x01A", chat_packet)
        chattime = false
        buytime = true
    end

    if id == 0x05B or id == 0x01A or id == 22 then
        parsed = packets.parse('outgoing', original)
        print("O", id, parsed, '\n')
    else
        print("O", id)
    end
end)



function precast(spell)
    if spell.prefix == "/weaponskill" then
       send_command("input /ja 'Sneak Attack' <me>;")
    end
end

function midcast(spell)
    
end

function aftercast(spell)
    
end

function status_change(new, old)
    
end

    

function self_command(command)
   buytime = false
   chattime = true
end