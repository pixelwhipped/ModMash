if not util then require("prototypes.scripts.util") end
if not util.loader then util.loader = {} end
local beltTypes = {
  "loader","splitter","underground-belt","transport-belt"
}

local local_loader_added = function(entity)	
		if entity == nil or entity.type ~= "loader" then 
			return
		end
		if entity.direction  == defines.direction.north or entity.direction  == defines.direction.south then
			local north = util.get_entities_to_north(entity,beltTypes)
			if #north > 0 then
				if north[1].direction == 4 then entity.loader_type = "input" return end
				return
			end
			local south = util.get_entities_to_south(entity,beltTypes)
			if  #south > 0 then
				if south[1].direction == 0 then entity.loader_type = "input" return end
			end
		elseif entity.direction  == defines.direction.east or entity.direction  == defines.direction.west then
			local east = util.get_entities_to_east(entity,beltTypes)			
			if #east > 0 then
				if east[1].direction == 6 then entity.loader_type = "input" return end			
			end
			local west = util.get_entities_to_west(entity,beltTypes)
			if #west > 0 then
				if west[1].direction == 2 then entity.loader_type = "input" return end
			end
		end
	end

if modmash.ticks ~= nil then	
	table.insert(modmash.on_added,local_loader_added)
end

--util.loader_added = local_loader_added