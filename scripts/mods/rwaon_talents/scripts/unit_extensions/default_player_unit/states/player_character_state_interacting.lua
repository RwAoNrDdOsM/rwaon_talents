local mod = get_mod("rwaon_talents")

mod:hook_origin(PlayerCharacterStateInteracting, "update", function (self, unit, input, dt, context, t)
	local csm = self.csm
	local input_extension = self.input_extension
	local interactor_extension = self.interactor_extension
	local status_extension = self.status_extension
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

	if self.activate_block then
		if not status_extension:is_blocking() and not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local game_object_id = Managers.state.unit_storage:go_id(unit)

			if self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", game_object_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", game_object_id, true)
			end
		end

		status_extension:set_blocking(true)
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
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not csm.state_next and status_extension.do_leap then
		csm:change_state("leaping")

		return
	end

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.is_waiting_for_interaction_approval(interactor_extension) then
		if not self.has_started_interacting then
			self.has_started_interacting = true
		end

		if not CharacterStateHelper.interact(input_extension, interactor_extension) then
			csm:change_state("standing")

			return
		end
	end

	if CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)

		local params = movement_settings_table.stun_settings.pushed
		local hit_react_type = status_extension:hit_react_type()
		params.hit_react_type = hit_react_type .. "_push"

		csm:change_state("stunned", params)
		interactor_extension:abort_interaction()

		return
	end

	if CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)

		local params = movement_settings_table.stun_settings.parry_broken
		local hit_react_type = status_extension:hit_react_type() 
		params.hit_react_type = hit_react_type

		csm:change_state("stunned", params)
		interactor_extension:abort_interaction()

		return
	end

	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end)