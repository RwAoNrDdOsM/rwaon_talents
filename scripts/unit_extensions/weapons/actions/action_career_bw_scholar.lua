local mod = get_mod("rwaon_talents")

mod:hook_origin(ActionCareerBWScholar, "client_owner_start_action", function (self, new_action, t, chain_action_data, power_level, action_init_data)
	ActionCareerBWScholar.super.client_owner_start_action(self, new_action, t, chain_action_data, power_level, action_init_data)

	local talent_extension = self.talent_extension
	local owner_unit = self.owner_unit
	local buff_extension = ScriptUnit.extension(owner_unit, "buff_system")

	--[[if talent_extension:has_talent("sienna_scholar_activated_ability_dump_overcharge", "bright_wizard", true) then
		local player = Managers.player:owner(owner_unit)

		if player.local_player or (self.is_server and player.bot_player) then
			local overcharge_extension = self.overcharge_extension

			overcharge_extension:reset()
		end
	end]]

	if talent_extension:has_talent("rwaon_sienna_scholar_embodiment_of_aqshy", "bright_wizard", true) then
		local player = Managers.player:owner(owner_unit)

		if player.local_player or (self.is_server and player.bot_player) then
			buff_extension:add_buff("rwaon_sienna_scholar_embodiment_of_aqshy_buff", {attacker_unit = owner_unit})
			buff_extension:add_buff("rwaon_sienna_scholar_embodiment_of_aqshy_overcharge", {attacker_unit = owner_unit})
		end
	end	

	if talent_extension:has_talent("rwaon_sienna_scholar_activated_ability_heal", "bright_wizard", true) then
		local network_manager = Managers.state.network
		local network_transmit = network_manager.network_transmit
		local unit_id = network_manager:unit_game_object_id(owner_unit)
		local heal_type_id = NetworkLookup.heal_types.career_skill

		network_transmit:send_rpc_server("rpc_request_heal", unit_id, 40, heal_type_id) --50 3rd
	end

	if talent_extension:has_talent("rwaon_sienna_scholar_activated_ability_damage", "bright_wizard", true) then
		local player = Managers.player:owner(owner_unit)

		if player.local_player or (self.is_server and player.bot_player) then
			buff_extension:add_buff("rwaon_sienna_scholar_activated_ability_damage", {attacker_unit = owner_unit})
		end
	end	

	self:_play_vo()
end)