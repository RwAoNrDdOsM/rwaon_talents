local mod = get_mod("rwaon_talents")

local function is_local(unit)
	local player = Managers.player:owner(unit)

	return player and not player.remote
end
local function merge(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end
function is_in_inn()
    local level_transition_handler = Managers.state.game_mode.level_transition_handler
	local level_key = level_transition_handler:get_current_level_keys()
    local is_in_inn = level_key == "inn_level"
    return is_in_inn
end

NewDamageProfileTemplates = {}

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
        buffer = "both",
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
    local index = #NetworkLookup.buff_templates + 1
    NetworkLookup.buff_templates[index] = buff_name
    NetworkLookup.buff_templates[buff_name] = index
end
function mod:add_talent_buff_extra(hero_name, buff_name, buff_data)   
    TalentBuffTemplates[hero_name][buff_name] = buff_data
    BuffTemplates[buff_name] = buff_data
    local index = #NetworkLookup.buff_templates + 1
    NetworkLookup.buff_templates[index] = buff_name
    NetworkLookup.buff_templates[buff_name] = index
end

function mod:add_buff(buff_name, buff_data) 
    local new_buff = {
        buffs = {
            merge({ name = buff_name }, buff_data),
        },
    }
    BuffTemplates[buff_name] = new_buff
    local index = #NetworkLookup.buff_templates + 1
    NetworkLookup.buff_templates[index] = buff_name
    NetworkLookup.buff_templates[buff_name] = index
end

function mod:add_buff_extra(buff_name, buff_data)
    BuffTemplates[buff_name] = buff_data
    local index = #NetworkLookup.buff_templates + 1
    NetworkLookup.buff_templates[index] = buff_name
    NetworkLookup.buff_templates[buff_name] = index
end

function mod:add_buff_function(name, func)
    BuffFunctionTemplates.functions[name] = func
end

function change_weapon_value(action_no, action_from, value, new_data)
    action_no[action_from][value] = new_data
end
function _change_weapon_value(_value, value, new_data)
    _value[value] = new_data
end

function change_chain_actions(action_no, action_from, row, new_data)
	local value = "allowed_chain_actions"
	action_no[action_from][value][row] = new_data
end

function change_buff_data(action_no, action_from, row, new_data)
	local value = "buff_data"
	action_no[action_from][value][row] = new_data
end

function add_buff_data(action_no, action_from, new_data)
	local value = "buff_data"
	action_no[action_from][value] = new_data
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

--[[ProcFunctions.heal_permanent_proc = function (player, buff, params)
	if not Managers.state.network.is_server then
        return
    end

    local player_unit = player.player_unit
    local heal_amount = buff.bonus
    local hit_unit = params[1]
    local attack_type = params[2]
    local hit_zone_name = params[3]
    local target_number = params[4]
    local buff_type = params[5]
    local critical_hit = params[6]
    local breed = AiUtils.unit_breed(hit_unit)
    local attack_wanted = buff.attack_wanted
    mod:echo(attack_type)
    mod:echo(buff_type)

    if Unit.alive(player_unit) and breed and (attack_type == attack_wanted) then
        DamageUtils.heal_network(player_unit, player_unit, heal_amount, "heal_from_proc")
        mod:echo("Healed by" .. tostring(heal_amount))
    end
end]]

-- Character States
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_dodging")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_falling")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_interacting")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_jumping")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_leaping")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_lunging")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_standing")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_walking")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/states/player_character_state_stunned")


--Player Movement Setting
mod:dofile("scripts/mods/rwaon_talents/scripts/settings/player_movement_settings")

--Buff Stuff
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/buffs/buff_funtion_templates")
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/default_player_unit/buffs/buff_templates")

-- Characters
mod:dofile("scripts/mods/rwaon_talents/characters/bright_wizard")
mod:dofile("scripts/mods/rwaon_talents/characters/wood_elf")
mod:dofile("scripts/mods/rwaon_talents/characters/empire_soldier")
mod:dofile("scripts/mods/rwaon_talents/characters/witch_hunter")
mod:dofile("scripts/mods/rwaon_talents/characters/dwarf_ranger")

-- Death Reactions
mod:dofile("scripts/mods/rwaon_talents/scripts/unit_extensions/generic/death_reactions")

-- Weapons
RangedBuffTypes = {
    RANGED = true,
    ULTIMATE = true,
}
mod:dofile("scripts/mods/rwaon_talents/scripts/settings/equipment/weapons")

-- Traits
mod:dofile("scripts/mods/rwaon_talents/scripts/settings/equipment/weapon_traits")

-- Code to get Traits working
for name, data in pairs(WeaponTraits.traits) do
	data.name = name
end
table.merge_recursive(BuffTemplates, WeaponTraits.buff_templates)

--Misc
mod:dofile("scripts/mods/rwaon_talents/misc/explode_fix")
--mod:dofile("scripts/mods/rwaon_talents/misc/dropdowns")
--mod:dofile("scripts/mods/rwaon_talents/misc/cooldown")

-- DamageProfielTemplates NetworkLookup
for key, _ in pairs(NewDamageProfileTemplates) do
    i = #NetworkLookup.damage_profiles + 1
    NetworkLookup.damage_profiles[i] = key
    NetworkLookup.damage_profiles[key] = i
end

StatBuffApplicationMethods.increased_max_targets = "stacking_multiplier" -- stacking_bonus

table.merge_recursive(DamageProfileTemplates, NewDamageProfileTemplates)

--[[ DEBUG DEBUG DEBUG ]]--

-- Set all characters to max level.
--[[mod:hook(BackendInterfaceHeroAttributesPlayFab, "get", function (func, self, hero_name, attribute_name)
    if attribute_name == "experience" then
        return 99999999999
    end
    return func(self, hero_name, attribute_name)
end)

-- Unlock all careers.
mod:hook(Development, "parameter", function(func, key, ...)
    if key == "unlock_all_careers" then return true end
    return func(key, ...)
end)]]

-- Do NOT unlock achievements.
mod:hook(Achievement, "unlock", function(func, ...)
    return
end)

-- Callbacks
mod.update = function(dt)
    --mod:update_physics(dt)
end

mod.on_setting_changed = function()
end