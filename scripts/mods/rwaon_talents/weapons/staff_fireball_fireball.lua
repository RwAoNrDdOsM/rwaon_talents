local mod = get_mod("rwaon_talents")

-- Fireball Staff

------------------------------------------------------------------------------
-- Charged Shot Changes


-- Increased Damage
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
			attack = 0.35, --0.3
			impact = 0.5
		},
		power_distribution_far = {
			attack = 0.35, --0.3
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
			attack = 0.35, --0.3
			impact = 0.5
		},
		power_distribution_far = {
			attack = 0.35, --0.3
			impact = 0.25
		},
		range_dropoff_settings = shotgun_dropoff_ranges
    }
}

-- Increased overcharge
PlayerUnitStatusSettings.overcharge_values.fireball_charged = 9 -- 7

-- Increased radius
ExplosionTemplates.fireball_charged = {
	explosion = {
		use_attacker_power_level = true,
		radius_min = 1.375, -- 1.25
		sound_event_name = "fireball_big_hit",
		radius_max = 3.6, -- 3
		attacker_power_level_offset = 0.25,
		max_damage_radius_min = 0.5, -- 0.5
		alert_enemies_radius = 10,
		damage_profile_glance = "fireball_charged_explosion_glance",
		max_damage_radius_max = 2, -- 2
		alert_enemies = true,
		damage_profile = "fireball_charged_explosion",
		effect_name = "fx/wpnfx_fireball_charged_impact"
	}
}
ExplosionTemplates.fireball_charged_t2 = table.clone(ExplosionTemplates.fireball_charged)
ExplosionTemplates.fireball_charged_t2.explosion.attack_template = "drakegun_t2"
ExplosionTemplates.fireball_charged_t2.explosion.attack_template_glance = "drakegun_glance_t2"
ExplosionTemplates.fireball_charged_t2.explosion.dot_template_name = "burning_1W_dot"
ExplosionTemplates.fireball_charged_t2.explosion.dot_template_name_glance = "burning_1W_dot"
ExplosionTemplates.fireball_charged_t3 = table.clone(ExplosionTemplates.fireball_charged)
ExplosionTemplates.fireball_charged_t3.explosion.attack_template = "drakegun_t3"
ExplosionTemplates.fireball_charged_t3.explosion.attack_template_glance = "drakegun_glance_t3"
ExplosionTemplates.fireball_charged_t3.explosion.dot_template_name = "burning_1W_dot"
ExplosionTemplates.fireball_charged_t3.explosion.dot_template_name_glance = "burning_1W_dot"

--[[local function add_weapon_data(action_no, action_from, value, new_data)
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

end]]