local mod = get_mod("rwaon_talents")

-- Elf Longbow
------------------------------------------------------------------------------
for _, weapon in ipairs{
    "longbow_template_1",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    change_buff_data(action_one, "default", 1, {
        start_time = 0,
        external_multiplier = 0.65, -- 0.5
        end_time = 0.3,
        buff_name = "planted_decrease_movement"
    })
    change_chain_actions(action_one, "default", 1, {
        sub_action = "default",
        start_time = 0.3, -- 0.6
        action = "action_wield",
        input = "action_wield"
    })
    change_weapon_value(action_one, "default", "impact_data", {
        wall_nail = true,
        depth = 0.1,
        targets = 2, -- 1 
        damage_profile = "arrow_carbine",
        link = true,
        depth_offset = -0.6
    })
    change_chain_actions(action_one, "shoot_charged", 1, {
        sub_action = "default",
        start_time = 0.4, -- 0.5
        action = "action_wield",
        input = "action_wield"
    })
    change_chain_actions(action_one, "shoot_charged", 3, {
        sub_action = "default",
        start_time = 0.45, -- 0.55
        action = "action_two",
        input = "action_two_hold",
        end_time = math.huge
    })
    change_chain_actions(action_one, "shoot_special_charged", 1, {
        sub_action = "default",
        start_time = 0.4, -- 0.5
        action = "action_wield",
        input = "action_wield"
    })
    change_chain_actions(action_one, "shoot_special_charged", 3, {
        sub_action = "default",
        start_time = 0.45, -- 0.55
        action = "action_two",
        input = "action_two_hold",
        end_time = math.huge
    })
    change_weapon_value(action_two, "default", "aim_zoom_delay", 0.2) -- 0.01
    change_buff_data(action_two, "default", 1, {
        start_time = 0,
        external_multiplier = 0.5, -- 0.25 
        buff_name = "planted_charging_decrease_movement"
    })
    change_chain_actions(action_two, "default", 1, {
        sub_action = "default",
        start_time = 0, -- 0.3
        action = "action_wield",
        input = "action_wield",
        end_time = math.huge
    })
end