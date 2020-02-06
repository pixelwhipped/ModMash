if not modmash or not modmash.util then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

local super_container_stack_size = modmash.defines.defaults.super_container_stack_size


local starts_with  = modmash.util.starts_with
local ends_with  = modmash.util.ends_with
local ends_with  = modmash.util.ends_with
local get_name_for = modmash.util.get_name_for
local table_contains = modmash.util.table.contains
local create_icon = modmash.util.create_icon
local convert_to_string = modmash.util.convert_to_string

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
local raw_items = {"item","accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}
local item_list = nil

local local_get_item = function(name)
	if item_list == nil then
		item_list = {}
		for r = 1, #raw_items do local raw = raw_items[r]
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
	return item_list[name]
end

local exclude_containers = {"player-port","spawner","spitter-spawner","electric-energy-interface"}
local containers = {}

local local_create_container = function(item,x)
	local base_contain_icons = {
		{
			icon = "__modmash__/graphics/icons/super-container.png",
			icon_size = 32
		}}
	local base_tech_icons = {
		{
			icon = "__modmash__/graphics/technology/super-material.png",
			icon_size = 128,
			scale = 0.5,
			shift = {-48,-48}
		},{
			icon = "__modmash__/graphics/icons/super-container.png",
			icon_size = 32,
			scale = 0.5,
			shift = {-24,12}
		}}
	
	local base_uncontain_icons = nil
	if item.icon == nil or item.icon == false then
		base_uncontain_icons = item.icons
		if not base_uncontain_icons then
			log("all icon data seems missing for item: " .. item.name)
			log(serpent.block(item))
        end
	else
		base_uncontain_icons = {
			{
				icon=item.icon,
				icon_size = item.icon_size
			}}		
	end

--    local icon_size = item.icon_size or item.icons[1].icon_size or 32 -- OR definitions, try 32 if someone did the wrong thing

	local contain_icons = create_icon(base_contain_icons,item.icon,item.icon_size,item.icons,0.5,{0,2})		
	local tech_icons = create_icon(base_tech_icons,item.icon,item.icon_size,item.icons,0.5,{24,24})	
	local uncontain_icons = create_icon(base_uncontain_icons,"__modmash__/graphics/icons/super-container.png",32,nil,0.5,{5,5})	

	local container = {
		type = "item",
		name = "super-container-for-"..item.name,
		localised_name = get_name_for(item,"Super Container to "),
		localised_description = get_name_for(item,"Super Container to "),
		icon = false,
		icons = contain_icons,
		icon_size = 32,
		hide_from_player_crafting = true,
		subgroup = "intermediate-product",
		order = "zz[super-container-for-".. item.name .."]",
		stack_size = super_container_stack_size}
	local contain = {
		type = "recipe",
		name = "super-container-for-"..item.name,
		localised_name = get_name_for(item,"Super Container for "),
		localised_description = get_name_for(item,"Super Container for "),
		icon = false,
		icons = contain_icons,
		icon_size = 32,
		enabled = false,
		energy = 2,
		category = "containment",
		subgroup = "containers",
		hide_from_player_crafting = true,
		ingredients =
		{
			{"empty-super-container", 1},
			{item.name, item.stack_size}
		},
		result = "super-container-for-"..item.name}
	local uncontain = {	
		type = "recipe",
		name = "empty-super-container-of-"..item.name,
		localised_name = get_name_for(item,"Empty Super Container of "), -- "Empty Super Container of "..clean_name,
		localised_description = get_name_for(item,"Empty Super Container of "), --"Empty Super Container of "..clean_name,
		icon = false,
		icons = uncontain_icons,
		icon_size = 32,
		enabled = false,
		energy = 2,
		category = "containment",
		subgroup = "containers",
		hide_from_player_crafting = true,
		ingredients =
		{
			{name = "super-container-for-"..item.name,amount = 1}
		},
		results = {
			{name = "empty-super-container", amount = 1},
			{name = item.name, amount = item.stack_size}
		}}	
	local tech = {
		type = "technology",
		name = "super-containment-"..x,
		localised_name = get_name_for(item,"Super Containment of "), --"Super Containment of "..clean_name,
		localised_description = get_name_for(item,"Super Containment of "),
		icon_size = 128,
		icon = false,
		icons = tech_icons,
		prerequisites = {"super-containers"},
		effects =
		{
			{
			type = "unlock-recipe",
			recipe = contain.name
			},
			{
			type = "unlock-recipe",
			recipe = uncontain.name
			},
		},
		unit =
		{
			count = 75,	  
			ingredients = {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1}
			},
			time = 30
		},
		order = "d-a-a"}
	table.insert(containers,container.name)
	data:extend({container,contain,uncontain,tech})
end

local local_create_subspace_transport = function()
	local animation = 
	{
		layers =
		{
			{
				filename = "__modmash__/graphics/entity/subspace-transport/lab.png",
				width = 98,
				height = 87,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 1.5),
				hr_version =
				{
					filename = "__modmash__/graphics/entity/subspace-transport/hr-lab.png",
					width = 194,
					height = 174,
					frame_count = 33,
					line_length = 11,
					animation_speed = 1 / 3,
					shift = util.by_pixel(0, 1.5),
					scale = 0.5
				}
			},
			{
				filename = "__base__/graphics/entity/lab/lab-integration.png",
				width = 122,
				height = 81,
				frame_count = 1,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 15.5),
				hr_version =
				{
					filename = "__base__/graphics/entity/lab/hr-lab-integration.png",
					width = 242,
					height = 162,
					frame_count = 1,
					line_length = 1,
					repeat_count = 33,
					animation_speed = 1 / 3,
					shift = util.by_pixel(0, 15.5),
					scale = 0.5
				}
			},
			{
				filename = "__base__/graphics/entity/lab/lab-shadow.png",
				width = 122,
				height = 68,
				frame_count = 1,
				line_length = 1,
				repeat_count = 33,
				animation_speed = 1 / 3,
				shift = util.by_pixel(13, 11),
				draw_as_shadow = true,
				hr_version =
				{
					filename = "__base__/graphics/entity/lab/hr-lab-shadow.png",
					width = 242,
					height = 136,
					frame_count = 1,
					line_length = 1,
					repeat_count = 33,
					animation_speed = 1 / 3,
					shift = util.by_pixel(13, 11),
					scale = 0.5,
					draw_as_shadow = true
				}
			}
		}
	}
	data:extend({
		{
			type = "item",
			name = "subspace-transport",
			icon = "__modmash__/graphics/icons/lab.png",
			icon_size = 32,
			subgroup = "production-machine",
			order = "g[subspace-lab]",
			place_result = "subspace-transport",
			stack_size = 10
		},
		{
			type = "recipe",
			name = "subspace-transport",	
			enabled = "false",
			ingredients =
			{
			  {"assembling-machine-4", 1},
			  {"processing-unit", 10},
			  {"advanced-circuit", 10},
			  {"titanium-plate",10},
			  {"alien-plate",10},
			  {"concrete",50},
			  {"super-material", 20}
			},
			result = "subspace-transport"
		},
		{
			type = "technology",
			name = "subspace-transport",
			icon_size = 128,
			icon = "__modmash__/graphics/technology/subspace-transport.png",
			prerequisites = {"fluid-handling-3","automation-4"},
			effects =
			{
			  {
				type = "unlock-recipe",
				recipe = "subspace-transport"
			  },
			},
			unit =
			{
			  count = 400,	  
			  ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
				{"production-science-pack", 1}
			  },
			  time = 60,
			},
			order = "d-a-a"
		},
		{
			type = "lab",
			name = "subspace-transport",
			icon = "__modmash__/graphics/icons/lab.png",
			icon_size = 32,
			flags = {"placeable-player", "player-creation"},
			minable = {mining_time = 0.2, result = "subspace-transport"},
			max_health = 150,
			corpse = "big-remnants",
			dying_explosion = "medium-explosion",
			collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
			selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
			on_animation = animation,
			off_animation = animation,
			working_sound =
			{
			  sound =
			  {
				filename = "__base__/sound/lab.ogg",
				volume = 0.7
			  },
			  apparent_volume = 1
			},
			vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
			energy_source =
			{
			  type = "burner",
			  fuel_category = "advanced-alien",
			  effectivity = 1,
			  fuel_inventory_size = 2,
			},
			light = {intensity = 0.6, size = 8, shift = {0.0, 0.0}, color = {r = 1.0, g = 0.0, b = 1.0}},
			energy_usage = "200MW",
			researching_speed = 1,
			inputs = containers
		}
	})
end

-- need to add check for stacking inception
local local_create_super_containers = function()
	local base_container = {
		type = "item",
		name = "empty-super-container",
		localised_name = "Super Container",
		localised_description = "Super Material",
		icon = false,
		icons = {{icon = "__modmash__/graphics/icons/super-container.png"}},
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "zz[super-container]",
		stack_size = 10}
	local base_recipe = {	
		type = "recipe",
		name = "empty-super-container",
		icon = false,
		icons = {{icon = "__modmash__/graphics/icons/super-container.png"}},
		icon_size = 32,
		localised_name = "Empty Super Container",
		localised_description = "Empty Super Container",
		enabled = false,
		ingredients =
		{
		  {"super-material", 1},
		  {"titanium-plate", 2},
		  {"blank-circuit", 1}
		},
		result = "empty-super-container"}

	local tech_icons = {
		{
			icon = "__modmash__/graphics/technology/super-material.png",
			icon_size = 128,
			scale = 0.5,
			},
		{
			icon = "__modmash__/graphics/icons/super-container.png",
			icon_size = 32,
			shift = {16,16}
		}}
	local tech = {
	    type = "technology",
		name = "super-containers",
		localised_name = "Super Containers",
		localised_description = "Super Containers",
		icon_size = 128,
		icon = false,
		icons = tech_icons,
		prerequisites = {"fluid-handling-3","automation-4"},
		effects =
		{
		  {
			type = "unlock-recipe",
			recipe = "empty-super-container"
		  },
		},
		unit =
		{
		  count = 200,	  
		  ingredients = {
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1}
		  },
		  time = 45,
		},
		order = "d-a-a"
	}
	
	data:extend({base_container,base_recipe,tech})
	local z = 1
	local added = {}
	for rx = 1, #raw_items do local raw = raw_items[rx]	
		for name,item in pairs(data.raw[raw]) do		
			if added[name] == nil then added[name] = item end
		end
	end
	--for rx = 1, #added do local raw = added[rx]	
	for name,item in pairs(added) do	
		if item ~= nil and item.name ~= nil and item.icon_size ~= nil then	
			if item.stack_size ~= nil and item.stack_size > 1 and item.icon_size ~= nil
				and table_contains(exclude_containers,item.name) == false
				and starts_with(item.name,"creative-mod") == false  
				and starts_with(item.name,"crash") == false 
				and starts_with(item.name,"deadlock-stack") == false 
				
				then
				local r = data.raw["recipe"][item.name]
				if (r~= nil and r.hide_from_player_crafting ~= true) or item.subgroup == "raw-material" or ends_with(item.name,"barrel") then
					if item.name ~= "empty-super-container" then
						--table.insert(added,item.name)
						local_create_container(item,z)
						z = z + 1
					end
				else 
					log("Skipping containers for " .. item.name)
				end
			end
		end
	end
end

local local_create_super_material_conversions = function()
	for name,item in pairs(data.raw["resource"]) do			
		
		--if item ~= nil and item.name ~= nil and item.icon ~= false and starts_with(item.name,"creative-mod") == false and data.raw["fluid"][item.name] == nil and data.raw["item"][item.name] ~= nil then					
		if item ~= nil and item.name ~= nil
				and starts_with(item.name,"creative-mod") == false
				and data.raw["fluid"][item.name] == nil
				and ((data.raw["item"][item.name] ~= nil) or (data.raw["tool"][item.name] ~= nil))
			then
			local base_icons = {
			{
				icon = "__modmash__/graphics/icons/super-material.png",
				icon_size = 32,
				shift = {-1,0}
			}}
			local base_tech_icons = {
			{
				icon = "__modmash__/graphics/technology/super-material.png",
				icon_size = 128,
				shift = {-32,-32},
				scale = 0.5
			}}
			local icons = create_icon(base_icons,item.icon,item.icon_size,item.icons,0.5,{4,4})		
			local tech_icons = create_icon(base_tech_icons,item.icon,item.icon_size,item.icons,1,{16,16})		
			local m = nil
			if data.raw["item"][item.name] then m = data.raw["item"][item.name].stack_size
			elseif data.raw["tool"][item.name] then m = data.raw["tool"][item.name].stack_size end
			if m == nil then m = 50 end
			local recipe = {
				type = "recipe",
				name = "modmash-supermaterial-to-"..item.name,
				localised_name = get_name_for(item,"Super Material to "),
				localised_description = get_name_for(item,"Super Material to "),
				category = "crafting-with-fluid",
				
				icon = false,
				icons = icons,
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
					icon = false,
					icons = tech_icons,
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
		ingredients[#ingredients+1] = {type="fluid",name = "sludge",amount = 25}
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
	local item = local_get_item(results[1].name)	

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
		normal = {
			enabled = "false",
			--hidden = true,
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
		--hidden = true,
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
			log("Skipping recyling " .. recipe.name)
		else
			local_create_recylce_item(recipe)
		end
	end			
end
local local_update_recipe = function(name, standard, normal, expensive)
	if data.raw.recipe[name] == nil then return end
	if standard ~= nil then
		data.raw.recipe[name].ingredients = standard		
	end
	if normal ~= nil then
		if data.raw.recipe[name].normal == nil then data.raw.recipe[name].normal = 
		{
			result = name
		} end
		data.raw.recipe[name].normal.ingredients = normal
	end
	if expensive ~= nil then
		if data.raw.recipe[name].expensive == nil then data.raw.recipe[name].expensive = 
		{
			result = name
		} end
		data.raw.recipe[name].expensive.ingredients = expensive
	end
end

local local_update_recipies = function()
	local_update_recipe("red-wire",{      
		  {name = "copper-cable", amount= 1}
		},nil,nil)
		
	local_update_recipe("green-wire",
		{      
		  {name = "copper-cable", amount = 1}
		},nil,nil)
	local_update_recipe("electronic-circuit",nil,
		{      
		  {name = "green-wire",  amount= 1},
		  {name = "blank-circuit",amount= 1}
		},
		{      
		  {name = "green-wire", amount=2},
		  {name = "blank-circuit", amount=2}
		})
	
	local_update_recipe("advanced-circuit",nil,
		{      
		  {name = "blank-circuit", amount=1},
		  {name = "electronic-circuit", amount=1},
		  {name = "plastic-bar", amount=1},
		  {name = "red-wire", amount=1},
		},
		{      
		  {name = "blank-circuit", amount=2},
		  {name = "electronic-circuit", amount=1},
		  {name = "plastic-bar", amount=2},
		  {name = "red-wire", amount=2},
		})



	if data.raw.recipe["processing-unit"].category == "crafting-with-fluid" then
		local_update_recipe("processing-unit",nil,
		{      
		   {name = "blank-circuit", amount=5},
		  {name = "red-wire", amount=1},
		  {name = "green-wire", amount=1},
		  {name = "copper-cable",amount= 1},
		  {type = "fluid", name = "sulfuric-acid",amount=5}
		},
		{      
		  {name = "blank-circuit",amount= 5},
		  {name = "red-wire", amount=2},
		  {name = "green-wire",amount= 2},
		  {name = "copper-cable",amount= 2},
		  {type = "fluid", name = "sulfuric-acid", amount = 10}
		})
	else
		local_update_recipe("processing-circuit",nil,
		{      
		   {name = "blank-circuit", amount=5},
		  {name = "red-wire", amount=1},
		  {name = "green-wire", amount=1},
		  {name = "copper-cable", amount=1},
		},
		{      
		  {name = "blank-circuit", amount=5},
		  {name = "red-wire", amount=2},
		  {name = "green-wire", amount=2},
		  {name = "copper-cable", amount=2},
		})
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
	  if data.raw.recipe[recipe] then		
		if (data.raw.recipe[recipe].normal ~= nil and type(data.raw.recipe[recipe].normal) == "table") or (data.raw.recipe[recipe].expensive ~= nil and type(data.raw.recipe[recipe].expensive) == "table") then
			if data.raw.recipe[recipe].expensive and type(data.raw.recipe[recipe].expensive) == "table" then
				log(recipe.." found expensive recipe")
				data.raw.recipe[recipe].expensive.ingredients = remove_ingredient_from_recipie_type(data.raw.recipe[recipe].expensive.ingredients,name)
			end
			if data.raw.recipe[recipe].normal and type(data.raw.recipe[recipe].normal) == "table" then
				log(recipe.." found normal recipe")
				data.raw.recipe[recipe].normal.ingredients = remove_ingredient_from_recipie_type(data.raw.recipe[recipe].normal.ingredients,name)     
			end
		else
			if data.raw.recipe[recipe].ingredients then
			  log(recipe.." found standard recipe")
			  data.raw.recipe[recipe].ingredients = remove_ingredient_from_recipie_type(data.raw.recipe[recipe].ingredients,name)
			else
				log(recipe.." not found")
			end
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
	
	add_ingredient_to_recipe("lab",{name = "glass", amount = 2})
	add_ingredient_to_recipe("solar-panel",{name = "glass", amount = 1})
	

	
	add_ingredient_to_recipe("construction-robot",{name = "droid", amount = 1})	
	add_ingredient_to_recipe("logistic-robot",{name = "droid", amount = 1})	
	remove_ingredient_from_recipie("construction-robot","electronic-circuit")
	remove_ingredient_from_recipie("logistic-robot","advanced-circuit")

	add_ingredient_to_recipe("inserter",{name = "burner-inserter", amount = 1})	
	remove_ingredient_from_recipie("inserter","iron-gear-wheel")
	remove_ingredient_from_recipie("inserter","iron-plate")

	if settings.startup["modmash-setting-glass"].value == "Hard" then 
		add_ingredient_to_recipe("fluid-wagon",{name = "glass", amount = 1})
		add_ingredient_to_recipe("oil-refinery",{name = "glass", amount = 4})
		add_ingredient_to_recipe("chemical-plant",{name = "glass", amount = 2})
		add_ingredient_to_recipe("nuclear-reactor",{name = "glass", amount = 10})
		add_ingredient_to_recipe("nuclear-fuel",{name = "glass", amount = 1})
		add_ingredient_to_recipe("rocket-fuel",{name = "glass", amount = 1})	
		add_ingredient_to_recipe("pump",{name = "glass", amount = 1})	
		for name, recipe in pairs(data.raw.recipe) do
			if recipe ~= nil and recipe.name ~= nil and ends_with(recipe.name,"science-pack") then
				add_ingredient_to_recipe(recipe.name,{name = "glass", amount = 1})	
			end
		end
	end
end

if not modmash.util.types then   
    modmash.util.types = {}
    modmash.util.types.is_polutant = local_is_polutant
    local_set_types_biome()
    local_set_types_non_pollutant() 
end



local add_missing_ooze = function()
	local added = {}
	local exclude_ooze = {"coal","titanium-ore","copper-ore","stone","iron-ore","uranium-ore"}	
	for name,item in pairs(data.raw["resource"]) do	
		if data.raw["fluid"][item.name] == nil then
			if added[item.name] == nil and starts_with(item.name,"creative") == false then 
				if data.raw["item"][item.name] ~= nil and table_contains(exclude_ooze,item.name) == false then
					added[item.name] = item 
				end
			end
		end
	end
	local tech = {
			type = "technology",
			name = "enrichment-e",
			localised_name = "Enrichment Extended",
			localised_description = "Refines Etended materials to obtain more usefull components",
			icon = "__modmash__/graphics/technology/advanced-chemistry.png",
			icon_size = 128,
			effects =
			{
     
			},
			prerequisites =
			{
			  "enrichment-3"
			},
			unit =
			{
			  count = 400,
			  ingredients =
			  {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
			  },
			  time = 45
			},
			upgrade = true,
			order = "a-b-d",}
	for name,item in pairs(added) do
		local base_icons = {
		{
			icon = "__modmash__/graphics/icons/alien-ooze.png",
			icon_size = 32,
			scale = 0.75,
			shift = {-8,-8}
		}}
		local icons = create_icon(base_icons,item.icon,item.icon_size,item.icons,0.5,{8,8})		
		local r = 	{
			type = "recipe",
			name = "alien-enrichment-process-to-"..item.name,
			localised_name = get_name_for(item,"Alien ooze to "),
			localised_description = get_name_for(item,"Alien ooze to" ),
			energy_required = 1.5,
			enabled = false,
			category = "crafting-with-fluid",
			ingredients = {{type="fluid",name = "alien-ooze",amount = 25}},
			hide_from_player_crafting = true,
			icon = false,
			icons = icons,
			icon_size = 64,
			subgroup = "intermediate-product",
			order = "c[alien-enrichment-process-to-"..item.name.."]-e[alien-enrichment-process-to-"..item.name.."]",
			main_product = "",
			results =
			{			
				{
				name = item.name,
				amount = 10
				}
			},
			allow_decomposition = false}
		table.insert(tech.effects,{
			type = "unlock-recipe",
			recipe = r.name})
		data:extend({r})
	end
	if #tech.effects > 0 then data:extend({tech}) end
end

local add_missing_materials_to_stone_and_uranium = function()
	local ingredients_missing_in = function(recipe,material)
		for rz = 1, #recipe.results do local res = recipe.results[rz]	
			if res.name == material then return false end
		end
		return true
	end
	local stone = data.raw["recipe"]["stone-enrichment-process"]
	local uranium = data.raw["recipe"]["uranium-enrichment-process"]
	local alien = data.raw["recipe"]["alien-enrichment-process"]
	local added = {}	
	for name,item in pairs(data.raw["resource"]) do	
		if data.raw["fluid"][item.name] == nil then
			if added[item.name] == nil and starts_with(item.name,"creative") == false then 
				if data.raw["item"][item.name] ~= nil then
					added[item.name] = item 
				end
			end
		end
	end
	for name,item in pairs(added) do
		if ingredients_missing_in(stone,item.name) then
			table.insert(stone.results,{
				name = item.name,
				probability = 0.25,
				amount = 1,
			}) 
		end
		if ingredients_missing_in(uranium,item.name) then
			table.insert(uranium.results,{
				name = item.name,
				probability = 0.25,
				amount = 1,
			})
		end
		if ingredients_missing_in(alien,item.name) then
			table.insert(alien.results,{
				name = item.name,
				probability = 0.25,
				amount = 1,
			})	
		end
	end
end


local check_ingredients = function(ingredients,name)
	--local new_table = {}
	local names = {}
	if ingredients ~= nil then
		--log(convert_to_string(ingredients))
		for i = #ingredients, 1, -1 do		
			--log(convert_to_string(ingredients[i]))
			if ingredients[i] == nil or ingredients[i].name == nil then
				--log("-----------ERROR NIL ".. name.. " " ..convert_to_string(ingredients))			
			elseif table_contains(names,ingredients[i].name) then
				log("------------ERROR DETECTED RECIPE ".. name.. " has duplicates of "..ingredients[i].name)
				table.remove(ingredients,i)
		--	else
		--		table.insert(names,ingredients[i].name)
		--		table.insert(new_table,ingredients[i])
			end
		end			
	end
	--ingredients = new_table
	return ingredients
end

local check_duplicate_items_in_recipies = function()
	for name, recipe in pairs(data.raw.recipe) do
		local normal = false;
		local expensive = false;
		local standard = false;

		if recipe ~= nil and recipe.name ~= nil then
			if (recipe.normal ~= nil and type(recipe.normal) == "table") or (recipe.expensive ~= nil and type(recipe.expensive) == "table") then
				if recipe.normal ~= nil and type(recipe.normal) == "table" then
					normal = true
					if recipe.normal.ingredients == nil then
						log("------------ERROR DETECTED RECIPE ".. name.. " has normal but missing ingredients")
					else 
						recipe.normal.ingredients = check_ingredients(recipe.normal.ingredients,recipe.name)
					end
					if recipe.normal.results == nil and recipe.normal.result == nil then
						log("------------ERROR DETECTED RECIPE ".. name.. " has normal but missing results")
					end
				end
				if recipe.expensive ~= nil and type(recipe.expensive) == "table" then
					expensive = true
					if recipe.expensive.ingredients == nil then
						log("------------ERROR DETECTED RECIPE ".. name.. " has expensive but missing ingredients")
					else 
						recipe.expensive.ingredients = check_ingredients(recipe.expensive.ingredients,recipe.name)
					end
					if recipe.expensive.results == nil and recipe.expensive.result == nil then
						log("------------ERROR DETECTED RECIPE ".. name.. " has expensive but missing results")
					end
				end
			elseif recipe.ingredients ~= nil then
				standard = true
				recipe.ingredients = check_ingredients(recipe.ingredients,recipe.name)
				if recipe.results == nil and recipe.result == nil then
					log("------------ERROR DETECTED RECIPE ".. name.. " has standard but missing results")
				end
			end
		else
			log("--------------------------ERROR DETECTED RECIPE WITH NO NAME")
			if recipe ~= nil then
				log(convert_to_string(recipe))
			end
		end
		if standard == false and normal == false and expensive == false then
			log("------------ERROR DETECTED RECIPE ".. name.. " has no ingredients at all!")
		elseif standard == true or normal == true then
			if not (recipe.normal ~= nil and type(recipe.normal) == "table") then
				if recipe.results ~= nil then
					--[[recipe.normal = {
						enabled = recipe.enabled,
						results = recipe.results,
						ingredients = recipe.ingredients
					}]]
				elseif recipe.result_count ~= nil then
				--[[	recipe.normal = {
						enabled = recipe.enabled,
						results = {{ name= recipe.result, amount=recipe.result_count}},
						ingredients = recipe.ingredients
					}]]
				else
					--[[recipe.normal = {
						enabled = recipe.enabled,
						results = {{ name= recipe.result, amount=1}},
						ingredients = recipe.ingredients
					}]]
				end
			end
			if not (recipe.expensive ~= nil and type(recipe.expensive) == "table") then
				if recipe.normal == nil then
					recipe.expensive = recipe.normal
				end
			end
		elseif expensive == true and normal == false then			
			recipe,normal = recipe.expensive
		end

		--if recipe.icon == nil then recipe.icon = false end
		--if recipe.icon_size == nil then recipe.icon_size = 32 end
		end
end

local check_prerequisites = function(prerequisites,name)
	local new_table = {}
	local names = {}
	if prerequisites ~= nil then
	for i = 1, #prerequisites do		
			if prerequisites[i] == nil then
				--log("-----------ERROR NIL ".. name.. " " ..convert_to_string(prerequisites))			
			elseif table_contains(names,prerequisites[i]) then
				log("------------ERROR DETECTED PREREQUISITS ".. name .. " has duplicates of "..prerequisites[i])
			else
				table.insert(names,prerequisites[i])
				table.insert(new_table,prerequisites[i])
			end
		end			
	end
	prerequisites = new_table
	return prerequisites
end


local check_duplicate_tech = function()
	for name, tech in pairs(data.raw.technology) do
		data.raw.technology[name].prerequisites = check_prerequisites(tech.prerequisites, name)
	end
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
	if recipe == nil then return nil end
	local result_count = 1		
	if recipe.normal ~= nil and type(recipe.normal) == "table" and recipe.normal.result ~= nil then
		result_count = recipe.normal.result_count or 1
		if type(recipe.normal.result) == "string" then
			return {{type = "item", name = recipe.normal.result, amount = result_count}}
		elseif recipe.normal.result.name then
			return {recipe.result}
		elseif recipe.normal.result[1] then
			result_count = recipe.normal.result[2] or result_count
			return {{type = "item", name = recipe.normal.result[1], amount = result_count}}
		end		
	end
	return recipe.results
end


local local_create_ore_refinements = function()
	for name, recipe in pairs(data.raw.recipe) do
		if recipe ~= nil and recipe.name ~= nil and recipe.category=="smelting" then
			local sr = local_get_standard_results(recipe)
			local nr = local_get_normal_results(recipe)
			local s = nil
			local n = nil
			if sr~=nil and #sr==1 then s = sr[1] end
			if nr~=nil and #nr==1 then n = nr[1] end
			local make = nil
			if s ~= nil and s.name ~= nil and ends_with(s.name,"plate") then
				if #recipe.ingredients == 1 then
					make = 
					{
						results = s,
						energy_required  = recipe.energy_required,
						ingredients = local_ensure_ingredient_format(recipe.ingredients[1])
					}
				end
			elseif n ~= nil and n.name ~= nil and ends_with(n.name,"plate") then
				if #recipe.normal.ingredients == 1 then	
					make = 
					{
						results = n,
						energy_required  = recipe.normal.energy_required,
						ingredients = local_ensure_ingredient_format(recipe.normal.ingredients[1])
					}
				end
			end

			if make ~= nil then
				if make.ingredients ~=nil and ends_with(make.ingredients.name,"ore") then
					local i = local_get_item(make.ingredients.name)
					if i ~= nil and type(i.icon) == "string" then
						local m = data.raw["item"][make.ingredients.name].stack_size
						if m == nil then m = 50 end
						local ore_name = i.name.."-refined"
						local item = 
						{
						    type = "item",
							name = ore_name,
							localised_name = get_name_for(i,"Refined "),
							localised_description = get_name_for(i,"Refined "),
							hide_from_player_crafting = true,
							icon = false,
							icons = {
								{
									icon = i.icon,
									icon_size = i.icon_size,
								},
								{
									icon = i.icon,
									icon_size = i.icon_size,
									tint = {r=0.0,g=0.0,b=0.0,a=0.25}
								}
							},
							subgroup = "raw-resource",
							order = "z["..ore_name.."]",
							stack_size = m
						}
						local refine_recipie = 
						{
							type = "recipe",
							name = ore_name,
							category = "ore-refining",
							subgroup = "refine",
							normal =
							{
								hide_from_player_crafting = true,
								allow_as_intermediate = false,
								allow_intermediates = false,
								hidden_from_char_screen = true,
								enabled = true,
								energy_required = 2,
								ingredients = {{i.name, 1}},
								result = ore_name
							}
						}
						local refine_result_recipie = 
						{
							type = "recipe",
							name = ore_name.."_to_plate",
							category = "smelting",
							subgroup = "refine",
							normal =
							{
								hide_from_player_crafting = true,
								allow_as_intermediate = false,
								allow_intermediates = false,
								hidden_from_char_screen = true,
								enabled = true,
								energy_required = make.energy_required * 1.2,
								ingredients = {{ore_name, 1}},
								results = { {name = make.results.name, amount = make.results.amount * 2 }}
							}							
						}
						data:extend({item,refine_recipie,refine_result_recipie})
					end
				end
			end
		end
	end
end

if data ~= nil and data_final_fixes == true then
    local_set_types_biome() --Dexy Edit
    local_set_types_non_pollutant() --Dexy Edit
    local_create_biome_recipies()
    local_create_fluid_recipies()
    local_update_recipies()	
    local_create_recycle_recipies(data.raw.recipe)
	local_create_super_material_conversions()
	local_create_super_containers()
	local_create_subspace_transport()
	add_missing_materials_to_stone_and_uranium()
	add_missing_ooze()
	local_create_ore_refinements()

	local loot_science_a = table.deepcopy(data.raw["simple-entity"]["crash-site-lab-broken"])
	loot_science_a.name = "loot_science_a"
	loot_science_a.order = "zzzzz"
	loot_science_a.localised_name ="Crashed science lab"
	local loot_science_b = table.deepcopy(data.raw["simple-entity"]["crash-site-lab-broken"])
	loot_science_b.name = "loot_science_b"
	loot_science_b.order = "zzzzz"
	loot_science_b.localised_name ="Crashed science lab"
	data:extend({loot_science_a,loot_science_b})
	if settings.startup["modmash-check-recipies"].value == "Enabled" then 
		check_duplicate_items_in_recipies()
	end
	if settings.startup["modmash-check-tech"].value == "Enabled" then
		check_duplicate_tech()
	end

	for name,item in pairs(data.raw["assembling-machine"]) do			
		if item ~= nil and item.name ~= nil then	
			if (starts_with(item.name,"assembling-machine") and item.crafting_speed > 1.25)
			or starts_with(item.name,"centrifuge") then
				if table_contains(item.crafting_categories,"containment") == false then
					table.insert(item.crafting_categories,"containment")
				end				
			end
		end
	end

end