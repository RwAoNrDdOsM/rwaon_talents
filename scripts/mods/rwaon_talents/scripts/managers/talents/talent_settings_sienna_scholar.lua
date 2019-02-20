local mod = get_mod("rwaon_talents")
------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 1, 1, "rwaon_sienna_scholar_reduced_spread", {
    num_ranks = 1,
    icon = "sienna_scholar_reduced_spread",
    description_values = {
        {
            value_type = "percent",
            value = -0.4
        }
    },
    buffs = {
        "rwaon_sienna_scholar_reduced_spread"
    },
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_reduced_spread", {
    multiplier = -0.4, -- MODIFIED
    stat_buff = StatBuffIndex.REDUCED_SPREAD,
})

mod:add_talent("bw_scholar", 1, 2, "rwaon_sienna_scholar_on_elite_special_killed", {
    num_ranks = 1,
    icon = "sienna_scholar_increased_attack_speed",
    description_values = {
        {
            value_type = "percent",
            value = 0.03
        },
        { 
            value = 10 
        },
        { 
            value = 5 
        },
    },
    buffs = {
        "rwaon_sienna_scholar_on_elite_special_killed"
    },
})

local Unit_get_data = Unit.get_data
mod:hook_safe(StatisticsUtil, "register_kill", function (victim_unit, damage_data, statistics_db, is_server)
    rwaon_damaging_unit_data = victim_unit
end)

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_on_elite_special_killed", {
    max_stacks = 1,
    event_buff = true,
    event = "on_kill",
    --icon = "icons_placeholder",
    buff_func = function (unit, buff, params)
        local killing_blow = params[1]

        local damage_amount          = killing_blow[1]
        local damage_type            = killing_blow[2]
        local attacker_unit          = killing_blow[3]
        local hit_zone_name          = killing_blow[4]
        local hit_position_table     = killing_blow[5]
        local damage_direction_table = killing_blow[6]
        local damage_source          = killing_blow[7]
        local hit_ragdoll_actor      = killing_blow[8]
        local unknown_thing          = killing_blow[9]
        

        mod:pcall(function()
            local local_player = Managers.player:local_player()
            local player_unit = local_player.player_unit
            local network_manager = Managers.state.network
            local victim_unit = rwaon_damaging_unit_data
            local unit_type = mod:unit_category(victim_unit)
            
            if (unit_type == "special" or unit_type == "elite") then
                local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
                buff_extension:add_buff("rwaon_sienna_scholar_on_elite_special_killed_buff", buff_params)
            end
        end)
    end,
})


mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_on_elite_special_killed_buff", {
    duration = 10,
    max_stacks = 5,
    refresh_durations = true,
    multiplier = 0.03,  
    icon = "sienna_scholar_increased_attack_speed",
    stat_buff = StatBuffIndex.INCREASED_WEAPON_DAMAGE_MELEE,
})

------------------------------------------------------------------------------
--[[mod:add_talent("bw_scholar", 2, 1, "rwaon_sienna_scholar_armour_dot", {
    description_values = {},
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    buffer = "server",
})]]

mod:add_talent("bw_scholar", 2, 3, "rwaon_sienna_scholar_double_dot_duration", {
    description_values = {},
    icon = "sienna_adept_charge_speed_increase",
    buffer = "server",
})

mod:dofile("scripts/mods/rwaon_talents/scripts/managers/talents/talent_settings_sienna_extra/burning_dots")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 3, 1, "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge", {
    icon = "sienna_scholar_increased_ranged_charge_speed_on_low_health",
    buffer = "server",
    description_values = {
        { 
            value = 0.1, 
            value_type = "percent", 
        },
        { 
            value = 6 
        },
        { 
            value = 5 
        },
    },
	buffs = {
        "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge",
        "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge_icon",
	},
})

local function is_local(unit)
	local player = Managers.player:owner(unit)

	return player and not player.remote
end

BuffFunctionTemplates.functions.update_multiplier_based_on_overcharge_chunks = function (unit, buff, params)
    if is_local(unit) then
        local overcharge_extension = ScriptUnit.extension(unit, "overcharge_system")
        local overcharge, threshold, max_overcharge = overcharge_extension:current_overcharge_status()
        local template = buff.template
        local min_multiplier = template.min_multiplier
        local max_multiplier = template.max_multiplier
        local chunk_size = template.chunk_size
        local stat_buff_index = template.stat_buff
        local previous_multiplier = buff.previous_multiplier or 0
        local num_chunks = math.floor(overcharge / chunk_size)
        local multiplier = math.clamp(num_chunks * min_multiplier, 0, max_multiplier)
        buff.multiplier = multiplier
        
        if stat_buff_index and previous_multiplier ~= multiplier then
            local buff_extension = ScriptUnit.extension(unit, "buff_system")
            local difference = multiplier - previous_multiplier

            buff_extension:update_stat_buff(stat_buff_index, difference)
        end

        buff.previous_multiplier = multiplier
    end
end

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge", {
    chunk_size = 6,
    min_multiplier = 0.1,
    max_multiplier = 0.5,
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
    update_func = "update_multiplier_based_on_overcharge_chunks"
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge_icon", {
    chunk_size = 6,
    buff_to_add = "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge_icon_dummy",
	update_func = "activate_buff_stacks_based_on_overcharge_chunks"
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_crit_damage_from_overcharge_icon_dummy", {
    max_stacks = 5,
    icon = "sienna_scholar_increased_ranged_charge_speed_on_low_health",
})

mod:add_talent("bw_scholar", 3, 3, "rwaon_sienna_scholar_passive_increased_attack_speed_from_overcharge", {
    name = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    description_values = {
        { 
            value = 0.05, 
            value_type = "percent", 
        },
        { 
            value = 6 
        },
        { 
            value = 5 
        },
        {
            value = 0.1, 
            value_type = "percent", 
        },
    },
    buffs = {
        "sienna_scholar_passive_increased_attack_speed_from_overcharge",
        "rwaon_sienna_scholar_passive_increased_attack_speed_debuff",
    },
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_attack_speed", {
    max_stacks = 5,
    multiplier = 0.05,  -- Multiplier (MODIFIED!)
    icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    stat_buff = StatBuffIndex.ATTACK_SPEED,
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_attack_speed_debuff", {
    max_stacks = 1,
    multiplier = -0.1,
    --icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    stat_buff = StatBuffIndex.ATTACK_SPEED,
})
------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 4, 2, "sienna_scholar_regrowth", {
    name = "sienna_scholar_bloodlust_2",
    description = "regrowth_desc_3",
	num_ranks = 1,
	buffer = "both",
	icon = "kerillian_shade_regrowth",
	description_values = {
		{
			value = 2
		}
	},
	requirements = {},
	buffs = {
		"sienna_scholar_regrowth"
	},
	buff_data = {}
})

mod:add_talent_buff("bright_wizard", "sienna_scholar_regrowth", {
    name = "regrowth",
    event_buff = true,
    event = "on_hit",
    perk = "ninja_healing",
    bonus = 2,
    buff_func = ProcFunctions.heal_finesse_damage_on_melee
})

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 5, 1, "rwaon_sienna_scholar_embodiment_of_aqshy", {
    description_values = {
        { 
            value = 3 
        },
        { 
            value = 10 
        },
    },
    icon = "sienna_scholar_activated_ability_dump_overcharge",
    buffs = {},
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_embodiment_of_aqshy_overcharge", {
    duration = 10,
    refresh_durations = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    icon = "sienna_scholar_activated_ability_dump_overcharge",
    --dormant = true,
    bonus = 3,
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
		end
        
        local hit_unit = params[1]
        local attack_type = params[2]
        local hit_zone_name = params[3]
        local target_number = params[4]
        local buff_type = params[5]
        local is_critical = params[6]  

        if attack_type == "projectile" and buff_type == "n/a" then
            return
        end

		if Unit.alive(player_unit) then
			local overcharge_amount = buff.bonus
			local overcharge_extension = ScriptUnit.extension(player_unit, "overcharge_system")

			if overcharge_extension then
				overcharge_extension:remove_charge(overcharge_amount)
			end
		end
	end,
})

mod:add_talent("bw_scholar", 5, 2, "rwaon_sienna_scholar_activated_ability_heal", {
    name = "sienna_scholar_activated_ability_heal",
	num_ranks = 1,
	icon = "sienna_scholar_activated_ability_heal",
	description_values = {
        {
			value = 30
		},
        {
            value_type = "percent",
            value = 0.3
        },
	},
    buffs = {
        "rwaon_sienna_scholar_activated_ability_anitcooldown",
    },
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_activated_ability_anitcooldown", {
	multiplier = 0.3,
	stat_buff = StatBuffIndex.ACTIVATED_COOLDOWN,
})


mod:add_talent("bw_scholar", 5, 3, "rwaon_sienna_scholar_increased_speed", {
    num_ranks = 1,
    buffer = "both",
    icon = "sienna_scholar_activated_ability_cooldown",
    description_values = {
        {
            value = 10
        },
        {
            value_type = "percent",
            value = 0.15
        }
    },
    requirements = {},
    buffs = {},
    buff_data = {}
})


mod:add_buff_extra("rwaon_sienna_scholar_increased_speed", {
    activation_effect = "fx/screenspace_potion_03",
    deactivation_sound = "hud_gameplay_stance_deactivate",
    activation_sound = "hud_gameplay_stance_tank_activate",
    buffs = {
        {
            apply_buff_func = "apply_movement_buff",
            multiplier = 1.15, -- 1.5
            --name = "movement",
            icon = "sienna_scholar_activated_ability_cooldown",
            refresh_durations = true,
            remove_buff_func = "remove_movement_buff",
            --max_stacks = 1,
            duration = 10,
            dormant = false,
            path_to_movement_setting_to_modify = {
                "move_speed"
            }
        },
        {
            multiplier = 0.15, -- 0.5
            --name = "attack speed buff",
            refresh_durations = true,
            --max_stacks = 1,
            duration = 10,
            stat_buff = StatBuffIndex.ATTACK_SPEED
        },
    }
})