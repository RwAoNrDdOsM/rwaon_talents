local mod = get_mod("rwaon_talents")

mod:add_talent_buff("wood_elf", "kerillian_maidenguard_passive_stamina_regen_aura", {
    range = 10,
    buff_to_add = "kerillian_maidenguard_passive_stamina_regen_buff",
    update_func = "activate_buff_on_distance",
})

mod:add_talent_buff("wood_elf", "kerillian_maidenguard_passive_stamina_regen_buff", {
    max_stacks = 1,
	icon = "kerillian_maidenguard_passive",
    stat_buff = "fatigue_regen",
    multiplier = 0.5,
})

PassiveAbilitySettings.rwaon_we_2 = {
	description = "career_passive_desc_we_2a_2",
	display_name = "career_passive_name_we_2",
	icon = "kerillian_maidenguard_passive",
	buffs = {
		"kerillian_maidenguard_passive_dodge",
		"kerillian_maidenguard_passive_dodge_speed",
		"kerillian_maidenguard_passive_stamina_regen_aura",
		"kerillian_maidenguard_passive_increased_stamina",
		"kerillian_maidenguard_passive_uninterruptible_revive",
		--"kerillian_maidenguard_ability_cooldown_on_hit",
		--"kerillian_maidenguard_ability_cooldown_on_damage_taken"
	},
	perks = {
		{
			display_name = "career_passive_name_we_2b",
			description = "career_passive_desc_we_2b_2"
		},
		{
			display_name = "career_passive_name_we_2c",
			description = "career_passive_desc_we_2c"
		}
	}
}

CareerSettings.we_maidenguard.passive_ability = PassiveAbilitySettings.rwaon_we_2

------------------------------------------------------------------------------

ActivatedAbilitySettings.rwaon_we_2 = {
	description = "career_active_desc_we_2",
	display_name = "career_active_name_we_2",
	cooldown = 40,
	icon = "kerillian_maidenguard_activated_ability",
	ability_class = CareerAbilityWEMaidenGuard
}

CareerSettings.we_maidenguard.activated_ability = ActivatedAbilitySettings.rwaon_we_2