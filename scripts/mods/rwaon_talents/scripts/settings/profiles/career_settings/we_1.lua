local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_we_1 = {
    description = "career_passive_desc_we_1a",
    display_name = "career_passive_name_we_1",
    icon = "kerillian_shade_passive",
    buffs = {
        "kerillian_shade_passive",
        "kerillian_shade_passive_backstab_killing_blow",
        "kerillian_shade_end_activated_ability",
        --"kerillian_shade_ability_cooldown_on_hit",
        --"kerillian_shade_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_we_1b",
            description = "career_passive_desc_we_1b"
        }
    }
}
CareerSettings.we_shade.passive_ability = PassiveAbilitySettings.rwaon_we_1