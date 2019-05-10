local mod = get_mod("rwaon_talents")

local broadphase_results = {}
BuffFunctionTemplates.functions.activate_buff_based_on_enemy_proximity = function (unit, buff, params)
    local ai_system = Managers.state.entity:system("ai_system")
    local ai_broadphase = ai_system.broadphase
    local buff_extension = ScriptUnit.extension(unit, "buff_system")
    local template = buff.template
    local range = buff.range
    local num_enemies = template.num_enemies
    local buff_to_add = template.buff_to_add
    local own_position = POSITION_LOOKUP[unit]
    local num_nearby_enemies = Broadphase.query(ai_broadphase, own_position, range, broadphase_results)
    local num_alive_nearby_enemies = 0

    for i = 1, num_nearby_enemies, 1 do
        local enemy_unit = broadphase_results[i]
        local alive = ALIVE[enemy_unit] and ScriptUnit.extension(enemy_unit, "health_system"):is_alive()

        if alive then
            num_alive_nearby_enemies = num_alive_nearby_enemies + 1

            if num_alive_nearby_enemies == num_enemies then
                break
            end
        end
    end

    if not buff.stack_ids then
        buff.stack_ids = {}
    end

    local num_chunks = math.floor(num_alive_nearby_enemies / num_enemies)
    local num_buff_stacks = buff_extension:num_buff_type(buff_to_add)

    if num_buff_stacks < num_chunks then
        local difference = num_chunks - num_buff_stacks

        for i = 1, difference, 1 do
            local buff_id = buff_extension:add_buff(buff_to_add)
            local stack_ids = buff.stack_ids
            stack_ids[#stack_ids + 1] = buff_id
        end
    elseif num_chunks < num_buff_stacks then
        local difference = num_buff_stacks - num_chunks

        for i = 1, difference, 1 do
            local stack_ids = buff.stack_ids
            local buff_id = table.remove(stack_ids, 1)

            buff_extension:remove_buff(buff_id)
        end
    end
end
BuffFunctionTemplates.functions.activate_multiplier_based_on_enemy_proximity = function (unit, buff, params)
    local ai_system = Managers.state.entity:system("ai_system")
    local ai_broadphase = ai_system.broadphase
    local template = buff.template
    local range = buff.range
    local min_multiplier = template.min_multiplier
    local max_multiplier = template.max_multiplier
    local chunk_size = template.chunk_size
    local stat_buff_index = template.stat_buff
    local previous_proc = buff.previous_proc or 0
    local own_position = POSITION_LOOKUP[unit]

    table.clear(broadphase_results)

    local num_nearby_enemies = Broadphase.query(ai_broadphase, own_position, range, broadphase_results)
    local num_alive_nearby_enemies = 0

    for i = 1, num_nearby_enemies, 1 do
        local enemy_unit = broadphase_results[i]
        local alive = ALIVE[enemy_unit] and ScriptUnit.extension(enemy_unit, "health_system"):is_alive()

        if alive then
            num_alive_nearby_enemies = num_alive_nearby_enemies + 1
        end
    end

    local num_chunks = math.floor(num_alive_nearby_enemies / chunk_size)
    local multiplier = min_multiplier

    if num_chunks >= 1 then
        multiplier = max_multiplier
    end

    buff.multiplier = multiplier

    if previous_proc ~= multiplier and stat_buff_index then
        local buff_extension = ScriptUnit.extension(unit, "buff_system")
        local difference = multiplier - previous_proc

        buff_extension:update_stat_buff(stat_buff_index, difference)
    end

    buff.previous_proc = multiplier
end
BuffFunctionTemplates.functions.update_proc_chance_based_on_stacks = function (unit, buff, params)
    local buff_extension = ScriptUnit.extension(unit, "buff_system")
    local template = buff.template
    local chunks_buff = template.chunks_buff
    local num_chunks = buff_extension:num_buff_type(chunks_buff) or 0
    local min_proc_chance = template.min_proc_chance
	local max_proc_chance = template.max_proc_chance
    local stat_buff_index = template.stat_buff
	local proc_chance = math.clamp(num_chunks * min_proc_chance, min_proc_chance, max_proc_chance)
    if stat_buff_index then
        template.proc_chance = proc_chance
    end
end
mod:hook_origin(BuffFunctionTemplates.functions, "apply_dot_damage", function (unit, buff, params)
    if not Managers.state.network.is_server then
        return
    end

    local t = params.t

    if buff.next_poison_damage_time < t then
        local health_extension = ScriptUnit.extension(unit, "health_system")

        if health_extension:is_alive() then
            local buff_template = buff.template
            --local random_mod_next_dot_time = 0.75 * buff.template.time_between_dot_damages + math.random() * 0.5 * buff.template.time_between_dot_damages
            buff.next_poison_damage_time = buff.next_poison_damage_time + buff.template.time_between_dot_damages--+ random_mod_next_dot_time
            local attacker_unit = params.attacker_unit

            if Unit.alive(attacker_unit) then
                local target_unit = unit
                local hit_zone_name = buff.template.hit_zone or "full"
                local attack_direction = Vector3.down()
                local hit_ragdoll_actor = nil
                local damage_source = buff.damage_source or "dot_debuff"
                local power_level = buff.power_level or DefaultPowerLevel
                local damage_profile_name = buff_template.damage_profile or "default"
                local damage_profile = DamageProfileTemplates[damage_profile_name]
                local target_index = nil
                local boost_curve_multiplier = 0
                local is_critical_strike = false
                local can_damage = true
                local can_stagger = false
                local blocking = false
                local shield_breaking_hit = false
                local backstab_multiplier = nil

                DamageUtils.server_apply_hit(t, attacker_unit, target_unit, hit_zone_name, nil, attack_direction, hit_ragdoll_actor, damage_source, power_level, damage_profile, target_index, boost_curve_multiplier, is_critical_strike, can_damage, can_stagger, blocking, shield_breaking_hit, backstab_multiplier)
            end
        end
    end
end)
mod:hook_origin(BuffFunctionTemplates.functions, "start_dot_damage", function (unit, buff, params)
    --local random_mod_next_dot_time = 0.75 * buff.template.time_between_dot_damages + math.random() * 0.5 * buff.template.time_between_dot_damages
    buff.next_poison_damage_time = params.t + buff.template.time_between_dot_damages --+ random_mod_next_dot_time

    if buff.template.start_flow_event then
        Unit.flow_event(unit, buff.template.start_flow_event)
    end

    if buff.template.damage_type == "burninating" then
        local attacker_unit = params.attacker_unit
        local attacker_buff_extension = attacker_unit and ScriptUnit.has_extension(attacker_unit, "buff_system")
        local target_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

        if target_buff_extension and attacker_buff_extension and attacker_buff_extension:has_buff_type("sienna_unchained_burn_increases_damage_taken") then
            local buff_data = attacker_buff_extension:get_non_stacking_buff("sienna_unchained_burn_increases_damage_taken")

            table.clear(clearable_params)

            clearable_params.external_optional_multiplier = buff_data.multiplier
            clearable_params.external_optional_duration = buff.duration

            target_buff_extension:add_buff("increase_damage_recieved_while_burning", clearable_params)
        end
    end
end)