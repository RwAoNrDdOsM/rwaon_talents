local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_bw_2 = {
    description = "career_passive_desc_bw_1a_2",
    display_name = "career_passive_name_bw_1",
    icon = "sienna_scholar_passive",
    buffs = {
        "sienna_scholar_passive",
        "sienna_scholar_passive_ranged_damage",
        --"sienna_scholar_ability_cooldown_on_hit",
        --"sienna_scholar_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_bw_1b",
            description = "career_passive_desc_bw_1b_2"
        }
    }
}

CareerSettings.bw_scholar.passive_ability = PassiveAbilitySettings.rwaon_bw_2
