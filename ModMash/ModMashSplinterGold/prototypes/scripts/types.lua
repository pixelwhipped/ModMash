﻿local ends_with = modmashsplintergold.util.ends_with
local starts_with = modmashsplintergold.util.starts_with
local get_item = modmashsplintergold.util.get_item
local get_name_for = modmashsplintergold.util.get_name_for
local ensure_ingredient_format = modmashsplintergold.util.ensure_ingredient_format
local get_standard_results = modmashsplintergold.util.get_standard_results
local get_normal_results = modmashsplintergold.util.get_normal_results
local create_layered_icon_using =	modmashsplintergold.util.create_layered_icon_using
local table_contains = modmashsplintergold.util.table.contains

local icon_pin_topleft = modmashsplintergold.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplintergold.util.defines.icon_pin_top
local icon_pin_topright = modmashsplintergold.util.defines.icon_pin_topright
local icon_pin_right = modmashsplintergold.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplintergold.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplintergold.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplintergold.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplintergold.util.defines.icon_pin_left

local local_update_tech = function(old_recipe,new_recipe)
		log("checking for "..old_recipe)
		for name, value in pairs(data.raw.technology) do			
			if value.effects ~= nil then				
				for k =1, #value.effects do
					if value.effects[k] ~= nil then
						if value.effects[k].type == "unlock-recipe" and value.effects[k].recipe == old_recipe then
							log("found "..name)
							table.insert(data.raw["technology"][name].effects,{type = "unlock-recipe",recipe = new_recipe})
							return
						end		
					end
				end
			end
		end
	end

local local_flatten_duplicates = function(ingredients)	
	if ingredients == nil then return nil end
	local map = {}
	local flat = {}
	for k = 1, #ingredients do local i=ingredients[k]
		if i ~= nil then
			if map[i.name] == nil then
				map[i.name] = {type=i.type, name=i.name, amount=i.amount}
			else 
				map[i.name].amount = map[i.name].amount+i.amount
			end
		end
	end
	for name, value in pairs(map) do	
		table.insert(flat,value)
	end
	return flat
end

local local_update_recipe = function(recipe)	
	if recipe == nil then return nil end
	if recipe.ingredients == nil then return nil end
	if #recipe.ingredients > 3 then return nil end
	local foundplate = false
	local foundcable = false
	if ends_with(recipe.name,"-with-blank-circuit") then return nil end
	for k = 1, #recipe.ingredients do
		local ingredient = ensure_ingredient_format(recipe.ingredients[k])
		if ingredient ~= nil then
			if ingredient.name == "copper-plate" then
				ingredient.name = "gold-plate"
				foundplate = true
			elseif ingredient.name == "copper-cable" then
				ingredient.name = "gold-cable"
				foundcable = true
			end
		end
		recipe.ingredients[k] = ingredient		
	end
	if foundcable == false and foundplate == false then return nil end
	return local_flatten_duplicates(recipe.ingredients)
end

local local_update_result = function(recipe)
	local name = nil
	
	if recipe.result ~= nil then
		name = recipe.result
		recipe.result_count = (recipe.result_count or 1)*2
		return recipe.result
	end
	if recipe.results ~= nil then
		for k=1, #recipe.results do
			local result = ensure_ingredient_format(recipe.results[k])
			if result ~= nil then
				if result.type == nil or result.type ~= "fluid" then
					result.amount = result.amount * 2
				end
			end
			recipe.results[k] = result
		end
		if name ~= nil then return name end 
		if #recipe.results > 0 then return recipe.results[1].name end
	end
	return nil
end

local local_gold_recipe = function(recipe)
	if recipe == nil then return nil end
	local name = nil
	local standard_ingredients = local_update_recipe(recipe)
	local normal_ingredients = local_update_recipe(recipe.normal)
	local expensive_ingredients = local_update_recipe(recipe.expensive)
	if standard_ingredients == nil and normal_ingredients == nil and expensive_ingredients == nil then return nil end
	if standard_ingredients ~= nil then 
		recipe.ingredients = standard_ingredients 
	end
	if normal_ingredients ~= nil then 
		recipe.normal.ingredients = normal_ingredients 
		name = local_update_result(recipe.normal)
	end
	if expensive_ingredients ~= nil then 
		recipe.expensive.ingredients = expensive_ingredients 
		if name == nil then
			name = local_update_result(recipe.expensive)
		else
			local_update_result(recipe.expensive)
		end
	end
	if name == nil then
		name = local_update_result(recipe)
	else
		local_update_result(recipe)
	end

	if name == nil then return nil end
	local item = get_item(name)
	if item == nil then return nil end
	if item.stackable == false or item.name == "warptorio-armor" or item.name == "copper-cable" then
		return nil
	end
	if item.subgroup == "raw-resource" then return nil end
	if item.stack_size == 1 then return nil end
	if item.flags ~= nil then
		for k=1, #item.flags do
			if item.flags[k] == "hidden" or item.flags[k] ==  "not-stackable" then return nil end
		end
	end

	local rname = recipe.name	 
	if item.icon_size ~= nil and (type(item.icon_size) ~= "number" or item.icon_size > 64) then return nil end
	if item.icons ~= nil then
		for k=1, #item.icons do
			if item.icons[k].icon_size ~= nil and (type(item.icons[k].icon_size) ~= "number" or item.icons[k].icon_size > 64)  then return nil end
		end
	end
	recipe.localised_name = item.localised_name
	recipe.localised_description = item.localised_description
	recipe.name = recipe.name.."-with-gold"
	recipe.icon = false
	recipe.icons = create_layered_icon_using(
	{
		{
			from = item,
		},
		{
	
			from = data.raw["item"]["gold-ore"],
			scale = 0.45,
			pin = icon_pin_bottomright		
		}
	})
	recipe.allow_as_intermediate = false
    recipe.allow_decomposition = false	
	return recipe
end

local local_create_gold_recipies = function()
	local recipies = {}
	for name, recipe in pairs(data.raw.recipe) do
		recipies[#recipies+1] = table.deepcopy(recipe)
	end
	for k=1, #recipies do local recipe = recipies[k];			
	    if recipe.hidden or recipe.hide_from_player_crafting 
			or starts_with(recipe.name,"creative-mod") 
			or starts_with(recipe.name,"deadlock-stack") then
			-- do nothing
		else
			local name = recipe.name
			local new_recipe = local_gold_recipe(recipe)
			if new_recipe ~= nil then
				data:extend({new_recipe}) 
				--log(serpent.block(new_recipe))
				local_update_tech(name,new_recipe.name)
			end
		end
	end	
end

local local_add_module_limits = function()
	for name, module in pairs(data.raw["module"]) do
		if module ~= nil and module.limitation ~= nil then
			if table_contains(module.limitation,"gold-ore") == false then table.insert(module.limitation,"gold-ore") end
			--if table_contains(module.limitation,"gold-plate") == false then table.insert(module.limitation,"gold-plate") end
			--if table_contains(module.limitation,"gold-cable") == false then table.insert(module.limitation,"gold-cable") end 
		end
	end
end

if data ~= nil and data_final_fixes == true then
	local_create_gold_recipies()
	local_add_module_limits()
end