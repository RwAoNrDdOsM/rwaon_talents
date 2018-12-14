
local mod = get_mod("rwaon_talents")
-- Conflagoration Staff
------------------------------------------------------------------------------

--Radius Change


    
for _, staff_fireball_geiser in ipairs{
    "staff_fireball_geiser_template_1",
} do
    local weapon_template = Weapons[staff_fireball_geiser]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    add_weapon_value(action_two, "default", "max_radius", 4.2) --3.5
    --add_weapon_data(action_two, "default", "max_radius", 4.2) --3.5
end

------------------------------------------------------------------------------

-- Dot and Damage

mod:add_buff("burning_geiser_dot", {
    duration = 5,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1,
    damage_type = "burninating",
    damage_profile = "burning_geiser_dot",
    update_func = "apply_dot_damage"
})

mod:add_buff("burning_geiser_dot_infinite", {
	damage_profile = "burning_geiser_dot",
	name = "burning dot",
	end_flow_event = "smoke",
	start_flow_event = "burn_infinity",
	death_flow_event = "burn_death",
	remove_buff_func = "remove_dot_damage",
	apply_buff_func = "start_dot_damage",
	time_between_dot_damages = 1,
	damage_type = "burninating",
	max_stacks = 1,
	update_func = "apply_dot_damage"
})

DamageProfileTemplates.burning_geiser_dot = table.clone(DamageProfileTemplates.default)
DamageProfileTemplates.burning_geiser_dot.no_stagger = true
DamageProfileTemplates.burning_geiser_dot.default_target.damage_type = "burninating"
DamageProfileTemplates.burning_geiser_dot.default_target.armor_modifier = {
	attack = {
		1,
		0.75,
		3,
		1,
		1,
		0
	},
	impact = {
		1,
		0,
		0,
		1,
		1,
		0
	}
}
DamageProfileTemplates.burning_geiser_dot.default_target.power_distribution = {
	attack = 0.075, --0.05
	impact = 0.05
}

InfiniteBurnDotLookup = {
	sienna_adept_ability_trail = "sienna_adept_ability_trail_infinite",
	burning_dot = "burning_dot_infinite",
	burning_1W_dot = "burning_1W_dot_infinite",
	burning_flamethrower_dot = "burning_flamethrower_dot_infinite",
	burning_3W_dot = "burning_3W_dot_infinite",
	beam_burning_dot = "beam_burning_dot_infinite",
	burning_geiser_dot = "burning_geiser_dot_infinite"
}

DotTypeLookup = {
	burning_dot = "burning_dot",
	burning_3W_dot = "burning_dot",
	corpse_explosion_default = "poison_dot",
	arrow_poison_dot = "poison_dot",
	beam_burning_dot = "burning_dot",
	weapon_bleed_dot_test = "poison_dot",
	burning_1W_dot = "burning_dot",
	burning_flamethrower_dot = "burning_dot",
	burning_geiser_dot = "burning_dot",
	aoe_poison_dot = "poison_dot",
	slow_grenade_slow = "slow_debuff",
	chaos_zombie_explosion = "poison_dot"
}

DamageProfileTemplates.geiser = {
	dot_template_name = "burning_geiser_dot",
	charge_value = "aoe",
	attack_template = "wizard_staff_geiser",
	critical_strike = {
		attack_armor_power_modifer = {
			1,
			0.5,
			1,
			1,
			1,
			0.25
		},
		impact_armor_power_modifer = {
			1,
			1.5,
			1,
			1,
			1,
			0.5
		}
	},
	armor_modifier = {
		attack = {
			1,
			0.5,
			1,
			1,
			1,
			0
		},
		impact = {
			1,
			1.5,
			1,
			1,
			1,
			0.5
		}
	},
	cleave_distribution = {
		attack = 0.2,
		impact = 0.2
	},
	target_radius = {
		0.36, --0.3
		1 --0.8
	},
	default_target = { --outside circle
		boost_curve_type = "ninja_curve",
		boost_curve_coefficient = 1,
		attack_template = "wizard_staff_geiser",
		power_distribution = {
			attack = 0.025, --0.05
			impact = 0.175
		}
	},
	targets = {
		{ --Inside circle
			boost_curve_type = "ninja_curve",
			boost_curve_coefficient = 1,
			attack_template = "wizard_staff_geiser",
			power_distribution = {
				attack = 0.15, --0.3
				impact = 0.7
			}
		},
		{ --On circle
			boost_curve_type = "ninja_curve",
			boost_curve_coefficient = 1,
			attack_template = "wizard_staff_geiser",
			power_distribution = {
				attack = 0.0625, --0.125
				impact = 0.35
			}
		}
	}
}

------------------------------------------------------------------------------

--Fire Patch

--[[
ExplosionTemplates.conflag.aoe = {
    dot_template_name = "burning_geiser_dot",
    radius = 5, --4
    nav_tag_volume_layer = "fire_grenade",
    create_nav_tag_volume = true,
    attack_template = "wizard_staff_geiser",
    sound_event_name = "player_combat_weapon_fire_grenade_explosion",
    damage_interval = 1,
    duration = 5, --2
    area_damage_template = "explosion_template_aoe",
    nav_mesh_effect = {
            particle_radius = 2,
            particle_name = "fx/wpnfx_fire_grenade_impact_remains",
            particle_spacing = 0.9
    }
}]]