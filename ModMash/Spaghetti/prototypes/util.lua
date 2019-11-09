if not spaghetti then spaghetti = {} end
if not spaghetti.util then spaghetti.util = {} end
if not spaghetti.util.table then modmash.spaghetti.table = {} end

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

local local_distance = function( x1, y1, x2, y2 ) return math.sqrt( (x2-x1)^2 + (y2-y1)^2 ) end

local local_get_entity_size = function(entity)
	if entity == nil then return {1,1} end
	if entity.prototype.selection_box ~= nil then				
		return {
				entity.prototype.selection_box["right_bottom"]["x"] - entity.prototype.selection_box["left_top"]["x"],
				entity.prototype.selection_box["right_bottom"]["y"] - entity.prototype.selection_box["left_top"]["y"]}
	end
	return {1,1} 
end

spaghetti.util.convert_to_string = local_convert_to_string
spaghetti.util.log = local_log
spaghetti.util.print = local_print
spaghetti.util.is_valid = local_is_valid
spaghetti.util.is_valid_and_persistant = local_is_valid_and_persistant

spaghetti.util.is_int = local_is_int
spaghetti.util.starts_with = local_starts_with
spaghetti.util.ends_with = local_ends_with
spaghetti.util.index_of = local_index_of
spaghetti.util.table.length = local_table_length
spaghetti.util.table.index_of = local_table_index_of
spaghetti.util.table.remove = local_table_remove
spaghetti.util.table.contains = local_table_contains
spaghetti.util.table.clone = local_table_clone
spaghetti.util.table.remove_all = local_table_remove_all
spaghetti.util.distance = local_distance
spaghetti.util.get_entity_size = local_get_entity_size