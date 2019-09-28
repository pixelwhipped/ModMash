if not util then require("prototypes.scripts.util") end

local local_get_recyle_recipe = function(name)
	for _, player in pairs (game.players) do
		for _, recipe in pairs (player.force.recipes) do
			if recipe.name == "craft-"..name then
				return recipe
			end
		end
	end
	return nil
end

local local_recycling_machine_process = function(entity)
	local loaders = util.get_entities_around(entity,1)
	local storage = {}
	local entities = {}
	local filters = {}
	local msg = ""
	local result = ""
	local max = 0
	local current = entity.get_recipe()
	if loaders ~= nil then
		for i, ent in pairs(loaders) do			
			if ent.prototype.type == "inserter" then			
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
			elseif ent.prototype.type == "loader" then

			end
		end		
		for index, sto in pairs(storage) do			
			if (sto.prototype.type == "transport-belt" or entity.prototype.type == "underground-belt")  then				
				local contents = util.aggrigate_content(sto.get_transport_line(1),sto.get_transport_line(2))																			
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
			recycling_machine.signal = util.signal.set_new_signal(recycling_machine.entity,"recycling-machine-indicator",1)
		else
			recycling_machine.signal = util.signal.set_new_signal(recycling_machine.entity,"recycling-machine-indicator",2)
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

local init = function()	
	if game.players[1] == nil then return init end
	if global.modmash.recycling_machines == nil then global.modmash.recycling_machines = {} end	
	for name, recipe in pairs(game.players[1].force.recipes) do 
		if util.starts_with(recipe.name,"craft-") then
			recipe.enabled = true
		end
	end
	local_rebuild_lables()
	return nil
end

local local_recycling_tick = function()
	if init ~= nil then init = init() end	
	if game.tick % 20 == 0 then
		local recycling_machines = global.modmash.recycling_machines
		for index=1, #recycling_machines do local recycling_machine = recycling_machines[index]		
			if recycling_machine.entity.valid then
				if not recycling_machine.entity.to_be_deconstructed(recycling_machine.entity.force) then
					if recycling_machine.automated == true then
						local recipe = local_recycling_machine_process(recycling_machine.entity)
						if recipe ~= nil then								
							util.try_set_recipe(recycling_machine.entity,recipe)
						end
					end
				end
			end
		end
	end
end

local local_recycling_added = function(ent)
	if ent.name == "recycling-machine" then
		detail = {
			entity = ent,
			automated = true,
		}
		ent.operable = false
		table.insert(global.modmash.recycling_machines, detail)
		local_refresh_sticker(detail,true)
	end
end

local local_recycling_removed = function(entity)
	if entity.name == "recycling-machine" then		
		for index, recycling_machine in ipairs(global.modmash.recycling_machines) do
			if recycling_machine.entity.valid and recycling_machine.entity == entity then
				table.remove(global.modmash.recycling_machines, index)
				local_refresh_sticker(recycling_machine,false)
				return
			end
		end
	end
end

local local_recycling_adjust = function(entity)
	if entity.name == "recycling-machine" then
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
end

if modmash.ticks ~= nil then			
	table.insert(modmash.ticks,local_recycling_tick)
	table.insert(modmash.on_added,local_recycling_added)
	table.insert(modmash.on_remove,local_recycling_removed)
	table.insert(modmash.on_adjust,local_recycling_adjust)
end