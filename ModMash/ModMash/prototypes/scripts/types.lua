if not modmash or not modmash.util then require("prototypes.scripts.util") end

local starts_with  = modmash.util.starts_with
local ends_with  = modmash.util.ends_with

local biome_types = nil
local non_pollutant = nil

log("Creating Types")

local local_set_types_biome = function() 
  biome_types = {
    {name = "basic", factor = 1},
    {name = "water", factor = 1.5},
    {name = "desert", factor = 0.5},
    {name = "sand", factor = 0.5},
    {name = "snow", factor = 0.75},
    {name = "ice", factor = 0.75},
    {name = "volcanic", factor = 0.25}
  } 
  modmash.util.types.biome_types = biome_types
end
 
local local_set_types_non_pollutant = function ()
  non_pollutant = {
    { name= "water", polutant = true},
    { name= "fish-oil", polutant = true},
    { name= "steam", polutant = true}
  } 
  modmash.util.types.non_pollutant = non_pollutant
end
 
local local_is_polutant = function(surface)
  for _, v in ipairs(non_pollutant) do  
    if v.name == surface then return not v.polutant end
  end
  return true 
end 

local local_create_biome_recipies = function()
	local create_recipe_for_biome = function(name, factor)
		local smooth = 25
		log("Creating Biome Recipe: wind-trap-action-" .. name)
		return {
			type = "recipe",        
			name = "wind-trap-action-" .. name,
			energy_required = 1/smooth,
			enabled = true,
			category = "wind-trap",
			ingredients = {},
			results = {
				{type = "fluid", name = "water", amount = math.floor(100/smooth*factor+0.5)},			
			},
			hidden = true
		}
    end  
	for _,biome in pairs(biome_types) do
		data:extend({create_recipe_for_biome(biome.name, biome.factor)})
	end 
end
--stored in multiple names accumulator ammo etc
local raw_items = {"accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}
local item_list = nil

local local_get_item = function(name)
	if item_list == nil then
		item_list = {}
		for r = 1, #raw_items do local raw = raw_items[r]	
			for name,item in pairs(data.raw[raw]) do			
				if item ~= nil and item.name ~= nil then				
					item_list[item.name] = item
				end
			end
		end
	end
	return item_list[name]
end

local local_create_super_material_conversions = function()
	for name,item in pairs(data.raw["resource"]) do			
		
		if item ~= nil and item.name ~= nil and item.icon ~= false and starts_with(item.name,"creative-mod") == false and data.raw["fluid"][item.name] == nil and data.raw["item"][item.name] ~= nil then					
			local m = data.raw["item"][item.name].stack_size
			if m == nil then m = 50 end
			local recipe = {
				type = "recipe",
				name = "modmash-supermaterial-to-"..item.name,
				localised_name = "Super Material to " .. item.name:gsub("-", ""),
				localised_description = "Super Material to " .. item.name:gsub("-", ""),
				category = "crafting-with-fluid",
				
				icon = false,
				icons =
				{
				  {
					icon = "__modmash__/graphics/icons/super-material.png",
				  },
				  {
					icon = item.icon,
					scale = 0.5,
					shift = {7, 8 }
				  }
				},
				icon_size = 32,
				subgroup = "intermediate-product",
				order = "zzz[super-material]["..item.name.."]",
				main_product = "",

				ingredients = {{name = "super-material",amount = 4}},
				energy_required = 1.5,
				enabled = false,				
				results =
				{			
					{
					name = item.name,
					amount = m,
					}			
				},
				allow_decomposition = false}

			local tech = {
				type = "technology",
				name = recipe.name .. "-tech",
				localised_name = recipe.localised_name,
				localised_description = recipe.localised_description,
				icon = "__base__/graphics/technology/fluid-handling.png",
				icon_size = 128,
				effects =
				{
				  {
					type = "unlock-recipe",
					recipe = recipe.name
				  }
				},
				prerequisites =
				{
				  "fluid-handling-3"
				},
				unit =
				{
				  count = 200,
				  ingredients =
				  {
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
					{"production-science-pack", 1}
				  },
				  time = 60
				},
				upgrade = true,
				order = "a-b-d",
			  }
			data:extend({recipe,tech})
		end
	end
end

local local_create_fluid_item = function(name, fluid)
  log("Discharge and valve Fluid: dump-" .. fluid.name)
  local discharge_recipe =
  {
    type = "recipe",
    name = "dump-" .. fluid.name,
	localised_name = "Discharge " .. fluid.name,
	localised_description = "Discharge " .. fluid.name,
    category = "discharge-fluids",
    energy_required = fluid.energy_required,    
	hide_from_player_crafting = true,
	hidden = true,
    order = fluid.order,
    enabled = true,
    icon = fluid.icon,	
    icon_size = 32,
	hide_from_stats = true,
    ingredients = {{type = "fluid", name = fluid.name, amount = 10000}},
    results = 
    {
      {type = "fluid", name = fluid.name, amount = 0}
    },
  }
  local valve_recipe =
  {
    type = "recipe",
    name = "valve-" .. fluid.name,
	localised_name = "Valve fluid " .. fluid.name,
	localised_description = "Valve fluid " .. fluid.name,
    category = "discharge-fluids",
	--subgroup = "recyclable",
    energy_required = fluid.energy_required,    
	hide_from_player_crafting = true,
	hidden = false,
    order = fluid.order,
    enabled = true,
    icon = fluid.icon,	
    icon_size = 32,
	hide_from_stats = true,
    ingredients = {{type = "fluid", name = fluid.name, amount = 100}},
    results = 
    {
      {type = "fluid", name = fluid.name, amount = 100}
    },
  }
  data:extend({discharge_recipe,valve_recipe})
end

local local_create_fluid_recipies = function()
	local fluids = data.raw["fluid"] 
	for name,fluid in pairs(fluids) do
		local_create_fluid_item(fluid_name, fluid)
	end 

	local mini_boiler_recipe =
	{
		type = "recipe",
		name = "valve-water-steam",
		localised_name = "Valve fluid Water To Steam",
		localised_description = "Valve fluid Water To Steam",
		category = "discharge-fluids",--recycling",
		--subgroup = "recyclable",
		energy_required = 1.5,    
		hide_from_player_crafting = true,
		hidden = false,
		order = "z[valve-water-steam]",
		enabled = true,
		icon = "__base__/graphics/icons/fluid/steam.png",	
		icon_size = 32,
		hide_from_stats = true,
		ingredients = {{type = "fluid", name = "water", amount = 100}},
		results = 
		{
			{type = "fluid", name = "steam", amount = 100}
		}
	}

	local mini_condenser_recipe =
	{
		type = "recipe",
		name = "valve-steam-water",
		localised_name = "Valve fluid Steam To Water",
		localised_description = "Valve fluid Steam To Water",
		category = "discharge-fluids",---"recycling",
		--subgroup = "recyclable",
		energy_required = 1.5,    
		hide_from_player_crafting = true,
		hidden = false,
		order = "z[valve-steam-water]",
		enabled = true,
		icon = "__base__/graphics/icons/fluid/water.png",	
		icon_size = 32,
		hide_from_stats = true,
		ingredients = {{type = "fluid", name = "steam", amount = 100}},
		results = 
		{
			{type = "fluid", name = "water", amount = 100}
		}
	}
	data:extend({mini_boiler_recipe,mini_condenser_recipe})
end

local local_get_results_from_ingredients = function(r)
	local ingredients = {}		
	for k=1, #r do local i = r[k];	
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
	ingredients[#ingredients+1] = {type="fluid",name = "sludge",amount = 25}
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

	local item = local_get_item(results[1].name)	

	if item == nil then
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

	if r.normal ~= nil and r.expensive ~= nil then		
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
		normal = {
			enabled = "false",
			hidden = true,
			hide_from_player_crafting = true,
			energy_required = r.normal.energy_required,			
            -- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},-- {type="fluid",name = "steam",amount = 50}}, Dexy Edit
            ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},-- {type="fluid",name = "steam",amount = 50}},
            results = local_get_results_from_ingredients(r.normal.ingredients)
        },
        expensive =
        {
            enabled = "false",
			--hidden = true,
			hide_from_player_crafting = true,
            energy_required = r.expensive.energy_required,          
            -- ingredients = {{name = results[1].name, amount = math.max(results[1].amount,1)}},-- {type="fluid",name = "steam",amount = 50}}, Dexy Edit
            ingredients = {{name = results[1].name, amount = math.max(resultAmout,1)}},-- {type="fluid",name = "steam",amount = 50}},
            results = local_get_results_from_ingredients(r.expensive.ingredients)
        }
		}
	elseif r.normal ~= nil then		
		recipe =
		{
		type = "recipe",
		name = "craft-" .. results[1].name,
		category = "recycling",
		subgroup = "recyclable",		
		hidden = true,	    
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
	recipe.localised_name = "Recyle Item"
	recipe.localised_description = "Recyle Item"
	log("Creating recycle recipe "..recipe.name)
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
	    if recipe.hidden or recipe.hide_from_player_crafting or starts_with(recipe.name,"creative-mod") then
			log("Skipping recyling " .. recipe.name)
		else
			local_create_recylce_item(recipe)
		end
	end			
end

local local_update_recipies = function()
	data.raw.recipe["red-wire"].ingredients =
		{      
		  {"copper-cable", 1}
		}

	data.raw.recipe["green-wire"].ingredients =
		{      
		  {"copper-cable", 1}
		}

	data.raw.recipe["electronic-circuit"].normal.ingredients =
		{      
		  {"green-wire", 1},
		  {"blank-circuit", 1}
		}
	data.raw.recipe["electronic-circuit"].expensive.ingredients =
		{      
		  {"green-wire", 2},
		  {"blank-circuit", 2}
		}	

	data.raw.recipe["advanced-circuit"].normal.ingredients =
		{      
		  {"blank-circuit", 1},
		  {"electronic-circuit", 1},
		  {"plastic-bar", 1},
		  {"red-wire", 1},
		}	
	data.raw.recipe["advanced-circuit"].expensive.ingredients =
		{      
		  {"blank-circuit", 2},
		  {"electronic-circuit", 1},
		  {"plastic-bar", 2},
		  {"red-wire", 2},
		}

	if data.raw.recipe["processing-unit"].category == "crafting-with-fluid" then
	data.raw.recipe["processing-unit"].normal.ingredients =
		{      
		  {"blank-circuit", 5},
		  {"red-wire", 1},
		  {"green-wire", 1},
		  {"copper-cable", 1},
		  {type = "fluid", name = "sulfuric-acid", amount = 5}
		}	
	data.raw.recipe["processing-unit"].expensive.ingredients =
		{      
		  {"blank-circuit", 5},
		  {"red-wire", 2},
		  {"green-wire", 2},
		  {"copper-cable", 2},
		  {type = "fluid", name = "sulfuric-acid", amount = 10}
		}
	else
	data.raw.recipe["processing-unit"].normal.ingredients =
		{      
		  {"blank-circuit", 5},
		  {"red-wire", 1},
		  {"green-wire", 1},
		  {"copper-cable", 1},
		--  {type = "fluid", name = "sulfuric-acid", amount = 5}
		}	
	data.raw.recipe["processing-unit"].expensive.ingredients =
		{      
		  {"blank-circuit", 5},
		  {"red-wire", 2},
		  {"green-wire", 2},
		  {"copper-cable", 2},
		--  {type = "fluid", name = "sulfuric-acid", amount = 10}
		}
	end
	local remove_recipie_from = function(tble,value)
		local new_table = {}
		if tble ~= nil then
			for i = 1, #tble do		
				if tble[i].recipe ~= value then 
					table.insert(new_table,tble[i])
				end
			end			
		end
		tble = new_table
		return tble
	end

	local remove_ingredient_from_recipie_type = function(recipe, name)
		local new_table = {}
		
		if recipe ~= nil then
			for i = 1, #recipe do		
				if recipe[i][1] ~= name then 
					table.insert(new_table,recipe[i])
				end
			end		
		end
		recipe = new_table
		return recipe
	end

	local remove_ingredient_from_recipie = function(recipe, name)
	  if recipe == nil then
		log("nil recipe")
		return
	  end
	  if name == nil then
		log("nil recipe name")
		return
	  end
	  if data.raw.recipe[recipe]  then		
		if data.raw.recipe[recipe].expensive then
		  log(recipe.." found expensive recipe")
		  data.raw.recipe[recipe].expensive.ingredients = remove_ingredient_from_recipie_type(data.raw.recipe[recipe].expensive.ingredients,name)
		end
		if data.raw.recipe[recipe].normal then
			log(recipe.." found normal recipe")
			data.raw.recipe[recipe].normal.ingredients = remove_ingredient_from_recipie_type(data.raw.recipe[recipe].normal.ingredients,name)     
		end
		if data.raw.recipe[recipe].ingredients then
		  log(recipe.." found standard recipe")
		  data.raw.recipe[recipe].ingredients = remove_ingredient_from_recipie_type(data.raw.recipe[recipe].ingredients,name)
		end
	  else
		log(recipe.." not found")
	  end
	end

	local add_ingredient_to_recipe_type = function(recipe, item)
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

	local add_ingredient_to_recipe = function(recipe, item)
	  if data.raw.recipe[recipe] and type(item) == "table"  then
		if data.raw.recipe[recipe].expensive then
		  data.raw.recipe[recipe].expensive.ingredients = add_ingredient_to_recipe_type(data.raw.recipe[recipe].expensive.ingredients,item)
		end
		if data.raw.recipe[recipe].normal then
			data.raw.recipe[recipe].normal.ingredients = add_ingredient_to_recipe_type(data.raw.recipe[recipe].normal.ingredients,item)     
		end
		if data.raw.recipe[recipe].ingredients then
		  data.raw.recipe[recipe].ingredients = add_ingredient_to_recipe_type(data.raw.recipe[recipe].ingredients,item)
		end
	  end
	end

	data.raw["technology"]["circuit-network"].effects = remove_recipie_from(data.raw["technology"]["circuit-network"].effects,"red-wire")
	data.raw["technology"]["circuit-network"].effects = remove_recipie_from(data.raw["technology"]["circuit-network"].effects,"green-wire")
	data.raw.recipe["red-wire"].enabled = true	
	data.raw.recipe["green-wire"].enabled = true	
	add_ingredient_to_recipe("small-lamp",{name = "glass", amount = 1})
	add_ingredient_to_recipe("pipe",{name = "glass", amount = 1})

	add_ingredient_to_recipe("storage-tank",{name = "glass", amount = 1})
	add_ingredient_to_recipe("rail-chain-signal",{name = "glass", amount = 1})
	add_ingredient_to_recipe("rail-signal",{name = "glass", amount = 1})
	add_ingredient_to_recipe("fluid-wagon",{name = "glass", amount = 1})
	add_ingredient_to_recipe("oil-refinery",{name = "glass", amount = 4})
	add_ingredient_to_recipe("chemical-plant",{name = "glass", amount = 2})
	add_ingredient_to_recipe("lab",{name = "glass", amount = 2})
	add_ingredient_to_recipe("solar-panel",{name = "glass", amount = 1})
	add_ingredient_to_recipe("nuclear-reactor",{name = "glass", amount = 10})
	add_ingredient_to_recipe("nuclear-fuel",{name = "glass", amount = 1})
	add_ingredient_to_recipe("rocket-fuel",{name = "glass", amount = 1})	
	add_ingredient_to_recipe("pump",{name = "glass", amount = 1})	

	
	add_ingredient_to_recipe("construction-robot",{name = "droid", amount = 1})	
	add_ingredient_to_recipe("logistic-robot",{name = "droid", amount = 1})	
	remove_ingredient_from_recipie("construction-robot","electronic-circuit")
	remove_ingredient_from_recipie("logistic-robot","advanced-circuit")

	add_ingredient_to_recipe("inserter",{name = "burner-inserter", amount = 1})	
	remove_ingredient_from_recipie("inserter","iron-gear-wheel")
	remove_ingredient_from_recipie("inserter","iron-plate")

	for name, recipe in pairs(data.raw.recipe) do
		if recipe ~= nil and recipe.name ~= nil and ends_with(recipe.name,"science-pack") then
			add_ingredient_to_recipe(recipe.name,{name = "glass", amount = 1})	
		end
	end
end

if not modmash.util.types then   
    modmash.util.types = {}
    modmash.util.types.is_polutant = local_is_polutant
    --modmash.util.types.set_types_biome = local_set_types_biome
    --modmash.util.types.set_types_non_pollutant = local_set_types_non_pollutant
    local_set_types_biome()
    local_set_types_non_pollutant() 
end


if data ~= nil and data_final_fixes == true then
    local_set_types_biome() --Dexy Edit
    local_set_types_non_pollutant() --Dexy Edit
    local_create_biome_recipies()
    local_create_fluid_recipies()
    local_update_recipies()	
    local_create_recycle_recipies(data.raw.recipe)
	local_create_super_material_conversions()
end