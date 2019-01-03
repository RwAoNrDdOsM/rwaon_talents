local mod = get_mod("rwaon_talents")

-- Hagban Bow

------------------------------------------------------------------------------
-- Dot Changes

BuffTemplates.arrow_poison_dot = {
    buffs = {
        {
            duration = 6, -- 3
            name = "arrow poison dot",
            start_flow_event = "poisoned",
            end_flow_event = "poisoned_end",
            death_flow_event = "poisoned_death",
            remove_buff_func = "remove_dot_damage",
            apply_buff_func = "start_dot_damage",
            time_between_dot_damages = 1.2, -- 0.6
            damage_profile = "poison_direct",
            update_func = "apply_dot_damage",
            reapply_buff_func = "reapply_dot_damage"
        }
    }
}