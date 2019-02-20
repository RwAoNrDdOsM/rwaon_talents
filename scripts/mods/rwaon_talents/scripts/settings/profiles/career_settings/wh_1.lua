local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_wh_1 = {
    description = "career_passive_desc_wh_1a",
    display_name = "career_passive_name_wh_1",
    icon = "victor_zealot_passive",
    buffs = {
        "victor_zealot_passive_increased_damage",
        "victor_zealot_passive_uninterruptible_heavy",
        "victor_zealot_invulnerability_cooldown",
        --"victor_zealot_ability_cooldown_on_hit",
        --"victor_zealot_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_wh_1b",
            description = "career_passive_desc_wh_1b"
        },
        {
            display_name = "career_passive_name_wh_1c",
            description = "career_passive_desc_wh_1c"
        }
    }
}
CareerSettings.wh_zealot.passive_ability = PassiveAbilitySettings.rwaon_wh_1