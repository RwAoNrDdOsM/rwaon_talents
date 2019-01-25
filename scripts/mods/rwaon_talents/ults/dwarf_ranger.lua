local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------


mod:hook_safe(CareerAbilityDRIronbreaker, "init", function (self, extension_init_context, unit, extension_init_data)
	rwaon_aimed_unit = nil
	self.owner_unit = unit
end)

mod.update_outline = function(self)
	if rwaon_aimed_unit and Unit.alive(rwaon_aimed_unit) then
		--Unit.set_shader_pass_flag_for_meshes(rwaon_aimed_unit, "outline_unit", true)
		--Unit.set_color_for_materials(rwaon_aimed_unit, "outline_color", Color(255, 0, 0))	
		local outline_system = Managers.state.entity:system("outline_system")
		outline_system:set_priority_outline(rwaon_aimed_unit, "ai_alive", true)
	end
end

mod.update_raycast = function(self, unit)
	local player = Managers.player:local_player()
	local owner_player = Managers.player:owner(unit)
	local is_bot = owner_player and owner_player.bot_player

	local world = Managers.world:world("level_world")
	local physics_world = World.get_data(world, "physics_world")
	
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local player_rotation = first_person_extension:current_rotation()
	local player_position = first_person_extension:current_position()
	local direction = Vector3.normalize(Quaternion.forward(player_rotation))
	
	local result = PhysicsWorld.immediate_raycast_actors(physics_world, player_position, direction, "dynamic_collision_filter", "filter_ray_true_flight_ai_only", "dynamic_collision_filter", "filter_ray_true_flight_hitbox_only")
		

	rwaon_aimed_unit = nil
	
	local range = 10

	local talent_extension = ScriptUnit.extension(unit, "talent_system")
	if talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_range", "dwarf_ranger", true) then
		range = 15
	end

	if result then
		local num_hits = #result

		for i = 1, num_hits, 1 do
			local hit = result[i]
			local hit_actor = hit[4]
			local hit_unit = Actor.unit(hit_actor)
			local distance = Vector3.distance(player_position, hit[1])
			
			if hit_unit ~= player.player_unit and distance <= range then
				if ScriptUnit.has_extension(hit_unit, "health_system") and not is_bot then -- 
					local health_extension = ScriptUnit.extension(hit_unit, "health_system")

					if health_extension:is_alive() then
						rwaon_aimed_unit = hit_unit
						return
					end
				end
			end
		end
	end
end

--[[CareerAbilityDRIronbreaker.update_raycast function(self, unit)
	local player = Managers.player:local_player()
	local owner_player = Managers.player:owner(unit)
	local is_bot = owner_player and owner_player.bot_player

	local world = Managers.world:world("level_world")
	local physics_world = World.get_data(world, "physics_world")
	
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local player_rotation = first_person_extension:current_rotation()
	mod:echo(player_rotation)
	local player_position = first_person_extension:current_position()
	mod:echo(player_position)
	local direction = Vector3.normalize(Quaternion.forward(player_rotation))
	mod:echo(direction)
	--local camera_position = Managers.state.camera:camera_position(player.viewport_name)
	--local camera_rotation = Managers.state.camera:camera_rotation(player.viewport_name)
	--local camera_direction = Quaternion.forward(camera_rotation)
	
	--local results = PhysicsWorld.immediate_raycast(physics_world, camera_position, camera_direction, 100, "all")
	
	local results = PhysicsWorld.immediate_raycast_actors(physics_world, player_position, direction)
		

	rwaon_aimed_unit = nil
	
	local range = 10

	local talent_extension = ScriptUnit.extension(unit, "talent_system")
	if talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_range", "dwarf_ranger", true) then
		range = 15
	end

	if results then
		local num_hits = #result

		for i = 1, num_hits, 1 do
			local hit = result[i]
			local hit_actor = hit[4]
			local hit_unit = Actor.unit(hit_actor)
			local distance = Vector3.distance(camera_position, hit[1])
			
			if hit_unit ~= player.player_unit and distance <= range then
				if ScriptUnit.has_extension(hit_unit, "health_system") and not is_bot then -- 
					local health_extension = ScriptUnit.extension(hit_unit, "health_system")

					if health_extension:is_alive() then
						rwaon_aimed_unit = hit_unit
						return
					end
				end
			end
		end
	end
end]]

mod.disable_outline = function(self)
	if rwaon_aimed_unit and Unit.alive(rwaon_aimed_unit) then
		--Unit.set_shader_pass_flag_for_meshes(rwaon_aimed_unit, "outline_unit", false)
		local outline_system = Managers.state.entity:system("outline_system")
		outline_system:set_priority_outline(rwaon_aimed_unit, "never", false)
	end
end

mod:hook_safe(CareerAbilityDRIronbreaker, "update", function (self, unit, input, dt, context, t)
	if not self:_ability_available() then
		rwaon_aimed_unit = nil
		return
	end

	local input_extension = self._input_extension

	if not input_extension then
		rwaon_aimed_unit = nil
		return
	end

	if not self._is_priming then
		mod:disable_outline()
	elseif self._is_priming then
		mod:disable_outline()
		mod:update_raycast(unit)
		mod:update_outline()

		if input_extension:get("action_two") then
			mod:disable_outline()
			rwaon_aimed_unit = nil
			return
		end

		if input_extension:get("weapon_reload") then
			mod:disable_outline()
			rwaon_aimed_unit = nil
			return
		end

		if not input_extension:get("action_career_hold") then
			mod:disable_outline()
			rwaon_aimed_unit = nil
		end
	end
end)

mod:hook_origin(TargetOverrideExtension, "taunt", function (self, radius, duration, stagger, taunt_species)
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
		local taunt_target = not ai_breed.ignore_taunts and not ai_breed.boss and not ai_breed.elite and not ai_breed.special

		if taunt_species then
			local category = mod:unit_category(taunt_species)
			
			if category == "normal" then 
				taunt_target = not ai_breed.ignore_taunts and not ai_breed.boss and not ai_breed.elite and not ai_breed.special
			end

			if category == "special" then 
				taunt_target = not ai_breed.ignore_taunts and not ai_breed.boss and not ai_breed.elite and not (ai_breed.horde_behavior == "horde_rat") and not (ai_breed.horde_behavior == "horde_shield_rat") and not (ai_breed.horde_behavior == "marauder") and not (ai_breed.horde_behavior == "shield_marauder") and not (ai_breed.horde_behavior == "fanatic")
			end

			if category == "elite" then 
				taunt_target = not ai_breed.ignore_taunts and not ai_breed.boss and not ai_breed.special and not (ai_breed.horde_behavior == "horde_rat") and not (ai_breed.horde_behavior == "horde_shield_rat") and not (ai_breed.horde_behavior == "marauder") and not (ai_breed.horde_behavior == "shield_marauder") and not (ai_breed.horde_behavior == "fanatic")
			end

			if category == "boss" then 
				taunt_target = not ai_breed.ignore_taunts and not ai_breed.elite and not ai_breed.special and not (ai_breed.horde_behavior == "horde_rat") and not (ai_breed.horde_behavior == "horde_shield_rat") and not (ai_breed.horde_behavior == "marauder") and not (ai_breed.horde_behavior == "shield_marauder") and not (ai_breed.horde_behavior == "fanatic")
			end
		end

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

				--[[local stagger_impact = {
					1, -- 1
					0.5, -- 0.5
					3, -- 3
					0, -- 0
					1 -- 1
				}]]

				AiUtils.stagger_target(self_unit, ai_unit, 1, self._stagger_impact, stagger_direction, t)
			end
		end
	end
end)

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
	--local taunt_bosses = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
	--local taunt_specials = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
	--local taunt_elites = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)
	--local taunt_infantry = talent_extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses", "dwarf_ranger", true)

	if is_server then
		local target_override_extension = ScriptUnit.extension(owner_unit, "target_override_system")

		target_override_extension:taunt(range, duration, stagger, rwaon_aimed_unit)
	else
		network_transmit:send_rpc_server("rpc_taunt", owner_unit_id, range, duration, stagger, rwaon_aimed_unit)
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

	mod:disable_outline()
	self:_play_vfx()
	self:_play_vo()
	career_extension:start_activated_ability_cooldown()
end)