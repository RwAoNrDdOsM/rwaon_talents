local mod = get_mod("rwaon_talents")

PassiveAbilitySettings.rwaon_we_3 = {
    description = "career_passive_desc_we_3a_2",
    display_name = "career_passive_name_we_3",
    icon = "kerillian_waywatcher_passive",
    buffs = {
        "kerillian_waywatcher_passive",
        "kerillian_waywatcher_passive_no_damage_dropoff",
        "kerillian_waywatcher_passive_increased_ammunition",
        "kerillian_waywatcher_passive_increased_zoom",
        --"kerillian_waywatcher_ability_cooldown_on_hit",
        --"kerillian_waywatcher_ability_cooldown_on_damage_taken"
    },
    perks = {
        {
            display_name = "career_passive_name_we_3b",
            description = "career_passive_desc_we_3b_2"
        },
        {
            display_name = "career_passive_name_we_3c",
            description = "career_passive_desc_we_3c"
        },
        {
            display_name = "career_passive_name_we_3d",
            description = "career_passive_desc_we_3d_2"
        }
    }
}
CareerSettings.we_waywatcher.passive_ability = PassiveAbilitySettings.rwaon_we_3