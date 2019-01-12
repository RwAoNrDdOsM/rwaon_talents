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
            value = 0.05
        }
    },
    buffs = {
        "rwaon_sienna_scholar_on_elite_special_killed"
    },
})

mod.unit_category = function(unit)
    local breed_categories = {}

    breed_categories["skaven_clan_rat"] = "normal"
    breed_categories["skaven_clan_rat_with_shield"] = "normal"
    breed_categories["skaven_dummy_clan_rat"] = "normal"
    breed_categories["skaven_slave"] = "normal"
    breed_categories["skaven_dummy_slave"] = "normal"
    breed_categories["chaos_marauder"] = "normal"
    breed_categories["chaos_marauder_with_shield"] = "normal"
    breed_categories["chaos_fanatic"] = "normal"
    breed_categories["critter_rat"] = "normal"
    breed_categories["critter_pig"] = "normal"

    breed_categories["skaven_gutter_runner"] = "special"
    breed_categories["skaven_pack_master"] = "special"
    breed_categories["skaven_ratling_gunner"] = "special"
    breed_categories["skaven_poison_wind_globadier"] = "special"
    breed_categories["chaos_vortex_sorcerer"] = "special"
    breed_categories["chaos_corruptor_sorcerer"] = "special"
    breed_categories["skaven_warpfire_thrower"] = "special"
    breed_categories["skaven_loot_rat"] = "special"
    breed_categories["chaos_tentacle"] = "special"
    breed_categories["chaos_tentacle_sorcerer"] = "special"
    breed_categories["chaos_plague_sorcerer"] = "special"
    breed_categories["chaos_plague_wave_spawner"] = "special"
    breed_categories["chaos_vortex"] = "special"
    breed_categories["chaos_dummy_sorcerer"] = "special"

    breed_categories["skaven_storm_vermin"] = "elite"
    breed_categories["skaven_storm_vermin_commander"] = "elite"
    breed_categories["skaven_storm_vermin_with_shield"] = "elite"
    breed_categories["skaven_plague_monk"] = "elite"
    breed_categories["chaos_berzerker"] = "elite"
    breed_categories["chaos_raider"] = "elite"
    breed_categories["chaos_warrior"] = "elite"
    
    breed_categories["skaven_rat_ogre"] = "boss"
    breed_categories["skaven_stormfiend"] = "boss"
    breed_categories["skaven_storm_vermin_warlord"] = "boss"
    breed_categories["skaven_stormfiend_boss"] = "boss"
    breed_categories["skaven_grey_seer"] = "boss"
    breed_categories["chaos_troll"] = "boss"
    breed_categories["chaos_dummy_troll"] = "boss"
    breed_categories["chaos_spawn"] = "boss"
    breed_categories["chaos_exalted_champion"] = "boss"
    breed_categories["chaos_exalted_champion_warcamp"] = "boss"
    breed_categories["chaos_exalted_sorcerer"] = "boss"

    local breed_data = Unit.get_data(unit, "breed")
    breed_name = breed_data.name
    if breed_categories[breed_name] then
        return breed_categories[breed_name]
    else
        -- Handle unknown breeds: everything below 300 HP is normal, above is a boss
        local health_extension = ScriptUnit.extension(unit, "health_system")
        local hp = health_extension:get_max_health()
        if hp > 300 then
            return "boss"
        else
            return "normal"
        end
    end
end

local Unit_get_data = Unit.get_data
mod:hook_safe(StatisticsUtil, "register_kill", function (victim_unit, damage_data, statistics_db, is_server)
	local attacker_unit = AiUtils.get_actual_attacker_unit(damage_data[DamageDataIndex.ATTACKER])
	local damaging_unit = damage_data[DamageDataIndex.DAMAGING_UNIT]
	local player_manager = Managers.player
	local attacker_player = player_manager:owner(attacker_unit)
	local grenade_kill = false
	local breed = Unit_get_data(victim_unit, "breed")

    rwaon_damaging_unit_data = victim_unit

	if attacker_player then
		local stats_id = attacker_player:stats_id()

		statistics_db:increment_stat(stats_id, "kills_total")

		if breed ~= nil then
			local breed_name = breed.name
			local print_message = breed.awards_positive_reinforcement_message

			if print_message then
				local predicate = "killed_special"
				local local_human = not attacker_player.remote and not attacker_player.bot_player
				local profile_index = attacker_player:profile_index()
				local stats_id = attacker_player:stats_id()
				local attacker_player_unit = attacker_player.player_unit

				if Unit.alive(attacker_player_unit) then
					local career_extension = ScriptUnit.extension(attacker_player_unit, "career_system")
					local career_index = (career_extension and career_extension:career_index()) or attacker_player:career_index()

					Managers.state.event:trigger("add_coop_feedback_kill", stats_id .. breed_name, local_human, predicate, profile_index, career_index, breed_name)
				end
			end

			statistics_db:increment_stat(stats_id, "kills_per_breed", breed_name)

			local hit_zone = damage_data[DamageDataIndex.HIT_ZONE]

			if hit_zone == "head" then
				statistics_db:increment_stat(stats_id, "headshots")
			end

			local damage_source = damage_data[DamageDataIndex.DAMAGE_SOURCE_NAME]
			local master_list_item = rawget(ItemMasterList, damage_source)

			if master_list_item then
				local slot_type = master_list_item.slot_type

				if slot_type == "melee" then
					statistics_db:increment_stat(stats_id, "kills_melee")
				elseif slot_type == "ranged" then
					statistics_db:increment_stat(stats_id, "kills_ranged")
				end

				if Managers.unlock:is_dlc_unlocked("holly") then
					if damage_source == "we_1h_axe" then
						statistics_db:increment_stat(stats_id, "holly_kills_we_1h_axe")
					elseif damage_source == "bw_1h_crowbill" then
						statistics_db:increment_stat(stats_id, "holly_kills_bw_1h_crowbill")
					elseif damage_source == "wh_dual_wield_axe_falchion" then
						statistics_db:increment_stat(stats_id, "holly_kills_wh_dual_wield_axe_falchion")
					elseif damage_source == "dr_dual_wield_hammers" then
						statistics_db:increment_stat(stats_id, "holly_kills_dr_dual_wield_hammers")
					elseif damage_source == "es_dual_wield_hammer_sword" then
						statistics_db:increment_stat(stats_id, "holly_kills_es_dual_wield_hammer_sword")
					end
				end
			end
		end
	end

	if (breed ~= nil and breed.elite) or breed.boss then
		local human_and_bot_players = player_manager:human_and_bot_players()

		for _, player in pairs(human_and_bot_players) do
			if player ~= attacker_player then
				local stats_id = player:stats_id()

				if breed ~= nil then
					local breed_name = breed.name

					statistics_db:increment_stat(stats_id, "kill_assists_per_breed", breed_name)
				end
			end
		end
	end
end)

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_on_elite_special_killed", {
    max_stacks = 1,
    event_buff = true,
    event = "on_kill",
    --icon = "icons_placeholder",
    buff_func = function (unit, buff, params)
        --local death_ext = ScriptUnit.extension(unit, "death_system")
        --local death_has_started = death_ext and death_ext.death_has_started
        --local killing_blow = params.death and death_ext and not death_has_started
        local killing_blow = params[1]
        

        --local attacker_unit = biggest_hit[DamageDataIndex.ATTACKER]
        --local damage_amount = biggest_hit[DamageDataIndex.DAMAGE_AMOUNT]

        local damage_amount          = killing_blow[1]
        local damage_type            = killing_blow[2]
        local attacker_unit          = killing_blow[3] --  or victim_unit
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
            --local unit_id, is_level_unit = network_manager:game_object_or_level_id(unit)

            --if DamageUtils.is_player_unit(attacker_unit) and damage_amount > 0 then
                --if (not killing_blow) and attacker_unit == player_unit then
                    --assists[unit_id] = 1
                --if killing_blow and (attacker_unit == player_unit) then -- or assists[unit_id]
                    local victim_unit = rwaon_damaging_unit_data
                    local unit_type = mod.unit_category(victim_unit)
                    --00mod:echo(unit_type)
                    --mod:echo(damage_source)

                    if (unit_type == "special" or unit_type == "elite") and (damage_source == "bw_skullstaff_beam" or damage_source == "bw_skullstaff_spear" or damage_source == "bw_skullstaff_geiser" or damage_source == "bw_skullstaff_fireball" or damage_source == "bw_skullstaff_flamethrower") then
                        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
                        buff_extension:add_buff("rwaon_sienna_scholar_on_elite_special_killed_buff", buff_params)
                    end
                    --opacities[unit_type] = 255
                    --sizes[unit_type] = 0
                    --colors[unit_type] = {255, 25, 25}
                    
                    --if assists[unit_id] then
                    --    if attacker_unit ~= player_unit then
                    --        colors[unit_type] = {7, 150, 210}
                    --    end
                    --    assists[unit_id] = nil  -- Remove from table
                        -- TODO clear assists periodically as units can die from other causes
                        -- TODO show assists from non-player causes (e.g. gunner fire, barrel explosions...)
                    --end
                --end
            --end
        end)
    end,
})


mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_on_elite_special_killed_buff", {
    duration = 10,
    max_stacks = 5,
    refresh_durations = true,
    multiplier = 0.05,  
    icon = "sienna_scholar_increased_attack_speed",
    stat_buff = StatBuffIndex.INCREASED_WEAPON_DAMAGE_MELEE,
})

------------------------------------------------------------------------------
mod:add_talent("bw_scholar", 2, 1, "rwaon_sienna_scholar_armour_dot", {
    description_values = {},
    icon = "sienna_scholar_passive_reduced_block_cost_from_overcharge",
    buffer = "server",
})

mod:add_talent("bw_scholar", 2, 3, "rwaon_sienna_scholar_double_dot_duration", {
    description_values = {},
    icon = "sienna_adept_charge_speed_increase",
    buffer = "server",
})

mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard_talent_extras/burning_dots")

------------------------------------------------------------------------------

mod:add_talent("bw_scholar", 3, 1, "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge", {
    icon = "sienna_scholar_increased_ranged_charge_speed_on_low_health",
    description_values = {
        { value = 0.04, value_type = "percent", }, -- Multiplier
        { value = 6 }, -- Chunk size
        { value = 5 }, -- Max stacks
    },
	buffs = {
        "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge",
        "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge_icon",
	},
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge", {
    chunk_size = 6,
    min_multiplier = 0.04,
    max_multiplier = 0.2,
    stat_buff = StatBuffIndex.HEADSHOT_MULTIPLIER,
    update_func = "update_multiplier_based_on_overcharge_chunks"
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge_icon", {
    chunk_size = 6,
    buff_to_add = "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge_icon_dummy",
	update_func = "activate_buff_stacks_based_on_overcharge_chunks"
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_passive_increased_headshot_damage_from_overcharge_icon_dummy", {
    max_stacks = 5,
    icon = "sienna_scholar_increased_ranged_charge_speed_on_low_health",
})

mod:add_talent("bw_scholar", 3, 3, "sienna_scholar_passive_increased_attack_speed_from_overcharge", {
    icon = "sienna_scholar_passive_increased_attack_speed_from_overcharge",
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
        { value = 0.25, value_type = "percent", }, -- Multiplier
        { value = 2 }, -- Overcharge reduction
    },
    icon = "sienna_scholar_activated_ability_dump_overcharge",
    buffs = {
    },
})

local function is_local(unit)
	local player = Managers.player:owner(unit)

	return player and not player.remote
end

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_embodiment_of_aqshy_overcharge", {
    duration = 10,
    refresh_durations = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    icon = "sienna_scholar_activated_ability_dump_overcharge",
    --dormant = true,
    bonus = 1,
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

local embodiment_of_aqshy_buff = {
    activation_effect = "fx/screenspace_potion_03",
    deactivation_sound = "hud_gameplay_stance_deactivate",
    activation_sound = "hud_gameplay_stance_tank_activate",
    buffs = {
        {
            apply_buff_func = "apply_movement_buff",
            multiplier = 1.15, -- 1.5
            --name = "movement",
            icon = "sienna_scholar_activated_ability_dump_overcharge",
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
}

TalentBuffTemplates.bright_wizard.rwaon_sienna_scholar_embodiment_of_aqshy_buff = embodiment_of_aqshy_buff
BuffTemplates.rwaon_sienna_scholar_embodiment_of_aqshy_buff = embodiment_of_aqshy_buff

--mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_embodiment_of_aqshy_buff", )

mod:add_talent("bw_scholar", 5, 3, "rwaon_sienna_scholar_activated_ability_damage", {
    name = "sienna_scholar_activated_ability_cooldown",
    num_ranks = 1,
    buffer = "both",
    icon = "sienna_scholar_activated_ability_cooldown",
    description_values = {
        {
            value_type = "percent",
            value = 0.2
        }
    },
    requirements = {},
    buffs = {},
    buff_data = {}
})

mod:add_talent_buff("bright_wizard", "rwaon_sienna_scholar_activated_ability_damage", {
    multiplier = 0.2,
    max_stacks = 1,
    icon = "sienna_scholar_activated_ability_cooldown",
    dormant = true,
    stat_buff = StatBuffIndex.POWER_LEVEL,
    duration = 10,
})
