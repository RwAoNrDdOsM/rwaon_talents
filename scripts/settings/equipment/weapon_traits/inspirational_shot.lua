
WeaponTraits.traits.ranged_restore_stamina_headshot = {
    display_name = "traits_ranged_restore_stamina_headshot",
    buffer = "both",
    advanced_description = "description_traits_ranged_restore_stamina_headshot",
    icon = "ranged_restore_stamina_headshot",
    buff_name = "traits_ranged_restore_stamina_headshot",
    description_values = {
        {
            value = 5
        },
    }
}

WeaponTraits.buff_templates.traits_ranged_restore_stamina_headshot = {
    buffs = {
        {
            event = "on_hit",
            dormant = true,
            event_buff = true,
            heal_amount = 5,
            buff_func = function (player, buff, params)
                local player_unit = player.player_unit
                local attack_type = params[2]
                local hit_zone_name = params[3]
                local heal_amount = buff.heal_amount
                
                if Managers.state.network.is_server then
                    local health_extension = ScriptUnit.extension(unit, "health_system")
                    local status_extension = ScriptUnit.extension(unit, "status_system")
                    
                    if Unit.alive(player_unit) and hit_zone_name == "head" and (attack_type == "instant_projectile" or attack_type == "projectile") then
                        local player_and_bot_units = PLAYER_AND_BOT_UNITS

                        for i = 1, #player_and_bot_units, 1 do
                            if Unit.alive(player_and_bot_units[i]) then
                                local health_extension = ScriptUnit.extension(player_and_bot_units[i], "health_system")
                                local status_extension = ScriptUnit.extension(player_and_bot_units[i], "status_system")

                                if  not status_extension:is_knocked_down() and not status_extension:is_assisted_respawning() and health_extension:is_alive() then
                                    DamageUtils.heal_network(player_and_bot_units[i], unit, heal_amount, "career_passive")
                                end
                            end
                        end
                    end
                end
            end,
        }
    }
}