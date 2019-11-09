log("AAA solutions running Final Fixes")

aaa_zzz_mode = "AAA" 

local table_remove_key = function(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

local table_index_of = function(table,value)
	for k, v in pairs(table) do 
		if v == value then 
			return k 
		end
	end return nil 
end

local table_contains = function(table, value) return table_index_of(table,value) ~= nil end

local raw_items = {"enemy","fluid","item","accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","item-with-entity-data","lab","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}
local item_list = nil



local local_get_item = function(name)
	if name == nil then return nil end
	if item_list == nil then
		item_list = {}
		for r = 1, #raw_items do local raw = raw_items[r]	
			if data.raw[raw] ~= nil then
				for name,item in pairs(data.raw[raw]) do			
					if item ~= nil and item.name ~= nil then	
						if table_contains(item_list,item.name) then
							if item_list[item.name].icon_size == nil and item.icon_size ~= nil then
								item_list[item.name] = item
							end
						else
							item_list[item.name] = item
						end
					end
				end
			end
		end
	end
	local item = item_list[name]
	if item == nil then
		log(aaa_zzz_mode.." solutions item ".. name .. " not found")	
	end
	return item
end

-- could add option to select hardest or easiest by amount
local local_remove_nil_and_duplicate_product = function(products, recipe, id)
	local names = {}
	if products ~= nil then
		for i = #products, 1, -1 do		
			if products[i] == nil or products[i].name == nil then
				log(aaa_zzz_mode.." solutions found nil ".. id .. "in recipe "..recipe)	
				table.remove(products,i)
			elseif table_contains(names,products[i].name) then	
				log(aaa_zzz_mode.." solutions found duplicate ".. id .. " ".. products[i].name.." in recipe "..recipe)	
				table.remove(products,i)
			else
				table.insert(names,products[i].name)
			end
		end			
	end
	return products
end

local local_ensure_product_format = function(product,recipe, id)
	for i = #product, 1, -1 do	
		if product[i] == nil then
			--log(aaa_zzz_mode.." solutions found nil in ".. id .. "  in recipe "..recipe)	
			table.remove(product,i)
		else
			local type = nil
			local name = nil
			local amount = nil
			if product[i].type == nil then
				type = "item" 
			else 
				type = product[i].type
			end
			if product[i].name == nil then
				name = product[i][1] 
			else 
				name = product[i].name
			end
			if product[i].amount == nil then
				amount = product[i][2]
			else 
				amount = product[i].amount
			end
			if amount == nil then amount = 1 end
			if type == nil or name == nil then
				if product[i] ~= nil then
					local str = ""
					if type == nil then str = str .. " T," end
					if name == nil then str = str .. " N," end
					if amount == nil then str = str .. " A," end
					log(aaa_zzz_mode.." solutions malformed ".. id .." in "..recipe.. " "..str)	
					--log(serpent.block(product))
				end
				table.remove(product,i)
			else
				product[i] = {type=type, name=name, amount=amount}
			end
		end
	end
	return product
end

local local_fix_products = function(products,recipe, id)
	if products == nil then return nil end
	return local_remove_nil_and_duplicate_product(local_ensure_product_format(products,recipe,id),recipe,id)
end

local local_get_standard_ingredients = function(recipe)
	if recipe~=nil and recipe.ingredients ~= nil and type(recipe.ingredients) == "table" then return local_fix_products(recipe.ingredients,recipe.name,"ingredient") end
end

local local_get_normal_ingredients = function(recipe)	
	if recipe~=nil and recipe.normal ~= nil and type(recipe.normal) == "table" and recipe.normal.ingredients ~= nil then return local_fix_products(recipe.normal.ingredients,recipe.name,"ingredient") end
end
	
local local_get_expensive_ingredients = function(recipe)
	if recipe~=nil and recipe.expensive ~= nil and type(recipe.expensive) == "table" and recipe.expensive.ingredients ~= nil then return local_fix_products(recipe.expensive.ingredients,recipe.name,"ingredient") end
end

local local_get_standard_results = function(recipe)
	if recipe == nil then return nil end
	if recipe.results == nil then
		local result_count = 1
		if recipe.result ~= nil then
			result_count = recipe.result_count or 1
			if type(recipe.result) == "string" then
				recipe.results = {{type = "item", name = recipe.result, amount = result_count}}
			elseif recipe.result.name then
				recipe.results = {recipe.result}
			elseif recipe.result[1] then
				result_count = recipe.result[2] or result_count
				recipe.results = {{type = "item", name = recipe.result[1], amount = result_count}}
			end
			--recipe.result = nil			
		end
	end
	return local_fix_products(recipe.results,recipe.name,"results")
end

local local_get_normal_results = function(recipe)
	if recipe == nil then return nil end
	local result_count = 1		
	if recipe.normal ~= nil and type(recipe.normal) == "table" and recipe.normal.result ~= nil then
		result_count = recipe.normal.result_count or 1
		if type(recipe.normal.result) == "string" then
			recipe.normal.results = {{type = "item", name = recipe.normal.result, amount = result_count}}
		elseif recipe.normal.result.name then
			recipe.normal.results = {recipe.result}
		elseif recipe.normal.result[1] then
			result_count = recipe.normal.result[2] or result_count
			recipe.normal.results = {{type = "item", name = recipe.normal.result[1], amount = result_count}}
		end
		--recipe.normal.result = nil			
	end
	if recipe.normal == nil then return nil end
	return local_fix_products(recipe.normal.results,recipe.name,"results")
end

local local_get_expensive_results = function(recipe)
	if recipe == nil then return nil end
	local result_count = 1		
	if recipe.expensive ~= nil and type(recipe.expensive) == "table" and recipe.expensive.result ~= nil then
		result_count = recipe.expensive.result_count or 1
		if type(recipe.expensive.result) == "string" then
			recipe.expensive.results = {{type = "item", name = recipe.expensive.result, amount = result_count}}
		elseif recipe.expensive.result.name then
			recipe.expensive.results = {recipe.result}
		elseif recipe.expensive.result[1] then
			result_count = recipe.expensive.result[2] or result_count
			recipe.expensive.results = {{type = "item", name = recipe.expensive.result[1], amount = result_count}}
		end
		--recipe.expensive.result = nil			
	end
	if recipe.expensive == nil then return nil end
	return local_fix_products(recipe.expensive.results,recipe.name,"results")
end
local local_get_icon = function(proto,name)
	if proto == nil or name ==  nil then return nil end
	local icon = nil
	local icon_size = 32
	local icons = nil

	if proto.icon then
		icon = proto.icon
		icon_size = proto.icon_size
		icons = {{icon = icon, icon_size = icon_size}}
		return {icon=icon,icons=icons,icon_size=icon_size}
	elseif proto.icons then
		icons = proto.icons
		local require_sizes = true;
		if proto.icon_size then require_sizes = false end
		if require_sizes == true then
			local str = " ";
			icon_size = proto.icons[1].icon_size
			for x=1, #proto.icons do
				if not proto.icons[x].icon_size then
					str = str .. x ..","
				end
			end
			if str ~= " " then
				log(aaa_zzz_mode.." solutions found malformed icon "..name..str)
			end
			return {icon=icon,icons=icons,icon_size=icon_size}
		else
			icon_size=proto.icon_size
			icon = proto.icon
			icons = {{icon = false, icon_size = icon_size}}
			return {icon=icon,icons=icons,icon_size=icon_size}
		end
	end
	return nil
end

local ignore_icons_errors = {"area","night-vision-equipment","projectile","solar-panel-equipment","personal-roboport-equipment","roboport-equipment"}

local local_get_icon_for_recipe = function(recipe)
	-- body
	local name = recipe.name
	local result = local_get_icon(recipe,name)
	if result ~= nil then return result end
	result = local_get_icon(local_get_item(recipe.main_product),name)
	if result ~= nil then return result end
	result = local_get_icon(local_get_item(recipe.result),name)
	if result ~= nil then return result end
	if recipe.normal then
		if recipe.normal.result then			
			result = local_get_icon(recipe.normal.result,name)
			if result ~= nil then return result end
		elseif recipe.normal.results then
			local n = recipe.normal.results[1].name
			if n == nil then n = recipe.normal.results[1][1] end
			result = local_get_icon(n,name)
			if result ~= nil then return result end
		end
	end
	if recipe.expensive then
		if recipe.expensive.result then			
			result = local_get_icon(recipe.expensive.result,name)
			if result ~= nil then return result end
		elseif recipe.expensive.results then
			local n = recipe.normal.results[1].name
			if n == nil then n = recipe.normal.results[1][1] end
			result = local_get_icon(n,name)
			if result ~= nil then return result end
		end
	end

	if recipe.results then
		local n = recipe.results[1].name
		if n == nil then n = recipe.results[1][1] end
		result = local_get_icon(n,name)
		if result ~= nil then return result end
	end
	local i = local_get_item(recipe.name)
	if i ~= nil then 
		result = local_get_icon(i,name)
		if result ~= nil then return result end
	end	
	if i ~= nil and table_contains(ignore_icons_errors, i.type) ~= true then 
		log(aaa_zzz_mode.." solutions found malformed icon (FAIL)"..name)
		log(serpent.block(i))
	end
	return nil
end


--[[todo: Need to detect icon/icons this is becase after these chnages the need for an ICON for a recipie
may be induced wich is why we are required to add it.

an shoud be recipie.icon=>recipie.icons=>main_product.(icon|icons) ?? check wiki, may need to not malformed

]]
function AAA_ZZZ_check_recipies(isZ)
	if isZ then aaa_zzz_mode = "ZZZ" else aaa_zzz_mode = "AAA" end
	if settings.startup["aaasolutions-check-recipies"].value ~= "Enabled" then return end
	for name, recipe in pairs(data.raw.recipe) do
		if isZ == true then
			-- get copy of current icon
			local icon = local_get_icon_for_recipe(recipe)
			--revert to initial if we can
			if icon == nil and recipe.initial_icon ~= nil then util.table.deepcopy(recipe.initial_icon) end
			
			--get current altered recipies
			local standard_ingredients = local_get_standard_ingredients(recipe)
			local normal_ingredients = local_get_normal_ingredients(recipe)
			local expensive_ingredients = local_get_expensive_ingredients(recipe)

			--check and make deep copies
			if standard_ingredients ~= nil then standard_ingredients=util.table.deepcopy(standard_ingredients) end
			if normal_ingredients ~= nil then normal_ingredients=util.table.deepcopy(normal_ingredients) end
			if expensive_ingredients ~= nil then expensive_ingredients=util.table.deepcopy(expensive_ingredients) end

			--need to copy updated properties
			if recipe.initial ~= nil then
				recipe.initial.allow_as_intermediate = recipe.allow_as_intermediate
				recipe.initial.allow_decomposition = recipe.allow_decomposition
				recipe.initial.allow_intermediates = recipe.allow_intermediates	
				recipe.initial.always_show_made_in = recipe.always_show_made_in
				recipe.initial.always_show_products = recipe.always_show_products
				recipe.initial.category = recipe.category
				recipe.initial.crafting_machine_tint = recipe.crafting_machine_tint
				recipe.initial.emissions_multiplier = recipe.emissions_multiplier
				recipe.initial.enabled = recipe.enabled
				recipe.initial.energy_required = recipe.energy_required
				recipe.initial.hidden = recipe.hidden
				recipe.initial.hide_from_player_crafting = recipe.hide_from_player_crafting
				recipe.initial.hide_from_stats = recipe.hide_from_stats
				recipe.initial.main_product = recipe.main_product -- hmmmm
				recipe.initial.requester_paste_multiplier = recipe.requester_paste_multiplier
				recipe.initial.show_amount_in_title = recipe.show_amount_in_title				
				recipe.initial.subgroup = recipe.subgroup
				recipe.initial.localised_description = recipe.localised_description
				recipe.initial.localised_name = recipe.localised_name
				recipe.initial.order = recipe.order

				recipe = recipe.initial
			end
			if icon~=nil then 
				if #icon.icons == 1 then
					recipe.icon = icon.icon
					recipe.icon_size = icon.icon_size
					recipe.icons = nil
				else
					recipe.icon = false
					recipe.icon_size = icon.icon_size
					recipe.icons = icon.icons
				end
			end
			-- now we update the correct recipe changed since the initial aaa record
			if standard_ingredients ~= nil and recipe.ingredients ~= nil then
				recipe.ingredients = standard_ingredients
			end
			if normal_ingredients ~= nil and recipe.normal ~= nil then
				recipe.normal.ingredients = normal_ingredients
			end
			if expensive_ingredients ~= nil and recipe.expensive ~= nil then
				recipe.expensive.ingredients = expensive_ingredients
			end

		elseif isZ == false then
			recipe.initial = util.table.deepcopy(recipe) -- replicate for later use
			recipe.initial_icon = local_get_icon_for_recipe(recipe)
			local standard_ingredients = local_get_standard_ingredients(recipe)
			local normal_ingredients = local_get_normal_ingredients(recipe)
			local expensive_ingredients = local_get_expensive_ingredients(recipe)
			if standard_ingredients == nil then
				if normal_ingredients ~= nil then standard_ingredients = normal_ingredients
				elseif expensive_ingredients ~= nil then standard_ingredients = expensive_ingredients end
			end
			if normal_ingredients == nil then
				normal_ingredients = standard_ingredients
			end
			if expensive_ingredients == nil then
				expensive_ingredients = standard_ingredients
			end

			local standard_results = local_get_standard_results(recipe)
			local normal_results = local_get_normal_results(recipe)
			local expensive_results = local_get_expensive_results(recipe)

			if standard_results == nil then
				if normal_results ~= nil then standard_results = normal_results
				elseif expensive_results ~= nil then standard_results = expensive_results end
			end
			if normal_results == nil then
				normal_results = standard_results
			end
			if expensive_results == nil then
				expensive_results = standard_results
			end

			if standard_ingredients == nil or normal_ingredients == nil or expensive_ingredients == nil 
			or standard_results == nil or normal_results == nil or expensive_results == nil then 
			
				local str = ""
				if standard_ingredients == nil then str = str .." SI," end
				if normal_ingredients == nil then str = str .." NI," end
				if expensive_ingredients == nil then str = str .." EI," end
				if standard_results == nil then str = str .." SR," end
				if normal_results == nil then str = str .."  NR," end
				if expensive_results == nil then str = str .." ER," end
				log(aaa_zzz_mode.." solutions found malformed recipe "..recipe.name.." "..str)
			else
				recipe.ingredients = util.table.deepcopy(standard_ingredients)
				recipe.results = util.table.deepcopy(standard_results)
				if recipe.normal == nil then
					recipe.normal = 
					{
						ingredients = util.table.deepcopy(normal_ingredients),
						results = util.table.deepcopy(normal_results)
					}
				else
					recipe.normal.ingredients = util.table.deepcopy(normal_ingredients)
					recipe.normal.results = util.table.deepcopy(normal_results)
				end
				if recipe.expensive == nil then
					recipe.expensive = 
					{
						ingredients = util.table.deepcopy(expensive_ingredients),
						results = util.table.deepcopy(expensive_results)
					}
				else
					recipe.expensive.ingredients = util.table.deepcopy(expensive_ingredients)
					recipe.expensive.results = util.table.deepcopy(expensive_results)
				end
			end
		
		end
	end
end

local local_remove_nil_and_duplicate = function(data, name, id)
	local names = {}
	if data ~= nil then
		for i = #data, 1, -1 do		
			if data[i] == nil then
				log(aaa_zzz_mode.." solutions found nil ".. id .. "in tech "..name)	
				table.remove(data,i)
			elseif table_contains(names,data[i]) then	
				log(aaa_zzz_mode.." solutions found duplicate ".. id .. " ".. data[i].." in tech "..name)	
				table.remove(data,i)
			else
				table.insert(names,data[i])
			end
		end			
	end
	return data
end

function AAA_ZZZ_check_tech(isZ)
	if isZ then aaa_zzz_mode = "ZZZ" else aaa_zzz_mode = "AAA" end
	if settings.startup["aaasolutions-check-tech"].value ~= "Enabled" then return end
	for name, tech in pairs(data.raw.technology) do
		data.raw.technology[name].prerequisites = local_remove_nil_and_duplicate(tech.prerequisites, name,"prerequisite")
	end
end

AAA_ZZZ_check_recipies(false)
AAA_ZZZ_check_tech(false)
