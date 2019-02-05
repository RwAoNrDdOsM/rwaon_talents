local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_es_2 = {
    description = "career_passive_desc_es_2a_2",
    display_name = "career_passive_name_es_2",
    icon = "markus_knight_passive",
    buffs = {
        "markus_knight_passive",
        "markus_knight_passive_damage_reduction",
        "markus_knight_passive_increased_stamina",
        --"markus_knight_ability_cooldown_on_hit",
        --"markus_knight_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_es_2b",
            description = "career_passive_desc_es_2b_2"
        },
        {
            display_name = "career_passive_name_es_2c",
            description = "career_passive_desc_es_2c_2"
        }
    }
}
CareerSettings.es_knight.passive_ability = PassiveAbilitySettings.rwaon_es_2