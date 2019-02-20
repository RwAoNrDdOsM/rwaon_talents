local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_bw_3 = {
    description = "career_passive_desc_bw_3a",
    display_name = "career_passive_name_bw_3",
    icon = "sienna_unchained_passive",
    buffs = {
        "sienna_unchained_passive",
        "sienna_unchained_passive_increased_melee_power_on_overcharge",
        --"sienna_unchained_ability_cooldown_on_hit",
        --"sienna_unchained_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_bw_3b",
            description = "career_passive_desc_bw_3b"
        },
        {
            display_name = "career_passive_name_bw_3c",
            description = "career_passive_desc_bw_3c_2"
        }
    }
}
CareerSettings.bw_unchained.passive_ability = PassiveAbilitySettings.rwaon_bw_3