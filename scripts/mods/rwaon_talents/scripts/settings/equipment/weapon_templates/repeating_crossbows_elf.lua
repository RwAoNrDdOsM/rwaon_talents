local mod = get_mod("rwaon_talents")

-- Elf Repeating Crossbow
------------------------------------------------------------------------------
-- Letting all careers using this weapon
ItemMasterList.we_crossbow_repeater.can_wield = {
    "we_shade",
    "we_maidenguard"
}

for _, weapon in ipairs{
    "repeating_crossbow_elf_template",
} do
    local weapon_template = Weapons[weapon]
    local action_one = weapon_template.actions.action_one
    local action_two = weapon_template.actions.action_two
    change_weapon_value(action_one, "zoomed_shot","hold_input", "action_two_hold")
end

--Crash Preventions from AnyWeapon
--- Crash prevention.
mod:hook_origin(GearUtils, "link_units", function(world, attachment_node_linking, link_table, source, target)
	for _, attachment_nodes in ipairs(attachment_node_linking) do
		local source_node = attachment_nodes.source
		local target_node = attachment_nodes.target

		local target_node_valid = type(target_node) ~= "string" and true or Unit.has_node(target, target_node)
		local source_node_valid = type(source_node) ~= "string" and true or Unit.has_node(source, source_node)
		if target_node_valid and source_node_valid then
			local source_node_index = (type(source_node) == "string" and Unit.node(source, source_node)) or source_node
			local target_node_index = (type(target_node) == "string" and Unit.node(target, target_node)) or target_node
			link_table[#link_table + 1] = {
				unit = target,
				i = target_node_index,
				parent = Unit.scene_graph_parent(target, target_node_index),
				local_pose = Matrix4x4Box(Unit.local_pose(target, target_node_index))
			}

			World.link_unit(world, target, target_node_index, source, source_node_index)
		end
	end
end)

--- Crash prevention.
mod:hook(MenuWorldPreviewer, "_spawn_item_unit", function(func, self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
	pcall(function()
		func(self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
	end)
end)

mod:hook(Unit, "animation_event", function(func, ...)
	pcall(function(...)
		return func(...)
	end, ...)
end)

--- Crash prevention.
mod:hook(SimpleHuskInventoryExtension, "_wield_slot", function(func, self, world, equipment, slot_name, unit_1p, unit_3p)
	local item_data
	pcall(function()
		item_data = func(self, world, equipment, slot_name, unit_1p, unit_3p)
	end)
	return item_data
end)

--- Crash prevention.
mod:hook(SimpleInventoryExtension, "_wield_slot", function(func, self, equipment, slot_data, unit_1p, unit_3p, buff_extension)
	local ret_val
	pcall(function()
		ret_val = func(self, equipment, slot_data, unit_1p, unit_3p, buff_extension)
	end)
	return ret_val
end)