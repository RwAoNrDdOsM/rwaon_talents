local mod = get_mod("rwaon_talents")

mod:hook_origin(CareerExtension, "reduce_activated_ability_cooldown", function (self, amount)
	--[[if self._cooldown_paused then
		return
	end

    self._cooldown = self._cooldown - amount]]
end)