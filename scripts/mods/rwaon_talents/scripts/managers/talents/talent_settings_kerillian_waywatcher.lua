local mod = get_mod("rwaon_talents")

local buff_tweak_data = {
    kerillian_waywatcher_passive = {
        heal_amount = 2,
        headshot_bonus = 1.5,
        range = 10,
    },
    kerillian_waywatcher_passive_buff = {
        duration = 15,
        max_stacks = 15,
    },
    --
    kerillian_waywatcher_increased_crit_power_on_enemy_proximity_cooldown = {
        duration = 20,
    },
    kerillian_waywatcher_increased_crit_power_on_enemy_proximity = {
        num_enemies = 3,
        range = 3,
    },
    kerillian_waywatcher_increased_crit_power_on_enemy_proximity_buff = {
        multiplier = 1.5,
    },
    --
    kerillian_waywatcher_poison_on_damage_taken = {
        proc_chance = 0.05,
    },
    kerillian_waywatcher_poison_on_damage_taken_buff = {
        duration = 3,
    },
    kerillian_waywatcher_block_on_melee_buff = {
        duration = 4,
        multiplier = 0.3,
    },
    --
    kerillian_waywatcher_attack_speed_on_ranged_buff = {
        duration = 7,
        multiplier = 0.05,
        max_stacks = 5,
    },
    kerillian_waywatcher_move_speed_on_ranged_buff = {
        multiplier = 1.15,
        duration = 5,
    },
    kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff = {
        multiplier = 0.1,
        duration = 5,
        max_stacks = 5,
    },
    --

    --
    kerillian_waywatcher_on_recent_ranged_buff = {
        duration = 15,
    },
    kerillian_waywatcher_on_recent_ranged = {
        heal_amount = 2,
    },
    kerillian_waywatcher_on_killed_special = {
        heal_amount = 2,
        headshot_bonus = 2,
    },
    kerillian_waywatcher_on_ranged_extra_shot = {
        min_proc_chance = 0.05,
        max_proc_chance = 0.15,
        proc_chance = 0,
        duration = 2,
        max_stacks = 3,
    },
}

local function is_local(unit)
	local player = Managers.player:owner(unit)

	return player and not player.remote
end
------------------------------------------------------------------------------
mod:add_talent("we_waywatcher", 1, 1, "kerillian_waywatcher_crit_power_on_enemy_proximity", {
	name = "kerillian_waywatcher_crit_power_on_enemy_proximity",
	num_ranks = 1,
	icon = "kerillian_waywatcher_increased_crit_hit_damage_on_high_health",
	description_values = {
        {
            value = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity.num_enemies
        },
        {
            value_type = "baked_percent",
            value = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity_buff.multiplier
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity_cooldown.duration
        }
    },
	requirements = {},
	buffs = {
        "kerillian_waywatcher_increased_crit_power_on_enemy_proximity_cooldown",
        "kerillian_waywatcher_remove_crit_power_on_enemy_proximity",
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_increased_crit_power_on_enemy_proximity_cooldown", {
    duration = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity_cooldown.duration,
    buff_after_delay = true,
    max_stacks = 1,
    refresh_durations = true,
    is_cooldown = true,
    icon = "kerillian_waywatcher_increased_crit_hit_damage_on_high_health",
    delayed_buff_name = "kerillian_waywatcher_increased_crit_power_on_enemy_proximity"
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_increased_crit_power_on_enemy_proximity", {
    max_stacks = 1,
    buff_to_add = "kerillian_waywatcher_increased_crit_power_on_enemy_proximity_buff",
    update_func = "activate_buff_based_on_enemy_proximity",
    num_enemies = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity.num_enemies,
    range = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity.range,
})  
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_increased_crit_power_on_enemy_proximity_buff", {
    max_stacks = 1,
    stat_buff = "increased_max_targets",
    icon = "kerillian_waywatcher_increased_crit_hit_damage_on_high_health",
    multiplier = buff_tweak_data.kerillian_waywatcher_increased_crit_power_on_enemy_proximity_buff.multiplier,
})  
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_remove_crit_power_on_enemy_proximity", {
    max_stacks = 1,
    event_buff = true,
    event = "on_damage_taken",
    dormant = true,
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
		end
        
        local attacker_unit = params[1]
		local damage_amount = params[2]
        local damage_type = params[3]
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
        local template = buff.template
        local buff_to_add_1 = template.buff_to_add_1
        local buff_to_remove_1 = template.buff_to_remove_1

        if buff_extension:has_buff_type("kerillian_waywatcher_increased_crit_power_on_enemy_proximity") then
            local buff = buff_extension:get_non_stacking_buff("kerillian_waywatcher_increased_crit_power_on_enemy_proximity")

			if buff then
				buff_extension:remove_buff(buff.id)
            end

            buff_extension:add_buff("kerillian_waywatcher_increased_crit_power_on_enemy_proximity_cooldown")
        end
    end,
})

mod:add_talent("we_waywatcher", 1, 2, "kerillian_waywatcher_poison_on_damage_taken", {
	name = "kerillian_waywatcher_poison_on_damage_taken",
	num_ranks = 1,
	icon = "kerillian_waywatcher_conqueror",
	description_values = {
        {
            value_type = "percent",
            value = buff_tweak_data.kerillian_waywatcher_poison_on_damage_taken.proc_chance
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_poison_on_damage_taken_buff.duration
        }
    },
	requirements = {},
	buffs = {
		"kerillian_waywatcher_poison_on_damage_taken"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_poison_on_damage_taken", {
    max_stacks = 1,
    event_buff = true,
    event = "on_damage_taken",
    dormant = true,
    buff_to_add = "kerillian_waywatcher_poison_on_damage_taken_buff",
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
		end
        
        local attacker_unit = params[1]
		local damage_amount = params[2]
		local damage_type = params[3]
        
        if attacker_unit then
            for i=1, #PLAYER_AND_BOT_UNITS, 1 do
                if attacker_unit == PLAYER_AND_BOT_UNITS[i] then
                    return
                end
            end
            local health_extension = ScriptUnit.extension(attacker_unit, "health_system")
                
            if health_extension:is_alive() then
                mod:echo("This talent needs more research to work")
                --[[local damage_profile = 
                local target_index = 
                local power_level = 
                local hit_zone_name = "full"
                local damage_source

                DamageUtils.apply_dot(damage_profile, target_index, power_level, attacker_unit, player_unit, hit_zone_name, damage_source, nil, false)
                --[[local buff_extension = ScriptUnit.extension(attacker_unit, "buff_system")
                local template = buff.template
                local buff_to_add = template.buff_to_add
                --buff_extension:add_buff(buff_to_add)

                local actual_target_index = math.ceil(self.amount_of_mass_hit)
                local hit_rotation = Quaternion.look(attack_direction, Vector3.up())
                local damage_source = self.item_name
                local damage_source_id = NetworkLookup.damage_sources[damage_source]
                local damage_profile_id = self.impact_damage_profile_id       
                local power_level = 300 -- Get player's actual powerlevel
                
                Managers.state.entity:system("weapon_system"):send_rpc_attack_hit(damage_source_id, attacker_unit_id, hit_unit_id, hit_zone_id, hit_position, attack_direction, damage_profile_id, "power_level", power_level, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", 0, "is_critical_strike", false)
                damage_source_id, attacker_unit_id, hit_unit_id, hit_zone_id, hit_position, attack_direction, damage_profile_id, ...)
                ]]
            end
        end
    end,
    proc_chance = buff_tweak_data.kerillian_waywatcher_poison_on_damage_taken.proc_chance,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_poison_on_damage_taken_buff", {
        duration = buff_tweak_data.kerillian_waywatcher_poison_on_damage_taken_buff.duration,
        name = "buff poison dot",
        start_flow_event = "poisoned",
        end_flow_event = "poisoned_end",
        death_flow_event = "poisoned_death",
        remove_buff_func = "remove_dot_damage",
        apply_buff_func = "start_dot_damage",
        time_between_dot_damages = 1,
        damage_profile = "poison_direct",
        update_func = "apply_dot_damage",
        reapply_buff_func = "reapply_dot_damage"
})

mod:add_talent("we_waywatcher", 1, 3, "kerillian_waywatcher_block_on_melee", {
	name = "kerillian_waywatcher_block_on_melee",
	num_ranks = 1,
	icon = "kerillian_waywatcher_stamina_regen",
	description_values = {
        {
            value_type = "percent",
            value = buff_tweak_data.kerillian_waywatcher_block_on_melee_buff.multiplier
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_block_on_melee_buff.duration
        }
    },
	requirements = {},
	buffs = {
		"kerillian_waywatcher_block_on_melee"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_block_on_melee", {
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
    buffs_to_add = {"kerillian_waywatcher_block_on_melee_buff1", "kerillian_waywatcher_block_on_melee_buff2"},
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
        local critical_hit = params[6]
        
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buffs_to_add = template.buffs_to_add
        if buff_type == "MELEE_1H" or buff_type == "MELEE_2H" and Unit.alive(player_unit) and hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
            for i=1, #buffs_to_add do
                local buff_to_add = buffs_to_add[i]
                buff_extension:add_buff(buff_to_add)
            end
        end
    end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_block_on_melee_buff1", {
    max_stacks = 1,
    icon = "kerillian_waywatcher_stamina_regen",
    stat_buff = "fatigue_regen",
    refresh_durations = true,
    multiplier = buff_tweak_data.kerillian_waywatcher_block_on_melee_buff.multiplier,
    duration = buff_tweak_data.kerillian_waywatcher_block_on_melee_buff.duration,
})

mod:add_talent_buff("wood_elf", "kerillian_waywatcher_block_on_melee_buff2", {
    max_stacks = 1,
    stat_buff = "block_cost",
    refresh_durations = true,
    multiplier = buff_tweak_data.kerillian_waywatcher_block_on_melee_buff.multiplier,
    duration = buff_tweak_data.kerillian_waywatcher_block_on_melee_buff.duration,
})
------------------------------------------------------------------------------
mod:add_talent("we_waywatcher", 2, 1, "kerillian_waywatcher_attack_speed_on_ranged", {
	name = "kerillian_waywatcher_attack_speed_on_ranged",
    num_ranks = 1,
	icon = "kerillian_waywatcher_attack_speed",
	description_values = {
        {
            value_type = "percent",
            value = buff_tweak_data.kerillian_waywatcher_attack_speed_on_ranged_buff.multiplier
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_attack_speed_on_ranged_buff.max_stacks
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_attack_speed_on_ranged_buff.duration
        }
    },
	requirements = {},
	buffs = {
		"kerillian_waywatcher_attack_speed_on_ranged"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_attack_speed_on_ranged", {
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
    buff_to_add = "kerillian_waywatcher_attack_speed_on_ranged_buff",
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
        local critical_hit = params[6]
        
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add    
        if buff_type == "RANGED" and hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" and Unit.alive(player_unit) then -- 
            buff_extension:add_buff(buff_to_add)
        end
	end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_attack_speed_on_ranged_buff", {
    icon = "kerillian_waywatcher_attack_speed",
    stat_buff = "attack_speed",
    refresh_durations = true,
    multiplier = buff_tweak_data.kerillian_waywatcher_attack_speed_on_ranged_buff.multiplier,
    max_stacks = buff_tweak_data.kerillian_waywatcher_attack_speed_on_ranged_buff.max_stacks,
    duration = buff_tweak_data.kerillian_waywatcher_attack_speed_on_ranged_buff.duration,
})

mod:add_talent("we_waywatcher", 2, 2, "kerillian_waywatcher_move_speed_on_ranged", {
	name = "kerillian_waywatcher_move_speed_on_ranged",
    num_ranks = 1,
	icon = "kerillian_waywatcher_activated_ability_cooldown",
	description_values = {
        {
            value_type = "baked_percent",
            value = buff_tweak_data.kerillian_waywatcher_move_speed_on_ranged_buff.multiplier
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_move_speed_on_ranged_buff.duration
        },
	},
	requirements = {},
	buffs = {
		"kerillian_waywatcher_move_speed_on_ranged"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_move_speed_on_ranged", {
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
    buff_to_add = "kerillian_waywatcher_move_speed_on_ranged_buff",
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
        local critical_hit = params[6]
        
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add
        if buff_type == "RANGED" and hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" and Unit.alive(player_unit) then
            buff_extension:add_buff(buff_to_add)
            --mod:echo("added movement buff")
        end
    end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_move_speed_on_ranged_buff", {
    max_stacks = 1,
    icon = "kerillian_waywatcher_activated_ability_cooldown",
    refresh_durations = true,
    max_stacks = 1,
	remove_buff_func = "remove_movement_buff",
	apply_buff_func = "apply_movement_buff",
	path_to_movement_setting_to_modify = {
		"move_speed"
    },
    multiplier = buff_tweak_data.kerillian_waywatcher_move_speed_on_ranged_buff.multiplier,
    duration = buff_tweak_data.kerillian_waywatcher_move_speed_on_ranged_buff.duration,
})

mod:add_talent("we_waywatcher", 2, 3, "kerillian_waywatcher_headshot_multiplier_on_melee_headshot", {
	name = "kerillian_waywatcher_headshot_multiplier_on_melee_headshot",
    num_ranks = 1,
	icon = "kerillian_waywatcher_crit_chance",
	description_values = {
        {
            value_type = "percent",
            value = buff_tweak_data.kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff.multiplier
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff.max_stacks
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff.duration
        },
    },
	requirements = {},
	buffs = {
		"kerillian_waywatcher_headshot_multiplier_on_melee_headshot"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_headshot_multiplier_on_melee_headshot", {
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
    buff_to_add = "kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff",
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
        local critical_hit = params[6]
        
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add    
        if buff_type == "MELEE_1H" or buff_type == "MELEE_2H" and hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" and Unit.alive(player_unit) then -- 
            buff_extension:add_buff(buff_to_add)
        end
	end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff", {
    icon = "kerillian_waywatcher_crit_chance",
    stat_buff = "headshot_multiplier",
    refresh_durations = true,
    multiplier = buff_tweak_data.kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff.multiplier,
    max_stacks = buff_tweak_data.kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff.max_stacks,
    duration = buff_tweak_data.kerillian_waywatcher_headshot_multiplier_on_melee_headshot_buff.duration,
})

------------------------------------------------------------------------------
mod:add_talent("we_waywatcher", 3, 1, "kerillian_waywatcher_improved_group_heal", {
	name = "kerillian_waywatcher_improved_group_heal",
    num_ranks = 1,
	icon = "kerillian_waywatcher_improved_regen",
	description_values = {},
	requirements = {},
	buffs = {},
	buff_data = {}
})

mod:add_talent("we_waywatcher", 3, 2, "kerillian_waywatcher_regenerate_ammunition", {
	name = "kerillian_waywatcher_regenerate_ammunition",
    num_ranks = 1,
	icon = "kerillian_waywatcher_regenerate_ammunition",
	description_values = {},
	requirements = {},
	buffs = {},
	buff_data = {}
})

mod:add_talent("we_waywatcher", 3, 3, "kerillian_waywatcher_passive_increased_range", {
	name = "kerillian_waywatcher_passive_increased_range",
    num_ranks = 1,
	icon = "kerillian_waywatcher_group_regen",
	description_values = {},
	requirements = {},
	buffs = {},
	buff_data = {}
})

------------------------------------------------------------------------------
mod:add_talent("we_waywatcher", 4, 1, "kerillian_waywatcher_on_recent_ranged", {
	name = "kerillian_waywatcher_on_recent_ranged",
	num_ranks = 1,
	icon = "kerillian_waywatcher_bloodlust",
	description_values = {
        {
            value = buff_tweak_data.kerillian_waywatcher_on_recent_ranged_buff.duration
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_on_recent_ranged.heal_amount
        }
    },
	requirements = {},
	buffs = {
		"kerillian_waywatcher_on_recent_ranged"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_on_recent_ranged", {
    max_stacks = 1,
    event_buff = true,
    event = "on_kill",
    dormant = true,
    buff_to_add = "kerillian_waywatcher_on_recent_ranged_buff",
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
        end
        
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
        
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add
        local heal_amount = template.heal_amount
        if Unit.alive(player_unit) and 
           damage_source == "we_shortbow" or 
           damage_source == "we_shortbow_hagbane" or 
           damage_source == "we_longbow" then

            buff_extension:add_buff(buff_to_add)
        elseif Unit.alive(player_unit) and 
               damage_source == "we_spear" or 
               damage_source == "we_dual_wield_daggers" or 
               damage_source == "we_dual_wield_swords" or 
               damage_source == "we_1h_sword" or 
               damage_source == "we_dual_wield_sword_dagger" or 
               damage_source == "we_2h_axe" or --glaive
               damage_source == "we_2h_sword" or
               damage_source == "we_1h_axe" then

            if buff_extension:has_buff_type("kerillian_waywatcher_on_recent_ranged_buff") then
                DamageUtils.heal_network(player_unit, player_unit, heal_amount, "heal_from_proc")
            end
        end
    end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_on_recent_ranged_buff", {
    max_stacks = 1,
    icon = "kerillian_waywatcher_bloodlust",
    max_stacks = 1,
    refresh_durations = true,
})

mod:add_talent("we_waywatcher", 4, 2, "kerillian_waywatcher_on_killed_special", {
	name = "kerillian_waywatcher_on_killed_special",
    num_ranks = 1,
	icon = "kerillian_waywatcher_regrowth",
	description_values = {
        {
            value = buff_tweak_data.kerillian_waywatcher_on_killed_special.heal_amount
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_on_killed_special.headshot_bonus
        },
    },
	requirements = {},
	buffs = {
        "kerillian_waywatcher_on_killed_special",
        "kerillian_waywatcher_on_killed_elite",
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_on_killed_special", {
    max_stacks = 1,
    event_buff = true,
    event = "on_special_killed",
    heal_amount = buff_tweak_data.kerillian_waywatcher_on_killed_special.heal_amount,
    headshot_bonus = buff_tweak_data.kerillian_waywatcher_on_killed_special.headshot_bonus,
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
        end
        
        local killing_blow = params[1]
        local damage_amount = killing_blow[DamageDataIndex.DAMAGE_AMOUNT]
		local damage_type = killing_blow[DamageDataIndex.DAMAGE_TYPE]
		local hit_zone_name = killing_blow[DamageDataIndex.HIT_ZONE]
		local direction = killing_blow[DamageDataIndex.DIRECTION]
		local damage_source = killing_blow[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local hit_ragdoll = killing_blow[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME]
		local damaging_unit = killing_blow[DamageDataIndex.DAMAGING_UNIT]
		local react_type = killing_blow[DamageDataIndex.HIT_REACT_TYPE]
        local critical = killing_blow[DamageDataIndex.CRITICAL_HIT]
        local attacker_unit = killing_blow[DamageDataIndex.ATTACKER]
        local position = killing_blow[DamageDataIndex.POSITION]
        local breed_data        = params[2]
        local ai_unit           = params[3]
        
        local template = buff.template
        local heal_amount = template.heal_amount
        local headshot_bonus = template.headshot_bonus
        if hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
            heal_amount = heal_amount + headshot_bonus
            DamageUtils.heal_network(player_unit, player_unit, heal_amount, "career_passive")
        else
            DamageUtils.heal_network(player_unit, player_unit, heal_amount, "career_passive")
        end
    end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_on_killed_elite", {
    max_stacks = 1,
    event_buff = true,
    event = "on_killed",
    heal_amount = buff_tweak_data.kerillian_waywatcher_on_killed_special.heal_amount,
    headshot_bonus = buff_tweak_data.kerillian_waywatcher_on_killed_special.headshot_bonus,
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
        end
        
        local killing_blow    = params[1]
        local attack_type     = killing_blow[1]
        local hit_zone_name   = killing_blow[2]
        local target_number   = killing_blow[3]
        local buff_type       = killing_blow[4]
        local is_critical     = killing_blow[5]
        
        local template = buff.template
        local heal_amount = template.heal_amount
        local headshot_bonus = template.headshot_bonus
        local unit_type = mod:unit_category(hit_unit)
        
        if unit_type == "elite" then
            if hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
                heal_amount = heal_amount + headshot_bonus
            end
            DamageUtils.heal_network(player_unit, player_unit, heal_amount, "career_passive")
        end
    end,
})


mod:add_talent("we_waywatcher", 4, 3, "kerillian_waywatcher_on_ranged_extra_shot", {
	name = "kerillian_waywatcher_on_ranged_extra_shot",
    num_ranks = 1,
	icon = "kerillian_waywatcher_headshot_multiplier",
	description_values = {
        {
            value = buff_tweak_data.kerillian_waywatcher_on_ranged_extra_shot.max_stacks
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_on_ranged_extra_shot.min_proc_chance
        },
        {
            value = buff_tweak_data.kerillian_waywatcher_on_ranged_extra_shot.duration
        },
    },
	requirements = {},
	buffs = {
		"kerillian_waywatcher_on_ranged_extra_shot"
	},
	buff_data = {}
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_on_ranged_extra_shot", {
    max_stacks = 1,
    event_buff = true,
    event = "on_damage_dealt",
    dormant = true,
    buff_to_add = "kerillian_waywatcher_move_speed_on_ranged_buff",
    buff_func = function (player, buff, params)
		local player_unit = player.player_unit

		if not is_local(player_unit) then
			return
		end
        
        local hit_unit = params[1]
		local damage_amount = params[2]
		local hit_zone_name = params[3]
		local no_crit_headshot_damage = params[4]
		local is_critical_strike = params[5]
        local buff_type = params[6]
        local target_index = params[7]
        
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add
        if buff_type == "RANGED" and Unit.alive(player_unit) then
            buff_extension:add_buff(buff_to_add)
        end
    end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_move_speed_on_ranged_buff", {
    refresh_durations = true,
    stat_buff = "extra_shot",
    icon = "kerillian_waywatcher_headshot_multiplier",
    chunks_buff = "kerillian_waywatcher_move_speed_on_ranged_buff",
    update_func = "update_proc_chance_based_on_stacks",
})
------------------------------------------------------------------------------
--kerillian_waywatcher_gain_ammo_on_boss_death
--kerillian_waywatcher_activated_ability_heal
--kerillian_waywatcher_activated_ability_restore_ammo


------------------------------------------------------------------------------
-- Passives
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_passive", {
    event_buff = true,
    event = "on_hit",
    heal_amount = buff_tweak_data.kerillian_waywatcher_passive.heal_amount,
    headshot_bonus = buff_tweak_data.kerillian_waywatcher_passive.headshot_bonus,
    range = buff_tweak_data.kerillian_waywatcher_passive.range,
    buff_to_add = "kerillian_waywatcher_passive_buff",
    buff_func = function (player, buff, params)
        local player_unit = player.player_unit
        local hit_unit = params[1]
		local attack_type = params[2]
		local hit_zone_name = params[3]
		local target_number = params[4]
		local buff_type = params[5]
        local critical_hit = params[6]

		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add
        local heal_amount = template.heal_amount
        local headshot_bonus = template.headshot_bonus
        local range = template.range
        local talent_extension = ScriptUnit.extension(player_unit, "talent_system")
        if talent_extension:has_talent("kerillian_waywatcher_passive_increased_range", "wood_elf", true) then
            range = 25
        end
        local range_squared = range * range
		local num_buff_stacks = buff_extension:num_buff_type(buff_to_add)

		if not buff.stack_ids then
			buff.stack_ids = {}
		end

		if buff_type == "MELEE_1H" or buff_type == "MELEE_2H" then
            if num_buff_stacks ~= 15 then
                local buff_id = buff_extension:add_buff(buff_to_add)
                local stack_ids = buff.stack_ids
                stack_ids[#stack_ids + 1] = buff_id
            end
        elseif buff_type == "RANGED" and num_buff_stacks >= 5 then
            --if Managers.state.network.is_server then
				local health_extension = ScriptUnit.extension(player_unit, "health_system")
				local status_extension = ScriptUnit.extension(player_unit, "status_system")
                
                if health_extension:is_alive() and not status_extension:is_knocked_down() and not status_extension:is_assisted_respawning() then
                    if talent_extension:has_talent("kerillian_waywatcher_regenerate_ammunition", "wood_elf", true) and hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
                        local weapon_slot = "slot_ranged"
                        local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
                        local slot_data = inventory_extension:get_slot_data(weapon_slot)
        
                        if slot_data then
                            local right_unit_1p = slot_data.right_unit_1p
                            local left_unit_1p = slot_data.left_unit_1p
                            local right_hand_ammo_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
                            local left_hand_ammo_extension = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
                            local ammo_extension = right_hand_ammo_extension or left_hand_ammo_extension
        
                            if ammo_extension then
                                local ammo_bonus_fraction = 0.04
                                local ammo_amount = math.floor(math.max(math.round(ammo_extension:get_max_ammo() * ammo_bonus_fraction), 1) * (num_buff_stacks / 5))
        
                                ammo_extension:add_ammo_to_reserve(ammo_amount)
                            end
                        end
                    end
                    

                    heal_amount = heal_amount * (num_buff_stacks - 4)
                    if hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
                        heal_amount = heal_amount + (headshot_bonus * (num_buff_stacks - 4))
                        --mod:echo("headshot heal amount increase")
                    end
                    --mod:echo(heal_amount)
                    local player_position = POSITION_LOOKUP[player_unit]
					local player_and_bot_units = PLAYER_AND_BOT_UNITS

					for i = 1, #player_and_bot_units, 1 do
						if Unit.alive(player_and_bot_units[i]) then
							local health_extension = ScriptUnit.extension(player_and_bot_units[i], "health_system")
							local status_extension = ScriptUnit.extension(player_and_bot_units[i], "status_system")

                            if not status_extension:is_knocked_down() and not status_extension:is_assisted_respawning() and health_extension:is_alive() then
                                local unit_position = POSITION_LOOKUP[player_and_bot_units[i]]
				                local distance_squared = Vector3.distance_squared(player_position, unit_position)
                                
                                if distance_squared < range_squared then
                                    local talent_extension = ScriptUnit.extension(player_unit, "talent_system")
                                    if talent_extension:has_talent("kerillian_waywatcher_improved_group_heal", "wood_elf", true) then
                                        if player_and_bot_units[i] ~= player_unit then
                                            heal_amount = heal_amount * 2
                                            DamageUtils.heal_network(player_and_bot_units[i], player_unit, heal_amount, "career_passive")
                                            
                                        end
                                    else
                                        DamageUtils.heal_network(player_and_bot_units[i], player_unit, heal_amount, "career_passive")
                                    end
                                    --mod:echo("Added " .. tostring(heal_amount) .. " health for " .. tostring(player_and_bot_units[i]))
                                end
							end
						end
					end
                end
            --end

            if num_buff_stacks ~= 0 then
                local stack_ids = buff.stack_ids
                for i = 1, #stack_ids, 1 do
                    local stack_ids = buff.stack_ids
                    local buff_id = table.remove(stack_ids, 1)

                    buff_extension:remove_buff(buff_id)
                end
            end
		end
	end,
})
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_passive_buff", {
    icon = "kerillian_waywatcher_passive",
    duration = buff_tweak_data.kerillian_waywatcher_passive_buff.duration,
    max_stacks = buff_tweak_data.kerillian_waywatcher_passive_buff.max_stacks,
})