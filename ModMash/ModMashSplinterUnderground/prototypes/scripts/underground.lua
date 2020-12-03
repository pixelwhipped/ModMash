require("prototypes.scripts.defines") 
require("mod-gui")
local distance = modmashsplinterunderground.util.distance
local table_contains = modmashsplinterunderground.util.table.contains
local is_valid  = modmashsplinterunderground.util.is_valid
local starts_with  = modmashsplinterunderground.util.starts_with
local print  = modmashsplinterunderground.util.print
local is_valid_and_persistant = modmashsplinterunderground.util.entity.is_valid_and_persistant

local level_one_rock_prefix  = modmashsplinterunderground.defines.names.level_one_rock_prefix
local level_two_rock_prefix  = modmashsplinterunderground.defines.names.level_two_rock_prefix
local dirt_prefix  = modmashsplinterunderground.defines.names.dirt_prefix
local base_rock_names = modmashsplinterunderground.defines.names.rock_names
local level_one_attack_rock = modmashsplinterunderground.defines.names.level_one_attack_rock
local level_two_attack_rock = modmashsplinterunderground.defines.names.level_two_attack_rock
local rock_names  = {}
local local_generate_rocks = function()
	for k=1, #base_rock_names do		
		table.insert(rock_names,base_rock_names[k])
		table.insert(rock_names,level_one_rock_prefix..base_rock_names[k])
		table.insert(rock_names,level_two_rock_prefix..base_rock_names[k])
	end
end
local_generate_rocks()

local underground_accumulator  = modmashsplinterunderground.defines.names.underground_accumulator
local underground_access  = modmashsplinterunderground.defines.names.underground_access
local underground_access2  = modmashsplinterunderground.defines.names.underground_access2
local battery_cell = modmashsplinterunderground.defines.names.battery_cell
local used_battery_cell = modmashsplinterunderground.defines.names.used_battery_cell
local fail_place_entity  = modmashsplinterunderground.util.fail_place_entity
local dirt_prefix = modmashsplinterunderground.defines.names.dirt_prefix

local force_player = modmashsplinterunderground.util.defines.names.force_player
local force_enemy = modmashsplinterunderground.util.defines.names.force_enemy
local force_neutral = modmashsplinterunderground.util.defines.names.force_neutral


local teleport_cooldown = 0
local surfaces = nil
local surfaces_top = nil
local resource_level_one = {}
local resource_level_two = {}


local banned_level_zero = {}
local banned_level_one = {}
local banned_level_two = {}

local local_register_surface = function(name)	
	if global.modmashsplinterunderground.surfaces[name] ~= nil then return end
	local top_surface = {
		level = 0,
		top_name = name,
		middle_name = name.."-underground",
		bottom_name = name.."-deep-underground",
		accumulators = {},
		accesses = {},
		origins = {},
		flip = true
	}
	global.modmashsplinterunderground.surfaces[name] = top_surface
	global.modmashsplinterunderground.surfaces_top[name] = top_surface
	global.modmashsplinterunderground.surfaces[name.."-underground"] = {
		level = 1,
		top_name = name,
		middle_name = name.."-underground",
		bottom_name = name.."-deep-underground",
		accumulators = {},
		accesses = {},
		origins = {},
		flip = true
	}
	global.modmashsplinterunderground.surfaces[name.."-deep-underground"] = {
		level = 2,
		top_name = name,
		middle_name = name.."-underground",
		bottom_name = name.."-deep-underground",
		accumulators = {},
		accesses = {},
		origins = {},
		flip = true
	}
end

local local_register_resource_level_one = function(resource)
	if resource == nil or type(resource.name) ~= "string" or type(resource.probability) ~= "number" then return end
	for k=1, #resource_level_one do
		if resource_level_one[k].name == resource.name then return end
	end
	table.insert(resource_level_one,{name = resource.name, probability = math.min(resource.probability,1)})
end
local local_register_resource_level_two = function(resource)
	if resource == nil or type(resource.name) ~= "string" or type(resource.probability) ~= "number" then return end
	for k=1, #resource_level_two do
		if resource_level_two[k].name == resource.name then return end
	end
	table.insert(resource_level_two,{name = resource.name, probability = math.min(resource.probability,1)})
end

local local_register_resources = function()
	if settings.startup["setting-resource-detection"].value == "Experimental" then
		local list = {}
		local sum = 0
		local max = 0
		for k, v in pairs(game.entity_prototypes) do 
			if v.type == "resource" and starts_with(v.name,"creative") == false then
				if v.mineable_properties ~= nil and v.mineable_properties.minable == true and 
					v.mineable_properties.mining_particle ~= nil and
					type(v.mineable_properties.mining_time) == "number" then
					local pass = 0
					for _, product in pairs(v.mineable_properties.products) do
						if product.type == "fluid" then pass = 2 end
						if product.type == "item" and pass ~= 2 then
							pass = 1
						end
					end
					if pass == 1 then
						if v.map_color ~= nil then
							sum = sum + v.mineable_properties.mining_time
							if v.mineable_properties.mining_time > max then max = v.mineable_properties.mining_time end
							table.insert(list,{name = v.name, probability = v.mineable_properties.mining_time})
						end
					end
				end
			end					
		end
		if sum > 0 then
			local d=1/max
			for k=1 , #list do
				local_register_resource_level_one({name = list[k].name, probability = (sum/list[k].probability)*d})
				local_register_resource_level_two({name = list[k].name, probability = (sum/list[k].probability)*d})
			end
		else
			local_register_resource_level_one({name = "uranium-ore", probability = 0.15})
			local_register_resource_level_one({name = "iron-ore", probability = 0.4})
			local_register_resource_level_one({name = "copper-ore", probability = 0.4})
			local_register_resource_level_one({name = "coal", probability = 0.25})

			local_register_resource_level_two({name = "uranium-ore", probability = 0.15})
			local_register_resource_level_two({name = "iron-ore", probability = 0.4})
			local_register_resource_level_two({name = "copper-ore", probability = 0.4})
			local_register_resource_level_two({name = "coal", probability = 0.3})
			local_register_resource_level_two({name = "stone", probability = 0.25})
		end
	else
		local_register_resource_level_one({name = "uranium-ore", probability = 0.15})
		local_register_resource_level_one({name = "iron-ore", probability = 0.4})
		local_register_resource_level_one({name = "copper-ore", probability = 0.4})
		local_register_resource_level_one({name = "coal", probability = 0.25})

		local_register_resource_level_two({name = "uranium-ore", probability = 0.15})
		local_register_resource_level_two({name = "iron-ore", probability = 0.4})
		local_register_resource_level_two({name = "copper-ore", probability = 0.4})
		local_register_resource_level_two({name = "coal", probability = 0.3})
		local_register_resource_level_two({name = "stone", probability = 0.25})
	end
end

local local_ban_entity_level_zero = function(name)
	if name == nil or type(name) ~= "string" then return end
	for k=1, #banned_level_zero do
		if banned_level_zero[k] == name then return end
	end
	table.insert(banned_level_zero,name)
end

local local_ban_entity_level_one = function(name)
	if name == nil or type(name) ~= "string" then return end
	for k=1, #banned_level_one do
		if banned_level_one[k] == name then return end
	end
	table.insert(banned_level_one,name)
end

local local_ban_entity_level_two = function(name)
	if name == nil or type(name) ~= "string" then return end
	for k=1, #banned_level_two do
		if banned_level_two[k] == name then return end
	end
	table.insert(banned_level_two,name)
end

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

local local_ensure_underground_environment = function(value)  
	if game.surfaces[value.top_name] ~= nil then
		if not game.surfaces[value.middle_name] then
			init_surface(game.create_surface(value.middle_name),game.surfaces[value.top_name],0.34)
		end
		if not game.surfaces[value.bottom_name] then
			init_surface(game.create_surface(value.bottom_name),game.surfaces[value.top_name],0.42)
		end
	end
	end

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

local generate_surface_area = function(x,y,r,surface, res, allow_mixed, rock_prefix,force_first_rock)	
	local cx, cy = math.floor(x / 32), math.floor(y / 32)
	if surface.is_chunk_generated({cx, cy}) ~= true then
		surface.request_to_generate_chunks({x, y}, r*2)
		surface.force_generate_chunk_requests()
	end
	local p = get_circle_lines(x,y,r)
	local d = get_sorted_lines(p)
	
    local amt = math.random(800, 3200)
	local res_table =  local_build_probability_table(res)
	local rnd = math.random(1, math.ceil(#res_table*1.5))
	local attack_rocks = math.random(1,5)

	local mixed = math.random(1,6)
	local biter = math.random(1,45)
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
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				if force_first_rock ~= nil or (attack_rocks > 0 and math.random(1,10) > 4 and #surface.find_entities_filtered{area = {{pos.x-4.5, pos.y-4.5}, {pos.x+4.5, pos.y+4.5}}, name = {level_one_attack_rock,level_two_attack_rock}} < 1) then
					force_first_rock = nil
					local rname = level_one_attack_rock
					attack_rocks = attack_rocks - 1
					if rock_prefix == level_two_rock_prefix then rname = level_two_attack_rock end
					local ent = surface.create_entity({ name = rname, position = pos, force = force_player })
					if ent ~= nil then
						ent.active = false
						ent.backer_name = ""
					end
				else			
					surface.create_entity({ name = rock_prefix..base_rock_names[math.random(#base_rock_names)], position = pos,force = force_player })
				end
			  end			  			  
			else
			  --inside
			  if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				local create = nil
				if rnd <= #res_table then
					if allow_mixed and mixed == 1 then
						create = {name=res_table[math.random(1,#res_table)], amount=(amt*m)*2, position=pos}
					else
						create = {name=res_table[rnd], amount=amt*m, position=pos}
					end
				end 						
				if create ~= nil then 
					surface.create_entity(create)
					if biter < 6 and x == j and y == i then	
						surface.create_entity({ name = "biter-spawner", position = pos })
					end
				else
					if biter < 6  and x == j and y == i then	
						surface.create_entity({ name = "biter-spawner", position = pos })
					end
				end
			  end
			end
		  elseif j==s or j == e then
		    --edge
				if current_tile.name == "out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})
				--add rock radar
				surface.create_entity({ name = rock_prefix..base_rock_names[math.random(#base_rock_names)], position = pos })
			  end	
		  else 
			--nothing
		  end
		end
	  end
	end
	end

local local_check_surface = function(player)
	for name,value in pairs(surfaces_top) do
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
				local res = resource_level_one
				local mixed = false
				local rock_prefix = level_one_rock_prefix
				if value.level==2 then
					res = resource_level_two 
					mixed = true
					rock_prefix = level_two_rock_prefix
				end
				generate_surface_area(pos.x, pos.y,6,game.surfaces[name],res,mixed,rock_prefix)	
			end
		end
	end
end

local local_chunk_generated = function(event)  
  if is_map_editor == true then return end
  local area = event.area
  local surface = event.surface   
  local surface_reference = surfaces[surface.name]
  if surface_reference.level ~= 0 then
	  for py = 0, 31, 1 do 
		for px = 0, 31, 1 do 
		  local tile = "out-of-map"
		  y = py + area.left_top.y
		  x = px + area.left_top.x
		  local pos = { x = x, y = y }
		  surface.set_tiles({{ name = tile, position = pos }})	  
		end
	  end  
	  local rnd = math.random(1,7)
	  if rnd <= 3 then
		local res = resource_level_one
		local mixed = false
		local rock_prefix = level_one_rock_prefix
		if surface_reference.level==2 then
			res = resource_level_two 
			rock_prefix = level_two_rock_prefix
			mixed = true
		end
		generate_surface_area(area.left_top.x+16,area.left_top.y+16,math.random(5,8),surface,res,mixed,rock_prefix)
	  end
  end
  end


local local_on_player_spawned = function(event)
	local player = game.get_player(event.player_index)
	if player == nil or player.character == nil then return end
	local_check_surface(player)
	end	

local local_cutscene_cancelled = function(event)
	if remote.interfaces["freeplay"] then 
		local_on_player_spawned(event)
	end
end

local local_accumulators_tick = function()			
	for name, value in pairs(surfaces_top) do --only on top and middle surface
		local accumulators = value.accumulators
		
		for index=1, #accumulators do local accumulator = accumulators[index]
			
			if is_valid_and_persistant(accumulator.bottom_entity) and is_valid_and_persistant(accumulator.top_entity)  then
				local e = accumulator.bottom_entity.energy + accumulator.top_entity.energy
				e = e / 2
				accumulator.bottom_entity.energy = e
				accumulator.top_entity.energy = e
			end
		end
	end
end

local function local_get_camera(player)
	local frameflow = mod_gui.get_frame_flow(player)	
	local camera = frameflow.underground_camera
	if not camera then
		camera = frameflow.add{type = "frame", name = "underground_camera", style = "captionless_frame"}		
	end
	return camera
end

local last_point = {}

local local_safe_teleport = function(player, surface, position,index)
	local last_pt_name = index..""	
	if player and player.character then
		position = surface.find_non_colliding_position(
			player.character.name, player.character.position, 5, 0.5, false
		) or position
	end
	player.teleport(position, surface)
	last_point[last_pt_name] = {x=math.floor(position.x),y=math.floor(position.y)}
	local_get_camera(player).visible = false
end

local local_bitter_follow = function(entity)
	local enemy = entity.surface.find_enemy_units(entity.position, 5)
	for i = 1, #enemy do local e = enemy[i]
		e.set_command({type=defines.command.go_to_location, destination=entity.position, distraction=defines.distraction.none})
	end
end

local local_access_process = function(access,pollution,flip,upper_surface,lower_surface)
	teleport_cooldown = teleport_cooldown -1
	if teleport_cooldown <= 0 then 
		for i = 1, #game.players do local p = game.players[i]
			local last_pt_name = i..""		
			local last_pt = last_point[last_pt_name]
			if last_pt ~= nil and distance(math.floor(p.character.position.x),math.floor(p.character.position.y),last_pt.x,last_pt.y) >= 1 then 
				last_point[last_pt_name] = nil
			elseif last_pt == nil then
				if is_valid(p.character) and p.character.surface.name == upper_surface.name and last_pos ~= p.character.position then
					if distance(p.character.position.x,p.character.position.y,access.top_entity.position.x,access.top_entity.position.y) < 1.5 then				
						local_safe_teleport(p, lower_surface,p.character.position,i)
						teleport_cooldown = 60
						last_pos = p.character.position
						local_bitter_follow(access.top_entity)
					end
				elseif is_valid(p.character) and p.character.surface.name == lower_surface.name and last_pos ~= p.character.position then
					if distance(p.character.position.x,p.character.position.y,access.bottom_entity.position.x,access.bottom_entity.position.y) < 1.5 then				
						local_safe_teleport(p, upper_surface,p.character.position,i)
						teleport_cooldown = 60
						last_pos = p.character.position
						local_bitter_follow(access.bottom_entity)
					end
				end
			end
		end		
	end
	if pollution > 0 then upper_surface.pollute(access.top_entity.position, pollution)  end

	local inventory = {}
	if flip then
		flip = false
		local top = access.top_entity.get_inventory(defines.inventory.chest)
		local bottom = access.bottom_entity.get_inventory(defines.inventory.chest)
		if top ~= nil and bottom ~= nil then
			for n, c  in pairs (top.get_contents()) do
				if n~=nil then				
					local ic = bottom.get_item_count(n)
					if (ic == nil or ic < c) and bottom.can_insert({name=n,count=1}) then
						bottom.insert({name=n,count=1})
						top.remove({name=n,count=1})
					end
				end
			end		
			for n, c  in pairs (bottom.get_contents()) do
				if n ~= nil then
				local ic = top.get_item_count(n)
					if (ic == nil or ic < c) and top.can_insert({name=n,count=1}) then
					top.insert({name=n,count=1})
					bottom.remove({name=n,count=1})
				end
				end
			end	
		end
	else
		flip = true
		local bottom = access.top_entity.get_inventory(defines.inventory.chest)
		local top = access.bottom_entity.get_inventory(defines.inventory.chest)
		if top ~= nil and bottom ~= nil then
			for n, c  in pairs (top.get_contents()) do
				if n~=nil then				
					local ic = bottom.get_item_count(n)
					if (ic == nil or ic < c) and bottom.can_insert({name=n,count=1}) then
						bottom.insert({name=n,count=1})
						top.remove({name=n,count=1})
					end
				end
			end		
			for n, c  in pairs (bottom.get_contents()) do
				if n ~= nil then
				local ic = top.get_item_count(n)
					if (ic == nil or ic < c) and top.can_insert({name=n,count=1}) then
					top.insert({name=n,count=1})
					bottom.remove({name=n,count=1})
				end
				end
			end	
		end
	end

	if game.tick%60==0 then
		local moved = {}
		local enemy = lower_surface.find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if is_valid(e) and upper_surface.can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
				local ne = upper_surface.create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
				ne.health = e.health
				table.insert(moved,ne)
				e.destroy()
			end
		end

		enemy = upper_surface.find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if is_valid(e) and table_contains(moved,e) == false and lower_surface.can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
				local ne = lower_surface.create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
				ne.health = e.health
				e.destroy()
			end
		end
	end		
	return flip
	end

local local_check_surfaces = function()
	for name,value in pairs(surfaces_top) do
		local_ensure_underground_environment(value)
	end
end
local started = false

local local_underground_tick = function()	
	if started == false then
		started = true
		local_register_resources()
		local_check_surfaces()
	end
	for name, value in pairs(surfaces_top) do
		local p = 0
		
		local ms= surfaces[value.middle_name]
		local bs= surfaces[value.bottom_name]
		local tss= game.surfaces[value.top_name]
		local mss = game.surfaces[value.middle_name]
		local bss = game.surfaces[value.bottom_name]
		local accesses = value.accesses
		local accesses2 = ms.accesses
		if bss and #accesses2 > 0 and #accesses > 0 then 
			p = p + bss.get_total_pollution()
			bss.clear_pollution()
		end
		if mss and #accesses > 0 then 
			p = p + mss.get_total_pollution()
			mss.clear_pollution()
		else

		end
		if p > 0 and #accesses > 0 then p = p/#accesses end

		for index=1, #accesses do local access = accesses[index]
			if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
				ms.flip = local_access_process(access,p,ms.flip,tss,mss)
			end
		end
		for index=1, #accesses2 do local access = accesses2[index]
			if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
				bs.flip = local_access_process(access,0,bs.flip,mss,bss)
			end
		end
	end
end


local local_underground_removed = function(entity,event,died)	

	if died ~= true then died = false end

	local surface = surfaces[entity.surface.name]
	if surface == nil then return end
	local accumulators = surfaces[surface.top_name].accumulators
	local accesses = surfaces[surface.top_name].accesses
	local accesses2 = surfaces[surface.middle_name].accesses
	if modmashsplinterunderground.removed_rocks == nil then modmashsplinterunderground.removed_rocks = 0 end

	if entity.name == underground_access then				
		for index, access in pairs(accesses) do
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
				table.remove(accesses, index)				
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
				table.remove(accesses, index)				
				return
			end
		end
	elseif entity.name == underground_access2 then				
		for index, access in pairs(accesses2) do
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
				table.remove(accesses2, index)				
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
				table.remove(accesses2, index)				
				return
			end
		end
	elseif entity.name == underground_accumulator then				
		for index, accumulator in pairs(accumulators) do
			if accumulator.top_entity == entity then
				if died == true then
					local surface = accumulator.bottom_entity.surface
					local pos = accumulator.bottom_entity.position
					local name = accumulator.bottom_entity.name
					accumulator.bottom_entity.destroy()
					surface.create_entity{name = "small-remnants", position = pos, force = force_player}
					surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}
				else
					accumulator.bottom_entity.destroy()
				end
				table.remove(accumulators, index)				
				return
			elseif accumulator.bottom_entity == entity then
				if died == true then
					local surface = accumulator.top_entity.surface
					local pos = accumulator.top_entity.position
					local name = accumulator.top_entity.name
					accumulator.top_entity.destroy()
					surface.create_entity{name = "small-remnants", position = pos, force = force_player}
					surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}
				else
					accumulator.top_entity.destroy()
				end
				table.remove(accumulators, index)				
				return
			end
		end
	elseif entity.name == battery_cell or entity.name == used_battery_cell then
			if is_valid(event.buffer) then
				if #event.buffer == 1 then
					local item = event.buffer[1]
					if item.type == "item-with-tags" then 	
						local e = (math.floor(((entity.energy)/100000)/5))*5
						item.set_tag("charge", e)
						item.custom_description = math.floor(e) .. "%"
					end
				end
			end
	elseif surfaces[entity.surface.name].level == 1 then
		if entity.name == level_one_attack_rock then
			modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
			generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,resource_level_one,false,level_one_rock_prefix, true)
		else
			for k=1,#base_rock_names do
				if level_one_rock_prefix..base_rock_names[k] == entity.name then	
					modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
				--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
					generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,resource_level_one,false,level_one_rock_prefix)
					break
				end		
			end
		end
	elseif surfaces[entity.surface.name].level == 2 then
		if entity.name == level_two_attack_rock then
			modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
			generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,resource_level_two,true,level_two_rock_prefix, true)
		else
			for k=1,#base_rock_names do
				if level_two_rock_prefix..base_rock_names[k] == entity.name then	
					modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
					--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
					generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,resource_level_two,true,level_two_rock_prefix)
					break
				end
			end
		end
	end
	if modmashsplinterunderground.removed_rocks > 999999 then
		for i = 1, #game.players do local p = game.players[i]
				p.unlock_achievement("hollow_earth")
			end	
		end
	end

local local_ensure_can_place_entity_inner = function(entity,event,surface)
	local etype = entity.type
	local ename = entity.name
	if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end

	if ename == underground_access or ename == underground_access2 or ename == underground_accumulator then 		
		if surface.level == 0 then			
			if ename == underground_access2 then return false end
			local rocks = game.surfaces[surface.middle_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
			for index=1, #rocks do local r = rocks[index]
				if is_valid(r) then 
					r.destroy({raise_destroy = true}) 
				end			
			end			
			--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
			generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.middle_name],resource_level_one,false,level_one_rock_prefix)
			return game.surfaces[surface.middle_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
		elseif entity.surface.name == surface.middle_name then
			if ename == underground_access or ename == underground_accumulator then
				if game.surfaces[surface.top_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force} then
					return true
				end
			elseif ename == underground_access2 then
				local rocks = game.surfaces[surface.bottom_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.bottom_name],resource_level_two,true,level_two_rock_prefix)
				return game.surfaces[surface.bottom_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
			end
		elseif entity.surface.name == surface.bottom_name then			
			if ename == underground_access2 then
				local rocks = game.surfaces[surface.middle_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.middle_name],resource_level_one,false,level_one_rock_prefix)
				return game.surfaces[surface.middle_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
			end
		end		
	end
	return true
	end

local local_ensure_can_place_entity = function(entity,event,surface)
	if local_ensure_can_place_entity_inner(entity,event,surface) then	
		
		local etype = entity.type
		local ename = entity.name
		if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
		if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end
		if surface.level == 1 and (etype=="solar-panel" or etype == "rocket-silo") or table_contains(banned_level_one,entity.name) then		
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			return false
		elseif surface.level == 2 and (entity.name == underground_accumulator or entity.name == underground_access or entity.type=="solar-panel" or entity.type == "rocket-silo") or table_contains(banned_level_two,entity.name) then
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			return false
		elseif surface.level == 0 and entity.name == underground_access2 or table_contains(banned_level_zero,entity.name) then
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			return false
		end
	else		
		fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-fail"})
		return false
	end
	return true
	end

local local_underground_added = function(entity,event)	
	
		if is_valid(entity) ~= true then return end	
		local surface = surfaces[entity.surface.name]
		if surface == nil then 
			if entity.name == battery_cell then	
				entity.energy = 10000000
			elseif entity.name == underground_access or 
				   entity.name == underground_access2 or entity.name == underground_accumulator then
			
				fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			end
			return
		end

		local accumulators = surfaces[surface.top_name].accumulators
		local accesses = surfaces[surface.top_name].accesses
		local accesses2 = surfaces[surface.middle_name].accesses
		
		local_ensure_underground_environment(surface)
		if local_ensure_can_place_entity(entity,event,surface) == false then 
			return
		end		

		if entity.name == underground_access then 	
			--entity.force = force_neutral
			if surface.level == 0 then
				local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
				table.insert(accesses,{bottom_entity = u, top_entity = entity})
			elseif surface.level == 1 then
				local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = entity.position, force = force_player}
				table.insert(accesses,{bottom_entity = entity, top_entity = u})
			end
		elseif entity.name == underground_access2 then 	
			--entity.force = force_neutral
			if surface.level == 1 then
				local u = game.surfaces[surface.bottom_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
				table.insert(accesses2,{bottom_entity = u, top_entity = entity})
			elseif surface.level == 2 then
				local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = force_player}
				table.insert(accesses2,{bottom_entity = entity, top_entity = u})
			end
		elseif entity.name == underground_accumulator then	
			if surface.level == 0 then
				local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = entity.force}
				table.insert(accumulators,{bottom_entity = u, top_entity = entity})
			elseif surface.level == 1 then
				local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = entity.position, force = entity.force}
				table.insert(accumulators,{bottom_entity = entity, top_entity = u})
			end
		elseif entity.name == battery_cell then	
			entity.energy = 10000000
		elseif entity.name == used_battery_cell and is_valid(event.stack) and event.stack.type == "item-with-tags" and event.stack.get_tag("charge") ~= nil then
			entity.energy = event.stack.get_tag("charge")*100000	
		end
	end

local local_standard_filter = {
	{filter = "name", name = underground_accumulator}, 
	{filter = "name", name = underground_access},
	{filter = "name", name = underground_access2},
	{filter = "name", name = battery_cell},
	{filter = "name", name = used_battery_cell},
	
}
local local_enemy_filter = { {filter = "type", type = "unit" },{filter = "type", type = "unit-spawner" }}


local local_surface_created = function(event)
	if settings.startup["setting-surface-detection"].value == "Experimental" then
		local s = game.surfaces[event.surface_index]
		if s ~= nil and 
				s.map_gen_settings~=nil and
				s.map_gen_settings.property_expression_names ~=nil and
				s.map_gen_settings.property_expression_names["tile:water:probability"] ~=nil and
				type(s.map_gen_settings.property_expression_names["tile:water:probability"]) == "number" and
				s.map_gen_settings.property_expression_names["tile:water:probability"] < -100 then
			local_register_surface(s.name) 
		end
	end
end

local local_register_loot = function()	
	if remote.interfaces["modmashsplinterloot"] ~= nil and remote.interfaces["modmashsplinterloot"]["register_loot"] ~= nil then
		local underground_loot = {
			{
				name = "underground_loot", probability = 0.1, 
				items = {
					{{name = underground_access ,max_stacks = 3, probability = 0.5},{name = underground_access2 ,max_stacks = 2, probability = 0.5}},
					{{name = underground_accumulator ,max_stacks = 6, probability = 0.5}}
				}
			},
			{
				name = "underground_loot_power", probability = 0.1, 
				items = {
					{{name = underground_accumulator ,max_stacks = 10, probability = 0.5}},
					{{name = battery_cell ,max_stacks = 10, probability = 0.5}}
				}
			}}
		for k = 1, #underground_loot do
			remote.call("modmashsplinterloot","register_loot",underground_loot[k])
		end
	end
end



local local_init = function() 
	if global.modmashsplinterunderground.surfaces == nil then
		global.modmashsplinterunderground.surfaces = {}
		global.modmashsplinterunderground.surfaces_top = {}
		local_register_surface("nauvis")
	end
	surfaces = global.modmashsplinterunderground.surfaces
	surfaces_top = global.modmashsplinterunderground.surfaces_top
	local_register_loot()
	end

local local_load = function() 
	surfaces = global.modmashsplinterunderground.surfaces
	surfaces_top = global.modmashsplinterunderground.surfaces_top
	end

local local_on_configuration_changed = function() 
	local_register_loot()
	end

local local_entity_damaged = function(event)
	if event.entity.force.name == force_enemy then
		local s  = surfaces[event.entity.surface.name]	
		if s ~= nil and s.level > 0 then
			if is_valid(event.cause) and event.cause.force.name == force_player then
				for _, enemy in pairs(event.cause.surface.find_enemy_units(event.entity.position, 12)) do
					enemy.set_command({type=defines.command.attack, target=event.cause, distraction=defines.distraction.none})	
				end
			end
		end
	end
	end



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

local local_on_selected_entity_changed = function(event)

	local player = game.players[event.player_index]
	local selected = player.selected
	if selected ~= nil then
		local surface = selected.surface
		if surface == nil then return end
		
		local s = surfaces[surface.name]
		local accesses = surfaces[s.top_name].accesses
		local accesses2 = surfaces[s.middle_name].accesses
	
		for index, access in pairs(accesses) do
			if access.top_entity == selected then
				local_show_camera(player,access.bottom_entity)
				return
			elseif access.bottom_entity == selected then
				local_show_camera(player,access.top_entity)
				return
			end
		end
		for index, access in pairs(accesses2) do
			if access.top_entity == selected then
				local_show_camera(player,access.bottom_entity)
				return
			elseif access.bottom_entity == selected then
				local_show_camera(player,access.top_entity)
				return
			end
		end
	end
	local_get_camera(player).visible = false
end


script.on_init(local_init)
script.on_load(local_load)
script.on_event({defines.events.on_player_joined_game,defines.events.on_player_created},local_on_player_spawned)
script.on_event(defines.events.on_cutscene_cancelled,local_cutscene_cancelled)
script.on_event(defines.events.on_chunk_generated,local_chunk_generated)
script.on_nth_tick(30, local_accumulators_tick)
script.on_event(defines.events.on_tick, local_underground_tick)
script.on_configuration_changed(local_on_configuration_changed)


script.on_event(defines.events.on_entity_damaged,
	function(event) 
		if is_valid(event.entity) then local_entity_damaged(event) end 
	end,local_enemy_filter)

script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event,true) end 
	end)

script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event) end 
	end)

script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_underground_removed(event.entity,event) end 
	end)


script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_underground_added(event.entity,event) end 
	end)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_underground_added(event.created_entity,event) end 
	end)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_underground_added(event.created_entity,event) end 
	end)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_underground_added(event.entity,event) end 
	end)

script.on_event(defines.events.on_surface_created,
	function(event) 
		if is_valid(event) then local_surface_created(event) end 
	end)

script.on_event(defines.events.on_selected_entity_changed, local_on_selected_entity_changed)


	
remote.add_interface("modmashsplinterunderground",
	{
		register_surface = local_register_surface,
		register_resource_level_one = local_register_resource_level_one,
		register_resource_level_two = local_register_resource_level_two,
		ban_entity_level_zero = local_ban_entity_level_zero,
		ban_entity_level_one = local_ban_entity_level_one,
		ban_entity_level_two = local_ban_entity_level_two
	})