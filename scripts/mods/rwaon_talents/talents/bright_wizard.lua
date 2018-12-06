local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 2, 3, "rwaon_sienna_scholar_double_dot_duration", {
    description_values = {},
    buffer = "server",
})

mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard_talent_extras/double_dot_duration")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 3, 1, "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge", {
    --icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    description_values = {
        { value = 0.04, value_type = "percent", }, -- Multiplier (MODIFIED!)
        { value = 6 }, -- Chunk size
        { value = 5 }, -- Max stacks
    },
    buffs = {
        "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge",
    },
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge", {
    chunk_size = 6,
    buffs = {
        {
            buff_to_add = "rwaon_sienna_scholar_passive_increased_headshot_damage",
            update_func = "activate_buff_stacks_based_on_overcharge_chunks"
        }
    },
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
})

--[[
mod:add_talent("bw_scholar", 5, 3, "rwaon_sienna_scholar_cascading_firecloak", {
    description_values = {
        { value = 0.3, value_type = "percent" },
        { value = 5 },
    },
    buffer = "server",
    --buff_after_delay = true,
    --max_stacks = 1,
    --refresh_durations = true,
    --is_dormant = false,
    --is_cooldown = true,
    icon = "icons_placeholder",
	--duration = 120,
    --delayed_buff_name = "rwaon_sienna_scholar_cascading_firecloak"
    buffs = {
        "rwaon_sienna_scholar_cascading_firecloak",
    },
})
mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_cascading_firecloak", {
    buff_func = function(player, buff, params)
        local player_unit = Managers.player:local_player().player_unit
        local position = Unit.world_position(player_unit, 0) + Vector3(0, 0, 0)
        local rotation = Unit.local_rotation(player_unit, 0) + Vector3(0, 0, 0)
        local explosion_template = "lamp_oil"
        local scale = 1
        local damage_source = "explosion_bw_unchained_ability"
        local attacker_power_level = explosion_template.attacker_power_level or 0
        mod:echo(player_unit)
        mod:echo(position)
        mod:echo(rotation)
        mod:echo(explosion_template)
        mod:echo(scale)
        mod:echo(damage_source)
        mod:echo(attacker_power_level)

        Managers.state.entity:system("area_damage_system"):create_explosion(player_unit, position, rotation, explosion_template, scale, damage_source, attacker_power_level, false)
        
        if Managers.state.network.is_server then
			local first_person_extension = ScriptUnit.has_extension(unit, "first_person_system")
			local go_id = Managers.state.unit_storage:go_id(unit)
			local network_manager = Managers.state.network
			local game = network_manager:game()

			if not go_id then
				return
			end

			local aim_direction = GameSession.game_object_field(game, go_id, "aim_direction")
			local start_pos = POSITION_LOOKUP[unit]
			local nav_world = Managers.state.entity:system("ai_system"):nav_world()
			local projected_start_pos = LocomotionUtils.pos_on_mesh(nav_world, start_pos, 2, 30)

			if projected_start_pos then
				local liquid_template_name = "lamp_oil_fire"
				local liquid_template_id = NetworkLookup.liquid_area_damage_templates[liquid_template_name]
				local network_manager = Managers.state.network
				local invalid_game_object_id = NetworkConstants.invalid_game_object_id

				network_manager.network_transmit:send_rpc_server("rpc_create_liquid_damage_area", invalid_game_object_id, projected_start_pos, aim_direction, liquid_template_id)
			end
		end
    end
})]]