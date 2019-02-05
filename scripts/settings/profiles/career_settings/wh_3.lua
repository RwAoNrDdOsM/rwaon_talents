local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_wh_3 = {
    description = "career_passive_desc_wh_3a_2",
    display_name = "career_passive_name_wh_3",
    icon = "victor_witchhunter_passive",
    buffs = {
        "victor_witchhunter_passive",
        "victor_witchhunter_passive_block_cost_reduction",
        "victor_witchhunter_headshot_crit_killing_blow",
        "victor_witchhunter_headshot_multiplier_increase",
        --"victor_witchhunter_ability_cooldown_on_hit",
        --"victor_witchhunter_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_wh_3b",
            description = "career_passive_desc_wh_3b"
        },
        {
            display_name = "career_passive_name_wh_3c",
            description = "career_passive_desc_wh_3c"
        }
    }
},}
}
CareerSettings.wh_captain.passive_ability = PassiveAbilitySettings.rwaon_wh_3