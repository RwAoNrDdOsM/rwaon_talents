local mod = get_mod("rwaon_talents")

-- Passives
mod:add_talent_buff("wood_elf", "kerillian_waywatcher_passive", {
    event_buff = true,
    event = "on_hit",
    heal_amount = 3,
    headshot_bonus = 2,
    range = 10,
    buff_to_add = "kerillian_waywatcher_passive_buff",
    buff_func = function (player, buff, params)
        local player_unit = player.player_unit
        local hit_unit = params[1]
		local attack_type = params[2]
		local hit_zone_name = params[3]
		local target_number = params[4]
		local buff_type = params[5]
        local critical_hit = params[6]

		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local template = buff.template
        local buff_to_add = template.buff_to_add
        local heal_amount = template.heal_amount
        local headshot_bonus = template.headshot_bonus
        local range = template.range
        local range_squared = range * range
		local num_buff_stacks = buff_extension:num_buff_type(buff_to_add)

		if not buff.stack_ids then
			buff.stack_ids = {}
		end

		if buff_type == "MELEE_1H" or buff_type == "MELEE_2H" then
            if num_buff_stacks ~= 10 then
                local buff_id = buff_extension:add_buff(buff_to_add)
                local stack_ids = buff.stack_ids
                stack_ids[#stack_ids + 1] = buff_id
            end
        elseif buff_type == "RANGED" and num_buff_stacks >= 5 then
            if Managers.state.network.is_server then
				local health_extension = ScriptUnit.extension(player_unit, "health_system")
				local status_extension = ScriptUnit.extension(player_unit, "status_system")
                
				if health_extension:is_alive() and not status_extension:is_knocked_down() and not status_extension:is_assisted_respawning() then
                    heal_amount = heal_amount * num_buff_stacks
                    if hit_zone_name == "head" or hit_zone_name == "neck" or hit_zone_name == "weakspot" then
                        heal_amount = heal_amount + (headshot_bonus * num_buff_stacks)
                        --mod:echo("headshot heal amount increase")
                    end

                    local player_position = POSITION_LOOKUP[player_unit]
					local player_and_bot_units = PLAYER_AND_BOT_UNITS

					for i = 1, #player_and_bot_units, 1 do
						if Unit.alive(player_and_bot_units[i]) then
							local health_extension = ScriptUnit.extension(player_and_bot_units[i], "health_system")
							local status_extension = ScriptUnit.extension(player_and_bot_units[i], "status_system")

                            if not status_extension:is_knocked_down() and not status_extension:is_assisted_respawning() and health_extension:is_alive() then
                                local unit_position = POSITION_LOOKUP[player_and_bot_units[i]]
				                local distance_squared = Vector3.distance_squared(player_position, unit_position)
                                
                                if distance_squared < range_squared then
                                    DamageUtils.heal_network(player_and_bot_units[i], player_unit, heal_amount, "career_passive")
                                    mod:echo("Added " .. tostring(heal_amount) .. " health for " .. tostring(player_and_bot_units[i]))
                                end
							end
						end
					end
                end
            end

            if num_buff_stacks ~= 0 then
                local stack_ids = buff.stack_ids
                for i = 1, #stack_ids, 1 do
                    local stack_ids = buff.stack_ids
                    local buff_id = table.remove(stack_ids, 1)

                    buff_extension:remove_buff(buff_id)
                end
            end
		end
	end
})

mod:add_talent_buff("wood_elf", "kerillian_waywatcher_passive_buff", {
    max_stacks = 10,
    icon = "kerillian_waywatcher_passive",
    duration = 15,
})