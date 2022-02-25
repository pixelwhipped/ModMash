if not mms2.log_enable then mms2.log_enable = true end

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

local local_log = function(arg) if mms2.log_enable == true then log(local_convert_to_string(arg)) end end
local local_log_disable = function() mms2.log_enable = false end
local local_log_enable = function() mms2.log_enable = true end
local local_is_logging = function() return mms2.log_enable end

local local_is_int = function(n) return (type(n) == "number") and (math.floor(n) == n) end

local local_starts_with = function(str, start) return str ~=nil and start ~=nil and str:sub(1, #start) == start end
local local_ends_with = function(str, ending) return str ~=nil and ending ~=nil and (ending == "" or str:sub(-#ending) == ending) end
local local_index_of = function(str, f_str) return string.find(str, f_str, 1, true) end
local local_is_empty = function(s) return s == nil or s == '' end

local local_get_name_for = function(item, prefix, suffix)
	local result
	if prefix == nil and suffix == nil then suffix = "" end
	if type(item) == "string" then item = { localised_name = item } end
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
			return { "recipe-name.concatenationstrings",prefix,{ result},suffix} 	
		else
			return {"recipe-name.concatenationstring",prefix,{result}} 
		end
	elseif suffix ~= nil then
		return {"recipe-name.concatenationstring",{result},suffix} 				
	else
		return {"recipe-name.defaultstring",{result}} 
	end
	end

local local_is_dictionary = function(d)
	for k, v in pairs(d) do 
		return type(k) == "string" and type(v)=="number"
	end
	return false
	end
local local_to_dictionary = function(tble,get_name,get_count)
    local cret = { }
    for _, x in pairs(tble) do cret[get_name(x)]= get_count(x) end
    return cret
	end
local local_table_length = function(table)
    local count = 0
	for k, v in next, table do count = count + 1 end
	return count 
	end
local local_table_is_empty = function(table)
	if table == nil then return true end
	return local_table_length(table) == 0
	end

local local_table_index_of = function(table, value)
	for k, v in pairs(table) do 
		if v == value then
			return k
        end
    end return nil
	end
local local_table_contains = function(table, value) return local_table_index_of(table, value) ~= nil end
local local_table_remove = function(tble, value)
    local new_table = { }
	if tble ~= nil then
		if local_is_int(value) == true then
            table.remove(tble, value)
		else
			for k, v in next, table do 
				if v ~= value then
                    table.insert(new_table, v)
                end

            end
        end
    end
    tble = new_table
	return tble
    end
local local_table_remove_all = function(tbl, remove)
	for i,j in pairs(remove) do
		tbl = local_table_remove(tbl, j)
    end
	return tbl
    end

local local_inner_table_clone = function(t,c,e,a)  
	local meta = getmetatable(t)
	local tbl = { }
	for k, v in pairs(t) do
		if type(v) == "table" then
			local i = local_table_index_of(e,v)
			if i ~= nil then
				tbl[k] = a[i]
			else
				table.insert(e,v)
				local nt = c(v,c,e,a)
				table.insert(a,nt)
				tbl[k] = nt
			end
		else
			tbl[k] = v
		end
	end
	setmetatable(tbl, meta)
	return tbl
	end

local local_table_clone = function (t)
	if type(t) ~= "table" then return t end	
	return local_inner_table_clone(t,local_inner_table_clone,{},{})	
	end

local local_distance_squared = function(x1, y1, x2, y2)
	local x, y = x1-x2, y1-y2
	return (x*x+y*y)
	end

local local_distance = function(x1, y1, x2, y2) 
  local x, y = x1-x2, y1-y2
  return math.sqrt(x*x+y*y)
  end

local local_opposite_direction = function(direction)
	if direction == defines.direction.north then return defines.direction.south end
	if direction == defines.direction.northeast then return defines.direction.southwest end
	if direction == defines.direction.east then return defines.direction.west end
	if direction == defines.direction.southeast then return defines.direction.northwest end
	if direction == defines.direction.south then return defines.direction.north end
	if direction == defines.direction.southwest then return defines.direction.northeast end
	if direction == defines.direction.west then return defines.direction.east end
	if direction == defines.direction.northwest then return defines.direction.southeast end
	return direction
    end


mms2.opposite_direction = local_opposite_direction
mms2.convert_to_string = local_convert_to_string
mms2.log = local_log
mms2.log_disable = local_log_disable
mms2.log_enable = local_log_enable
mms2.is_logging = local_is_logging
mms2.is_int = local_is_int
mms2.starts_with = local_starts_with
mms2.is_empty = local_is_empty
mms2.ends_with = local_ends_with
mms2.get_name_for = local_get_name_for
mms2.index_of = local_index_of
mms2.table = {	
	is_dictionary = local_is_dictionary,
	to_dictionary = local_to_dictionary,
	is_empty = local_table_is_empty,
	length = local_table_length,
	index_of = local_table_index_of,
	remove = local_table_remove,
	contains = local_table_contains,
	table_clone = local_table_clone
}

mms2.tech = {}
mms2.entity = {}
mms2.recipe = {}
mms2.fluid = {}
mms2.signal = {}

mms2.distance = local_distance
mms2.distance_squared = local_distance_squared

if remote ~= nil then
	require("utilcontrol")
else 
	require("utildata")
end