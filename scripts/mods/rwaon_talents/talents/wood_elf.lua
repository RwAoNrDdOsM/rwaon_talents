local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

mod:add_talent("we_maidenguard", 5, 1, "rwaon_kerillian_double_dash", {
	description_values = {
		{value = 5},
	},
    buffer = "server",
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