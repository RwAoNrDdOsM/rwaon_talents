local mod = get_mod("rwaon_talents")

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
		local taunt_target = not ai_breed.ignore_taunts and not ai_breed.boss

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