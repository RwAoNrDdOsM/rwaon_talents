local mod = get_mod("rwaon_talents")

WeaponTraits.traits.melee_counter_push_power = {
    display_name = "traits_melee_counter_push_power",
    buffer = "both",
    advanced_description = "description_traits_melee_counter_push_power",
    icon = "melee_counter_push_power",
    buff_name = "traits_melee_counter_push_power",
    description_values = {
        {
            value_type = "percent",
            value = 0.03
        },
    }
}

WeaponTraits.buff_templates.traits_melee_counter_push_power = {
    buffs = {
        {
            event = "on_hit",
            dormant = true,
            event_buff = true,
            buff_func = function (player, buff, params)
                local player_unit = player.player_unit
                local hit_unit = params[1]
                local attack_type = params[2]
                local hit_zone_name = params[3]
                local target_number = params[4]
                local buff_type = params[5]
                local critical_hit = params[6]
                
                local breed_data = Unit.get_data(hit_unit, "breed")

                if Unit.alive(player_unit) and attack_type == "heavy_attack" and not breed_data ~= nil then
                    local health_extension = ScriptUnit.extension(hit_unit, "health_system")
			        local health = health_extension:current_health()
                    local calls = math.ceil(health / 255)
                    mod:echo(tostring(health))

                    for i = 1, calls, 1 do
                        mod:buff_attack_hit(player_unit, hit_unit, "heroic_killing_blow_proc")
                    end 
                    
                    local breed_data = Unit.get_data(hit_unit, "breed")

                    if breed_data then 
                        local breed_name = breed_data.name

                        if breed_name == "chaos_troll" then
                            local health_extension = ScriptUnit.extension(hit_unit, "health_system")
                            local state = health_extension.state

                            if not state == "down" then
                                mod:buff_attack_hit(unit, hit_unit, "heroic_killing_blow_proc")
                            end
                        end
                    end
                end

            end,
            proc_chance = 1 --0.03
        }
    }
}

NewDamageProfileTemplates.heroic_killing_blow_proc = {
	charge_value = "n/a",
	default_target = {
		boost_curve_type = "tank_curve",
		boost_curve_coefficient = 1,
		attack_template = "heroic_killing_blow_proc",
		power_distribution = {
			attack = 1,
			impact = 1
		}
    },
    targets = {
		boost_curve_type = "tank_curve",
		boost_curve_coefficient = 1,
		attack_template = "heroic_killing_blow_proc",
		power_distribution = {
			attack = 1,
			impact = 1
		}
	}
}

mod.buff_attack_hit = function (self, unit, hit_unit, damage_profile_name)
    local network_manager = Managers.state.network
    local inventory_extension = ScriptUnit.extension(unit, "inventory_system")
    local wielded_slot_name = inventory_extension:get_wielded_slot_name()
	local slot_data = inventory_extension:get_slot_data(wielded_slot_name)
	local item_data = slot_data.item_data
	local item_name = item_data.name
    local damage_source_id = NetworkLookup.damage_sources[item_name]
	local attacker_unit_id = network_manager:unit_game_object_id(unit)
	local hit_unit_id = network_manager:unit_game_object_id(hit_unit)
    local hit_zone_id = NetworkLookup.hit_zones.head
    local hit_position = POSITION_LOOKUP[hit_unit]
    local target_unit_position = POSITION_LOOKUP[hit_unit] or Unit.world_position(hit_unit, 0)
	local attacker_position = POSITION_LOOKUP[unit] or Unit.world_position(unit, 0)
    local attack_direction = Vector3.normalize(target_unit_position - attacker_position)
    local damage_profile_id = NetworkLookup.damage_profiles[damage_profile_name]
    local power_level = 6000
    local melee_boost_override = damage_profile_name and damage_profile_name.melee_boost_override
    local boost_curve_multiplier = ActionUtils.get_melee_boost(unit, melee_boost_override)

    local weapon_system = Managers.state.entity:system("weapon_system")
    weapon_system:send_rpc_attack_hit(damage_source_id, attacker_unit_id, hit_unit_id, hit_zone_id, hit_position, attack_direction, damage_profile_id, "power_level", power_level, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", boost_curve_multiplier, "can_damage", true, "can_stagger", true)

end

--[[mod:hook_safe(DamageUtils, "buff_on_attack", function (unit, hit_unit, attack_type, is_critical, hit_zone_name, target_number, send_to_server, buff_type)
    local inventory_extension = ScriptUnit.extension(unit, "inventory_system")
    local buff_extension = ScriptUnit.extension(unit, "buff_system")

    if attack_type == "heavy_attack" then
        local _, procced = buff_extension:apply_buffs_to_value(0, StatBuffIndex.HEAVY_KILLING_BLOW_PROC)

		if procced then
            mod:echo("procced")
            local health_extension = ScriptUnit.extension(hit_unit, "health_system")
			local health = health_extension:current_health()
			local calls = math.ceil(health / 255)

            for i = 1, calls, 1 do
				mod:buff_attack_hit(unit, hit_unit, "heroic_killing_blow_proc")
			end

			return "killing_blow"
		end
	end
end)]]