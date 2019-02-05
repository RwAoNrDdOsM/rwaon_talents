local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_dr_2 = {
    description = "career_passive_desc_dr_2a_2",
    display_name = "career_passive_name_dr_2",
    icon = "bardin_slayer_passive",
    buffs = {
        "bardin_slayer_passive_attack_speed",
        "bardin_slayer_passive_stacking_damage_buff_on_hit",
        "bardin_slayer_ability_cooldown_on_damage_taken",
        "bardin_slayer_ability_cooldown_on_hit"
    },
    perks = {
        {
            display_name = "career_passive_name_dr_2b",
            description = "career_passive_desc_dr_2b_2"
        }
    }
}
CareerSettings.dr_slayer.passive_ability = PassiveAbilitySettings.rwaon_dr_2