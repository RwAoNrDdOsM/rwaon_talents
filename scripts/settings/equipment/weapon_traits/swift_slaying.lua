WeaponTraits.traits.melee_attack_speed_on_crit = {
    display_name = "traits_melee_attack_speed_on_crit",
    advanced_description = "description_traits_melee_attack_speed_on_crit",
    icon = "melee_attack_speed_on_crit",
    buff_name = "traits_melee_attack_speed_on_crit",
    description_values = {
        {
            value_type = "percent",
            value = 0.04
        },
        {
            value_type = "percent",
            value = 0.2
        },
        {
            value_type = "percent",
            value = 0.4
        },
        {
            value = 5
        },
    }
}

WeaponTraits.buff_templates.traits_melee_attack_speed_on_crit_proc = {
    buffs = {
        {
            apply_buff_func = "apply_movement_buff",
            multiplier = 1.2, -- 1.5
            name = "traits_melee_attack_speed_on_crit_proc",
            icon = "melee_attack_speed_on_crit",
            refresh_durations = true,
            remove_buff_func = "remove_movement_buff",
            max_stacks = 1,
            duration = 5,
            dormant = false,
            path_to_movement_setting_to_modify = {
                "move_speed"
            }
        },
        {
            multiplier = 0.4, -- 0.5
            name = "traits_melee_attack_speed_on_crit_proc",
            refresh_durations = true,
            max_stacks = 1,
            duration = 5,
            stat_buff = StatBuffIndex.ATTACK_SPEED
        },
    }
}
WeaponTraits.buff_templates.traits_melee_attack_speed_on_crit = {
	buffs = {
		{
			buff_to_add = "traits_melee_attack_speed_on_crit_proc",
			event_buff = true,
			event = "on_hit",
            dormant = true,
            proc_chance = 0.04,
		    buff_func = ProcFunctions.add_buff,
		}
	}
}