require ("prototypes.scripts.defines")

local starts_with  = modmashsplinterfluid.util.starts_with
local get_item  = modmashsplinterfluid.util.get_item
local get_item_substitution  = modmashsplinterfluid.util.get_item_substitution
local get_name_for  = modmashsplinterfluid.util.get_name_for

local local_get_results_from_ingredients = function(r)
	local ingredients = {}		
	for k=1, #r do local i = r[k];	
		if i ~= nil then 
			local name = nil
			local amount = nil
			if i.type ~= nil then			
				amount = i.amount
				name = i.name
			else
				name = i[1]
				amount = i[2]			
			end
			if amount == nil then amount = 1 end
			if i.type ~= "fluid" then
				if name == nil then name = i.name end
				ingredients[#ingredients+1] = {
					name = name,
					probability = 1,
					amount = math.max(1, math.floor(amount * 0.8))
					}
			end
		end
	end
	if #ingredients ~= 0 then
		ingredients[#ingredients+1] = {type="fluid",name = get_item_substitution("sludge").name,amount = 25}
	end
	return ingredients
end

local local_create_recylce_item = function(r)
	local results = nil
	if r.normal ~= nil then 		
		results = r.normal.results
		if results == nil or #results == 0 then
			if r.normal.result_count ~= nil then
				results = {{name = r.normal.result, amount = math.max(r.normal.result_count,1)}}
			else
				results = {{name = r.normal.result, amount = 1}}
			end	
		else
			results = {{name = r.result, amount = 1}}	
		end
	else
		results = r.results;
		if results == nil or #results == 0 then
			if r.result_count ~= nil then
				results = {{name = r.result, amount = math.max(r.result_count,1)}}
			else
				results = {{name = r.result, amount = 1}}
			end
		else
			results = {{name = r.result, amount = 1}}
		end		
	end	
	if #results == 0 then
		results = {{name = r.result, amount = 1}}
	end
	if #results > 1 then
		return
	end

	local ingds = r.ingredients
	if ingds == nil then ingds = r.normal.ingredients end
	if ingds == nil then
		return 
	end 
	local item = get_item(results[1].name)	

	if item == nil or item.icon_size == nil then
		return
	end
	if item.stackable == false or item.name == "warptorio-armor" then
		return
	end
	if (item.icon == nil or item.icon == false) and item.icons == nil then return end
	if item.subgroup == "raw-resource" or (item.flags ~= nil and item.flags[1] == "hidden")  then 
		return
	end
	local recipe = nil

	----------------- Dexy Edit ---------------------
    resultAmout = 1;
    if(results[1].amount ~= nil) then
        resultAmout = results[1].amount
    end
    -------------------------------------------------
	local energy = r.energy_required
	if energy == nil then energy = 0.5 end
	if r.normal ~= nil and type(r.normal) == "table" and r.expensive ~= nil and type(r.expensive) == "table"  then		
		recipe =
		{
		type = "recipe",
		name = "craft-" .. results[1].name,
		localised_name = "craft-" .. results[1].name,
		localised_description = "craft-" .. results[1].name,
		category = "recycling",
		subgroup = "recyclable",		
		--hidden = true,	
		hide_from_player_crafting = true,
		icon_size = item.icon_size,
		energy_required = energy*2,
		normal = {
			enabled = "false",
			--hidden = true,
			hide_from_player_crafting = true,						
            -- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},-- {type="fluid",name = "steam",amount = 50}}, Dexy Edit
            ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},-- {type="fluid",name = "steam",amount = 50}},
            results = local_get_results_from_ingredients(r.normal.ingredients)
        },
        expensive =
        {
            enabled = "false",
			--hidden = true,
			hide_from_player_crafting = true,
            -- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},-- {type="fluid",name = "steam",amount = 50}}, Dexy Edit
            ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},-- {type="fluid",name = "steam",amount = 50}},
            results = local_get_results_from_ingredients(r.expensive.ingredients)
        }
		}
	elseif r.normal ~= nil and type(r.normal) == "table" then		
		recipe =
		{
		type = "recipe",
		name = "craft-" .. results[1].name,
		category = "recycling",
		subgroup = "recyclable",		
		--hidden = true,	    
		icon_size = item.icon_size,
		normal = {
			enabled = "false",
			--hidden = true,
			hide_from_player_crafting = true,
			energy_required = r.normal.energy_required,			
			            -- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},--, {type="fluid",name = "steam",amount = 50}}, --Dexy Edit
            ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},--, {type="fluid",name = "steam",amount = 50}},
			results = local_get_results_from_ingredients(r.normal.ingredients)
		}
		}
	elseif r.expensive ~= nil and type(r.expensive) == "table" then		
		recipe =
		{
		type = "recipe",
		name = "craft-" .. results[1].name,
		category = "recycling",
		subgroup = "recyclable",		
		hidden = true,	    
		icon_size = item.icon_size,
		expensive = {
			enabled = "false",
			--hidden = true,
			hide_from_player_crafting = true,
			energy_required = r.normal.energy_required,			
			            -- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},--, {type="fluid",name = "steam",amount = 50}}, --Dexy Edit
            ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},--, {type="fluid",name = "steam",amount = 50}},
			results = local_get_results_from_ingredients(r.expensive.ingredients)
		}
		}
	else
		local res = local_get_results_from_ingredients(r.ingredients)
		if #res<1 then 
			return 
		end
		recipe =
		{
		type = "recipe",
		name = "craft-" .. results[1].name,
		category = "recycling",
		subgroup = "recyclable",
		enabled = "false",
		--hidden = true,	    
		hide_from_player_crafting = true,		
		energy_required = r.energy_required,
		icon_size = item.icon_size,
		-- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},--{type="fluid",name = "steam",amount = 50}}, -- results --Dexy Edit
        ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},--{type="fluid",name = "steam",amount = 50}}, -- results
		results = res
		}  
		end
	-- modified fix Dexy Edit
	if item.icon ~= nil and item.icon ~= false then
		recipe.icon = item.icon
	else
		recipe.icon = false
        recipe.icons = item.icons
	end
	recipe.hide_from_stats = true
	recipe.hide_from_player_crafting = true
	recipe.allow_as_intermediate = false
	recipe.allow_intermediates = false
	recipe.hidden_from_char_screen = true
	recipe.localised_name = get_name_for(item,"Recyle Item ")
	recipe.localised_description = get_name_for(item,"Recyle Item ")
	--log("Creating recycle recipe "..recipe.name)
	--if item.subgroup ~= nil then recipe.subgroup = item.subgroup end  
	data:extend({recipe})
	table.insert(data.raw["technology"]["recycling-machine"].effects, {type = "unlock-recipe",recipe = "craft-" .. results[1].name})
end

local local_create_recycle_recipies = function(source)
	local recipies = {}
	for name, recipe in pairs(source) do
		recipies[#recipies+1] = recipe
	end
	for k=1, #recipies do local recipe = recipies[k];	
		
	    if recipe.hidden or recipe.hide_from_player_crafting 
			or starts_with(recipe.name,"creative-mod") 
			or starts_with(recipe.name,"deadlock-stack") then
		else
			local_create_recylce_item(recipe)
		end
	end			
end

if data ~= nil and data_final_fixes == true then
    local_create_recycle_recipies(data.raw.recipe)
end