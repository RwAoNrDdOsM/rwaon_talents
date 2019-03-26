local mod = get_mod("rwaon_talents")

local function is_in_inn()
    local level_transition_handler = Managers.state.game_mode.level_transition_handler
    local level_key = level_transition_handler:get_current_level_keys()
    if level_key == "inn_level" then
        return true
    else
        return false
    end
end

mod:hook_safe(ActionCareerWEWaywatcher, "client_owner_start_action", function (self, new_action, t, chain_action_data, power_level, action_init_data)
	local owner_unit = self.owner_unit
    local weapon_slot = "slot_ranged"
    local inventory_extension = ScriptUnit.extension(owner_unit, "inventory_system")
    local slot_data = inventory_extension:get_slot_data(weapon_slot)
    if slot_data then
        local buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
        local item_data = slot_data.item_data
        local item_template = BackendUtils.get_item_template(item_data)
        local buff_template = nil
        local remove_buff_1 = nil
        local remove_buff_2 = nil
        if item_template.name == "shortbow_hagbane_template_1" then
            if not buff_extension:has_buff_type("shortbow_hagbane_template_1") then
                buff_template = "shortbow_hagbane_template_1"
                remove_buff_1 = "shortbow_template_1"
                remove_buff_2 = "longbow_template_1"
            end
        elseif item_template.name == "shortbow_template_1" then
            if not buff_extension:has_buff_type("shortbow_template_1") then
                buff_template = "shortbow_template_1"
                remove_buff_1 = "shortbow_hagbane_template_1"
                remove_buff_2 = "longbow_template_1"
            end
        elseif item_template.name == "longbow_template_1" then
            if not buff_extension:has_buff_type("longbow_template_1") then
                buff_template = "longbow_template_1"
                remove_buff_1 = "shortbow_template_1"
                remove_buff_2 = "shortbow_hagbane_template_1"
            end
        end
        local network_manager = Managers.state.network
        local owner_unit_id = network_manager:unit_game_object_id(owner_unit)
        local buff_template_name_id = nil
        if buff_template then
            buff_template_name_id = NetworkLookup.buff_templates[buff_template]
        end
        if buff_template and buff_template_name_id then
            if self.is_server then
                buff_extension:add_buff(buff_template)
                network_manager.network_transmit:send_rpc_clients("rpc_add_buff", owner_unit_id, buff_template_name_id, owner_unit_id, 0, false)
            else
                network_manager.network_transmit:send_rpc_server("rpc_add_buff", owner_unit_id, buff_template_name_id, owner_unit_id, 0, true)
            end
        end
        
        local buff_id_1 = nil
        local buff_id_2 = nil
        if remove_buff_1 then
            buff_id_1 = buff_extension:add_buff(remove_buff_1)
        end
        if remove_buff_2 then
            buff_id_2 = buff_extension:add_buff(remove_buff_2)
        end
		if buff_id_1 then
			buff_extension:remove_buff(buff_id_1)
        end
        if buff_id_2 then
            buff_extension:remove_buff(buff_id_2)
        end
    end
end)

local function is_local(unit)
	local player = Managers.player:owner(unit)

	return player and not player.remote
end

mod:add_buff("shortbow_hagbane_template_1", {
    refresh_durations = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
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
        if buff_type == "ULTIMATE" and Unit.alive(player_unit) then
            --mod:echo("Success")
            --[[local network_manager = Managers.state.network
            local owner_unit_id = network_manager:unit_game_object_id(hit_unit)
            local buff_template = "aoe_poison_dot"
            local buff_template_name_id = NetworkLookup.buff_templates[buff_template]
            local hit_unit_buff_extension = ScriptUnit.extension(hit_unit, "buff_system")
            local is_server = player.is_server
            if is_server then
                hit_unit_buff_extension:add_buff(buff_template, {
                    attacker_unit = player_unit
                })
                network_manager.network_transmit:send_rpc_clients("rpc_add_buff", owner_unit_id, buff_template_name_id, owner_unit_id, 0, false)
                mod:echo("Applied Buff")
            else
                network_manager.network_transmit:send_rpc_server("rpc_add_buff", owner_unit_id, buff_template_name_id, owner_unit_id, 0, true)
            end]]
        end
	end,
})
mod:add_buff("shortbow_template_1", {
    refresh_durations = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
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
        if buff_type == "ULTIMATE" and Unit.alive(player_unit) then
            local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
            local network_manager = Managers.state.network
            local owner_unit_id = network_manager:unit_game_object_id(player_unit)
            local buff_template = "shortbow_template_1_buff"
            local buff_template_name_id = NetworkLookup.buff_templates[buff_template]
            local is_server = player.is_server
            if is_server then
                buff_extension:add_buff(buff_template)
                network_manager.network_transmit:send_rpc_clients("rpc_add_buff", owner_unit_id, buff_template_name_id, owner_unit_id, 0, false)
            else
                network_manager.network_transmit:send_rpc_server("rpc_add_buff", owner_unit_id, buff_template_name_id, owner_unit_id, 0, true)
            end
        end
	end,
})

mod:add_buff("shortbow_template_1_buff", {
    duration = 5,
    multiplier = 0.2,
    max_stacks = 1,
    name = "shortbow_template_1_buff",
    icon = "icons_placeholder",
    stat_buff = "attack_speed",
    refresh_durations = true
})

mod:add_buff("longbow_template_1", {
    refresh_durations = true,
    max_stacks = 1,
    event_buff = true,
    event = "on_hit",
    dormant = true,
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
        if buff_type == "ULTIMATE" and Unit.alive(player_unit) then
            --mod:echo("Success")
        end
	end,
})

mod:hook_origin(GenericAmmoUserExtension, "use_ammo", function (self, ammo_used)
	if not self.destroy_when_out_of_ammo and script_data.infinite_ammo then
		ammo_used = 0
	end

	local buff_extension = self.owner_buff_extension
	local infinite_ammo = false

	if buff_extension then
		infinite_ammo = buff_extension:get_non_stacking_buff("victor_bountyhunter_passive_infinite_ammo_buff") or buff_extension:get_non_stacking_buff("shortbow_template_1_buff")
	end

	if infinite_ammo then
		ammo_used = 0
	end

	self.shots_fired = self.shots_fired + ammo_used

	if buff_extension then
		buff_extension:trigger_procs("on_ammo_used")

		if self:total_remaining_ammo() == 0 then
			buff_extension:trigger_procs("on_last_ammo_used")
		end

		if not LEVEL_EDITOR_TEST and not Managers.player.is_server then
			local player_manager = Managers.player
			local owner_player = player_manager:owner(self.owner_unit)
			local peer_id = owner_player:network_id()
			local local_player_id = owner_player:local_player_id()
			local event_id = NetworkLookup.proc_events.on_ammo_used

			Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", peer_id, local_player_id, event_id)

			if self:total_remaining_ammo() == 0 then
				event_id = NetworkLookup.proc_events.on_last_ammo_used

				Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", peer_id, local_player_id, event_id)
			end
		end
	end

	assert(self:ammo_count() >= 0, "ammo went below 0")
end)

mod:hook_origin(ActionCareerWEWaywatcher.super, "fire", function (self, current_action, add_spread)
	local owner_unit = self.owner_unit
	local speed = current_action.speed
	local first_person_extension = self.first_person_extension
	local position = first_person_extension:current_position()
	local rotation = first_person_extension:current_rotation()
	local spread_extension = self.spread_extension
	local num_projectiles = self.num_projectiles

	for i = 1, num_projectiles, 1 do
		local fire_rotation = rotation

		if spread_extension then
			if self.num_projectiles_shot > 1 then
				local spread_horizontal_angle = math.pi * (self.num_projectiles_shot % 2 + 0.5)
				local shot_count_offset = (self.num_projectiles_shot == 1 and 0) or math.round((self.num_projectiles_shot - 1) * 0.5, 0)
				local angle_offset = self.multi_projectile_spread * shot_count_offset
				fire_rotation = spread_extension:combine_spread_rotations(spread_horizontal_angle, angle_offset, fire_rotation)
			end

			if add_spread then
				spread_extension:set_shooting()
			end
		end

		local angle = ActionUtils.pitch_from_rotation(fire_rotation)
		local target_vector = Vector3.normalize(Quaternion.forward(fire_rotation))

		if i > 1 then
			speed = speed * (1 - i * 0.05)
		end

		local target_unit = self.targets and ((current_action.single_target and self.targets[1]) or self.targets[i])
        local lookup_data = current_action.lookup_data
        local buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
        if buff_extension:has_buff_type("shortbow_hagbane_template_1") then
            ActionUtils.spawn_true_flight_projectile(owner_unit, target_unit, self.true_flight_template_id, position, fire_rotation, angle, target_vector, speed, self.item_name, "shortbow_hagbane_template_1", lookup_data.action_name, lookup_data.sub_action_name, nil, self._is_critical_strike, self.power_level)
        else
		    ActionUtils.spawn_true_flight_projectile(owner_unit, target_unit, self.true_flight_template_id, position, fire_rotation, angle, target_vector, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, nil, self._is_critical_strike, self.power_level)
            mod:echo(lookup_data.item_template_name)
            mod:echo(lookup_data.action_name)
            mod:echo(lookup_data.sub_action_name)
        end

		if self.ammo_extension and not self.extra_buff_shot then
			local ammo_usage = self.current_action.ammo_usage

			self.ammo_extension:use_ammo(ammo_usage)

			if self.ammo_extension:can_reload() then
				local play_reload_animation = false

				self.ammo_extension:start_reload(play_reload_animation)
			end
		end

		self.num_projectiles_shot = self.num_projectiles_shot + 1
		local overcharge_type = current_action.overcharge_type

		if overcharge_type and not self.extra_buff_shot then
			local overcharge_amount = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

			if current_action.scale_overcharge then
				self.overcharge_extension:add_charge(overcharge_amount, self.charge_level)
			else
				self.overcharge_extension:add_charge(overcharge_amount)
			end
		end

		if current_action.alert_sound_range_fire then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], current_action.alert_sound_range_fire)
		end
	end
end)