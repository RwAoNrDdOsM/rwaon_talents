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
