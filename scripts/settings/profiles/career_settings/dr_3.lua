local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_dr_3 = {
    description = "career_passive_desc_dr_3a_2",
    display_name = "career_passive_name_dr_3",
    icon = "bardin_ranger_passive",
    buffs = {
        "bardin_ranger_passive",
        "bardin_ranger_passive_increased_ammunition",
        "bardin_ranger_passive_reload_speed",
        "bardin_ranger_passive_consumeable_dupe_healing",
        "bardin_ranger_passive_consumeable_dupe_potion",
        "bardin_ranger_passive_consumeable_dupe_grenade",
        --"bardin_ranger_ability_cooldown_on_hit",
        --"bardin_ranger_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_dr_3b",
            description = "career_passive_desc_dr_3b_2"
        },
        {
            display_name = "career_passive_name_dr_3c",
            description = "career_passive_desc_dr_3c_2"
        },
        {
            display_name = "career_passive_name_dr_3d",
            description = "career_passive_desc_dr_3d"
        }
    }
}
CareerSettings.dr_ranger.passive_ability = PassiveAbilitySettings.rwaon_dr_3