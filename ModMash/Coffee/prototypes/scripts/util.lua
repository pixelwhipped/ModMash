if not coffee then coffee = {} end
if not coffee.util then coffee.util = {} end
if not coffee.util.raw then coffee.util.raw = {} end
if not coffee.util.table then coffee.util.table = {} end
if not coffee.util.signal then coffee.util.signal = {} end

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

local local_is_valid = function(entity) return (entity ~= nil and type(entity)=="table" and entity.valid) end
local local_is_valid_and_persistant = function(entity)  return local_is_valid(entity) and not entity.to_be_deconstructed(entity.force) end

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

local local_get_entities_to_excluding = function(direction, entity, type)
	local entities = local_get_entities_to(direction, entity, type)
	local ret = {}
	for index=1, #entities do
		local e = entities[index]
		if e ~= entity then 
			table.insert(ret,e)
		end
	end
	return ret
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

local local_get_entities_around = function(entity,tiles_away,findtype,name)
	local wh = local_get_entity_size(entity)
	local w = 0.5*wh[1] --wh[1]/2
	local h = 0.5*wh[2] --wh[2]/2
	local entities

	-- pushes the distance out from the entity if tiles_away
	if type(tiles_away) == "number" then w = w + tiles_away h = h + tiles_away
	elseif type(tiles_away) == "string" then w = w + tonumber(tiles_away) h = h + tonumber(tiles_away) end

	entities = entity.surface.find_entities_filtered{area = {{entity.position.x-w, entity.position.y-h}, {entity.position.x+w, entity.position.y+h}}, type = findtype, name = name}
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

local local_get_name_for = function(item, prefix, suffix)
        local result
		if prefix == nil and suffix == nil then suffix = "" end
		if type(item) == "string" then item = 
		{
			localised_name = item
		} end
		if item.localised_name then
			if type(item.localised_name) == "table" then
				result = item.localised_name[1]
			else
				result = item.localised_name
				if prefix ~= nil then
					if suffix ~= nil then
						return {"recipe-name.concatenationstrings",prefix,result,suffix} 	
					else
						return {"recipe-name.concatenationstring",prefix,result} 
					end
				elseif suffix ~= nil then
					return {"recipe-name.concatenationstring",result,suffix} 				
				else
					return {"recipe-name.defaultstring",result} 
				end
            end
		elseif item.place_result then
            result = 'entity-name.'..item.place_result
        elseif item.placed_as_equipment_result then
            result = 'equipment-name.'..item.placed_as_equipment_result
        else
            result = 'item-name.'..item.name
        end
		if prefix ~= nil then
			if suffix ~= nil then
				return {"recipe-name.concatenationstrings",prefix,{result},suffix} 	
			else
				return {"recipe-name.concatenationstring",prefix,{result}} 
			end
		elseif suffix ~= nil then
			return {"recipe-name.concatenationstring",{result},suffix} 				
		else
			return {"recipe-name.defaultstring",{result}} 
		end
	end

local local_check_icon_size = function(size,fallback)
	if size ~= nil then return size end
	if fallback ~= nil then return fallback end
	return 32
end
local local_create_icon = function(base_icons, add_icon, add_size, add_icons, add_scale, add_shift)	
	local icons =  nil
	
	local base_size = base_icons[1].icon_size
	base_size = local_check_icon_size(base_size,add_size)
	local base_scale = 64/base_size

	icons = {
		{
			icon = "__coffee__/graphics/blank64.png",
			icon_size = 64
			}
		}
	for k = 1, #base_icons do 		
			local i = base_icons[k]		
			local s = local_check_icon_size(i.icon_size,add_size)/64
			local off = {0,0}
			if i.shift ~= nil then off = i.shift end
			local add = {
				icon = i.icon,
				icon_size = local_check_icon_size(i.icon_size,add_size),
				scale = i.scale,
				tint = i.tint,
				shift = {off[1]+(add_shift[1]*s),off[2]+(add_shift[2]*s)},
			}
			table.insert(icons,add)
		end

	if add_icons == nil or #add_icons == 0 then
		table.insert(icons,
			{
				icon = add_icon,
				icon_size = add_size,
				scale = add_scale,
				shift = add_shift
			})
	else
		for k = 1, #add_icons do 		
			local i = add_icons[k]		
			local s = 1
			local off = {0,0}
			if i.shift ~= nil then off = i.shift end
			if i.scale ~= nil then s = i.scale end
			local add = {
				icon = i.icon,
				icon_size = local_check_icon_size(i.icon_size,add_size),
				scale = add_scale,
				shift = add_shift,
				tint = i.tint
			}
			table.insert(icons,add)
		end
	end
	return icons
end

coffee.util.create_icon = local_create_icon
coffee.util.signal.get_posistion_from = local_get_signal_position_from
coffee.util.signal.set_new_signal = local_set_new_signal

coffee.util.try_set_recipe = local_try_set_recipe
coffee.util.convert_to_string = local_convert_to_string
coffee.util.get_name_for = local_get_name_for
coffee.util.log = local_log
coffee.util.print = local_print
coffee.util.is_valid = local_is_valid
coffee.util.is_valid_and_persistant = local_is_valid_and_persistant

coffee.util.is_int = local_is_int
coffee.util.starts_with = local_starts_with
coffee.util.ends_with = local_ends_with
coffee.util.index_of = local_index_of
coffee.util.aggrigate_content = local_aggrigate_content
coffee.util.raw.find_raw_entity = local_find_raw_entity
coffee.util.raw.find_recipies_for = local_find_recipies_for
coffee.util.table.length = local_table_length
coffee.util.table.index_of = local_table_index_of
coffee.util.table.remove = local_table_remove
coffee.util.table.contains = local_table_contains
coffee.util.table.clone = local_table_clone
coffee.util.table.remove_all = local_table_remove_all
coffee.util.table.aggrigate = local_aggrigate_content
coffee.util.distance = local_distance
coffee.util.patch_technology = local_patch_technology
coffee.util.get_entity_size = local_get_entity_size

coffee.util.opposite_direction = local_opposite_direction
coffee.util.get_entities_to = local_get_entities_to
coffee.util.get_entities_to_northwest = local_get_entities_to_northwest
coffee.util.get_entities_to_norteast = local_get_entities_to_norteast
coffee.util.get_entities_to_north = local_get_entities_to_north
coffee.util.get_entities_to_east = local_get_entities_to_east
coffee.util.get_entities_to_south = local_get_entities_to_south
coffee.util.get_entities_to_west = local_get_entities_to_west
coffee.util.get_entities_to_southeast = local_get_entities_to_southeast
coffee.util.get_entities_to_southwest = local_get_entities_to_southwest
coffee.util.get_entities_around = local_get_entities_around
coffee.util.get_entity_size = local_get_entity_size
coffee.util.get_entities_to_excluding = local_get_entities_to_excluding
