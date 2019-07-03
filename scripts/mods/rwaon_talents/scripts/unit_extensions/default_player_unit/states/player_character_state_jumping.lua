local mod = get_mod("rwaon_talents")
local position_lookup = POSITION_LOOKUP
mod:hook_origin(PlayerCharacterStateJumping, "update", function (self, unit, input, dt, context, t)
	local csm = self.csm
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	local locomotion_extension = self.locomotion_extension

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
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

	if locomotion_extension:is_on_ground() then
		csm:change_state("walking")
		first_person_extension:change_state("walking")

		return
	end

	if not csm.state_next and locomotion_extension:current_velocity().z <= 0 then
		csm:change_state("falling", self.temp_params)
		first_person_extension:change_state("falling")

		return
	end

	local inventory_extension = self.inventory_extension
	local move_speed = math.clamp(movement_settings_table.move_speed, 0, PlayerUnitMovementSettings.move_speed)
	local move_speed_multiplier = status_extension:current_move_speed_multiplier()
	move_speed = move_speed * move_speed_multiplier
	move_speed = move_speed * movement_settings_table.player_speed_scale
	move_speed = move_speed * movement_settings_table.player_air_speed_scale

	CharacterStateHelper.move_in_air(self.first_person_extension, input_extension, self.locomotion_extension, move_speed, unit)
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(t, unit, input_extension, inventory_extension, self.health_extension)

	local interactor_extension = self.interactor_extension

	if CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local config = interactor_extension:interaction_config()

		interactor_extension:start_interaction("interacting")

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
			params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
	end

	if CharacterStateHelper.is_interacting(interactor_extension) then
		local config = interactor_extension:interaction_config()

		if not config.allow_movement then
			local params = self.temp_params
			params.swap_to_3p = config.swap_to_3p
			params.show_weapons = config.show_weapons
			params.activate_block = config.activate_block

			csm:change_state("interacting", params)
		end

		return
	end
end)