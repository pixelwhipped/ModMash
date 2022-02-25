mms2.print = mms2.log
local table_contains = mms2.table.contains

local local_is_valid = function(entity) return type(entity)=="table" end

local raw_items = {"item","accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}
local item_list = nil

local local_starts_with = function(str, start) return str ~=nil and start ~=nil and str:sub(1, #start) == start end

local local_get_item = function(name)
	if item_list == nil then
		item_list = {}
		for r = 1, #raw_items do local raw = raw_items[r]	
			for name,item in pairs(data.raw[raw]) do			
				if item ~= nil and item.name ~= nil and local_starts_with(item.name,"YARM-fake-")==false then	
					if item_list[item.name] ~= nil then
						if item_list[item.name].icon_size == nil and item.icon_size ~= nil and (item.place_result ~= nil or item.stack_size ~= nil) then
                            if item.place_result ~= nil then
                                item_list[item.place_result] = item
                            else
							    item_list[item.name] = item
                            end
						end
					elseif item.place_result ~= nil then
                        item_list[item.place_result] = item
                    else
                        item_list[item.name] = item
					end
				end
			end
		end
	end
	return item_list[name]
    end

if mms2.mod_request_item_substitutions == nil then 
	mms2.mod_request_item_substitutions = {
	}
end

local local_validate_item_substitutions = function(name, func)		
	if mms2.table.is_empty(test) then log("substitution for ".. name .. " is nil or empty") return false end
	if type(func) ~= "function" then log("substitution for ".. name .. " missing function") return false end
	local test  = func(1)
	for k=1, #test do local ingredient = test[k]
		if type(ingredient) ~= "table" then log("substitution for ".. name .. " ingredient[" ..k.. "] invalid") return false end
		if mms2.is_empty(ingredient.name) then log("substitution for ".. name .. " ingredient[" ..k.. "] missing name") return false end
		if mms2.is_int(ingredient.amount) then log("substitution for ".. name .. " ingredient[" ..ingredient.name.. "] missing amount") return false end
	end
	return true
	end

local local_register_item_substitution = function(name, func, compat)
	if mms2.is_empty(name) then log("name for item substitution invalid") return false end
	if local_validate_item_substitutions(name,func) ~= true then log("item ".. name .. " substitution failed") return false end
	if mms2.mod_request_item_substitutions[name] ~= nil then 
		if mms2.mod_request_item_substitutions[name].compat() == false then
			log("replacing item ".. name .. " substitution from "..  serpent.block(mms2.mod_request_item_substitutions[name].func(1)) .. " with " .. serpent.block(func(1)))
		else
			log("cannot replace item ".. name .. " substitution from "..  serpent.block(mms2.mod_request_item_substitutions[name].func(1)) .. " with " .. serpent.block(func(1)) .. " becase compatibilty function is blocking action")
		end
	end
	if compat == nil or type(compat()) ~= "boolean" then 
		compat = function() return false end
	end
	mms2.mod_request_item_substitutions[name] = {
		func = func,
		compat = compat
		}
	end
	

local remove_ingredient_from = function(tble,value)
	local new_table = {}
	if tble ~= nil then
		for i = 1, #tble do	
			if tble[i] ~= nil then
				if tble[i].name ~= nil and tble[i].name ~= value then 
					table.insert(new_table,tble[i])
				elseif tble[i][1] ~= nil and tble[i][1] ~= value then						
					table.insert(new_table,tble[i])
				end
			end
		end			
	end
	tble = new_table
	return new_table
	end 

local local_substitue_ingredient_item = function(name,ingredients)		
    if mms2.is_empty(name) then log("name for item substitution invalid") return false end
	if mms2.table.is_empty(ingredients) then log("ingredients for item substitution " .. name .. " is invalid") return false end
	local count = 0
	local probability = nil
	for k = 1, #ingredients do local ingredient = ingredients[k]
		if ingredient ~= nil and (ingredient[1] == name or ingredient.name == name) then
			count = count + (ingredient.amount or ingredient[2])
			if ingredient.probability ~= nil then probability = ingredient.probability end
		end
	end
	if mms2.mod_request_item_substitutions[name] ~= nil then
		local sub = mms2.mod_request_item_substitutions[name].func(count,probability)
		if sub ~= nil and type(sub) == "table" and #sub > 0 then
			local new_table = remove_ingredient_from(ingredients,name)
			for k = 1, #sub do
				table.insert(new_table,sub[k])
			end
			ingredients = new_table
			return new_table
		end
	end
	return ingredients
	end

local local_get_item_substitution = function(name)	
	if type(name) == "string" then  		
		local s = local_substitue_ingredient_item(name,{{name = name, amount = 1}})
		if s~=nil and type(s) == "table" and #s > 0 and s[1].name ~= nil then 
			if s[1].type == "fluid" then
				local i = data.raw["fluid"][s[1].name]
				return i
			else
				local i = local_get_item(s[1].name) 
				return i
			end			
		end
	end
	return local_get_item(name)
	end

local local_get_item_ingredient_substitutions_merged = function(ingredients)
	local temp = {}
	local ret = {}
	for k=1, #ingredients do local i = ingredients[k]
		if i ~= nil then
			if i.name == nil then
				temp[i[1]] = {name = i[1], amount = i[2]}
			elseif temp[i.name] == nil then
				temp[i.name] = {name = i.name, type = i.type, probability=  i.probability, amount = i.amount}
			else
				temp[i.name].amount = temp[i.name].amount + i.amount
			end
		end		
	end
	for name,value in pairs(temp) do
		table.insert(ret,value)
	end
	return ret
end


local local_get_item_ingredient_substitutions = function(names,ingredients)
	if type(names) == "string" then return local_substitue_ingredient_item(names,ingredients) end
	for k = 1, #names do local name = names[k]		
		if name ~= nil then ingredients = local_substitue_ingredient_item(name,ingredients) end
	end
	return local_get_item_ingredient_substitutions_merged(ingredients)
end

local local_check_icon_size = function(size,fallback)
	if size ~= nil then return size end
	if fallback ~= nil then return fallback end
	return 32
end


local local_get_technology = function(technology) return data.raw["technology"][technology] end

local local_patch_technology = function(technology, recipe)
	local tech = nil
	if type(technology) == "table" and technology.effects ~= nil then 
		tech = technology
	elseif type(technology) == "string" then
		tech = local_get_technology(technology)
	end
	if tech then
		for k = 1, #tech.effects do r = tech.effects[k]
			if r.recipe == recipe then return end
		end
        table.insert(tech.effects, {
			type="unlock-recipe",
			recipe=recipe
		})
	elseif type(technology) == "table" then
		--Not Implemented
	end
	end

local icon_pin_topleft = 0
local icon_pin_top = 1
local icon_pin_topright = 2
local icon_pin_right = 3
local icon_pin_bottomright = 4
local icon_pin_bottom = 5
local icon_pin_bottomleft = 6
local icon_pin_left = 7

local local_create_layered_icon_using = function(initial_icons)
	
	local bad_icon = {	
		{
				icon = "__mms2common__/graphics/icons/bad-icon.png",
				icon_mipmaps = 4,
				icon_size = 64,
				scale = 1.0,
				shift = {0,0}		
		}
	}

	local base_icon = {
		{
			icon = "__mms2common__/graphics/icons/blankicon.png",
			icon_mipmaps = 4,
			icon_size = 64,
			scale = 1.0,
			shift = {0,0}
		}
	}
	
	if initial_icons == nil or type(initial_icons) ~= "table" or #initial_icons == 0 then 
		return bad_icon 
	end
	local icons = {}
	for k = 1, #initial_icons do local icon = initial_icons[k]
		if icon ~= nil then
			if icon.from ~= nil then
				if (icon.from.icon == false or icon.from.icon == nil)  and icon.from.icons ~= nil then
					for j = 1, #icon.from.icons do 
						local new_icon_from = icon.from.icons[j]
						if icon.scale ~=nil then
							if new_icon_from.scale == nil then
								new_icon_from.scale = icon.scale
							else
								new_icon_from.scale = new_icon_from.scale * icon.scale
							end
						end
						table.insert(icons,new_icon_from)
					end				
				else
					table.insert(icons,{
						icon = icon.from.icon,
						icon_mipmaps = icon.from.icon_mipmaps,
						icon_size = icon.from.icon_size,
						scale = icon.scale,
						pin = icon.pin
					})
				end
			else
				table.insert(icons,icon)
			end
		end
	end

	for k = 1, #icons do local icon = icons[k]
		if icon ~= nil and next(icon) ~= nil then
			local current_icon = {}
			if icon.icon_size == nil then
				return bad_icon
			end
			current_icon.icon = icon.icon
			current_icon.icon_size = icon.icon_size
			current_icon.icon_mipmaps = icon.icon_mipmaps
			current_icon.tint = icon.tint
			current_icon.icon_scale = (icon.icon_size and icon.icon_size/64)
			if icon.scale == nil then	
				current_icon.scale = 1
			else
				current_icon.scale = icon.scale
			end 
			if icon.pin == icon_pin_topleft then
				current_icon.shift = {((64-(64*current_icon.scale))/2)*-1,((64-(64*current_icon.scale))/2)*-1}
			elseif icon.pin == icon_pin_top then
				current_icon.shift = {0,((64-(64*current_icon.scale))/2)*-1}
			elseif icon.pin == icon_pin_topright then
				current_icon.shift = {((64-(64*current_icon.scale))/2)*-1,((64-(64*current_icon.scale))/2)}
			elseif icon.pin == icon_pin_right then
				current_icon.shift = {((64-(64*current_icon.scale))/2),0}
			elseif icon.pin == icon_pin_bottomright then
				current_icon.shift = {((64-(64*current_icon.scale))/2),((64-(64*current_icon.scale))/2)}
			elseif icon.pin == icon_pin_bottom then
				current_icon.shift = {0,((64-(64*current_icon.scale))/2)}
			elseif icon.pin == icon_pin_bottomleft then
				current_icon.shift = {((64-(64*current_icon.scale))/2)*-1,((64-(64*current_icon.scale))/2)}
			elseif icon.pin == icon_pin_left then
				current_icon.shift = {((64-(64*current_icon.scale))/2)*-1,0}
			end			
			current_icon.scale = (current_icon.scale and current_icon.icon_scale and current_icon.scale * current_icon.icon_scale)
			
			table.insert(base_icon,current_icon)
		end
	end
	return base_icon
end

local local_ensure_ingredient_format = function(product)
	local type = nil
	local name = nil
	local amount = nil
	if product == nil then return nil end
	if product.type == nil then
		type = "item" 
	else 
		type = product.type
	end
	if product.name == nil then
		name = product[1] 
	else 
		name = product.name
	end
	if product.amount == nil then
		amount = product[2]
	else 
		amount = product.amount
	end
	if amount == nil then amount = 1 end
	if type ~= nil and name ~= nil then return {type=type, name=name, amount=amount} end
	return nil
end

local local_get_standard_results = function(recipe)
	if recipe == nil then return nil end
	local result_count = 1
	if recipe.results == nil then		
		if recipe.result ~= nil then
			result_count = recipe.result_count or 1
			if type(recipe.result) == "string" then
				return {{type = "item", name = recipe.result, amount = result_count}}
			elseif recipe.result.name then
				return {recipe.result}
			elseif recipe.result[1] then
				result_count = recipe.result[2] or result_count
				return {{type = "item", name = recipe.result[1], amount = result_count}}
			end	
		end
	end
	return recipe.results
end

local local_get_normal_results = function(recipe)
	if recipe == nil or recipe.normal == nil then return nil end
	if recipe.normal ~= false and recipe.normal.results ~= nil then return recipe.normal.results end		
	if recipe.normal ~= false and recipe.normal.result ~= nil and type(recipe.normal.result) == "string" then
		local result_count = 1	
		result_count = recipe.normal.result_count or 1
		return {{type = "item", name = recipe.normal.result, amount = result_count}}
	end
	if recipe.expensive ~= false and recipe.expensive.results ~= nil then return recipe.expensive.results end		
	if recipe.expensive ~= false and recipe.expensive.result ~= nil and type(recipe.expensive.result) == "string" then
		local result_count = 1	
		result_count = recipe.expensive.result_count or 1
		return {{type = "item", name = recipe.expensive.result, amount = result_count}}
	end
	return nil
end

local local_add_ingredient_to_recipe_type = function(recipe, item)
	local new_table = {}
	if recipe ~= nil then
		for i = 1, #recipe do		
			if recipe[i].name == item.name then 
				return recipe
			end
		end		
		for i = 1, #recipe do		
			table.insert(new_table,recipe[i])
		end		
		table.insert(new_table,item)
	end
	recipe = new_table
	return recipe
end

local local_add_ingredient_to_recipe = function(recipe, item)
	if data.raw.recipe[recipe] and type(item) == "table"  then
	if data.raw.recipe[recipe].expensive then
		data.raw.recipe[recipe].expensive.ingredients = local_add_ingredient_to_recipe_type(data.raw.recipe[recipe].expensive.ingredients,item)
	end
	if data.raw.recipe[recipe].normal then
		data.raw.recipe[recipe].normal.ingredients = local_add_ingredient_to_recipe_type(data.raw.recipe[recipe].normal.ingredients,item)     
	end
	if data.raw.recipe[recipe].ingredients then
		data.raw.recipe[recipe].ingredients = local_add_ingredient_to_recipe_type(data.raw.recipe[recipe].ingredients,item)
	end
	end
end

mms2.is_valid = local_is_valid
mms2.get_item = local_get_item

mms2.get_item_ingredient_substitutions = local_get_item_ingredient_substitutions
mms2.get_item_substitution = local_get_item_substitution

mms2.add_ingredient_to_recipe = local_add_ingredient_to_recipe

mms2.create_layered_icon_using = local_create_layered_icon_using

mms2.tech.get_technology = local_get_technology
mms2.tech.patch_technology = local_patch_technology

mms2.ensure_ingredient_format = local_ensure_ingredient_format
mms2.get_standard_results = local_get_standard_results
mms2.get_normal_results = local_get_normal_results