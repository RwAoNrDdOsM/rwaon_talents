local mod = get_mod("rwaon_talents")

mod:hook_origin(PlayerCharacterStateDodging, "update", function (self, unit, input, dt, context, t)
	local csm = self.csm
	local unit = self.unit
	local movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(unit)
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local first_person_extension = self.first_person_extension
	self.time_in_dodge = self.time_in_dodge + dt

	ScriptUnit.extension(unit, "whereabouts_system"):set_is_onground()

	if CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

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

	if self.locomotion_extension:is_animation_driven() then
		return
	end

	if (input_extension:get("jump") or input_extension:get("jump_only")) and status_extension:can_override_dodge_with_jump(t) and self.locomotion_extension:jump_allowed() then
		local params = self.temp_params
		params.post_dodge_jump = true

		csm:change_state("jumping", params)

		return
	end

	CharacterStateHelper.update_dodge_lock(unit, self.input_extension, status_extension)

	if not self.csm.state_next and not self.locomotion_extension:is_on_ground() then
		csm:change_state("falling", self.temp_params)

		return
	end

	if not self:update_dodge(unit, dt, t) then
		local params = self.temp_params

		csm:change_state("walking", params)
	end

	CharacterStateHelper.look(input_extension, self.player.viewport_name, first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(t, unit, input_extension, self.inventory_extension, self.health_extension)

	local move_anim = CharacterStateHelper.get_move_animation(self.locomotion_extension, input_extension, status_extension)

	if move_anim ~= self.move_anim then
		CharacterStateHelper.play_animation_event(unit, move_anim)

		self.move_anim = move_anim
	end
end)