local mod = get_mod("rwaon_talents")

local version = "Vermintide Mod Reworks - Alpha 03/01/19"
function mod:version(self)
	mod:echo(version)
end

mod:command("version", mod:localize("version_command_description"), function() mod.version() end)

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
    --local new_buff_index = #NetworkLookup.buff_templates[buff_name] + 1
    
    local talent_buff = {
        buffs = {
            merge({ name = buff_name }, buff_data),
        },
    }
    TalentBuffTemplates[hero_name][buff_name] = talent_buff
    BuffTemplates[buff_name] = talent_buff
    --NetworkLookup.buff_templates[buff_name] = new_buff_index
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

function change_chain_actions(action_no, action_from, row, new_data)
	local value = "allowed_chain_actions"
	action_no[action_from][value][row] = new_data
end

-- Replace Localize
local vmf = get_mod("VMF")
mod:hook("Localize", function(func, text_id)
    local str = vmf.quick_localize(mod, text_id)
    if str then return str end
    return func(text_id)
end)

function mod:unit_category(unit)
	-- Thanks Pixaal for this code
	local breed_categories = {}

    breed_categories["skaven_clan_rat"] = "normal"
    breed_categories["skaven_clan_rat_with_shield"] = "normal"
    breed_categories["skaven_dummy_clan_rat"] = "normal"
    breed_categories["skaven_slave"] = "normal"
    breed_categories["skaven_dummy_slave"] = "normal"
    breed_categories["chaos_marauder"] = "normal"
    breed_categories["chaos_marauder_with_shield"] = "normal"
    breed_categories["chaos_fanatic"] = "normal"
    breed_categories["critter_rat"] = "normal"
    breed_categories["critter_pig"] = "normal"

    breed_categories["skaven_gutter_runner"] = "special"
    breed_categories["skaven_pack_master"] = "special"
    breed_categories["skaven_ratling_gunner"] = "special"
    breed_categories["skaven_poison_wind_globadier"] = "special"
    breed_categories["chaos_vortex_sorcerer"] = "special"
    breed_categories["chaos_corruptor_sorcerer"] = "special"
    breed_categories["skaven_warpfire_thrower"] = "special"
    breed_categories["skaven_loot_rat"] = "special"
    breed_categories["chaos_tentacle"] = "special"
    breed_categories["chaos_tentacle_sorcerer"] = "special"
    breed_categories["chaos_plague_sorcerer"] = "special"
    breed_categories["chaos_plague_wave_spawner"] = "special"
    breed_categories["chaos_vortex"] = "special"
    breed_categories["chaos_dummy_sorcerer"] = "special"

    breed_categories["skaven_storm_vermin"] = "elite"
    breed_categories["skaven_storm_vermin_commander"] = "elite"
    breed_categories["skaven_storm_vermin_with_shield"] = "elite"
    breed_categories["skaven_plague_monk"] = "elite"
    breed_categories["chaos_berzerker"] = "elite"
    breed_categories["chaos_raider"] = "elite"
    breed_categories["chaos_warrior"] = "elite"
    
    breed_categories["skaven_rat_ogre"] = "boss"
    breed_categories["skaven_stormfiend"] = "boss"
    breed_categories["skaven_storm_vermin_warlord"] = "boss"
    breed_categories["skaven_stormfiend_boss"] = "boss"
    breed_categories["skaven_grey_seer"] = "boss"
    breed_categories["chaos_troll"] = "boss"
    breed_categories["chaos_dummy_troll"] = "boss"
    breed_categories["chaos_spawn"] = "boss"
    breed_categories["chaos_exalted_champion"] = "boss"
    breed_categories["chaos_exalted_champion_warcamp"] = "boss"
    breed_categories["chaos_exalted_sorcerer"] = "boss"

    local breed_data = Unit.get_data(unit, "breed")
    breed_name = breed_data.name
    if breed_categories[breed_name] then
        return breed_categories[breed_name]
    else
        -- Handle unknown breeds: everything below 300 HP is normal, above is a boss
        local health_extension = ScriptUnit.extension(unit, "health_system")
        local hp = health_extension:get_max_health()
        if hp > 300 then
            return "boss"
        else
            return "normal"
        end
    end
end

-- Talents
mod:dofile("scripts/mods/rwaon_talents/talents/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/talents/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/talents/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/talents/witch_hunter")
--mod:dofile("scripts/mods/rwaon_talents/talents/dwarf_ranger")

-- Ultimates
mod:dofile("scripts/mods/rwaon_talents/ults/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/ults/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/ults/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/ults/witch_hunter")
--mod:dofile("scripts/mods/rwaon_talents/ults/dwarf_ranger")

-- Passives
--mod:dofile("scripts/mods/rwaon_talents/passives/bright_wizard")
--mod:dofile("scripts/mods/rwaon_talents/passives/wood_elf")
--mod:dofile("scripts/mods/rwaon_talents/passives/empire_soldier")
--mod:dofile("scripts/mods/rwaon_talents/passives/witch_hunter")
--mod:dofile("scripts/mods/rwaon_talents/passives/dwarf_ranger")

-- Weapons
--mod:dofile("scripts/mods/rwaon_talents/weapons/1h_falchions")
--mod:dofile("scripts/mods/rwaon_talents/weapons/1h_axes")
mod:dofile("scripts/mods/rwaon_talents/weapons/2h_axes_wood_elf")
mod:dofile("scripts/mods/rwaon_talents/weapons/shortbows_hagbane")
mod:dofile("scripts/mods/rwaon_talents/weapons/sienna_scholar_career_skill")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_blast_beam")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_spark_spear")
mod:dofile("scripts/mods/rwaon_talents/weapons/staff_fireball_fireball")
mod:dofile("scripts/mods/rwaon_talents/weapons/staff_fireball_geiser")
--mod:dofile("scripts/mods/rwaon_talents/weapons/staff_flamethrower")

-- Traits
--mod:dofile("scripts/mods/rwaon_talents/traits/barrage")

--Misc
mod:dofile("scripts/mods/rwaon_talents/misc/buff_type_fix")
mod:dofile("scripts/mods/rwaon_talents/misc/regrowth_fix")


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