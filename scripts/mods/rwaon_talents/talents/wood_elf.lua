local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:add_talent("we_maidenguard", 1, 3, "rwaon_kerillian_maidenguard_defence", {
	description_values = {
		{
			value_type = "percent",
			value = 0.1,
		}
	},
	icon = "kerillian_maidenguard_damage_reduction_on_last_standing",
	requirements = {},
	buffs = {
			"rwaon_kerillian_maidenguard_defence",
	},
	buff_data = {},
})

mod:add_talent_buff("wood_elf", "rwaon_kerillian_maidenguard_defence", {
	max_stacks = 1,
	multiplier = -0.1,
	stat_buff = StatBuffIndex.DAMAGE_TAKEN,
})

------------------------------------------------------------------------------

mod:add_talent("we_maidenguard", 2, 1, "kerillian_maidenguard_max_ammo", {
	description = "kerillian_maidenguard_max_ammo_desc",
	name = "kerillian_maidenguard_max_ammo",
	icon = "kerillian_maidenguard_max_ammo",
	description_values = {
		{
			value_type = "percent",
			value = 0.4,
		}
	},
	buffs = {
		"kerillian_maidenguard_max_ammo"
	},
})


mod:add_talent("we_maidenguard", 2, 3, "rwaon_kerillian_maidenguard_increased_attack_speed", {
	description_values = {
		{
			value_type = "percent",
			value = 0.1,
		}
	},
	requirements = {},
	buffs = {
			"rwaon_kerillian_maidenguard_increased_attack_speed",
	},
	buff_data = {},
})

mod:add_talent_buff("wood_elf", "rwaon_kerillian_maidenguard_increased_attack_speed", {
	multiplier = 0.1,
	stat_buff = StatBuffIndex.ATTACK_SPEED,
})

------------------------------------------------------------------------------

mod:add_talent("we_maidenguard", 5, 1, "rwaon_kerillian_maidenguard_ability_double_dash", {
	description_values = {
		{
			value_type = "percent",
			value = 0.25,
		},
		{
			value = 5
		},
	},
	buffer = "server",
	buffs = {
		"rwaon_kerillian_maidenguard_ability_anitcooldown"
	},
})

mod:add_talent_buff("wood_elf", "rwaon_kerillian_maidenguard_ability_double_dash", {
	duration = 5,
    max_stacks = 1,
	icon = "icons_placeholder",
	dormant = true,
	remove_buff_func = "rwaon_kerillian_maidenguard_start_ability_cooldown",
})

mod:add_buff_function("rwaon_kerillian_maidenguard_start_ability_cooldown", function (unit, buff, params) 
	local function is_local(unit)
		local player = Managers.player:owner(unit)
	
		return player and not player.remote
	end
	
	if is_local(unit) then
		local career_extension = ScriptUnit.extension(unit, "career_system")

		career_extension:stop_ability("cooldown_triggered")
		career_extension:start_activated_ability_cooldown()
	end
end)

mod:add_talent("we_maidenguard", 5, 3, "rwaon_kerillian_maidenguard_ability_stagger", {
	description_values = {
		{
			value_type = "percent",
			value = 0.25,
		},
	},
	buffer = "server",
	buffs = {
		"rwaon_kerillian_maidenguard_ability_anitcooldown"
	},
})

mod:add_talent_buff("wood_elf", "rwaon_kerillian_maidenguard_ability_anitcooldown", {
	multiplier = 0.25,
	stat_buff = StatBuffIndex.ACTIVATED_COOLDOWN,
})


------------------------------------------------------------------------------