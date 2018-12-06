local mod = get_mod("rwaon_talents")

WeaponTraits.traits.ranged_consecutive_hits_increase_power = {
    display_name = "traits_ranged_consecutive_hits_increase_power",
    buffer = "both",
    advanced_description = "new_description_traits_ranged_consecutive_hits_increase_power",
    icon = "ranged_consecutive_hits_increase_power",
    buff_name = "traits_ranged_consecutive_hits_increase_power",
    description_values = {
        {
            value_type = "percent",
            value = 0.05
        },
        {
            value_type = "duration",
            value = 2
        }
    }
}

WeaponTraits.buff_templates.consecutive_shot_buff = {
    buffs = {
        {
            duration = 2,
            multiplier = 0.05,
            max_stacks = 5,
            icon = "ranged_consecutive_hits_increase_power",
            refresh_durations = true,
            stat_buff = StatBuffIndex.POWER_LEVEL
        }
    }
}

ProcFunctions.buff_consecutive_shots_damage = function (player, buff, params)
    if not Managers.state.network.is_server then
        return
    end

    local player_unit = player.player_unit
    local buff_system = Managers.state.entity:system("buff_system")

    if Unit.alive(player_unit) then
        local buff_name = "consecutive_shot_buff"
        local talent_extension = ScriptUnit.extension(player_unit, "talent_system")

        buff_system:add_buff(player_unit, buff_name, player_unit, false)
    end
end