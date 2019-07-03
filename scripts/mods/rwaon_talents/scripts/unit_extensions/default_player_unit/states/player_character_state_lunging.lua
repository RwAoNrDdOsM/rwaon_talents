local mod = get_mod("rwaon_talents")

mod:hook_origin(PlayerCharacterStateLunging, "update", function (self, unit, input, dt, context, t)
	local csm = self.csm
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local whereabouts_extension = ScriptUnit.extension(unit, "whereabouts_system")
	local first_person_extension = self.first_person_extension
	local damage_start_time = self.damage_start_time

	if CharacterStateHelper.is_colliding_down(unit) then
		if self._falling then
			self._falling = false

			whereabouts_extension:set_landed()
		end

		whereabouts_extension:set_is_onground()
	elseif not self._falling then
		self._falling = true

		whereabouts_extension:set_fell(self.name)
	end

	local lunge_data = self._lunge_data
	local lunge_events = lunge_data.lunge_events

	if lunge_events then
		local first_event_data = lunge_events[1]
		local start_time = self._start_time

		while first_event_data do
			if first_event_data.t < t - start_time then
				local event_function = first_event_data.event_function

				event_function(self)
				table.remove(lunge_events, 1)

				first_event_data = lunge_events[1]
			else
				break
			end
		end
	end

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

		return
	end

	local world = self.world

	if CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		self._stop = true

		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	if CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)

		local params = movement_settings_table.stun_settings.pushed
		local hit_react_type = status_extension:hit_react_type()
		params.hit_react_type = hit_react_type .. "_push"

		csm:change_state("stunned", params)

		return
	end

	if CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)

		local params = movement_settings_table.stun_settings.parry_broken
		local hit_react_type = status_extension:hit_react_type() 
		params.hit_react_type = hit_react_type

		csm:change_state("stunned", params)

		return
	end

	if not self._stop then
		local damage_data = lunge_data.damage

		if damage_data and damage_start_time <= t then
			self._stop = self:_update_damage(unit, dt, t, damage_data)
		end

		local input_service = Managers.input:get_service("Player")

		if input_service:get("action_two", true) then
			local position = POSITION_LOOKUP[unit]
			local forward_direction = Quaternion.forward(first_person_extension:current_rotation())

			self:_do_blast(position, forward_direction)

			self._stop = true
		end

		local move_state = self:_update_movement(unit, dt, t, lunge_data)

		if move_state == "ledge_hang" then
			self._stop = true

			csm:change_state("ledge_hanging", self.temp_params)

			return
		end

		if move_state == "stop" and not self._stop then
			local position = POSITION_LOOKUP[unit]
			local forward_direction = Quaternion.forward(first_person_extension:current_rotation())

			self:_do_blast(position, forward_direction)

			self._stop = true
		end
	end

	if self._stop then
		if not self.csm.state_next and self._falling then
			csm:change_state("falling", self.temp_params)

			self.temp_params.hit = false

			first_person_extension:change_state("falling")

			return
		else
			csm:change_state("walking", self.temp_params)

			self.temp_params.hit = false

			first_person_extension:change_state("walking")

			return
		end
	end

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension, 0.5)
	CharacterStateHelper.update_weapon_actions(t, unit, input_extension, self.inventory_extension, self.health_extension)
	self._last_position:store(POSITION_LOOKUP[unit])
end)

mod:hook_origin(PlayerCharacterStateLunging, "_update_damage", function (self, unit, dt, t, damage_data)
	local padding = damage_data.depth_padding
	local half_width = 0.5 * damage_data.width
	local half_height = 0.5 * damage_data.height
	local new_pos = POSITION_LOOKUP[unit]
	local old_pos = self._last_position:unbox()
	local delta_move = new_pos - old_pos
	local half_length = Vector3.length(delta_move) * 0.5 + padding
	local rot = Quaternion.look(delta_move, Vector3.up())
	local first_person_extension = self.first_person_extension
	local forward_direction = Quaternion.forward(first_person_extension:current_rotation())
	local mid_pos = (new_pos + old_pos) * 0.5 + Vector3(0, 0, half_height) + (damage_data.offset_forward or 0) * forward_direction
	local size = Vector3(half_width, half_length, half_height)
	local collision_filter = damage_data.collision_filter
	local actors, num_actors = PhysicsWorld.immediate_overlap(self.physics_world, "shape", "oobb", "position", mid_pos, "rotation", rot, "size", size, "collision_filter", collision_filter, "use_global_table")
	local hit_units = self._hit_units
	local buff_extension = self.buff_extension
	local network_manager = Managers.state.network
	local attacker_unit_id = network_manager:unit_game_object_id(unit)
	local attack_direction = Vector3.normalize(delta_move)
	local weapon_system = Managers.state.entity:system("weapon_system")

	for i = 1, num_actors, 1 do
		local hit_actor = actors[i]
		local hit_unit = Actor.unit(hit_actor)

		if not hit_units[hit_unit] then
			hit_units[hit_unit] = true
			local hit_unit_id = network_manager:unit_game_object_id(hit_unit)
			local hit_unit_pos = POSITION_LOOKUP[hit_unit]
			local shield_blocked = nil
			local backstab_multiplier = 1
			local procced = false
			local breed = Unit.get_data(hit_unit, "breed")
			local damage_profile_id, power_level, hit_zone_id, ignore_shield, allow_backstab = self:_parse_attack_data(damage_data)

			if breed and AiUtils.unit_alive(hit_unit) then
				shield_blocked = not ignore_shield and AiUtils.attack_is_shield_blocked(hit_unit, unit)

				if allow_backstab then
					local owner_to_hit_dir = Vector3.normalize(hit_unit_pos - new_pos)
					local hit_unit_direction = Quaternion.forward(Unit.local_rotation(hit_unit, 0))
					local hit_angle = Vector3.dot(hit_unit_direction, owner_to_hit_dir)
					local behind_target = hit_angle >= 0.55

					if behind_target then
						backstab_multiplier, procced = buff_extension:apply_buffs_to_value(backstab_multiplier, "backstab_multiplier")
					end
				end

				shield_blocked = self:_calculate_hit_mass(shield_blocked, damage_data, hit_unit, breed)
			else
				shield_blocked = false
			end

			if breed and AiUtils.unit_alive(hit_unit) then
				local final_stagger_direction = nil

				if damage_data.stagger_angles then
					local owner_to_hit_dir = Vector3.normalize(hit_unit_pos - new_pos)
					local cross = Vector3.cross(Vector3.flat(owner_to_hit_dir), Vector3.flat(forward_direction))
					local additional_stagger_angle = Math.random(damage_data.stagger_angles.min, damage_data.stagger_angles.max) * ((cross.z < 0 and -1) or 1)
					local new_attack_direction = attack_direction
					new_attack_direction.x = math.cos(additional_stagger_angle) * attack_direction.x - math.sin(additional_stagger_angle) * attack_direction.y
					new_attack_direction.y = math.sin(additional_stagger_angle) * attack_direction.x + math.cos(additional_stagger_angle) * attack_direction.y
					final_stagger_direction = Vector3.normalize(new_attack_direction)
				else
					final_stagger_direction = attack_direction
				end

				local damage_source = "career_ability"
				local damage_source_id = NetworkLookup.damage_sources[damage_source]
				local actual_hit_target_index = nil
				local shield_break_procc = false
				local boost_curve_multiplier = 0
				local is_critical_strike = false
				local can_damage = true
				local can_stagger = true

				weapon_system:send_rpc_attack_hit(damage_source_id, attacker_unit_id, hit_unit_id, hit_zone_id, hit_unit_pos, final_stagger_direction, damage_profile_id, "power_level", power_level, "hit_target_index", actual_hit_target_index, "blocking", shield_blocked, "shield_break_procced", shield_break_procc, "boost_curve_multiplier", boost_curve_multiplier, "is_critical_strike", is_critical_strike, "can_damage", can_damage, "can_stagger", can_stagger)

				self._num_impacts = self._num_impacts + 1
				local lunge_events = self._lunge_data.lunge_events

				if lunge_events then
					local impact_event_function = lunge_events.impact

					if impact_event_function then
						impact_event_function(self)
					end
				end

				if self._lunge_data.first_person_hit_animation_event then
					CharacterStateHelper.play_animation_event_first_person(first_person_extension, self._lunge_data.first_person_hit_animation_event)
				end

				local hit_mass_count_reached = self.max_targets <= self._amount_of_mass_hit or breed.armor_category == 2 or breed.armor_category == 3

				if AiUtils.unit_alive(hit_unit) and (damage_data.interrupt_on_first_hit or (hit_mass_count_reached and damage_data.interrupt_on_max_hit_mass)) then
					self:_do_blast(new_pos, forward_direction)

					return true
				end

				if AiUtils.unit_alive(hit_unit) and damage_data.do_stagger then
					self:_do_blast(new_pos, forward_direction)
				end
			end
		end
	end

	return false
end)