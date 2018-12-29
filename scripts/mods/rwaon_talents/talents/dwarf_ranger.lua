local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:hook_origin(BuffExtension, "add_buff", function (self, template_name, params)
	if FROZEN[self._unit] then
		return
	end

	local buff_template = BuffTemplates[template_name]
	local buffs = buff_template.buffs
	local start_time = Managers.time:time("game")
	local id = self.id
	local world = self.world

	if #self._buffs == 0 then
		Managers.state.entity:system("buff_system"):set_buff_ext_active(self._unit, true)
	end

	for i, sub_buff_template in ipairs(buffs) do
		repeat
			local duration = sub_buff_template.duration
			local max_stacks = sub_buff_template.max_stacks
			local end_time = duration and start_time + duration

			if max_stacks then
				local has_max_stacks = false
				local stacks = 0

				for j = 1, #self._buffs, 1 do
					local existing_buff = self._buffs[j]

					if existing_buff.buff_type == sub_buff_template.name then
						if existing_buff.area_buff_unit and sub_buff_template.refresh_buff_area_position then
							local buff_area_extension = ScriptUnit.has_extension(existing_buff.area_buff_unit, "buff_area_system")

							if buff_area_extension then
								buff_area_extension:set_unit_position(POSITION_LOOKUP[self._unit])
							end
						end

						if duration and sub_buff_template.refresh_durations then
							existing_buff.start_time = start_time
							existing_buff.duration = duration
							existing_buff.end_time = end_time
							existing_buff.attacker_unit = (params and params.attacker_unit) or nil
							local reapply_buff_func = sub_buff_template.reapply_buff_func

							if reapply_buff_func then
								buff_extension_function_params.bonus = existing_buff.bonus
								buff_extension_function_params.multiplier = existing_buff.multiplier
								buff_extension_function_params.t = start_time
								buff_extension_function_params.end_time = end_time
								buff_extension_function_params.attacker_unit = existing_buff.attacker_unit

								BuffFunctionTemplates.functions[reapply_buff_func](self._unit, existing_buff, buff_extension_function_params, world)
							end
						end

						stacks = stacks + 1

						if stacks == max_stacks then
							has_max_stacks = true

							break
						end
					end
				end

				if has_max_stacks then
					break
				elseif stacks == max_stacks - 1 then
					local on_max_stacks_func = sub_buff_template.on_max_stacks_func

					if on_max_stacks_func then
						local player = Managers.player:owner(self._unit)

						if player then
							on_max_stacks_func(player, sub_buff_template)
						end
					end

					if sub_buff_template.reset_on_max_stacks then
						local num_buffs = #self._buffs
						local j = 1

						while num_buffs >= j do
							local buff = self._buffs[j]

							if buff.buff_type == sub_buff_template.name then
								buff_extension_function_params.bonus = buff.bonus
								buff_extension_function_params.multiplier = buff.multiplier
								buff_extension_function_params.t = start_time
								buff_extension_function_params.end_time = buff.duration and buff.start_time + buff.duration
								buff_extension_function_params.attacker_unit = buff.attacker_unit

								self:_remove_sub_buff(buff, j, buff_extension_function_params)

								num_buffs = num_buffs - 1
							else
								j = j + 1
							end
						end

						break
					end
				end
			end

			local buff = {
				id = id,
				parent_id = params and params.parent_id,
				start_time = start_time,
				template = sub_buff_template,
				buff_type = sub_buff_template.name
			}

			if sub_buff_template.buff_area then
				local unit_spawner = Managers.state.unit_spawner
				local extension_init_data = {
					buff_area_system = {
						removal_proc_function_name = sub_buff_template.remove_buff_func,
						radius = sub_buff_template.area_radius,
						owner_player = Managers.player:owner(self._unit)
					}
				}
				local buff_unit, buff_unit_go_id = unit_spawner:spawn_network_unit(sub_buff_template.area_unit_name, "buff_aoe_unit", extension_init_data, POSITION_LOOKUP[self._unit], Quaternion.identity(), nil)
				buff.area_buff_unit = buff_unit
			end

			buff.attacker_unit = (params and params.attacker_unit) or nil
			local bonus = sub_buff_template.bonus
			local multiplier = sub_buff_template.multiplier
			local proc_chance = sub_buff_template.proc_chance
			local range = sub_buff_template.range
			local damage_source, power_level = nil

			if params then
				local variable_value = params.variable_value

				if variable_value then
					local variable_bonus_table = sub_buff_template.variable_bonus

					if variable_bonus_table then
						local bonus_index = (variable_value == 1 and #variable_bonus_table) or 1 + math.floor(variable_value / (1 / #variable_bonus_table))
						bonus = variable_bonus_table[bonus_index]
					end

					local variable_multiplier_table = sub_buff_template.variable_multiplier

					if variable_multiplier_table then
						local min_multiplier = variable_multiplier_table[1]
						local max_multiplier = variable_multiplier_table[2]
						multiplier = math.lerp(min_multiplier, max_multiplier, variable_value)
					end
				end

				bonus = params.external_optional_bonus or bonus
				multiplier = params.external_optional_multiplier or multiplier
				proc_chance = params.external_optional_proc_chance or proc_chance
				duration = params.external_optional_duration or duration
				range = params.external_optional_range or range
				damage_source = params.damage_source
				power_level = params.power_level
			end

			buff.bonus = bonus
			buff.multiplier = multiplier
			buff.proc_chance = proc_chance
			buff.duration = duration
			buff.range = range
			buff.damage_source = damage_source
			buff.power_level = power_level
			buff_extension_function_params.bonus = bonus
			buff_extension_function_params.multiplier = multiplier
			buff_extension_function_params.t = start_time
			buff_extension_function_params.end_time = end_time
			buff_extension_function_params.attacker_unit = buff.attacker_unit
			local apply_buff_func = sub_buff_template.apply_buff_func

			if apply_buff_func then
				BuffFunctionTemplates.functions[apply_buff_func](self._unit, buff, buff_extension_function_params, world)
			end

			if sub_buff_template.stat_buff then
				local index = self:_add_stat_buff(sub_buff_template, buff)
				buff.stat_buff_index = index
			end

			if sub_buff_template.event_buff then
				local buff_func = sub_buff_template.buff_func
				local event = sub_buff_template.event
				buff.buff_func = buff_func
				local event_buffs = self._event_buffs[event]
				local index = self._event_buffs_index
				buff.event_buff_index = index
				event_buffs[index] = buff
				self._event_buffs_index = index + 1
			end

			if sub_buff_template.buff_after_delay then
				local delayed_buff_name = sub_buff_template.delayed_buff_name
				buff.delayed_buff_name = delayed_buff_name
			end

			if sub_buff_template.continuous_effect then
				self._continuous_screen_effects[id] = self:_play_screen_effect(sub_buff_template.continuous_effect)
			end

			self._buffs[#self._buffs + 1] = buff
		until true
	end

	local activation_sound = buff_template.activation_sound

	if activation_sound then
		self:_play_buff_sound(activation_sound)
	end

	local activation_effect = buff_template.activation_effect

	if activation_effect then
		self:_play_screen_effect(activation_effect)
	end

	local deactivation_effect = buff_template.deactivation_effect

	if deactivation_effect then
		self._deactivation_screen_effects[id] = deactivation_effect
	end

	local deactivation_sound = buff_template.deactivation_sound

	if deactivation_sound then
		self._deactivation_sounds[id] = deactivation_sound
	end

	self.id = id + 1

	return id
end)

mod:add_talent("dr_ironbreaker", 2, 3, "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks", {
    num_ranks = 1,
    description_values = {
        {
            value_type = "percent",
            value = 0.10,
        },
        {
            value = 5,
        },
        {
            value = 15,
        }
    },
    requirements = {},
    buffs = {
        "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks"
    },
})

ProcFunctions.apply_movespeed_on_charged_attacks = function (player, buff, params)
    local player_unit = player.player_unit
    local hit_unit = params[1]
    local attack_type = params[2]

    if attack_type ~= "heavy_attack" then
        return
    end

    if Unit.alive(player_unit) then
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

        buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_buff", buff_params)
    end
end
BuffFunctionTemplates.functions.apply_movespeed_on_charged_attacks = function (player, buff, params)
    local player_unit = player.player_unit
    local hit_unit = params[1]
    local attack_type = params[2]

    if attack_type ~= "heavy_attack" then
        return
    end

    if Unit.alive(player_unit) then
        local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

        buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_buff", buff_params)
    end
end


mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks", {
    event = "on_hit",
    event_buff = true,
    max_stacks = 1,
    icon = "icons_placeholder",
    buff_func = function (player, buff, params)
        local player_unit = player.player_unit
        local hit_unit = params[1]
        local attack_type = params[2]
    
        if attack_type ~= "heavy_attack" then
            return
        end
    
        if Unit.alive(player_unit) then
            local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
    
            buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_buff", buff_params)
        end
    end,
})

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_buff", {
    duration = 5,
	multiplier = 5,
    max_stacks = 1,
    refresh_durations = false,
    icon = "icons_placeholder",
    stat_buff = StatBuffIndex.ATTACK_SPEED,
    buff_after_delay = true,
    delayed_buff_name = "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown",
    buff_func = function (player, buff, params)
        local player_unit = player.player_unit
    
        if Unit.alive(player_unit) then
            local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
            local movespeed_on_charged_attacks_buff = buff_extension:get_non_stacking_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks")
    
            if movespeed_on_charged_attacks_buff then
                buff_extension:remove_buff(movespeed_on_charged_attacks_buff.id)
            end
        end
    end,
})

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown", {
    duration = 15,
    max_stacks = 1,
    icon = "icons_placeholder",
    refresh_durations = false,
    buff_after_delay = true,
    delayed_buff_name = "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks",      
})


--[[bardin_ironbreaker_gromril_delay = {
    buffs = {
        {
            duration = 20
            buff_after_delay = true,
            max_stacks = 1,
            refresh_durations = true,
            is_cooldown = true,
            icon = "bardin_ironbreaker_gromril_armour",
            dormant = true,
            delayed_buff_name = "bardin_ironbreaker_gromril_armour"
        }
    }
},
bardin_ironbreaker_refresh_gromril_armour = {
    buffs = {
        {
            event = "on_gromril_armour_removed",
            event_buff = true,
            buff_func = ProcFunctions.add_gromril_delay
        }
    }
},
bardin_ironbreaker_gromril_armour = {
    buffs = {
        {
            max_stacks = 1,
            icon = "bardin_ironbreaker_gromril_armour",
            dormant = true,
            refresh_durations = true
        }
    }
},]]
------------------------------------------------------------------------------