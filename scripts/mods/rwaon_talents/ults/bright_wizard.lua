local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:add_talent_buff("bright_wizard", "sienna_adept_ability_trail_double", {
	duration = 5,
    max_stacks = 1,
	icon = "sienna_adept_activated_ability_dump_overcharge",
	dormant = true,
	remove_buff_func = "sienna_adept_double_trail_talent_start_ability_cooldown",
})

mod:add_buff_function("sienna_adept_double_trail_talent_start_ability_cooldown", function (unit, buff, params) 
	local function is_local(unit)
		local player = Managers.player:owner(unit)
	
		return player and not player.remote
	end
	
	if is_local(unit) then
		local career_extension = ScriptUnit.extension(unit, "career_system")

		career_extension:stop_ability("cooldown_triggered")
		career_extension:start_activated_ability_cooldown()
	end
end)

local DEBUG = false
local function dprint(...)
	if DEBUG then
		printf(...)
	end
end

mod:hook_origin(CareerAbilityBWAdept, "_run_ability", function(func, self)
	dprint("_run_ability")
	self:_stop_priming()

	local end_position = self._last_valid_position and self._last_valid_position:unbox()

	if not end_position then
		dprint("no end_position")

		return
	end

	local owner_unit = self.owner_unit
	local is_server = self.is_server
	local local_player = self.local_player
	local bot_player = self.bot_player
	local network_manager = self.network_manager
	local career_extension = self.career_extension
	local talent_extension = ScriptUnit.extension(owner_unit, "talent_system")

	if local_player or (is_server and bot_player) then
		local start_pos = POSITION_LOOKUP[owner_unit]
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local projected_start_pos = LocomotionUtils.pos_on_mesh(nav_world, start_pos, 2, 30)

		if projected_start_pos then
			local damage_wave_template_name = "sienna_adept_ability_trail"

			if talent_extension:has_talent("sienna_adept_ability_trail_increased_duration", "bright_wizard", true) then
				damage_wave_template_name = "sienna_adept_ability_trail_increased_duration"
			end

			local damage_wave_template_id = NetworkLookup.damage_wave_templates[damage_wave_template_name]
			local invalid_game_object_id = NetworkConstants.invalid_game_object_id

			network_manager.network_transmit:send_rpc_server("rpc_create_damage_wave", invalid_game_object_id, projected_start_pos, end_position, damage_wave_template_id)
		end
	end

	if local_player then
		local first_person_extension = self.first_person_extension

		first_person_extension:animation_event("battle_wizard_active_ability_blink")

		MOOD_BLACKBOARD.skill_adept = true

		career_extension:set_state("sienna_activate_adept")
	end

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:teleport_to(end_position)

	local position = end_position
	local rotation = Unit.local_rotation(owner_unit, 0)
	local explosion_template = "sienna_adept_activated_ability_end_stagger"
	local scale = 1
	local career_power_level = career_extension:get_career_power_level()
	local area_damage_system = Managers.state.entity:system("area_damage_system")

	area_damage_system:create_explosion(owner_unit, position, rotation, explosion_template, scale, "career_ability", career_power_level, false)

	if talent_extension:has_talent("sienna_adept_ability_trail_double", "bright_wizard", true) then
		if local_player or (is_server and bot_player) then
			local buff_extension = self.buff_extension

			if buff_extension and buff_extension:has_buff_type("sienna_adept_ability_trail_double") then
				career_extension:start_activated_ability_cooldown()
				
				if buff_extension:has_buff_type("sienna_adept_ability_trail_double") then
					buff_extension:remove_buff(self._double_ability_buff_id)
				end

			elseif buff_extension then
				self._double_ability_buff_id = buff_extension:add_buff("sienna_adept_ability_trail_double")
			end
		end
	else
		career_extension:start_activated_ability_cooldown()
	end

	self:_play_vo()
end)

------------------------------------------------------------------------------


--[[mod:hook(ActionCareerBWScholar, "client_owner_start_action", function (self, new_action, t, chain_action_data, power_level, action_init_data)
	ActionCareerBWScholar.super.client_owner_start_action(self, new_action, t, chain_action_data, power_level, action_init_data)

	local talent_extension = self.talent_extension
	local owner_unit = self.owner_unit

	--[[if talent_extension:has_talent("sienna_scholar_activated_ability_dump_overcharge", "bright_wizard", true) then
		local player = Managers.player:owner(owner_unit)

		if player.local_player or (self.is_server and player.bot_player) then
			local overcharge_extension = self.overcharge_extension

			overcharge_extension:reset()
		end
	end

	if talent_extension:has_talent("sienna_scholar_activated_ability_heal", "bright_wizard", true) then
		local network_manager = Managers.state.network
		local network_transmit = network_manager.network_transmit
		local unit_id = network_manager:unit_game_object_id(owner_unit)
		local heal_type_id = NetworkLookup.heal_types.career_skill

		network_transmit:send_rpc_server("rpc_request_heal", unit_id, 50, heal_type_id)
	end

	self:_play_vo()
	return
end)]]