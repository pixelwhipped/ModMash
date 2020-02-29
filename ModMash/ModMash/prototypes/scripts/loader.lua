--[[Code check 29.2.20
removed old comments
added references for loader-1x1
--]]

if settings.startup["modmash-setting-loader-snapping"].value == "Disabled" then return end

if not modmash or not modmash.util then require("prototypes.scripts.util") end
if not modmash.util.defines then require ("prototypes.scripts.defines") end

local is_valid = modmash.util.is_valid
local table_contains = modmash.util.table.contains
local get_entity_size = modmash.util.get_entity_size 


local get_entities_to_north  = modmash.util.get_entities_to_north
local get_entities_to_south  = modmash.util.get_entities_to_south
local get_entities_to_east  = modmash.util.get_entities_to_east
local get_entities_to_west  = modmash.util.get_entities_to_west

loaders = nil

local beltTypes = {
  "loader","loader-1x1","splitter","underground-belt","transport-belt"
}

local local_adjust_loader = function(entity)	
	if entity.direction == defines.direction.north or entity.direction == defines.direction.south then
		local north = get_entities_to_north(entity,beltTypes)
		if #north > 0 then
			if north[1].direction == 4 then entity.loader_type = "input" return end
			if north[1].direction == 0 then entity.loader_type = "output" return end
			return
		end
		local south = get_entities_to_south(entity,beltTypes)
		if  #south > 0 then
			if south[1].direction == 0 then entity.loader_type = "input" return end
			if south[1].direction == 4 then entity.loader_type = "output" return end
		end
	elseif entity.direction  == defines.direction.east or entity.direction  == defines.direction.west then
		local east = get_entities_to_east(entity,beltTypes)			
		if #east > 0 then
			if east[1].direction == 6 then entity.loader_type = "input" return end	
			if east[1].direction == 2 then entity.loader_type = "output" return end	
		end
		local west = get_entities_to_west(entity,beltTypes)
		if #west > 0 then
			if west[1].direction == 2 then entity.loader_type = "input" return end
			if west[1].direction == 6 then entity.loader_type = "output" return end	
		end
	end
	end

local local_find_loaders  = function(entity)
	local surface = entity.surface
	local area = entity.bounding_box
	local wh = get_entity_size(entity)
	if wh == {0, 0} then wh = {1,1} end
	local w = 0.5*wh[1]
	local h = 0.5*wh[2]
	
	if entity.direction  == defines.direction.north or entity.direction  == defines.direction.south then
		area = {{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x+w, entity.position.y+(h+0.5)}}
	elseif entity.direction  == defines.direction.east or entity.direction  == defines.direction.west then
		area = {{entity.position.x-(w+0.5), entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+h}}
	end
	local loaders = surface.find_entities_filtered{area=area, type = {'loader-1x1','loader'}}
	for i, loader in pairs (loaders) do
		local_adjust_loader (loader)
	end
	end


local local_find_train_loaders = function(entity)
	if not (entity.type=="cargo-wagon" or entity.type=="locomotive") then return end
	if (entity.train.state==defines.train_state.wait_station or entity.train.state==defines.train_state.manual_control) and entity.train.speed==0 then
		if entity.orientation==0 or entity.orientation==0.5 then
			for j,loader in pairs(entity.surface.find_entities_filtered{type={'loader-1x1','loader'},area={{entity.position.x-1.5,entity.position.y-2.2},{entity.position.x-0.5,entity.position.y+2.2}}}) do
				table.insert(loaders,{loader,entity,6})				
			end
			for j,loader in pairs(entity.surface.find_entities_filtered{type={'loader-1x1','loader'},area={{entity.position.x+0.5,entity.position.y-2.2},{entity.position.x+1.5,entity.position.y+2.2}}}) do
				table.insert(loaders,{loader,entity,2})
			end
		elseif entity.orientation==0.25 or entity.orientation==0.75 then
			for j,loader in pairs(entity.surface.find_entities_filtered{type={'loader-1x1','loader'},area={{entity.position.x-2.2,entity.position.y-1.5},{entity.position.x+2.2,entity.position.y-0.5}}}) do				
				table.insert(loaders,{loader,entity,0})
			end
			for j,loader in pairs(entity.surface.find_entities_filtered{type={'loader-1x1','loader'},area={{entity.position.x-2.2,entity.position.y+0.5},{entity.position.x+2.2,entity.position.y+1.5}}}) do
				table.insert(loaders,{loader,entity,4})
			end
		end
	end
	end

local local_loader_added = function(entity)	
		if is_valid(entity) ~= true then return end		
		if entity.type == "loader-1x1" or entity.type == "loader" then 
			local_adjust_loader(entity)
			local w=entity.surface.find_entities_filtered{type="cargo-wagon",area={{entity.position.x-2,entity.position.y-2},{entity.position.x+2,entity.position.y+2}}}
			for a,b in pairs(w) do
				local_find_train_loaders(b)
			end
			local w=entity.surface.find_entities_filtered{type="locomotive",area={{entity.position.x-2,entity.position.y-2},{entity.position.x+2,entity.position.y+2}}}
			for a,b in pairs(w) do
				local_find_train_loaders(b)
			end
		elseif table_contains(beltTypes, entity.type) then
			local_find_loaders (entity)
		elseif entity.type=="cargo-wagon" or entity.type=="locomotive" then
			local_find_train_loaders(entity)
		end
	    
	end

local local_on_train_changed_state = function(event)
	for i,w in pairs(event.train.carriages) do
		local_find_train_loaders(w)
	end
	end

local local_loader_filter = function(entity)
	local filter={}
	for n=1, entity.filter_slot_count do
		local x = entity.get_filter(n)
		if x then
			table.insert(filter,n,x)
		end
	end
	if #filter==0 then filter=false end
	return filter
end

local local_loader_process_unload_line = function(entity,wagon, line)
	if wagon.is_empty()==false and entity.get_transport_line(line).can_insert_at_back() then
		local f = local_loader_filter(entity)
		if f then
			local done=false
			for name,count in pairs(wagon.get_contents()) do
				if done then break end
				for n,filter in pairs(f) do
					if name==filter then
						wagon.remove({name=name,count=1})
						ent.get_transport_line(line).insert_at_back({name=name,count=1})
						done=true
						break
					end
				end
			end
		else
			for name,count in pairs(wagon.get_contents()) do
				wagon.remove({name=name,count=1})
				entity.get_transport_line(line).insert_at_back({name=name,count=1})
				break
			end
		end
	end
	end

local local_loader_do_unload = function(entity,wagon)	
	local_loader_process_unload_line(entity,wagon,1)
	local_loader_process_unload_line(entity,wagon,2)
end

local local_loader_process_load_line = function(entity,wagon, line)
	if entity.get_transport_line(line).get_item_count()>0 then
		for name,count in pairs(entity.get_transport_line(line).get_contents()) do
			if wagon.can_insert({name=name,count=1}) then
				entity.get_transport_line(line).remove_item({name=name,count=1})
				wagon.insert({name=name,count=1})
				break
			end
		end
	end
end

local local_loader_do_load = function(entity,wagon)
	local_loader_process_load_line(entity,wagon,1)
	local_loader_process_load_line(entity,wagon,2)
end

local local_clean_loaders = function()
	for k=#loaders,1,-1 do local loader = loaders[k]
		if loader[1].valid==false or loader[2].valid==false 
			or (loader[2].train.state~=defines.train_state.wait_station and loader[2].train.state~=defines.train_state.manual_control) 
			or loader[2].train.speed~=0 then
			table.remove(loaders,k)
		end
	end
end

local local_loader_tick = function()
	local loader_active = function(entity,direction)
		if entity.loader_type=="output" and entity.direction==direction then return true end
		return entity.loader_type=="input" and entity.direction==(direction+4)%8 		
	end
	local_clean_loaders()
	for k=1, #loaders do local loader = loaders[k]
		if loader_active(loader[1],loader[3]) then
			if loader[1].loader_type=="output" then
				local_loader_do_unload(loader[1],loader[2].get_inventory(defines.inventory.cargo_wagon),loader[3])
			else
				local_loader_do_load(loader[1],loader[2].get_inventory(defines.inventory.cargo_wagon),loader[3])
			end
		end
		
	end
	end

local local_init = function()	
	if global.modmash.loader == nil then global.modmash.loader = {} end	
	if global.modmash.loader.loaders == nil then global.modmash.loader.loaders = {} end	
	loaders = global.modmash.loader.loaders
	end

local local_load = function()	
	if global.modmash.loader ~= nil and global.modmash.loader.loaders ~= nil then
		loaders = global.modmash.loader.loaders
	end
	end
	
local local_loader_removed = function(entity)
	if entity.type == "loader-1x1" or entity.type == "loader" then				
		for index, loader in pairs(loaders) do
			if  loader.entity == entity then
				table.remove(loaders, index)				
				return
			end
		end
	end
end

local local_on_entity_cloned = function(event)
	if is_valid(event.source) then 
		if entity.source.type == "loader-1x1" or event.source.type == "loader" then return end	
		for index, loader in pairs(loaders) do
			if  loader.entity == event.source then
				loader.entity = event.destination
				return
			end
		end
	end
end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.62" then	
		global.modmash.loader = {}	
		global.modmash.loader.loaders = {}	
		loaders = global.modmash.loader.loaders
		for _, surface in pairs(game.surfaces) do
			for c in surface.get_chunks() do
				local entities = surface.find_entities_filtered{area = c.area}
				for _, entity in pairs(entities) do
					local_loader_added(entity)
				end
			end
		end
	end
	end


modmash.register_script({
	on_tick = local_loader_tick,
	on_init = local_init,
	on_load = local_load,
	on_added = local_loader_added,
	on_removed = local_loader_removed,
	on_train_changed_state = local_on_train_changed_state,
	on_configuration_changed = local_on_configuration_changed,
	on_entity_cloned = local_on_entity_cloned
})