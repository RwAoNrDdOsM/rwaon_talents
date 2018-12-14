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
--mod:dofile("scripts/mods/rwaon_talents/talents/dwarf_ranger")

-- Ultimates
--mod:dofile("scripts/mods/rwaon_talents/ults/bright_wizard")
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
    if key == "unlimited_ammo" then return true end
    return func(key, ...)
end)

-- Do NOT unlock achievements.
mod:hook(Achievement, "unlock", function(func, ...)
    return
end)

ExplosionTemplates.cascading_firecloak = {
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
    local explosion_template = ExplosionTemplates.cascading_firecloak
    local scale = 1
    local area_damage_system = Managers.state.entity:system("area_damage_system")
    
	area_damage_system:create_explosion(owner_unit, position, rotation, explosion_template, scale, "career_ability", false, false)
end

mod:command("explode", mod:localize("explode_desc"), function() mod.explode() end)