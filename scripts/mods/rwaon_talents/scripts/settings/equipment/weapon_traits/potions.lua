local mod = get_mod("rwaon_talents")

--Concotion and Proxy

mod:add_buff_extra("damage_boost_potion_half", {
	activation_effect = "fx/screenspace_potion_01",
	deactivation_sound = "hud_gameplay_stance_deactivate",
	activation_sound = "hud_gameplay_stance_smiter_activate",
	buffs = {
		{
			duration = 8,
			name = "armor penetration",
			refresh_durations = true,
			max_stacks = 1,
			icon = "potion_buff_01"
		}
	}
})
mod:add_buff_extra("speed_boost_potion_half", {
	activation_effect = "fx/screenspace_potion_02",
	deactivation_sound = "hud_gameplay_stance_deactivate",
	activation_sound = "hud_gameplay_stance_ninjafencer_activate",
	buffs = {
		{
			apply_buff_func = "apply_movement_buff",
			multiplier = 1.5,
			name = "movement",
			icon = "potion_buff_02",
			refresh_durations = true,
			remove_buff_func = "remove_movement_buff",
			max_stacks = 1,
			duration = 8,
			path_to_movement_setting_to_modify = {
				"move_speed"
			}
		},
		{
			multiplier = 0.5,
			name = "attack speed buff",
			refresh_durations = true,
			max_stacks = 1,
			duration = 8,
			stat_buff = "attack_speed"
		}
	}
})
mod:add_buff_extra("cooldown_reduction_potion_half", {
	activation_effect = "fx/screenspace_potion_02",
	deactivation_sound = "hud_gameplay_stance_deactivate",
	activation_sound = "hud_gameplay_stance_ninjafencer_activate",
	buffs = {
		{
			name = "cooldown reduction buff",
			multiplier = 15,
			duration = 8,
			max_stacks = 1,
			icon = "potion_buff_03",
			refresh_durations = true,
			stat_buff = "cooldown_regen"
		}
	}
})

mod:hook_origin(ActionPotion, "finish", function (self, reason)
	if reason ~= "action_complete" then
		return
	end

	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local buff_template = current_action.buff_template
	local buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	local potion_spread = buff_extension:has_buff_type("trait_ring_potion_spread")
	local targets = {
		owner_unit
	}
	local smallest_distance = TrinketSpreadDistance
	local additional_target = nil

	if potion_spread then
		local num_players = #PLAYER_AND_BOT_UNITS
		local owner_player_position = POSITION_LOOKUP[owner_unit]

		for i = 1, num_players, 1 do
			local other_player_unit = PLAYER_AND_BOT_UNITS[i]

			if Unit.alive(other_player_unit) and other_player_unit ~= owner_unit then
				local other_player_position = POSITION_LOOKUP[other_player_unit]
				local distance = Vector3.distance(owner_player_position, other_player_position)

				if distance <= smallest_distance then
					--smallest_distance = distance
					additional_target = other_player_unit

					if additional_target then
						targets[#targets + 1] = additional_target
					end
				end
			end
		end
	end

	if buff_extension:has_buff_perk("potion_duration") then
		buff_template = buff_template .. "_increased"
	end

	local num_targets = #targets
	local network_manager = Managers.state.network
	local buff_template_name_id = NetworkLookup.buff_templates[buff_template]
	local owner_unit_id = network_manager:unit_game_object_id(owner_unit)

	if not buff_extension:has_buff_type("trait_ring_all_potions") then
		for i = 1, num_targets, 1 do
			local target_unit = targets[i]
			local unit_object_id = network_manager:unit_game_object_id(target_unit)
			local target_unit_buff_extension = ScriptUnit.extension(target_unit, "buff_system")

			if self.is_server then
				target_unit_buff_extension:add_buff(buff_template)
				network_manager.network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id, owner_unit_id, 0, false)
			else
				network_manager.network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id, owner_unit_id, 0, true)
			end
		end
	else
		local additional_potion_buffs = {
			"speed_boost_potion_reduced",
			"damage_boost_potion_reduced",
			"cooldown_reduction_potion_reduced"
		}
		
		local modify_conc = mod:get("modify_concoction")

		if modify_conc == true then
			local potions = mod:get("potions")

			if potions == "potions_one" then
				additional_potion_buffs = {
					"speed_boost_potion_half",
					"cooldown_reduction_potion_half",
				}
			elseif potions == "potions_two" then
				additional_potion_buffs = {
					"speed_boost_potion_half",
					"damage_boost_potion_half",
				}
			elseif potions == "potions_three" then
				additional_potion_buffs = {
					"damage_boost_potion_half",
					"cooldown_reduction_potion_half",
				}
			end
		end

		for i = 1, #additional_potion_buffs, 1 do
			local additional_buff_template_name_id = NetworkLookup.buff_templates[additional_potion_buffs[i]]

			if self.is_server then
				buff_extension:add_buff(additional_potion_buffs[i])
				network_manager.network_transmit:send_rpc_clients("rpc_add_buff", owner_unit_id, additional_buff_template_name_id, owner_unit_id, 0, false)
			else
				network_manager.network_transmit:send_rpc_server("rpc_add_buff", owner_unit_id, additional_buff_template_name_id, owner_unit_id, 0, true)
			end
		end
	end

	if self.ammo_extension then
		local ammo_usage = current_action.ammo_usage
		local _, procced = buff_extension:apply_buffs_to_value(0, StatBuffIndex.NOT_CONSUME_POTION)

		if not procced then
			self.ammo_extension:use_ammo(ammo_usage)
		else
			local inventory_extension = ScriptUnit.extension(owner_unit, "inventory_system")

			inventory_extension:wield_previous_weapon()

			if buff_extension:has_buff_type("trait_ring_not_consume_potion_damage") then
				DamageUtils.debug_deal_damage(self.owner_unit, "basic_debug_damage_player")
			end
		end
	end

	local player = Managers.player:unit_owner(owner_unit)
	local position = POSITION_LOOKUP[owner_unit]

	Managers.telemetry.events:player_used_item(player, self.item_name, position)
end)