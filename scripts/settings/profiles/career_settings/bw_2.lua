local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_bw_2 = {
    description = "career_passive_desc_bw_2a_2",
    display_name = "career_passive_name_bw_2",
    icon = "sienna_adept_passive",
    buffs = {
        "sienna_adept_passive",
        "sienna_adept_passive_reset_on_spell_used",
        "sienna_adept_passive_overcharge_charge_speed_increased",
        "sienna_adept_passive_ranged_damage",
        --"sienna_adept_ability_cooldown_on_hit",
        --"sienna_adept_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_bw_2b",
            description = "career_passive_desc_bw_2b_2"
        },
        {
            display_name = "career_passive_name_bw_2c",
            description = "career_passive_desc_bw_2c_2"
        }
    }
}

CareerSettings.bw_scholar.passive_ability = PassiveAbilitySettings.rwaon_bw_2
