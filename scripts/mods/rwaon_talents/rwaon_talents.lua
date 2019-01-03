local mod = get_mod("rwaon_talents")

local version = "Vermintide Mod Reworks - Alpha 03/01/19"

function mod:version(self)
	mod:echo(version)
end

mod:command("version", mod:localize("version_command_description"), function() mod.version() end)

local function merge(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

function mod:add_talent(career_name, tier, index, new_talent_name, new_talent_data)
    local career_settings = CareerSettings[career_name]
    local hero_name = career_settings.profile_name
    local talent_tree_index = career_settings.talent_tree_index
    
    local new_talent_index = #Talents[hero_name] + 1

    Talents[hero_name][new_talent_index] = merge({
        name = new_talent_name,
        description = new_talent_name .. "_desc",
        icon = "icons_placeholder",
        num_ranks = 1,
        requirements = {},
        description_values = {},
        buffs = {},
        buff_data = {},
    }, new_talent_data)

    TalentTrees[hero_name][talent_tree_index][tier][index] = new_talent_name

    TalentIDLookup[new_talent_name] = new_talent_index
end

function mod:add_talent_buff(hero_name, buff_name, buff_data)
    --local new_buff_index = #NetworkLookup.buff_templates[buff_name] + 1
    
    local talent_buff = {
        buffs = {
            merge({ name = buff_name }, buff_data),
        },
    }
    TalentBuffTemplates[hero_name][buff_name] = talent_buff
    BuffTemplates[buff_name] = talent_buff
    --NetworkLookup.buff_templates[buff_name] = new_buff_index
end

function mod:add_buff(buff_name, buff_data)
    local new_buff = {
        buffs = {
            merge({ name = buff_name }, buff_data),
        },
    }
    BuffTemplates[buff_name] = new_buff
end

function mod:add_buff_function(name, func)
    BuffFunctionTemplates.functions[name] = func
end

function add_weapon_value(action_no, action_from, value, new_data)
    action_no[action_from][value] = new_data
end

-- Replace Localize
local vmf = get_mod("VMF")
mod:hook("Localize", function(func, text_id)
    local str = vmf.quick_localize(mod, text_id)
    if str then return str end
    return func(text_id)
end)

-- Talents
mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/talents/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/talents/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/talents/witch_hunter")
mod:dofile("scripts/mods/rwaon_talents/talents/dwarf_ranger")

-- Ultimates
mod:dofile("scripts/mods/rwaon_talents/ults/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/ults/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/ults/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/ults/witch_hunter")
mod:dofile("scripts/mods/rwaon_talents/ults/dwarf_ranger")

-- Weapons
--mod:dofile("scripts/mods/rwaon_talents/weapons/1h_falchions")
--mod:dofile("scripts/mods/rwaon_talents/weapons/1h_axes")
mod:dofile("scripts/mods/rwaon_talents/weapons/shortbows_hagbane")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_blast_beam")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_spark_spear")
mod:dofile("scripts/mods/rwaon_talents/weapons/staff_fireball_fireball")
mod:dofile("scripts/mods/rwaon_talents/weapons/staff_fireball_geiser")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_flamethrower")


-- Traits
--mod:dofile("scripts/mods/rwaon_talents/traits/barrage")

--[[ DEBUG DEBUG DEBUG ]]--

-- Set all characters to max level.
mod:hook(BackendInterfaceHeroAttributesPlayFab, "get", function (func, self, hero_name, attribute_name)
    if attribute_name == "experience" then
        return 99999999999
    end
    return func(self, hero_name, attribute_name)
end)

-- Unlock all careers.
mod:hook(Development, "parameter", function(func, key, ...)
    if key == "unlock_all_careers" then return true end
    return func(key, ...)
end)

-- Do NOT unlock achievements.
mod:hook(Achievement, "unlock", function(func, ...)
    return
end)

--[[
local unit_alive = Unit.alive

mod:hook_origin(AreaDamageSystem, "_damage_unit", function(self, aoe_damage_data)
	local hit_unit = aoe_damage_data.hit_unit
	local attacker_unit = aoe_damage_data.attacker_unit
	local impact_position = aoe_damage_data.impact_position:unbox()
	local shield_blocked = aoe_damage_data.shield_blocked
	local do_damage = aoe_damage_data.do_damage
	local hit_zone_name = aoe_damage_data.hit_zone_name
	local damage_source = aoe_damage_data.damage_source
	local hit_distance = aoe_damage_data.hit_distance
	local push_speed = aoe_damage_data.push_speed
	local radius = aoe_damage_data.radius
	local max_damage_radius = aoe_damage_data.max_damage_radius
	local radius_min = aoe_damage_data.radius_min
	local radius_max = aoe_damage_data.radius_max
	local full_power_level = aoe_damage_data.full_power_level
	local actual_power_level = aoe_damage_data.actual_power_level
	local hit_direction = aoe_damage_data.hit_direction:unbox()
    local explosion_template_name = aoe_damage_data.explosion_template_name or "cascading_firecloak"
	local is_critical_strike = aoe_damage_data.is_critical_strike
	local allow_critical_proc = aoe_damage_data.allow_critical_proc
	local hit_unit_alive = unit_alive(hit_unit)

	if not hit_unit_alive then
		return
	end

	local attacker_unit_alive = unit_alive(attacker_unit)

	if not attacker_unit_alive then
		return
	end

	local explosion_template = ExplosionTemplates[explosion_template_name]
	local explosion_data = explosion_template.explosion
	local breed = AiUtils.unit_breed(hit_unit)
	local is_immune = breed and explosion_data.immune_breeds and (explosion_data.immune_breeds[breed.name] or explosion_data.immune_breeds.all)

	if shield_blocked then
		hit_distance = math.lerp(hit_distance, radius, 0.5)
	end

	local glancing_hit = max_damage_radius < hit_distance
	local attacker_player = Managers.player:owner(attacker_unit)
	local attacker_is_player = attacker_player ~= nil

	if attacker_is_player then
		local item_data = rawget(ItemMasterList, damage_source)

		if breed and item_data and not IGNORED_ITEM_TYPES_FOR_BUFFS[item_data.item_type] then
			local attack_type = "aoe"

			if item_data and item_data.item_type == "grenade" then
				attack_type = item_data.item_type
			end

			local send_to_server = false

			if attacker_player and attacker_player.remote then
				local peer_id = attacker_player.peer_id
				local attack_type_id = NetworkLookup.buff_attack_types.aoe
				local network_manager = Managers.state.network
				local attacker_unit_id = network_manager:unit_game_object_id(attacker_unit)
				local hit_unit_id = network_manager:unit_game_object_id(hit_unit)
				local hit_zone_id = NetworkLookup.hit_zones[hit_zone_name]
				local buff_weapon_type_id = NetworkLookup.buff_weapon_types["n/a"]

				RPC.rpc_buff_on_attack(peer_id, attacker_unit_id, hit_unit_id, attack_type_id, is_critical_strike and allow_critical_proc, hit_zone_id, 1, buff_weapon_type_id)
				DamageUtils.buff_on_attack(attacker_unit, hit_unit, attack_type, is_critical_strike and allow_critical_proc, hit_zone_name, 1, send_to_server, "n/a")
			elseif attacker_player then
				DamageUtils.buff_on_attack(attacker_unit, hit_unit, attack_type, is_critical_strike and allow_critical_proc, hit_zone_name, 1, send_to_server, "n/a")
			end

			if not explosion_template.no_aggro then
				AiUtils.aggro_unit_of_enemy(hit_unit, attacker_unit)
			end
		end
	end

	if not is_immune then
		local blocking = false
		local blackboard = BLACKBOARDS[hit_unit]

		if blackboard and radius < hit_distance and blackboard.shield_user then
			local stagger = blackboard.stagger
			blocking = not stagger or stagger < 1
		end

		local hit_ragdoll_actor = nil

		if not blocking and breed and breed.hitbox_ragdoll_translation then
			hit_ragdoll_actor = breed.hitbox_ragdoll_translation.j_spine or breed.hitbox_ragdoll_translation.j_spine1
		end

		local damage_profile_name = (glancing_hit and explosion_data.damage_profile_glance) or explosion_data.damage_profile or "default"

		if not do_damage or is_immune then
			damage_profile_name = damage_profile_name .. "_no_damage"
		end

		local t = Managers.time:time("game")
		local damage_profile = DamageProfileTemplates[damage_profile_name]
		local target_index = nil
		local boost_curve_multiplier = 0
		local shield_break_procc = false
		local is_critical_strike = false
		local backstab_multiplier = 1

		DamageUtils.add_damage_network_player(damage_profile, target_index, actual_power_level, hit_unit, attacker_unit, hit_zone_name, impact_position, hit_direction, damage_source, hit_ragdoll_actor, boost_curve_multiplier, is_critical_strike, backstab_multiplier)

		local target_alive = AiUtils.unit_alive(hit_unit)

		if target_alive then
			DamageUtils.stagger_ai(t, damage_profile, target_index, actual_power_level, hit_unit, attacker_unit, hit_zone_name, hit_direction, boost_curve_multiplier, is_critical_strike, shield_blocked, damage_source)
		elseif explosion_data.on_death_func then
			explosion_data.on_death_func(hit_unit)
		end

		DamageUtils.apply_dot(damage_profile, target_index, full_power_level, hit_unit, attacker_unit, hit_zone_name, damage_source, boost_curve_multiplier, is_critical_strike)

		if push_speed and DamageUtils.is_player_unit(hit_unit) then
			local status_extension = ScriptUnit.extension(hit_unit, "status_system")

			if not status_extension:is_disabled() then
				local locomotion_system = ScriptUnit.extension(hit_unit, "locomotion_system")

				locomotion_system:add_external_velocity(hit_direction * push_speed)
			end
		end
	end
end)

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
end)]]