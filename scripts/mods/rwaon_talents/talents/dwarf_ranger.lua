local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

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
	icon = "victor_zealot_passive_invulnerability",
	delayed_buff_name = "rwaon_bardin_ironbreaker_gain_movespeed_on_charged_attacks"
})

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_gain_movespeed_on_charged_attacks", {
	max_stacks = 1,
	event_buff = true,
	event = "on_hit",
	icon = "victor_zealot_passive_invulnerability",
	buff_func = function (player, buff, params)
		local player_unit = player.player_unit
		local hit_unit = params[1]
		local attack_type = params[2]
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		if attack_type ~= "heavy_attack" then
			return
		end

		if Unit.alive(player_unit) then
			buff_extension:add_buff("rwaon_bardin_ironbreaker_movespeed_on_charged_attacks", buff_params)
		end
		
		if Unit.alive(player_unit) then
			local buff_1 = buff_extension:add_buff("rwaon_bardin_ironbreaker_gain_movespeed_on_charged_attacks", {attacker_unit = player_unit})

			if buff_extension:has_buff_type("rwaon_bardin_ironbreaker_gain_movespeed_on_charged_attacks") then
				buff_extension:remove_buff(buff_1)
			end
		end
	end,			
})

mod:add_talent_buff("dwarf_ranger", "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks", {
	max_stacks = 1,
	icon = "victor_zealot_passive_invulnerability",
	apply_buff_func = "apply_movement_buff",
    multiplier = 1.25, -- 1.5
    refresh_durations = false,
    remove_buff_func = "remove_movement_buff",
    duration = 5,
    path_to_movement_setting_to_modify = {
        "move_speed"
	},
	buff_after_delay = true,
	delayed_buff_name = "rwaon_bardin_ironbreaker_movespeed_on_charged_attacks_cooldown",
})
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