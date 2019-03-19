local mod = get_mod("rwaon_talents")

WeaponTraits.traits.melee_shield_on_assist.name = "melee_shield_on_assist"
WeaponTraits.traits.melee_shield_on_assist.description_values = {
    {
        value = 5
    },
    {
        value_type = "percent",
        value = 0.5
    },
}

WeaponTraits.buff_templates.traits_melee_shield_on_assist = {
    buffs = {
        {
            event = "on_assisted_ally",
            event_buff = true,
            dormant = true,
            buff_name = "traits_melee_shield_on_assist_buff",
            buff_func = function (player, buff, params)
                local player_unit = player.player_unit
                local assisted_unit = params[1]
                local template = buff.template
                local buff_name = template.buff_name
                local buff_template_name_id = NetworkLookup.buff_templates[buff_name]
                local network_manager = Managers.state.network
                local network_transmit = network_manager.network_transmit

                if Unit.alive(player_unit) and Managers.player.is_server then
                    local unit_object_id = network_manager:unit_game_object_id(player_unit)
                    
                    if Managers.player.is_server then
                        buff_extension:add_buff(buff_name, {
                            attacker_unit = player_unit
                        })
                        network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, false)
                    else
                        network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, true)
                    end

                    if Unit.alive(assisted_unit) then
                        local unit_object_id = network_manager:unit_game_object_id(assisted_unit)

                        if Managers.player.is_server then
                            buff_extension:add_buff(buff_name, {
                                attacker_unit = assisted_unit
                            })
                            network_transmit:send_rpc_clients("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, false)
                        else
                            network_transmit:send_rpc_server("rpc_add_buff", unit_object_id, buff_template_name_id, unit_object_id, 0, true)
                        end

                    end
                end
            end
        }
    }
}

mod:add_buff("traits_melee_shield_on_assist_buff", {
    max_stacks = 1,
    icon = "icons_placeholder",
    --icon = "melee_shield_on_assist",
	multiplier = -0.5,
	stat_buff = "damage_taken",
    duration = 5,
})