require("prototypes.scripts.defines") 
data_state = wiki.defines.data_stages.data
if not wiki then wiki = {} end
if not wiki.util then wiki.util = {} end

local local_data_stage = function() 
	if data_state == wiki.defines.data_stages.control then 
		return wiki.defines.data_stages.control
	end
	return data_state
	end

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

local local_starts_with = function(str, start) return str ~=nil and start ~=nil and str:sub(1, #start) == start end

local local_ends_with = function(str, ending) return str ~=nil and ending ~=nil and (ending == "" or str:sub(-#ending) == ending) end

local local_table_index_of = function(table,value)
	for k, v in pairs(table) do 
		if v == value then 
			return k 
		end
	end return nil 
	end

local local_table_contains = function(table, value) return local_table_index_of(table,value) ~= nil end

wiki.util.data_stage = local_data_stage
wiki.util.log = local_log
wiki.util.print = local_print
wiki.util.starts_with = local_starts_with
wiki.util.ends_with = local_ends_with
wiki.util.table_contains = local_table_contains
wiki.util.index_of = local_table_index_of