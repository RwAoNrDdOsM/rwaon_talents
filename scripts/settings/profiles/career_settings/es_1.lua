local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_es_1 = {
    description = "career_passive_desc_es_1a",
    display_name = "career_passive_name_es_1",
    icon = "markus_huntsman_passive",
    buffs = {
        "markus_huntsman_passive",
        "markus_huntsman_passive_increased_ammunition",
        "markus_huntsman_passive_no_damage_dropoff",
        "markus_huntsman_passive_crit_aura",
        --"markus_huntsman_ability_cooldown_on_hit",
        --"markus_huntsman_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_es_1b",
            description = "career_passive_desc_es_1b"
        },
        {
            display_name = "career_passive_name_es_1c",
            description = "career_passive_desc_es_1c_2"
        },
        {
            display_name = "career_passive_name_es_1d",
            description = "career_passive_desc_es_1d"
        }
    }
}
CareerSettings.es_huntsman.passive_ability = PassiveAbilitySettings.rwaon_es_1