if not modmash then modmash = {} end
if not modmash.util then modmash.util = {} end
if not modmash.util.raw then modmash.util.raw = {} end
if not modmash.util.table then modmash.util.table = {} end
if not modmash.util.signal then modmash.util.signal = {} end
if not modmash.util.types then require ("prototypes.scripts.types") end

local is_polutant = modmash.util.types.is_polutant
local biome_types = modmash.util.types.biome_types

local local_convert_to_string = function (arg)
	ToString = function(arg)
		local res=""
		if type(arg)=="table" then
			res="{"
			for k,v in pairs(arg) do
				res=res.. tostring(k).." = ".. ToString(v) ..","
			end
			res=res.."}"
		else
			res=tostring(arg)
		end
		return res
	end
	return ToString(arg, "  ") 
end

local local_log = function(arg) log(local_convert_to_string(arg)) end

local local_print = function(arg,index)
	if index ~= nil then
		if game ~=nil then
			game.players[index].print(local_convert_to_string(message))
		else
			local_log(arg)
		end
	elseif game ~=nil then
		for i = 1, #game.players do local p = game.players[i]
			p.print(local_convert_to_string(arg))
		end
	else
		local_log(arg)
	end 
end

local local_is_valid = function(entity) return (entity ~= nil and entity.valid) end

local local_is_int = function(n) return (type(n) == "number") and (math.floor(n) == n) end

local local_starts_with = function(str, start) return str ~=nil and start ~=nil and str:sub(1, #start) == start end

local local_ends_with = function(str, ending) return str ~=nil and ending ~=nil and (ending == "" or str:sub(-#ending) == ending) end

local local_index_of = function(str,f_str)
	local i = 0
	i = string.find(str, f_str, 1, true)
	return i 
end

local local_aggrigate_content = function(cx1,cx2)
	local function add_from(tble, name)
		local cnt = 0
		if tble == nil then return 0 end
		if name == nil then return 0 end
		for x=1, #tble do local y = tble[x]
			if y.name == name then cnt = cnt + y.count end
		end
		return cnt
	end
	if cx1 == nil then return cx2 end
	if cx2 == nil then return cx1 end
	local c1  = cx1
	local c2  = cx2
	if #c1<#c2 then
		c1 = cx2
		c2 = cx1
	end
	local ret = {}
	for k=1, #c1 do local v = c1[k]		
		local found = false
		for j=1, #ret do local z = ret[j]
			if z.name == v.name then
				found = true
				break
			end
		end
		if found == false then
			local c = v.count + add_from(c2,v.name)							
			table.insert(ret,{name =v.name,count=c})
		end
	end
	local cret = {}
	for _, x in pairs(ret) do cret[x.name]= x.count end
	return cret
end

local local_find_raw_entity_prototypes = function(proto_type)
	for i,category in pairs (data.raw) do
		if category ~= nil and type(category)=="table" then
			for j,prototype in pairs (category) do					
				if prototype ~= nil and prototype.type == proto_type then return prototype end
			end
		end
	end
	return nil 
end

local local_find_raw_entity = function(name)
	for i,category in pairs (data.raw) do
		if category ~= nil and type(category)=="table" then
			for j,prototype in pairs (category) do					
				if prototype ~= nil and prototype.type ~= "recipe" and prototype.name == name then return prototype end
			end
		end
	end
	return nil 
end

local local_find_recipies_for = function(name)
	local recipies = {}
	for i,r in pairs (data.raw["recipe"]) do	
		if recipies[r.name] == nil then
			if r.normal ~= nil then 	
				if r.normal.result ~= nil then   
					if r.normal.result == name and recipies[r.name] == nil then recipies[r.name] = r end
				end
				if r.normal.results ~= nil then
					for k=1, #r.normal.results do local i = r.normal.results[k]
						if i.name == name and recipies[r.name] == nil then recipies[r.name] = r end
					end
				end
			end
			if r.expensive ~= nil then 	
				if r.expensive.result ~= nil then   
					if r.expensive.result == name and recipies[r.name] == nil then recipies[r.name] = r end
				end
				if r.expensive.results ~= nil then
					for k=1, #r.expensive.results do local i = r.expensive.results[k]
						if i.name == name and recipies[r.name] == nil then recipies[r.name] = r end
					end
				end
			end
			if r.result ~= nil then   
				if r.result == name and recipies[r.name] == nil then recipies[r.name] = r end
			end
			if r.results ~= nil then
				for k=1, #r.results do local i = r.results[k]
					if i.name == name and recipies[r.name] == nil then recipies[r.name] = r end
				end
			end
		end
	end
	return recipies
end

local local_table_length = function(table)
	local count = 0
	for k, v in next, table do count = count + 1 end
	return count 
end

local local_table_index_of = function(table,value)
	for k, v in pairs(table) do 
		if v == value then 
			return k 
		end
	end return nil 
end

local local_table_contains = function(table, value) return local_table_index_of(table,value) ~= nil end

local local_table_remove = function(tble,value)
	local new_table = {}
	if tble ~= nil then
		if local_is_int(value) == true then
			table.remove(tble,value)			
		else
			for k, v in next, table do 
				if v ~= value then 
					table.insert(new_table,v)
				end
			end			
		end
	end
	tble = new_table
	return tble
end

local local_table_remove_all = function(tbl,remove)
	for i,j in pairs(remove) do
		tbl = local_table_remove(tbl,j)
	end
	return tbl
end

local local_table_clone = function(t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = local_table_clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target 
end

local local_aggrigate_content = function(cx1,cx2)
	local function add_from(tble, name)
		local cnt = 0
		if tble == nil then return 0 end
		if name == nil then return 0 end
		for x=1, #tble do local y = tble[x]
			if y.name == name then cnt = cnt + y.count end
		end
		return cnt
	end
	if cx1 == nil then return cx2 end
	if cx2 == nil then return cx1 end
	local c1  = cx1
	local c2  = cx2
	if #c1<#c2 then
		c1 = cx2
		c2 = cx1
	end
	local ret = {}
	for k=1, #c1 do local v = c1[k]		
		local found = false
		for j=1, #ret do local z = ret[j]
			if z.name == v.name then
				found = true
				break
			end
		end
		if found == false then
			local c = v.count + add_from(c2,v.name)							
			table.insert(ret,{name =v.name,count=c})
		end
	end
	local cret = {}
	for _, x in pairs(ret) do cret[x.name]= x.count end
	return cret 
end

local local_distance = function( x1, y1, x2, y2 ) return math.sqrt( (x2-x1)^2 + (y2-y1)^2 ) end

local local_transfer_fluid = function(from,findex,to,tindex,amount,max)
	if from == nil or to == nil then return end
	local from_boxes = from.fluidbox
	local from_box = from_boxes[findex]		
	local to_boxes = to.fluidbox		
	local to_box = to_boxes[tindex]
	if from_box == nil then return end
	if to_box == nil then 
		if from_box.amount <= amount then
			from_boxes[findex] = nil
			to_boxes[tindex] = from_box
		else  				
			from_box.amount = from_box.amount - amount
			from_boxes[findex] = from_box
			from_box.amount = amount
			to_boxes[tindex] = from_box
		end
	else
		local tcap = to_boxes.get_capacity(tindex) - to_box.amount	
		local tfer = math.min(tcap,math.min(from_box.amount,amount))
		if tfer <=0 then return end		
		from_box.amount = math.max(from_box.amount - tfer,1)
		from_boxes[1] = from_box
		from_box.amount = to_box.amount + tfer
		to_boxes[tindex] = from_box				
	end 
end

local local_transfer_fluid_and_convert = function(from,findex,to,tindex,amount,max,totype,temp)
	if from == nil or to == nil then return end
	local from_boxes = from.fluidbox
	local from_box = from_boxes[findex]		
	local to_boxes = to.fluidbox		
	local to_box = to_boxes[tindex]
	if temp == nil then temp = game.fluid_prototypes[totype] end
	local fluid_prototype = game.fluid_prototypes[totype]
	if from_box == nil then return end
	if to_box == nil then 
		if from_box.amount <= amount then
			from_boxes[findex] = nil					
			if local_is_int(temp) then from_box.temperature = temp end
			from_box.name = totype							
			to_boxes[tindex] = from_box					
		else		
			from_box.amount = from_box.amount - amount
			from_boxes[findex] = from_box
			from_box.amount = amount					
			if local_is_int(temp) then from_box.temperature = temp end
			from_box.name = totype					
			to_boxes[tindex] = from_box
		end
	else
		local tcap = to_boxes.get_capacity(tindex) - to_box.amount	
		local tfer = math.min(tcap,math.min(from_box.amount,amount))
		if tfer <=0 then return end
		from_box.amount = math.max(from_box.amount - tfer,1)
		from_boxes[1] = from_box
		from_box.amount = to_box.amount + tfer
		if local_is_int(temp) then from_box.temperature = temp end
		from_box.name = totype
		to_boxes[tindex] = from_box
	end 
end

local local_get_connected_input_fluid = function(entity, box)
	local call = function(e,b)
		if not e.fluidbox or b > #e.fluidbox then return nil end	
		local inpipe = e.fluidbox.get_connections(b)	
		if inpipe == nil then return nil end
		for i = 1, #inpipe do local ip = inpipe[i]	
			if ip ~= nil then			
				for j = 1, #ip do local jp = ip[j]
					if jp ~= nil and ip.owner.fluidbox then
						for m = 1, #ip.owner.fluidbox do mp = ip.owner.fluidbox.get_connections(m)	
							if mp ~= nil then
								for mx = 1, #mp do mpx = mp[mx]
									if mpx.owner == e then
										return {entity = ip.owner, box = m} 
									end
								end
							end
						end
					end
				end
			end
		end
	end
	local status, retval = pcall(call,entity,box)
	if status == true then return retval end
end

local local_addable_fluid = function(entity, amount, index)
	local cap = 100
	if entity.fluidbox[index].get_capacity then 
		cap = entity.fluidbox[index].get_capacity(index) 
	end
	local avail = cap - entity.fluidbox[index].amount
	return math.min(avail,math.abs(amount)) 
end

local local_removeable_fluid = function(fluid, amount) return math.min(fluid.amount,math.abs(amount)) end

local local_change_fluidbox_fluid = function(entity,amount, pollution_source)
    local delta = 0
	local used = 0
	local abs_amount = math.abs(amount)
    if entity.fluidbox ~= nil then
		for i = 1, #entity.fluidbox do	
			local fluid =  entity.fluidbox[i]
			local current_fluid = "water"
			if fluid ~= nil and fluid.amount > 0 then			    
				local innerDelta = 0
				current_fluid = fluid.name
				if amount < 0 then					
					innerDelta = local_removeable_fluid(fluid,amount)					
					fluid.amount = fluid.amount-innerDelta
					if fluid.amount <= 0 then
						entity.fluidbox[i] = nil			
					else
						entity.fluidbox[i] = fluid	
					end
				else
					innerDelta = local_addable_fluid(entity,amount,i)
					fluid.amount = fluid.amount-innerDelta
					if fluid.amount <= 0 then
						entity.fluidbox[i] = nil			
					else
						entity.fluidbox[i] = fluid	
					end
				end
				used = used + innerDelta 
				if pollution_source ~= nil then
					if is_polutant(current_fluid) == true then
						pollution_source.surface.pollute(pollution_source.position,0.01)
					end
				end
				if used >= amount then 
					if(amount < 0) then return used * -1 end
					return used
				end
			end
		end
	end
	if(amount < 0) then return used * -1 end
	return used
end

local local_get_biome = function(entity)
	local r = 10
	local aabb = entity.prototype.collision_box
	local box = {{entity.position.x-r-aabb.left_top.x, entity.position.y-r-aabb.left_top.y}, {entity.position.x+r+aabb.right_bottom.x, entity.position.y+r+aabb.right_bottom.y}}
	local tiles = entity.surface.find_tiles_filtered{area=box}
	local counts = {}
	counts["basic"] = #tiles
	for _,tile in pairs(tiles) do
		for type,fac in pairs(biome_types) do
			if type ~= "basic" and string.find(tile.name, type) then
				counts["basic"] = counts["basic"]-1
				counts[type] = counts[type] and counts[type]+1 or 1
			end
		end
	end
	local max = 0
	local ret = "basic"
	for type,count in pairs(counts) do
		if count > max then
			ret = type
			max = count
		end
	end
	for _,tile in pairs(tiles) do
		if tile.name == ret then return ret end
	end
	return "basic"
end

local local_patch_technology = function(technology, recipe)
	if data.raw["technology"][technology] then
		table.insert(data.raw["technology"][technology].effects, {
			type="unlock-recipe",
			recipe=recipe
		})
	end 
end

local local_get_entity_size = function(entity)
	if entity == nil then return {1,1} end	
	if entity.prototype.selection_box ~= nil then				
		local size = {
				entity.prototype.selection_box["right_bottom"]["x"] - entity.prototype.selection_box["left_top"]["x"],
				entity.prototype.selection_box["right_bottom"]["y"] - entity.prototype.selection_box["left_top"]["y"]}
		if entity.direction == 0 or entity.direction == 4 then return size end
		return {size[2],size[1]}
	end
	return {1,1} 
end

local local_opposite_direction = function(direction)
	if direction == defines.direction.north then return defines.direction.south end
	if direction == defines.direction.northeast	 then return defines.direction.southwest end
	if direction == defines.direction.east then return defines.direction.west end
	if direction == defines.direction.southeast then return defines.direction.northwest  end
	if direction == defines.direction.south then return defines.direction.north end
	if direction == defines.direction.southwest then return defines.direction.northeast end
	if direction == defines.direction.west then return defines.direction.east end
	if direction == defines.direction.northwest then return defines.direction.southeast end
	return direction 
end

local local_get_entities_to_northwest = function(entity,type)
	local wh = local_get_entity_size(entity)
	if wh == {0, 0} then wh = {1,1} end
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x-(w+0.5), entity.position.y-h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x-(w+0.5), entity.position.y-h}}) 
end

local local_get_entities_to_northeast = function(entity,type)
	local wh = local_get_entity_size(entity)
	if wh == {0, 0} then wh = {1,1} end
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x+w, entity.position.y-(h+0.5)}, {entity.position.x+(w+0.5), entity.position.y-h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x+w, entity.position.y-(h+0.5)}, {entity.position.x+(w+0.5), entity.position.y-h}}) 
end

local local_get_entities_to_north = function(entity,type)
	local wh = local_get_entity_size(entity)	
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x+w, entity.position.y-h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y-(h+0.5)}, {entity.position.x+w, entity.position.y-h}})
end

local local_get_entities_to_south = function(entity,type)
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y+h}, {entity.position.x+w, entity.position.y+h+(0.5)}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y+h}, {entity.position.x+w, entity.position.y+h+(0.5)}}) 
end

local local_get_entities_to_east = function(entity,type)
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+h}}) 
end

local local_get_entities_to_west = function(entity,type) 
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-(w+0.5), entity.position.y-h}, {entity.position.x-w, entity.position.y+h}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-(w+0.5), entity.position.y-h}, {entity.position.x-w, entity.position.y+h}}) 
end

local local_get_entities_to_southeast = function(entity,type)
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+(h+0.5)}}, type = type} end
	return entity.surface.find_entities({{entity.position.x+w, entity.position.y-h}, {entity.position.x+(w+0.5), entity.position.y+(h+0.5)}}) 
end

local local_get_entities_to_southwest = function(entity,type)
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	if type ~= nil then return entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-h}, {entity.position.x-(w+0.5), entity.position.y+(h+0.5)}}, type = type} end
	return entity.surface.find_entities({{entity.position.x-w, entity.position.y-h}, {entity.position.x-(w+0.5), entity.position.y+(h+0.5)}})
end

local local_get_entities_to = function(direction, entity, type)
    local d = local_opposite_direction(direction)
	if d == defines.direction.north then return local_get_entities_to_north(entity,type) end
	if d == defines.direction.northeast	 then return local_get_entities_to_northeast(entity,type) end
	if d == defines.direction.east then return local_get_entities_to_east(entity,type) end
	if d == defines.direction.southeast then return local_get_entities_to_southeast(entity,type) end
	if d == defines.direction.south then return local_get_entities_to_south(entity,type) end
	if d == defines.direction.southwest then return local_get_entities_to_southwest(entity,type) end
	if d == defines.direction.west then return local_get_entities_to_west(entity,type) end
	if d == defines.direction.northwest then return local_get_entities_to_northwest(entity,type) end
	return {} 
end

local local_get_entity_size = function(entity)
	if entity == nil then return {1,1} end
	if entity.prototype.selection_box ~= nil then				
		return {
				entity.prototype.selection_box["right_bottom"]["x"] - entity.prototype.selection_box["left_top"]["x"],
				entity.prototype.selection_box["right_bottom"]["y"] - entity.prototype.selection_box["left_top"]["y"]}
	end
	return {1,1} 
end

local local_get_entities_around = function(entity, tiles,type,name)	
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	local entities
	if type ~= nil then
		if name ~= nil then
			entities = entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-h}, {entity.position.x-(w+0.5), entity.position.y+(h+0.5)}}, type = type}
		else
			entities = entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-h}, {entity.position.x-(w+0.5), entity.position.y+(h+0.5)}}, type = type, name = name}
		end
	else
		if name ~= nil then
			entities = entity.surface.find_entities_filtered{area = {{entity.position.x-(w+tiles), entity.position.y-(h+tiles)}, {entity.position.x+(w+tiles), entity.position.y+(h+tiles)}}, name = name}
		else
			entities = entity.surface.find_entities({{entity.position.x-(w+tiles), entity.position.y-(h+tiles)}, {entity.position.x+(w+tiles), entity.position.y+(h+tiles)}})
		end
	end
	for i, ent in pairs(entities) do	
		if ent == entity then
			table.remove(entities,i)
			break
		end	
	end
	return entities	
end

local local_try_set_recipe = function(entity,recipe)
	local call = function(e,f)
		e.set_recipe(f)
	end
	local status, retval = pcall(call,entity,recipe)
	if status == true then return end
end

local local_get_signal_position_from = function(entity)
    local left_top = entity.prototype.selection_box.left_top
    local right_bottom = entity.prototype.selection_box.right_bottom
    --Calculating center of the selection box
    local center = (left_top.x + right_bottom.x) / 2
    local width = math.abs(left_top.x) + right_bottom.x
    -- Set Shift here if needed, The offset looks better as it doesn't cover up fluid input information
    -- Ignore shift for 1 tile entities
    local x = (width > 1.25 and center - 0.5) or center
    local y = right_bottom.y
    --Calculating bottom center of the selection box
    return {x = entity.position.x + x, y = entity.position.y + y}
end

local local_set_new_signal = function(entity, name, variation)
    local signal = entity.surface.create_entity{name = name, position = local_get_signal_position_from(entity), force = entity.force}
    signal.graphics_variation = variation
    signal.destructible = false
    return signal
end

modmash.util.signal.get_posistion_from = local_get_signal_position_from
modmash.util.signal.set_new_signal = local_set_new_signal

modmash.util.try_set_recipe = local_try_set_recipe
modmash.util.convert_to_string = local_convert_to_string
modmash.util.log = local_log
modmash.util.print = local_print
modmash.util.is_valid = local_is_valid
modmash.util.is_int = local_is_int
modmash.util.starts_with = local_starts_with
modmash.util.ends_with = local_ends_with
modmash.util.index_of = local_index_of
modmash.util.aggrigate_content = local_aggrigate_content
modmash.util.raw.find_raw_entity = local_find_raw_entity
modmash.util.raw.find_recipies_for = local_find_recipies_for
modmash.util.table.length = local_table_length
modmash.util.table.index_of = local_table_index_of
modmash.util.table.remove = local_table_remove
modmash.util.table.contains = local_table_contains
modmash.util.table.clone = local_table_clone
modmash.util.table.remove_all = local_table_remove_all
modmash.util.table.aggrigate = local_aggrigate_content
modmash.util.distance = local_distance
modmash.util.patch_technology = local_patch_technology
modmash.util.transfer_fluid = local_transfer_fluid
modmash.util.transfer_fluid_and_convert = local_transfer_fluid_and_convert
modmash.util.get_connected_input_fluid = local_get_connected_input_fluid
modmash.util.get_biome = local_get_biome
modmash.util.get_entity_size = local_get_entity_size

modmash.util.change_fluidbox_fluid = local_change_fluidbox_fluid

modmash.util.opposite_direction = local_opposite_direction
modmash.util.get_entities_to = local_get_entities_to
modmash.util.get_entities_to_northwest = local_get_entities_to_northwest
modmash.util.get_entities_to_norteast = local_get_entities_to_norteast
modmash.util.get_entities_to_north = local_get_entities_to_north
modmash.util.get_entities_to_east = local_get_entities_to_east
modmash.util.get_entities_to_south = local_get_entities_to_south
modmash.util.get_entities_to_west = local_get_entities_to_west
modmash.util.get_entities_to_southeast = local_get_entities_to_southeast
modmash.util.get_entities_to_southwest = local_get_entities_to_southwest
modmash.util.get_entities_around = local_get_entities_around
modmash.util.get_entity_size = local_get_entity_size