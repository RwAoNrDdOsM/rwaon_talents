local mod = get_mod("rwaon_talents")

-- Hagbane Bow

------------------------------------------------------------------------------
for _, weapon in ipairs{
    "shortbow_hagbane_template_1",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    change_chain_actions(action_one, "default", 1, {
        sub_action = "default",
        start_time = 0.2, -- 0
        action = "action_wield",
        input = "action_wield"
    })
    change_chain_actions(action_one, "shoot_charged", 2, {
        sub_action = "default",
        start_time = 0.5, -- 0.66
        action = "action_wield",
        input = "action_wield"
    })
    weapon_template.dodge_count = 5 --6
end


-- Dot Changes

--[[BuffTemplates.arrow_poison_dot = {
    buffs = {
        {
            duration = 12, -- 3
            name = "arrow poison dot",
            start_flow_event = "poisoned",
            end_flow_event = "poisoned_end",
            death_flow_event = "poisoned_death",
            remove_buff_func = "remove_dot_damage",
            apply_buff_func = "start_dot_damage",
            time_between_dot_damages = 2.4, -- 0.6
            damage_profile = "poison_direct",
            update_func = "apply_dot_damage",
            reapply_buff_func = "reapply_dot_damage"
        }
    }
}
BuffTemplates.aoe_poison_dot = {
    buffs = {
        {
            duration = 6, -- 3
            name = "aoe poison dot",
            start_flow_event = "poisoned",
            end_flow_event = "poisoned_end",
            death_flow_event = "poisoned_death",
            remove_buff_func = "remove_dot_damage",
            apply_buff_func = "start_dot_damage",
            time_between_dot_damages = 1.5, -- 0.75
            damage_profile = "poison",
            update_func = "apply_dot_damage",
            reapply_buff_func = "reapply_dot_damage"
        }
    }
}]]