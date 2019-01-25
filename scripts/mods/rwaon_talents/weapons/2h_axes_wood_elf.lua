local mod = get_mod("rwaon_talents")

-- Glaive

------------------------------------------------------------------------------

DamageProfileTemplates.medium_slashing_smiter_flat = {
    armor_modifier = {
        attack = {
            1.25,
            0.65,
            2.5,
            1,
            0.75,
            0.6
        },
        impact = {
            1,
            0.5,
            1,
            1,
            0.75,
            0.25
        }
    },
	critical_strike = {
        attack_armor_power_modifer = {
            1,
            0.8,
            2.5,
            1,
            1
        },
        impact_armor_power_modifer = {
            1.25,
            0.75,
            2.75,
            1,
            1
        }
    },
	charge_value = "light_attack",
	cleave_distribution = {
		attack = 0.09,
		impact = 0.09
	},
	default_target = {
		boost_curve_type = "smiter_curve",
		attack_template = "slashing_smiter",
		power_distribution = {
			attack = 0.35,
			impact = 0.2
		}
	},
	targets = {
		[2] = {
			boost_curve_type = "tank_curve",
			attack_template = "light_blunt_tank",
			power_distribution = {
				attack = 0.1,
				impact = 0.1
			}
		}
	},
	shield_break = true
}

for _, h_axes_wood_elf in ipairs{
    "two_handed_axes_template_2",
    "two_handed_axes_template_2_t3_un",
} do
    local weapon_template = Weapons[h_axes_wood_elf]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    -- l1
    add_weapon_value(action_one, "light_attack_left_upward", "hit_mass_count", false)
    add_weapon_value(action_one, "light_attack_left_upward", "damage_profile", "medium_slashing_smiter_flat")
    change_chain_actions(action_one, "light_attack_left_upward", 3, {
        sub_action = "default",
        start_time = 0, -- 0.65
        end_time = 0.19,
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_left_upward", 4, {
        sub_action = "default",
        start_time = 0.46, -- 0.65
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_left_upward", 5, {
        sub_action = "default",
        start_time = 0, -- 0.65
        end_time = 0.19,
        action = "action_wield",
        input = "action_wield"
    })
    change_chain_actions(action_one, "light_attack_left_upward", 6, {
        sub_action = "default",
        start_time = 0.46, -- 0.65
        action = "action_wield",
        input = "action_wield"
    })
    -- l2
    add_weapon_value(action_one, "light_attack_right_upward", "hit_mass_count", false)
    add_weapon_value(action_one, "light_attack_right_upward", "damage_profile", "medium_slashing_smiter_flat")
    change_chain_actions(action_one, "light_attack_right_upward", 3, {
        sub_action = "default",
        start_time = 0, -- 0.6
        end_time = 0.29,
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_right_upward", 4, {
        sub_action = "default",
        start_time = 0.55, -- 0.6
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_right_upward", 5, {
        sub_action = "default",
        start_time = 0, -- 0.6
        end_time = 0.29,
        action = "action_wield",
        input = "action_wield"
    })
    change_chain_actions(action_one, "light_attack_right_upward", 6, {
        sub_action = "default",
        start_time = 0.55, -- 0.6
        action = "action_wield",
        input = "action_wield"
    })
    -- l3
    add_weapon_value(action_one, "light_attack_left", "hit_mass_count", false)
    add_weapon_value(action_one, "light_attack_left", "damage_profile", "medium_slashing_smiter_flat")
    change_chain_actions(action_one, "light_attack_left", 3, {
        sub_action = "default",
        start_time = 0, -- 0.65
        end_time = 0.19,
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_left", 4, {
        sub_action = "default",
        start_time = 0.46, -- 0.65
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_left", 5, {
        sub_action = "default",
        start_time = 0, -- 0.65
        end_time = 0.19,
        action = "action_wield",
        input = "action_wield"
    })
    change_chain_actions(action_one, "light_attack_left", 6, {
        sub_action = "default",
        start_time = 0.46, -- 0.65
        action = "action_wield",
        input = "action_wield"
    })
    -- push attack
    add_weapon_value(action_one, "light_attack_bopp", "hit_mass_count", false)
    add_weapon_value(action_one, "light_attack_bopp", "damage_profile", "medium_slashing_smiter_flat")
    change_chain_actions(action_one, "light_attack_bopp", 3, {
        sub_action = "default",
        start_time = 0.46, -- 0.65
        action = "action_two",
        input = "action_two_hold"
    })
    change_chain_actions(action_one, "light_attack_bopp", 4, {
        sub_action = "default",
        start_time = 0.46, -- 0.65
        action = "action_wield",
        input = "action_wield"
    })
end