--[[dsync checking 
changed local stock_transports = 0 to global.modmash.stock_transports
]]

log("subspace-transport.lua")
--[[check and import utils]]
--if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
--if not modmash.defines then require ("prototypes.scripts.defines") end


--[[defines]]
local subspace_transport  = modmash.defines.names.subspace_transport 
local super_container_stack_size = modmash.defines.defaults.super_container_stack_size
local priority = modmash.events.medium_priority
	
--[[create local references]]
--[[util]]
local is_valid = modmash.util.is_valid
local is_valid_and_persistant = modmash.util.entity.is_valid_and_persistant
local table_index_of = modmash.util.table.index_of
local table_remove = modmash.util.table.remove

--[[unitialized globals]]
local transports = nil

local transports_per_tick = 2
local stock_transports_per_tick = 1



--[[ensure globals]]
local local_init = function() 
	log("subspace-transport.local_init")
	if global.modmash.subspace_transports == nil then global.modmash.subspace_transports = {} end
	transports = global.modmash.subspace_transports
	end
local local_load = function() 
	log("subspace-transport.local_load")
	transports = global.modmash.subspace_transports
	end

local local_subspace_transports_share = function(name,stock,entity)
	for index=1, #transports do local transport = transports[index]
		if transport ~= entity and is_valid_and_persistant(transport) and transport.energy > 0 then
			local inventory = transport.get_inventory(defines.inventory.lab_input)
			if inventory == nil then return stock end
			if inventory.get_item_count(name) < stock and inventory.can_insert({name=name,count=1}) then
				inventory.insert({name=name,count=1})
				stock = stock -1;
				global.modmash.stock_transports = global.modmash.stock_transports + 1
			end
			if stock == 0 or global.modmash.stock_transports >= stock_transports_per_tick then return stock end
		end
	end
	return stock
end

local local_subspace_transports_process = function(entity)	
	local inventory = entity.get_inventory(defines.inventory.lab_input)
	if inventory == nil then return end
	local contents = inventory.get_contents()			
	for name, count in pairs(contents) do
		
		local stock = inventory.remove({name=name,count=count})		
		local balance = count-stock		
		balance = balance + local_subspace_transports_share(name,stock,entity)
		if balance>0 then inventory.insert({name=name,count=balance}) end
	end
end

local local_subspace_transports_tick = function()	
	global.modmash.stock_transports = 0
	local index = global.modmash.transports_update_index
	if not index then index = 1 end
	local numiter = 0
	local updates = math.min(#transports,transports_per_tick)
	for k=index, #transports do local transport = transports[k]
		if is_valid_and_persistant(transport) and transport.energy > 0 then
			local_subspace_transports_process(transport)
		end
		if k >= #transports then k = 1 end
		numiter = numiter + 1
		if numiter >= updates or global.modmash.stock_transports >= stock_transports_per_tick then 
			global.modmash.transports_update_index	= k
			return
		end
	end
end

local local_on_entity_cloned = function(event)
	if is_valid(event.source) then
		if event.source.name == subspace_transport then 		
			table_remove(transports, event.source)	
			table.insert(transports, event.destination)	
		end
	end
end

modmash.register_script({
	names = {subspace_transport},
	on_init = local_init,
	on_load = local_load,
	on_start = local_init,
	on_tick = {
		priority = priority,
		tick = local_subspace_transports_tick,		
		table = function() return transports end,
		auto_add_remove = {subspace_transport}
		},
	on_entity_cloned = local_on_entity_cloned
})
