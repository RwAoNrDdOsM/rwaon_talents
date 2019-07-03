local mod = get_mod("rwaon_talents")
local position_lookup = POSITION_LOOKUP
local fix = {
	"Double",
	"Triple",
	"Quad",
	"Penta",
	"Hexa",
	"Hepta",
	"Octa",
	"Nona",
	"Deca",
	"Hendeca",
	"Dodeca",
	"Trideca",
	"Tetradeca",
	"Pentadeca",
	"Hexadeca",
	"Heptadeca",
	"Octadeca",
	"Enneadeca",
	"Icosa"
}
mod:hook_origin(PlayerCharacterStateFalling, "update", function (self, unit, input, dt, context, t)
	local world = self.world
	local locomotion_extension = self.locomotion_extension
	local first_person_extension = self.first_person_extension
	local velocity = locomotion_extension:current_velocity()
	local self_pos = POSITION_LOOKUP[unit]

	if velocity.z > 0 then
		self.start_fall_height = position_lookup[unit].z
	end

	CharacterStateHelper.update_dodge_lock(unit, self.input_extension, self.status_extension)

	if position_lookup[unit].z < -240 then
		if self.is_server then
			local health_system = Managers.state.entity:system("health_system")

			health_system:suicide(unit)
		else
			local go_id = self.unit_storage:go_id(unit)

			self.network_transmit:send_rpc_server("rpc_suicide", go_id)
		end
	end

	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_overcharge_exploding(status_extension) then
		csm:change_state("overcharge_exploding")

		return
	end

	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)

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

	if not csm.state_next and locomotion_extension:is_on_ground() then
		if CharacterStateHelper.is_moving(locomotion_extension) then
			csm:change_state("walking")
			first_person_extension:change_state("walking")
		else
			csm:change_state("standing")
			first_person_extension:change_state("standing")
		end

		return
	end

	local colliding_with_ladder, ladder_unit = CharacterStateHelper.is_colliding_with_gameplay_collision_box(world, unit, "filter_ladder_collision")
	local recently_left_ladder = CharacterStateHelper.recently_left_ladder(status_extension, t)

	if colliding_with_ladder and not recently_left_ladder and not self.ladder_shaking then
		local top_node = Unit.node(ladder_unit, "c_platform")
		local ladder_rot = Unit.local_rotation(ladder_unit, 0)
		local ladder_plane_inv_normal = Quaternion.forward(ladder_rot)
		local ladder_offset = Unit.local_position(ladder_unit, 0) - self_pos
		local distance = Vector3.dot(ladder_plane_inv_normal, ladder_offset)
		local epsilon = 0.1

		if self_pos.z < Vector3.z(Unit.world_position(ladder_unit, top_node)) and distance > 0 and distance < 0.7 + epsilon then
			local params = self.temp_params
			params.ladder_unit = ladder_unit

			csm:change_state("climbing_ladder", params)

			return
		end
	end

	if CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if script_data.use_super_jumps and (input_extension:get("jump") or input_extension:get("jump_only")) then
		self.times_jumped_in_air = math.min(#fix, self.times_jumped_in_air + 1)
		local text = string.format("%sjump!", fix[self.times_jumped_in_air])

		Debug.sticky_text(text)

		local jump_speed = movement_settings_table.jump.initial_vertical_speed
		local velocity_current = self.locomotion_extension:current_velocity()
		local velocity_jump = Vector3(velocity_current.x, velocity_current.y, (velocity_current.z < -3 and jump_speed * 0.5) or jump_speed * 1.5)

		self.locomotion_extension:set_forced_velocity(velocity_jump)
		self.locomotion_extension:set_wanted_velocity(velocity_jump)
	end

	local inventory_extension = self.inventory_extension
	local move_speed = movement_settings_table.move_speed
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