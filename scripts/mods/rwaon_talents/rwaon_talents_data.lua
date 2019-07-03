local mod = get_mod("rwaon_talents")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = false,
    is_mutator = false, 
    mutator_settings = {},
    options = {
        widgets = {
            {
                setting_id    = "modify_concoction",
                type          = "checkbox",
                default_value = false,
                sub_widgets   = {
                    {
                        setting_id    = "potions",
                        type          = "dropdown",
                        default_value = "potions_one",
                        options = {
                          {text = "potions_one_localization_id",   value = "potions_one", show_widgets = {}},
                          {text = "potions_two_localization_id",   value = "potions_two", show_widgets = {}},
                          {text = "potions_three_localization_id", value = "potions_three", show_widgets = {}},
                          {text = "potions_four_localization_id",   value = "speed", show_widgets = {}},
                          {text = "potions_five_localization_id",   value = "strength", show_widgets = {}},
                          {text = "potions_six_localization_id", value = "conc", show_widgets = {}},
                        },
                    },
                },
            },
        }
    }
}