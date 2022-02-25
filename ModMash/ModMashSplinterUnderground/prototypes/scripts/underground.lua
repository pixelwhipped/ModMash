require("prototypes.scripts.defines") 
local mod_gui = require("mod-gui")
local distance = modmashsplinterunderground.util.distance
local table_contains = modmashsplinterunderground.util.table.contains
local is_valid  = modmashsplinterunderground.util.is_valid
local starts_with  = modmashsplinterunderground.util.starts_with
local ends_with  = modmashsplinterunderground.util.ends_with
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
local underground_accessml  = modmashsplinterunderground.defines.names.underground_accessml
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
		stops = {},
		combinators = {},
		super_stops = {},
		flip = true,
		nests = 0,
		biters = 0
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
		stops = {},
		combinators = {},
		super_stops = {},
		flip = true,
		nests = 0,
		biters = 0
	}
	global.modmashsplinterunderground.surfaces[name.."-deep-underground"] = {
		level = 2,
		top_name = name,
		middle_name = name.."-underground",
		bottom_name = name.."-deep-underground",
		accumulators = {},
		accesses = {},
		origins = {},
		stops = {},
		combinators = {},
		super_stops = {},
		flip = true,
		nests = 0,
		biters = 0
	}
end

local local_check_mineable = function(name)
	if name == nil then return false end
	if global.modmashsplinterunderground.mineable_resources == nil then
		global.modmashsplinterunderground.mineable_resources = {}
		for k, v in pairs(game.entity_prototypes) do 
			if v.type == "resource" and starts_with(v.name,"creative") == false then
				if v.mineable_properties ~= nil and v.mineable_properties.minable == true and 
					v.mineable_properties.mining_particle ~= nil and
					type(v.mineable_properties.mining_time) == "number" then
					local pass = 0
					for _, product in pairs(v.mineable_properties.products) do
						if product.type == "item" then
							pass = 1
						end
					end
					if pass == 1 then
						if v.map_color ~= nil then
							global.modmashsplinterunderground.mineable_resources[v.name] = v.name
						end
					end
				end
			end					
		end
	end
	if global.modmashsplinterunderground.mineable_resources[name] == nil then return false end
	return true
end

local local_register_resource_level_one = function(resource)

	if global.modmashsplinterunderground.resource_level_one == nil then global.modmashsplinterunderground.resource_level_one = {} end
	if resource == nil or type(resource.name) ~= "string" or type(resource.probability) ~= "number" then return end
	if settings.startup["setting-exculude-se"].value == true and starts_with(resource.name,"se-") then return end
	if local_check_mineable(resource.name) == false then return end
	for k=1, #global.modmashsplinterunderground.resource_level_one do
		if global.modmashsplinterunderground.resource_level_one[k].name == resource.name then 
			local always = resource.always
			if always == nil then always = false end
			if global.modmashsplinterunderground.resource_level_one[k].always == nil or global.modmashsplinterunderground.resource_level_one[k].always == false then
				global.modmashsplinterunderground.resource_level_one[k].always = always
			end
			return 
		end
	end
	local always = resource.always
	if always == nil then always = false end

	table.insert(global.modmashsplinterunderground.resource_level_one,{name = resource.name, probability = math.min(resource.probability,1), always = always})

	--log(resource.name)
	--log(serpent.block(global.modmashsplinterunderground.resource_level_one))
end

local local_register_resource_level_two = function(resource)
	if global.modmashsplinterunderground.resource_level_two == nil then global.modmashsplinterunderground.resource_level_two = {} end
	if resource == nil or type(resource.name) ~= "string" or type(resource.probability) ~= "number" then return end
	if settings.startup["setting-exculude-se"].value == true and starts_with(resource.name,"se-") then return end
	if local_check_mineable(resource.name) == false then return end
	for k=1, #global.modmashsplinterunderground.resource_level_two do
		if global.modmashsplinterunderground.resource_level_two[k].name == resource.name then 
			local always = resource.always
			if always == nil then always = false end
			if global.modmashsplinterunderground.resource_level_two[k].always == nil or global.modmashsplinterunderground.resource_level_two[k].always == false then
				global.modmashsplinterunderground.resource_level_two[k].always = always
			end
			return 
		end
	end
	local always = resource.always
	if always == nil then always = false end
	table.insert(global.modmashsplinterunderground.resource_level_two,{name = resource.name, probability = math.min(resource.probability,1), always = always})
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
				local_register_resource_level_one({name = list[k].name, probability = (list[k].probability/sum)*d,always = false})
				local_register_resource_level_two({name = list[k].name, probability = (list[k].probability/sum)*d,always = false})
			end
		else
			local_register_resource_level_one({name = "uranium-ore", probability = 0.15,always = false})
			local_register_resource_level_one({name = "iron-ore", probability = 0.4,always = false})
			local_register_resource_level_one({name = "copper-ore", probability = 0.4,always = false})
			local_register_resource_level_one({name = "coal", probability = 0.25,always = false})

			local_register_resource_level_two({name = "uranium-ore", probability = 0.15,always = false})
			local_register_resource_level_two({name = "iron-ore", probability = 0.4,always = false})
			local_register_resource_level_two({name = "copper-ore", probability = 0.4,always = false})
			local_register_resource_level_two({name = "coal", probability = 0.3,always = false})
			local_register_resource_level_two({name = "stone", probability = 0.25,always = false})
		end
	else
		local_register_resource_level_one({name = "uranium-ore", probability = 0.15,always = false})
		local_register_resource_level_one({name = "iron-ore", probability = 0.4,always = false})
		local_register_resource_level_one({name = "copper-ore", probability = 0.4,always = false})
		local_register_resource_level_one({name = "coal", probability = 0.25,always = false})

		local_register_resource_level_two({name = "uranium-ore", probability = 0.15,always = false})
		local_register_resource_level_two({name = "iron-ore", probability = 0.4,always = false})
		local_register_resource_level_two({name = "copper-ore", probability = 0.4,always = false})
		local_register_resource_level_two({name = "coal", probability = 0.3,always = false})
		local_register_resource_level_two({name = "stone", probability = 0.25,always = false})
	end
end

local local_ban_entity_level_zero = function(name)
	if global.modmashsplinterunderground.banned_level_zero == nil then global.modmashsplinterunderground.banned_level_zero = {} end
	if name == nil or type(name) ~= "string" then return end
	for k=1, #global.modmashsplinterunderground.banned_level_zero do
		if global.modmashsplinterunderground.banned_level_zero[k] == name then return end
	end
	table.insert(global.modmashsplinterunderground.banned_level_zero,name)
end

local local_ban_entity_level_one = function(name)
	if global.modmashsplinterunderground.banned_level_one == nil then global.modmashsplinterunderground.banned_level_one = {} end
	if name == nil or type(name) ~= "string" then return end
	for k=1, #global.modmashsplinterunderground.banned_level_one do
		if global.modmashsplinterunderground.banned_level_one[k] == name then return end
	end
	table.insert(global.modmashsplinterunderground.banned_level_one,name)
end

local local_ban_entity_level_two = function(name)
	if global.modmashsplinterunderground.banned_level_two == nil then global.modmashsplinterunderground.banned_level_two = {} end
	if name == nil or type(name) ~= "string" then return end
	for k=1, #global.modmashsplinterunderground.banned_level_two do
		if global.modmashsplinterunderground.banned_level_two[k] == name then return end
	end
	table.insert(global.modmashsplinterunderground.banned_level_two,name)
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

local is_valid_surface_resource = function(s,r)
	if s==nil or s.map_gen_settings == nil or s.map_gen_settings.autoplace_controls == nil then return false end	
	for name, value in pairs(s.map_gen_settings.autoplace_controls) do
		--log(name)
		if name == r then
			if value.frequency ~= nil and value.frequency > 0
				and value.richness ~= nil and value.richness > -1
				and value.size ~= nil and value.size > 0 then
				return true 
			end
		end
	end
	return false
	end		

local allow_resource_by_parent = function(res,surface)
	local value = surfaces[surface.name]
	--log(res)
	--log(serpent.block(value))
	if value.level == 2 then
		--log(serpent.block(global.modmashsplinterunderground.resource_level_two))
		for k=1, #global.modmashsplinterunderground.resource_level_two do
			if global.modmashsplinterunderground.resource_level_two[k].name == res then
				res = global.modmashsplinterunderground.resource_level_two[k]
				break
			end
		end
	else
		--log(serpent.block(global.modmashsplinterunderground.resource_level_one))
		for k=1, #global.modmashsplinterunderground.resource_level_one do
			if global.modmashsplinterunderground.resource_level_one[k].name == res then
				res = global.modmashsplinterunderground.resource_level_one[k]
				break
			end
		end
	end
	if type(res)=="string" then
		--log(res.." not registered")
		return false 
	end
	local always = "false"
	if res.always == true then
		always = "true"
		--log(res.name..".always="..always.." is always allowed on "..surface.name)
		return true 
	end
	
	if value == nil then
		--log(res.name..".always="..always.." is NOT allowed on initial surface "..surface.name.. " surface not found")
		return false
	end
	if game.surfaces[value.top_name] ~= nil then
		if game.surfaces[value.top_name] == "nauvis" then 
			--log(res.name..".always="..always.." is always allowed on initial surface "..surface.name)
			return true 
		end

		local s = game.surfaces[value.top_name]
		if is_valid_surface_resource(s,res.name) then
			--log(res.name..".always="..always.." is allowed on surface "..surface.name.." due to settings")
			return true
		else
			--log(res.name..".always="..always.." is NOT allowed on surface "..surface.name.." due to settings")
			return false
		end
	end
	--log(res.name..".always="..always.." is always allowed on "..surface.name.. " due to parse map_gen_settings error")
	return true
end



local allow_biter = function(surface)
	if global.modmashsplinterunderground.surfaces[surface.name]==nil then return false end
	if settings.global["setting-underground-biters"].value == 0 then return false end
	if global.modmashsplinterunderground.surfaces[surface.name].biters==nil then global.modmashsplinterunderground.surfaces[surface.name].biters = 0 end
	if global.modmashsplinterunderground.surfaces[surface.name].biters >= settings.global["setting-underground-biters"].value then return false end
	return true
end

local allow_biter_spawner = function(surface)
	if global.modmashsplinterunderground.surfaces[surface.name]==nil then return false end
	if settings.global["setting-underground-biters"].value == 0 then return false end
	if global.modmashsplinterunderground.surfaces[surface.name].nests==nil then global.modmashsplinterunderground.surfaces[surface.name].nests = 0 end
	local max_nests = math.floor(settings.global["setting-underground-biters"].value/10)
	max_nests = math.max(max_nests,1)
	if global.modmashsplinterunderground.surfaces[surface.name].nests >= max_nests then return false end
	return true
end

local generate_surface_area = function(x,y,r,surface, res, allow_mixed, rock_prefix,force_first_rock)	
	local cx, cy = math.floor(x / 32), math.floor(y / 32)
	if surface.is_chunk_generated({cx, cy}) ~= true then
		surface.request_to_generate_chunks({x, y}, r*2)
		surface.force_generate_chunk_requests()
	end

	local p = get_circle_lines(x,y,r)
	local d = get_sorted_lines(p)
	local rm = 0.25 + ((settings.global["setting-resource-mod"].value /100)*0.75)
    local amt = math.floor(math.random(800, 3200) * rm)
	local t_res_table =  local_build_probability_table(res)
	local res_table = {}
	for k = 1, #t_res_table do
		if allow_resource_by_parent(t_res_table[k],surface) then
			table.insert(res_table,t_res_table[k])
		end
	end
	local rnd = nil
	--[[
		1-(0/100)=1 case restrict
		1-(100/100)=0 case normal

	]]
	local erandmod = 1.5 + ((1-(settings.global["setting-resource-mod"].value /100))*2) --high less likley
	local erand = math.max(math.ceil(#res_table*erandmod))
	if erand == 1 then 
		rnd = 1 
	else
		--splinterunderground__/prototypes/scripts/underground.lua:446: bad argument #2 of 2 to 'random' (interval is empty)
		--not sure how possibly another mod breaking resources of messed up settings value have endured rnd is 1+
		rnd = math.random(1, erand)
	end

	local attack_rocks = math.random(1,5)
	if settings.global["setting-biter-rocks"].value == "Disabled" then attack_rocks = 0 end

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
			  if current_tile.name == "underground-out-of-map" then 
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
			  if current_tile.name == "underground-out-of-map" then 
				--log(serpent.block(res_table))
			    surface.set_tiles({{ name = tile, position = pos }})
				local create = nil
				if rnd ~= nil and  rnd <= #res_table then
					if allow_mixed and mixed == 1 then
					--	for z =1,5 do
							local chk_res = res_table[math.random(1,#res_table)]
					--		if allow_resource_by_parent(chk_res,surface) == true then
								create = {name=chk_res, amount=amt*m, position=pos}
					--			break
					--		end
					--	end
					else
						--for z =1,5 do
							local chk_res = res_table[rnd]
							--if allow_resource_by_parent(chk_res,surface) == true then
								create = {name=chk_res, amount=amt*m, position=pos}
								--break
							--end
						--end
					end
				end 						
				if create ~= nil then 
					surface.create_entity(create)
					if allow_biter_spawner(surface) then
						if biter < 6 and x == j and y == i then	
							surface.create_entity({ name = "biter-spawner", position = pos })
							global.modmashsplinterunderground.surfaces[surface.name].nests = global.modmashsplinterunderground.surfaces[surface.name].nests+1
						end
					end
				else
					if allow_biter_spawner(surface) then
						if biter < 6  and x == j and y == i then	
							surface.create_entity({ name = "biter-spawner", position = pos })
							global.modmashsplinterunderground.surfaces[surface.name].nests = global.modmashsplinterunderground.surfaces[surface.name].nests+1
						end
					end
				end
			  end
			end
		  elseif j==s or j == e then
		    --edge
				if current_tile.name == "underground-out-of-map" then 
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

local generate_surface_area_train = function(x,y,sd,surface, rock_prefix)	
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
				then -- or sd.clear_area.right_bottom.y
					-- or j == sd.clear_area.left_top.x or j== sd.clear_area.right_bottom.x	then
					--if #surface.find_entities_filtered{area = {{pos.x-4.5, pos.y-4.5}, {pos.x+4.5, pos.y+4.5}}, name = {level_one_attack_rock,level_two_attack_rock}} < 1 then
						local ent = surface.create_entity({ name = rock_prefix..base_rock_names[math.random(#base_rock_names)], position = pos, force = force_player })
					--end
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
				local res = global.modmashsplinterunderground.resource_level_one
				local mixed = false
				local rock_prefix = level_one_rock_prefix
				if value.level==2 then
					res = global.modmashsplinterunderground.resource_level_two 
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
  if surface_reference == nil then return end
  if surface_reference.level ~= 0 then
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
		local res = global.modmashsplinterunderground.resource_level_one
		local mixed = false
		local rock_prefix = level_one_rock_prefix
		if surface_reference.level==2 then
			res = global.modmashsplinterunderground.resource_level_two 
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

local local_get_camera = function(player)
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

local local_do_teleport = function(i, p, access, upper_surface, lower_surface)
	if is_valid(p.character) and p.vehicle == nil and p.character.surface.name == upper_surface.name then
		if distance(p.character.position.x,p.character.position.y,access.top_entity.position.x,access.top_entity.position.y) < 1.5 then				
			local_safe_teleport(p, lower_surface,p.character.position,i)
			teleport_cooldown = 60*settings.global["setting-teleport-cooldown"].value
			local_bitter_follow(access.top_entity)
		end
	elseif is_valid(p.character) and p.vehicle == nil and p.character.surface.name == lower_surface.name then
		if distance(p.character.position.x,p.character.position.y,access.bottom_entity.position.x,access.bottom_entity.position.y) < 1.5 then				
			local_safe_teleport(p, upper_surface,p.character.position,i)
			teleport_cooldown = 60*settings.global["setting-teleport-cooldown"].value
			local_bitter_follow(access.bottom_entity)
		end
	end
end


local local_check_teleport = function()
	local found
	teleport_cooldown = teleport_cooldown -1
	for i = 1, #game.players do local p = game.players[i]
		if p.valid and p.character ~= nil then
			local character = p.character
			
			local last_pt_name = i..""
			local last_pt = last_point[last_pt_name]
			if last_pt ~= nil and distance(math.floor(p.character.position.x),math.floor(p.character.position.y),last_pt.x,last_pt.y) >= 1.5 then 
				last_point[last_pt_name] = nil
			elseif last_pt == nil then

				local found_access = character.surface.find_entities_filtered{position=character.position,radius=1.5, name={underground_access, underground_access2}}
				if #found_access > 0 then
					local gsurfaces = game.surfaces
					for name, value in pairs(surfaces_top) do
						local ms= surfaces[value.middle_name]
						local bs= surfaces[value.bottom_name]
						local tss= gsurfaces[value.top_name]
						local mss = gsurfaces[value.middle_name]
						local bss = gsurfaces[value.bottom_name]
						local accesses = value.accesses
						local accesses2 = ms.accesses
						for index, access in ipairs(accesses) do 
							if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity) and access.top_entity.name ~=  underground_accessml then
								local_do_teleport(i, p, access, tss, mss)
							end
						end
						for index, access in ipairs(accesses2) do 
							if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity) and access.top_entity.name ~=  underground_accessml then
								local_do_teleport(i, p, access, mss, bss)
							end
						end
					end
				end
			end
		end
	end		
end

local equalize_inv = function(access, flip)
	
	local top = access.top_entity.get_inventory(defines.inventory.chest)
	local bottom = access.bottom_entity.get_inventory(defines.inventory.chest)

	if top.is_empty() and bottom.is_empty() then return not flip end

	local top_content = top.get_contents()
	local bottom_content = bottom.get_contents()

	--put everthing up top
	for name, count in pairs(bottom_content) do
		top_content[name] = (top_content[name] or 0) + count
	end
	
	local inv1, inv2
	if flip then
		inv1 = top
		inv2 = bottom
	else
		inv2 = top
		inv1 = bottom
	end
	
	inv1.clear()
	inv2.clear()
	for name, count in pairs(top_content) do
		if count == 1 then
			inv1.insert{name=name,count=count}
		else
			local mid = math.floor(count / 2)				
			local real = 0		
		
			if mid > 0 then real = inv1.insert{name=name, count=mid} end
			local remain = count - real
			local other = inv2.insert{name=name,count=remain}
			if other ~= remain then
				inv1.insert{name=name, count=remain-other}
			end
		end
	end
	return not flip
end

local local_access_process = function(access,pollution,flip,upper_surface,lower_surface)
	if pollution > 0 then upper_surface.pollute(access.top_entity.position, pollution*(settings.startup["setting-pollution-transfer-mod"].value/100))  end

	if (access.top_entity.unit_number + game.tick) % 20 == 0 then
		flip = equalize_inv(access, flip)
	end

	if game.tick%60==0 and settings.global["setting-biter-teleport"].value == "Enabled" then
		local moved = {}
		local enemy = lower_surface.find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if allow_biter(upper_surface) then
				if is_valid(e) and upper_surface.can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
					local ne = upper_surface.create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
					ne.health = e.health
					table.insert(moved,ne)
					e.destroy()
				end
			end
		end

		enemy = upper_surface.find_enemy_units(access.bottom_entity.position,2.5)
		for i = 1, #enemy do local e = enemy[i]
			if allow_biter(lower_surface) then
				if is_valid(e) and table_contains(moved,e) == false and lower_surface.can_place_entity{name=e.name, position=e.position, direction=e.direction, force=e.force} then
					local ne = lower_surface.create_entity{name=e.name, position=e.position, direction=e.direction, force=e.force}
					ne.health = e.health
					e.destroy()
				end
			end
		end
	end		
	return flip
	end


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

    for player_index, id in pairs(global.modmashsplinterunderground.train_ui) do
        if  from.unit_number == id then
            game.players[player_index].opened = to
        end
    end
end

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

local local_set_train_heading = function(train,heading,speed)
	--print("Requested "..heading.." ----------------")
	local current_heading = local_get_train_heading(train)
	
	if current_heading == heading then 		
		train.speed = speed 
	else
		train.speed = speed * -1
	end
end

local local_train_transfers_tick = function()

	--todo check train has fully left out station before allowing back in
	for k = #global.modmashsplinterunderground.train_transfers_clear, 1, -1 do
		local left = true
		local station = global.modmashsplinterunderground.train_transfers_clear[k].station
		for j = 1, #global.modmashsplinterunderground.train_transfers_clear[k].out_carriages do
			local c = global.modmashsplinterunderground.train_transfers_clear[k].out_carriages[j]
			if is_valid(c) and is_valid(station) and c.surface.find_entity(station.name, c.position) == station then
				left = false
				break
			end
		end
		if left == true then			
			table.remove(global.modmashsplinterunderground.train_transfers_clear,k)
		end
	end

	--if modmashsplinterunderground.defines.trains ~= true then return end
	if #global.modmashsplinterunderground.train_transfers == 0 then return end
	
	for t = #global.modmashsplinterunderground.train_transfers,1, -1 do
		local transfer = global.modmashsplinterunderground.train_transfers[t]
		if transfer==nil then --bad transfer
			table.remove(global.modmashsplinterunderground.train_transfers,t) 
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
				table.insert(global.modmashsplinterunderground.train_transfers_clear,{out_carriages = copy,station = transfer.to})
			end
			table.remove(global.modmashsplinterunderground.train_transfers,t)
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
				table.remove(global.modmashsplinterunderground.train_transfers,t)
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


local local_merge_signal = function(top_entity,bottom_entity,top_last_signals,bottom_last_signals)
	--ok stop for now  merged signals work simply copy each and set to 
	local temp_top = {}
	local temp_bottom = {}
	top_last_signals = top_last_signals or {}
	bottom_last_signals = bottom_last_signals or {}
	local tecn = top_entity.get_control_behavior()
	local tes = top_entity.get_merged_signals() or {}
	local becn = bottom_entity.get_control_behavior()
	local bes = bottom_entity.get_merged_signals() or {}

	for k=tecn.signals_count, 1, -1 do
		local t = tes[k]
		if t ~=nil then temp_top[t.signal.name] = t end	
		tecn.set_signal(k,nil)
	end
	for k=becn.signals_count, 1, -1 do
		local t = bes[k]
		if t ~=nil then temp_bottom[t.signal.name] = t end	
		becn.set_signal(k,nil)
	end	
	local index = 1
	local added_bottom = {}
	for name, value in pairs(temp_top) do
		if top_last_signals[name] ~=nil then
			local t = math.max(temp_top[name].count - top_last_signals[name].count,0)
			if t>0 then
				local signal = {signal={type=value.signal.type, name = value.signal.name},count = t}
				becn.set_signal(index,signal)
				added_bottom[name] = signal
			end
		else
			becn.set_signal(index,temp_top[name])	
			added_bottom[name] = temp_top[name]
		end
		index = index + 1
	end
	index = 1
	local added_top = {}
	for name, value in pairs(temp_bottom) do
		if bottom_last_signals[name] ~=nil then
			
			local t = math.max(temp_bottom[name].count - bottom_last_signals[name].count,0)
			if t>0 then
				local signal = {signal={type=value.signal.type, name = value.signal.name},count = t}
				tecn.set_signal(index,signal)	
				added_top[name] = signal
			end
		else
			tecn.set_signal(index,temp_bottom[name])	
			added_top[name] = temp_bottom[name]
		end
		index = index + 1
	end

	return {
		top_last_signals = added_top,
		bottom_last_signals =added_bottom
	}
end
local local_stops_circuit_tick = function()	
	--[[for k = #global.modmashsplinterunderground.combinator_disconections, 1, -1 do		
		if global.modmashsplinterunderground.combinator_disconections[k] ~= nil and global.modmashsplinterunderground.combinator_disconections[k].type == "electric-pole" then
			local entity = global.modmashsplinterunderground.combinator_disconections[k]
			for j=1,#entity.neighbours["copper"] do
				if is_valid(entity.neighbours["copper"][j]) and starts_with(entity.neighbours["copper"][j].name,"underground-combinator-") then
					entity.neighbours["copper"][j].disconnect_neighbour()
				end
			end
		else
			global.modmashsplinterunderground.combinator_disconections[k].disconnect_neighbour()
		end
		table.remove(global.modmashsplinterunderground.combinator_disconections,k)

	end]]
	--New honk version
	for k, entity in ipairs(global.modmashsplinterunderground.combinator_disconections) do
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
    global.modmashsplinterunderground.combinator_disconections = {}
end

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

local local_underground_tick = function()	
	local_train_transfers_tick()
	local gsurfaces = game.surfaces
	local_check_teleport()
	local_stops_circuit_tick()
	--[[
	for name, value in pairs(surfaces_top) do
		local p = 0
		
		local ms= surfaces[value.middle_name]
		local bs= surfaces[value.bottom_name]
		local tss= gsurfaces[value.top_name]
		local mss = gsurfaces[value.middle_name]
		local bss = gsurfaces[value.bottom_name]
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
	]]
		for name, value in pairs(surfaces_top) do
		local ms= surfaces[value.middle_name]
		local bs= surfaces[value.bottom_name]
		local tss= gsurfaces[value.top_name]
		local mss = gsurfaces[value.middle_name]
		local bss = gsurfaces[value.bottom_name]
		local accesses = value.accesses
		local accesses2 = ms.accesses

		for index=1, #accesses do local access = accesses[index]
			if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
				local p = ((game.tick%300)==0 and local_take_nearby_pollution(mss, access.bottom_entity)) or 0
				ms.flip = local_access_process(access,p,ms.flip,tss,mss)
			end
		end

		for index=1, #accesses2 do local access = accesses2[index]
			if is_valid_and_persistant(access.bottom_entity) and is_valid_and_persistant(access.top_entity)  then
				local p = ((game.tick%300)==0 and local_take_nearby_pollution(bss, access.bottom_entity)) or 0
				bs.flip = local_access_process(access,p,bs.flip,mss,bss)
			end
		end
	end
end

local local_add_rubble = function(pos,surface)
	for k=1, math.random(8,14) do
		local p = {x=pos.x-3 + math.random(1,6), y=pos.y-3 + math.random(1,6)}
		if ends_with(surface.name,"-deep-underground") == true then
			surface.create_entity({name = level_two_rock_prefix..base_rock_names[math.random(#base_rock_names)], position = p,force = force_player })
		elseif ends_with(surface.name,"-underground") == true then
			surface.create_entity({name = level_one_rock_prefix..base_rock_names[math.random(#base_rock_names)], position = p,force = force_player })
		else
			surface.create_entity({name = base_rock_names[math.random(#base_rock_names)], position = p,force = force_player })
		end
	end
end

local local_update_fake_stops = function(surface)
	local surface = surfaces[surface.name]
	if surface == nil then 
		return 
	end	
	local all_surface_stops = {}
	local added_surface_stops = {}
	surface_list = {surface.top_name,surface.middle_name,surface.bottom_name}
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
				local e = s.find_entities_filtered{name = {"subway-level-one","subway-level-two"},force = force_player}
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
			surface = surface.middle_name,
			others = {surface.bottom_name,surface.top_name}
		},
		{
			surface = surface.top_name,
			others = {surface.bottom_name,surface.middle_name}
		},
		{
			surface = surface.bottom_name,
			others = {surface.middle_name,surface.top_name}
		}
	}
	for k=1, #surface_list do 		
		--if there are stops on this surface then add to other surfaces
		if #all_surface_stops[surface_list[k].surface] > 0 and surfaces[surface_list[k].surface] ~= nil  then	
			--this is where it goes wrong because the top surface has stops containing it and underground 
			--and underground has stops containing it and dee-underground
			local super_stop = nil
			if ends_with(surface_list[k].surface,"-deep-underground") then
				--the superstop must be first stop in middle_surface bottom_entity
				local sn = surfaces[surface_list[k].surface].middle_name
				local actual_surface = surfaces[sn]
				if #actual_surface.stops > 0 then 
					super_stop = actual_surface.stops[1].bottom_entity 
				end
			elseif ends_with(surface_list[k].surface,"-underground") then
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

local local_underground_removed = function(entity,event,died)	
	if died ~= true then died = false end

	local surface = surfaces[entity.surface.name]
	if surface == nil then return end
	local accumulators = surfaces[surface.top_name].accumulators
	local accesses = surfaces[surface.top_name].accesses
	local accesses2 = surfaces[surface.middle_name].accesses

	local stops = surfaces[surface.top_name].stops
	local stops2 = surfaces[surface.middle_name].stops
	local combinators = surfaces[surface.top_name].combinators
	local combinators2 = surfaces[surface.middle_name].combinators
	
	if modmashsplinterunderground.removed_rocks == nil then modmashsplinterunderground.removed_rocks = 0 end

	if entity.name == underground_accessml then		
		local top_index = nil
		local bottom_index = nil
		local top = nil
		local middle = nil
		local bottom = nil
		
		if entity.surface.name == surface.top_name or entity.surface.name == surface.middle_name then
			for index, access in pairs(accesses) do
				if access.top_entity == entity or access.bottom_entity == entity  then			
					top = access.top_entity
					middle = access.bottom_entity
					top_index = index
				end
			end
			for index, access in pairs(accesses2) do
				if access.top_entity == middle or access.bottom_entity == entity  then			
					bottom = access.bottom_entity
					bottom_index = index
				end
			end
		else
			for index, access in pairs(accesses2) do
				if access.top_entity == entity or access.bottom_entity == entity  then	
					middle = access.top_entity
					bottom = access.bottom_entity
					bottom_index = index
				end
			end
			for index, access in pairs(accesses) do
				if access.top_entity == entity or access.bottom_entity == middle  then			
					top = access.top_entity
					top_index = index
				end
			end
		end

		if died == true then
			local surface = top.surface
			local pos = top.position
			local name = top.name
			if entity ~= top then top.destroy() end
			surface.create_entity{name = "small-remnants", position = pos, force = force_player}
			surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}

			surface = middle.surface
			pos = middle.position
			name = middle.name
			if entity ~= middle then middle.destroy() end
			surface.create_entity{name = "small-remnants", position = pos, force = force_player}
			surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}

			surface = bottom.surface
			pos = bottom.position
			 name = bottom.name
			if entity ~= bottom then bottom.destroy() end
			surface.create_entity{name = "small-remnants", position = pos, force = force_player}
			surface.create_entity{ name = "entity-ghost", inner_name = name, position = pos, force = force_player}

		else
			if entity ~= top then top.destroy() end
			if entity ~= middle then middle.destroy() end
			if entity ~= bottom then bottom.destroy() end
		end
		table.remove(accesses,top_index)
		table.remove(accesses2,bottom_index)
	elseif entity.name == underground_access then				
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
	
	elseif entity.name == "underground-combinator-l1" then				
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
	elseif entity.name == "underground-combinator-l2" then				
		for index, access in pairs(combinators2) do
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
				table.remove(combinators2, index)				
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
				table.remove(combinators2, index)				
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
	elseif entity.name == "subway-level-two" then				
		for index, access in pairs(stops2) do
			if access.top_entity == entity then
				if died == true then
					local surface = access.bottom_entity.surface
					local other_surface = access.top_entity.surface
					local pos = access.bottom_entity.position
					local dir = access.bottom_entity.direction
					local name = access.bottom_entity.name
					access.bottom_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
					surface.create_entity{ name = "entity-ghost",direction=dir, inner_name = name, position = pos, force = force_player}
					local_update_fake_stops(surface)
				else
					local pos = access.bottom_entity.position
					local surface = access.bottom_entity.surface
					local other_surface = access.top_entity.surface
					access.bottom_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
					local_update_fake_stops(surface)
				end
				table.remove(stops2, index)			
				return
			elseif access.bottom_entity == entity then
				if died == true then
					local surface = access.top_entity.surface
					local other_surface = access.bottom_entity.surface
					local pos = access.top_entity.position
					local name = access.top_entity.name
					local dir = access.top_entity.direction
					access.top_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
					surface.create_entity{ name = "entity-ghost", inner_name = name,direction=dir, position = pos, force = force_player}
					local_update_fake_stops(surface)
				else
					local pos = access.top_entity.position
					local surface = access.top_entity.surface
					local other_surface = access.bottom_entity.surface
					access.top_entity.destroy()
					local_add_rubble(pos,surface)
					local_add_rubble(pos,other_surface)
					local_update_fake_stops(surface)
				end
				table.remove(stops2, index)				
				return
			end
		end
	elseif surfaces[entity.surface.name].level == 1 then
		if entity.name == level_one_attack_rock then
			modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
			generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,global.modmashsplinterunderground.resource_level_one,false,level_one_rock_prefix, true)
		else
			for k=1,#base_rock_names do
				if level_one_rock_prefix..base_rock_names[k] == entity.name then	
					modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
				--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
					generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,global.modmashsplinterunderground.resource_level_one,false,level_one_rock_prefix)
					break
				end		
			end
		end
	elseif surfaces[entity.surface.name].level == 2 then
		if entity.name == level_two_attack_rock then
			modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
			generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,global.modmashsplinterunderground.resource_level_two,true,level_two_rock_prefix, true)
		else
			for k=1,#base_rock_names do
				if level_two_rock_prefix..base_rock_names[k] == entity.name then	
					modmashsplinterunderground.removed_rocks = modmashsplinterunderground.removed_rocks + 1
					--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
					generate_surface_area(entity.position.x, entity.position.y,2,entity.surface,global.modmashsplinterunderground.resource_level_two,true,level_two_rock_prefix)
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

	if is_valid(entity) and global.modmashsplinterunderground.surfaces[entity.surface.name]==nil then return end
	if settings.global["setting-underground-biters"].value == 0 then return end

	if is_valid(entity) and entity.force=="enemy" and entity.name ~= "queen-hive" then
		if entity.type =="unit-spawner" then
			global.modmashsplinterunderground.surfaces[entity.surface.name].nests = math.max(global.modmashsplinterunderground.surfaces[entity.surface.name].nests-1,0)
		elseif entity.type =="unit" and string.find(entity.name,"biter") then
			global.modmashsplinterunderground.surfaces[entity.surface.name].biters = math.max(global.modmashsplinterunderground.surfaces[entity.surface.name].biters-1,0)
		end					
	end
	end


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
		--for j=#tracks,1,-1 do
		--	print(d)
		--	print(tracks[j].position)
		--	print(tracks[j].type .. " " .. tracks[j].name)
		--end
		if #tracks > 0 then return false end
	end	
end

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

local local_update_stop_name = function(from, to)
	if from.backer_name == to.backer_name then
		if starts_with(from.backer_name,"[virtual-signal=stop-signal-0-1]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-0%-1%]", "") 
		elseif starts_with(from.backer_name,"[virtual-signal=stop-signal-1-0]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-0%]", "") 
		elseif starts_with(from.backer_name,"[virtual-signal=stop-signal-2-1]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-1%]", "") 
		elseif starts_with(from.backer_name,"[virtual-signal=stop-signal-1-2]") then from.backer_name = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-2%]", "") end

	end
	if ends_with(to.surface.name,"-deep-underground") == true then
		local x = string.gsub(from.backer_name, "%[virtual%-signal%=stop%-signal%-1%-2%]", "") 
		to.backer_name = "[virtual-signal=stop-signal-2-1]"..x
	elseif ends_with(to.surface.name,"-underground") == true then		
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
		elseif entity.name == "subway-level-two" then
			if ends_with(entity.surface.name,"-deep-underground") == true then
				local stops = surfaces[surface.middle_name].stops
				for k=1, #stops do local s = stops[k]
					if s.bottom_entity == entity then
						local_update_stop_name(s.bottom_entity,s.bottom_entity)
						local_update_stop_name(s.bottom_entity,s.top_entity)
						local_update_fake_stops(entity.surface)
						break
					end
				end
			else
				local stops = surfaces[surface.middle_name].stops
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
	local prefix = level_one_rock_prefix
	local attack_rock_name = level_one_attack_rock
	if ends_with(next_surface.name,"-deep-underground") then
		prefix = level_two_rock_prefix 
		attack_rock_name = level_two_attack_rock
	end

	
	local rocks = next_surface.find_entities_filtered{area = {{osd.clear_area.left_top.x, osd.clear_area.left_top.y}, {osd.clear_area.right_bottom.x, osd.clear_area.right_bottom.y}}, name = attack_rock_name}			
	for index=1, #rocks do local r = rocks[index]
		if is_valid(r) then 
			r.destroy({raise_destroy = true}) 
		end			
	end	
	generate_surface_area_train(sd.opposite_posistion.x, sd.opposite_posistion.y,osd,next_surface,prefix)
	if entity.name=="entity-ghost" then
		return next_surface.can_place_entity{name=entity.ghost_name, position=sd.opposite_posistion, direction=osd.direction, force=entity.force}	
	else
		return next_surface.can_place_entity{name=entity.name, position=sd.opposite_posistion, direction=osd.direction, force=entity.force}	
	end
end

local local_ensure_can_place_entity_inner = function(entity,event,surface)
	local etype = entity.type
	local ename = entity.name
	if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end

	if ename == "subway-level-one" or ename == "subway-level-two" or ename == "underground-combinator-l1" or ename == "underground-combinator-l2" or  ename == underground_access or ename == underground_access2 or ename == underground_accumulator then 		
		if surface.level == 0 then			
			if ename == underground_access2 or entity.name == "subway-level-two" or ename == "underground-combinator-l2"  then return false end
			if ename == "subway-level-one" then	
				return local_add_stop(entity,game.surfaces[surface.middle_name])		
			else
				
				local rocks = game.surfaces[surface.middle_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end			
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.middle_name],global.modmashsplinterunderground.resource_level_one,false,level_one_rock_prefix)
				return game.surfaces[surface.middle_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
			end
		elseif entity.surface.name == surface.middle_name then
			if ename == underground_access or ename == underground_accumulator or ename == "underground-combinator-l1" then
				if game.surfaces[surface.top_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force} then
					return true
				end
			elseif ename == underground_access2 or ename == "underground-combinator-l2" then
				local rocks = game.surfaces[surface.bottom_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.bottom_name],global.modmashsplinterunderground.resource_level_two,true,level_two_rock_prefix)
				return game.surfaces[surface.bottom_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
			elseif ename == "subway-level-one" then
				return local_add_stop(entity,game.surfaces[surface.top_name])
			elseif ename == "subway-level-two" then			
				return local_add_stop(entity,game.surfaces[surface.bottom_name])
			end
		elseif entity.surface.name == surface.bottom_name then			
			if ename == underground_access2 or ename == "underground-combinator-l2" then
				local rocks = game.surfaces[surface.middle_name].find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
				for index=1, #rocks do local r = rocks[index]
					if is_valid(r) then 
						r.destroy({raise_destroy = true}) 
					end			
				end		
				generate_surface_area(entity.position.x, entity.position.y,5,game.surfaces[surface.middle_name],global.modmashsplinterunderground.resource_level_one,false,level_one_rock_prefix)
				return game.surfaces[surface.middle_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}	
			elseif ename == "subway-level-two" then

				return local_add_stop(entity,game.surfaces[surface.middle_name])
			end
		end			

	elseif entity.type == "curved-rail" or entity.type == "straight-rail" or entity.type == "rail-signal" or entity.type == "rail-chain-signal" then	
		if modmashsplinterunderground.defines.trains == true then
			local f = entity.surface.find_entity("subway-level-one",entity.position)
			
			if f == nil then f = entity.surface.find_entity("subway-level-two",entity.position) end

			if f ~= nil then
				return local_can_place_by_stop(f,entity)
			end
		end
	end

	return true
	end

local local_ensure_can_place_entity = function(entity,event,surface)
	if global.modmashsplinterunderground.banned_level_one ==nil then global.modmashsplinterunderground.banned_level_one = {} end
	if global.modmashsplinterunderground.banned_level_two ==nil then global.modmashsplinterunderground.banned_level_two = {} end
	if global.modmashsplinterunderground.banned_level_zero ==nil then global.modmashsplinterunderground.banned_level_zero = {} end
	if local_ensure_can_place_entity_inner(entity,event,surface) then			
		local etype = entity.type
		local ename = entity.name
		if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
		if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end
		if surface.level == 1 and ((etype=="solar-panel" or etype == "rocket-silo") or table_contains(global.modmashsplinterunderground.banned_level_one,entity.name)) then		
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			return false
		elseif surface.level == 2 and ((entity.name == "subway-level-one" or entity.name == underground_accumulator or entity.name == underground_access or entity.type=="solar-panel" or entity.type == "rocket-silo") or table_contains(global.modmashsplinterunderground.banned_level_two,entity.name)) then
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			return false
		elseif surface.level == 0 and (entity.name == "subway-level-two" or entity.name == underground_access2 or table_contains(global.modmashsplinterunderground.banned_level_zero,entity.name)) then			
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
			return false
		end
	else	
		fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-fail"})
		return false
	end
	return true
	end

local local_underground_added_std = function(entity,event)			
	local surface = surfaces[entity.surface.name]
	if surface == nil then 
		if entity.name == battery_cell then	
			entity.energy = 10000000
		elseif entity.name == underground_access or 
				entity.name == underground_access2 or entity.name == underground_accumulator or
				entity.name == "subway-level-one" or entity.name == "subway-level-two" then				
			fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-disallowed"})
		end
		return
	end

	local accumulators = surfaces[surface.top_name].accumulators
	local accesses = surfaces[surface.top_name].accesses
	local accesses2 = surfaces[surface.middle_name].accesses	
	local stops = surfaces[surface.top_name].stops
	local stops2 = surfaces[surface.middle_name].stops	
	local combinators = surfaces[surface.top_name].combinators
	local combinators2 = surfaces[surface.middle_name].combinators	

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
	elseif entity.name == "underground-combinator-l1" then 	
		--entity.force = force_neutral
		entity.operable=false
		if surface.level == 0 then			
			local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
			table.insert(combinators,{bottom_entity = u, top_entity = entity})
			table.insert(global.modmashsplinterunderground.combinator_disconections,u)
			table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
			entity.connect_neighbour(u)
			u.operable=false
		elseif surface.level == 1 then
			local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = entity.position, force = force_player}
			table.insert(combinators,{bottom_entity = entity, top_entity = u})
			table.insert(global.modmashsplinterunderground.combinator_disconections,u)
			table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
			entity.connect_neighbour(u)
			u.operable=false
		end
	elseif entity.name == "underground-combinator-l2" then 	
		entity.operable=false
		--entity.force = force_neutral
		if surface.level == 1 then
			local u = game.surfaces[surface.bottom_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
			table.insert(combinators2,{bottom_entity = u, top_entity = entity})
			table.insert(global.modmashsplinterunderground.combinator_disconections,u)
			table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
			entity.connect_neighbour(u)
			u.operable=false
		elseif surface.level == 2 then
			local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = force_player}
			table.insert(combinators2,{bottom_entity = entity, top_entity = u})
			table.insert(global.modmashsplinterunderground.combinator_disconections,u)
			table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
			entity.connect_neighbour(u)
			u.operable=false
		end
	elseif entity.type == "electric-pole" then 		
			table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
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
	elseif entity.name == "subway-level-one" then 	
		local_update_stop_name(entity,entity)
		--entity.force = force_neutral
		if surface.level == 0 then
			--todo add tracks if required
			local sd = local_shape_data(entity.position,entity.direction)
			local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = sd.opposite_posistion, force = force_player, direction = sd.opposite_direction}				
			local_update_stop_name(entity,u)
			table.insert(stops,{bottom_entity = u, top_entity = entity})
			--entity.connect_neighbour(u)
			local_update_fake_stops(entity.surface)
		elseif surface.level == 1 then
			local sd = local_shape_data(entity.position,entity.direction)
			local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = sd.opposite_posistion, force = force_player, direction = sd.opposite_direction}
			local_update_stop_name(entity,u)
			table.insert(stops,{bottom_entity = entity, top_entity = u})
			--entity.connect_neighbour(u)
			local_update_fake_stops(entity.surface)
		end
	elseif entity.name == "subway-level-two" then 	
		local_update_stop_name(entity,entity)
		if surface.level == 1 then
			local sd = local_shape_data(entity.position,entity.direction)
			local osd = local_shape_data(entity.position,sd.opposite_direction)
			local u = game.surfaces[surface.bottom_name].create_entity{name=entity.name, position=sd.opposite_posistion, direction=osd.direction, force=entity.force}	
			local_update_stop_name(entity,u)
			table.insert(stops2,{bottom_entity = u, top_entity = entity, fake_bottom_entity = u}) --todo is fake needed?
			--entity.connect_neighbour(u)
			local_update_fake_stops(entity.surface)
		elseif surface.level == 2 then
			local sd = local_shape_data(entity.position,entity.direction)
			local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = sd.opposite_posistion, force = force_player,direction = sd.opposite_direction}
			local_update_stop_name(entity,u)
			table.insert(stops2,{bottom_entity = entity, top_entity = u})
			--entity.connect_neighbour(u)
			local_update_fake_stops(entity.surface)
		end
	end
	end

local local_ensure_can_place_entity_inner_ml_surface = function(entity,surface,resource_level,rock_prefix)
	local etype = entity.type
	local ename = entity.name
	if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end
	local rocks = surface.find_entities_filtered{area = {{entity.position.x-2.5, entity.position.y-2.5}, {entity.position.x+2.5, entity.position.y+2.5}}, name = rock_names}			
	for index=1, #rocks do local r = rocks[index]
		if is_valid(r) then 
			r.destroy({raise_destroy = true}) 
		end			
	end	
	generate_surface_area(entity.position.x, entity.position.y,5,surface,resource_level,false,rock_prefix)
	return surface.can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}		
end

local local_ensure_can_place_entity_ml = function(entity,event,surface)
	local etype = entity.type
	local ename = entity.name
	if entity.type == "entity-ghost" then etype = entity.ghost_prototype.type end
	if entity.type == "entity-ghost" then ename = entity.ghost_prototype.name end
	local pass = false
	if entity.surface.name == surface.top_name then
		pass =  local_ensure_can_place_entity_inner_ml_surface(entity,game.surfaces[surface.middle_name],global.modmashsplinterunderground.resource_level_one,level_one_rock_prefix)
		if pass == true then pass = local_ensure_can_place_entity_inner_ml_surface(entity,game.surfaces[surface.bottom_name],global.modmashsplinterunderground.resource_level_two,level_two_rock_prefix) end
	elseif entity.surface.name == surface.middle_name then
		pass = game.surfaces[surface.top_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}
		if pass == true then pass = local_ensure_can_place_entity_inner_ml_surface(entity,game.surfaces[surface.bottom_name],global.modmashsplinterunderground.resource_level_two,level_two_rock_prefix) end
	elseif entity.surface.name == surface.bottom_name then
		pass = game.surfaces[surface.top_name].can_place_entity{name=ename, position=entity.position, direction=entity.direction, force=entity.force}
		if pass == true then pass = local_ensure_can_place_entity_inner_ml_surface(entity,game.surfaces[surface.middle_name],global.modmashsplinterunderground.resource_level_one,level_one_rock_prefix) end
	end
	return pass
	end


local local_underground_added_ml = function(entity,event)			
	local surface = surfaces[entity.surface.name]
	if surface == nil then 
		fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-fail"})
		return
	end

	local accesses = surfaces[surface.top_name].accesses
	local accesses2 = surfaces[surface.middle_name].accesses	

	local_ensure_underground_environment(surface)

	if local_ensure_can_place_entity_ml(entity,event,surface) == false then 
		fail_place_entity(entity,event,{"modmashsplinterunderground.underground-placement-fail"})
		return
	end		

	if entity.surface.name == surface.top_name then
		
		local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
		table.insert(accesses,{bottom_entity = u, top_entity = entity})
		
		local u2 = game.surfaces[surface.bottom_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
		table.insert(accesses2,{bottom_entity = u2, top_entity = u})
		

	elseif entity.surface.name == surface.middle_name then
		local u = game.surfaces[surface.top_name].create_entity{name = entity.name, position = entity.position, force = force_player}
		table.insert(accesses,{bottom_entity = entity, top_entity = u})
		
		local u2 = game.surfaces[surface.bottom_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
		table.insert(accesses2,{bottom_entity = u2, top_entity = entity})

	elseif entity.surface.name == surface.bottom_name then
		local u = game.surfaces[surface.middle_name].create_entity{name = entity.name, position = entity.position, force = force_player}				
		table.insert(accesses2,{bottom_entity = entity, top_entity = u})

		local u2 = game.surfaces[surface.top_name].create_entity{name = entity.name, position = entity.position, force = force_player}
		table.insert(accesses,{bottom_entity = u, top_entity = u2})

	end

	end


local basic_generate_surface_area = function(x,y,r,surface, rock_prefix)	
	local cx, cy = math.floor(x / 32), math.floor(y / 32)
	if surface.is_chunk_generated({cx, cy}) ~= true then
		surface.request_to_generate_chunks({x, y}, r*2)
		surface.force_generate_chunk_requests()
	end
	local p = get_circle_lines(x,y,r)
	local d = get_sorted_lines(p)
	
	local attack_rocks = math.random(1,5)
	if settings.global["setting-biter-rocks"].value == "Disabled" then attack_rocks = 0 end

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
			  if current_tile.name == "underground-out-of-map" then 
			    surface.set_tiles({{ name = tile, position = pos }})					
			  end
			end
		  elseif j==s or j == e then
		    --edge
				if current_tile.name == "underground-out-of-map" then 
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


local local_try_add_entity = function(surface_name,entity_name,position,radius,force)
	local surface = surfaces[surface_name]
	if surface == nil then return false end
	local_ensure_underground_environment(surface)
	local rocks = game.surfaces[surface_name].find_entities_filtered{area = {{position.x-radius, position.y-radius}, {position.x+radius, position.y+radius}}, name = rock_names}			
	for index=1, #rocks do local r = rocks[index]
		if is_valid(r) then 
			r.destroy({raise_destroy = true}) 
		end			
	end			
	local rock_prefix = level_one_rock_prefix
	local resources = global.modmashsplinterunderground.resource_level_one
	if ends_with(surface_name,"deep-underground") then
		rock_prefix = level_two_rock_prefix
		resources = global.modmashsplinterunderground.resource_level_two
	end


	--function(x,y,r,surface, res, allow_mixed, rock_prefix,force_gen)	
	basic_generate_surface_area(position.x, position.y,radius,game.surfaces[surface_name],rock_prefix)
	if game.surfaces[surface_name].can_place_entity{name=entity_name, position=position, force = force} then
		return game.surfaces[surface_name].create_entity({name=entity_name, position=position, force = force}) ~= nil
	end
	return false
end

local local_underground_added = function(entity,event)
	if is_valid(entity) ~= true then return end	
	if entity.name == underground_accessml then
		local_underground_added_ml(entity,event)
	else	
		local_underground_added_std(entity,event)
	end
	if is_valid(entity) ~= true then return end	
	if global.modmashsplinterunderground.surfaces[entity.surface.name]==nil then return end
	if settings.global["setting-underground-biters"].value == 0 then return end

	if is_valid(entity) and entity.name ~= "queen-hive" then
		if entity.type =="unit-spawner" then
			print("hello")
			global.modmashsplinterunderground.surfaces[entity.surface.name].nests = global.modmashsplinterunderground.surfaces[entity.surface.name].nests+1
		elseif entity.type =="unit" and string.find(entity.name,"biter") then
			global.modmashsplinterunderground.surfaces[entity.surface.name].biters = global.modmashsplinterunderground.surfaces[entity.surface.name].biters+1
		end					
	end
end
--[[ todo currently not using but shoudl I?
local local_standard_filter = {
	{filter = "name", name = underground_accumulator}, 
	{filter = "name", name = underground_access},
	{filter = "name", name = underground_access2},
	{filter = "name", name = underground_accessml},
	{filter = "name", name = battery_cell},
	{filter = "name", name = used_battery_cell},
	
}]]
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
	
	if global.modmashsplinterunderground.combinator_disconections == nil then global.modmashsplinterunderground.combinator_disconections = {} end
	if global.modmashsplinterunderground.train_transfers == nil then global.modmashsplinterunderground.train_transfers = {} end
	if global.modmashsplinterunderground.train_transfers_clear == nil then global.modmashsplinterunderground.train_transfers_clear = {} end
	if global.modmashsplinterunderground.train_ui == nil then global.modmashsplinterunderground.train_ui = {} end	
	surfaces = global.modmashsplinterunderground.surfaces
	surfaces_top = global.modmashsplinterunderground.surfaces_top
	local_register_loot()
	local_register_resources()
	end

local local_load = function() 
	surfaces = global.modmashsplinterunderground.surfaces
	surfaces_top = global.modmashsplinterunderground.surfaces_top

	
	end

local local_on_configuration_changed = function(event) 
	if global.modmashsplinterunderground.train_transfers == nil then global.modmashsplinterunderground.train_transfers = {} end
	if global.modmashsplinterunderground.train_transfers_clear == nil then global.modmashsplinterunderground.train_transfers_clear = {} end
	if global.modmashsplinterunderground.train_ui == nil then global.modmashsplinterunderground.train_ui = {} end	
	global.modmashsplinterunderground.banned_level_zero = nil 
	global.modmashsplinterunderground.banned_level_one = nil 
	global.modmashsplinterunderground.banned_level_two = nil 

	if global.modmashsplinterunderground.resource_level_one == nil then global.modmashsplinterunderground.resource_level_one = {} end
	if global.modmashsplinterunderground.resource_level_two == nil then global.modmashsplinterunderground.resource_level_two = {} end
	global.modmashsplinterunderground.mineable_resources = nil

	for k=#global.modmashsplinterunderground.resource_level_one, 1, -1 do
		if global.modmashsplinterunderground.resource_level_one[k] == nil or local_check_mineable(global.modmashsplinterunderground.resource_level_one[k].name) == false then
			table.remove(global.modmashsplinterunderground.resource_level_one,k)
		end
	end
	for k=#global.modmashsplinterunderground.resource_level_two, 1, -1 do
		if global.modmashsplinterunderground.resource_level_two[k] == nil or local_check_mineable(global.modmashsplinterunderground.resource_level_two[k].name) == false then
			table.remove(global.modmashsplinterunderground.resource_level_two,k)
		end
	end

	local_register_loot()
	local_register_resources()
	

	local changed = event.mod_changes and event.mod_changes["modmashsplinterunderground"]
	if changed then
		if changed.old_version == nil or changed.old_version < "1.1.18" then			
			for name, value in pairs(global.modmashsplinterunderground.surfaces) do
				if global.modmashsplinterunderground.surfaces[name].stops == nil then
					global.modmashsplinterunderground.surfaces[name].stops = {}
				end				
				if global.modmashsplinterunderground.surfaces[name].super_stops == nil then
					global.modmashsplinterunderground.surfaces[name].super_stops = {}
					
				end				
			end	
			for name, value in pairs(global.modmashsplinterunderground.surfaces) do
				if ends_with(name,"-underground") == false then
					local_update_fake_stops(game.surfaces[name] )
				end
			end
		end
		if changed.old_version == nil or changed.old_version < "1.1.19" then			
			for name, value in pairs(global.modmashsplinterunderground.surfaces) do
				if ends_with(name,"-underground") == false then
					local_update_fake_stops(game.surfaces[name] )
				end
			end
		end
		if changed.old_version == nil or changed.old_version < "1.1.22" then			
			for name, value in pairs(global.modmashsplinterunderground.surfaces) do
				if global.modmashsplinterunderground.surfaces[name].combinators == nil then
					global.modmashsplinterunderground.surfaces[name].combinators = {}
				end						
			end	
		end
		if changed.old_version == nil or changed.old_version < "1.1.23" then			
			--well shit changing the type renders the entiry invalid need to rescan for all enities and remap
			if global.modmashsplinterunderground.combinator_disconections == nil then
				global.modmashsplinterunderground.combinator_disconections = {}
			end			
			for name, value in pairs(global.modmashsplinterunderground.surfaces_top) do			
				local ts= global.modmashsplinterunderground.surfaces[value.top_name]
				local ms= global.modmashsplinterunderground.surfaces[value.middle_name]
				local bs= global.modmashsplinterunderground.surfaces[value.bottom_name]
				if is_valid(game.surfaces[value.middle_name]) then
					local entities = game.surfaces[value.middle_name].find_entities_filtered{name={"underground-combinator-l1","underground-combinator-l2"}}
					for k=1, #entities do local entity = entities[k]
						if entity.name =="underground-combinator-l1" then
							local u = game.surfaces[value.top_name].find_entity("underground-combinator-l1", entity.position)
							if is_valid(u) then
								table.insert(ts.combinators,{bottom_entity = entity, top_entity = u})
								--entity.operable=true
								--u.operable=true
								table.insert(global.modmashsplinterunderground.combinator_disconections,u)
								table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
								entity.connect_neighbour({target_entity = u, wire = defines.wire_type.red})
								entity.connect_neighbour({target_entity = u, wire = defines.wire_type.green})
								
							end
						elseif is_valid(game.surfaces[value.bottom_name]) then
							local u = game.surfaces[value.bottom_name].find_entity("underground-combinator-l2", entity.position)
							if is_valid(u) then
								table.insert(ms.combinators,{bottom_entity = u, top_entity = entity})
								--entity.operable=true
								--u.operable=true
								table.insert(global.modmashsplinterunderground.combinator_disconections,u)
								table.insert(global.modmashsplinterunderground.combinator_disconections,entity)
								entity.connect_neighbour({target_entity = u, wire = defines.wire_type.red})
								entity.connect_neighbour({target_entity = u, wire = defines.wire_type.green})
							end
						end
					
					end
				end
			end	
		end
		if changed.old_version == nil or changed.old_version < "1.1.24" then	
			for name, value in pairs(global.modmashsplinterunderground.surfaces_top) do			
				local ts= global.modmashsplinterunderground.surfaces[value.top_name]
				local ms= global.modmashsplinterunderground.surfaces[value.middle_name]
				if ms.nests == nil then ms.nests = 0 end
				if ms.biters == nil then ms.biters = 0 end
				local bs= global.modmashsplinterunderground.surfaces[value.bottom_name]
				if bs.nests == nil then bs.nests = 0 end
				if bs.biters == nil then bs.biters = 0 end
				if is_valid(game.surfaces[value.middle_name]) then
					local entities = game.surfaces[value.middle_name].find_entities_filtered{force="enemy"}
					for k=1, #entities do local entity = entities[k]
						if entity.name ~= "queen-hive" then
							if entity.type =="unit-spawner" then
								ms.nests = ms.nests+1
							elseif entity.type =="unit" and string.find(entity.name,"biter") then
								ms.biters = ms.biters+1
							end					
						end
					end
				end
				if is_valid(game.surfaces[value.bottom_name]) then
					local entities = game.surfaces[value.bottom_name].find_entities_filtered{force="enemy"}
					for k=1, #entities do local entity = entities[k]
						if entity.name ~= "queen-hive" then
							if entity.type =="unit-spawner" then
								bs.nests = ms.nests+1
							elseif entity.type =="unit" and string.find(entity.name,"biter") then
								bs.biters = ms.biters+1
							end					
						end
					end
				end
			end	
		end
	end
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




local local_on_selected_entity_changed = function(event)

	local player = game.players[event.player_index]
	local selected = player.selected
	--[[if selected ~= nil and (selected.type == "locomotive" or selected.type == "cargo-wagon" or selected.type == "fluid-wagon" or selected.type == "artillery-wagon") then 
		print(selected.orientation.." "..selected.direction)
		selected.train.speed = 0.02
	end]]
	

	if selected ~= nil and selected.name ~= underground_accessml then

		local surface = selected.surface
		if surface == nil then return end
		local s = surfaces[surface.name]
		if not s then return end
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


local local_transport_train = function(train, from,to)
	--todo check train has fully left out station before allowing back in
	for k=1, #global.modmashsplinterunderground.train_transfers_clear do
		if global.modmashsplinterunderground.train_transfers_clear[k].out_carriages[1].train == train and
			(global.modmashsplinterunderground.train_transfers_clear[k].station == to or global.modmashsplinterunderground.train_transfers_clear[k].station == from) then
			return end -- we have not fully clear the destionation so cannot go back yet
	end

	for k=1, #global.modmashsplinterunderground.train_transfers do
		if global.modmashsplinterunderground.train_transfers[k].in_train == train or
			global.modmashsplinterunderground.train_transfers[k].out_train == train then
			return end
	end
	local manual_mode = train.manual_mode

	if #train.carriages > 3 then
		if from.name == "subway-level-one" and from.force.technologies["subway-level-one-more2"].researched ~= true then
			from.surface.create_entity{name="flying-text", position = from.position, text="Train too long, research available" , color={r=1,g=0.25,b=0.0}}
			train.manual_mode = true
			return
		elseif from.name == "subway-level-two" and from.force.technologies["subway-level-two-more2"].researched ~= true then
			from.surface.create_entity{name="flying-text", position = from.position, text="Train too long, research available" , color={r=1,g=0.25,b=0.0}}
			train.manual_mode = true
			return
		end
	end
	if #train.carriages == 3 then
		if from.name == "subway-level-one" and from.force.technologies["subway-level-one-more1"].researched ~= true then
			from.surface.create_entity{name="flying-text", position = from.position, text="Train too long, research available" , color={r=1,g=0.25,b=0.0}}
			train.manual_mode = true
			return
		elseif from.name == "subway-level-two" and from.force.technologies["subway-level-two-more1"].researched ~= true then
			from.surface.create_entity{name="flying-text", position = from.position, text="Train too long, research available" , color={r=1,g=0.25,b=0.0}}
			train.manual_mode = true
			return
		end
	end
	

	local sd = local_shape_data(from.position,from.direction)
	
	local out_track = to.connected_rail
	if out_track == nil then 
		from.surface.create_entity{name="flying-text", position = from.position, text="No output track" , color={r=1,g=0.25,b=0.0}}
		train.manual_mode = true
		return
	end

	--[[if out_track.get_rail_segment_length() <= #current_tracks * 2 then
		print(out_track.get_rail_segment_entity(defines.rail_direction.back, false).name)
		from.surface.create_entity{name="flying-text", position = from.position, text="Insufficent output space signal in way" , color={r=1,g=0.25,b=0.0}}
		train.manual_mode = true
		return
	end]]

	local current_tracks= train.get_rails()
	for k=1, #current_tracks do		
		local trk = out_track.get_connected_rail{rail_direction = sd.rail_direction, rail_connection_direction =  defines.rail_connection_direction.straight}
		--[[if trk == nil then
			trk = out_track.get_connected_rail{rail_direction = sd.rail_direction, rail_connection_direction =  defines.rail_connection_direction.left}
		end
		if trk == nil then
			trk = out_track.get_connected_rail{rail_direction = sd.rail_direction, rail_connection_direction =  defines.rail_connection_direction.right}
		end]]
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
		--print(train.carriages[k].position.x .." ".. train.carriages[k].position.y .." "..distance(from.position.x,from.position.y,train.carriages[k].position.x,train.carriages[k].position.y))
		train.carriages[k].operable=false
		table.insert(in_carriages,train.carriages[k])
		--need to sort  traversing in reverse  closest shoud be last as first to pop off
		table.sort(in_carriages, function(c1,c2) return distance(c1.position.x,c1.position.y,from.position.x,from.position.y) > distance(c2.position.x,c2.position.y,from.position.x,from.position.y) end)
	end
	train.manual_mode = true
	--print("---------------")
	--for k=1,#in_carriages do
	--	print(distance(in_carriages[k].position.x,in_carriages[k].position.y,from.position.x,from.position.y))
	--end
	table.insert(global.modmashsplinterunderground.train_transfers,
		{in_train = train, out_train = train,in_carriages = in_carriages, out_carriages = {}, from=from, to=to, manual_mode =  manual_mode, new_mode = true}
	)
end

local local_on_train_changed_state = function(event)	
	
	local train = event.train
	local old_state = event.old_state
	if train.manual_mode == false and train.state == defines.train_state.arrive_signal and old_state ~= defines.train_state.arrive_signal then
		---print(train.station.name)
	elseif train.manual_mode == false and train.state == defines.train_state.wait_station and old_state ~= defines.train_state.wait_station then
		if train.station ~= nil and (train.station.name == "subway-level-one" or train.station.name == "subway-level-two") then	
			
			local station = train.station
			local surface = surfaces[station.surface.name]
			if surface == nil then return end				
			if ends_with(station.surface.name,"-deep-underground") == true then
				local stops = surfaces[surface.middle_name].stops
				for k=1, #stops do local s = stops[k]
					if s.bottom_entity == station then
						local_transport_train(train, s.bottom_entity,s.top_entity)
						break
					end
				end
			elseif ends_with(station.surface.name,"-underground") == true then
				
				if train.station.name == "subway-level-one" then
					local stops = surfaces[surface.top_name].stops
					for k=1, #stops do local s = stops[k]
						if s.bottom_entity == station then
							local_transport_train(train,s.bottom_entity,s.top_entity)
							break
						end
					end
				else
					local stops = surfaces[surface.middle_name].stops
					for k=1, #stops do local s = stops[k]
						if s.top_entity == station then
							local_transport_train(train,s.top_entity,s.bottom_entity)
							break
						end
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
			if station == nil then
				station = carriage.surface.find_entity("subway-level-two",carriage.position)
			end
			if station ~= nil then
				local surface = surfaces[station.surface.name]
				if surface == nil then return end	
				if ends_with(station.surface.name,"-deep-underground") == true then
					local stops = surfaces[surface.middle_name].stops
					for k=1, #stops do local s = stops[k]
						if s.bottom_entity == station then
							local_transport_train(train, s.bottom_entity,s.top_entity)
							break
						end
					end
				elseif ends_with(station.surface.name,"-underground") == true then
				
					if station.name == "subway-level-one" then
						local stops = surfaces[surface.top_name].stops
						for k=1, #stops do local s = stops[k]
							if s.bottom_entity == station then
								local_transport_train(train,s.bottom_entity,s.top_entity)
								break
							end
						end
					else
						local stops = surfaces[surface.middle_name].stops
						for k=1, #stops do local s = stops[k]
							if s.top_entity == station then
								local_transport_train(train,s.top_entity,s.bottom_entity)
								break
							end
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

local local_on_entity_spawned = function(event)
	local entity = event.entity
	if is_valid(entity) and entity.name ~= "queen-hive" then
		if entity.type =="unit-spawner" then
			if allow_biter_spawner(entity.surface) == false then
				entity.destroy({raise_destroy=false})
			else
				global.modmashsplinterunderground.surfaces[entity.surface.name].nests = global.modmashsplinterunderground.surfaces[entity.surface.name].nests+1
			end
		elseif entity.type =="unit" and string.find(entity.name,"biter") then
			if allow_biter(entity.surface) == false then
				entity.destroy({raise_destroy=false})
			else
				global.modmashsplinterunderground.surfaces[entity.surface.name].biters = global.modmashsplinterunderground.surfaces[entity.surface.name].biters+1
			end
		end					
	end
end
local local_on_biter_base_built = function(event)
	local entity = event.entity
	if is_valid(entity) and entity.name ~= "queen-hive" then
		if global.modmashsplinterunderground.surfaces[entity.surface.name]~=nil then
			if entity.type =="unit-spawner" then
				if global.modmashsplinterunderground.surfaces[entity.surface.name].nests ==nil then global.modmashsplinterunderground.surfaces[entity.surface.name].nests = 0 end
				global.modmashsplinterunderground.surfaces[entity.surface.name].nests = global.modmashsplinterunderground.surfaces[entity.surface.name].nests+1
			elseif entity.type =="unit" and string.find(entity.name,"biter") then
				if global.modmashsplinterunderground.surfaces[entity.surface.name].biters ==nil then global.modmashsplinterunderground.surfaces[entity.surface.name].biters = 0 end
				global.modmashsplinterunderground.surfaces[entity.surface.name].biters = global.modmashsplinterunderground.surfaces[entity.surface.name].biters+1
			end		
		end
	end
end

script.on_event(defines.events.on_entity_spawned,local_on_entity_spawned)
script.on_event(defines.events.on_biter_base_built,local_on_biter_base_built)
script.on_event(defines.events.on_entity_renamed, local_on_entity_renamed)

script.on_event(defines.events.on_train_changed_state, local_on_train_changed_state)

script.on_init(local_init)
script.on_load(local_load)
script.on_event({defines.events.on_player_joined_game,defines.events.on_player_created},local_on_player_spawned)
script.on_event(defines.events.on_cutscene_cancelled,local_cutscene_cancelled)
script.on_event(defines.events.on_chunk_generated,local_chunk_generated)
script.on_nth_tick(30, local_accumulators_tick)
script.on_event(defines.events.on_tick, local_underground_tick)
script.on_configuration_changed(local_on_configuration_changed)



script.on_event(defines.events.on_gui_opened, function(event)
	--if global.modmashsplinterunderground.train_ui == nil then global.modmashsplinterunderground.train_ui = {} end	
    local entity = event.entity
    if is_valid(entity) ~= true then return end
    if entity.type == "locomotive" or entity.type == "cargo-wagon" or entity.type == "fluid-wagon" or entity.type == "artillery-wagon" then
        global.modmashsplinterunderground.train_ui[event.player_index] = entity.unit_number
    end
end)

script.on_event(defines.events.on_gui_closed, function (event)
	--if global.modmashsplinterunderground.train_ui == nil then global.modmashsplinterunderground.train_ui = {} end	
    local entity = event.entity
    if is_valid(entity) ~= true or (entity.type ~= "locomotive" and entity.type ~= "cargo-wagon" and entity.type ~= "fluid-wagon" and entity.type ~= "artillery-wagon") then
        return
    end
    global.modmashsplinterunderground.train_ui[event.player_index] = nil
end)

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

script.on_event(defines.events.script_raised_destroy,
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
		ban_entity_level_two = local_ban_entity_level_two,
		try_add_entity = local_try_add_entity
	})