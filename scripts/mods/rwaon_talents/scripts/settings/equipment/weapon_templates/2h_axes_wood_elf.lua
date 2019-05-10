local mod = get_mod("rwaon_talents")

-- Glaive

------------------------------------------------------------------------------

NewDamageProfileTemplates.medium_slashing_smiter_flat = {
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

for _, _weapon_template in ipairs{
    "two_handed_axes_template_2",
    --"two_handed_axes_template_2_t3_un",
} do
    local weapon_template = Weapons[_weapon_template]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    -- l1
    change_weapon_value(action_one, "light_attack_left_upward", "hit_mass_count", nil)
    change_weapon_value(action_one, "light_attack_left_upward", "damage_profile", "medium_slashing_smiter_flat")
    -- l2
    change_weapon_value(action_one, "light_attack_right_upward", "hit_mass_count", nil)
    change_weapon_value(action_one, "light_attack_right_upward", "damage_profile", "medium_slashing_smiter_flat")
    -- l3
    change_weapon_value(action_one, "light_attack_left", "hit_mass_count", nil)
    change_weapon_value(action_one, "light_attack_left", "damage_profile", "medium_slashing_smiter_flat")
    -- push attack
    change_weapon_value(action_one, "light_attack_bopp", "hit_mass_count", nil)
    change_weapon_value(action_one, "light_attack_bopp", "damage_profile", "medium_slashing_smiter_flat")
end