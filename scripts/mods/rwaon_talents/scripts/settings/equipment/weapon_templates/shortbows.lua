local mod = get_mod("rwaon_talents")

-- Elf Shortbow
------------------------------------------------------------------------------
for _, weapon in ipairs{
    "shortbow_template_1",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    change_buff_data(action_one, "default", 1, {
        start_time = 0,
        external_multiplier = 0.9, -- 1
        end_time = 0.3,
        buff_name = "planted_charging_decrease_movement"
    })
    change_weapon_value(action_one, "default", "speed", 5500) -- 8000
    change_weapon_value(action_one, "shoot_charged", "speed", 10000) -- 11000
    change_weapon_value(action_one, "shoot_charged", "scale_total_time_on_mastercrafted", true)
    change_weapon_value(action_one, "shoot_charged", "anim_end_event_condition_func", function (unit, end_reason)
        return end_reason ~= "new_interupting_action"
    end)
    change_chain_actions(action_one, "shoot_charged", 2, {
        sub_action = "default",
        start_time = 0.25,
        action = "action_one",
        release_required = "action_two_hold",
        --end_time = 0.4,
        input = "action_one"
    })
    change_chain_actions(action_one, "shoot_charged", 4, {
        sub_action = "default",
        start_time = 0.4, -- 0.25
        action = "weapon_reload",
        input = "weapon_reload"
    })
    change_chain_actions(action_one, "shoot_special_charged", 2, {
        sub_action = "default",
        start_time = 0.25,
        action = "action_one",
        release_required = "action_two_hold",
        --end_time = 0.4,
        input = "action_one"
    })
    change_chain_actions(action_one, "shoot_special_charged", 4, {
        sub_action = "default",
        start_time = 0.4, -- 0.25
        action = "weapon_reload",
        input = "weapon_reload"
    })
end
