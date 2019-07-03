local mod = get_mod("rwaon_talents")
local values = {
    chance = 0.04,
    movespeed = 1.4,
    attackspeed = 0.2,
    duration = 5,
}

WeaponTraits.traits.melee_attack_speed_on_crit = {
    display_name = "traits_melee_attack_speed_on_crit",
    advanced_description = "description_traits_melee_attack_speed_on_crit",
    icon = "melee_attack_speed_on_crit",
    buff_name = "traits_melee_attack_speed_on_crit",
    description_values = {
        {
            value_type = "percent",
            value = values.chance
        },
        {
            value_type = "percent",
            value = values.attackspeed
        },
        {
            value_type = "percent",
            value = values.movespeed - 1
        },
        {
            value = values.duration
        },
    }
}
mod:add_buff_extra("traits_melee_attack_speed_on_crit_proc", {
    buffs = {
        {
            icon = "bardin_slayer_crit_chance",
            name = "traits_melee_attack_speed_on_crit_proc_attackspeed",
            stat_buff = "attack_speed",
            multiplier = values.attackspeed,
            max_stacks = 1,
            duration = values.duration,
            refresh_durations = true
        },
        {
            remove_buff_func = "remove_movement_buff",
            name = "traits_melee_attack_speed_on_crit_proc_movespeed",
            multiplier = values.movespeed,
            max_stacks = 1,
            duration = values.duration,
            apply_buff_func = "apply_movement_buff",
            refresh_durations = true,
            path_to_movement_setting_to_modify = {
                "move_speed"
            }
        },
    }
})
WeaponTraits.buff_templates.traits_melee_attack_speed_on_crit = {
	buffs = {
		{
			buff_to_add = "traits_melee_attack_speed_on_crit_proc",
			event_buff = true,
			event = "on_hit",
            dormant = true,
            proc_chance = values.chance,
		    buff_func = ProcFunctions.add_buff,
		}
	}
}