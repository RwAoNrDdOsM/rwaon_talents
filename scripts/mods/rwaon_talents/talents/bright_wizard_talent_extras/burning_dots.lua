local mod = get_mod("rwaon_talents")

------------------------------------------------------------------------------

-- Double Duration Burn Dots
DoubleBurnDotLookup = {
	sienna_adept_ability_trail = "sienna_adept_ability_trail_double",
	burning_dot = "burning_dot_double",
	burning_1W_dot = "burning_1W_dot_double",
	burning_flamethrower_dot = "burning_flamethrower_dot_double",
	burning_3W_dot = "burning_3W_dot_double",
    beam_burning_dot = "beam_burning_dot_double",
    burning_geiser_dot = "burning_geiser_dot_double"
}

mod:add_buff("burning_dot_double", {
    duration = 6,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 0.1,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage"
})
mod:add_buff("burning_geiser_dot_double", {
    duration = 10,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1,
    damage_type = "burninating",
    damage_profile = "burning_geiser_dot",
    update_func = "apply_dot_damage"
})
mod:add_buff("beam_burning_dot_double", {
    duration = 4.5,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1,
    damage_type = "burninating",
    damage_profile = "beam_burning_dot",
    update_func = "apply_dot_damage",
})
mod:add_buff("burning_flamethrower_dot_double", {
    duration = 3,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    max_stacks = 1,
    refresh_durations = true,
    time_between_dot_damages = 0.65,
    damage_type = "burninating",
    damage_profile = "flamethrower_burning_dot",
    update_func = "apply_dot_damage",
})
mod:add_buff("sienna_adept_ability_trail_double", {
    apply_buff_func = "start_dot_damage",
    name = "burning dot",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    end_flow_event = "smoke",
    time_between_dot_damages = 0.125,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage"
})
mod:add_buff("burning_1W_dot_double", {
    duration = 4,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1.5,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage"
})
mod:add_buff("burning_3W_dot_double", {
    duration = 6,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1.25,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage"
})

-- Armour Burn Dots

ArmourBurnDotLookup = {
	sienna_adept_ability_trail = "sienna_adept_ability_trail_armour",
	burning_dot = "burning_dot_armour",
	burning_1W_dot = "burning_1W_dot_armour",
	burning_flamethrower_dot = "burning_flamethrower_dot_armour",
	burning_3W_dot = "burning_3W_dot_armour",
    beam_burning_dot = "beam_burning_dot_armour",
    burning_geiser_dot = "burning_geiser_dot_armour"
}

mod:add_buff("burning_dot_armour", {
    duration = 3,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 0.1,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})
mod:add_buff("burning_geiser_dot_armour", {
    duration = 5,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1,
    damage_type = "burninating",
    damage_profile = "burning_geiser_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})
mod:add_buff("beam_burning_dot_armour", {
    duration = 2.25,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1,
    damage_type = "burninating",
    damage_profile = "beam_burning_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})
mod:add_buff("burning_flamethrower_dot_armour", {
    duration = 1.5,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    max_stacks = 1,
    refresh_durations = true,
    time_between_dot_damages = 0.65,
    damage_type = "burninating",
    damage_profile = "flamethrower_burning_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})
mod:add_buff("sienna_adept_ability_trail_armour", {
    apply_buff_func = "start_dot_damage",
    name = "burning dot",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    end_flow_event = "smoke",
    time_between_dot_damages = 0.25,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})
mod:add_buff("burning_1W_dot_armour", {
    duration = 2,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1.5,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})
mod:add_buff("burning_3W_dot_armour", {
    duration = 3,
    name = "burning dot",
    end_flow_event = "smoke",
    start_flow_event = "burn",
    death_flow_event = "burn_death",
    remove_buff_func = "remove_dot_damage",
    apply_buff_func = "start_dot_damage",
    time_between_dot_damages = 1.25,
    damage_type = "burninating",
    damage_profile = "burning_dot",
    update_func = "apply_dot_damage",
    hit_zone = "head",
})


------------------------------------------------------------------------------

-- Activating new burn dots if have Boiling Blood
local buff_params = {}
local function add_dot(dot_template_name, hit_unit, attacker_unit, damage_source, power_level)
	if ScriptUnit.has_extension(hit_unit, "buff_system") then
		table.clear(buff_params)

		buff_params.attacker_unit = attacker_unit
		buff_params.damage_source = damage_source
		buff_params.power_level = power_level
		local buff_extension = ScriptUnit.extension(hit_unit, "buff_system")

		buff_extension:add_buff(dot_template_name, buff_params)
	end
end

Dots.burning_dot = function (dot_template_name, damage_profile, target_index, power_level, target_unit, attacker_unit, hit_zone_name, damage_source, boost_curve_multiplier, is_critical_strike)
    if damage_profile then
        dot_template_name = dot_template_name or target_settings.dot_template_name or damage_profile.dot_template_name
    end

    if not dot_template_name then
        return false
    end

    local talent_extension = ScriptUnit.has_extension(attacker_unit, "talent_system")

    if talent_extension then
        local breed = AiUtils.unit_breed(target_unit)
        local infinite_burn_talent = talent_extension:has_talent("sienna_adept_infinite_burn", "bright_wizard")
        local double_dot_duration_talent = talent_extension:has_talent("rwaon_sienna_scholar_double_dot_duration", "bw_scholar")
        local armour_dot_duration_talent = talent_extension:has_talent("rwaon_sienna_scholar_armour_dot", "bw_scholar")

        if infinite_burn_talent and breed then
            dot_template_name = InfiniteBurnDotLookup[dot_template_name]
        end
        if double_dot_duration_talent and breed then
            dot_template_name = DoubleBurnDotLookup[dot_template_name]
        end
        if armour_dot_duration_talent and breed then
            dot_template_name = ArmourBurnDotLookup[dot_template_name]
        end
    end

    add_dot(dot_template_name, target_unit, attacker_unit, damage_source, power_level)

    return true
end        