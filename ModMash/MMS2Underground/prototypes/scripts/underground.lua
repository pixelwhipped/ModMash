require("prototypes.scripts.defines") 
local mod_gui = require("mod-gui")
local distance = mms2underground.util.distance
local table_contains = mms2underground.util.table.contains
local is_valid  = mms2underground.util.is_valid
local starts_with  = mms2underground.util.starts_with
local ends_with  = mms2underground.util.ends_with
local print  = mms2underground.util.print
local is_valid_and_persistant = mms2underground.util.entity.is_valid_and_persistant

local level_one_rock_prefix  = mms2underground.defines.names.level_one_rock_prefix
local dirt_prefix  = mms2underground.defines.names.dirt_prefix
local base_rock_names = mms2underground.defines.names.rock_names
local rock_names  = {}

--ok
local local_generate_rocks = function()
	for k=1, #base_rock_names do		
		table.insert(rock_names,base_rock_names[k])
		table.insert(rock_names,level_one_rock_prefix..base_rock_names[k])
	end
end
local_generate_rocks()

local fail_place_entity  = mms2underground.util.fail_place_entity
local dirt_prefix = mms2underground.defines.names.dirt_prefix

local force_player = mms2underground.util.defines.names.force_player
local force_enemy = mms2underground.util.defines.names.force_enemy
local force_neutral = mms2underground.util.defines.names.force_neutral

local surfaces = nil

--ok
local local_surface_top_name = function(name)
	if name == nil then return nil end
	local x = string.gsub(name, "-underground","")
	return x
end

--ok
local local_surface_bottom_name = function(name)
	if name == nil then return nil end
	if endswith(name,"-underground") then return name end
	return name.."-underground"
end

--review
local local_build_probability_table = function(res)
	local tbl = {}
	for k=1, #res do
		local c = math.ceil(res[k].probability*10)
		local name = res[k].name
		for j=1, c do
			table.insert(tbl,name)
		end
	end
	return tbl
end

--ok
local local_check_mineable = function(name)	
	if name == nil then return false end	
	if game.entity_prototypes[name] == nil then log("CHECK RESOURCE "..name .. " Prototype not found") return false end
	local resource = game.entity_prototypes[name]
	if resource.type ~= "resource" then log("CHECK RESOURCE "..name .. " Not a resource type") return false end
	if resource.mineable_properties == nil then log("CHECK RESOURCE "..name .. " mineable_properties missing") return false end
	if resource.mineable_properties.minable ~= true then log("CHECK RESOURCE "..name .. " mineable property is not true") return false end
	if resource.mineable_properties.mining_particle == nil then log("CHECK RESOURCE "..name .. " mining_particle property is missing") return false end
	if type(resource.mineable_properties.mining_time) ~= "number" then log("CHECK RESOURCE "..name .. " mining_time property is invalid") return false end
	if type(resource.map_color) == "nil" then log("CHECK RESOURCE "..name .. " map_color is missing") return false end
	for _, product in pairs(resource.mineable_properties.products) do
		if product.type ~= "item" then
			log("CHECK RESOURCE "..name .. " expected item product")
			return false
		end
	end
	return true
end

--ok
local local_register_resource_check = function(resource,surface)
	if resource == nil then log("REGISTER RESOURCE passed nil resource") return end
	if surface == nil then log("REGISTER RESOURCE passed nil surface") return end
	if type(surface) ~= "string" then log("REGISTER RESOURCE expected surface name as string") return end
	surface = local_surface_bottom_name(surface)
	if surfaces[surface] == nil then log("REGISTER RESOURCE surface "..surface.." not found") return end
	if type(resource.name) ~= "string" then log("REGISTER RESOURCE name string expected") return end
	if type(resource.probability) ~= "number" then log("REGISTER RESOURCE probability number expected") return end
	if local_check_mineable(resource.name) == false then log("REGISTER RESOURCE skipping "..resource.name) return end
	for k=1, #surfaces[surface].resources do
		if surfaces[surface].resources[k].name == resource.name then 
			surfaces[surface].resources[k] = resource
			return
		end
	end
	table.insert(surfaces[surface].resources,{name = resource.name, probability = math.min(resource.probability,1)})
	return
end


--ok
local local_register_resource = function(resource,surface)
	--slow but check resource the clean up any prior bad and rebeild probability table
	if resource == nil then return end
	if surface == nil then return end
	if type(surface) ~= "string" then return end
	surface = local_surface_bottom_name(surface)
	if surfaces[surface] == nil then return end
	local_register_resource_check = function(resource,surface)
	for k=#surfaces[surface].resources,1,-1 do res = surfaces[surface].resources[k]
		if local_check_mineable(res.name) == false then
			table.remove(surfaces[surface].resources,k)
		end
	end
	surfaces[surface].resources_table = local_build_probability_table(surfaces[surface].resources)
end


--ok
local local_ban_entity = function(entity,surface,top)
	if entity == nil then log("BAN ENTITY passed nil entity info") return end
	if surface == nil then log("BAN ENTITY passed nil surface") return end
	if type(surface) ~= "string" then log("BAN ENTITY expected surface name as string") return end
	if top == true then
		surface = local_surface_top_name(surface)
	else
		surface = local_surface_bottom_name(surface)
	end
	if surfaces[surface] == nil then log("BAN ENTITY surface "..surface.." not found") return end
	if type(entity.name) == "string" then 
		for k=1, #surfaces[surface].blocked_entities do
			if surfaces[surface].blocked_entities[k].name == entity.name then return end
		end
		table.insert(surfaces[surface].blocked_entities,{name=entity.name})
	elseif type(entity.type) == "string" then
		for k=1, #surfaces[surface].blocked_entities do
			if surfaces[surface].blocked_types[k].name == entity.type then return end
		end
		table.insert(surfaces[surface].blocked_types,{name=entity.type})
	else
		log("BAN ENTITY name or type string expected") 
		return 
	end
end

--ok
local local_ban_entity_top = function(entity,surface) local_ban_entity(entity,surface,true) end

--ok
local local_ban_entity_bottom = function(entity,surface) local_ban_entity(entity,surface,false) end

--ok
local local_register_surface = function(name,data)	
	if name == nil then return end		
	local top_name = local_surface_top_name(name)
	if surfaces[top_name] ~= nil then return end	
	local bottom_name = local_surface_bottom_name(name)
	if data == nil then data = {} end
	if data.resources == nil then data.resources = {} end
	if data.blocked_top == nil then data.blocked_top = {} end
	if data.blocked_bottom == nil then data.blocked_bottom = {} end

	local top_surface = {
		is_top = true,
		name = top_name,
		connected = bottom_name,
		origins = {},
		stops = {},
		combinators = {},
		super_stops = {},
		blocked_entities = {},
		blocked_types = {},
	}

	local bottom_surface = {
		is_top = false,
		name = botttom_name,
		connected = top_name,
		blocked_entities = {},
		blocked_types = {},
		resources = {},
		resources_table = {}
	}
	surfaces[top_name] = top_surface
	surfaces[bottom_name] = bottom_surface
	for k=1, #data.resources do
		local_register_resource(data.resources[k],bottom_name)
	end
	for k=1, #data.blocked_top do
		local_ban_entity_top(data.blocked_top[k],top_name)
	end
	for k=1, #data.blocked_bottom do
		local_ban_entity_bottom(data.blocked_bottom[k],bottom_name)
	end
end

--ok
local init_surface = function(surface,parent,daytime)
	surface.map_gen_settings = {
		autoplace_controls = {
		},
		default_enable_all_autoplace_controls = false,
		autoplace_settings = {
			entity = { frequency = "none" },
			tile = { frequency = "none" },
			decorative = { frequency = "none" }
		},
		water = "none",
		peaceful_mode = parent.map_gen_settings.peaceful_mode,
		starting_area = "none",
		terrain_segmentation = "none",
		width = parent.map_gen_settings.width,
		height = parent.map_gen_settings.height,
		starting_points = {},
		show_clouds = false,
		research_queue_from_the_start = parent.map_gen_settings.research_queue_from_the_start,
		property_expression_names = {
			cliffiness = 0,
			["tile:water:probability"] = -1000,
			["tile:deep-water:probability"] = -1000
		}
	}
	surface.peaceful_mode = parent.map_gen_settings.peaceful_mode	
	surface.daytime = daytime
	surface.freeze_daytime = true
	return surface
	end

--ok
local local_ensure_underground_environment = function(value)  
	local top = local_surface_top_name(value.name)
	if game.surfaces[top] == nil or surfaces[top] == nil then return end
	local bottom = local_surface_bottom_name(value.name)
	if not game.surfaces[bottom] and surfaces[bottom] ~= nil then
		init_surface(game.create_surface(value.bottom_name),game.surfaces[value.top_name],0.42)
	end
end


local get_circle_lines = function( centerX, centerY, radius)
	local points = {}
	local radStep = 1/(1.5*radius)
	for angle = 1, math.pi+radStep, radStep do
	local pX = math.cos( angle ) * radius * 1.5
	local pY = math.sin( angle ) * radius
	for i=-1,1,2 do
		for j=-1,1,2 do
			local y = math.floor((centerY + j*pY)+0.5)
			local x = math.floor((centerX + i*pX)+0.5)
			if points[y] == nil then
			points[y]={x,x}
			else
			local s = math.min(x,points[y][1],points[y][2])
			local e = math.max(x,points[y][1],points[y][2])
			points[y]={s,e}
			end
		end
		end
	end
	return points
	end

local get_sorted_lines = function(circle)
	local tkeys = {}
	local ret = {}
	for k in pairs(circle) do table.insert(tkeys, k) end
		table.sort(tkeys)
		local min = nil
		local max = nil
		for _, k in ipairs(tkeys) do 
			ret[k]=circle[k] 
			if min == nil then
				min = math.min(circle[k][1],circle[k][2])
				max = math.max(circle[k][1],circle[k][2])
			else
				min = math.min(min,circle[k][1])
				max = math.min(max,circle[k][2])
			end
		end
		return {ret,tkeys[1],tkeys[#tkeys],min,max}
	end

local generate_surface_area = function(x,y,r,surface)	
	local bottom_name = local_surface_bottom_name(surface.name)
	if surfaces[bottom_name] == nil then return end
	local cx, cy = math.floor(x / 32), math.floor(y / 32)
	if surface.is_chunk_generated({cx, cy}) ~= true then
		surface.request_to_generate_chunks({x, y}, r*2)
		surface.force_generate_chunk_requests()
	end

	local p = get_circle_lines(x,y,r)
	local d = get_sorted_lines(p)
	local rm = 0.25 + ((settings.global["setting-resource-mod"].value /100)*0.75)
    local amt = math.floor(math.random(800, 3200) * rm)
	local res_table = surfaces[bottom_name].resources_table

	local rnd = nil
	local erandmod = 1.5 + ((1-(settings.global["setting-resource-mod"].value /100))*2) --high less likley
	local erand = math.max(math.ceil(#res_table*erandmod))
	if erand == 1 then 
		rnd = 1 
	else
		rnd = math.random(1, erand)
	end

	p = d[1]
	for i=d[2],d[3] do
	  local str = ""
	  if p[i] ~= nil then
		local s = p[i][1]
		local e = p[i][2]
		for j =s,e do
		  local pos = {x = j, y = i }
		  local tile = dirt_prefix .. "dirt-"..math.random(1, 7)
		  local current_tile = surface.get_tile(pos)		  
		  local m = math.max((1-(distance(x,y,j,i)/r)),0.25)
		  m = ((math.random(40,100)/200)+0.5)*m
		  if j>s and j<e then
			if i == d[2] or i == d[3] then
			  --edge
			  if current_tile.name == "underground-out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})	
				surface.create_entity({ name = level_one_rock_prefix..base_rock_names[math.random(#base_rock_names)], position = pos,force = force_player })
			  end			  			  
			else
			  --inside
			  if current_tile.name == "underground-out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				local create = nil
				if rnd ~= nil and  rnd <= #res_table then
					local chk_res = res_table[rnd]
					create = {name=chk_res, amount=amt*m, position=pos}
				end 						
			  end
			end
		  elseif j==s or j == e then
		    --edge
				if current_tile.name == "underground-out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				surface.create_entity({ name = level_one_rock_prefix..base_rock_names[math.random(#base_rock_names)], position = pos })
			  end	
		  else 
			--nothing
		  end
		end
	  end
	endgenerate_surface_area_train
	end

local generate_surface_area_train = function(x,y,sd,surface)	
	local cx, cy = math.floor(x / 32), math.floor(y / 32)
	if surface.is_chunk_generated({cx, cy}) ~= true then
		surface.request_to_generate_chunks({x, y}, 20)
		surface.force_generate_chunk_requests()
	end
	for i = sd.clear_area.left_top.y-2, sd.clear_area.right_bottom.y+2 do
		
		for j = sd.clear_area.left_top.x-2, sd.clear_area.right_bottom.x+2 do
			local pos = {j, y = i }
			local tile = dirt_prefix .. "dirt-"..math.random(1, 7)
			local current_tile = surface.get_tile(pos)	
			
			if current_tile.name == "underground-out-of-map" then 
				surface.set_tiles({{ name = tile, position = pos }})
				if j == sd.clear_area.right_bottom.x +2
				or j == sd.clear_area.left_top.x -2
				or i == sd.clear_area.left_top.y -2
				or i == sd.clear_area.right_bottom.y +2
				then 
					local ent = surface.create_entity({ name = level_one_rock_prefix..base_rock_names[math.random(#base_rock_names)], position = pos, force = force_player })
				end
			end
		end
	end
	
	end

local local_check_surface = function(player)
	for name,value in pairs(surfaces) do
		if table_contains(value.origins,player.force) ~= true then
			local_ensure_underground_environment(value)
			if game.surfaces[name] ~= nil then
				table.insert(value.origins,player.force)
				local pos = player.force.get_spawn_position(game.surfaces[name])
	
				local rocks = game.surfaces[name].find_entities_filtered{area = {{pos.x-2.5, pos.y-2.5}, {pos.x+2.5, pos.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]				
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				generate_surface_area(pos.x, pos.y,6,game.surfaces[name])	
			end
		end
	end
end

local local_chunk_generated = function(event)  
	--todo replace with logic to add rocks at borders
	if is_map_editor == true then return end
	local area = event.area
	local surface = event.surface   
	local surface_reference = surfaces[surface.name]
	if surface_reference.is_top == true then return end

	for py = 0, 31, 1 do 
		for px = 0, 31, 1 do 
			local tile = "underground-out-of-map"
			y = py + area.left_top.y
			x = px + area.left_top.x
			local pos = { x = x, y = y }
			surface.set_tiles({{ name = tile, position = pos }})	  
		end
	end  
	local rnd = math.random(1,7)
	if rnd <= 3 then
		generate_surface_area(area.left_top.x+16,area.left_top.y+16,math.random(5,8),surface)
	end
end

--ok
local local_on_player_spawned = function(event)
	local player = game.get_player(event.player_index)
	if player == nil or player.character == nil then return end
	local_check_surface(player)
	end	

--ok
local local_cutscene_cancelled = function(event)
	if remote.interfaces["freeplay"] then 
		local_on_player_spawned(event)
	end
end

--ok
local local_get_camera = function(player)
	local frameflow = mod_gui.get_frame_flow(player)	
	local camera = frameflow.underground_camera
	if not camera then
		camera = frameflow.add{type = "frame", name = "underground_camera", style = "captionless_frame"}		
	end
	return camera
end

--ok
local local_safe_teleport = function(player, surface, position,index)
	if player and player.character then
		position = surface.find_non_colliding_position(
			player.character.name, player.character.position, 5, 0.5, false
		) or position
	end
	player.teleport(position, surface)
	local_get_camera(player).visible = false
end

--review
local local_do_teleport = function(i, p, access, upper_surface, lower_surface)
	if is_valid(p.character) and p.vehicle == nil and p.character.surface.name == upper_surface.name then
		if distance(p.character.position.x,p.character.position.y,access.top_entity.position.x,access.top_entity.position.y) < 1.5 then				
			local_safe_teleport(p, lower_surface,p.character.position,i)
		end
	elseif is_valid(p.character) and p.vehicle == nil and p.character.surface.name == lower_surface.name then
		if distance(p.character.position.x,p.character.position.y,access.bottom_entity.position.x,access.bottom_entity.position.y) < 1.5 then				
			local_safe_teleport(p, upper_surface,p.character.position,i)
		end
	end
end

--review
local local_shape_data = function(position,direction)
	
	if direction == 0 then
		local sd= {
			direction = 0,
			opposite_direction = 4,
			rail_direction = defines.rail_direction.front,
			clear_area = {
				left_top = {x=position.x-9,y=position.y-7},
				right_bottom = {x=position.x+5,y=position.y+12}
			},
			collide_area = {
				left_top = {x=position.x-6,y=position.y-5},
				right_bottom = {x=position.x+2,y=position.y+10}
			},
			end_track_area = {
				left_top = {x=position.x-3,y=position.y-1},
				right_bottom = {x=position.x-1,y=position.y+1.5}
			},
			end_track_point = {
				x=position.x-2,y=position.y+0.25
			},
			end_track_place = {
				x=position.x-2,y=position.y+6.25
			},
			new_end_track_place = {
				x=position.x-2,y=position.y+2.25
			},
			entry_track_area = {
				left_top = {x=position.x-3,y=position.y-1},
				right_bottom = {x=position.x-1,y=position.y+11}
			},
			exclude_zones = {
				{
					left_top = {x=position.x-6,y=position.y-5},
					right_bottom = {x=position.x+2,y=position.y-1}
				},
				{
					left_top = {x=position.x-6,y=position.y-1},
					right_bottom = {x=position.x-3,y=position.y+10}
				},
				{
					left_top = {x=position.x-1,y=position.y-1},
					right_bottom = {x=position.x+2,y=position.y+10}
				}
			},
			opposite_posistion = {x=position.x-4,y=position.y},
			track_posistion = {x=position.x-2,y=position.y},
			track_direction = 0,
			speed_vector = -1,
		}
		return sd
	elseif direction == 4 then
		local sd =  {
			direction = 4,
			opposite_direction = 0,
			rail_direction = defines.rail_direction.back,
			clear_area = {
				left_top = {x=position.x-5,y=position.y-12},
				right_bottom = {x=position.x+9,y=position.y+7}
			},
			collide_area = {
				left_top = {x=position.x-2,y=position.y-10},
				right_bottom = {x=position.x+6,y=position.y+5}
			},
			end_track_area = {
				left_top = {x=position.x+1,y=position.y-1},
				right_bottom = {x=position.x+3,y=position.y+1.5}
			},
			entry_track_area = {
				left_top = {x=position.x+1,y=position.y-11},
				right_bottom = {x=position.x+3,y=position.y+1.5}
			},
			end_track_point = {
				x=position.x+2,y=position.y+0.25
			},
			end_track_place = {
				x=position.x+2,y=position.y-5.75
			},
			new_end_track_place = {
				x=position.x+2,y=position.y-2.75
			},
			exclude_zones = {
				{
					left_top = {x=position.x-2,y=position.y+1.5},
					right_bottom = {x=position.x+6,y=position.y+5}
				},
				{
					left_top = {x=position.x-2,y=position.y-10},
					right_bottom = {x=position.x+1,y=position.y+1.5}
				},
				{
					left_top = {x=position.x+3,y=position.y-10},
					right_bottom = {x=position.x+6,y=position.y+1.5}
				}
			},
			opposite_posistion = {x=position.x+4,y=position.y},
			track_posistion = {x=position.x+2,y=position.y},
			track_direction = 0,
			speed_vector = 1,
		}
		return sd
	elseif direction == 2 then
		local sd = {
			direction = 2,
			opposite_direction = 6,
			rail_direction = defines.rail_direction.front,
			clear_area = {
				left_top = {x=position.x-12,y=position.y-8},
				right_bottom = {x=position.x+7,y=position.y+4}
			},
			collide_area = {
				left_top = {x=position.x-10,y=position.y-6},
				right_bottom = {x=position.x+5,y=position.y+2}
			},
			end_track_area = {
				left_top = {x=position.x-1.5,y=position.y-3},
				right_bottom = {x=position.x+1.25,y=position.y-1}
			},
			entry_track_area = {
				left_top = {x=position.x-11,y=position.y-3},
				right_bottom = {x=position.x+1.25,y=position.y-1}
			},
			end_track_point = {
				x=position.x,y=position.y-2
			},
			end_track_place = {
				x=position.x-6,y=position.y-2
			},
			new_end_track_place = {
				x=position.x-1.5,y=position.y-2
			},
			exclude_zones = {
				{
					left_top = {x=position.x+1.25,y=position.y-6},
					right_bottom = {x=position.x+5,y=position.y+2}
				},
				{
					left_top = {x=position.x-10,y=position.y-6},
					right_bottom = {x=position.x+1.25,y=position.y-3}
				},
				{
					left_top = {x=position.x-10,y=position.y-1},
					right_bottom = {x=position.x+1.25,y=position.y+2}
				}
			},
			opposite_posistion = {x=position.x,y=position.y-4},
			track_posistion = {x=position.x,y=position.y-2},
			track_direction = 2,
			speed_vector = -1,
		}
		return sd
	else --6
		local sd = {
			direction = 6,
			opposite_direction = 2,
			rail_direction = defines.rail_direction.back,
			clear_area = {
				left_top = {x=position.x-7,y=position.y-4},
				right_bottom = {x=position.x+12,y=position.y+8}
			},
			collide_area = {
				left_top = {x=position.x-5,y=position.y-2},
				right_bottom = {x=position.x+10,y=position.y+6}
			},
			end_track_area = {
				left_top = {x=position.x-1.25,y=position.y+1},
				right_bottom = {x=position.x+1.25,y=position.y+3}
			},
			entry_track_area = {
				left_top = {x=position.x-1.25,y=position.y+1},
				right_bottom = {x=position.x+11,y=position.y+3}
			},
			end_track_point = {
				x=position.x,y=position.y+2
			},
			end_track_place = {
				x=position.x+6,y=position.y+2
			},
			new_end_track_place = {
				x=position.x+1.5,y=position.y+2
			},
			exclude_zones = {
				{
					left_top = {x=position.x-5,y=position.y-2},
					right_bottom = {x=position.x-1.25,y=position.y+6}
				},
				{
					left_top = {x=position.x-1.25,y=position.y-2},
					right_bottom = {x=position.x+10,y=position.y+1}
				},
				{
					left_top = {x=position.x-1.25,y=position.y+3},
					right_bottom = {x=position.x+10,y=position.y+6}
				}
			},
			opposite_posistion = {x=position.x,y=position.y+4},
			track_posistion = {x=position.x,y=position.y+2},
			track_direction = 2,
			speed_vector = 1,
		}
		return sd
	end
end

--review
local local_transfer_carrrige_state = function(from,to)
    local inventory = from.get_inventory(defines.inventory.fuel)
    if inventory ~= nil then
        local to_inventory = to.get_inventory(defines.inventory.fuel)
        for index=1,#inventory do 
            to_inventory[index].set_stack(inventory[index]);
        end
    end
    inventory = from.get_inventory(defines.inventory.burnt_result) --Maybe no but who know what people can do
    if inventory ~= nil then        
        local to_inventory = to.get_inventory(defines.inventory.burnt_result)
        for index=1,#inventory do 
            to_inventory[index].set_stack(inventory[index]);
        end
    end
    inventory = from.get_inventory(defines.inventory.cargo_wagon)
    if inventory ~= nil then
        local to_inventory = to.get_inventory(defines.inventory.cargo_wagon)
        if inventory.supports_filters() then
            for i = 1, #inventory do
                to_inventory.set_filter(i, inventory.get_filter(i))
            end
        end
        for index=1,#inventory do 
            to_inventory[index].set_stack(inventory[index]);
        end
        if inventory.supports_bar() then
            to_inventory.set_bar(inventory.get_bar())
        end     
    end
    inventory = from.get_inventory(defines.inventory.artillery_wagon_ammo)
    if inventory ~= nil then
        local to_inventory = to.get_inventory(defines.inventory.artillery_wagon_ammo)
        for index=1,#inventory do 
            to_inventory[index].set_stack(inventory[index]);
        end
    end
    local fluidbox = from.fluidbox
    if fluidbox ~= nil and #fluidbox > 0 then
        for i = 1, #fluidbox do
            if fluidbox[i] ~= nil and fluidbox[i].name ~= nil then
                to.fluidbox[i] = {
                    name = fluidbox[i].name,
                    amount  = fluidbox[i].amount,
                    temperature  = fluidbox[i].temperature 
                }
            end
        end
    end

    to.color = from.color
    to.health = from.health

    local driver = from.get_driver()
    if driver~= nil and driver.is_player() then
        --local opened = driver.opened      
        local_safe_teleport(driver,to.surface,to.position, driver.index)
        to.set_driver(driver)
        --if is_valid(opened) then opened.visible = true end
    end

    for k = 1, #from.train.passengers do passenger = from.train.passengers[k]
        if passenger~= nil and passenger.is_player() then   
           -- local opened = passenger.opened    
            local_safe_teleport(passenger,to.surface,to.position, passenger.index)
            to.set_driver(passenger)
            --if is_valid(opened) and opened.type == "cargo-wagon" then  end -- passenger.opened_self  = opened end
        end
    end


    if from.energy > 0 then
        to.energy = from.energy
        if from.burner then
            to.burner.currently_burning = from.burner.currently_burning
            to.burner.remaining_burning_fuel = from.burner.remaining_burning_fuel
        end
    end
    --todo check worked
	-- ya,now it work now.
    if from.grid then
        for _,fromEquip in pairs(from.grid.equipment) do
			to.grid.put{name=fromEquip.name,position=fromEquip.position};
			local toEquip=to.grid.get(fromEquip.position);
			
			
			--shield
			if(fromEquip.prototype.type=="energy-shield-equipment") then
				toEquip.shield=fromEquip.shield;
				--game.print(toEquip.shield);
			end
			--energy
			toEquip.energy=fromEquip.energy;
			--burner
			if(fromEquip.burner) then
				toEquip.burner.heat=fromEquip.burner.heat;

				for index=1,#fromEquip.burner.inventory do 
					toEquip.burner.inventory[index].set_stack(fromEquip.burner.inventory[index]);
				end
				for index=1,#fromEquip.burner.burnt_result_inventory do 
					toEquip.burner.burnt_result_inventory[index].set_stack(fromEquip.burner.burnt_result_inventory[index]);
				end
			end
			
			--modded thing? I got no idea.
		end
    end

    for player_index, id in pairs(global.mms2underground.train_ui) do
        if  from.unit_number == id then
            game.players[player_index].opened = to
        end
    end
end

--review
local local_get_train_heading = function(train)
	--0   = north  really 0.875 - 0.125
	--0.25 = east  really 0.125 - 0.375 
	--0.5 = south  really 0.375 - 0.625
	--0.75 = west  really 0.625 - 0.785
	local loco = false
	local locos = {}
	locos[0]=0 --north
	locos[2]=0 --east
	locos[4]=0 --south
	locos[6]=0 --west
	local wagons = {}
	wagons[0]=0 --north
	wagons[2]=0 --east
	wagons[4]=0 --south
	wagons[6]=0 --west
	for k=1,#train.carriages do local carriage = train.carriages[k]
		if is_valid(carriage) then
			--print(#train.carriages .." O = " ..carriage.orientation)
			if carriage.type == "locomotive" then
				loco = true
				--print(carriage.orientation)
				if carriage.orientation > 0.625 and carriage.orientation <= 0.875 then
					locos[6] = locos[6]+1								
				elseif carriage.orientation > 0.125 and carriage.orientation <= 0.375 then --carriage.orientation < 0.5 then
					locos[2] = locos[2]+1
				elseif carriage.orientation > 0.375 and carriage.orientation <= 0.625 then --carriage.orientation < 0.75 then
					locos[4] = locos[4]+1
				else --carriage.orientation > 0.875 and carriage.orientation <= 0.125 then --.carriage.orientation < 0.25 then
					locos[0] = locos[0]+1
				end
			elseif loco == false then
				if carriage.orientation > 0.625 and carriage.orientation <= 0.875 then
					wagons[6] = locos[6]+1
				elseif carriage.orientation > 0.125 and carriage.orientation <= 0.375 then --carriage.orientation < 0.5 then
					wagons[2] = wagons[2]+1
				elseif carriage.orientation > 0.375 and carriage.orientation <= 0.625 then --carriage.orientation < 0.75 then
					wagons[4] = wagons[4]+1
				else --carriage.orientation > 0.875 and carriage.orientation <= 0.125
					wagons[0] = wagons[0]+1
				end
			end
		end
	end
	local ords = {0,2,6,4}
	local seek = wagons
	if loco == true then seek = locos end
	local m = 0
	local r = 0
	
	for k = 1, #ords do
		dir=ords[k]
		value = seek[dir]
	--	print(dir.." "..value)
		if value>m then
			m=value
			r=dir
		end	
	end
	--if loco == false and #train.carriages>1 and r==2 then r = 6 end --no idea why
	if loco == false and #train.carriages>1 and r==6 then r = 6  --no idea why
	elseif loco == false and #train.carriages>1 and r==2 then r = 6 end --no idea why
	if loco == false and #train.carriages>1 and r==4 then r = 0 end--no idea why
	--elseif loco == false and #train.carriages>1 and r==0 then r = 4 end --no idea why
	
	--print("result "..r.." ----------------")
	
	return r
end

--review
local local_set_train_heading = function(train,heading,speed)
	--print("Requested "..heading.." ----------------")
	local current_heading = local_get_train_heading(train)
	
	if current_heading == heading then 		
		train.speed = speed 
	else
		train.speed = speed * -1
	end
end

--review
local local_train_transfers_tick = function()

	--todo check train has fully left out station before allowing back in
	for k = #global.mms2underground.train_transfers_clear, 1, -1 do
		local left = true
		local station = global.mms2underground.train_transfers_clear[k].station
		for j = 1, #global.mms2underground.train_transfers_clear[k].out_carriages do
			local c = global.mms2underground.train_transfers_clear[k].out_carriages[j]
			if is_valid(c) and is_valid(station) and c.surface.find_entity(station.name, c.position) == station then
				left = false
				break
			end
		end
		if left == true then			
			table.remove(global.mms2underground.train_transfers_clear,k)
		end
	end

	--if mms2underground.defines.trains ~= true then return end
	if #global.mms2underground.train_transfers == 0 then return end
	
	for t = #global.mms2underground.train_transfers,1, -1 do
		local transfer = global.mms2underground.train_transfers[t]
		if transfer==nil then --bad transfer
			table.remove(global.mms2underground.train_transfers,t) 
			return 
		end
		local in_carriages = transfer.in_carriages
		if in_carriages == nil or #in_carriages == 0 then --transfer complete
			local out_carriages = transfer.out_carriages
			local copy = {}
			if out_carriages ~= nil and #out_carriages>  0 then
				local carr
				for k = 1, #out_carriages do
					if is_valid(out_carriages[k]) then
						out_carriages[k].operable=true
						table.insert(copy,out_carriages[k])
					end
				end				
				--print(transfer.manual_mode )
				out_carriages[1].train.manual_mode = transfer.manual_mode 
				table.insert(global.mms2underground.train_transfers_clear,{out_carriages = copy,station = transfer.to})
			end
			table.remove(global.mms2underground.train_transfers,t)
		else
			
			local out_carriages = transfer.out_carriages
			local in_train = transfer.in_train
			local from = transfer.from
			local to = transfer.to
			if is_valid(from) == false or is_valid(to) == false then --if station removed
				if out_carriages ~= nil and #out_carriages>  0 then
					for k = #out_carriages, 1, -1 do
						if is_valid(out_carriages[k]) then
							out_carriages[k].operable=true
						else
							table.remove(out_carriages,k)
						end
					end
				end
				if in_carriages ~= nil and #in_carriages>  0 then
					for k = #in_carriages,1, -1 do
						if is_valid(in_carriages[k]) then
							in_carriages[k].operable=true
						else
							table.remove(in_carriages,k)
						end
					end
				end
				table.remove(global.mms2underground.train_transfers,t)
				return
			end
			
			local tosd = local_shape_data(to.position,to.direction)
			local fromsd = local_shape_data(from.position,from.direction)
			
			if transfer.speed == nil then transfer.speed = 0 end
			transfer.speed = math.min(transfer.speed + 0.01,0.5)
			--we are testing from last as it was sorted to be closeset is last however we still want 
			--to loop over in the event a carrige became invalid and needs to be removed.  first valid will break loop
			for k=#in_carriages,1,-1 do carriage = in_carriages[k]
				if is_valid(carriage) == true then					
					if distance(from.position.x,from.position.y,carriage.position.x,carriage.position.y) < 3.8 then
						local e = nil
						if transfer.new_mode == true then --todo remove eventually but required now to prevent breaking trains from old verion to new version
							if carriage.type == "locomotive" or carriage.type == "artillery-wagon" then
								e = to.surface.create_entity{name=carriage.name, direction=carriage.direction,orientation=carriage.orientation, position=tosd.new_end_track_place, force = carriage.force}
							else
								e = to.surface.create_entity{name=carriage.name, direction=carriage.direction, position=tosd.new_end_track_place, force = carriage.force}
							end
						else
							if carriage.type == "locomotive" or carriage.type == "artillery-wagon" then
								e = to.surface.create_entity{name=carriage.name, direction=carriage.direction,orientation=carriage.orientation, position=tosd.end_track_place, force = carriage.force}
							else
								e = to.surface.create_entity{name=carriage.name, direction=carriage.direction, position=tosd.end_track_place, force = carriage.force}
							end
						end
						if e ~= nil then 							
							--to transfer stuff player fuel resources grid
							e.connect_rolling_stock(defines.rail_direction.front)
							if e.train.schedule == nil then
								e.train.schedule = carriage.train.schedule
								--print("Before ".. carriage.train.schedule.current .. " " .. e.train.schedule.current)
								if e.train.schedule ~= nil and #e.train.schedule.records>0 then			
									
									local next = carriage.train.schedule.current 
									next = next + 1
									--print("update ".. carriage.train.schedule.current.. " " .. next)
									if next <= #e.train.schedule.records then
										e.train.go_to_station(next)
										--e.train.schedule.current = next
									else
										--e.train.schedule.current = 1
										e.train.go_to_station(1)
									end
									e.train.manual_mode = true
								end
								--print("After ".. carriage.train.schedule.current .. " " .. e.train.schedule.current)
							end
							table.insert(out_carriages,1,e)
							local_transfer_carrrige_state(carriage,e)
							carriage.disconnect_rolling_stock(defines.rail_direction.back)
							carriage.destroy({raise_destroy=false})
							table.remove(in_carriages,k)
						end
						break
					end
				else
					table.remove(in_carriages,k)
				end
			end
			transfer.in_train = nil
			for k = #in_carriages,1,-1 do				
				if is_valid(in_carriages[k].train) then
					local carriage = in_carriages[k]
					transfer.in_train = carriage.train
					local_set_train_heading(transfer.in_train,from.direction,0.2)
					break
				else
					table.remove(in_carriages.k)
				end
			end
			transfer.out_train = nil
			for k = #out_carriages, 1, -1 do				
				if is_valid(out_carriages[k]) and is_valid(out_carriages[k].train) then		
					local carriage = out_carriages[k]
					transfer.out_train = carriage.train
					local_set_train_heading(transfer.out_train,from.direction,0.2)
					break
				else
					table.remove(out_carriages,k)
				end
			end
		end
	end
end

--review
local local_stops_circuit_tick = function()	
	for k, entity in ipairs(global.mms2underground.combinator_disconections) do
        if entity.valid then
            if entity.type == "electric-pole" then
                for j=1,#entity.neighbours["copper"] do
                    if is_valid(entity.neighbours["copper"][j]) and starts_with(entity.neighbours["copper"][j].name,"underground-combinator-") then
                        entity.neighbours["copper"][j].disconnect_neighbour()
                    end
                end
            else
                entity.disconnect_neighbour()
            end
        end
    end
    global.mms2underground.combinator_disconections = {}
end

--ok
local local_take_nearby_pollution = function(surface, entity)
	local x = entity.position.x
	local y = entity.position.y

	local p = 0
	for i=-32,32,32 do
		for j=-32,32,32 do
			local pp = 0
			pp = surface.get_pollution{x + i, y + j}
			surface.pollute({x + i, y + j}, -pp)
			p = p + pp
		end
	end
	return p
end

--review
local local_underground_tick = function()	
	local_train_transfers_tick()
	local gsurfaces = game.surfaces
	local_stops_circuit_tick()

	for name, value in pairs(surfaces_top) do
		local bs= surfaces[value.bottom_name]
		local tss= gsurfaces[value.top_name]
		local bss = gsurfaces[value.bottom_name]
		local accesses = value.stops

		for index=1, #accesses do local access = accesses[index]
			if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
				local p = ((game.tick%300)==0 and local_take_nearby_pollution(bss, access.bottom_entity)) or 0
				if p > 0 then tss.pollute(access.top_entity.position, pollution*(settings.startup["setting-pollution-transfer-mod"].value/100))  end
			end
		end
	end
end

--ok
local local_add_rubble = function(pos,surface)
	for k=1, math.random(8,14) do
		local p = {x=pos.x-3 + math.random(1,6), y=pos.y-3 + math.random(1,6)}
		if ends_with(surface.name,"-underground") == true then
			surface.create_entity({name = level_one_rock_prefix..base_rock_names[math.random(#base_rock_names)], position = p,force = force_player })
		else
			surface.create_entity({name = base_rock_names[math.random(#base_rock_names)], position = p,force = force_player })
		end
	end
end

--review
local local_update_fake_stops = function(surface)
	local surface = surfaces[surface.name]
	if surface == nil then 
		return 
	end	
	local all_surface_stops = {}
	local added_surface_stops = {}
	surface_list = {surface.top_name,surface.bottom_name}
	--reset
	for k=1, #surface_list do surface = surfaces[surface_list[k]]				
		if surface~=nil then
			
			if surface.super_stops == nil then surface.super_stops = {} end
			
			if surface.super_stops.fake_stops ~= nil then --kill existing an check status
				for j =1, #surface.super_stops.fake_stops do				
					surface.super_stops.fake_stops[j].destroy({raise_destroy=false})					
				end
			else
				surface.super_stops.fake_stops = {}
			end
			surface.super_stops.stop = nil
			local s = game.surfaces[surface_list[k]]
			local r = {}
			if is_valid(s) == true then
				local e = s.find_entities_filtered{name = {"subway-level-one"},force = force_player}
				if #e > 0 then					
					--this surface has a subway so it's adjacent level has access to its stops
					e = s.find_entities_filtered{type = "train-stop",force = force_player} 					
					for k=1, #e do local f = e[k]					
						if is_valid(f) == true and table_contains(r,f.backer_name) == false then 
							table.insert(r,f.backer_name)
						end
					end
				end
			end
			all_surface_stops[surface_list[k]] = r
			added_surface_stops[surface_list[k]] = {}
		end		
	end	
	--add bottom and top to middle
	--add middle and bottom to top
	--add top and middle to bottom
	surface_list = {
		{
			surface = surface.top_name,
			others = {surface.bottom_name}
		},
		{
			surface = surface.bottom_name,
			others = {surface.top_name}
		}
	}
	for k=1, #surface_list do 		
		--if there are stops on this surface then add to other surfaces
		if #all_surface_stops[surface_list[k].surface] > 0 and surfaces[surface_list[k].surface] ~= nil  then	
			--this is where it goes wrong because the top surface has stops containing it and underground 
			--and underground has stops containing it and dee-underground
			local super_stop = nil
			if ends_with(surface_list[k].surface,"-underground") then
				--the superstop must be first stop in top_surface bottom_entity
				local sn = surfaces[surface_list[k].surface].top_name
				local actual_surface = surfaces[sn]
				if #actual_surface.stops > 0 then 
					super_stop = actual_surface.stops[1].bottom_entity
				end
			else
				
				--the superstop must be first stop in top_surface top_entity
				local sn = surfaces[surface_list[k].surface].top_name
				local actual_surface = surfaces[sn]				
				if #actual_surface.stops > 0 then 
					super_stop = actual_surface.stops[1].top_entity
				end
			end		
			if is_valid(super_stop) == true then
				if added_surface_stops[super_stop.surface.name] == nil then
					added_surface_stops[super_stop.surface.name]  = {}
				end
				surfaces[surface_list[k].surface].super_stops.stop = super_stop
				for j = 1, #surface_list[k].others do
					for m = 1, #all_surface_stops[surface_list[k].others[j]] do
						local surface_stops = all_surface_stops[surface_list[k].others[j]]
						for n = 1, #surface_stops do
							--add check name dose not exist on surface and not already added
							--not already added need test condition for this surface
							--destroy not working didnt
							if table_contains(added_surface_stops[super_stop.surface.name],surface_stops[n]) == false then
								
								local sd = local_shape_data(super_stop.position,super_stop.direction)
								local e = super_stop.surface.create_entity{name = "fake-stop", position = super_stop.position, direction= sd.opposite_direction, force = force_player}
								e.backer_name = surface_stops[n]
								table.insert(surfaces[surface_list[k].surface].super_stops.fake_stops,e)
								table.insert(added_surface_stops[super_stop.surface.name],surface_stops[n])
							end
						end
						
					end
				end
			end
		end
	end

end

--review
local local_underground_removed = function(entity,event,died)	
	if died ~= true then died = false end

	local surface = surfaces[entity.surface.name]
	if surface == nil then return end

	local stops = surfaces[surface.top_name].stops
	local combinators = surfaces[surface.top_name].combinators
	
	if mms2underground.removed_rocks == nil then mms2underground.removed_rocks = 0 end

	if entity.name == "underground-combinator-l1" then				
		for index, access in pairs(combinators) do
			if access.top_entity == entity then
				if died == true then
					local surface = access.bottom_entity.surface
					local pos = access.bottom_entity.position
					local name = access.bottom_entity.name
					access.bottom_entity.destroy()
					surface.create_entity{name = "small-remnants", position = pos, force = force_player}
					surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}
				else
					access.bottom_entity.destroy()
				end
				table.remove(combinators, index)				
				return
			elseif access.bottom_entity == entity then
				if died == true then
					local surface = access.top_entity.surface
					local pos = access.top_entity.position
					local name = access.top_entity.name
					access.top_entity.destroy()
					surface.create_entity{name = "small-remnants", position = pos, force = force_player}
					surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}
				else
					access.top_entity.destroy()
				end
				table.remove(combinators, index)				
				return
			end
		end	
	elseif entity.name == "subway-level-one" then				
		for index, access in pairs(stops) do
			if access.top_entity == entity then
				local surface = nil
				if died == true then
					surface = access.bottom_entity.surface
					local other_surface = access.top_entity.surface
					local pos = access.bottom_entity.position
					local dir = access.bottom_entity.direction
					local name = access.bottom_entity.name
					access.bottom_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
					surface.create_entity{ name = "entity-ghost", inner_name = name, direction = dir, position = pos, force = force_player}
				else
					local pos = access.bottom_entity.position
					surface = access.bottom_entity.surface
					local other_surface = access.top_entity.surface
					access.bottom_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
				end
				table.remove(stops, index)	
				local_update_fake_stops(surface)
				return
			elseif access.bottom_entity == entity then
				if died == true then
					surface = access.top_entity.surface
					local other_surface = access.bottom_entity.surface
					local pos = access.top_entity.position
					local name = access.top_entity.name
					local dir = access.top_entity.direction
					access.top_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
					surface.create_entity{ name = "entity-ghost", inner_name = name, direction=dir, position = pos, force = force_player}					
				else
					local pos = access.top_entity.position
					surface = access.top_entity.surface
					local other_surface = access.bottom_entity.surface
					access.top_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
				end
				table.remove(stops, index)	
				local_update_fake_stops(surface)
				return
			end
		end
	elseif surfaces[entity.surface.name].level == 1 then
		for k=1,#base_rock_names do
			if level_one_rock_prefix..base_rock_names[k] == entity.name then	
				mms2underground.removed_rocks = mms2underground.removed_rocks + 1
				generate_surface_area(entity.position.x, entity.position.y,2,entity.surface)
				break
			end		
		end
	end

	if mms2underground.removed_rocks > 999999 then
		for i = 1, #game.players do local p = game.players[i]
			p.unlock_achievement("hollow_earth")
		end	
	end
	end

--review
local local_test_train_surface = function(sd,surface,name)
	local tracks = surface.find_entities_filtered{area = {{sd.collide_area.left_top.x, sd.collide_area.left_top.y}, {sd.collide_area.right_bottom.x, sd.collide_area.right_bottom.y}}, type = "curved-rail"}			
	if #tracks > 0 then return false end
	for k=1, #sd.exclude_zones do local d= sd.exclude_zones[k]
		local tracks = surface.find_entities_filtered{area = {{d.left_top.x, d.left_top.y}, {d.right_bottom.x, d.right_bottom.y}}, name = name, invert=true}			
		for j=#tracks,1,-1 do
			if tracks[j] == nil or tracks[j].type == "item-entity" or tracks[j].type == "particle-source" or tracks[j].type == "corpse" or tracks[j].type == "resource" or tracks[j].type == "tree" or table_contains({level_one_attack_rock,level_two_attack_rock},tracks[j].name) or table_contains(rock_names,tracks[j].name) then
				table.remove(tracks,j)
			elseif tracks[j].type == "straight-rail" then
				if table_contains(surface.find_entities_filtered{area = {{sd.entry_track_area.left_top.x, sd.entry_track_area.left_top.y}, {sd.entry_track_area.right_bottom.x, sd.entry_track_area.right_bottom.y}}, name = "straight-rail"},tracks[j]) then
					table.remove(tracks,j)
				end
			end
		end
		if #tracks > 0 then return false end
	end	
end

--review
local local_can_place_by_stop = function(f,entity)
	local sd = local_shape_data(f.position,f.direction)
	local x = entity.position.x
	local y = entity.position.y
	for k=1, #sd.exclude_zones do local d= sd.exclude_zones[k]
		if not (x < d.left_top.x or x > d.right_bottom.x or y<d.left_top.y or y>d.right_bottom.y) then
			return false
		end
	end	
	return true
end

--review
local local_update_stop_name = function(from, to)
	if from.backer_name == to.backer_name then
		if starts_with(from.backer_name,"[virtual-signal=stop-signal-0-1]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-0%-1%]", "") 
		elseif starts_with(from.backer_name,"[virtual-signal=stop-signal-1-0]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-0%]", "") 
		elseif starts_with(from.backer_name,"[virtual-signal=stop-signal-2-1]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-1%]", "") 
		elseif starts_with(from.backer_name,"[virtual-signal=stop-signal-1-2]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-2%]", "") end

	end
	if ends_with(to.surface.name,"-underground") == true then		
		if from.name == "subway-level-one" then
			local x = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-0%-1%]", "")
			to.backer_name = "[virtual-signal=stop-signal-1-0]"..x 
		else
			local x = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-2%-1%]", "") 
			to.backer_name = "[virtual-signal=stop-signal-1-2]"..x
		end
	else
		local x = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-0%]", "") 
		to.backer_name = "[virtual-signal=stop-signal-0-1]"..x
	end
end

--review
local local_on_entity_renamed = function(event)
	if event == nil then return end
	if event.by_script == true then return end
	local entity = event.entity
	if is_valid(entity) == false then return end
	local surface = surfaces[entity.surface.name]
	if surface == nil then return end
	if entity.type == "train-stop" then		
		if entity.name == "subway-level-one" then
			if ends_with(entity.surface.name,"-underground") == true then
				local stops = surfaces[surface.top_name].stops
				for k=1, #stops do local s = stops[k]
					if s.bottom_entity == entity then
						local_update_stop_name(s.bottom_entity,s.bottom_entity)
						local_update_stop_name(s.bottom_entity,s.top_entity)
						local_update_fake_stops(entity.surface)
						break
					end
				end
			else
				local stops = surfaces[surface.top_name].stops
				
				for k=1, #stops do local s = stops[k]
					
					if s.top_entity == entity then	
						local_update_stop_name(s.top_entity,s.top_entity)
						local_update_stop_name(s.top_entity,s.bottom_entity)
						local_update_fake_stops(entity.surface)
						break
					end
				end
			end		
		end
	end
	end

	--review

--review
local local_add_stop = function(entity,next_surface)
	
	local sd = local_shape_data(entity.position,entity.direction)
	local osd = local_shape_data(sd.opposite_posistion,sd.opposite_direction)
	if local_test_train_surface(sd,entity.surface,entity.name) == false then return false end
	if local_test_train_surface(osd,next_surface,entity.name) == false then return false end
	local trees = next_surface.find_entities_filtered{area = {{osd.clear_area.left_top.x, osd.clear_area.left_top.y}, {osd.clear_area.right_bottom.x, osd.clear_area.right_bottom.y}}, type = "tree"}			
	for index=1, #trees do local r = trees[index]
		if is_valid(r) then 
			r.destroy({raise_destroy = true}) 
		end			
	end	

	local rocks = next_surface.find_entities_filtered{area = {{osd.clear_area.left_top.x, osd.clear_area.left_top.y}, {osd.clear_area.right_bottom.x, osd.clear_area.right_bottom.y}}, name = rock_names}			
	for index=1, #rocks do local r = rocks[index]
		if is_valid(r) then 
			r.destroy({raise_destroy = true}) 
		end			
	end	

	local attack_rock_name = level_one_attack_rock
	
	local rocks = next_surface.find_entities_filtered{area = {{osd.clear_area.left_top.x, osd.clear_area.left_top.y}, {osd.clear_area.right_bottom.x, osd.clear_area.right_bottom.y}}, name = attack_rock_name}			
	for index=1, #rocks do local r = rocks[index]
		if is_valid(r) then 
			r.destroy({raise_destroy = true}) 
		end			
	end	
	generate_surface_area_train(sd.opposite_posistion.x, sd.opposite_posistion.y,osd,next_surface)
	if entity.name=="entity-ghost" then
		return next_surface.can_place_entity{name=entity.ghost_name, position=sd.opposite_posistion, direction=osd.direction, force=entity.force}	
	else
		return next_surface.can_place_entity{name=entity.name, position=sd.opposite_posistion, direction=osd.direction, force=entity.force}	
	end
end

--review
local local_ensure_can_place_entity_inner = function(entity,event,surface)
	local etype = entity.type
	local ename = entity.name
	if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end

	if ename == "subway-level-one" or ename == "underground-combinator-l1" then 		
		if surface.level == 0 then			
			if ename == "subway-level-one" then	
				return local_add_stop(entity,game.surfaces[surface.bottom_name])		
			else				
				local rocks = game.surfaces[surface.bottom_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end			
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.bottom_name])
				return game.surfaces[surface.bottom_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
			end
		elseif entity.surface.name == surface.bottom_name then
			if ename == "underground-combinator-l1" then
				if game.surfaces[surface.top_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force} then
					return true
				end
			elseif ename == "subway-level-one" then
				return local_add_stop(entity,game.surfaces[surface.top_name])
			end
		end			

	elseif entity.type == "curved-rail" or entity.type == "straight-rail" or entity.type == "rail-signal" or entity.type == "rail-chain-signal" then	
		if mms2underground.defines.trains == true then
			local f = entity.surface.find_entity("subway-level-one",entity.position)
			if f ~= nil then
				return local_can_place_by_stop(f,entity)
			end
		end
	end

	return true
	end

--review
local local_ensure_can_place_entity = function(entity,event,surface)
	if global.mms2underground.banned_level_one ==nil then global.mms2underground.banned_level_one = {} end
	if global.mms2underground.banned_level_zero ==nil then global.mms2underground.banned_level_zero = {} end
	if local_ensure_can_place_entity_inner(entity,event,surface) then			
		local etype = entity.type
		local ename = entity.name
		if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
		if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end
		if surface.level == 1 and ((etype=="solar-panel" or etype == "rocket-silo") or table_contains(global.mms2underground.banned_level_one,entity.name)) then		
			fail_place_entity(entity,event,{"mms2underground.underground-placement-disallowed"})
			return false
		end
	else	
		fail_place_entity(entity,event,{"mms2underground.underground-placement-fail"})
		return false
	end
	return true
	end

--review
local local_underground_added_std = function(entity,event)			
	local surface = surfaces[entity.surface.name]
	if surface == nil then 
		if 	entity.name == "subway-level-one" then				
			fail_place_entity(entity,event,{"mms2underground.underground-placement-disallowed"})
		end
		return
	end

	local stops = surfaces[surface.top_name].stops
	local combinators = surfaces[surface.top_name].combinators

	local_ensure_underground_environment(surface)
	if local_ensure_can_place_entity(entity,event,surface) == false then 
		return
	end		
	if entity.name == "underground-combinator-l1" then 	
		entity.operable=false
		if surface.level == 0 then			
			local u = game.surfaces[surface.bottom_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
			table.insert(combinators,{bottom_entity = u, top_entity = entity})
			table.insert(global.mms2underground.combinator_disconections,u)
			table.insert(global.mms2underground.combinator_disconections,entity)
			entity.connect_neighbour(u)
			u.operable=false
		elseif surface.level == 1 then
			local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = entity.position, force = force_player}
			table.insert(combinators,{bottom_entity = entity, top_entity = u})
			table.insert(global.mms2underground.combinator_disconections,u)
			table.insert(global.mms2underground.combinator_disconections,entity)
			entity.connect_neighbour(u)
			u.operable=false
		end
	elseif entity.type == "electric-pole" then 		
		table.insert(global.mms2underground.combinator_disconections,entity)
	elseif entity.name == "subway-level-one" then 	
		local_update_stop_name(entity,entity)
		--entity.force = force_neutral
		if surface.level == 0 then
			print('A')
			--todo add tracks if required
			local sd = local_shape_data(entity.position,entity.direction)
			local u = game.surfaces[surface.bottom_name].create_entity{name = entity.name, position = sd.opposite_posistion, force = force_player, direction = sd.opposite_direction}				
			local_update_stop_name(entity,u)
			table.insert(stops,{bottom_entity = u, top_entity = entity})
			--entity.connect_neighbour(u)
			local_update_fake_stops(entity.surface)
		elseif surface.level == 1 then
			print('B')	
			local sd = local_shape_data(entity.position,entity.direction)
			local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = sd.opposite_posistion, force = force_player, direction = sd.opposite_direction}
			local_update_stop_name(entity,u)
			table.insert(stops,{bottom_entity = entity, top_entity = u})
			--entity.connect_neighbour(u)
			local_update_fake_stops(entity.surface)
		end
	end
	end

--ok
local local_underground_added = function(entity,event)
	if is_valid(entity) ~= true then return end	
	local_underground_added_std(entity,event)
end

--ok
local local_init = function() 
	if global.mms2underground.surfaces == nil then
		global.mms2underground.surfaces = {}
		local surfaces = require("surfaces")
		for name, value in pairs(surfaces) do
			local_register_surface(name,value)
		end
	end	
	if global.mms2underground.combinator_disconections == nil then global.mms2underground.combinator_disconections = {} end
	if global.mms2underground.train_transfers == nil then global.mms2underground.train_transfers = {} end
	if global.mms2underground.train_transfers_clear == nil then global.mms2underground.train_transfers_clear = {} end
	if global.mms2underground.train_ui == nil then global.mms2underground.train_ui = {} end	
	surfaces = global.mms2underground.surfaces
end

--ok
local local_load = function() 
	surfaces = global.mms2underground.surfaces
end

--ok
local local_show_camera = function(player,entity)
	local zoom = 0.1
	local camera = local_get_camera(player)
	local view = camera.view
	if view then
		view.position = entity.position
		view.surface_index = entity.surface.index
		view.zoom = zoom
		view.style.minimal_width = 350
		view.style.minimal_height = 350
	else
		local view = camera.add{type = "camera", name = "view", position = entity.position, surface_index = entity.surface.index, zoom = zoom}
		view.style.minimal_width = 350
		view.style.minimal_height = 350
	end
	camera.visible = true
end

local local_draw_debug_stop = function(stop,player,ttl)

		local sd = local_shape_data(stop.position,stop.direction)
		--print(stop.direction)
		if sd.clear_area ~= nil then
			local id = rendering.draw_rectangle
			{
				surface = stop.surface,
				players = {player},
				color = {r = 1, g = 0.1, b = 0, a = 0.1},
				draw_on_ground = true,
				width = 4,
				filled = false,
				target = entity,
				only_in_alt_mode = false,
				time_to_live = 60*ttl,
				left_top = sd.clear_area.left_top,
				right_bottom  = sd.clear_area.right_bottom 
			}
		end
		if sd.collide_area ~= nil then
			local id = rendering.draw_rectangle
			{
				surface = stop.surface,
				players = {player},
				color = {r = 0.0, g = 0.0, b = 1.0, a = 0.1},
				draw_on_ground = true,
				width = 4,
				filled = false,
				target = entity,
				only_in_alt_mode = false,
				time_to_live = 60*ttl,
				left_top = sd.collide_area.left_top,
				right_bottom  = sd.collide_area.right_bottom 
			}
		end
		
		
		if sd.entry_track_area ~= nil then
			local id = rendering.draw_rectangle
			{
				surface = stop.surface,
				players = {player},
				color = {r = 0.5, g = 0.5, b = 1.0, a = 0.1},
				draw_on_ground = true,
				width = 4,
				filled = false,
				target = entity,
				only_in_alt_mode = false,
				time_to_live = 60*ttl,
				left_top = sd.entry_track_area.left_top,
				right_bottom  = sd.entry_track_area.right_bottom 
			}
		end

		if sd.end_track_area ~= nil then
			local id = rendering.draw_rectangle
			{
				surface = stop.surface,
				players = {player},
				color = {r = 0.0, g = 1.0, b = 1.0, a = 0.1},
				draw_on_ground = false,
				width = 4,
				filled = false,
				target = entity,
				only_in_alt_mode = false,
				time_to_live = 60*ttl,
				left_top = sd.end_track_area.left_top,
				right_bottom  = sd.end_track_area.right_bottom 
			}
		end
		if sd.end_track_point ~= nil then
			local id = rendering.draw_circle
			{
				surface = stop.surface,
				players = {player},
				color = {r = 0.0, g = 1.0, b = 1.0, a = 0.1},
				draw_on_ground = false,
				width = 4,
				filled = false,
				target = entity,
				only_in_alt_mode = false,
				time_to_live = 60*ttl,
				radius = 0.5,
				target = sd.end_track_point
			}
		end
		if sd.exclude_zones ~= nil then
			for k=1, #sd.exclude_zones do local d= sd.exclude_zones[k]
				local id = rendering.draw_rectangle
				{
					surface = stop.surface,
					players = {player},
					color = {r = 0.5, g = 0.0, b = 0.5, a = 0.1},
					draw_on_ground = false,
					width = 4,
					filled = true,
					target = entity,
					only_in_alt_mode = false,
					time_to_live = 60*ttl,
					left_top = d.left_top,
					right_bottom  = d.right_bottom 
				}
			end
		end
	end

--ok
local local_on_selected_entity_changed = function(event)
	local player = game.players[event.player_index]
	local selected = player.selected
	if selected ~= nil and selected.name == "subway-level-one" then

		local surface = selected.surface
		if surface == nil then return end
		local top = local_surface_top_name(surface.name)
		local s = surfaces[top]
		if not s then return end
		local stops = surfaces[top].stops

		for index, stop in pairs(stops) do
			if stop.top_entity == selected then
				local_show_camera(player,stop.bottom_entity)
				return
			elseif stop.bottom_entity == selected then
				local_show_camera(player,stop.top_entity)
				return
			end
		end
	end
	local_get_camera(player).visible = false
end


local local_transport_train = function(train, from,to)
	--todo check train has fully left out station before allowing back in
	for k=1, #global.mms2underground.train_transfers_clear do
		if global.mms2underground.train_transfers_clear[k].out_carriages[1].train == train and
			(global.mms2underground.train_transfers_clear[k].station == to or global.mms2underground.train_transfers_clear[k].station == from) then
			return end -- we have not fully clear the destionation so cannot go back yet
	end

	for k=1, #global.mms2underground.train_transfers do
		if global.mms2underground.train_transfers[k].in_train == train or
			global.mms2underground.train_transfers[k].out_train == train then
			return end
	end
	local manual_mode = train.manual_mode

	local sd = local_shape_data(from.position,from.direction)
	
	local out_track = to.connected_rail
	if out_track == nil then 
		from.surface.create_entity{name="flying-text", position = from.position, text="No output track" , color={r=1,g=0.25,b=0.0}}
		train.manual_mode = true
		return
	end

	local current_tracks= train.get_rails()
	for k=1, #current_tracks do		
		local trk = out_track.get_connected_rail{rail_direction = sd.rail_direction, rail_connection_direction =  defines.rail_connection_direction.straight}
		out_track = trk
		if out_track == nil then
			from.surface.create_entity{name="flying-text", position = from.position, text="Insufficent straight output space" , color={r=1,g=0.25,b=0.0}}
			train.manual_mode = true
			return
		end
		local wagons = out_track.surface.find_entities_filtered{position=out_track.position, type={"locomotive","cargo-wagon","fluid-wagon","artillery-wagon"}}
		if #wagons > 0 then
			from.surface.create_entity{name="flying-text", position = from.position, text="Track blocked" , color={r=1,g=0.25,b=0.0}}
			train.manual_mode = true
			return
		end
	end
	local in_carriages = {}
	for k=1,#train.carriages do		
		train.carriages[k].operable=false
		table.insert(in_carriages,train.carriages[k])
		--need to sort  traversing in reverse  closest shoud be last as first to pop off
		table.sort(in_carriages, function(c1,c2) return distance(c1.position.x,c1.position.y,from.position.x,from.position.y) > distance(c2.position.x,c2.position.y,from.position.x,from.position.y) end)
	end
	train.manual_mode = true
	table.insert(global.mms2underground.train_transfers,
		{in_train = train, out_train = train,in_carriages = in_carriages, out_carriages = {}, from=from, to=to, manual_mode =  manual_mode, new_mode = true}
	)
end

local local_on_train_changed_state = function(event)	
	
	local train = event.train
	local old_state = event.old_state
	if train.manual_mode == false and train.state == defines.train_state.arrive_signal and old_state ~= defines.train_state.arrive_signal then
	
	elseif train.manual_mode == false and train.state == defines.train_state.wait_station and old_state ~= defines.train_state.wait_station then
		if train.station ~= nil and train.station.name == "subway-level-one" then	
			
			local station = train.station
			local surface = surfaces[station.surface.name]
			if surface == nil then return end				
			if ends_with(station.surface.name,"-underground") == true then				
				local stops = surfaces[surface.top_name].stops
				for k=1, #stops do local s = stops[k]
					if s.bottom_entity == station then
						local_transport_train(train,s.bottom_entity,s.top_entity)
						break
					end
				end								
			else
				local stops = surfaces[surface.top_name].stops
				for k=1, #stops do local s = stops[k]
					if s.top_entity == station then
						local_transport_train(train,s.top_entity,s.bottom_entity)
						break
					end
				end
			end			
		end
	elseif train.manual_mode == true and train.state == defines.train_state.manual_control and train.speed == 0 then
		for k = 1, #event.train.carriages do
			local carriage = event.train.carriages[k]
			local station = carriage.surface.find_entity("subway-level-one",carriage.position)
			if station ~= nil then
				local surface = surfaces[station.surface.name]
				if surface == nil then return end	
				if ends_with(station.surface.name,"-underground") == true then				
					local stops = surfaces[surface.top_name].stops
					for k=1, #stops do local s = stops[k]
						if s.bottom_entity == station then
							local_transport_train(train,s.bottom_entity,s.top_entity)
							break
						end
					end												
				else
					local stops = surfaces[surface.top_name].stops
					for k=1, #stops do local s = stops[k]
						if s.top_entity == station then
							local_transport_train(train,s.top_entity,s.bottom_entity)
							break
						end
					end
				end	
			end
		end
	end
end

script.on_event(defines.events.on_entity_renamed, local_on_entity_renamed)

script.on_event(defines.events.on_train_changed_state, local_on_train_changed_state)

script.on_init(local_init)
script.on_load(local_load)
script.on_event({defines.events.on_player_joined_game,defines.events.on_player_created},local_on_player_spawned)
script.on_event(defines.events.on_cutscene_cancelled,local_cutscene_cancelled)
script.on_event(defines.events.on_chunk_generated,local_chunk_generated)
script.on_nth_tick(30, local_accumulators_tick)
script.on_event(defines.events.on_tick, local_underground_tick)


--ok
script.on_event(defines.events.on_gui_opened, function(event)
    local entity = event.entity
    if is_valid(entity) ~= true then return end
    if entity.type == "locomotive" or entity.type == "cargo-wagon" or entity.type == "fluid-wagon" or entity.type == "artillery-wagon" then
        global.mms2underground.train_ui[event.player_index] = entity.unit_number
    end
	end)

--ok
script.on_event(defines.events.on_gui_closed, function (event)
    local entity = event.entity
	if is_valid(entity) ~= true then return end
    if entity.type == "locomotive" or entity.type == "cargo-wagon" or entity.type == "fluid-wagon" or entity.type == "artillery-wagon" then
        global.mms2underground.train_ui[event.player_index] = nil
    end
	end)

--ok
script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event,true) end 
	end)

--ok
script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event,false) end 
	end)

--ok
script.on_event(defines.events.script_raised_destroy,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event,false) end 
	end)

--ok	
script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event,false) end 
	end)

--ok
script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_underground_added(event.entity,event) end 
	end)

--ok
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_underground_added(event.created_entity,event) end 
	end)

--ok
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_underground_added(event.created_entity,event) end 
	end)

--ok
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_underground_added(event.entity,event) end 
	end)

--ok
script.on_event(defines.events.on_selected_entity_changed, local_on_selected_entity_changed)
--[[
	The event contains the following:

player_index :: Types/uint32
tick :: Types/uint32
input_name :: Types/string: The name of the custom input.
cursor_position :: Types/Position: The mouse cursor position when the input was activated.
selected_prototype :: Types/table (optional): Provided if include_selected_prototype is true. This table has the following members:
base_type :: Types/string: E.g. "entity".
derived_type :: Types/string: E.g. "tree".
name :: Types/string: E.g. "tree-05".
]]
local local_check_teleport_event = function(event)
	local p = game.players[event.player_index]
	if p.valid and p.character ~= nil then
		local character = p.character
		local found_access = character.surface.find_entities_filtered{position=character.position,radius=11, name={"subway-level-one"}}
		if #found_access > 0 then
			local gsurfaces = game.surfaces
			for name, value in pairs(surfaces_top) do
				local bs= surfaces[value.bottom_name]
				local tss= gsurfaces[value.top_name]
				local bss = gsurfaces[value.bottom_name]
				local accesses = value.stops				
				for index, access in ipairs(accesses) do 
				print(serpent.block(access))
					if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity) then
						local_do_teleport(i, p, access, tss, bss)
					end
				end
			end
		end
	end	
end

script.on_event("enter-subway-input", local_check_teleport_event)

--ok	
remote.add_interface("mms2underground",
	{
		register_surface = local_register_surface,
		register_resource = local_register_resource,
		ban_entity_top = local_ban_entity_top,
		ban_entity_bottom = local_ban_entity_bottom
	})