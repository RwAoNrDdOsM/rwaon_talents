local mod = get_mod("rwaon_talents")

mod:add_talent_buff("wood_elf", "kerillian_shade_regrowth", {
    name = "regrowth",
	event_buff = true,
	event = "on_hit",
	perk = "ninja_healing",
	bonus = 2,
	buff_func = ProcFunctions.heal_finesse_damage_on_melee
})

mod:add_talent_buff("wood_elf", "kerillian_waywatcher_regrowth", {
    name = "regrowth",
	event_buff = true,
	event = "on_hit",
	perk = "ninja_healing",
	bonus = 2,
	buff_func = ProcFunctions.heal_finesse_damage_on_melee
})

mod:add_talent_buff("witch_hunter", "victor_bountyhunter_regrowth", {
    name = "regrowth",
	event_buff = true,
	event = "on_hit",
	perk = "ninja_healing",
	bonus = 2,
	buff_func = ProcFunctions.heal_finesse_damage_on_melee
})

mod:add_talent_buff("witch_hunter", "victor_witchhunter_regrowth", {
    name = "regrowth",
	event_buff = true,
	event = "on_hit",
	perk = "ninja_healing",
	bonus = 2,
	buff_func = ProcFunctions.heal_finesse_damage_on_melee
})