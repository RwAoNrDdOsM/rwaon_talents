local mod = get_mod("rwaon_talents")

local function merge(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

function mod:add_talent(career_name, tier, index, new_talent_name, new_talent_data)
    local career_settings = CareerSettings[career_name]
    local hero_name = career_settings.profile_name
    local talent_tree_index = career_settings.talent_tree_index
    
    local new_talent_index = #Talents[hero_name] + 1

    Talents[hero_name][new_talent_index] = merge({
        name = new_talent_name,
        description = new_talent_name .. "_desc",
        icon = "icons_placeholder",
        num_ranks = 1,
        requirements = {},
        description_values = {},
        buffs = {},
        buff_data = {},
    }, new_talent_data)

    TalentTrees[hero_name][talent_tree_index][tier][index] = new_talent_name

    TalentIDLookup[new_talent_name] = new_talent_index
end

function mod:add_talent_buff(hero_name, buff_name, buff_data)
    local talent_buff = {
        buffs = {
            merge({ name = buff_name }, buff_data),
        },
    }
    TalentBuffTemplates[hero_name][buff_name] = talent_buff
    BuffTemplates[buff_name] = talent_buff
end

function mod:add_buff(buff_name, buff_data)
    local new_buff = {
        buffs = {
            merge({ name = buff_name }, buff_data),
        },
    }
    BuffTemplates[buff_name] = new_buff
end

function mod:add_buff_function(name, func)
    BuffFunctionTemplates.functions[name] = func
end

function add_weapon_value(action_no, action_from, value, new_data)
    action_no[action_from][value] = new_data
end

-- Replace Localize
local vmf = get_mod("VMF")
mod:hook("Localize", function(func, text_id)
    local str = vmf.quick_localize(mod, text_id)
    if str then return str end
    return func(text_id)
end)

-- Talents
mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/talents/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/talents/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/talents/witch_hunter")
mod:dofile("scripts/mods/rwaon_talents/talents/dwarf_ranger")

-- Ultimates
mod:dofile("scripts/mods/rwaon_talents/ults/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/ults/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/ults/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/ults/witch_hunter")
--mod:dofile("scripts/mods/rwaon_talents/ults/dwarf_ranger")

-- Weapons
--mod:dofile("scripts/mods/rwaon_talents/weapons/1h_falchions")
--mod:dofile("scripts/mods/rwaon_talents/weapons/1h_axes")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_blast_beam")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_spark_spear")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_fireball_fireball")
mod:dofile("scripts/mods/rwaon_talents/weapons/staff_fireball_geiser")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_flamethrower")


-- Traits
--mod:dofile("scripts/mods/rwaon_talents/traits/barrage")

-- Hook into the heal function.
--mod:hook_origin(ProcFunctions, "heal", nil)
--local orig = BuffTemplates.bloodlust.buffs[1].buff_func
--BuffTemplates.bloodlust.buffs[1].buff_func = function(player, buff, params)
--    local mod = get_mod("rwaon_talents")
--    if mod then
--        return mod.bloodlust(player, buff, params)
--    else
--        return orig(player, buff, params)
--    end
--end


--[[ DEBUG DEBUG DEBUG ]]--

-- Set all characters to max level.
mod:hook(BackendInterfaceHeroAttributesPlayFab, "get", function (func, self, hero_name, attribute_name)
    if attribute_name == "experience" then
        return 99999999999
    end
    return func(self, hero_name, attribute_name)
end)

-- Unlock all careers.
mod:hook(Development, "parameter", function(func, key, ...)
    if key == "unlock_all_careers" then return true end
    return func(key, ...)
end)

-- Do NOT unlock achievements.
mod:hook(Achievement, "unlock", function(func, ...)
    return
end)

ExplosionTemplates.cascading_firecloak = {
    explosion = {
        radius = 6,
        dot_template_name = "burning_3W_dot",
        max_damage_radius = 6,
        alert_enemies = false,
        damage_type_glance = "fire_grenade_glance",
        alert_enemies_radius = 10,
        attack_template = "fire_grenade_explosion",
        sound_event_name = "fireball_big_hit",
        always_hurt_players = false,
        damage_type = "fire_grenade",
        damage_profile = "explosive_barrel",
        effect_name = "fx/wpnfx_fire_grenade_impact",
        power_level_glance = 250,
        power_level = 500,
    },
    aoe = {
        dot_template_name = "burning_1W_dot",
        radius = 6,
        nav_tag_volume_layer = "fire_grenade",
        create_nav_tag_volume = true,
        attack_template = "fire_grenade_dot",
        sound_event_name = "player_combat_weapon_fire_grenade_explosion",
        damage_interval = 1,
        duration = 5,
        area_damage_template = "explosion_template_aoe",
        nav_mesh_effect = {
            particle_radius = 2,
            particle_name = "fx/wpnfx_fire_grenade_impact_remains",
            particle_spacing = 0.9
        }
    }
}

NetworkLookup.explosion_templates.cascading_firecloak = { 
    explosion = {
        radius = 3,
        dot_template_name = "burning_3W_dot",
        max_damage_radius = 3,
        alert_enemies = false,
        damage_type_glance = "fire_grenade_glance",
        alert_enemies_radius = 10,
        attack_template = "fire_grenade_explosion",
        sound_event_name = "fireball_big_hit",
        always_hurt_players = false,
        damage_type = "fire_grenade",
        damage_profile = "explosive_barrel",
        effect_name = "fx/wpnfx_fire_grenade_impact",
        power_level_glance = 250,
        power_level = 500,
    },
    aoe = {
        dot_template_name = "burning_1W_dot",
        radius = 6,
        nav_tag_volume_layer = "fire_grenade",
        create_nav_tag_volume = true,
        attack_template = "fire_grenade_dot",
        sound_event_name = "player_combat_weapon_fire_grenade_explosion",
        damage_interval = 1,
        duration = 5,
        area_damage_template = "explosion_template_aoe",
        nav_mesh_effect = {
            particle_radius = 2,
            particle_name = "fx/wpnfx_fire_grenade_impact_remains",
            particle_spacing = 0.9
        }
    }
}

mod.explode = function()
    local owner_unit = Managers.player:local_player().player_unit
    local position = Unit.local_position(owner_unit, 0)
    local rotation = Unit.local_rotation(owner_unit, 0)
    local explosion_template = "cascading_firecloak"
    local scale = 1
    local area_damage_system = Managers.state.entity:system("area_damage_system")
    
	area_damage_system:create_explosion(owner_unit, position, rotation, explosion_template, scale, "career_ability", false, false)
end

mod:command("explode", mod:localize("explode_desc"), function() UPDATE_POSITION_LOOKUP() mod.explode()  end)


local unit_alive = Unit.alive
mod:hook_origin(AreaDamageSystem, "_damage_unit", function(self, aoe_damage_data)
	local hit_unit = aoe_damage_data.hit_unit
	local attacker_unit = aoe_damage_data.attacker_unit
	local impact_position = aoe_damage_data.impact_position:unbox()
	local shield_blocked = aoe_damage_data.shield_blocked
	local do_damage = aoe_damage_data.do_damage
	local hit_zone_name = aoe_damage_data.hit_zone_name
	local damage_source = aoe_damage_data.damage_source
	local hit_distance = aoe_damage_data.hit_distance
	local push_speed = aoe_damage_data.push_speed
	local radius = aoe_damage_data.radius
	local max_damage_radius = aoe_damage_data.max_damage_radius
	local radius_min = aoe_damage_data.radius_min
	local radius_max = aoe_damage_data.radius_max
	local full_power_level = aoe_damage_data.full_power_level
	local actual_power_level = aoe_damage_data.actual_power_level
	local hit_direction = aoe_damage_data.hit_direction:unbox()
    local explosion_template_name = aoe_damage_data.explosion_template_name or "cascading_firecloak"
	local is_critical_strike = aoe_damage_data.is_critical_strike
	local allow_critical_proc = aoe_damage_data.allow_critical_proc
	local hit_unit_alive = unit_alive(hit_unit)

	if not hit_unit_alive then
		return
	end

	local attacker_unit_alive = unit_alive(attacker_unit)

	if not attacker_unit_alive then
		return
	end

	local explosion_template = ExplosionTemplates[explosion_template_name]
	local explosion_data = explosion_template.explosion
	local breed = AiUtils.unit_breed(hit_unit)
	local is_immune = breed and explosion_data.immune_breeds and (explosion_data.immune_breeds[breed.name] or explosion_data.immune_breeds.all)

	if shield_blocked then
		hit_distance = math.lerp(hit_distance, radius, 0.5)
	end

	local glancing_hit = max_damage_radius < hit_distance
	local attacker_player = Managers.player:owner(attacker_unit)
	local attacker_is_player = attacker_player ~= nil

	if attacker_is_player then
		local item_data = rawget(ItemMasterList, damage_source)

		if breed and item_data and not IGNORED_ITEM_TYPES_FOR_BUFFS[item_data.item_type] then
			local attack_type = "aoe"

			if item_data and item_data.item_type == "grenade" then
				attack_type = item_data.item_type
			end

			local send_to_server = false

			if attacker_player and attacker_player.remote then
				local peer_id = attacker_player.peer_id
				local attack_type_id = NetworkLookup.buff_attack_types.aoe
				local network_manager = Managers.state.network
				local attacker_unit_id = network_manager:unit_game_object_id(attacker_unit)
				local hit_unit_id = network_manager:unit_game_object_id(hit_unit)
				local hit_zone_id = NetworkLookup.hit_zones[hit_zone_name]
				local buff_weapon_type_id = NetworkLookup.buff_weapon_types["n/a"]

				RPC.rpc_buff_on_attack(peer_id, attacker_unit_id, hit_unit_id, attack_type_id, is_critical_strike and allow_critical_proc, hit_zone_id, 1, buff_weapon_type_id)
				DamageUtils.buff_on_attack(attacker_unit, hit_unit, attack_type, is_critical_strike and allow_critical_proc, hit_zone_name, 1, send_to_server, "n/a")
			elseif attacker_player then
				DamageUtils.buff_on_attack(attacker_unit, hit_unit, attack_type, is_critical_strike and allow_critical_proc, hit_zone_name, 1, send_to_server, "n/a")
			end

			if not explosion_template.no_aggro then
				AiUtils.aggro_unit_of_enemy(hit_unit, attacker_unit)
			end
		end
	end

	if not is_immune then
		local blocking = false
		local blackboard = BLACKBOARDS[hit_unit]

		if blackboard and radius < hit_distance and blackboard.shield_user then
			local stagger = blackboard.stagger
			blocking = not stagger or stagger < 1
		end

		local hit_ragdoll_actor = nil

		if not blocking and breed and breed.hitbox_ragdoll_translation then
			hit_ragdoll_actor = breed.hitbox_ragdoll_translation.j_spine or breed.hitbox_ragdoll_translation.j_spine1
		end

		local damage_profile_name = (glancing_hit and explosion_data.damage_profile_glance) or explosion_data.damage_profile or "default"

		if not do_damage or is_immune then
			damage_profile_name = damage_profile_name .. "_no_damage"
		end

		local t = Managers.time:time("game")
		local damage_profile = DamageProfileTemplates[damage_profile_name]
		local target_index = nil
		local boost_curve_multiplier = 0
		local shield_break_procc = false
		local is_critical_strike = false
		local backstab_multiplier = 1

		DamageUtils.add_damage_network_player(damage_profile, target_index, actual_power_level, hit_unit, attacker_unit, hit_zone_name, impact_position, hit_direction, damage_source, hit_ragdoll_actor, boost_curve_multiplier, is_critical_strike, backstab_multiplier)

		local target_alive = AiUtils.unit_alive(hit_unit)

		if target_alive then
			DamageUtils.stagger_ai(t, damage_profile, target_index, actual_power_level, hit_unit, attacker_unit, hit_zone_name, hit_direction, boost_curve_multiplier, is_critical_strike, shield_blocked, damage_source)
		elseif explosion_data.on_death_func then
			explosion_data.on_death_func(hit_unit)
		end

		DamageUtils.apply_dot(damage_profile, target_index, full_power_level, hit_unit, attacker_unit, hit_zone_name, damage_source, boost_curve_multiplier, is_critical_strike)

		if push_speed and DamageUtils.is_player_unit(hit_unit) then
			local status_extension = ScriptUnit.extension(hit_unit, "status_system")

			if not status_extension:is_disabled() then
				local locomotion_system = ScriptUnit.extension(hit_unit, "locomotion_system")

				locomotion_system:add_external_velocity(hit_direction * push_speed)
			end
		end
	end
end)