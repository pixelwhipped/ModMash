local is_valid = modmashsplinterlogistics.util.is_valid
local print = modmashsplinterlogistics.util.print
local table_contains = modmashsplinterlogistics.util.table.contains
local get_entity_size = modmashsplinterlogistics.util.entity.get_entity_size 
local get_entities_to_north  = modmashsplinterlogistics.util.entity.get_entities_to_north
local get_entities_to_south  = modmashsplinterlogistics.util.entity.get_entities_to_south
local get_entities_to_east  = modmashsplinterlogistics.util.entity.get_entities_to_east
local get_entities_to_west  = modmashsplinterlogistics.util.entity.get_entities_to_west
local starts_with  = modmashsplinterlogistics.util.starts_with


loaders = nil
local loader_size = nil

local beltTypes = {
  "loader","loader-1x1","loader-1x2","splitter","underground-belt","transport-belt"
}

local local_adjust_loader = function(entity)	
	--if starts_with(entity.name,"them-") then return end
	if loader_size == nil then loader_size = get_entity_size(entity) end
	if settings.startup["setting-loader-snapping"].value ~= "Enabled" then return end
	if entity.direction == defines.direction.north or entity.direction == defines.direction.south then
		local north = get_entities_to_north(entity,beltTypes,loader_size)
		if #north > 0 then
			if north[1].direction == 4 then entity.loader_type = "input" return end
			if north[1].direction == 0 then entity.loader_type = "output" return end
			return
		end
		local south = get_entities_to_south(entity,beltTypes,loader_size)
		if  #south > 0 then
			if south[1].direction == 0 then entity.loader_type = "input" return end
			if south[1].direction == 4 then entity.loader_type = "output" return end
		end
	elseif entity.direction  == defines.direction.east or entity.direction  == defines.direction.west then
		local east = get_entities_to_east(entity,beltTypes,loader_size)			
		if #east > 0 then
			if east[1].direction == 6 then entity.loader_type = "input" return end	
			if east[1].direction == 2 then entity.loader_type = "output" return end	
		end
		local west = get_entities_to_west(entity,beltTypes,loader_size)
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
	
	if entity.direction  == defines.direction.north or entity.direction == defines.direction.south then
		area = {{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x+w, entity.position.y+(h+0.5)}}
	elseif entity.direction  == defines.direction.east or entity.direction  == defines.direction.west then
		area = {{entity.position.x-(w+0.5), entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+h}}
	end
	local loaders = surface.find_entities_filtered{area=area, type = {'loader-1x1','loader','loader-1x2'}}
	for k=1, #loaders do local loader = loaders[k]
		local_adjust_loader (loader)
	end
	end

local local_add_or_replace = function(loader)
	for k =1, #loaders do l = loaders[k]
		if l[1] == loader[1] then
			l[2] = loader[2]
			l[3] = loader[3]
			return
		end
	end
	table.insert(loaders,loader)
end

local local_find_train_loaders = function(entity)
	--if not (entity.type=="cargo-wagon" or entity.type=="locomotive") then return end
	if (entity.train.state==defines.train_state.wait_station or entity.train.state==defines.train_state.manual_control) and entity.train.speed==0 then
		if entity.orientation==0 or entity.orientation==0.5 then  --split into each
			local entities = entity.surface.find_entities_filtered{type={'loader-1x1','loader','loader-1x2'},area={{entity.position.x-1.8,entity.position.y-2.5},{entity.position.x-0.8,entity.position.y+2.5}}}
			for k=1,#entities do local loader = entities[k]
				local_add_or_replace({loader,entity,6})				
			end
			entities = entity.surface.find_entities_filtered{type={'loader-1x1','loader','loader-1x2'},area={{entity.position.x+0.8,entity.position.y-2.5},{entity.position.x+1.8,entity.position.y+2.5}}}
			for k=1,#entities do local loader = entities[k]
				local_add_or_replace({loader,entity,2})
			end
		elseif entity.orientation==0.25 or entity.orientation==0.75 then
			--print("Z")
			local entities = entity.surface.find_entities_filtered{type={'loader-1x1','loader','loader-1x2'},area={{entity.position.x-2.5,entity.position.y-1.8},{entity.position.x+2.5,entity.position.y-0.8}}}
			for k=1,#entities do local loader = entities[k]		
				local_add_or_replace({loader,entity,0})
			end
			entities = entity.surface.find_entities_filtered{type={'loader-1x1','loader','loader-1x2'},area={{entity.position.x-2.5,entity.position.y+0.8},{entity.position.x+2.5,entity.position.y+1.8}}}
			for k=1,#entities do local loader = entities[k]
				local_add_or_replace({loader,entity,4})
			end
		end
	end
	end

local local_loader_added = function(entity,event)	
		local_adjust_loader(entity)
		local w=entity.surface.find_entities_filtered{type="cargo-wagon",area={{entity.position.x-2,entity.position.y-2},{entity.position.x+2,entity.position.y+2}}}
		for k=1, #w do local b = w[k]
			local_find_train_loaders(b)
		end
		local w=entity.surface.find_entities_filtered{type="locomotive",area={{entity.position.x-2,entity.position.y-2},{entity.position.x+2,entity.position.y+2}}}
		for k=1, #w do local b = w[k]
			local_find_train_loaders(b)
		end
	end

local local_on_train_changed_state = function(event)
	for k = 1, #event.train.carriages do
		local_find_train_loaders(event.train.carriages[k])
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

local local_loader_do_unload = function(entity,wagon)	
	if wagon == nil or entity == nil or wagon.is_empty() then return end
	local line = entity.get_transport_line(1)
	local line2 = entity.get_transport_line(2)
	local c1 = 0
	if line.can_insert_at_back() == true then c1 = c1 + 1 end
	if line2.can_insert_at_back() == true then c1 = c1 + 1 end
	if c1 == 0 then return end
	local f = local_loader_filter(entity)
	local content = wagon.get_contents()
	if f then
		local done=false
		for name,count in pairs(content) do
			if done then break end
			for n,filter in pairs(f) do
				if name==filter then
					wagon.remove({name=name,count=c1})
					line.insert_at_back({name=name,count=c1})
					line2.insert_at_back({name=name,count=c2})
					done=true
					break
				end
			end
		end
	else
		local name,count = next(content)
		wagon.remove({name=name,count=c1})
		line.insert_at_back({name=name,count=c1})
		line2.insert_at_back({name=name,count=c2})
	end
	end

local local_loader_tick = function()
	local loader_active = function(entity,direction)
		if entity.direction==direction and entity.loader_type=="output" then return true end
		return entity.direction==(direction+4)%8 and entity.loader_type=="input" 		
	end
	for k=#loaders,1,-1 do local loader = loaders[k]
		if loader == nil then
			table.remove(loaders,k)
		else
			local l1,l2,l3 = loader[1],loader[2],loader[3]
			if l1.valid==false or l2.valid==false 
				or l2.train.speed~=0 or (l2.train.state~=defines.train_state.wait_station and l2.train.state~=defines.train_state.manual_control) then
				table.remove(loaders,k)
			elseif loader_active(l1,l3) then
				if l1.loader_type=="output" and l2.type ~="locomotive" then
					local_loader_do_unload(l1,l2.get_inventory(defines.inventory.cargo_wagon),l3)
				else
					local wagon = l2.get_inventory(defines.inventory.cargo_wagon)
					if wagon ~= nil then
						local transport_line = l1.get_transport_line(1)
						if transport_line.get_item_count()>0 then
							local name,count = next(transport_line.get_contents())
							local wagon_count = wagon.insert({name=name,count=1})
							if wagon_count > 0 then transport_line.remove_item({name=name,count=wagon_count}) end
						end
						transport_line = l1.get_transport_line(2)
						if transport_line.get_item_count()>0 then
							local name,count = next(transport_line.get_contents())
							local wagon_count = wagon.insert({name=name,count=1})
							if wagon_count > 0 then transport_line.remove_item({name=name,count=wagon_count}) end
						end
					end
				end
			end
		end
	end
	end

local local_init = function()	
	if global.modmashsplinterlogistics.loader == nil then global.modmashsplinterlogistics.loader = {} end	
	if global.modmashsplinterlogistics.loader.loaders == nil then global.modmashsplinterlogistics.loader.loaders = {} end	
	loaders = global.modmashsplinterlogistics.loader.loaders
	remote.call("modmashsplinterregenerative","register_regenerative",{"regenerative-mini-loader","regenerative-splitter","regenerative-transport-belt","regenerative-underground-belt-structure"})
	end

local local_load = function()	
	--if global.modmashsplinterlogistics.loader ~= nil and global.modmashsplinterlogistics.loader.loaders ~= nil then
	loaders = global.modmashsplinterlogistics.loader.loaders
	--end
	remote.call("modmashsplinterregenerative","register_regenerative",{"regenerative-mini-loader","regenerative-splitter","regenerative-transport-belt","regenerative-underground-belt-structure"})
	end
	
local local_loader_removed = function(entity)
	for k=#loaders,1,-1 do local loader = loaders[k]
		if loader[1] == entity then
			table.remove(loaders,k)
			return
		end
	end
end
--wtf
--[[
local local_on_entity_cloned = function(event)
	if event.source.type == "loader-1x1" or event.source.type == "loader" or event.source.type == "loader-1x2" then return end	
	for index, loader in pairs(loaders) do
		if  loader.entity == event.source then
			loader.entity = event.destination
			return
		end
	end
end
]]


local local_standard_loader_filter = {{filter = "type", type = "loader-1x1"}, 
	{filter = "name", name = "mini-loader", mode = "and"}, 
	{filter = "name", name = "fast-mini-loader"}, 
	{filter = "name", name = "express-mini-loader"}, 
	{filter = "name", name = "high-speed-mini-loader"},
	{filter = "name", name = "regenerative-mini-loader"}}

local local_standard_belt_filter = {{filter = "type", type = "splitter"},
	{filter = "type", type = "underground-belt"},
	{filter = "type", type = "transport-belt"}}

local local_standard_wagon_filter = {{filter = "type", type = "cargo-wagon"},
	{filter = "type", type = "locomotive"}}

local local_standard_filter = {
	{filter = "type", type = "cargo-wagon"},
	{filter = "type", type = "locomotive"},
	{filter = "type", type = "splitter"},
	{filter = "type", type = "underground-belt"},
	{filter = "type", type = "transport-belt"},
	{filter = "type", type = "loader-1x1"}, 
	{filter = "name", name = "mini-loader", mode = "and"}, 
	{filter = "name", name = "fast-mini-loader"}, 
	{filter = "name", name = "express-mini-loader"}, 
	{filter = "name", name = "high-speed-mini-loader"},
	{filter = "name", name = "regenerative-mini-loader"}
}

script.on_init(local_init)
script.on_load(local_load)
--[[
script.on_event(defines.events.on_entity_cloned,
	function(event) 
		if is_valid(event.source) then local_on_entity_cloned(event.source, nil) end 
	end,local_standard_loader_filter)
	]]

local local_added_event = function(entity,event)
	if entity.type == "cargo-wagon" or entity.type == "locomotive" then
		local_find_train_loaders(entity)
	elseif entity.type == "splitter" or entity.type == "underground-belt" or entity.type == "transport-belt" then
		local_find_loaders(entity) 
	elseif entity.type == "loader-1x1" then
		local_loader_added(entity,event) 
	end
end
-------------------loaders
script.on_event(defines.events.script_raised_revive,
	function(event) 
		if is_valid(event.entity) then local_added_event(event.entity,event) end 
	end,local_standard_filter)
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_added_event(event.created_entity,event) end 
	end,local_standard_filter)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_added_event(event.created_entity,event) end 
	end,local_standard_filter)
script.on_event(defines.events.script_raised_built,
	function(event) 
		if is_valid(event.created_entity) then local_added_event(event.entity,event) end 
	end,local_standard_filter)

script.on_event(defines.events.on_entity_died,
	function(event) 
		if is_valid(event.entity) then local_loader_removed(event.entity) end 
	end,local_standard_loader_filter)

script.on_event(defines.events.on_robot_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_loader_removed(event.entity) end 
	end,local_standard_loader_filter)

script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_loader_removed(event.entity) end 
	end,local_standard_loader_filter)
script.on_event(defines.events.on_player_mined_entity,
	function(event) 
		if is_valid(event.entity) then local_loader_removed(event.entity) end 
	end,local_standard_loader_filter)
--[[
---------------------belts
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_find_loaders(event.created_entity) end 
	end,local_standard_belt_filter)

script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_find_loaders(event.created_entity) end 
	end,local_standard_belt_filter)

script.on_event(defines.events.script_raised_built,
function(event) 
	if is_valid(event.entity) then local_find_loaders(event.entity) end 
end,local_standard_belt_filter)

script.on_event(defines.events.script_raised_revive,
function(event) 
	if is_valid(event.entity) then local_find_loaders(event.entity) end 
end,local_standard_belt_filter)


-------------------wagons
--we are still adding and checking for later use only the ticks will be disabled
script.on_event(defines.events.on_robot_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_find_train_loaders(event.created_entity) end 
	end,local_standard_wagon_filter)
script.on_event(defines.events.on_built_entity,
	function(event) 
		if is_valid(event.created_entity) then local_find_train_loaders(event.created_entity) end 
	end,local_standard_wagon_filter)

script.on_event(defines.events.script_raised_built,
function(event) 
	if is_valid(event.entity) then local_find_train_loaders(event.entity) end 
end,local_standard_wagon_filter)

script.on_event(defines.events.script_raised_revive,
function(event) 
	if is_valid(event.entity) then local_find_train_loaders(event.entity) end 
end,local_standard_wagon_filter)
--]]
script.on_event(defines.events.on_train_changed_state,local_on_train_changed_state)

if settings.startup["setting-loader-wagon-support"].value ~= "Disabled" then	
	 script.on_event(defines.events.on_tick,local_loader_tick)
end	

