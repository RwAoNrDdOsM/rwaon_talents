local mod = get_mod("rwaon_talents")
local position_lookup = POSITION_LOOKUP

mod:hook_origin(PlayerCharacterStateLeaping, "update", function (self, unit, input, dt, context, t)
	local csm = self.csm
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension
	local inventory_extension = self.inventory_extension
	local health_extension = self.health_extension

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

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

	if self:_update_movement(unit, dt, t) then
		self:_finish(unit, t)

		if CharacterStateHelper.is_colliding_down(unit) then
			csm:change_state("walking", self.temp_params)
			first_person_extension:change_state("walking")

			return
		end

		if not self.csm.state_next and locomotion_extension:current_velocity().z <= 0 then
			csm:change_state("falling", self.temp_params)
			first_person_extension:change_state("falling")

			return
		end
	end

	local current_position = POSITION_LOOKUP[unit]
	local starting_pos = self._leap_data.starting_pos:unbox()
	local distance_travelled = Vector3.length(current_position - starting_pos)
	local percentage_done = distance_travelled / self._leap_data.total_distance
	local look_override_x = 0
	local look_override_y = math.lerp(0, -0.01, percentage_done)
	local look_sense_override = math.min(1, math.lerp(0.1, 1, percentage_done))
	local look_override = Vector3(look_override_x, look_override_y, 0)

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, inventory_extension, look_sense_override, look_override)
	CharacterStateHelper.update_weapon_actions(t, unit, input_extension, inventory_extension, health_extension)
end)