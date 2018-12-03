local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 1, 1, "rwaon_sienna_scholar_double_dot_duration", {
    description_values = {},
    buffer = "server",
})

mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard_talent_extras/double_dot_duration")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 1, 2, "rwaon_sienna_scholar_martial_studies", {
    description_values = {
        { value = 0.2, value_type = "percent" },
    },
    buffer = "server",
    buffs = {
        "rwaon_sienna_scholar_martial_studies",
    },
})
mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_martial_studies", {
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
    multiplier = 0.2,
})

------------------------------------------------------------------------------
--[[
mod:add_talent("bw_scholar", 2, 3, "rwaon_sienna_scholar_cascading_firecloak", {
    description_values = {
        { value = 0.3, value_type = "percent" },
        { value = 5 },
    },
    buffer = "server",
    buffs = {
        "rwaon_sienna_scholar_cascading_firecloak",
    },
})
mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_cascading_firecloak", {
    {
        buff_to_add = "sienna_scholar_passive_reduced_block_cost",
        update_func = "activate_buff_stacks_based_on_overcharge_chunks"
    }
})]]

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 3, 3, "sienna_scholar_passive_increased_attack_speed_from_overcharge", {
    --icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
    description_values = {
        { value = 0.03, value_type = "percent", }, -- Multiplier (MODIFIED!)
        { value = 8 }, -- Chunk size
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
