if not modmash or not modmash.util then require("prototypes.scripts.util") end
--if not modmash.util.loader then modmash.util.loader = {} end

local get_entities_to_north  = modmash.util.get_entities_to_north
local get_entities_to_south  = modmash.util.get_entities_to_south
local get_entities_to_east  = modmash.util.get_entities_to_east
local get_entities_to_west  = modmash.util.get_entities_to_west

local beltTypes = {
  "loader","splitter","underground-belt","transport-belt"
}

local local_loader_added = function(entity)	
		if entity == nil or entity.type ~= "loader" then 
			return
		end
		if entity.direction  == defines.direction.north or entity.direction  == defines.direction.south then
			local north = get_entities_to_north(entity,beltTypes)
			if #north > 0 then
				if north[1].direction == 4 then entity.loader_type = "input" return end
				return
			end
			local south = get_entities_to_south(entity,beltTypes)
			if  #south > 0 then
				if south[1].direction == 0 then entity.loader_type = "input" return end
			end
		elseif entity.direction  == defines.direction.east or entity.direction  == defines.direction.west then
			local east = get_entities_to_east(entity,beltTypes)			
			if #east > 0 then
				if east[1].direction == 6 then entity.loader_type = "input" return end			
			end
			local west = get_entities_to_west(entity,beltTypes)
			if #west > 0 then
				if west[1].direction == 2 then entity.loader_type = "input" return end
			end
		end
	end

if modmash.ticks ~= nil then	
	table.insert(modmash.on_added,local_loader_added)
end
