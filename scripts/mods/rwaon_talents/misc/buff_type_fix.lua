local mod = get_mod("rwaon_talents")

mod:hook_origin(PlayerProjectileHuskExtension, "hit_enemy", function (self, impact_data, hit_unit, hit_position, hit_direction, hit_normal, hit_actor, breed, hit_units, ranged_boost_curve_multiplier)
	if hit_actor == nil then
		return
	end

	if self:hit_afro(breed, hit_actor) then
		return
	end

	local owner_unit = self.owner_unit
	local damage_profile_name = impact_data.damage_profile or "default"
	local damage_profile = DamageProfileTemplates[damage_profile_name]
	local allow_link = true
	local aoe_data = impact_data.aoe

	if damage_profile then
		local node = Actor.node(hit_actor)
		local hit_zone = breed.hit_zones_lookup[node]
		local hit_zone_name = hit_zone.name
		local send_to_server = false
		local charge_value = damage_profile.charge_value or "projectile"
		local is_critical_strike = self._is_critical_strike
		local owner_unit = self.owner_unit
        local num_targets_hit = self.num_targets_hit + 1
        local damage_source = self.item_name
        local item_data = rawget(ItemMasterList, damage_source)
		local weapon_template_name = (item_data and item_data.template) or item_data.temporary_template
		local buff_type = "n/a"

		if weapon_template_name then
			local weapon_template = Weapons[weapon_template_name]
			buff_type = weapon_template.buff_type
        end				
        

		DamageUtils.buff_on_attack(owner_unit, hit_unit, charge_value, is_critical_strike, hit_zone_name, num_targets_hit, send_to_server, buff_type)

		allow_link = self:hit_enemy_damage(damage_profile, hit_unit, hit_position, hit_direction, hit_normal, hit_actor, breed, ranged_boost_curve_multiplier, hit_units)
	end

	local grenade = impact_data.grenade

	if grenade or (aoe_data and self.max_mass <= self.amount_of_mass_hit) then
		self:do_aoe(aoe_data, hit_position)
		self:stop()
	end

	local current_action = self.current_action

	if current_action.use_max_targets then
		if current_action.max_targets <= self.num_targets_hit then
			if impact_data.link and allow_link then
				self:link_projectile(hit_unit, hit_position, hit_direction, hit_normal, hit_actor, self.did_damage)
			end

			self:stop()
		end
	elseif self.max_mass <= self.amount_of_mass_hit then
		if impact_data.link and allow_link then
			self:link_projectile(hit_unit, hit_position, hit_direction, hit_normal, hit_actor, self.did_damage)
		end

		self:stop()
	end
end)

mod:hook_origin(PlayerProjectileUnitExtension, "hit_enemy", function (self, impact_data, hit_unit, hit_position, hit_direction, hit_normal, hit_actor, breed, has_ranged_boost, ranged_boost_curve_multiplier)
	local owner_unit = self.owner_unit
	local shield_blocked = false
	local damage_profile_name = impact_data.damage_profile or "default"
	local damage_profile = DamageProfileTemplates[damage_profile_name]
	local allow_link = true
	local aoe_data = impact_data.aoe

	if damage_profile then
		local node = Actor.node(hit_actor)
		local hit_zone = breed.hit_zones_lookup[node]
		local hit_zone_name = hit_zone.name
		local send_to_server = true
		local charge_value = damage_profile.charge_value or "projectile"
		local is_critical_strike = self._is_critical_strike
		local owner_unit = self.owner_unit
        local num_targets_hit = self.num_targets_hit + 1
        local damage_source = self.item_name
        local item_data = rawget(ItemMasterList, damage_source)
		local weapon_template_name = (item_data and item_data.template) or item_data.temporary_templat
        local buff_type = "n/a"

		if weapon_template_name then
			local weapon_template = Weapons[weapon_template_name]
			buff_type = weapon_template.buff_type
		end				

		DamageUtils.buff_on_attack(owner_unit, hit_unit, charge_value, is_critical_strike, hit_zone_name, num_targets_hit, send_to_server, buff_type)

		allow_link, shield_blocked = self:hit_enemy_damage(damage_profile, hit_unit, hit_position, hit_direction, hit_normal, hit_actor, breed, has_ranged_boost, ranged_boost_curve_multiplier)
	end

	local grenade = impact_data.grenade

	if grenade or (aoe_data and self.max_mass <= self.amount_of_mass_hit) then
		self:do_aoe(aoe_data, hit_position)
		self:stop()
	end

	local current_action = self.current_action

	if current_action.use_max_targets then
		if current_action.max_targets <= self.num_targets_hit then
			if impact_data.link and allow_link then
				self:link_projectile(hit_unit, hit_position, hit_direction, hit_normal, hit_actor, self.did_damage, shield_blocked)
			end

			self:stop()
		end
	elseif self.max_mass <= self.amount_of_mass_hit then
		if impact_data.link and allow_link then
			self:link_projectile(hit_unit, hit_position, hit_direction, hit_normal, hit_actor, self.did_damage, shield_blocked)
		end

		self:stop()
	end

	if self.locomotion_extension.notify_hit_enemy then
		self.locomotion_extension:notify_hit_enemy(hit_unit)
	end

	self:_check_projectile_spawn(impact_data, hit_unit, hit_position, hit_direction, hit_normal, hit_actor)
end)