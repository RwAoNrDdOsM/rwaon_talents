local mod = get_mod("rwaon_talents")

-- Hagban Bow

------------------------------------------------------------------------------
-- Dot Changes

--[[AttackTemplates.arrow_poison_hagbane_aoe = {
    stagger_value = 2,
    sound_type = "medium",
    damage_type = "arrow_poison"
}
AttackTemplates.arrow_poison_hagbane_aoe_t2 = {
    dot_template_name = "aoe_poison_dot_hagbane",
    sound_type = "medium",
    damage_type = "arrow_poison",
    stagger_value = 2,
    dot_type = "poison_dot"
}
AttackTemplates.arrow_poison_hagbane_aoe_t3 = {
    dot_template_name = "aoe_poison_dot_hagbane",
    sound_type = "medium",
    damage_type = "arrow_poison",
    stagger_value = 2,
    dot_type = "poison_dot"
}

BuffTemplates.arrow_poison_dot_hagbane = {
    buffs = {
        {
            duration = 6, -- 3
            name = "arrow poison dot",
            start_flow_event = "poisoned",
            end_flow_event = "poisoned_end",
            death_flow_event = "poisoned_death",
            remove_buff_func = "remove_dot_damage",
            apply_buff_func = "start_dot_damage",
            time_between_dot_damages = 1.2, -- 0.6
            damage_profile = "poison_direct",
            update_func = "apply_dot_damage",
            reapply_buff_func = "reapply_dot_damage"
        }
    }
}

BuffTemplates.aoe_poison_dot_hagbane = {
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
}

DamageProfileTemplates.poison_aoe_hagbane = {
	no_friendly_fire = true,
	require_damage_for_dot = true,
	no_stagger = false,
	armor_modifier = {
		attack = {
			1,
			0,
			1.5,
			1,
			1,
			0
		},
		impact = {
			1,
			0.75,
			1,
			1,
			0.5,
			0
		}
	},
	default_target = {
		attack_template = "arrow_poison_hagbane_aoe",
		dot_template_name = "aoe_poison_dot_hagbane",
		damage_type = "poison",
		power_distribution = {
			attack = 0.05,
			impact = 0.5
		}
    },
    targets = {
		attack_template = "arrow_poison_hagbane_aoe",
		dot_template_name = "aoe_poison_dot_hagbane",
		damage_type = "poison",
		power_distribution = {
			attack = 0.05,
			impact = 0.5
		}
    },
}

ExplosionTemplates.carbine_poison_arrow = {
    explosion = {
        use_attacker_power_level = true,
        radius = 2,
        no_prop_damage = true,
        sound_event_name = "arrow_hit_poison_cloud",
        damage_profile = "poison_aoe_hagbane",
        effect_name = "fx/wpnfx_poison_arrow_impact_carbine"
    }
}

DamageProfileTemplates.shortbow_hagbane_charged.default_target.dot_template_name = "arrow_poison_dot_hagbane"

DamageProfileTemplates.shortbow_hagbane_charged.targets = {
    dot_template_name = "arrow_poison_dot_hagbane",
	boost_curve_type = "ninja_curve",
    boost_curve_coefficient = 0.5,
    attack_template = "arrow_machinegun",
	power_distribution_near = {
		attack = 0.1,
		impact = 0.15
	},
	power_distribution_far = {
		attack = 0.075,
		impact = 0.1
	},
	range_dropoff_settings = {
		dropoff_start = 10,
		dropoff_end = 30
	}
}]]

-- Quick fix

BuffTemplates.arrow_poison_dot = {
    buffs = {
        {
            duration = 6, -- 3
            name = "arrow poison dot",
            start_flow_event = "poisoned",
            end_flow_event = "poisoned_end",
            death_flow_event = "poisoned_death",
            remove_buff_func = "remove_dot_damage",
            apply_buff_func = "start_dot_damage",
            time_between_dot_damages = 1.2, -- 0.6
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
}