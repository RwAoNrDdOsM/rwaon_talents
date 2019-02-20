local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_es_3 = {
    description = "career_passive_desc_es_3a",
    display_name = "career_passive_name_es_3",
    icon = "markus_mercenary_passive",
    buffs = {
        "markus_mercenary_passive",
        --"markus_mercenary_ability_cooldown_on_hit",
        --"markus_mercenary_ability_cooldown_on_damage_taken",
        "markus_mercenary_passive_hit_mass_override",
        "markus_mercenary_passive_crit_chance"
    },
    perks = {
        {
            display_name = "career_passive_name_es_3b",
            description = "career_passive_desc_es_3b"
        },
        {
            display_name = "career_passive_name_es_3c",
            description = "career_passive_desc_es_3c_2"
        }
    }
}
CareerSettings.es_mercenary.passive_ability = PassiveAbilitySettings.rwaon_es_3