local mod = get_mod("rwaon_talents")

-- Fireball Staff

------------------------------------------------------------------------------
-- Charged Shot Changes

DamageProfileTemplates.staff_fireball_charged = {
	charge_value = "projectile",
	critical_strike = {
		attack_armor_power_modifer = {
			1,
			1,
			4,
			1,
			1,
			0.25
		},
		impact_armor_power_modifer = {
			1,
			0.8,
			1,
			1,
			1,
			0.25
		}
	},
	armor_modifier = {
		attack = {
			1,
			1,
			4,
			1,
			0.1,
			0
		},
		impact = {
			1,
			0.5,
			1,
			1,
			1,
			0
		}
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	default_target = {
		dot_template_name = "burning_1W_dot",
		boost_curve_type = "ninja_curve",
		boost_curve_coefficient = 1,
		attack_template = "fireball",
		power_distribution_near = {
			attack = 0.15, --0.3
			impact = 0.5
		},
		power_distribution_far = {
			attack = 0.15, --0.3
			impact = 0.25
		},
		range_dropoff_settings = shotgun_dropoff_ranges
	},
	targets = {
		dot_template_name = "burning_1W_dot",
		boost_curve_type = "ninja_curve",
		boost_curve_coefficient = 0.5,
		attack_template = "fireball",
		power_distribution_near = {
			attack = 0.15, --0.3
			impact = 0.5
		},
		power_distribution_far = {
			attack = 0.15, --0.3
			impact = 0.25
		},
		range_dropoff_settings = shotgun_dropoff_ranges
    }
}

local function add_weapon_data(action_no, action_from, value, new_data)
    action_no[action_from][value] = new_data
end

local function add_weapon_action(action_no, action_name, new_data)
    action_no[action_name] = new_data
end
    
for _, staff_fireball_fireball in ipairs{
    "staff_fireball_fireball_template_1",
} do
    local weapon_template = Weapons[staff_fireball_fireball]
    local action_one = weapon_template.actions.action_one
	local action_two = weapon_template.actions.action_two
end