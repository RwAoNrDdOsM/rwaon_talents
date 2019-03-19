WeaponTraits.traits.ranged_consecutive_hits_increase_power = {
    name = "ranged_consecutive_hits_increase_power",
    display_name = "traits_ranged_consecutive_hits_increase_power",
    buffer = "both",
    advanced_description = "description_traits_ranged_consecutive_hits_increase_power",
    icon = "ranged_consecutive_hits_increase_power",
    buff_name = "traits_ranged_consecutive_hits_increase_power",
    description_values = {
        {
            value_type = "percent",
            value = 0.05
        },
        {
            value = 5
        },
        {
            value = 2
        }
    }
}

WeaponTraits.buff_templates.consecutive_shot_buff = {
    buffs = {
        {
            duration = 2,
            multiplier = 0.05,
            max_stacks = 5,
            icon = "ranged_consecutive_hits_increase_power",
            refresh_durations = true,
            stat_buff = "power_level",
        }
    }
}

WeaponTraits.buff_templates.traits_ranged_consecutive_hits_increase_power = {
    buffs = {
        {
            event = "on_hit",
            dormant = true,
            event_buff = true,
            buff_func = function (player, buff, params)
                local player_unit = player.player_unit
                local hit_unit = params[1]
                local hit_unit_buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")
                local player_unit_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")
            
                --if not hit_unit_buff_extension:has_buff_type("consecutive_shot_debuff") then
                    --hit_unit_buff_extension:add_buff("consecutive_shot_debuff")
                --else
                    player_unit_buff_extension:add_buff("consecutive_shot_buff")
                --end
            end,
        }
    }
}