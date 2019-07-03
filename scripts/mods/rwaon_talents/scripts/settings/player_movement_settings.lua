local mod = get_mod("rwaon_talents")

PlayerUnitMovementSettings.hit_react_settings.light.duration_function = function ()
    local duration = 1 --0.35

    return duration
end

PlayerUnitMovementSettings.hit_react_settings.medium.duration_function = function ()
    local duration = 2.5 --0.6

    return duration
end

PlayerUnitMovementSettings.hit_react_settings.heavy.duration_function = function ()
    local duration = 4 --0.6

    return duration
end