--local mod = get_mod("rwaon_talents")
local mod = get_mod("staff_fireball_fireball")
-- Fireball Staff
------------------------------------------------------------------------------

--Charged Shot Changes
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
			attack = 0.05, --0.3
			impact = 0.5
		},
		power_distribution_far = {
			attack = 0.05, --0.3
			impact = 0.25
		},
		range_dropoff_settings = shotgun_dropoff_ranges
    },
    targets = {
        {
            dot_template_name = "burning_1W_dot",
            boost_curve_type = "ninja_curve",
            boost_curve_coefficient = 1,
            attack_template = "fireball",
            power_distribution_near = {
                attack = 0.05, --0.3
                impact = 0.5
            },
            power_distribution_far = {
                attack = 0.05, --0.3
                impact = 0.25
            },
            range_dropoff_settings = shotgun_dropoff_ranges
        }
	}
}
DamageProfileTemplates.staff_fireball_charged_2 = {
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
        {
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
        }
	}
}
DamageProfileTemplates.staff_fireball_charged_3 = {
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
			attack = 0.3, --0.3
			impact = 0.5
		},
		power_distribution_far = {
			attack = 0.3, --0.3
			impact = 0.25
		},
		range_dropoff_settings = shotgun_dropoff_ranges
    },
    targets = {
        {
            dot_template_name = "burning_1W_dot",
            boost_curve_type = "ninja_curve",
            boost_curve_coefficient = 1,
            attack_template = "fireball",
            power_distribution_near = {
                attack = 0.3, --0.3
                impact = 0.5
            },
            power_distribution_far = {
                attack = 0.3, --0.3
                impact = 0.25
            },
            range_dropoff_settings = shotgun_dropoff_ranges
        }
	}
}

ExplosionTemplates.fireball_charged = {
    explosion = {
        use_attacker_power_level = true,
        radius_min = 1.25,
        sound_event_name = "fireball_big_hit",
        radius_max = 3,
        attacker_power_level_offset = 0.25,
        max_damage_radius_min = 0.5,
        alert_enemies_radius = 10,
        damage_profile_glance = "fireball_charged_explosion_glance",
        max_damage_radius_max = 2,
        alert_enemies = true,
        damage_profile = "fireball_charged_explosion",
        effect_name = "fx/wpnfx_fireball_charged_impact"
    }
}
ExplosionTemplates.fireball_charged_2 = {
    explosion = {
        use_attacker_power_level = true,
        radius_min = 1.25,
        sound_event_name = "fireball_big_hit",
        radius_max = 3,
        attacker_power_level_offset = 0.25,
        max_damage_radius_min = 0.5,
        alert_enemies_radius = 10,
        damage_profile_glance = "fireball_charged_explosion_glance_2",
        max_damage_radius_max = 2,
        alert_enemies = true,
        damage_profile = "fireball_charged_explosion_2",
        effect_name = "fx/wpnfx_fireball_charged_impact"
    }
}
ExplosionTemplates.fireball_charged_3 = {
    explosion = {
        use_attacker_power_level = true,
        radius_min = 1.25,
        sound_event_name = "fireball_big_hit",
        radius_max = 3,
        attacker_power_level_offset = 0.25,
        max_damage_radius_min = 0.5,
        alert_enemies_radius = 10,
        damage_profile_glance = "fireball_charged_explosion_glance_3",
        max_damage_radius_max = 2,
        alert_enemies = true,
        damage_profile = "fireball_charged_explosion_3",
        effect_name = "fx/wpnfx_fireball_charged_impact"
    }
}

DamageProfileTemplates.fireball_charged_explosion = {
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
			attack = 0.075,
			impact = 0.5
		}
	}
}
DamageProfileTemplates.fireball_charged_explosion_2 = {
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
			attack = 0.125,
			impact = 0.5
		}
	}
}
DamageProfileTemplates.fireball_charged_explosion_3 = {
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
			attack = 0.25,
			impact = 0.5
		}
	}
}

DamageProfileTemplates.fireball_charged_explosion_glance = table.clone(DamageProfileTemplates.fireball_charged_explosion)
DamageProfileTemplates.fireball_charged_explosion_glance.default_target.attack_template = "fireball_charged_explosion_glance"
DamageProfileTemplates.fireball_charged_explosion_glance.default_target.damage_type = "fireball_charged_explosion_glance"
DamageProfileTemplates.fireball_charged_explosion_glance.default_target.dot_template_name = "burning_1W_dot"
DamageProfileTemplates.fireball_charged_explosion_glance_2 = table.clone(DamageProfileTemplates.fireball_charged_explosion_2)
DamageProfileTemplates.fireball_charged_explosion_glance_2.default_target.attack_template = "fireball_charged_explosion_glance_2"
DamageProfileTemplates.fireball_charged_explosion_glance_2.default_target.damage_type = "fireball_charged_explosion_glance_2"
DamageProfileTemplates.fireball_charged_explosion_glance_2.default_target.dot_template_name = "burning_1W_dot"
DamageProfileTemplates.fireball_charged_explosion_glance_3 = table.clone(DamageProfileTemplates.fireball_charged_explosion_3)
DamageProfileTemplates.fireball_charged_explosion_glance_3.default_target.attack_template = "fireball_charged_explosion_glance_3"
DamageProfileTemplates.fireball_charged_explosion_glance_3.default_target.damage_type = "fireball_charged_explosion_glance_3"
DamageProfileTemplates.fireball_charged_explosion_glance_3.default_target.dot_template_name = "burning_1W_dot"


AttackTemplates.fireball_charged_explosion_glance = {
    dot_template_name = "burning_1W_dot",
    stagger_value = 0.5,
    dot_type = "burning_dot"
}
AttackTemplates.fireball_charged_explosion_glance_2 = {
    dot_template_name = "burning_1W_dot",
    stagger_value = 1,
    dot_type = "burning_dot"
}
AttackTemplates.fireball_charged_explosion_glance_3 = {
    dot_template_name = "burning_1W_dot",
    stagger_value = 2,
    dot_type = "burning_dot"
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
    add_weapon_action(action_one, "shoot_charged_2", {
        scale_overcharge = true,
		alert_sound_range_hit = 2,
		fire_at_gaze_setting = "tobii_fire_at_gaze_fireball",
		charge_value = "light_attack",
		kind = "charged_projectile",
		fire_sound_event_parameter = "drakegun_charge_fire",
		is_spell = true,
		scale_power_level = 0.5,
		overcharge_type = "fireball_charged",
		fire_sound_event = "player_combat_weapon_staff_fireball_fire",
		hit_effect = "fireball_impact",
		apply_recoil = true,
		throw_up_this_much_in_target_direction = 0.1,
		alert_sound_range_fire = 12,
		fire_time = 0.3,
		fire_sound_on_husk = true,
		speed = 3000,
		anim_event = "attack_shoot_fireball_charged",
		total_time = 1,
		allowed_chain_actions = {
				{
					sub_action = "default",
					start_time = 0.4,
					action = "action_wield",
					input = "action_wield"
				},
				{
					sub_action = "default",
					start_time = 0.6,
					action = "action_one",
					release_required = "action_two_hold",
					input = "action_one"
				},
				{
					sub_action = "default",
					start_time = 0.5,
					action = "action_two",
					input = "action_two_hold",
					end_time = math.huge
				},
				{
					sub_action = "default",
					start_time = 0.2,
					action = "weapon_reload",
					input = "weapon_reload"
				}
		},
		enter_function = function (attacker_unit, input_extension)
				input_extension:clear_input_buffer()

				return input_extension:reset_release_input()
		end,
		projectile_info = Projectiles.fireball_charged,
		impact_data = {
			damage_profile = "staff_fireball_charged_2",
			aoe = ExplosionTemplates.fireball_charged_2
		},
		timed_data = {
			life_time = 1.5,
			aoe = ExplosionTemplates.fireball_charged_2
		},
		recoil_settings = {
				horizontal_climb = 0,
				restore_duration = 0.2,
				vertical_climb = -1,
				climb_duration = 0.2,
				climb_function = math.easeInCubic,
				restore_function = math.ease_out_quad
		}
	})
    add_weapon_action(action_one, "shoot_charged_3", {
        scale_overcharge = true,
		alert_sound_range_hit = 2,
		fire_at_gaze_setting = "tobii_fire_at_gaze_fireball",
		charge_value = "light_attack",
		kind = "charged_projectile",
		fire_sound_event_parameter = "drakegun_charge_fire",
		is_spell = true,
		scale_power_level = 0.5,
		overcharge_type = "fireball_charged",
		fire_sound_event = "player_combat_weapon_staff_fireball_fire",
		hit_effect = "fireball_impact",
		apply_recoil = true,
		throw_up_this_much_in_target_direction = 0.1,
		alert_sound_range_fire = 12,
		fire_time = 0.3,
		fire_sound_on_husk = true,
		speed = 3000,
		anim_event = "attack_shoot_fireball_charged",
		total_time = 1,
		allowed_chain_actions = {
			{
				sub_action = "default",
				start_time = 0.4,
				action = "action_wield",
				input = "action_wield"
			},
			{
				sub_action = "default",
				start_time = 0.6,
				action = "action_one",
				release_required = "action_two_hold",
				input = "action_one"
			},
			{
				sub_action = "default",
				start_time = 0.5,
				action = "action_two",
				input = "action_two_hold",
				end_time = math.huge
			},
			{
				sub_action = "default",
				start_time = 0.2,
				action = "weapon_reload",
				input = "weapon_reload"
			}
		},
		enter_function = function (attacker_unit, input_extension)
				input_extension:clear_input_buffer()

				return input_extension:reset_release_input()
		end,
		projectile_info = Projectiles.fireball_charged,
		impact_data = {
				damage_profile = "staff_fireball_charged_3",
				aoe = ExplosionTemplates.fireball_charged_3
		},
		timed_data = {
				life_time = 1.5,
				aoe = ExplosionTemplates.fireball_charged_3
		},
		recoil_settings = {
				horizontal_climb = 0,
				restore_duration = 0.2,
				vertical_climb = -1,
				climb_duration = 0.2,
				climb_function = math.easeInCubic,
				restore_function = math.ease_out_quad
		}
		})
    add_weapon_data(action_two, "default", "allowed_chain_actions", {
        {
            sub_action = "default",
            start_time = 0.2,
            action = "action_wield",
            input = "action_wield"
        },
        {
            sub_action = "shoot_charged_3",
            start_time = 2.2,
            action = "action_one",
            input = "action_one"
        },
        {
            sub_action = "shoot_charged_2",
            start_time = 1.2,
            action = "action_one",
            input = "action_one"
        },
        {
            sub_action = "shoot_charged",
            start_time = 0.2,
            action = "action_one",
            input = "action_one"
        },
        {
            sub_action = "default",
            start_time = 0.2,
            action = "weapon_reload",
            input = "weapon_reload"
        }
    })
end

-- Think I need this but idk
--[[
NetworkLookup.damage_profiles.staff_fireball_charged = "staff_fireball_charged"
NetworkLookup.damage_profiles.staff_fireball_charged_2 = "staff_fireball_charged_2"
NetworkLookup.damage_profiles.staff_fireball_charged_3 = "staff_fireball_charged_3"
NetworkLookup.damage_profiles.fireball_charged_explosion = "fireball_charged_explosion"
NetworkLookup.damage_profiles.fireball_charged_explosion_2 = "fireball_charged_explosion_2"
NetworkLookup.damage_profiles.fireball_charged_explosion_3 = "fireball_charged_explosion_3"
NetworkLookup.damage_profiles.fireball_charged_explosion_glance = "fireball_charged_explosion_glance"
NetworkLookup.damage_profiles.fireball_charged_explosion_glance_2 = "fireball_charged_explosion_glance_2"
NetworkLookup.damage_profiles.fireball_charged_explosion_glance_3 = "fireball_charged_explosion_glance_3"]]