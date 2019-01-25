local mod = get_mod("rwaon_talents")


------------------------------------------------------------------------------
ActivatedAbilitySettings.rwaon_we_2 = {
	description = "career_active_desc_we_2",
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
	local buff_template_name_id = NetworkLookup.buff_templates[buff_name]

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
	local has_impact_stagger_buff = talent_extension:has_talent("rwaon_kerillian_maidenguard_ability_stagger", "wood_elf", true)
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
			},
			do_stagger = has_impact_stagger_buff,
			on_interrupt_blast = {
				allow_backstab = true,
				radius = 3, -- 3
				power_level_multiplier = 1, -- 1
				hit_zone_hit_name = "full",
				damage_profile = "ability_push",
				ignore_shield = true,
				collision_filter = "filter_explosion_overlap_no_player"
			},
		}
    }

	if talent_extension:has_talent("rwaon_kerillian_maidenguard_ability_double_dash", "we_maidenguard", true) then
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

-- Stagger Talent

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
						backstab_multiplier, procced = buff_extension:apply_buffs_to_value(backstab_multiplier, StatBuffIndex.BACKSTAB_MULTIPLIER)
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