local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------


mod:add_talent("bw_scholar", 1, 1, "rwaon_sienna_scholar_reduced_spread", {
    num_ranks = 1,
    --icon = "sienna_scholar_reduced_spread",
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
    multiplier = -0.4,
    stat_buff = StatBuffIndex.REDUCED_SPREAD,
})

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
    buff_to_add = "rwaon_sienna_scholar_passive_increased_headshot_damage_1",
    update_func = "activate_buff_stacks_based_on_overcharge_chunks"
})

--[[local function is_local(unit)
	local player = Managers.player:owner(unit)

	return player and not player.remote
end

BuffFunctionTemplates.functions.activate_buff_stacks_based_on_overcharge_chunks_increased_headshot_damage = function (unit, buff, params)
    if is_local(unit) then
        local overcharge_extension = ScriptUnit.extension(unit, "overcharge_system")
        local buff_extension = ScriptUnit.extension(unit, "buff_system")
        local overcharge, threshold, max_overcharge = overcharge_extension:current_overcharge_status()
        local template = buff.template
        local chunk_size = template.chunk_size
        local buff_to_add = template.buff_to_add
        local max_stacks = 5
        local owner_unit = unit

        if not buff.stack_ids then
            buff.stack_ids = {}
        end

        local num_chunks = math.min(math.floor(overcharge / chunk_size), max_stacks)
        local num_buff_stacks = buff_extension:num_buff_type(buff_to_add)

        if num_buff_stacks < num_chunks then
            local difference = num_chunks - num_buff_stacks

            for i = 1, difference, 1 do
                if i == 5 then
                    buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_5")
                elseif i == 4 then
                    buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_4")
                elseif i == 3 then
                    buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_3")
                elseif i == 2 then
                    buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_2")
                elseif i == 1 then
                    buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_1")
                end
            end
        elseif num_chunks < num_buff_stacks then
            local difference = num_buff_stacks - num_chunks

            for i = 1, difference, 1 do
                if i == 4 then
                    local buff_id = buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_5", {attacker_unit = owner_unit})
                    buff_extension:remove_buff(buff_id)
                elseif i == 3 then
                    local buff_id = buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_4", {attacker_unit = owner_unit})
                    buff_extension:remove_buff(buff_id)
                elseif i == 2 then
                    local buff_id = buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_3", {attacker_unit = owner_unit})
                buff_extension:remove_buff(buff_id)
                elseif i == 1 then
                    local buff_id = buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_2", {attacker_unit = owner_unit})
                    buff_extension:remove_buff(buff_id)
                elseif i == 0 then
                    local buff_id = buff_extension:add_buff("rwaon_sienna_scholar_passive_increased_headshot_damage_1", {attacker_unit = owner_unit})
                    buff_extension:remove_buff(buff_id)
                end
            end
        end
    end
end

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage", {
    max_stacks = 5,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
    chunk_size = 6,
    buff_to_add = "rwaon_sienna_scholar_passive_increased_headshot_damage",
    update_func = "activate_buff_stacks_based_on_overcharge_chunks_increased_headshot_damage"
})]]

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_1", {
    max_stacks = 1,
    multiplier = 0.04,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
})
--[[
mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_2", {
    max_stacks = 1,
    multiplier = 0.08,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_3", {
    max_stacks = 1,
    multiplier = 0.12,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_4", {
    max_stacks = 1,
    multiplier = 0.16,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_5", {
    max_stacks = 1,
    multiplier = 0.20,
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
})]]

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


--[[mod:add_talent("bw_scholar", 5, 1, "rwaon_sienna_scholar_embodiment_of_aqshy", {})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_embodiment_of_aqshy_overcharge", {
    duration = 10,
    refresh_durations = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    icon = "icons_placeholder",
    buff_func = function(player, buff, params)
        
    end,
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_embodiment_of_aqshy_buff", {
    max_stacks = 1,
    activation_effect = "fx/screenspace_overheat_critical",
    deactivation_sound = "hud_gameplay_stance_deactivate",
    activation_sound = "hud_gameplay_stance_tank_activate",
    icon = "icons_placeholder",
    duration = 10,
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
})]]