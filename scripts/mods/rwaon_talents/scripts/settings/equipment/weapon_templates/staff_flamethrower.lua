local mod = get_mod("rwaon_talents")
-- Flamestorm Staff
------------------------------------------------------------------------------

--Button Switch
local switch_button_layout = mod:get("flamestorm_weapon_switch")
    
if switch_button_layout then
    Weapons.staff_flamethrower_template.actions = {
        action_one = {
            default = {
                charge_sound_stop_event = "player_combat_weapon_staff_charge_down",
                scale_chain_window_by_charge_time_buff = true,
                scale_anim_by_charge_time_buff = false,
                kind = "charge",
                charge_sound_name = "player_combat_weapon_staff_charge",
                remove_overcharge_on_interrupt = true,
                overcharge_interval = 0.3,
                charge_sound_husk_name = "player_combat_weapon_staff_charge_husk",
                minimum_hold_time = 0.2,
                overcharge_type = "flamethrower",
                anim_end_event = "attack_finished",
                charge_sound_switch = "projectile_charge_sound",
                charge_time = 3,
                hold_input = "action_one_hold",
                anim_event = "flamethrower_charge_start",
                charge_sound_husk_stop_event = "stop_player_combat_weapon_staff_charge_husk",
                anim_end_event_condition_func = function (unit, end_reason)
                    return end_reason ~= "new_interupting_action"
                end,
                total_time = math.huge,
                buff_data = {
                    {
                        start_time = 0,
                        external_multiplier = 0.9,
                        end_time = 0.3,
                        buff_name = "planted_fast_decrease_movement"
                    },
                    {
                        start_time = 0.3,
                        external_multiplier = 0.8,
                        end_time = 0.7,
                        buff_name = "planted_fast_decrease_movement"
                    },
                    {
                        start_time = 0.7,
                        external_multiplier = 1,
                        buff_name = "planted_fast_decrease_movement"
                    }
                },
                allowed_chain_actions = {
                    {
                        sub_action = "default",
                        start_time = 0.2,
                        action = "action_wield",
                        input = "action_wield"
                    },
                    {
                        sub_action = "shoot_charged",
                        start_time = 0.65,
                        action = "action_two",
                        input = "action_two"
                    },
                    {
                        sub_action = "default",
                        start_time = 0.2,
                        action = "weapon_reload",
                        input = "weapon_reload"
                    }
                }
            }
        },
        action_two = {
            default = {
                particle_effect_flames = "fx/wpnfx_flamethrower_1p_01",
                is_spell = true,
                kind = "flamethrower",
                spray_range = 7,
                damage_profile = "flamethrower_spray",
                no_headshot_sound = true,
                overcharge_interval = 0.5,
                hit_effect = "flamethrower",
                particle_effect_flames_3p = "fx/wpnfx_flamethrower_01",
                damage_interval = 0.5,
                alert_sound_range_hit = 2,
                anim_time_scale = 1,
                minimum_hold_time = 2,
                fire_sound_event = "Play_player_combat_weapon_staff_flamethrower_shoot",
                overcharge_type = "spear",
                charge_value = "light_attack",
                anim_end_event = "attack_finished",
                fire_time = 0.3,
                dot_check = 0.97,
                stop_fire_event = "Stop_player_combat_weapon_staff_flamethrower_shoot",
                fire_sound_on_husk = true,
                area_damage = true,
                fire_stop_time = 0.55,
                hold_input = "action_two_hold",
                anim_event = "attack_shoot_flamethrower",
                alert_sound_range_fire = 12,
                total_time = 1.3,
                buff_data = {
                    {
                        start_time = 0,
                        external_multiplier = 0.5,
                        end_time = 0.25,
                        buff_name = "planted_fast_decrease_movement"
                    },
                    {
                        start_time = 0.25,
                        external_multiplier = 1,
                        buff_name = "planted_charging_decrease_movement"
                    }
                },
                allowed_chain_actions = {
                    {
                        sub_action = "default",
                        start_time = 0.75,
                        action = "action_wield",
                        input = "action_wield"
                    },
                    {
                        sub_action = "default",
                        start_time = 1,
                        action = "action_two",
                        release_required = "action_two_hold",
                        input = "action_two"
                    },
                    {
                        sub_action = "default",
                        start_time = 0.75,
                        action = "action_one",
                        input = "action_one"
                    },
                    {
                        sub_action = "default",
                        start_time = 0.75,
                        action = "weapon_reload",
                        input = "weapon_reload"
                    }
                },
                enter_function = function (attacker_unit, input_extension)
                    input_extension:clear_input_buffer()
    
                    return input_extension:reset_release_input()
                end
            },
            shoot_charged = {
                damage_window_start = 0.1,
                anim_end_event = "attack_finished",
                is_spell = true,
                damage_profile = "flamethrower",
                kind = "flamethrower",
                initial_damage_profile = "flamethrower_initial",
                no_headshot_sound = true,
                charge_fuel_time_multiplier = 5,
                overcharge_interval = 0.25,
                hit_effect = "flamethrower",
                particle_effect_flames_3p = "fx/wpnfx_flamethrower_01",
                damage_interval = 0.25,
                alert_sound_range_hit = 2,
                fire_sound_event = "Play_player_combat_weapon_staff_flamethrower_shoot_charged",
                minimum_hold_time = 0.75,
                damage_window_end = 0,
                overcharge_type = "drakegun_charging",
                charge_value = "light_attack",
                fire_time = 0.3,
                stop_fire_event = "Stop_player_combat_weapon_staff_flamethrower_shoot",
                fire_sound_on_husk = true,
                area_damage = true,
                particle_effect_flames = "fx/wpnfx_flamethrower_1p_01",
                hold_input = "action_two_hold",
                anim_event = "attack_shoot_flamethrower_charged",
                alert_sound_range_fire = 12,
                total_time = math.huge,
                buff_data = {
                    {
                        start_time = 0,
                        external_multiplier = 0.5,
                        buff_name = "planted_charging_decrease_movement"
                    }
                },
                allowed_chain_actions = {
                    {
                        sub_action = "default",
                        start_time = 0.4,
                        action = "action_wield",
                        input = "action_wield"
                    },
                    {
                        sub_action = "default",
                        start_time = 0.3,
                        action = "weapon_reload",
                        input = "weapon_reload"
                    }
                },
                enter_function = function (attacker_unit, input_extension)
                    input_extension:clear_input_buffer()
    
                    return input_extension:reset_release_input()
                end
            }
        },
        weapon_reload = {
            default = {
                charge_sound_stop_event = "stop_player_combat_weapon_staff_cooldown",
                hold_input = "weapon_reload_hold",
                charge_effect_material_variable_name = "intensity",
                kind = "charge",
                charge_sound_parameter_name = "drakegun_charge_fire",
                do_not_validate_with_hold = true,
                charge_effect_material_name = "Fire",
                minimum_hold_time = 0.5,
                vent_overcharge = true,
                anim_end_event = "attack_finished",
                charge_sound_switch = "projectile_charge_sound",
                charge_time = 3,
                uninterruptible = true,
                anim_event = "cooldown_start",
                charge_sound_name = "player_combat_weapon_staff_cooldown",
                anim_end_event_condition_func = function (unit, end_reason)
                    return end_reason ~= "new_interupting_action"
                end,
                total_time = math.huge,
                buff_data = {
                    {
                        start_time = 0,
                        external_multiplier = 0.2,
                        buff_name = "planted_fast_decrease_movement",
                        end_time = math.huge
                    }
                },
                enter_function = function (attacker_unit, input_extension)
                    input_extension:reset_release_input()
                    input_extension:clear_input_buffer()
                end,
                allowed_chain_actions = {
                    {
                        sub_action = "default",
                        start_time = 0.2,
                        action = "action_wield",
                        input = "action_wield"
                    }
                },
                condition_func = function (action_user, input_extension)
                    local overcharge_extension = ScriptUnit.extension(action_user, "overcharge_system")
    
                    return overcharge_extension:get_overcharge_value() ~= 0
                end,
                chain_condition_func = function (action_user, input_extension)
                    local overcharge_extension = ScriptUnit.extension(action_user, "overcharge_system")
    
                    return overcharge_extension:get_overcharge_value() ~= 0
                end
            }
        },
        action_inspect = ActionTemplates.action_inspect,
        action_wield = ActionTemplates.wield,
        action_instant_grenade_throw = ActionTemplates.instant_equip_grenade,
        action_instant_heal_self = ActionTemplates.instant_equip_and_heal_self,
        action_instant_heal_other = ActionTemplates.instant_equip_and_heal_other,
        action_instant_drink_potion = ActionTemplates.instant_equip_and_drink_potion,
        action_instant_equip_tome = ActionTemplates.instant_equip_tome,
        action_instant_equip_grimoire = ActionTemplates.instant_equip_grimoire,
        action_instant_equip_grenade = ActionTemplates.instant_equip_grenade_only,
        action_instant_equip_healing_draught = ActionTemplates.instant_equip_and_drink_healing_draught
    }
end

------------------------------------------------------------------------------


local function add_weapon_data(action_no, action_from, value, new_data)
    action_no[action_from][value] = new_data
end
    
for _, staff_flamethrower in ipairs{
    "staff_flamethrower_template",
} do
    --local weapon_template = Weapons[staff_flamethrower]
    --local from_action_one = weapon_template.actions.action_one
    --local from_action_two = weapon_template.actions.action_two
    
end

------------------------------------------------------------------------------