_addon.name = 'OpenSesame'
_addon.author = 'Arcon'
_addon.version = '1.0.0.0'
_addon.language = 'english'
_addon.commands = {'opensesame', 'os'}

require('luau')
packets = require('packets')

defaults = {}
defaults.Auto = false
defaults.Range = 10
settings = config.load(defaults)

last = {}
doors = S{}

update_doors = function()
    local mobs = windower.ffxi.get_mob_array()
    doors:clear()
    for index, mob in pairs(mobs) do
        if mob.spawn_type == 34 and mob.distance < 2500 then
            doors:add(index)
        end
    end
end:cond(function()
    return settings.Auto
end)

update_doors()

exceptions = S{
    17097337,
}

check_door = function(door)
    return door
        and door.spawn_type == 34
        and door.distance < settings.Range^2
        and (not last[door.index] or os.time() - last[door.index] > 7)
        and door.name:byte() ~= 95
        and door.name ~= 'Furniture'
        and not exceptions:contains(door.id)
end

frame_count = 0
windower.register_event('prerender', function()
    if not windower.ffxi.get_info().logged_in then
        frame_count = 0
        return
    end

    frame_count = frame_count + 1
    if frame_count == 30 then
        update_doors()
        frame_count = 0
    end

    local open = T{}
    if settings.Auto then
        for index in doors:it() do
            local door = windower.ffxi.get_mob_by_index(index)
            if check_door(door) then
                open[door.index] = door.id
            end
        end
    else
        local door = windower.ffxi.get_mob_by_target()
        if door and check_door(door) then
            open[door.index] = door.id
        end
    end

    for id, index in open:it() do
        packets.inject(packets.new('outgoing', 0x01A, {
            ['Target'] = id,
            ['Target Index'] = index
        }))
        last[index] = os.time()
    end
end)

windower.register_event('logout', 'zone change', function()
    last = {}
    doors:clear()
end)

windower.register_event('addon command', function(command, ...)
    command = command and command:lower()
    local args = {...}

    if command == 'auto' then
        if args[1] == 'on' then
            settings.Auto = true
        elseif args[1] == 'off' then
            settings.Auto = false
        else
            settings.Auto = not settings.Auto
        end

        update_doors()

        log('Automatic door opening %s.':format(settings.Auto and 'enabled' or 'disabled'))
        config.save(settings)

    else
        print(_addon.name .. ' v' .. _addon.version .. ':')
        print('  auto [on|off] - Sets automatic door opening to on/off or toggles it')

    end
end)
