local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------
--[[
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
        "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown",
    },
})

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown", {
	duration = 15,
	buff_after_delay = true,
	max_stacks = 1,
	refresh_durations = true,
	is_cooldown = true,
	icon = "icons_placeholder",
	delayed_buff_name = "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks",  
})

ProcFunctions.rwaon_bardin_ironbreaker_movespeed_on_charged_attacks = function (player, buff, params)
	local player_unit = player.player_unit
	local status_extension = ScriptUnit.extension(player_unit, "status_system")

	if Unit.alive(player_unit) and not status_extension:is_knocked_down() then
		local health_extension = ScriptUnit.extension(player_unit, "health_system")
		--local damage = params[2]
		local current_health = health_extension:current_health()
		--local killing_blow = current_health <= damage

		--if killing_blow then
			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

			buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_buff")

			if Managers.state.network.is_server then
				local heal_amount = current_health * -1 + 1

				DamageUtils.heal_network(player_unit, player_unit, heal_amount, "heal_from_proc")
			end

			--return true
		--end
	end
end

BuffFunctionTemplates.functions.rwaon_bardin_ironbreaker_movespeed_on_charged_attacks = function (unit, buff, params)
	local player_unit = unit
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

	if Unit.alive(player_unit) then
		buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks")
	end
end

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks", {
	remove_on_proc = true,
	max_stacks = 1,
	event_buff = true,
	event = "on_damage_taken",
	icon = "icons_placeholder",
	buff_func = ProcFunctions.rwaon_bardin_ironbreaker_movespeed_on_charged_attacks,
})

BuffFunctionTemplates.functions.add_rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown = function (unit, buff, params)
	local player_unit = unit
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

	if Unit.alive(player_unit) then
		buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown")
	end
end

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_buff", {
	duration = 5,
	multiplier = -1,
	remove_buff_func = "add_rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown",
	max_stacks = 1,
	icon = "icons_placeholder",
	priority_buff = true,
	stat_buff = StatBuffIndex.DAMAGE_TAKEN,
})]]

------------------------------------------------------------------------------

mod:add_talent("dr_ironbreaker", 5, 3, "rwaon_bardin_ironbreaker_uninterruptible_attacks", {
    num_ranks = 1,
})

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_uninterruptible_attacks", {
	max_stacks = 1,
	perk = "uninterruptible",
	refresh_durations = true,
	duration = 10,
	icon = "icons_placeholder",
})