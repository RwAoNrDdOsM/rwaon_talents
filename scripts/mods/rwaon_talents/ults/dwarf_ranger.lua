local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod.ActionCareerDRIronbreakerTargeting = function(self)
    local current_action = new_action
    local aim_timer = 0
	local owner_unit = owner_unit
    local time_to_shoot = 0
    local target = nil
	local current_target = target
	local owner_player = Managers.player:owner(owner_unit)
    local is_bot = owner_player and owner_player.bot_player
    local outline_system = Managers.state.entity:system("outline_system")
    local required_aim_time = 0.1
    local aimed_target = nil
    
	if required_aim_time <= aim_timer then
		local physics_world = World.get_data(world, "physics_world")
		local first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
		local player_rotation = first_person_extension:current_rotation()
		local player_position = first_person_extension:current_position()
		local direction = Vector3.normalize(Quaternion.forward(player_rotation))
		local results = PhysicsWorld.immediate_raycast_actors(physics_world, player_position, direction, "dynamic_collision_filter", "filter_ray_true_flight_ai_only", "dynamic_collision_filter", "filter_ray_true_flight_hitbox_only")
		local hit_unit = nil

		if results then
			local num_results = #results

			for i = 1, num_results, 1 do
				local result = results[i]
				local hit_actor = result[4]

				if hit_actor then
					local aim_at_unit = Actor.unit(hit_actor)

					if hit_actor ~= Unit.actor(aim_at_unit, "c_afro") then
						local unit = Actor.unit(hit_actor)

						if ScriptUnit.has_extension(unit, "health_system") then
							local health_extension = ScriptUnit.extension(unit, "health_system")

							if health_extension:is_alive() then
								local breed = Unit.get_data(unit, "breed")

								if breed and not breed.no_autoaim then
									hit_unit = unit

									break
								end
							end
						end
					end
				end
			end
		end

		if hit_unit and aimed_target ~= hit_unit then
			aimed_target = hit_unit
			aim_timer = 0

			if Unit.alive(hit_unit) and current_target ~= hit_unit then
				target = hit_unit
			end
		end

		if not is_bot and outline_system and target then
			outline_system:set_priority_outline(target, "ai_alive", true)
		end
	end

	if not is_bot and outline_system or (current_target and not AiUtils.unit_alive(current_target)) and not is_bot then
		outline_system:set_priority_outline(current_target, "never", false)
    end
    return target
end

--[[mod:hook_origin(TargetOverrideExtension, "taunt", function (self, radius, duration, stagger, taunt_bosses)
	local self_unit = self._unit
	local t = Managers.time:time("game")
	local taunt_end_time = t + duration
	local position = POSITION_LOOKUP[self_unit]
	local result_table = self._result_table
	local num_ai_units = AiUtils.broadphase_query(position, radius, result_table)

	for i = 1, num_ai_units, 1 do
		local ai_unit = result_table[i]
		local ai_extension = ScriptUnit.extension(ai_unit, "ai_system")
		local ai_blackboard = ai_extension:blackboard()
		local ai_breed = ai_extension:breed()
		local taunt_target = not ai_breed.ignore_taunts and (not ai_breed.boss or taunt_bosses)

		if taunt_target then
			if ai_blackboard.target_unit == self_unit then
				ai_blackboard.no_taunt_hesitate = true
			end

			ai_blackboard.taunt_unit = self_unit
			ai_blackboard.taunt_end_time = taunt_end_time
			ai_blackboard.target_unit = self_unit
			ai_blackboard.target_unit_found_time = t

			if stagger then
				local stagger_direction = POSITION_LOOKUP[ai_unit] - position

				local stagger_impact = {
					0.5, -- 1
					0.5, -- 0.5
					0.5, -- 3
					0.5, -- 0
					0.5 -- 1
				}

				AiUtils.stagger_target(self_unit, ai_unit, 1, stagger_impact, stagger_direction, t)
			end
		end
	end
end)]]

--[[mod:add_buff("rwaon_bardin_ironbreaker_taunt_1", {
	duration = 5,
	delay_buff = true,
	delay_buff_name = "rwaon_bardin_ironbreaker_taunt_buff_1"
})

mod:add_buff("rwaon_bardin_ironbreaker_taunt_buff_1", {
	buff_func = funciton (unit)
		local targets = FrameTable.alloc_table()
		targets[1] = owner_unit
		local owner_unit_id = network_manager:unit_game_object_id(owner_unit)
		local range = 10
		local duration = 10

		if talent_extension:has_talent("bardin_ironbreaker_activated_ability_duration", "dwarf_ranger", true) then
			duration = 15
		end

		if talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_range", "dwarf_ranger", true) then
			range = 15
		end

		local stagger = true
		local taunt_bosses = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
		--local taunt_specials = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
		--local taunt_elites = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
		--local taunt_infantry = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)

		if is_server then
			local target_override_extension = ScriptUnit.extension(owner_unit, "target_override_system")
			--local target = mod.ActionCareerDRIronbreakerTargeting()
			--mod:echo(target)

			target_override_extension:taunt(range, duration, stagger, taunt_bosses)
		else
			network_transmit:send_rpc_server("rpc_taunt", owner_unit_id, range, duration, stagger, taunt_bosses)
		end
	end
	delay_buff = true,
	delay_buff_name = "rwaon_bardin_ironbreaker_taunt_2"
})]]

mod:hook_origin(CareerAbilityDRIronbreaker, "_run_ability", function (self)
	self:_stop_priming()

	local owner_unit = self._owner_unit
	local is_server = self._is_server
	local local_player = self._local_player
	local network_manager = self._network_manager
	local network_transmit = network_manager.network_transmit
	local owner_unit_id = network_manager:unit_game_object_id(owner_unit)
	local career_extension = self._career_extension
	local buff_extension = self._buff_extension
	local talent_extension = ScriptUnit.extension(owner_unit, "talent_system")


	CharacterStateHelper.play_animation_event(owner_unit, "iron_breaker_active_ability")

	local buff_name_1 = "bardin_ironbreaker_activated_ability"
	local buff_name_2 = "bardin_ironbreaker_activated_ability_block_cost"

	if talent_extension:has_talent("bardin_ironbreaker_activated_ability_duration", "dwarf_ranger", true) then
		buff_name_1 = "bardin_ironbreaker_activated_ability_duration"
		buff_name_2 = "bardin_ironbreaker_activated_ability_duration_block_cost"
	end

	local buff_3 = talent_extension:has_talent("rwaon_bardin_ironbreaker_uninterruptible_attacks", "dwarf_ranger", true)

	if talent_extension:has_talent("rwaon_bardin_ironbreaker_uninterruptible_attacks", "dwarf_ranger", true) then
		buff_name_3 = "rwaon_bardin_ironbreaker_uninterruptible_attacks"
	end

	local unit_object_id = network_manager:unit_game_object_id(owner_unit)
	local buff_template_name_id_3 = nil

	if buff_3 then
		buff_template_name_id_3 = buff_extension:add_buff("rwaon_bardin_ironbreaker_uninterruptible_attacks", {attacker_unit = owner_unit})
	end

	if is_server then
		buff_extension:add_buff(buff_name_1, {
			attacker_unit = owner_unit
		})
		network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id_1, unit_object_id, 0, false)

		if buff_2 then
			buff_extension:add_buff(buff_name_2, {
				attacker_unit = owner_unit
			})
			network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id_2, unit_object_id, 0, false)
		end
	else
		network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id_1, unit_object_id, 0, true)

		if buff_2 then
			network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id_2, unit_object_id, 0, true)
		end
	end

	--[[if talent_extension:has_talent("rwaon_bardin_ironbreaker_uninterruptible_attacks", "dwarf_ranger", true) then
		local buff_name_3 = "rwaon_bardin_ironbreaker_uninterruptible_attacks"
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_buff(buff_name_3, {
			attacker_unit = owner_unit
		})
	end]]


	local targets = FrameTable.alloc_table()
	targets[1] = owner_unit
	local range = 10
	local duration = 10

	if talent_extension:has_talent("bardin_ironbreaker_activated_ability_duration", "dwarf_ranger", true) then
		duration = 15
	end

	if talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_range", "dwarf_ranger", true) then
		range = 15
	end

	local stagger = true
	local taunt_bosses = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
	--local taunt_specials = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
	--local taunt_elites = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
	--local taunt_infantry = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)

	if is_server then
		local target_override_extension = ScriptUnit.extension(owner_unit, "target_override_system")
        --local target = mod.ActionCareerDRIronbreakerTargeting()
        --mod:echo(target)

		target_override_extension:taunt(range, duration, stagger, taunt_bosses)
	else
		network_transmit:send_rpc_server("rpc_taunt", owner_unit_id, range, duration, stagger, taunt_bosses)
	end

	local buff_template_name_id_1 = NetworkLookup.buff_templates[buff_name_1]
	local buff_template_name_id_2 = NetworkLookup.buff_templates[buff_name_2]

	for i = 1, #targets, 1 do
		local unit = targets[i]
		local unit_object_id = network_manager:unit_game_object_id(unit)
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		if is_server then
			buff_extension:add_buff(buff_name_1, {
				attacker_unit = owner_unit
			})
			buff_extension:add_buff(buff_name_2, {
				attacker_unit = owner_unit
			})

			network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id_1, owner_unit_id, 0, false)
			network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id_2, owner_unit_id, 0, false)
		else
			network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id_1, owner_unit_id, 0, true)
			network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id_2, owner_unit_id, 0, true)
		end
	end

	if local_player then
		local first_person_extension = self._first_person_extension

		first_person_extension:animation_event("ability_shout")
		first_person_extension:play_unit_sound_event("Play_career_ability_bardin_ironbreaker_enter", owner_unit, 0, true)
	end

	self:_play_vfx()
	self:_play_vo()
	career_extension:start_activated_ability_cooldown()
end)