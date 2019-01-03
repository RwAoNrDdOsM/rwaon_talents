local mod = get_mod("rwaon_talents")


------------------------------------------------------------------------------
ActivatedAbilitySettings.rwaon_we_2 = {
	description = "rwaon_career_active_desc_we_2",
	display_name = "career_active_name_we_2",
	cooldown = 40,
	icon = "kerillian_maidenguard_activated_ability",
	ability_class = CareerAbilityWEMaidenGuard
}

CareerSettings.we_maidenguard.activated_ability = ActivatedAbilitySettings.rwaon_we_2

mod:hook_origin(CareerAbilityWEMaidenGuard, "_run_ability", function(self)
    self:_stop_priming()

	local owner_unit = self._owner_unit
	local is_server = self._is_server
	local local_player = self._local_player
	local network_manager = self._network_manager
	local network_transmit = network_manager.network_transmit
	local status_extension = self._status_extension
	local career_extension = self._career_extension
	local talent_extension = ScriptUnit.extension(owner_unit, "talent_system")
	local buff_name = "kerillian_maidenguard_activated_ability"

	--[[if talent_extension:has_talent("rwaon_kerillian_double_dash", "wood_elf", true) then
		buff_name = "rwaon_kerillian_maidenguard_ability_double_dash"
	end]]

	local unit_object_id = network_manager:unit_game_object_id(owner_unit)
	local buff_template_name_id = buff_name

	if is_server then
		local buff_extension = self._buff_extension

		buff_extension:add_buff(buff_name, {
			attacker_unit = owner_unit
		})
		network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, false)
	else
		network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, true)
	end

	if local_player then
		local first_person_extension = self._first_person_extension

		first_person_extension:animation_event("shade_stealth_ability")
		career_extension:set_state("kerillian_activate_maiden_guard")
		first_person_extension:play_unit_sound_event("Play_career_ability_maiden_guard_charge", owner_unit, 0, true)
	end

	status_extension:set_noclip(true)

	if network_manager:game() then
		status_extension:set_is_dodging(true)

		local unit_id = network_manager:unit_game_object_id(owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_id, 0)
	end

	local has_impact_damage_buff = talent_extension:has_talent("kerillian_maidenguard_activated_ability_damage", "wood_elf", true)
	status_extension.do_lunge = {
		animation_end_event = "maiden_guard_active_ability_charge_hit",
		allow_rotation = true,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		falloff_to_speed = 5,
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.65,
		initial_speed = 37.5,
		animation_event = "maiden_guard_active_ability_charge_start",
		damage = {
			depth_padding = 0.4,
			height = 1.8,
			collision_filter = "filter_explosion_overlap_no_player",
			hit_zone_hit_name = "full",
			ignore_shield = true,
			interrupt_on_max_hit_mass = false,
			interrupt_on_first_hit = false,
			damage_profile = "maidenguard_dash_ability",
			width = 1.5,
			allow_backstab = true,
			power_level_multiplier = (has_impact_damage_buff and 2.5) or 0,
			stagger_angles = {
				max = 90,
				min = 90
			}
		}
    }

	if talent_extension:has_talent("rwaon_kerillian_double_dash", "we_maidenguard", true) then
		if local_player or (is_server and bot_player) then
			local buff_extension = self._buff_extension
			
			if buff_extension:has_buff_type("rwaon_kerillian_maidenguard_ability_double_dash") then
				career_extension:start_activated_ability_cooldown()

				if buff_extension:has_buff_type("rwaon_kerillian_maidenguard_ability_double_dash") then
					buff_extension:remove_buff(self._double_ability_buff_id)
				end
			else
				self._double_ability_buff_id = buff_extension:add_buff("rwaon_kerillian_maidenguard_ability_double_dash", {attacker_unit = owner_unit})
			end
		end
	else
		career_extension:start_activated_ability_cooldown()
	end

	self:_play_vo()
end)