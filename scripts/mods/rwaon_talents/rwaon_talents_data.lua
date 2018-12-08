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
                setting_id = "flamestorm_weapon_switch",
                type = "checkbox",
                title = mod:localize("flamestorm_weapon_switch_option_name"),
                tooltip = mod:localize("flamestorm_weapon_switch_option_tooltip"),
                default_value = false,
			},
		},
	}, 
}
