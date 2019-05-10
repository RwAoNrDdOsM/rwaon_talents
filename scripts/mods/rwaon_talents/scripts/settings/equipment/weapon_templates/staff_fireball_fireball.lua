local mod = get_mod("rwaon_talents")

-- Fireball Staff

------------------------------------------------------------------------------
-- Charged Shot Changes


-- Increased Damage
NewDamageProfileTemplates.staff_fireball_charged = {
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

--Increased scaled overcharge
mod:hook_origin(PlayerUnitOverchargeExtension, "add_charge", function (self, overcharge_amount, charge_level)
	local buff_extension = self.buff_extension

	if buff_extension:has_buff_type("twitch_no_overcharge_no_ammo_reloads") then
		return
	end

	local max_value = self.max_value
	local current_overcharge_value = self.overcharge_value
	local new_overcharge_value = nil

	if charge_level then
		overcharge_amount = 0.6 * overcharge_amount + 0.4 * overcharge_amount * charge_level -- 0.4 + 0.6
	end

	overcharge_amount = self.buff_extension:apply_buffs_to_value(overcharge_amount, "reduced_overcharge")

	if current_overcharge_value <= max_value * 0.97 and max_value < current_overcharge_value + overcharge_amount then
		self:hud_sound(self.overcharge_warning_critical_sound_event or "staff_overcharge_warning_critical", self.first_person_extension)

		new_overcharge_value = max_value - 0.1
	else
		new_overcharge_value = math.min(current_overcharge_value + overcharge_amount, max_value)
	end

	self:_check_overcharge_level_thresholds(new_overcharge_value)

	self.time_when_overcharge_start_decreasing = Managers.time:time("game") + self.time_until_overcharge_decreases
	self.overcharge_value = new_overcharge_value
end)


-- Increased radius
ExplosionTemplates.fireball_charged = {
	explosion = {
		use_attacker_power_level = true,
		radius_min = 1.25, -- 1.25
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

-- Increase Explosion Damage
NewDamageProfileTemplates.fireball_charged_explosion = {
	charge_value = "aoe",
	armor_modifier = {
		attack = {
			1,
			0.25,
			1.5,
			1,
			0.75,
			0
		},
		impact = {
			1,
			0.5,
			1,
			1,
			0.75,
			0
		}
	},
	default_target = {
		attack_template = "drakegun",
		dot_template_name = "burning_1W_dot",
		damage_type = "drakegun",
		power_distribution = {
			attack = 0.3, -- 0.25
			impact = 0.5
		}
	},
	targets = {
		attack_template = "drakegun",
		dot_template_name = "burning_1W_dot",
		damage_type = "drakegun",
		power_distribution = {
			attack = 0.3, -- 0.25
			impact = 0.5
		}
	}
}

NewDamageProfileTemplates.fireball_charged_explosion_glance = table.clone(NewDamageProfileTemplates.fireball_charged_explosion)
NewDamageProfileTemplates.fireball_charged_explosion_glance.default_target.attack_template = "drakegun_glance"
NewDamageProfileTemplates.fireball_charged_explosion_glance.default_target.damage_type = "drakegun_glance"
NewDamageProfileTemplates.fireball_charged_explosion_glance.default_target.dot_template_name = "burning_1W_dot"
    
for _, staff_fireball_fireball in ipairs{
    "staff_fireball_fireball_template_1",
} do
    local weapon_template = Weapons[staff_fireball_fireball]
    local action_one = weapon_template.actions.action_one
	local action_two = weapon_template.actions.action_two
end