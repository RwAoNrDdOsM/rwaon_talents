local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_wh_2 = {
    description = "career_passive_desc_wh_2a_2",
    display_name = "career_passive_name_wh_2",
    icon = "victor_bountyhunter_passive",
    buffs = {
        "victor_bountyhunter_passive_crit_buff",
        "victor_bountyhunter_passive_crit_buff_removal",
        "victor_bountyhunter_passive_reload_speed",
        "victor_bountyhunter_passive_increased_ammunition",
        --"victor_bountyhunter_ability_cooldown_on_hit",
        --"victor_bountyhunter_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_wh_2b",
            description = "career_passive_desc_wh_2b_2"
        },
        {
            display_name = "career_passive_name_wh_2c",
            description = "career_passive_desc_wh_2c_2"
        }
    }
}
CareerSettings.wh_bountyhunter.passive_ability = PassiveAbilitySettings.rwaon_wh_2