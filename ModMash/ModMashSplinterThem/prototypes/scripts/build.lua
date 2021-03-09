require("prototypes.scripts.defines") 
local table_contains = modmashsplinterthem.util.table.contains

local rebuild_names = {"them-roboport","them-chest","them-chest-energy-converter","them-solar-panel","them-transport-belt","them-underground-belt-structure","them-mini-loader-structure","them-small-electric-pole"}
--local onexone = {"them-transport-belt","them-underground-belt-structure","them-mini-loader-structure","them-small-electric-pole"}
--local onezthree = {"them-chest","them-chest-energy-converter"}
--local threexthree = {"them-solar-panel"}
--local fourxfour = {"them-roboport"}

local entity_size = {}
entity_size["them-roboport"]= {x=4,y=4}
entity_size["them-solar-panel"] = {x=3,y=3}
entity_size["them-chest-energy-converter"] = {x=1,y=3}
entity_size["them-chest"] = {x=1,y=3}
entity_size["them-transport-belt"] = {x=1,y=1}
entity_size["them-underground-belt-structure"] = {x=1,y=1}
entity_size["them-mini-loader-structure"] = {x=1,y=1}
entity_size["them-small-electric-pole"] = {x=1,y=1}

local local_bases = {
	{
		{name="them-roboport", position={x=2,y=2}},
		{name="them-solar-panel", position={x=5.5,y=2.5}},
		{name="them-solar-panel", position={x=9.5,y=2.5}},
		{name="them-chest-energy-converter", position={x=7.5,y=4.5}},
		{name="them-chest", position={x=3.5,y=5.5}},
		{name="them-chest", position={x=8.5,y=7.5}},
		{name="them-transport-belt", position={x=0.5,y=4.5}, direction = 2},
		{name="them-transport-belt", position={x=1.5,y=4.5}, direction = 2},		
		{name="them-transport-belt", position={x=5.5,y=4.5}, direction = 2},
		{name="them-transport-belt", position={x=5.5,y=5.5}, direction = 2},
		{name="them-transport-belt", position={x=5.5,y=9.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=10.5}, direction = 0},
		{name="them-transport-belt", position={x=3.5,y=8.5}, direction = 2},
		{name="them-transport-belt", position={x=4.5,y=8.5}, direction = 2},
		{name="them-transport-belt", position={x=5.5,y=8.5}, direction = 2},
		{name="them-transport-belt", position={x=6.5,y=8.5}, direction = 2},
		{name="them-transport-belt", position={x=1.5,y=5.5}, direction = 0},
		{name="them-transport-belt", position={x=1.5,y=6.5}, direction = 0},
		--{name="them-transport-belt", position={x=9.5,y=5.5}, direction = 0},
		
		{name="them-transport-belt", position={x=9.5,y=4.5}, direction = 2},		
		{name="them-transport-belt", position={x=10.5,y=4.5}, direction = 2},
		
		{name="them-transport-belt", position={x=5.5,y=7.5}, direction = 0},
		{name="them-transport-belt", position={x=6.5,y=7.5}, direction = 6},

		{name="them-underground-belt-structure", position={x=6.5,y=4.5}, direction = 2, belt_to_ground_type = "input"},
		{name="them-underground-belt-structure", position={x=8.5,y=4.5}, direction = 6, belt_to_ground_type = "output"},
		
		
		{name="them-underground-belt-structure", position={x=6.5,y=6.5}, direction = 6, belt_to_ground_type = "output"},
		{name="them-underground-belt-structure", position={x=2.5,y=6.5}, direction = 2, belt_to_ground_type = "input"},

		{name="them-underground-belt-structure", position={x=5.5,y=6.5}, direction = 0, belt_to_ground_type = "input"},
		{name="them-underground-belt-structure", position={x=5.5,y=0.5}, direction = 4, belt_to_ground_type = "output"},
		
		{name="them-mini-loader-structure", position={x=2.5,y=4.5}, direction = 2, loader_type="input"},
		{name="them-mini-loader-structure", position={x=4.5,y=4.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=6.5,y=5.5}, direction = 2, loader_type="input"},
		{name="them-mini-loader-structure", position={x=4.5,y=5.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=3.5,y=7.5}, direction = 0, loader_type="output"},
		{name="them-mini-loader-structure", position={x=7.5,y=6.5}, direction = 2, loader_type="output"},
		{name="them-mini-loader-structure", position={x=7.5,y=7.5}, direction = 2, loader_type="output"},
		{name="them-mini-loader-structure", position={x=7.5,y=8.5}, direction = 2, loader_type="input"},
		{name="them-small-electric-pole", position={x=7.5,y=2.5}},
		{name="them-small-electric-pole", position={x=2.5,y=5.5}},

		
		{name="them-underground-belt-structure", position={x=4.5,y=0.5}, direction = 4, belt_to_ground_type = "input"},
		{name="them-underground-belt-structure", position={x=4.5,y=10.5}, direction = 0, belt_to_ground_type = "output"},

		{name="them-underground-belt-structure", position={x=10.5,y=5.5}, direction = 6, belt_to_ground_type = "input"},
		{name="them-underground-belt-structure", position={x=0.5,y=5.5}, direction = 2, belt_to_ground_type = "output"}

	},
	{
		{name="them-mini-loader-structure", position={x=1.5,y=5.5}, direction = 4, loader_type="input"},
		{name="them-mini-loader-structure", position={x=4.5,y=4.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=4.5,y=5.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=8.5,y=5.5}, direction = 2, loader_type="input"},
		{name="them-mini-loader-structure", position={x=10.5,y=4.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=2.5,y=8.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=3.5,y=7.5}, direction = 0, loader_type="input"},
		{name="them-mini-loader-structure", position={x=4.5,y=8.5}, direction = 2, loader_type="output"},
		{name="them-mini-loader-structure", position={x=5.5,y=9.5}, direction = 0, loader_type="input"},


		{name="them-roboport", position={x=8,y=8}},
		{name="them-solar-panel", position={x=2.5,y=2.5}},
		{name="them-solar-panel", position={x=7.5,y=2.5}},
		{name="them-chest-energy-converter", position={x=9.5,y=4.5}},
		{name="them-chest", position={x=1.5,y=7.5}},
		{name="them-chest", position={x=3.5,y=5.5}},
		{name="them-chest", position={x=5.5,y=7.5}},
		{name="them-transport-belt", position={x=0.5,y=4.5}, direction = 2},
		{name="them-transport-belt", position={x=1.5,y=4.5}, direction = 4},
		{name="them-transport-belt", position={x=5.5,y=5.5}, direction = 2},
		{name="them-transport-belt", position={x=6.5,y=5.5}, direction = 2},
		{name="them-transport-belt", position={x=7.5,y=5.5}, direction = 2},
		{name="them-transport-belt", position={x=3.5,y=8.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=0.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=1.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=2.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=3.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=4.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=10.5}, direction = 0},

		{name="them-small-electric-pole", position={x=2.5,y=4.5}},
		{name="them-small-electric-pole", position={x=6.5,y=4.5}},
		{name="them-small-electric-pole", position={x=10.5,y=7.5}},

				{name="them-underground-belt-structure", position={x=4.5,y=0.5}, direction = 4, belt_to_ground_type = "input"},
		{name="them-underground-belt-structure", position={x=4.5,y=10.5}, direction = 0, belt_to_ground_type = "output"},

		{name="them-underground-belt-structure", position={x=10.5,y=5.5}, direction = 6, belt_to_ground_type = "input"},
		{name="them-underground-belt-structure", position={x=0.5,y=5.5}, direction = 2, belt_to_ground_type = "output"}

	},
	{
		{name="them-mini-loader-structure", position={x=4.5,y=2.5}, direction = 4, loader_type="input"},
		{name="them-mini-loader-structure", position={x=5.5,y=1.5}, direction = 4, loader_type="output"}, --
		{name="them-mini-loader-structure", position={x=3.5,y=4.5}, direction = 2, loader_type="input"},
		{name="them-mini-loader-structure", position={x=3.5,y=5.5}, direction = 2, loader_type="output"},

		{name="them-mini-loader-structure", position={x=4.5,y=6.5}, direction = 0, loader_type="output"},
		{name="them-mini-loader-structure", position={x=9.5,y=7.5}, direction = 0, loader_type="input"},

		{name="them-mini-loader-structure", position={x=6.5,y=4.5}, direction = 6, loader_type="input"},
		{name="them-mini-loader-structure", position={x=5.5,y=5.5}, direction = 6, loader_type="output"},

		{name="them-mini-loader-structure", position={x=8.5,y=5.5}, direction = 2, loader_type="input"},
		{name="them-mini-loader-structure", position={x=8.5,y=4.5}, direction = 2, loader_type="output"},

		{name="them-mini-loader-structure", position={x=10.5,y=4.5}, direction = 6, loader_type="output"},
		{name="them-mini-loader-structure", position={x=10.5,y=5.5}, direction = 6, loader_type="input"},


		{name="them-roboport", position={x=2,y=8}},
		{name="them-solar-panel", position={x=2.5,y=2.5}},
		{name="them-solar-panel", position={x=7.5,y=2.5}},
		{name="them-solar-panel", position={x=7.5,y=7.5}},

		{name="them-chest-energy-converter", position={x=5.5,y=3.5}},
		{name="them-chest", position={x=9.5,y=5.5}},
		{name="them-chest", position={x=4.5,y=4.5}},

		{name="them-transport-belt", position={x=4.5,y=0.5}, direction = 4},
		{name="them-transport-belt", position={x=4.5,y=1.5}, direction = 4},
		{name="them-transport-belt", position={x=5.5,y=0.5}, direction = 0},

		{name="them-transport-belt", position={x=4.5,y=7.5}, direction = 4},
		{name="them-transport-belt", position={x=4.5,y=8.5}, direction = 4},
		{name="them-transport-belt", position={x=4.5,y=9.5}, direction = 4},
		{name="them-transport-belt", position={x=4.5,y=10.5}, direction = 4},


		{name="them-transport-belt", position={x=0.5,y=4.5}, direction = 2},
		{name="them-transport-belt", position={x=1.5,y=4.5}, direction = 2},
		{name="them-transport-belt", position={x=2.5,y=4.5}, direction = 2},

		{name="them-transport-belt", position={x=0.5,y=5.5}, direction = 6},
		{name="them-transport-belt", position={x=1.5,y=5.5}, direction = 6},
		{name="them-transport-belt", position={x=2.5,y=5.5}, direction = 6},

		{name="them-transport-belt", position={x=7.5,y=4.5}, direction = 6},

		{name="them-transport-belt", position={x=6.5,y=5.5}, direction = 2},
		{name="them-transport-belt", position={x=7.5,y=5.5}, direction = 2},

		{name="them-transport-belt", position={x=5.5,y=10.5}, direction = 0},
		{name="them-transport-belt", position={x=5.5,y=9.5}, direction = 2},
		{name="them-transport-belt", position={x=6.5,y=9.5}, direction = 2},
		{name="them-transport-belt", position={x=7.5,y=9.5}, direction = 2},
		{name="them-transport-belt", position={x=8.5,y=9.5}, direction = 2},
		{name="them-transport-belt", position={x=9.5,y=9.5}, direction = 0},
		{name="them-transport-belt", position={x=9.5,y=8.5}, direction = 0},

		{name="them-small-electric-pole", position={x=0.5,y=3.5}},
		{name="them-small-electric-pole", position={x=5.5,y=6.5}},
		{name="them-small-electric-pole", position={x=3.5,y=10.5}},
		{name="them-small-electric-pole", position={x=9.5,y=3.5}}

	}
}

--not quite 100% seems to return false in some instances where an be true
local local_can_add_entity = function(surface,name, x, y, offset_x, offset_y)
	local nx = x+offset_x
	local ny = y+offset_y
	if surface.surface.find_entity(name, {x=nx,y=ny}) ~= nil then return true end
	local size = entity_size[name] 
	if surface.surface.can_place_entity{name=name, position={x=nx,y=ny}} then return true end
	if size == nil then return surface.surface.can_place_entity{name="them-transport-belt", position={x=nx,y=ny}, build_check_type=defines.build_check_type.blueprint_ghost, forced=true} end
	local hx = size.x/2.0
	local hy = size.y/2.0
	for cx = (hx*-1), hx,1 do
		for cy = (hy*-1), hy,1 do
			if false == surface.surface.can_place_entity{name="them-transport-belt", position={x=nx+cx,y=ny+cy}, build_check_type=defines.build_check_type.blueprint_ghost, forced=true} then
				local tile = surface.surface.get_tile(nx+cx,ny+cy).name
				if tile ~= nil and string.find(tile,"water") == nil then 
					return false 
				end
			end
		end
	end
	return true
end

local local_add_concrete = function(surface,name, x, y, offset_x, offset_y,water_fix)
	local nx = x+offset_x
	local ny = y+offset_y
	--if surface.surface.find_entity(name, {x=nx,y=ny}) ~= nil then return end
	local size = entity_size[name] 
	if size == nil then 
		if surface.surface.get_tile(x+offset_x,y+offset_y).name ~="them-concrete"
			then surface.surface.set_tiles({{name="them-concrete",position={x=nx,y=ny}}}) 
		end
		return
	end		
	local hx = ((size.x)/2.0)
	local hy = ((size.y)/2.0)
	for cx = (hx*-1)-0.5, hx+0.5,1 do
		for cy = (hy*-1)-0.5, hy+0.5,1 do
			if surface.surface.get_tile(nx+cx,ny+cy).name ~="them-concrete" then
				if water_fix == true then
					local tile = surface.surface.get_tile(nx+cx,ny+cy).name
					if tile ~= nil and string.find(tile,"water") ~= nil then 
						surface.surface.set_tiles({{name="them-concrete",position={x=nx+cx,y=ny+cy}, remove_colliding_entities = true, remove_colliding_decoratives = true}})
					end
				else
					surface.surface.set_tiles({{name="them-concrete",position={x=nx+cx,y=ny+cy}, remove_colliding_entities = true, remove_colliding_decoratives = true}})
				end
			end
		end
	end
end

local local_kill_area = function(surface,name, x, y, offset_x, offset_y)
	local nx = x+offset_x
	local ny = y+offset_y
	local size = entity_size[name] 
	if size == nil then size = {x=1,y=1} end
	local kill = surface.surface.find_entities({{(nx-(size.x/2)), (ny-(size.y/2))}, {(nx+(size.x/2)), (ny+(size.y/2))}})
	for k=1, #kill do 
		if kill[k].type ~= "character" and kill[k].type ~= "spider-vehicle" and kill [k].type ~= "construction-robot" and kill[k].type ~= "logistic-robot" and kill[k].type ~= "combat-robot" and kill[k].type ~= "projectile" then
			kill[k].destroy({raise_destroy=true})
		end
	end
end

local local_add_port = function(surface, x, y, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-roboport",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-roboport", position={x=x+offset_x,y=y+offset_y}, force="enemy",create_build_effect_smoke=false,create_build_effect_smoke=false}
	elseif surface.surface.find_entity("them-roboport",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then
			local_kill_area(surface,"them-roboport",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-roboport",x,y,offset_x,offset_y)
			return surface.surface.create_entity{name="them-roboport", position={x=x+offset_x,y=y+offset_y}, force="enemy",raise_built = true,create_build_effect_smoke=false}
		end
	end
end

local local_add_pole = function(surface, x, y, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-small-electric-pole",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-small-electric-pole", position={x=x+offset_x,y=y+offset_y}, force="enemy",create_build_effect_smoke=false}
	elseif surface.surface.find_entity("them-small-electric-pole",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then			
			local_kill_area(surface,"them-small-electric-pole",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-small-electric-pole",x,y,offset_x,offset_y)
			surface.surface.create_entity{name="them-small-electric-pole", position={x=x+offset_x,y=y+offset_y}, force="enemy",raise_built = true,create_build_effect_smoke=false}
		end
	end
end

local local_add_chest = function(surface, x, y, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-chest",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-chest", force="enemy", position={x=x+offset_x,y=y+offset_y}}
	elseif surface.surface.find_entity("them-chest",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then
		local kill = surface.surface.find_entities({{(x+offset_x)-0.1, (y+offset_y)-0.5}, {(x+offset_x)+0.1, (y+offset_y)+0.5}})
			local_kill_area(surface,"them-chest",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-chest",x,y,offset_x,offset_y)
			surface.surface.create_entity{name="them-chest", position={x=x+offset_x,y=y+offset_y}, force="enemy",raise_built = true,create_build_effect_smoke=false}
		end
	end
end

local local_add_converter = function(surface, x, y, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-chest-energy-converter",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-chest-energy-converter", position={x=x+offset_x,y=y+offset_y}, force="enemy",create_build_effect_smoke=false}
	elseif surface.surface.find_entity("them-chest-energy-converter",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then
			local kill = surface.surface.find_entities({{(x+offset_x)-0.1, (y+offset_y)-0.5}, {(x+offset_x)+0.1, (y+offset_y)+0.5}})
			local_kill_area(surface,"them-chest-energy-converter",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-chest-energy-converter",x,y,offset_x,offset_y)			
			surface.surface.create_entity{name="them-chest-energy-converter", position={x=x+offset_x,y=y+offset_y}, force="enemy",raise_built = true}
		end
	end
end

local local_add_solar = function(surface, x, y, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-solar-panel",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-solar-panel", position={x=x+offset_x,y=y+offset_y}, force="enemy",create_build_effect_smoke=false}
	elseif surface.surface.find_entity("them-solar-panel",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then
			local_kill_area(surface,"them-solar-panel",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-solar-panel",x,y,offset_x,offset_y)
			surface.surface.create_entity{name="them-solar-panel", position={x=x+offset_x,y=y+offset_y}, force="enemy",raise_built = true}
		end
	end
end

local local_add_belt = function(surface, x, y,direction, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-transport-belt",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-transport-belt", position={x=x+offset_x,y=y+offset_y},direction=direction, force="enemy",create_build_effect_smoke=false}
	elseif surface.surface.find_entity("them-transport-belt",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.name)== false then
			local_kill_area(surface,"them-transport-belt",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-transport-belt",x,y,offset_x,offset_y)
			surface.surface.create_entity{name="them-transport-belt", position={x=x+offset_x,y=y+offset_y},direction=direction, force="enemy",raise_built = true}
		end
	end
end

local local_add_underground = function(surface, x, y,direction,belt_to_ground_type, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-underground-belt-structure",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-underground-belt-structure", position={x=x+offset_x,y=y+offset_y},direction=direction,belt_to_ground_type=belt_to_ground_type, force="enemy",create_build_effect_smoke=false}		
	elseif surface.surface.find_entity("them-underground-belt-structure",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then
			local kill = surface.surface.find_entities({{(x+offset_x)-0.1, (y+offset_y)-0.1}, {(x+offset_x)+0.1, (y+offset_y)+0.1}})
			local_kill_area(surface,"them-underground-belt-structure",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-underground-belt-structure",x,y,offset_x,offset_y)
			surface.surface.create_entity{name="them-underground-belt-structure", position={x=x+offset_x,y=y+offset_y},direction=direction,belt_to_ground_type=belt_to_ground_type, force="enemy",raise_built = true,create_build_effect_smoke=false}						
		end
	end
end

local local_add_loader = function(surface, x, y,direction,loader_type, ghost, offset_x,offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0
	if ghost == true then
		local_add_concrete(surface,"them-mini-loader-structure",x,y,offset_x,offset_y,true)
		surface.surface.create_entity{name = "entity-ghost", inner_name = "them-mini-loader-structure", position={x=x+offset_x,y=y+offset_y},direction=direction,loader_type=loader_type, force="enemy",create_build_effect_smoke=false}
		table.insert(surface.loader_checks,{position={x=x+offset_x,y=y+offset_y},loader_type=loader_type})
	elseif surface.surface.find_entity("them-mini-loader-structure",{x=x+offset_x,y=y+offset_y}) == nil then
		local g = surface.surface.find_entity("entity-ghost",{x=x+offset_x,y=y+offset_y})
		if g==nil or table_contains(rebuild_names, g.inner_name)== false then
			local kill = surface.surface.find_entities({{(x+offset_x)-0.1, (y+offset_y)-0.1}, {(x+offset_x)+0.1, (y+offset_y)+0.1}})
			local_kill_area(surface,"them-mini-loader-structure",x,y,offset_x,offset_y)
			local_add_concrete(surface,"them-mini-loader-structure",x,y,offset_x,offset_y)			
			surface.surface.create_entity{name="them-mini-loader-structure", position={x=x+offset_x,y=y+offset_y},direction=direction,loader_type=loader_type, force="enemy",raise_built = true,create_build_effect_smoke=false}		
			table.insert(surface.loader_checks,{position={x=x+offset_x,y=y+offset_y},loader_type=loader_type})
		end
	end
end

local local_can_build_base = function(surface, x, y, base)
	for k=1, #base do 
		if local_can_add_entity(surface,base[k].name, base[k].position.x, base[k].position.y, x, y) ~= true then return false end
	end
	return true
end

local local_build_base = function(surface, x, y, cbase, ghost)
	local connections = {}
	local ports = {}
	local is_vein = true
	local base = {}
	

	if is_vein == false then
		local destroys = surface.surface.find_entities_filtered{area={left_top = {x+0.1, y+0.1}, right_bottom = {x+9.9, y+10.9}}}
		for k=1, #destroys do
			if destroys[k].type ~= "character" and destroys[k].name ~= "them-roboport" and destroys[k].name ~=  "them-chest-energy-converter" and destroys[k].name ~=  "them-chest" then
				if destroys[k].type == "cliff" then
					destroys[k].destroy({raise_destroy=true})
				else
					destroys[k].destroy({raise_destroy=false})
				end
			end
		end
	end
	for k=1, #cbase do --deleted before don't delete
		table.insert(base,cbase[k])
	end

	if ghost==true then --weird underground belt flipping
		base[#base] = cbase[#base-1]
		base[#base-1] = cbase[#base]
	end

	

	for k=1, #base do 
		local structure = base[k]	
		if ghost == true and structure ~= nil then
			table.insert(surface.rebuild[structure.name],{position = {x=(structure.position.x+x),y=(structure.position.y+y)}})
			if surface.current_base_build == nil then surface.current_base_build = {positions={}} end
			table.insert(surface.current_base_build.positions,{position = {x=(structure.position.x+x),y=(structure.position.y+y)}})
			surface.current_base_build.base = base --i know it gets set over and over again
			surface.current_base_build.position = {x=x,y=y}
			surface.current_base_build.is_vein = is_vein
		end
		
		connections["top"] = {marked=false}
		connections["bottom"] = {marked=false}
		connections["left"] = {marked=false}
		connections["right"] = {marked=false}
		if structure.name == "them-roboport" then
			local e = local_add_port(surface, structure.position.x, structure.position.y, ghost, x,y)
			table.insert(ports,e)
		elseif structure.name == "them-chest" then
			local_add_chest(surface, structure.position.x, structure.position.y, ghost, x,y)
		elseif structure.name == "them-chest-energy-converter" then
			local_add_converter(surface, structure.position.x, structure.position.y, ghost, x,y)
		elseif structure.name == "them-solar-panel" then
			local_add_solar(surface, structure.position.x, structure.position.y, ghost, x,y)
		elseif structure.name == "them-transport-belt" then
			local_add_belt(surface, structure.position.x, structure.position.y,structure.direction, ghost, x,y)
		elseif structure.name == "them-underground-belt-structure" then
			local_add_underground(surface, structure.position.x, structure.position.y,structure.direction,structure.belt_to_ground_type, ghost, x,y)
		elseif structure.name == "them-mini-loader-structure" then
			local_add_loader(surface, structure.position.x, structure.position.y,structure.direction,structure.loader_type, ghost, x,y)
		elseif structure.name == "them-small-electric-pole" then
			local_add_pole(surface, structure.position.x, structure.position.y, ghost, x,y)
		end
	end
	if ghost == true then return {connections=connections,position={x=x,y=y},ports = {},is_vein = is_vein} end
	return {connections=connections,position={x=x,y=y},base=base,ports=ports,is_vein = is_vein}
end

local local_build_random_base = function(surface, x, y, ghost)
	return local_build_base(surface, x, y, local_bases[math.random(1,#local_bases)])
end

return
{
	bases = local_bases,
	can_add_entity = local_can_add_entity,
	add_port = local_add_port,
	add_pole = local_add_pole,
	add_chest = local_add_chest,
	add_converter = local_add_converter,
	add_solar = local_add_solar,
	add_belt = local_add_belt,
	add_underground = local_add_underground,
	add_loader = local_add_loader,
	can_build_base = local_can_build_base,
	build_base = local_build_base,
	build_random_base = local_build_random_base,
	add_concrete=local_add_concrete
}
