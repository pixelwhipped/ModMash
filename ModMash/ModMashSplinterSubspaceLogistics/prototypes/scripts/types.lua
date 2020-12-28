require("prototypes.scripts.defines")
local super_container_stack_size = modmashsplintersubspacelogistics.defines.defaults.super_container_stack_size

local ends_with = modmashsplintersubspacelogistics.util.ends_with
local starts_with = modmashsplintersubspacelogistics.util.starts_with
local get_item = modmashsplintersubspacelogistics.util.get_item
local get_name_for = modmashsplintersubspacelogistics.util.get_name_for
local ensure_ingredient_format = modmashsplintersubspacelogistics.util.ensure_ingredient_format
local get_standard_results = modmashsplintersubspacelogistics.util.get_standard_results
local get_normal_results = modmashsplintersubspacelogistics.util.get_normal_results
local create_layered_icon_using =	modmashsplintersubspacelogistics.util.create_layered_icon_using
local table_contains = modmashsplintersubspacelogistics.util.table.contains

local icon_pin_topleft = modmashsplintersubspacelogistics.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplintersubspacelogistics.util.defines.icon_pin_top
local icon_pin_topright = modmashsplintersubspacelogistics.util.defines.icon_pin_topright
local icon_pin_right = modmashsplintersubspacelogistics.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplintersubspacelogistics.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplintersubspacelogistics.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplintersubspacelogistics.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplintersubspacelogistics.util.defines.icon_pin_left


local exclude_containers = {"player-port","spawner","spitter-spawner","electric-energy-interface"}
local containers = {}

local local_create_container = function(item,x,container)

	local container = {
		type = "item",
		name = "super-container-for-"..item.name,
		localised_name = get_name_for(item,"Super Container of "),
		localised_description = get_name_for(item,"Super Container of "),
		icon = false,
		icons = create_layered_icon_using({
			{
				from = container
			},
			{
				from = item,
				scale = 0.45,
			}
		}),
		icon_size = 64,
		icon_mipmaps = 4,
		hide_from_player_crafting = true,
		subgroup = "intermediate-product",
		order = "zz[super-container-for-".. item.name .."]",
		stack_size = super_container_stack_size}
	local contain = {
		type = "recipe",
		name = "super-container-for-"..item.name,
		localised_name = get_name_for(item,"Super Container for "),
		localised_description = get_name_for(item,"Super Container for "),
		always_show_made_in = true,
		icon = false,
		icons = create_layered_icon_using({
			{
				from = container
			},
			{
				from = item,
				scale = 0.45,
			}
		}),
		icon_size = 64,
		icon_mipmaps = 4,
		enabled = false,
		energy = 45,
		category = "containment",
		subgroup = "containers",
		hide_from_player_crafting = true,
		ingredients =
		{
			{"empty-super-container", 1},
			{item.name, math.min(item.stack_size,settings.startup["setting-max-recipie-stack"].value)}
		},
		result = "super-container-for-"..item.name}
	local uncontain = {	
		type = "recipe",
		name = "empty-super-container-of-"..item.name,
		localised_name = get_name_for(item,"Empty Super Container of "), -- "Empty Super Container of "..clean_name,
		localised_description = get_name_for(item,"Empty Super Container of "), --"Empty Super Container of "..clean_name,
		always_show_made_in = true,
		icon = false,
		icons = create_layered_icon_using({
			{
				icon = "__modmashsplintersubspacelogistics__/graphics/icons/super-container.png",
				icon_size = 64,
				icon_mipmaps = 4,
				scale = 0.55,
				pin = icon_pin_topleft
			},
			{
				from = item,
				scale = 0.65,
				pin = icon_pin_bottomright
			}
		}),
		icon_size = 64,
		icon_mipmaps = 4,
		enabled = false,
		energy = 30,
		category = "containment",
		subgroup = "containers",
		hide_from_player_crafting = true,
		ingredients =
		{
			{name = "super-container-for-"..item.name,amount = 1}
		},
		results = {
			{name = "empty-super-container", amount = 1},
			{name = item.name, amount = math.min(item.stack_size,settings.startup["setting-max-recipie-stack"].value)}
		}}	
	local tech = {
		type = "technology",
		name = "super-containment-"..x,
		localised_name = get_name_for(item,"Super Containment of "), --"Super Containment of "..clean_name,
		localised_description = get_name_for(item,"Super Containment of "),
		icon_size = 128,
		icon = false,
		icons = create_layered_icon_using(
		{
			{
				from = container
			},
			{
				from = item,
				scale = 0.5,
			}
		}),
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
				filename = "__modmashsplintersubspacelogistics__/graphics/entity/subspace-transport/lab.png",
				width = 98,
				height = 87,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 1.5),
				hr_version =
				{
					filename = "__modmashsplintersubspacelogistics__/graphics/entity/subspace-transport/hr-lab.png",
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
			icon = "__modmashsplintersubspacelogistics__/graphics/icons/lab.png",
			icon_size = 64,
			icon_mipmaps = 4,
			subgroup = "subspace-logistic",
			order = "a",
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
			icon = "__modmashsplintersubspacelogistics__/graphics/technology/subspace-transport.png",
			prerequisites = {"super-material"},
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
			icon = "__modmashsplintersubspacelogistics__/graphics/icons/lab.png",
			icon_size = 64,
			icon_mipmaps = 4,
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

local raw_items = {"item","accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}

local local_create_super_containers = function()
	local base_container = {
		type = "item",
		name = "empty-super-container",
		localised_name = "Super Container",
		localised_description = "Super Material",
		icon = "__modmashsplintersubspacelogistics__/graphics/icons/super-container.png",
		icon_size = 64,
		icon_mipmaps = 4,
		always_show_made_in = true,
		subgroup = "subspace-logistic",
		order = "b",
		stack_size = 10}
	local base_recipe = {	
		type = "recipe",
		name = "empty-super-container",
		icon = "__modmashsplintersubspacelogistics__/graphics/icons/super-container.png",
		icon_size = 64,
		icon_mipmaps = 4,
		always_show_made_in = true,
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
			icon = "__modmashsplintersubspacelogistics__/graphics/icons/super-container.png",
			icon_size = 64,
		}}
	local tech = {
	    type = "technology",
		name = "super-containers",
		localised_name = "Super Containers",
		localised_description = "Super Containers",
		icon_size = 128,
		icon = false,
		icons = tech_icons,
		prerequisites = {"subspace-transport"},
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

	for name,item in pairs(added) do	
		if item ~= nil and item.name ~= nil and item.icon_size ~= nil then	
			if item.stack_size ~= nil and item.stack_size > 1 and item.icon_size ~= nil
				and table_contains(exclude_containers,item.name) == false
				and starts_with(item.name,"creative-mod") == false  
				and starts_with(item.name,"crash") == false 
				and starts_with(item.name,"deadlock-stack") == false 
				
				then
				
				if settings.startup["setting-subspace"].value == "Resource Only" then
					local r = data.raw["resource"][item.name]
					if r~= nil then
						if item.name ~= "empty-super-container" then
							local_create_container(item,z,base_container)
							z = z + 1				
						end
					end
				elseif settings.startup["setting-subspace"].value == "Items" then
					local r = data.raw["recipe"][item.name]
					if (r~= nil and r.hide_from_player_crafting ~= true) or item.subgroup == "raw-material" or ends_with(item.name,"barrel") then
						if item.name ~= "empty-super-container" then							
							local_create_container(item,z,base_container)
							z = z + 1					
						end
					end
				end
			end
		end
	end
end

local local_create_super_material_conversions = function()
	local supermaterial  = data.raw["item"]["super-material"]

	for name,item in pairs(data.raw["resource"]) do			
		if item ~= nil and item.name ~= nil
				and starts_with(item.name,"creative-mod") == false
				and data.raw["fluid"][item.name] == nil
				and ((data.raw["item"][item.name] ~= nil) or (data.raw["tool"][item.name] ~= nil)) then
			--[[local base_tech_icons = {
			{
				icon = "__modmashsplintersubspacelogistics__/graphics/technology/super-material.png",
				icon_size = 128,
				shift = {0,8},
				scale = 0.5
			}}]]
			local m = nil
			if data.raw["item"][item.name] then m = data.raw["item"][item.name].stack_size
			elseif data.raw["tool"][item.name] then m = data.raw["tool"][item.name].stack_size end
			m = math.min(m,settings.startup["setting-max-recipie-stack"].value)
			local recipe = {
				type = "recipe",
				name = "modmash-supermaterial-to-"..item.name,
				localised_name = get_name_for(item,"Super Material to "),
				localised_description = get_name_for(item,"Super Material to "),
				category = "crafting-with-fluid",				
				icon = false,
				icons = create_layered_icon_using({
					{
						from = supermaterial
					},
					{
						from = item,
						scale = 0.5,
						pin = icon_pin_bottomright
					}
				}),
				icon_size = 64,
				icon_mipmaps = 4,
				subgroup = "super-material",
				order = "d[super-material]["..item.name.."]",
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
					icons = create_layered_icon_using(
					{
						{
							from = 
							{
								icon = "__modmashsplintersubspacelogistics__/graphics/icons/super-material-tech.png",
								icon_size = 64,
								icon_mipmaps = 4
							}
						},
						{
							from = item,
							scale = 0.5,
							pin = icon_pin_bottomright
						}
					}),
					--icon = "__modmashsplintersubspacelogistics__/graphics/technology/super-material.png",
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
					  "super-material"
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
					order = "z",
				  }
				data:extend({recipe,tech})
		end
	end
end

if data ~= nil and data_final_fixes == true then
	local_create_super_material_conversions()
	
	if settings.startup["setting-subspace"].value ~= "Off" then
		local_create_subspace_transport()
		local_create_super_containers()		
	end
	table.insert(data.raw["assembling-machine"]["assembling-machine-4"].crafting_categories,"containment")
	table.insert(data.raw["assembling-machine"]["assembling-machine-5"].crafting_categories,"containment")
end

