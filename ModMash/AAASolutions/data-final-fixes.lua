log("AAA solutions running Final Fixes")

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


-- could add option to select hardest or easiest by amount
local local_remove_nil_and_duplicate_product = function(products, recipe, id)
	local names = {}
	if products ~= nil then
		for i = #products, 1, -1 do		
			if products[i] == nil or products[i].name == nil then
				log("Z solutions found nil ".. id .. "in recipe "..recipe)	
				table.remove(products,i)
			elseif table_contains(names,products[i].name) then	
				log("Z solutions found duplicate ".. id .. " ".. products[i].name.." in recipe "..recipe)	
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
				log("AAA solutions malformed ".. id .." in "..recipe.. " "..str)	
				--log(serpent.block(product))
			end
			table.remove(product,i)
		else
			product[i] = {type=type, name=name, amount=amount}
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

--[[todo: Need to detect icon/icons this is becase after these chnages the need for an ICON for a recipie
may be induced wich is why we are required to add it.

an shoud be recipie.icon=>recipie.icons=>main_product.(icon|icons) ?? check wiki, may need to not malformed

]]
function AAA_ZZZ_check_recipies(isZ)
	if settings.startup["aaasolutions-check-recipies"].value ~= "Enabled" then return end
	for name, recipe in pairs(data.raw.recipe) do
		if isZ == true then --revert less the nil and duplicates
			recipe = recipe.initial
			local standard_ingredients = local_get_standard_ingredients(recipe)
			local normal_ingredients = local_get_normal_ingredients(recipe)
			local expensive_ingredients = local_get_expensive_ingredients(recipe)
			if standard_ingredients ~= nil then
				recipe.ingredients = standard_ingredients
			end
			if normal_ingredients ~= nil then
				recipe.normal.ingredients = normal_ingredients
			end
			if expensive_ingredients ~= nil then
				recipe.expensive.ingredients = expensive_ingredients
			end

		else
			recipe.initial = util.table.deepcopy(recipe)
			local standard_ingredients = local_get_standard_ingredients(recipe)
			local normal_ingredients = local_get_normal_ingredients(recipe)
			local expensive_ingredients = local_get_expensive_ingredients(recipe)
			if standard_ingredients == nil then
				if normal_ingredients ~= nil then standard_ingredients = normal_ingredients
				elseif expensive_ingredients ~= nil then standard_ingredients = expensive_ingredients end
			elseif isZ == false then
				recipe.added_from_standard = true
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
				log("AAA solutions found malformed recipe "..recipe.name.." "..str)
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
				log("AAA solutions found nil ".. id .. "in tech "..name)	
				table.remove(data,i)
			elseif table_contains(names,data[i]) then	
				log("AAA solutions found duplicate ".. id .. " ".. data[i].." in tech "..name)	
				table.remove(data,i)
			else
				table.insert(names,data[i])
			end
		end			
	end
	return data
end

function AAA_ZZZ_check_tech()
	if settings.startup["aaasolutions-check-tech"].value ~= "Enabled" then return end
	for name, tech in pairs(data.raw.technology) do
		data.raw.technology[name].prerequisites = local_remove_nil_and_duplicate(tech.prerequisites, name,"prerequisite")
	end
end

AAA_ZZZ_check_recipies(false)
AAA_ZZZ_check_tech()
