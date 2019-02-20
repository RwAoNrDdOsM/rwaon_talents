local mod = get_mod("rwaon_talents")

mod:hook_origin(PlayerUnitOverchargeExtension, "_check_overcharge_level_thresholds", function (self, new_overcharge_value)
    local buff_extension = self.buff_extension
    local max_value = self.max_value
    local overcharge_threshold = self.overcharge_threshold

    if max_value <= new_overcharge_value then
        local unit = self.unit

        StatusUtils.set_overcharge_exploding(unit, true)

        self.is_exploding = true
        local overcharged_critical_buff_id = self.overcharged_critical_buff_id

        if overcharged_critical_buff_id then
            buff_extension:remove_buff(overcharged_critical_buff_id)

            self.overcharged_critical_buff_id = nil
        end

        local overcharged_buff_id = self.overcharged_buff_id

        if overcharged_buff_id and self.overcharge_value < self.overcharge_limit then
            buff_extension:remove_buff(overcharged_buff_id)

            self.overcharged_buff_id = nil
        end
    elseif overcharge_threshold <= new_overcharge_value then
        if not self.above_threshold then
            self.above_threshold = true
            local wwise_world = Managers.world:wwise_world(self.world)

            WwiseWorld.trigger_event(wwise_world, self.hit_overcharge_threshold_sound)
            self:hud_sound(self.overcharge_warning_low_sound_event or "staff_overcharge_warning_low", self.first_person_extension)
        end

        local overcharge_limit = self.overcharge_limit
        local overcharge_critical_limit = self.overcharge_critical_limit

        if overcharge_critical_limit <= new_overcharge_value then
            if not self.overcharged_critical_buff_id then
                local overcharged_buff_id = self.overcharged_buff_id

                if overcharged_buff_id then
                    buff_extension:remove_buff(overcharged_buff_id)

                    self.overcharged_buff_id = false

                    self:hud_sound(self.overcharge_warning_high_sound_event or "staff_overcharge_warning_high", self.first_person_extension)
                end

                if buff_extension:has_buff_type("sienna_unchained_passive") then
                    self.overcharged_critical_buff_id = buff_extension:add_buff("overcharged_critical_no_attack_penalty")
                elseif  buff_extension:has_buff_type("rwaon_sienna_scholar_passive_increased_attack_speed_debuff") then
                    self.overcharged_critical_buff_id = buff_extension:add_buff("overcharged_critical_no_attack_penalty")
                else
                    self.overcharged_critical_buff_id = buff_extension:add_buff("overcharged_critical")
                end
            end

            local overcharge_rumble_overcharged_effect_id = self._overcharge_rumble_overcharged_effect_id

            if overcharge_rumble_overcharged_effect_id then
                Managers.state.controller_features:stop_effect(overcharge_rumble_overcharged_effect_id)

                self._overcharge_rumble_overcharged_effect_id = false
            end

            local overcharge_rumble_critical_effect_id = self._overcharge_rumble_critical_effect_id

            if overcharge_rumble_critical_effect_id then
                Managers.state.controller_features:stop_effect(overcharge_rumble_critical_effect_id)

                self._overcharge_rumble_critical_effect_id = false
            end

            self._overcharge_rumble_critical_effect_id = Managers.state.controller_features:add_effect("rumble", {
                rumble_effect = "overcharge_rumble_crit"
            })
        elseif overcharge_limit <= new_overcharge_value then
            local dialogue_input = ScriptUnit.extension_input(self.unit, "dialogue_system")
            local event_data = FrameTable.alloc_table()
            local event_name = "overcharge"

            dialogue_input:trigger_dialogue_event(event_name, event_data)

            if not self.overcharged_buff_id and not self.overcharged_critical_buff_id then
                self:hud_sound(self.overcharge_warning_med_sound_event or "staff_overcharge_warning_med", self.first_person_extension)

                if buff_extension:has_buff_type("sienna_unchained_passive") then
                    self.overcharged_buff_id = buff_extension:add_buff("overcharged_no_attack_penalty")
                elseif buff_extension:has_buff_type("rwaon_sienna_scholar_passive_increased_attack_speed_debuff") then
                    self.overcharged_buff_id = buff_extension:add_buff("overcharged_no_attack_penalty")
                else
                    self.overcharged_buff_id = buff_extension:add_buff("overcharged")
                end
            end

            local overcharge_rumble_effect_id = self._overcharge_rumble_effect_id

            if overcharge_rumble_effect_id then
                Managers.state.controller_features:stop_effect(overcharge_rumble_effect_id)

                self._overcharge_rumble_effect_id = false
            end

            local overcharge_rumble_overcharged_effect_id = self._overcharge_rumble_overcharged_effect_id

            if overcharge_rumble_overcharged_effect_id then
                Managers.state.controller_features:stop_effect(overcharge_rumble_overcharged_effect_id)

                self._overcharge_rumble_overcharged_effect_id = false
            end

            self._overcharge_rumble_overcharged_effect_id = Managers.state.controller_features:add_effect("rumble", {
                rumble_effect = "overcharge_rumble_overcharged"
            })
        else
            local overcharge_rumble_effect_id = self._overcharge_rumble_effect_id

            if overcharge_rumble_effect_id then
                Managers.state.controller_features:stop_effect(overcharge_rumble_effect_id)

                self._overcharge_rumble_effect_id = false
            end

            self._overcharge_rumble_effect_id = Managers.state.controller_features:add_effect("rumble", {
                rumble_effect = "overcharge_rumble"
            })
        end
    end
end)