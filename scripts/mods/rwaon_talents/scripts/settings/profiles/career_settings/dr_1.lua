local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_dr_1 = {
    description = "career_passive_desc_dr_1a",
    display_name = "career_passive_name_dr_1",
    icon = "bardin_ironbreaker_gromril_armour",
    buffs = {
        "bardin_ironbreaker_gromril_armour",
        "bardin_ironbreaker_gromril_antistun",
        "bardin_ironbreaker_passive_increased_defence",
        "bardin_ironbreaker_passive_increased_stamina",
        "bardin_ironbreaker_passive_reduced_stun_duration",
        "bardin_ironbreaker_refresh_gromril_armour",
        --"bardin_ironbreaker_ability_cooldown_on_hit",
        --"bardin_ironbreaker_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_dr_1b",
            description = "career_passive_desc_dr_1b_2"
        },
        {
            display_name = "career_passive_name_dr_1c",
            description = "career_passive_desc_dr_1c_2"
        },
        {
            display_name = "career_passive_name_dr_1d",
            description = "career_passive_desc_dr_1d_2"
        }
    }
}
CareerSettings.dr_ironbreaker.passive_ability = PassiveAbilitySettings.rwaon_dr_1