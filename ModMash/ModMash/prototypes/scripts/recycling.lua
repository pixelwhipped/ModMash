--[[dsync checking 
ok only locals are reference to globals or a constant
]]

--[[code reviewed 13.10.19]]
log("recycling.lua")
--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end
local is_valid  = modmash.util.is_valid

--[[defines]]
local recycling_machine = modmash.defines.names.recycling_machine
local low_priority = modmash.events.low_priority
local medium_priority = modmash.events.medium_priority
local high_priority = modmash.events.high_priority

local get_entities_around  = modmash.util.get_entities_around
local aggrigate_content  = modmash.util.aggrigate_content
local set_new_signal  = modmash.util.signal.set_new_signal
local try_set_recipe  = modmash.util.try_set_recipe
local starts_with  = modmash.util.starts_with

local recycling_machines_per_tick = 10

local local_get_recyle_recipe = function(name)
	return game.players[1].force.recipes["craft-"..name]
	end

local local_recycling_machine_process = function(entity)
	local loaders = get_entities_around(entity,1)
	local storage = {}
	local entities = {}
	local filters = {}
	local msg = ""
	local result = ""
	local max = 0
	local current = entity.get_recipe()
	if loaders ~= nil then
		for i, ent in pairs(loaders) do			
			if ent.type == "inserter" then			
				if ent.drop_target == entity then
					if current ~= nil and ent.held_stack.valid_for_read then				   
						return current
					end
					if ent.filter_slot_count > 0 then
						for fi = 1, ent.filter_slot_count do	
							local f = ent.get_filter(fi)
							if f ~= nil then 
								table.insert(filters,f) 								
							end
						end
					end	
					table.insert(storage,ent.pickup_target)					
				end
			elseif ent.type == "loader" and ent.loader_type == "input" then
				local filtered = false
				if ent.filter_slot_count > 0 then
					for fi = 1, ent.filter_slot_count do	
						local f = ent.get_filter(fi)
						if f ~= nil then 
							local rc = local_get_recyle_recipe(f)					
							if rc ~= nil then
								if rc == current then return nil end
								filtered = true
								result = f
								max = 1
							end							
						end
					end
				end
				if filtered == false then
					local contents = aggrigate_content(ent.get_transport_line(1),ent.get_transport_line(2))	
					for name, count in pairs(contents) do
						local rc = local_get_recyle_recipe(name)					
						if rc ~= nil then
							if rc == current then return nil end
							if count > max then 
								result = name
								max = count
							end	
						end
					end
				end
			elseif (ent.type == "loader-1x1" or ent.type == "loader-1x2") and ent.loader_type == "input" then
				local filtered = false
				if ent.filter_slot_count > 0 then
					for fi = 1, ent.filter_slot_count do	
						local f = ent.get_filter(fi)
						if f ~= nil then 
							local rc = local_get_recyle_recipe(f)					
							if rc ~= nil then
								if rc == current then return nil end
								filtered = true
								result = f
								max = 1
							end							
						end
					end
				end
				if filtered == false then
					local contents = aggrigate_content(ent.get_transport_line(1),ent.get_transport_line(2))	
					for name, count in pairs(contents) do
						local rc = local_get_recyle_recipe(name)					
						if rc ~= nil then
							if rc == current then return nil end
							if count > max then 
								result = name
								max = count
							end	
						end
					end
				end
			end

		end		
		for index, sto in pairs(storage) do			
			if (sto.prototype.type == "transport-belt" or entity.prototype.type == "underground-belt")  then				
				local contents = aggrigate_content(sto.get_transport_line(1),sto.get_transport_line(2))																			
				for name, count in pairs(contents) do	--for _, x in pairs(contents) do			
					local rc = local_get_recyle_recipe(name)					
					if rc ~= nil then
						if rc == current then return nil end
						if count > max then 
							result = name
							max = count
						end	
					end
				end
			elseif sto.prototype.type == "container" or sto.prototype.type == "logistic-container" then			
				local inventory = sto.get_output_inventory()
				if not inventory then
					--msg = msg .. "c wagon "
					 
				end
				if inventory then
					local found = false
					--msg = msg .. " has inventory " .. #inventory
					local contents = inventory.get_contents()					
					for name, count in pairs(contents) do								
						if #filters == 0 then found = true end
						for fi = 1, #filters do							
							if filters[fi] == name then 
								found = true 								
							end
						end
						local rc = local_get_recyle_recipe(name)
						if rc ~= nil then							
							if found then 
								if rc == current then return nil end
								if count > max then 								
									result = name
									max = count
								end	
							end
						end
					end
				else							
					local contents = sto.get_contents()
					for name, count in pairs(contents) do
						local found = false
						if #filters == 0 then found = true end
						for fi = 1, #filters do							
							if filters[fi] == name then 
								found = true 								
							end
						end						
						local rc = local_get_recyle_recipe(name)
						if rc ~= nil then							
							if found then
								if rc == current then return nil end
								if count > max then 
									result = name
									max = count
								end	
							end						
						end
					end					
				end
			end
		end			
		if result ~= nil then return local_get_recyle_recipe(result) end
	end			
	return nil
	end

local local_set_sticker = function(recycling_machine, automated,keep)
	if recycling_machine.signal ~= nil then
		recycling_machine.signal.destroy() 
	end
	if keep then
		if automated then
			recycling_machine.signal = set_new_signal(recycling_machine.entity,"recycling-machine-indicator",1)
		else
			recycling_machine.signal = set_new_signal(recycling_machine.entity,"recycling-machine-indicator",2)
		end
	end
	end

local local_refresh_sticker = function(recycling_machine,keep)
	local_set_sticker(recycling_machine,recycling_machine.automated,keep)
	end

local local_rebuild_lables = function()
	local recycling_machines = global.modmash.recycling_machines
	for k=1, #recycling_machines do local recycling_machine = recycling_machines[k];			
		if recycling_machine ~= nil and recycling_machine.entity ~= nil and recycling_machine.entity.valid then	
			if not recycling_machine.entity.to_be_deconstructed(recycling_machine.entity.force) then
				local_refresh_sticker(recycling_machine,true)
			end
		end
	end
	end

local local_init = function()	
	if global.modmash.recycling_machines == nil then global.modmash.recycling_machines = {} end	
	end

local local_start = function()	
	local_rebuild_lables()
	end

local local_recycling_tick = function()
	--if true then return end
	local recycling_machines = global.modmash.recycling_machines
	if not global.modmash.recycling_machines_index then global.modmash.recycling_machines_index = 1 end
	local index = global.modmash.recycling_machines_index
	
	local numiter = 0
	local updates = math.min(#recycling_machines,recycling_machines_per_tick)

	for index=1, #recycling_machines do local recycling_machine = recycling_machines[index]		
		if recycling_machine.entity.valid then
			if not recycling_machine.entity.to_be_deconstructed(recycling_machine.entity.force) then
				if recycling_machine.entity.is_crafting() == false then 
					if recycling_machine.automated == true then
						local recipe = local_recycling_machine_process(recycling_machine.entity)
						if recipe ~= nil then								
							try_set_recipe(recycling_machine.entity,recipe)
						end
					end
				end
			end
		end
		if index >= #recycling_machines then index = 1 end
		numiter = numiter + 1
		if numiter >= updates then 
			global.modmash.recycling_machines_index	= index
			return
		end	
	end
end

local local_recycling_added = function(entity)
	detail = {
		entity = entity,
		automated = true,
	}
	entity.operable = false
	table.insert(global.modmash.recycling_machines, detail)
	local_refresh_sticker(detail,true)
	end

local local_recycling_removed = function(entity)	
	for index, recycling_machine in ipairs(global.modmash.recycling_machines) do
		if recycling_machine.entity.valid and recycling_machine.entity == entity then
			table.remove(global.modmash.recycling_machines, index)
			local_refresh_sticker(recycling_machine,false)
			return
		end
	end
	end

local local_on_entity_cloned = function(event)
	if is_valid(event.source) then 
		if event.source.name == recycling_machine then return end	
		for index, recycling_machine in pairs(global.modmash.recycling_machines) do
			if  recycling_machine.entity == event.source then
				recycling_machine.entity = event.destination
				return
			end
		end
	end
end

local local_recycling_adjust = function(entity)
	local recycling_machines = global.modmash.recycling_machines
	for index=1, #recycling_machines do local recycling_machine = recycling_machines[index]
		if entity == recycling_machine.entity then
			if recycling_machine.automated == false then
				recycling_machine.automated = true
				entity.operable = false
			else
				recycling_machine.automated = false
				entity.operable = true
			end
			local_refresh_sticker(recycling_machine,true)
			return
		end
	end
	end

local local_on_selected = function(player,entity)
	if entity ~= nil then
		if (entity.name == "recycling-machine" or (global.modmash.allow_pickup_rotations and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")))) then
			if settings.startup["modmash-setting-show-adjustable"].value == true then
				entity.surface.create_entity{name="flying-text", position = entity.position, text="Press CTRL + A to adjust", color={r=1,g=1,b=1}}
			end
		end

	end
	end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		--fix recipes
		for name, recipe in pairs(game.players[1].force.recipes) do 
			if starts_with(recipe.name,"craft-") then
				recipe.enabled = true
			end
		end
	end
	end

modmash.register_script({
	names = {recycling_machine},
	on_init = local_init,
	on_start = local_start,
	on_tick = {
		tick = local_recycling_tick,
		priority = low_priority,
		},
	on_added_by_name = local_recycling_added,
	on_removed_by_name = local_recycling_removed,
	on_selected_by_name = local_on_selected,
	on_adjust_by_name = local_recycling_adjust,
	on_configuration_changed = local_on_configuration_changed,
	on_entity_cloned = local_on_entity_cloned
})
