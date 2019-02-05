local mod = get_mod("rwaon_talents")

WeaponTraits.traits.melee_increase_damage_on_block = {
    display_name = "traits_melee_increase_damage_on_block",
    buffer = "server",
    advanced_description = "description_traits_melee_increase_damage_on_block",
    icon = "melee_increase_damage_on_block",
    buff_name = "traits_melee_increase_damage_on_block",
    description_values = {
        {
            value_type = "percent",
            value = 0.2
        },
        {
            value = 5
        },
        {
            value_type = "percent",
            value = 1
        },
    }
}

WeaponTraits.buff_templates.traits_melee_increase_damage_on_block = {
    buffs = {
        {
            event = "on_block",
            dormant = true,
            event_buff = true,
            buff_func = ProcFunctions.block_increase_enemy_damage_taken
        },
        {
            dormant = true,
            stat_buff = StatBuffIndex.COUNTER_PUSH_POWER,
            multiplier = 1, --0.5
        }
    }
}