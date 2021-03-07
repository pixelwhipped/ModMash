require("prototypes.scripts.defines") 
if not global.modmashsplinterthem then global.modmashsplinterthem = {} end
local base_builder = require("prototypes.scripts.build") 
local rebuild_names = {"them-roboport","them-chest","them-chest-energy-converter","them-solar-panel","them-transport-belt","them-underground-belt-structure","them-mini-loader-structure","them-small-electric-pole"}


local distance = modmashsplinterthem.util.distance
local is_valid  = modmashsplinterthem.util.is_valid
local table_index_of  = modmashsplinterthem.util.table.index_of
local table_contains = modmashsplinterthem.util.table.contains
local starts_with  = modmashsplinterthem.util.starts_with
local ends_with  = modmashsplinterthem.util.ends_with
local local_table_remove = modmashsplinterthem.util.table.remove
local is_valid_and_persistant = modmashsplinterthem.util.entity.is_valid_and_persistant
local fail_place_entity  = modmashsplinterthem.util.fail_place_entity

local surfaces = nil
local surface_names = nil
local surfaces_per_tick = 2
local exclude_all_targets = {"character","transport-belt","underground-belt","loader", "splitter","logistic-container","container","constant-combinator"}
local exclude_targets = {"transport-belt","underground-belt","loader", "splitter","logistic-container","container","constant-combinator"}

local minimal_energy = 1000
local max_useable_iterations = 10
local beam_life = 60*3
local end_game_energy = 10000 -- reduce just made crazy to avoid
local resource_gain_event = 0


--common functions section
	local local_create_beam = function(source,target,beam_name,time)
		if is_valid(source) and is_valid(target) then
			if beam_name == nil then beam_name = "them-electric-beam" end
			if time == nil then time = beam_life end
			if target.type=="resource" then
				return source.surface.create_entity
				{
				  name = beam_name,
				  source = source,
				  target_position = target.position,
				  position = source.position,
				  force = source.force,
				  duration = time
				}
			else
				return source.surface.create_entity
				{
				  name = beam_name,
				  source = source,
				  target = target,
				  position = source.position,
				  force = source.force,
				  duration = time
				}
			end
		end
		end
	
	local local_rebuid_count = function(surface)
		local c = 0
		for k=1, #rebuild_names do 
			for j = #surface.rebuild[rebuild_names[k]],1,-1 do		
				if surface.surface.find_entity(rebuild_names[k], surface.rebuild[rebuild_names[k]][j].position) ~= nil then
					table.remove(surface.rebuild[rebuild_names[k]],j)
				else
					c = c + 1
				end
			end
		end
		return c
		end	

	local value_builder = function(min,max,iteration,max_iteration)
		local v = iteration/max_iteration
		local d = math.max(min,max)- math.min(min,max)
		return math.min(min,max) + (d*v)
		end

	local reverse_value_builder = function(min,max,iteration,max_iteration)
		local v = iteration/max_iteration
		local d = math.max(min,max)- math.min(min,max)
		return math.max(min,max) - (d*v)
		end
--end common functions section

--[[
--debug section
	local debug_surface_sensor = function(player)
	  if surfaces[player.surface.name] ~= nil then
		local s = surfaces[player.surface.name]
		return {"","Enemy progress",string.format(" = %.2f", ((s.energy + s.end_game_saving)/end_game_energy))} 
	  end
	  return {"","nil"}
	end
	local debug_cooldown_sensor = function(player)
	  if surfaces[player.surface.name] ~= nil then
		local s = surfaces[player.surface.name]
		return {"","Enemy cooldown",string.format(" = %.2f", ((s.spawn_base_cooldown/60)/60))} 
	  end
	  return {"","nil"}
	end
	local debug_rebuild_sensor = function(player)
	  if surfaces[player.surface.name] ~= nil then
		local s = surfaces[player.surface.name]
		return {"","Enemy build que",(" = "..local_rebuid_count(s))} 
	  end
	  return {"","nil"}
	end
	
	local function register_sensors()
	  if modmashsplinterthem.debug == true and script.active_mods["StatsGui"] and remote.call("StatsGui", "version") == 1 then
		remote.call("StatsGui", "add_sensor", "modmashsplinterthem", "debug_surface_sensor")
		remote.call("StatsGui", "add_sensor", "modmashsplinterthem", "debug_cooldown_sensor")
		remote.call("StatsGui", "add_sensor", "modmashsplinterthem", "debug_rebuild_sensor")
	  end
	end
	
	if modmashsplinterthem.debug == true then
		remote.add_interface("modmashsplinterthem", {
		  debug_surface_sensor = debug_surface_sensor,
		  debug_cooldown_sensor = debug_cooldown_sensor,
		  debug_rebuild_sensor = debug_rebuild_sensor
		})
	end
--end debug section
--]]
--init section
	--to make initialization of new emeny dynamic harder the more times they spawn from new(not expand)
	local local_init_surface = function(surface)
		local iteration = 1
		if table_contains(surface_names,surface.name) then 
			iteration = surfaces[surface.name].iteration or 1
			iteration = iteration + 1
		end
		local data = 
		{
			started = game.ticks_played,
			iteration = iteration,
			surface = surface,
			bases = {},
			conversion_efficiency = value_builder(0.5,2.5,iteration,max_useable_iterations),
			passive_energy_gain = value_builder(0.05,5,iteration,max_useable_iterations),
			energy = value_builder(100,1000,iteration,max_useable_iterations),
			base_defence_radius = value_builder(16,32,iteration,max_useable_iterations),
			bots_per_port = value_builder(25,150,iteration,max_useable_iterations),
			loader_checks = {},
			ports = {},
			ghosts = {},
			chests = {},
			converters = {},
			rebuild = {},
			attack_projectiles = {},
			attack_projectile_range= value_builder(192,256,iteration,max_useable_iterations),
			attack_health_stack = {},
			raid_projectiles = {},
			raid_projectile_range= value_builder(192,256,iteration,max_useable_iterations),
			raid_health_stack = {},
			harvest_projectiles = {},
			harvest_health_stack = {},	
			return_health_stack = {},
			steal_requested = false,
			steal_range = value_builder(192,256,iteration,max_useable_iterations),
			max_bases = value_builder(15,32,iteration,max_useable_iterations),
			energy_required_per_item = reverse_value_builder(150,75,iteration,max_useable_iterations),
			harvest_chance = 20,
			raid_chance = 20,
			attack_chance = value_builder(10,20,iteration,max_useable_iterations), -- more aggresive over time
			expand_chance = 10,
			bot_chance = 10,
			steal_chance = 10,
			end_game_chance = 5,
			end_game_saving = 0,
			flags = {},
			veins = {},
			max_veins = value_builder(3,10,iteration,max_useable_iterations),

		}
		data.spawn_base_cooldown = 60*60*math.random(6,reverse_value_builder(8,25,iteration,max_useable_iterations))		
		--if modmashsplinterthem.debug == true and iteration == 1 then data.spawn_base_cooldown=0 end	--todo remove only for debug
		
		for k=1, #rebuild_names do data.rebuild[rebuild_names[k]] = {} end
		if table_contains(surface_names,surface.name) == false then
			table.insert(surface_names,surface.name)
		end
		return data
	end

	--called when last port on surface destroyed resulting in a new build + modifies to make enemies harder
	local local_clear_surface = function(surface)
		local kill = surface.surface.find_entities_filtered {name = rebuild_names}
		for k=1, #kill do local e = kill[k]
			if is_valid(e) then
				e.die(e.force,e)
			end
		end
		surfaces[surface.surface.name] = local_init_surface(surface.surface)	
	end

	local local_register_surface = function(surface)
		if surfaces[surface.name] ~= nil then return end
		if ends_with(surface.name,"underground") == true then return end  --no undergrounds
		surfaces[surface.name] = local_init_surface(surface)
	end

	local local_init = function()	
		if global.modmashsplinterthem == nil then global.modmashsplinterthem = {} end
		if global.modmashsplinterthem.surfaces == nil then global.modmashsplinterthem.surfaces = {} end
		if global.modmashsplinterthem.surface_names == nil then global.modmashsplinterthem.surface_names = {} end
		if global.modmashsplinterthem.mines == nil then global.modmashsplinterthem.mines = {} end
		surfaces = global.modmashsplinterthem.surfaces
		surface_names = global.modmashsplinterthem.surface_names	
		--register_sensors()
		end

	local local_load = function()	
		surfaces = global.modmashsplinterthem.surfaces
		surface_names = global.modmashsplinterthem.surface_names	
		--register_sensors()
		end
--end init section


local local_next_point = function(direction,position)
	if direction == 0 then return {x=position.x,y=position.y-1} end
	if direction == 4 then return {x=position.x,y=position.y+1} end
	if direction == 2 then return {x=position.x+1,y=position.y} end
	return {x=position.x-1,y=position.y}
end

local local_get_options_unclean = function (surface,directions,current,target)
	local ret = {}
	local p1 = local_next_point(directions[1],current)
	local p2 = local_next_point(directions[2],current)
	local p3 = local_next_point(directions[3],current)
	if p1.x == target.x and p1.y == target.y then return {{name="them-transport-belt", position=p1, direction = directions[1]}} end
	if p2.x == target.x and p2.y == target.y then return {{name="them-transport-belt", position=p2, direction = directions[2]}} end
	if p3.x == target.x and p3.y == target.y then return {{name="them-transport-belt", position=p3, direction = directions[3]}} end

	--or true due to issue with can_add_entity returning false  works when entity not actually placed?
	if base_builder.can_add_entity(surface,"them-transport-belt", p1.x, p1.y, 0, 0) then table.insert(ret,{name="them-transport-belt", position=p1, direction = directions[1]}) end
	if base_builder.can_add_entity(surface,"them-transport-belt", p2.x, p2.y, 0, 0)  then table.insert(ret,{name="them-transport-belt", position=p2, direction = directions[2]}) end
	if base_builder.can_add_entity(surface,"them-transport-belt", p3.x, p3.y, 0, 0) then table.insert(ret,{name="them-transport-belt", position=p3, direction = directions[3]}) end
	if #ret == 0 then return nil end
	if #ret == 1 then return ret end
	if #ret == 2 then 
		if distance(ret[1].position.x,ret[1].position.y,target.x,target.y)<distance(ret[2].position.x,ret[2].position.y,target.x,target.y) then
			return ret
		else
			return {ret[2],ret[1]}
		end
	end
	if distance(ret[1].position.x,ret[1].position.y,target.x,target.y)<distance(ret[2].position.x,ret[2].position.y,target.x,target.y) then
		--1 before 2
		if distance(ret[2].position.x,ret[2].position.y,target.x,target.y)<distance(ret[3].position.x,ret[3].position.y,target.x,target.y) then
			return ret
		else			
			-- 2 after 3
			if distance(ret[3].position.x,ret[3].position.y,target.x,target.y)<distance(ret[1].position.x,ret[1].position.y,target.x,target.y) then
				return {ret[3],ret[1],ret[2]}
			else
				return {ret[1],ret[3],ret[2]}
			end
		end
	else 
		--2 before 1
		if distance(ret[1].position.x,ret[1].position.y,target.x,target.y)<distance(ret[3].position.x,ret[3].position.y,target.x,target.y) then
			return {ret[2],ret[1],ret[3]}
		else
			if distance(ret[3].position.x,ret[3].position.y,target.x,target.y)<distance(ret[2].position.x,ret[2].position.y,target.x,target.y) then
				return {ret[3],ret[2],ret[1]}
			else
				return {ret[2],ret[3],ret[1]}
			end
		end
	end
end


local local_get_options = function (surface,directions,current,target,exiting)
	local opts = local_get_options_unclean(surface,directions,current,target)
	if opts == nil then return nil end
	if #exiting == 0 then return opts end
	local ret = {}
	for k=1,#opts do
		local safe = true
		for j=1,#exiting do
			if exiting[j].position.x == opts[k].position.x and exiting[j].position.y == opts[k].position.y then
				safe = false
				break
			end
		end
		if safe == true then table.insert(ret,opts[k]) end
	end
	if #ret == 0 then return nil end
	return ret
end

local local_has_belt_neighbours = function(belt)
	if belt == nil then return false end
	local sum = 0
	for k, v in pairs(belt) do
		sum = sum + #v
	end
	return sum
end

local local_belt_theft_existing_before_condition = function(surface, entity)
	if is_valid(entity) ~= true then return false end
	
	for n,v in pairs(entity.belt_neighbours) do
		local e = entity.belt_neighbours[n]		
		for k = 1, 50 do
			for j = 1, #e do
				if e[j].name == "them-transport-belt" then 
					return false 
				end
			end		
			if #e > 0 then
				e = e[1].belt_neighbours[n]
			end
		end
	end
	return true
end

local local_belt_theft_complexity_condition = function(surface, entity)
	if is_valid(entity) ~= true then return false end
	if surface.iteration == 1 then return true end
	if surface.iteration == 2 then return (entity.get_transport_line(1).get_item_count()+entity.get_transport_line(2).get_item_count()) > 0 end
	return (entity.get_transport_line(1).get_item_count()+entity.get_transport_line(2).get_item_count()) > 0 and local_has_belt_neighbours(entity.belt_neighbours) > 1
end

local local_find_steal_target = function(surface,end_pos, area)
	local e = surface.surface.find_entities_filtered{type="transport-belt", force="player",area = area, limit = 50}
	if #e==0 then return nil end
	local target = nil
	for k=1,#e do
		if local_belt_theft_existing_before_condition(surface,e[k]) and local_belt_theft_complexity_condition(surface,e[k]) == true then
			if target == nil then 
				target = e[k]
			end 
			if distance(end_pos.position.x,end_pos.position.y,target.position.x,target.position.y) >
					distance(end_pos.position.x,end_pos.position.y,e[k].position.x,e[k].position.y) then
				target = e[k]
			end
		end
	end
	return target
end

local local_update_steal = function(surface)
	if #surface.bases == 0 then return end
	if #surface.veins > surface.max_veins then return end
	if surface.current_steal_build ~= nil then return end
	if surface.steal_requested ~= true then return end
	if surface.steal == nil then
		local hr = (modmashsplinterthem.port_range/2)*0.9
		local bi = math.random(1,#surface.bases)
		local base = surface.bases[bi]
		local d = math.random(1,4)
		local target = nil
		local start_pos = nil
		local end_pos = nil
		local connection = nil
		local dtests = nil
		--can only get in from bottom or left
		if d==1 then  --(tested)try to steal from belts upward
			end_pos = {name="them-transport-belt", position={x=base.position.x+4.5,y=base.position.y-0.5}, direction = 4}
			target = local_find_steal_target(surface,end_pos,{{base.position.x-hr, base.position.y-hr}, {base.position.x+hr, base.position.y}})
			
			if target == nil then 
				surface.steal_requested = false
				return
			end			
			connection = "top"
			if base.connections[connection].marked == true then 
				surface.steal_requested = false
				return
			end			
			base.connections[connection].marked = true
			start_pos = {name="them-transport-belt", position={x=target.position.x,y=target.position.y}, direction = 4}
			if target.position.x<end_pos.position.x then
				dtests = {4,2,6}  --target is to left so prefer right(2) over left(6) and alway down(4)
			else
				dtests = {4,6,2}  --target is to left so prefer left(6) over right(2) and alway down(4)
			end
		elseif d==2 then	--(tested)down
			end_pos = {name="them-transport-belt", position={x=base.position.x+5.5,y=base.position.y+11.5}, direction = 0}
			target = local_find_steal_target(surface,end_pos,{{base.position.x-hr, base.position.y+11.5}, {base.position.x+hr, base.position.y+hr+11.5}})
			if target == nil then 
				surface.steal_requested = false
				return
			end			
			connection = "bottom"
			if base.connections[connection].marked == true then 
				surface.steal_requested = false
				return
			end			
			base.connections[connection].marked = true
			start_pos = {name="them-transport-belt", position={x=target.position.x,y=target.position.y}, direction = 0}
			if target.position.x<end_pos.position.x then
				dtests = {0,2,6}  --target is to left so prefer right(2) over left(6) and alway up(0)
			else
				dtests = {0,6,2}  --target is to left so prefer left(6) over right(2) and alway up(0)
			end
		elseif d==3 then	--left
			local tl = {x=base.position.x-hr, y=base.position.y-hr}
			local br = {x=base.position.x+0.5, y=base.position.y+hr}
			end_pos = {name="them-transport-belt", position={x=base.position.x-0.5,y=base.position.y+4.5}, direction = 2}
			target = local_find_steal_target(surface,end_pos,{{tl.x, tl.y},{br.x, br.y}})
			if target == nil then 
				surface.steal_requested = false
				return
			end			
			connection = "left"
			if base.connections[connection].marked == true then
				surface.steal_requested = false
				return
			end			
			base.connections[connection].marked = true
			start_pos = {name="them-transport-belt", position={x=target.position.x,y=target.position.y}, direction = 2}
			if target.position.y<end_pos.position.y then
				dtests = {2,0,4} 
			else
				dtests = {2,4,0}  
			end
		else	--right
			local tl = {x =base.position.x+11.5, y=base.position.y-hr-5.5}
			local br = {x=base.position.x+hr+11.5, y=base.position.y+hr+5.5}
			end_pos = {name="them-transport-belt", position={x=base.position.x+11.5,y=base.position.y+5.5}, direction = 6}
			target = local_find_steal_target(surface,end_pos,{{tl.x, tl.y},{br.x, br.y}})
			if target == nil then 
				surface.steal_requested = false
				return 
			end			
			connection = "right"
			if base.connections[connection].marked == true then 
				surface.steal_requested = false
				return
			end			
			base.connections[connection].marked = true
			start_pos = {name="them-transport-belt", position={x=target.position.x,y=target.position.y}, direction = 6}
			if target.position.y<end_pos.position.y then
				dtests = {6,0,4}  
			else
				dtests = {6,4,0}  
			end
		end
		surface.steal =
		{
			base_index = bi,
			connection = connection,
			target = target,
			start_pos = start_pos,
			end_pos = end_pos,
			movements = dtests,
			belts = {start_pos}
		}
	else
		local options = local_get_options(surface,surface.steal.movements,surface.steal.belts[#surface.steal.belts].position,surface.steal.end_pos.position,surface.steal.belts)
		
		if options == nil then
			surface.bases[surface.steal.base_index].connections[surface.steal.connection].marked = false
			surface.steal = nil 
			surface.steal_requested = false
			return
		end
		if is_valid(surface.steal.target) == false then
			surface.bases[surface.steal.base_index].connections[surface.steal.connection].marked = false
			surface.steal = nil 
			surface.steal_requested = false
			return
		end
		local failedbydir = false
		if surface.steal.connection == "top" and options[1].position.y > surface.steal.end_pos.position.y then failedbydir = true end
		if surface.steal.connection == "bottom" and options[1].position.y < surface.steal.end_pos.position.y then failedbydir = true end
		if surface.steal.connection == "left" and options[1].position.x > surface.steal.end_pos.position.x then failedbydir = true end
		if surface.steal.connection == "right" and options[1].position.x < surface.steal.end_pos.position.x then failedbydir = true end

		if failedbydir == true then
			surface.bases[surface.steal.base_index].connections[surface.steal.connection].marked = false
			surface.steal = nil 
			surface.steal_requested = false
			return
		end
		--complete
		if options[1].position.x == surface.steal.end_pos.position.x and options[1].position.y == surface.steal.end_pos.position.y then
			local base = {}
			table.insert(surface.steal.belts,options[1])
			
			if #surface.steal.belts == 1 then				
				--base_builder.add_belt(surface, surface.steal.belts[1].position.x, surface.steal.belts[1].position.y,surface.steal.belts[1].direction, false, 0,0)
				table.insert(base,{name="them-transport-belt", position=surface.steal.belts[1].position, direction = 2})
			else
				for k = 1, #surface.steal.belts-1 do 
					local belt = surface.steal.belts[k]
					local next_belt = surface.steal.belts[k+1]
					if (belt.direction == 4 or belt.direction == 0) and next_belt.position.x~=belt.position.x then
						belt.direction = next_belt.direction
					end
					if (belt.direction == 6 or belt.direction == 2) and next_belt.position.y~=belt.position.y then
						belt.direction = next_belt.direction
					end
				end
				surface.steal.belts[#surface.steal.belts].direction = surface.steal.movements[1]
				for k = 1, #surface.steal.belts do 
					local belt = surface.steal.belts[k]
					--base_builder.add_belt(surface, belt.position.x, belt.position.y,belt.direction, false, 0,0)
					table.insert(base,{name="them-transport-belt", position=belt.position, direction = belt.direction})
				end
			end
			-- add condition and relabel as vein if vail not nill then next base is vein
			local b = base_builder.build_base(surface,0,0,base,true)	
			table.insert(surface.veins,b)
			surface.steal = nil
			surface.steal_requested = false
			return
		end
		--test if belt exists we have an intersect
		table.insert(surface.steal.belts,options[1])
		--base_builder.add_concrete(surface,options[1].name, options[1].position.x, options[1].position.y, 0, 0)
	end


end

--each tick per surface.  
--checks for loaders including filter
local local_tick_surface = function(surface)
	resource_gain_event = 0
	for k=#surface.loader_checks, 1, -1 do
		local e = surface.surface.find_entity("them-mini-loader-structure",surface.loader_checks[k].position)
		
		if is_valid(e) then			
			if surface.loader_checks[k].loader_type == "output" then
				e.set_filter(1,"them-matter-cube") --stop rebuild items falling out
			end
			e.loader_type = surface.loader_checks[k].loader_type
			table.remove(surface.loader_checks, k)
		end
		
	end
	local_update_steal(surface)
end

local local_update_mines = function()
	if #global.modmashsplinterthem.mines == 0 then return end
	local tindex = global.modmashsplinterthem.mine_update_index
	if tindex == nil or  tindex > global.modmashsplinterthem.mine_update_index then 
		global.modmashsplinterthem.mine_update_index = 1
		tindex = 1
	end
	local tnumiter = 0
	local tupdates = math.min(#surface_names,4)
	local mines  = global.modmashsplinterthem.mines
	local detonate = false

	for k = tindex, #mines do 		
		local mine = global.modmashsplinterthem.mines[k]
		if k >= #mines then k = 1 end
		if is_valid(mine)then
			local targets = mine.surface.find_entities_filtered{position = mine.position, radius=16, force="enemy"}
			for j =1, #targets do local t = targets[j]
				if is_valid(t) then
					if starts_with(t.name,"them-robot") then
						detonate = true
						j = #targets
					end
				end
			end
			if detonate == true then
				targets = mine.surface.find_entities_filtered{position = mine.position, radius=32}
				for j =1, #targets do local t = targets[j]
					if is_valid(t) then						
						if starts_with(t.name,"them-robot") then
							t.die()
						else
							t.energy = -1000
						end
					end
				end
				mine.die()
			end
		end
		tnumiter = tnumiter + 1
		if tnumiter >= tupdates then 
			global.modmashsplinterthem.mine_update_index = k
			k = #mines + 1 -- break
		end
	end
end

--convert chest items to matter and update surfaces
local local_tick = function()
	--we need to convert all items in chest to matter cubes
	--note converters contain items to rebuild so no check required there for each tick. doing so would result in extract checking/slow down. negative effect is all convertes destroyed base must die too
	for name, surface  in pairs (surfaces) do
		for k=1, #surface.chests do local entity = surface.chests[k]
			if is_valid(entity) == true then
				local from = entity.get_inventory(defines.inventory.chest)
				if from ~= nil then
					for n, c  in pairs (from.get_contents()) do
						if n~=nil and n~= "them-matter-cube" then	
							from.remove({name=n,count=c})						
							if from.can_insert({name="them-matter-cube",count=c}) then
								from.insert({name="them-matter-cube",count=c})						
							end
						end
					end	
				end
			end
		end
	end
	--update x surfaces per tick
	local tindex = global.modmashsplinterthem.surface_update_index
	if not tindex then 
		global.modmashsplinterthem.surface_update_index = 1
		tindex = 1
	end
	local tnumiter = 0
	local tupdates = math.min(#surface_names,surfaces_per_tick)
	for k = tindex, #surface_names do 		
		local_tick_surface(surfaces[surface_names[k]])
		if k >= #surface_names then k = 1 end
		tnumiter = tnumiter + 1
		if tnumiter >= tupdates then 
			global.modmashsplinterthem.surface_update_index = k
			k = #surface_names + 1 -- break
		end
	end


	local_update_mines()
end

local local_insert_bot = function(surface,port)
	if surface.energy > surface.energy_required_per_item and port.get_inventory(defines.inventory.roboport_robot).can_insert("them-robot") then
		port.get_inventory(defines.inventory.roboport_robot).insert({name="them-robot",count=1})
		surface.energy = surface.energy - surface.energy_required_per_item
		return true
	end
	return false
end

local local_return_home = function(surface,projectile, index, projectiles)
	if #surface.ports>=1 then
		local t = surface.ports[math.random(1, #surface.ports)] --enhance could sort by distance
		t.surface.create_entity{name='them-robot-projectile', speed=0.06, position=projectile.entity.position, force="enemy", target=t.position}
		if projectile.entity.health < projectile.entity.prototype.max_health then table.insert(surface.return_health_stack,projectile.entity.health) end
			projectile.entity.destroy({raise_destroy = true})
		table.remove(projectiles,index)
	else									
		projectile.entity.die() --whoops no ports die
	end
end

local local_update_converters = function(surface)
	local rebuild_priority = false
	for k=#surface.converters,1,-1 do local entity = surface.converters[k] 
		if is_valid(entity) == true then
			local from = entity.get_inventory(defines.inventory.chest)
			if from ~= nil then
				for j=1, #rebuild_names do local name = rebuild_names[j]
					if surface.rebuild[name] ~= nil and #surface.rebuild[name] > from.get_item_count(name) then							
						-- possibe duplicates but they will be removed when no longer the case this also enusres availbility from closest could check network storage maybe
						if from.can_insert({name = name, count = 1}) and surface.energy > surface.energy_required_per_item then
							from.insert({name = name, count = 1})
							surface.energy = surface.energy - surface.energy_required_per_item
						else
							rebuild_priority = true
						end
					end					
				end
				for n, c  in pairs (from.get_contents()) do
					if n~=nil and (surface.rebuild[n] == nil or #surface.rebuild[n] == 0) then	
						from.remove({name=n,count=c})							
						surface.energy = surface.energy + (c*surface.conversion_efficiency)
					end
				end	
			end
		end
	end
	return rebuild_priority
	end

local update_raid_projectiles = function(surface,ticks)
	for k=#surface.raid_projectiles,1,-1 do local projectile = surface.raid_projectiles[k] 
		if projectile ~= nil then
			projectile.time_to_live = projectile.time_to_live - ticks
			if is_valid(projectile.entity) == true then
				if projectile.time_to_live <= 0 then --return
					if projectile.count ~= nil and projectile.count > 0 then
						local chest = nil
						if #surface.chests > 0 then
							chest = surface.chests[math.random(1, #surface.chests)]
						elseif #surface.converters > 0 then --fail try fall back
							chest = surface.converters[math.random(1, #surface.chests)]
						end
						if is_valid(chest) then
							local from = chest.get_inventory(defines.inventory.chest)
							if from ~= nil then					
								if from.can_insert({name="them-matter-cube",count=projectile.count}) then
									from.insert({name="them-matter-cube",count=projectile.count})		
								else
									--just convert to energy
									surface.energy = surface.energy + (projectile.count*surface.conversion_efficiency)
								end
							end
						end
					end
					local_return_home(surface,projectile,k,surface.raid_projectiles)
				elseif projectile.target == nil then
					local targets =  projectile.entity.surface.find_entities_filtered{type={"container","logistic-container"},force="player", position=projectile.entity.position, radius = 5}
					if #targets > 0 then
						projectile.target = targets[math.random(1, #targets)] --sort and go by closest
						if is_valid(projectile.target) then
							local from = projectile.target.get_inventory(defines.inventory.chest)
							local total_removed = 0
							if from ~= nil then
								for n, c  in pairs (from.get_contents()) do
									if total_removed<50 and n~=nil then	
										total_removed = total_removed + c
										from.remove({name=n,count=c})						
									end
								end	
							end
							if total_removed > 0 then
								local_create_beam(projectile.entity,projectile.target,"them-electric-raid-beam",projectile.time_to_live)
								projectile.count = total_removed
							end
						end
					end	
				end
			end
		else
			table.remove(surface.raid_projectiles,k)
		end
	end
end

local update_attack_projectiles = function(surface,ticks)
	for k=1, #surface.attack_projectiles do local projectile = surface.attack_projectiles[k] 
		if projectile ~= nil then
			--if attack complete check if more enemy close by or return as normal bot
			projectile.time_to_live = projectile.time_to_live - ticks
			projectile.target_time_to_live = projectile.target_time_to_live - ticks
		
			if is_valid(projectile.entity) == true then
				if projectile.time_to_live <=0 then
					local_return_home(surface,projectile,k,surface.attack_projectiles)
				elseif projectile.target_time_to_live <=0 and is_valid(projectile.target) == false then
					projectile.target = nil
					--attack some things, leave chests belts etc  other entites are auto targeted anyway
					local targets =  projectile.entity.surface.find_entities_filtered{force="player", position=projectile.entity.position, radius = surface.attack_projectile_range, limit=15}

					local new_targets = {}	--invert = true dosn't work
					for j=1, #targets do
						if table_contains(exclude_targets,targets[j].type) == false then
							table.insert(new_targets,targets[j])
						end
					end
					if #new_targets >= 1 then
						projectile.target_time_to_live = beam_life
						local t = new_targets[math.random(1, #new_targets)]
						if is_valid(t) and t.health ~=nil then
							t.health = t.health - 50
							local_create_beam(projectile.entity,t)
							if t.health <= 0 then
								t.die()
								projectile.target_time_to_live = 0
								projectile.target = nil
							else
								projectile.target = t
							end
						else
							local_return_home(surface,projectile,k,surface.attack_projectiles)
						end
					else
						local_return_home(surface,projectile,k,surface.attack_projectiles)
					end
				end
			end
		else
			table.remove(surface.attack_projectiles,k)
		end
	end
end

local update_harvest_projectiles = function(surface,ticks)
	for k=#surface.harvest_projectiles,1,-1 do local projectile = surface.harvest_projectiles[k] 
		if projectile ~= nil then
			projectile.time_to_live = projectile.time_to_live - ticks
			if is_valid(projectile.entity) == true then
				if projectile.time_to_live <=0 then
					local t = surface.ports[math.random(1, #surface.ports)]
					t.surface.create_entity{name='them-robot-projectile', speed=0.06, position=projectile.entity.position, force="enemy", target=t.position}
					if projectile.entity.health <  projectile.entity.prototype.max_health then table.insert(surface.return_health_stack,projectile.entity.health) end
					projectile.entity.destroy({raise_destroy = true})
					table.remove(surface.harvest_projectiles,k)
				else
					if projectile.target == nil then
						local targets =  projectile.entity.surface.find_entities_filtered{type={"resource"}, position=projectile.entity.position, radius = 6.0}
						if #targets > 0 then						
							local t = targets[math.random(1, #targets)]	
							projectile.target = t
							local_create_beam(projectile.entity,t,nil,projectile.time_to_live)
							local amount = math.min(35,t.amount)
							local r = t.amount - amount;
							if r == 0 then
								t.destroy()
							else
								t.amount = r
								local chest = surface.chests[1]
								if #surface.chests > 1 then
									chest = surface.chests[math.random(1, #surface.chests)]
								end
								if is_valid(chest) then
									local from = chest.get_inventory(defines.inventory.chest)
									if from ~= nil then					
										if from.can_insert({name="them-matter-cube",count=amount}) then
											from.insert({name="them-matter-cube",count=amount})		
										else
											--just convert to energy
											surface.energy = surface.energy + (amount*surface.conversion_efficiency)
										end
									end
								end
							end
						else
							local_return_home(surface,projectile, k, surface.harvest_projectiles)
						end
					end
				end
			end
		else
			table.remove(surface.harvest_projectiles,k)
		end
	end
end


local check_interupt_belt = function(surface)
	local redo = {}
	local mark = {}
	for k=1,#surface.current_base_build.base do local structure = surface.current_base_build.base[k]
		if structure~=nil then
			if surface.surface.find_entity(structure.name,{x=surface.current_base_build.position.x+structure.position.x,y=surface.current_base_build.position.y+structure.position.y}) == nil then 
				local targets = surface.surface.find_entities_filtered{force = {"neutral","player"},position={x=surface.current_base_build.position.x+structure.position.x,y=surface.current_base_build.position.y+structure.position.y}}
				--if tagets may be something in our way check if it a belt otherwise
				for j = 1, #targets do
					if targets[j].to_be_deconstructed() == false then
						table.insert(mark,targets[j])
						table.insert(redo,structure)						
					end
				end
			end
		end
	end
	for k = 1, #mark do
		mark[k].force = "enemy"
		mark[k].order_deconstruction("enemy")
		if mark[k].to_be_deconstructed() == false then mark[k].destroy({raise_destroy = true}) end
	end
	for k = 1, #redo do
		base_builder.add_belt(surface, surface.current_base_build.position.x, surface.current_base_build.position.y,redo[k].direction, true, redo[k].position.x,redo[k].position.y)
	end
end

local check_current_base_build = function(surface)
	if surface.current_base_build.is_vein == false then
		for k=1,#surface.current_base_build.base do local structure = surface.current_base_build.base[k]
			if structure~=nil then			
				if surface.surface.find_entity(structure.name,{x=surface.current_base_build.position.x+structure.position.x,y=surface.current_base_build.position.y+structure.position.y}) == nil then return end
			end
		end
	else
		if check_interupt_belt(surface) == false then
			surface.current_base_build = nil
		else
			for k=1,#surface.current_base_build.base do local structure = surface.current_base_build.base[k]
				if structure~=nil then
					if surface.surface.find_entity(structure.name,{x=surface.current_base_build.position.x+structure.position.x,y=surface.current_base_build.position.y+structure.position.y}) == nil then return end
				end
			end
		end
	end
	if is_vein == false then
		base_builder.build_base(surface,surface.current_base_build.position.x,surface.current_base_build.position.y,surface.current_base_build.base,false)
	end
	surface.current_base_build = nil
	surface.spawn_base_cooldown = 60*60*math.random(6,reverse_value_builder(8,25,surface.iteration,max_useable_iterations))	
end

local local_round = function(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

local local_get_start = function(surface)
	local t = surface.surface.find_entities_filtered{force ="player", limit=50}
	if #t == 0 then return nil end
	t = t[math.random(1,#t)]
	local x = math.random(96,192)
	local y = math.random(96,192)
	if math.random(1,100) < 50 then
		x = x*-1
	end
	if math.random(1,100) < 50 then
		y = y*-1
	end
	local pos = {x=local_round(t.position.x+x),y=local_round(t.position.y+y)}
	local x = surface.surface.find_entities_filtered{type={"resource"}, position=pos, radius = (surface.raid_projectile_range*0.5)}
	if #x < 1 then return nil end
	--for k=1, #x do
	--	modmashsplinterthem.util.print(x[k].name)
	--end
	return pos
end

local check_base_exists = function(surface)
	if #surface.ports == 0 then		
		--modmashsplinterthem.util.print(surface.spawn_base_cooldown)
		if surface.spawn_base_cooldown <= 0 then
			--todo randomize
			local pos = local_get_start(surface)
			if pos == nil then return false end
			local px =  pos.x
			local py =  pos.y
			if base_builder.can_build_base(surface,px,py,surface.flags.next_base) == true then
				if global.modmashsplinterthem.arrival_acheivement == nil then
					for i = 1, #game.players do local p = game.players[i]
						p.unlock_achievement("them_arrival")
					end	
					global.modmashsplinterthem.arrival_acheivement = true
				end
				local b = base_builder.build_base(surface,px,py,surface.flags.next_base,false)
				b.index = #surface.bases+1
				if #b.ports > 0 then
					local port = b.ports[math.random(1,#b.ports)]
					if is_valid(port) then
						port = surface.surface.find_entity("them-roboport", port.position)
						if port ~= nil then port.get_inventory(defines.inventory.roboport_robot).insert({name="them-robot",count=5}) end
					end
				end			
				table.insert(surface.bases,	b) 
				surface.spawn_base_cooldown = 60*60*math.random(6,reverse_value_builder(8,25,surface.iteration,max_useable_iterations))		
				--if modmashsplinterthem.debug == true then surface.spawn_base_cooldown=60*60 end
			else
				return false
			end
		else
			return false
		end
	end
	return true
end

local local_update_defense = function(surface)
	---if true then return false end
	local defend_priority = false
	for k=1, #surface.ports do
		local port = surface.ports[k]
		if is_valid(port) then
			local targets = surface.surface.find_entities_filtered{force="player", position=port.position, radius = surface.base_defence_radius}
			if #targets > 0 then
				local x = targets[math.random(1, #targets)]
				if x.name ~= "entity-ghost" then 
					if port.get_inventory(defines.inventory.roboport_robot).get_item_count("them-robot") > 0 then
						local removed = port.get_inventory(defines.inventory.roboport_robot).remove({name ="them-robot",count=1})					
						if removed > 0 then				
							port.surface.create_entity({
								name='them-robot-projectile-combat',
								force=port.force,
								position=port.position,
								speed=0.6,
								source=port,
								target=x.position
								})	
						elseif surface.energy > surface.energy_required_per_item then --no bots but enough energy to create do now
							if #surface.attack_projectiles < #surface.ports*surface.bots_per_port then
								if port.get_inventory(defines.inventory.roboport_robot).can_insert("them-robot") then
									if modmashsplinterthem.debug == true then surface.last_ai_event = "Add them-robot" end
									port.get_inventory(defines.inventory.roboport_robot).insert("them-robot")
									surface.energy = surface.energy - surface.energy_required_per_item
								end
								removed = port.get_inventory(defines.inventory.roboport_robot).remove({name ="them-robot",count=1})					
								if removed > 0 then		
									port.surface.create_entity({
										name='them-robot-projectile-combat',
										force=port.force,
										position=port.position,
										speed=0.6,
										source=port,
										target=x.position
										})	
								end
							end
						else
							defend_priority = true
						end
					end
				end
			end
		end
	end
	return defend_priority
end

local local_harvest_condition = function(surface,port,bots)
	if #surface.harvest_projectiles > bots*0.5 then return false end
	if surface.flags.rebuild_priority == true and bots < 2 then return false end
	if bots == 0 then return false end
	return #surface.chests > 0 
end

local local_do_harvest = function(surface,port,bots)
	local targets =  port.surface.find_entities_filtered{type={"resource"}, position=port.position, radius = surface.raid_projectile_range}
	if #targets > 0 then
		local allow_harvest = true
		local x = targets[math.random(1, #targets)]
		local removed = port.get_inventory(defines.inventory.roboport_robot).remove({name ="them-robot",count=math.ceil(bots*0.1)})					
		if removed > 0 then	
			for k=1, removed do
				port.surface.create_entity({
					name='them-robot-projectile-harvest',
					force=port.force,
					position=port.position,
					speed=0.6,
					source=port,
					target={x=x.position.x+math.random(1,4),y=x.position.y+math.random(1,4)}
					})		
			end
		end
	end	
end

local local_attack_condition = function(surface,port,bots)
	if surface.flags.rebuild_priority == true then return false end
	if surface.flags.defend_priority == true then return false end
	if #surface.attack_projectiles > 0 then return false end
	return bots >= 5
end


local local_do_attack = function(surface,port,bots)	
	local targets = surface.surface.find_entities_filtered{force="player", position=port.position, radius = surface.attack_projectile_range, limit=10}
	if #targets > 0 then
		local x = targets[math.random(1, #targets)]
		if x.name ~= "entity-ghost" and table_contains(exclude_all_targets,x.type) == false then 	
			local removed = port.get_inventory(defines.inventory.roboport_robot).remove({name = "them-robot",count=math.ceil(bots*0.25)})					
			for k=1,removed do
				port.surface.create_entity({
					name='them-robot-projectile-combat',
					force=port.force,
					position=port.position,
					speed=0.6,
					source=port,
					target={x=x.position.x+math.random(1,3),y=x.position.y+math.random(1,3)}
					})	
			end
		end
	end	
end


local local_raid_condition = function(surface,port,bots)
	if #surface.raid_projectiles > bots*0.5 then return false end
	if surface.flags.rebuild_priority == true and bots < 2 then return false end
	if bots > 5 then return false end
	return #surface.chests > 0 
end

local local_do_raid = function(surface,port,bots)
	local targets = surface.surface.find_entities_filtered{type={"container","logistic-container"}, force="player", position=port.position, radius = surface.raid_projectile_range}
	if #targets > 0 then
		local x = targets[math.random(1, #targets)]
		if x.name ~= "entity-ghost" then 			
			local from = x.get_inventory(defines.inventory.chest)
			if from ~= nil and from.is_empty() == false then
				local removed = port.get_inventory(defines.inventory.roboport_robot).remove({name = "them-robot",count=math.ceil(bots*0.25)})					
				for k=1,removed do
					port.surface.create_entity({
						name='them-robot-projectile-raid',
						force=port.force,
						position=port.position,
						speed=0.6,
						source=port,
						target=x.position
						})	
				end
			end
		end
	end	
end

local local_bot_condition = function(surface,port,bots)
	return surface.energy > surface.energy_required_per_item and bots < surface.bots_per_port
end

local local_do_bot = function(surface,port,bots)
	bots = bots + #surface.attack_projectiles
	bots = bots + #surface.raid_projectiles
	bots = bots + #surface.harvest_projectiles
	if bots < surface.bots_per_port then
		local_insert_bot(surface,port)
	end
end


local local_steal_condition = function(surface,port,bots)
	if surface.flags.rebuild_required > 0 then return false end
	if surface.flags.defend_priority == true then return false end
	if surface.current_base_build ~= nil then return false end
	if surface.steal_requested == true then return false end
	if #surface.bases < 3 then return false end
	if #surface.veins > surface.max_veins then return false end
	if surface.spawn_base_cooldown > 0 then return false end
	return true
end

local local_do_steal = function(surface,port,bots)
	surface.steal_requested = true
end



local local_expand_condition = function(surface,port,bots)
	if surface.flags.rebuild_required > 0 then return false end
	if surface.flags.defend_priority == true then return false end
	if surface.current_base_build ~= nil then return false end
	if surface.steal_requested == true then return false end
	if surface.spawn_base_cooldown > 0 then return false end
	--if surface.energy < (surface.energy_required_per_item * #surface.flags.next_base) then return false end	
	return true
end

local local_do_expand = function(surface,port,bots)
	local base = surface.bases[math.random(1,#surface.bases)]

	local d = math.random(4)
	local position = nil
	local build_position = nil
	if d == 1 then
		position = {x=base.position.x,y=base.position.y+11}
		build_position = {x=base.position.x,y=base.position.y+11}
		if base.connections["bottom"].marked == true then return end
	elseif d == 2 then
		position = {x=base.position.x,y=base.position.y-11.5}
		build_position = {x=base.position.x,y=base.position.y-11}
		if base.connections["top"].marked == true then return end
	elseif d == 3 then
		position = {x=base.position.x-11.5,y=base.position.y}
		build_position = {x=base.position.x-11,y=base.position.y}
		if base.connections["left"].marked == true then return end
	else
		position = {x=base.position.x+11.5,y=base.position.y}
		build_position = {x=base.position.x+11,y=base.position.y}
		if base.connections["right"].marked == true then return end
	end
	if position ~= nil and base_builder.can_build_base(surface,position.x,position.y,surface.flags.next_base) == true then
		for k=1, #surface.bases do
			if surface.bases[k].position.x == build_position.x and surface.bases[k].position.y == build_position.y then return end
		end
		local b = base_builder.build_base(surface,build_position.x,build_position.y,surface.flags.next_base,true)		
		table.insert(surface.bases,	b) 
		--connect bases
		if d == 1 then
			base.connections["bottom"].marked = true
			b.connections["top"].marked = true
		elseif d == 2 then
			base.connections["top"].marked = true
			b.connections["bottom"].marked = true
		elseif d == 3 then
			base.connections["left"].marked = true
			b.connections["right"].marked = true
		else
			base.connections["right"].marked = true
			b.connections["left"].marked = true
		end

	end
	
end

local local_end_game_condition = function(surface,port,bots)
	return (surface.energy + surface.end_game_saving) > end_game_energy
end

local local_do_end_game = function(surface, port, bots)
	port.surface.create_entity({
		name='them-matter-artillery-projectile',
		force=port.force,
		position=port.position,
		speed=0.6,
		source=port,
		target=port
		})	
		local_clear_surface(surface)
end

local local_add_chance= function (chance_table,count,func)
	for k = 1, count do table.insert(chance_table,func) end
end

local local_nth_tick_surface = function(surface,ticks)	
	surface.flags = {}
	surface.spawn_base_cooldown = math.max(0,surface.spawn_base_cooldown - ticks)
	surface.flags.rebuild_required = local_rebuid_count(surface)
	surface.flags.rebuild_priority = false
	surface.flags.defend_priority = local_update_defense(surface)
	surface.flags.next_base = base_builder.bases[math.random(1,#base_builder.bases)]
	if surface.current_base_build ~= nil then 
		check_current_base_build(surface)
	end
	update_raid_projectiles(surface,ticks)
	update_attack_projectiles(surface,ticks)
	update_harvest_projectiles(surface,ticks)
	if check_base_exists(surface) == false then return end
	if (surface.energy*1.02) > minimal_energy then
		surface.end_game_saving = surface.end_game_saving + (surface.energy*0.02)
		surface.energy = surface.energy - (surface.energy*0.02)
	end
	--surface.energy = 1000
	surface.flags.rebuild_priority = local_update_converters(surface)

	local chance_table = {}
	local port = surface.ports[math.random(1,#surface.ports)]
	if is_valid(port) ~= true then return end
	local bots = port.get_inventory(defines.inventory.roboport_robot).get_item_count("them-robot")


	if local_end_game_condition(surface,port,bots) then local_add_chance(chance_table,surface.end_game_chance, local_do_end_game) end
	if local_harvest_condition(surface,port,bots) then local_add_chance(chance_table,surface.harvest_chance, local_do_harvest) end
	if local_attack_condition(surface,port,bots) then local_add_chance(chance_table,surface.attack_chance, local_do_attack) end
	if local_raid_condition(surface,port,bots) then local_add_chance(chance_table,surface.raid_chance, local_do_raid) end
	if local_bot_condition(surface,port,bots) then local_add_chance(chance_table,surface.bot_chance, local_do_bot) end
	if local_steal_condition(surface,port,bots) then local_add_chance(chance_table,surface.steal_chance, local_do_steal) end
	if local_expand_condition(surface,port,bots) then local_add_chance(chance_table,surface.expand_chance, local_do_expand) end
	if #chance_table > 0 then
		local func = chance_table[math.random(1,#chance_table)]
		func(surface,port,bots)
	end
end

local local_nth_tick = function()
	local tindex = global.modmashsplinterthem.surface_update_nth_index
	if not tindex then 
		global.modmashsplinterthem.surface_update_nth_index = 1
		tindex = 1
	end
	local tnumiter = 0
	local tupdates = math.min(#surface_names,surfaces_per_tick)
	for k = tindex, #surface_names do 
		local s = surfaces[surface_names[k]]
		if s.ticks == nil then 
			s.ticks = 120 
			s.last_tick = game.ticks_played
		else
			s.ticks = game.ticks_played - s.last_tick 
			s.last_tick = game.ticks_played
		end
		local_nth_tick_surface(s,s.ticks)
		if k >= #surface_names then k = 1 end
		tnumiter = tnumiter + 1
		if tnumiter >= tupdates then 
			global.modmashsplinterthem.surface_update_nth_index = k
			k = #surface_names + 1 -- break
		end
	end
end

--required to register a surface is ready for the new bad guys
local local_on_rocket_launched = function(event)
	local rocket = event.rocket
	local rocket_silo = event.rocket_silo
	local player_index = event.player_index
	if table_contains(surfaces,rocket_silo.surface.name) == true then return end
	local_register_surface(rocket_silo.surface)
	end

local local_on_post_entity_died = function(event)
	if is_valid(event.ghost) then
		if surfaces[event.ghost.surface.name] ~= nil then 
			local surface = surfaces[event.ghost.surface.name]
			if table_contains(rebuild_names,event.ghost.ghost_name) then
				table.insert(surface.ghosts,event.ghost)
			end
			if #surface.ports <= 0 then
				for k=#surface.ghosts, 1, -1 do
					if is_valid(surface.ghosts[k]) then surface.ghosts[k].destroy() end
				end
				surface.ghosts = {}
			else
				for k=#surface.ghosts, 1, -1 do
					if is_valid(surface.ghosts[k]) ~= true then
						table.remove(surface.ghosts,k)
					end
				end
			end
		end
	end
end



local local_removed = function(entity, destruct)

	if destruct == nil then destruct = false end
	if surfaces[entity.surface.name] == nil then local_register_surface(entity.surface) end
	local surface =  surfaces[entity.surface.name]
	if entity.name == "them-pinch-mine" then
		for k=0, #global.modmashsplinterthem.mines do local landmine = global.modmashsplinterthem.mines[k]
			if  landmine == entity then
				table.remove(global.modmashsplinterthem.mines, index)		
				return
			end
		end
	elseif entity.name == "them-roboport" then
		for index, roboport in pairs(surface.ports) do
			if  roboport == entity then
				table.remove(surface.ports, index)
				if #surface.ports > 0 then
					if destruct ~= true then						
						table.insert(surface.rebuild["them-roboport"],{position = entity.position})
						base_builder.add_port(surface,entity.position.x,entity.position.y,true)	
					end
				else
					local_clear_surface(surface)
				end				
			end
		end
	elseif entity.name == "them-chest-energy-converter" then
		for index, chest in pairs(surface.converters) do
			if  chest == entity then
				table.remove(surface.converters, index)
				if #surface.converters > 0 then
					if destruct ~= true then						
						table.insert(surface.rebuild["them-chest-energy-converter"],{position = entity.position})
						base_builder.add_port(surface,entity.position.x,entity.position.y,true)	
					end
				else
					local_clear_surface(surface)
				end		
			end
		end
	elseif entity.name == "them-robot-raid" then
		for k=#surface.raid_projectiles,1,-1 do
			if surface.raid_projectiles[k].entity==entity then
				table.remove(surface.raid_projectiles,k)
			end
		end
	elseif entity.name == "them-robot-harvest" then
		for k=#surface.harvest_projectiles,1,-1 do
			if surface.harvest_projectiles[k].entity==entity then
				table.remove(surface.harvest_projectiles,k)
			end
		end
	elseif entity.name == "them-robot-combat" then
		for k=#surface.attack_projectiles,1,-1 do
			if surface.attack_projectiles[k].entity==entity then
				table.remove(surface.attack_projectiles,k)
			end
		end
	elseif entity.name == "them-chest" then
		for index, chest in pairs(surface.chests) do
			if  chest == entity then
				table.remove(surface.chests, index)
				if destruct ~= true then
					table.insert(surface.rebuild["them-chest"],{position = entity.position})
					base_builder.add_chest(surface,entity.position.x,entity.position.y,true)							
				end
			end
		end
	elseif entity.name == "them-solar-panel" and destruct ~= true then		
		table.insert(surface.rebuild["them-solar-panel"],{position = entity.position})
		base_builder.add_solar(surface,entity.position.x,entity.position.y,true)	
	elseif entity.name == "them-transport-belt" and destruct ~= true then
		table.insert(surface.rebuild["them-transport-belt"],{position = entity.position, direction = entity.direction})
		base_builder.add_belt(surface,entity.position.x,entity.position.y,entity.direction, true)	
	elseif entity.name == "them-underground-belt-structure" and destruct ~= true then
		table.insert(surface.rebuild["them-underground-belt-structure"],{position = entity.position, direction = entity.direction})
		base_builder.add_underground(surface,entity.position.x,entity.position.y,entity.direction, true)	
	elseif entity.name == "them-mini-loader-structure" and destruct ~= true then
		table.insert(surface.rebuild["them-mini-loader-structure"],{position = entity.position, direction = entity.direction, loader_type = entity.loader_type})
		base_builder.add_loader(surface,entity.position.x,entity.position.y,entity.direction, entity.loader_type, true)	
	elseif entity.name == "them-small-electric-pole" and destruct ~= true then
		table.insert(surface.rebuild["them-small-electric-pole"],{position = entity.position})
		base_builder.add_pole(surface,entity.position.x,entity.position.y,true)	
	end 
	end

	
local local_on_script_trigger_effect = function(event)

	if event.effect_id == "pinch-explosion" then
		local targets = game.surfaces[event.surface_index].find_entities_filtered{position=event.source_position, radius=9}
		for k=1, #targets do t = targets[k]
			if starts_with(t.name,"them-robot") == true then
				t.die()
			else	
				energy = 0
			end
		end
	end
	if event.effect_id == "matter-explosion" and resource_gain_event == 0 then
		if event.source_entity ~= nil then
			if event.source_entity.name == "them-roboport" then
				for i = 1, #game.players do local p = game.players[i]
					p.unlock_achievement("them_end_game")
				end
			else
				for i = 1, #game.players do local p = game.players[i]
					p.unlock_achievement("them_oppenheimer")
				end
			end
		end

		resource_gain_event = 1
		local targets = game.surfaces[event.surface_index].find_entities_filtered{position=event.source_position, radius=128, type={"resource"}}
		
		for k=1, #targets do t = targets[k]
		
			t.amount = math.min(t.amount*2,4294967295)
		end
	end	
end

local local_on_trigger_created_entity = function(event)		
	local entity = event.entity		
	if ends_with(entity.surface.name,"underground") == true then return end
	if surfaces[entity.surface.name] == nil then local_register_surface(entity.surface) end
	local surface = surfaces[entity.surface.name]
	if entity.name == "them-robot" then		
		entity.force = "enemy"
		if #surface.ports == 0 then
			entity.die()
		else
			if #surface.return_health_stack > 0 then
				entity.health = surface.return_health_stack[1]
				table.remove(surface.return_health_stack,1)
			end
		end
	elseif entity.name == "them-robot-harvest" then		
		entity.force = "enemy"
		if #surface.ports == 0 then
			entity.die()
		else
			--harvest for 10 seconds
			table.insert(surface.harvest_projectiles,
				{
					entity = entity,
					time_to_live = 60*10,
					content = {}
				})
			if #surface.harvest_health_stack > 0 then
				entity.health = surface.harvest_health_stack[1]
				table.remove(surface.harvest_health_stack,1)
			end
		end
	elseif entity.name == "them-robot-raid" then		
		entity.force = "enemy"
		if #surface.ports == 0 then
			entity.die()
		else
			--raid for 8 seconds
			table.insert(surface.raid_projectiles,
				{
					entity = entity,
					time_to_live = 60*8,
					content = {}
				})
			if #surface.raid_health_stack > 0 then
				entity.health = surface.raid_health_stack[1]
				table.remove(surface.raid_health_stack,1)
			end
		end
	elseif entity.name == "them-robot-combat" then
		entity.force = "enemy"		
		if #surface.ports == 0 then
			entity.die()
		else
			--attack for 1 minute
			table.insert(surface.attack_projectiles,
			{
				entity = entity,
				target_time_to_live = 0,
				time_to_live = 60*60
			})					
		end
		if #surface.attack_health_stack > 0 then
			entity.health = surface.attack_health_stack[1]
			table.remove(surface.attack_health_stack,1)
		end		
	end end

local local_added = function(entity,event)	
	if ends_with(entity.surface.name,"underground") == true then return end --dont care about undergrounds	
	if surfaces[entity.surface.name] == nil then local_register_surface(entity.surface) end
	local surface = surfaces[entity.surface.name]
	if entity.name == "them-pinch-mine" then
		table.insert(global.modmashsplinterthem.mines,entity)
	elseif entity.name == "them-roboport" then
		table.insert(surface.ports,entity)
		entity.operable = false
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)
	elseif entity.name == "them-robot-combat" then		
		local_on_trigger_created_entity({entity = entity})		
	elseif entity.name == "them-robot-harvest" then		
		local_on_trigger_created_entity({entity = entity})	
	elseif entity.name == "them-robot-raid" then		
		local_on_trigger_created_entity({entity = entity})	
	elseif entity.name == "them-solar-panel" then				
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)
	elseif entity.name == "them-pole" then				
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)		
	elseif entity.name == "them-robot" then		
		local_on_trigger_created_entity({entity = entity})
	elseif entity.name == "them-chest" then
		table.insert(surface.chests,entity)
		entity.operable = false
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)	elseif entity.name == "them-chest-energy-converter" then
		table.insert(surface.converters,entity)
		entity.operable = false
		entity.force = "enemy"	
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)
	elseif entity.name == "them-mini-loader-structure" then
		entity.operable = false
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)
	elseif entity.name == "them-underground-belt-structure" then
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)
	elseif entity.name == "them-transport-belt" then
		entity.force = "enemy"
		base_builder.add_concrete(surface,entity.name, entity.position.x, entity.position.y, 0, 0)
	end

	if event ~= nil then
		if entity.force.name == "player" and surface.surface.get_tile(entity.position.x, entity.position.y).name == "them-concrete" then
			fail_place_entity(entity,event,{"modmashsplinter.placement-disallowed"})
		else
			if table_contains(rebuild_names, entity.name) then
				for k=#surface.ghosts, 1, -1 do
					if is_valid(surface.ghosts[k]) ~= true then 
						table.remove(surface.ghosts,k)
					end
				end
			end
		end
	end
	end


--event setup section
	script.on_init(local_init)
	script.on_load(local_load)
	script.on_nth_tick(120, local_nth_tick)
	script.on_event(defines.events.on_script_trigger_effect, local_on_script_trigger_effect)
	script.on_event(defines.events.on_tick, local_tick)
	script.on_event(defines.events.on_entity_died,
		function(event) 
			if is_valid(event.entity) then local_removed(event.entity,false) end
		end)
	script.on_event(defines.events.on_robot_mined_entity,
		function(event) 
			if is_valid(event.entity) then local_removed(event.entity,false) end 
		end)
	script.on_event(defines.events.on_player_mined_entity,
		function(event) 
			if is_valid(event.entity) then local_removed(event.entity,true) end 
		end)
	script.on_event(defines.events.on_post_entity_died,local_on_post_entity_died)
	script.on_event(defines.events.script_raised_revive,
		function(event) 
			if is_valid(event.entity) then local_added(event.entity) end 
		end)
	script.on_event(defines.events.on_robot_built_entity,
		function(event) 
			if is_valid(event.created_entity) then local_added(event.created_entity,event) end 
		end,local_land_mine_filter)
	script.on_event(defines.events.on_built_entity,
		function(event) 
			if is_valid(event.created_entity) then local_added(event.created_entity,event) end 
		end)
	script.on_event(defines.events.script_raised_built,
		function(event) 
			if is_valid(event.entity) then local_added(event.entity) 
			elseif is_valid(event.created_entity) then local_added(event.created_entity,event) end 
		end)
	script.on_event(defines.events.on_trigger_created_entity, local_on_trigger_created_entity)
	script.on_event(defines.events.on_rocket_launched, local_on_rocket_launched)
--end event setup section