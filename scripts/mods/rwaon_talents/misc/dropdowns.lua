local mod = get_mod("rwaon_talents")

DropdownUnits = DropdownUnits or {}
DropdownUnits.units = {}
DropdownUnits.units.bounding_unit = {}
DropdownUnits.positions = {}
DropdownUnits.positions.bounding_unit = {}
unit_unique_id_counter = 1
rwaon_enable_physics = {}

--[[mod.enable_physics = function(self, unit)
	rwaon_enable_physics_time = 0
    
    local world = Managers.world:world("level_world")

	table.insert(
		rwaon_enable_physics,
		{
			unit = unit,
			t = World.time(world)
		}
	)
end

mod.update_physics = function(self, dt)
	if #rwaon_enable_physics > 0 then
		-- Update time
		rwaon_enable_physics_time = rwaon_enable_physics_time + dt
		
		-- Time pasted
		if rwaon_enable_physics_time >= 1 then
			for _, data in pairs(rwaon_enable_physics) do
				if data.unit and Unit.alive(data.unit) then
					Unit.enable_physics(data.unit)
				end
			end
			
			-- Stop loop
			rwaon_enable_physics_time = 0
			rwaon_enable_physics = {}
		end
	end
end]]

mod.destroy_unit = function(self, unit)
	local position = Vector3(-10000, -10000, -10000)
			
    Unit.disable_physics(unit)
    Unit.set_local_position(unit, 0, position)
    --mod:enable_physics(unit)
end

mod.on_game_state_changed = function(status, state)
	if status == "enter" and state == "StateIngame" then
		mod.DropdownUnits()
	end
end

mod:command("ree", mod:localize("ree_command_description"), function() mod.DropdownUnits() end)

mod.DropdownUnits = function(self)
    local game_mode_manager = Managers.state.game_mode

    if game_mode_manager then
		local level_transition_handler = game_mode_manager.level_transition_handler
        local level_key = level_transition_handler.level_key

        --mod:echo(level_key)

        if level_key == "inn_level" then
            return
        end

        if level_key == "farmlands" then
            DropdownUnits.units = {
                -- Cart 1
                ["[Unit '#ID[f80dba6e6d92ae86]']"] = true,
                -- Cart 2
                ["[Unit '#ID[4dacf2107d46bf17]']"] = true,
                -- Planks 1
                ["[Unit '#ID[c21909d2c2eca591]']"] = true, 
                -- Something
                ["[Unit '#ID[844fb22beb341971]']"] = true, 
                -- Something else
                ["[Unit '#ID[d405e0b136c19f2c]']"] = true, 
                -- Plank 1
                ["[Unit '#ID[77213efd652ea6ce]']"] = true, 
                -- Plank 2
                ["[Unit '#ID[d405e0b136c19f2c]']"] = true, 
                -- Box
                ["[Unit '#ID[5123b3476f0f7ef8]']"] = true, 
                -- Gate
                ["[Unit '#ID[429418d88cd56409]']"] = true, 
            }
            DropdownUnits.positions = {
                -- Cart 1
                ["271.96, -255.61, 7.66"] = true,
                -- Cart 2
                ["178.55, -176.87, 4.80"] = true,
                -- Planks 1
                ["273.27, -255.92, 7.82"] = true,
                -- Plank 1
                ["270.36, -255.77, 9.73"] = true,
                ["271.09, -254.09, 9.77"] = true,
                -- Plank 2
                ["271.59, -256.75, 8.70"] = true,
                ["271.75, -254.80, 9.41"] = true,
                -- Box
                ["271.32, -254.45, 8.25"] = true,
                ["270.37, -256.21, 8.18"] = true,
                -- Gate
                ["176.53, -175.00, 5.03"] = true,
            }
        end
	end

    local world = Managers.world:world("level_world")
    local units = World.units(world)

    for _, unit in pairs(units) do
        local position = Unit.world_position(unit, 0)
        local position_to_2f = tostring(string.format("%.2f", position[1])) .. ", " .. tostring(string.format("%.2f", position[2])) .. ", " .. tostring(string.format("%.2f", position[3]))
        local origin_position = DropdownUnits.positions[position_to_2f] or Vector3(0, -10000, 0)

        if origin_position == true then 
            origin_position = position
        end 

        if DropdownUnits.units[tostring(unit)] and Vector3.distance(position, origin_position) <= 0.001 then
            mod:echo("Destroyed Unit: " .. tostring(unit) .. " at " .. tostring(position))

            mod:destroy_unit(unit)
        end
    end
end