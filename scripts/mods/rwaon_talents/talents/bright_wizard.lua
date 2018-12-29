local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 2, 3, "rwaon_sienna_scholar_double_dot_duration", {
    description_values = {},
    buffer = "server",
})

mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard_talent_extras/double_dot_duration")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 3, 1, "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge", {
    description_values = {
        { value = 0.04, value_type = "percent", }, -- Multiplier
        { value = 6 }, -- Chunk size
        { value = 5 }, -- Max stacks
    },
	buffs = {
		"rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge"
	},
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge", {
    chunk_size = 6,
    buff_to_add = "rwaon_sienna_scholar_passive_increased_headshot_damage",
    update_func = "activate_buff_stacks_based_on_overcharge_chunks"
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage", {
    max_stacks = 5,
    multiplier = 0.04,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
})

mod:add_talent("bw_scholar", 3, 3, "sienna_scholar_passive_increased_attack_speed_from_overcharge", {
    --icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    description_values = {
        { value = 0.03, value_type = "percent", }, -- Multiplier (MODIFIED!)
        { value = 6 }, -- Chunk size
        { value = 5 }, -- Max stacks
    },
    buffs = {
        "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    },
})

mod:add_talent_buff("bright_wizard", "sienna_scholar_passive_increased_attack_speed", {
    max_stacks = 5,
    multiplier = 0.03,  -- Multiplier (MODIFIED!)
    icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    stat_buff = StatBuffIndex.ATTACK_SPEED,
})

------------------------------------------------------------------------------
--[[
mod:add_talent("bw_scholar", 4, 2, "rwaon_sienna_scholar_sear_wounds", {
    description_values = {
        { value = 5 }, -- Heal ammount
    },
    buffs = {
        "rwaon_sienna_scholar_sear_wounds",
    },
})
mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_sear_wounds", {
    event = "on_kill",
    event_buff = true,
    buff_func = function(player, buff, params)
        local player_unit = player.player_unit

        local killing_blow = params[1]
        local breed_data = params[2]

        local damage_amount          = killing_blow[1]
        local damage_type            = killing_blow[2]
        local attacker_unit          = killing_blow[3] --  or victim_unit
        local hit_zone_name          = killing_blow[4]
        local hit_position_table     = killing_blow[5]
        local damage_direction_table = killing_blow[6]
        local damage_source          = killing_blow[7]
        local hit_ragdoll_actor      = killing_blow[8]
        local unknown_thing          = killing_blow[9]

        if damage_source ~= "sienna_scholar_career_skill_weapon" then
            return
        end

        if not Unit.alive(player_unit) or not Managers.player.is_server then
            return
        end

        local heal_amount = 5
        DamageUtils.heal_network(player_unit, player_unit, heal_amount, "heal_from_proc")
    end,
})]]

------------------------------------------------------------------------------

--[[
mod:add_talent("bw_scholar", 5, 2, "rwaon_sienna_scholar_embodiment_of_aqshy", {
    description_values = {},
    --buff_after_delay = true,
    --max_stacks = 1,
    --refresh_durations = true,
    --is_dormant = false,
    --is_cooldown = true,
	--duration = 120,
    --delayed_buff_name = "rwaon_sienna_scholar_cascading_firecloak"
})

mod:add_buff("rwaon_sienna_scholar_embodiment_of_aqshy", {
    max_stacks = 1,
    activation_effect = "fx/screenspace_overheat_critical",
    deactivation_sound = "hud_gameplay_stance_deactivate",
    activation_sound = "hud_gameplay_stance_tank_activate",
    icon = "icons_placeholder",
    duration = 10,
	buffs = {
		{
			apply_buff_func = "apply_movement_buff",
			multiplier = 1.5,
			max_stacks = 1,
			path_to_movement_setting_to_modify = {
				"move_speed"
			}
		},
		{
			multiplier = 1.5,
			max_stacks = 1,
            stat_buff = StatBuffIndex.ATTACK_SPEED
        },
        {
            multiplier = -1.5,
            max_stacks = 1,
            stat_buff = StatBuffIndex.REDUCED_OVERCHARGE
        }
	}
})]]

--[[mod:add_talent("bw_scholar", 5, 3, "rwaon_sienna_scholar_cascading_firecloak", {
    description_values = {
        { value = 0.3, value_type = "percent" },
        { value = 5 },
    },
    buffer = "server",
    buffs = {
        "rwaon_sienna_scholar_cascading_firecloak_cooldown",
    },
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_cascading_firecloak_on_damage_taken", {
    max_stacks = 1,
    icon = "icons_placeholder",
    priority_buff = true,
    stat_buff = StatBuffIndex.DAMAGE_TAKEN,
    duration = 5,
    multiplier = -1,
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_cascading_firecloak_cooldown", {
    remove_buff = "rwaon_sienna_scholar_gain_cascading_firecloak",
    buff_after_delay = true,
    max_stacks = 1,
    refresh_durations = true,
    is_cooldown = true,
    duration = 5,
    icon = "icons_placeholder",
    delayed_buff_name = "rwaon_sienna_scholar_gain_cascading_firecloak",
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_gain_cascading_firecloak", {
    remove_on_proc = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    icon = "icons_placeholder",
    buff_func = function(player, buff, params)
        local player_unit = player.player_unit
        local status_extension = ScriptUnit.extension(player_unit, "status_system")
    
        if Unit.alive(player_unit) and not status_extension:is_knocked_down() then
            local health_extension = ScriptUnit.extension(player_unit, "health_system")
            local health_min = 0.3
            local current_health = health_extension:current_health()
            local below_threshold = current_health <= health_min
    
            --if below_threshold then
                local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
    
                buff_extension:add_buff("rwaon_sienna_scholar_cascading_firecloak_cooldown")
                buff_extension:add_buff("rwaon_sienna_scholar_cascading_firecloak_on_damage_taken")
    
                local owner_unit = Managers.player:local_player().player_unit
                local position = Unit.local_position(owner_unit, 0)
                local rotation = Unit.local_rotation(owner_unit, 0)
                local explosion_template = "cascading_firecloak"
                local scale = 1
                local area_damage_system = Managers.state.entity:system("area_damage_system")
    
                area_damage_system:create_explosion(owner_unit, position, rotation, explosion_template, scale, "career_ability", false, false)
    
                --return true
            --end
        end       
    end,
})]]
