﻿if not util then require("prototypes.scripts.util") end

local valve_levels = {
    type = "simple-entity-with-force",
    name = "valve-indicator",
    flags = {"not-blueprintable", "not-deconstructable", "not-on-map", "placeable-off-grid"},
    icon = "__modmash__/graphics/stickers/blank-icon.png",
    icon_size = 32,
    max_health = 100,
    selectable_in_game = false,
    mined_sound = nil,
    minable = nil,
    collision_box = nil,
    selection_box = nil,
    collision_mask = {},
    render_layer = "explosion",
    vehicle_impact_sound = nil,
    pictures =
    {
        {
            filename = "__modmash__/graphics/stickers/valve-25.png",
            priority = "extra-high",
            x = 0,
            y = 0,
            width = 17,
            height = 17,
            scale = 1,
        },
        {
            filename = "__modmash__/graphics/stickers/valve-50.png",
            priority = "extra-high",
            x = 0,
            y = 0,
            width = 17,
            height = 17,
            scale = 1,
        },
        {
            filename = "__modmash__/graphics/stickers/valve-75.png",
            priority = "extra-high",
            x = 0,
            y = 0,
            width = 17,
            height = 17,
            scale = 1,
        },
    },
}
data:extend({valve_levels})

local local_create_valve = function(name,localised_name,localised_description,order,ingredients,technology, source, usage)
	local icon = "__modmash__/graphics/icons/" .. name .. ".png"
	if source == nil then
		source = {type = "burner", effectivity = 1, fuel_inventory_size = 0, render_no_power_icon = false}
	end
	if usage == nil then
		usage = "1W" -- Need to be at least 1W or the no energy signal will keep blinking
	end

	local entity = {
		type = "assembling-machine",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
        icon_size = 32,
		icon = icon,
		flags = {"placeable-player", "player-creation"},
		minable = {mining_time = 0.5, result = name},
		max_health = 150,
		corpse = "small-remnants",
		fast_replaceable_group = "pipe",
		always_draw_idle_animation = true,
		collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		fluid_boxes =
		{
			{
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				pipe_connections =
				{
					{type = "output", position = {0, -1}}
				},
				production_type = "output"
			},
			{
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				pipe_connections =
				{
					{type = "input", position = {0, 1}},
				},
				production_type = "input"
			}
		},
		animation =
		{
			north =
			{
				filename = "__modmash__/graphics/entity/"..name.."/small-pump-up.png",
				width = 46,
				height = 56,
				frame_count = 8,
				shift = {0.09375, 0.03125},
				animation_speed = 0.5
			},
			east =
			{
				filename = "__modmash__/graphics/entity/"..name.."/small-pump-right.png",
				width = 51,
				height = 56,
				frame_count = 8,
				shift = {0.265625 - 6/2/32, -0.21875},
				animation_speed = 0.5
			},
			south =
			{
				filename = "__modmash__/graphics/entity/"..name.."/small-pump-down.png",
				width = 61,
				height = 58,
				frame_count = 8,
				shift = {0.421875, -0.125},
				animation_speed = 0.5
			},
			west =
			{
				filename = "__modmash__/graphics/entity/"..name.."/small-pump-left.png",
				width = 56,
				height = 44,
				frame_count = 8,
				shift = {0.3125, 0.0625},
				animation_speed = 0.5
			}
		},
		energy_source = source,--{type = "burner", effectivity = 1, fuel_inventory_size = 0, render_no_power_icon = false},
		energy_usage = usage,--"1W", -- Need to be at least 1W or the no energy signal will keep blinking
		crafting_speed = 1,
		ingredient_count = 1,
		always_draw_idle_animation = false,
		crafting_categories = {"discharge-fluids","wind-trap","recycling"},
		module_specification = {module_slots = 0},
		allowed_effects = {"pollution"}
		}
	local item = {
	    type = "item",
		name = name,
		localised_name = localised_name,
	    localised_description = localised_description,
		icon = icon,
		icon_size = 32,
		subgroup = "energy-pipe-distribution",
		order = "b[pipe]-"..order.."["..name.."]",
		place_result = name,
		stack_size = 50}
	local recipe = {
      type = "recipe",
      name = name,
	  localised_name = localised_name,
	  localised_description = localised_description,
      enabled = "false",
      ingredients = ingredients,
      result = name}
	if category ~= nil then recipe.category = category end
	data:extend({item})
	data:extend({entity})
	data:extend({recipe})	
	util.patch_technology(technology,name)
end

local local_valves = {
	{		
		name = "modmash-check-valve",		
		localised_name = "Check Valve",		
		localised_description = "Allows flow only in direction of arrow",
		order = "a",
		technology = "fluid-handling",
		ingredients = {
				{"steel-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		},
	},
	{		
		name = "modmash-overflow-valve",		
		localised_name = "Overflow Valve",		
		localised_description = "Allows flow when input is over 75% or a set % full. CTRL+A to Adjust",
		order = "b",
		technology = "fluid-handling-2",
		ingredients = {
				{"electronic-circuit", 1},
				{"steel-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		}
	},
	{		
		name = "modmash-underflow-valve",		
		localised_name = "Underflow Valve",		
		localised_description = "Allows flow when output is under 75% or a set % full. CTRL+A to Adjust",
		order = "c",
		technology = "fluid-handling-2",
		ingredients = {
				{"electronic-circuit", 1},
				{"steel-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		}
	},
	{		
		name = "mini-boiler",		
		localised_name = "Mini Boiler",		
		localised_description = "Converts Water into Steam",
		order = "d",
		technology = "fluid-handling-2",
		ingredients = {
				{"electronic-circuit", 1},
				{"titanium-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		},
		energy_source =
		{
			  type = "electric",
			  usage_priority = "secondary-input",
			  emissions = 0,
			  drain = "25kW",
		},
		energy_usage = "50kW",
		--crafting_speed = 0.8,
	},
	{		
		name = "condenser-valve",		
		localised_name = "Condenser valve",		
		localised_description = "Converts Steam back into Water",
		order = "e",
		technology = "fluid-handling-2",
		ingredients = {
				{"electronic-circuit", 1},
				{"titanium-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		},
		energy_source =
		{
			  type = "electric",
			  usage_priority = "secondary-input",
			  emissions = 0,
			  drain = "25kW",
		},
		energy_usage = "50kW",
		--crafting_speed = 0.8,
	}	}

data:extend({
	{
		type = "item",
		name = "void-item",
		icon = "__modmash__/graphics/stickers/blank-icon.png",
		localised_name = "Void Item",
		localised_description = "Void Item",
		icon_size = 32,
		subgroup = "logistic-network",
		order = "z[void]",
		enabled = false,
		stack_size = 50
	},
	{
		type = "recipe",
		name = "void-recipe",
		localised_name = "Void Recipe",
		localised_description = "Void Recipe",
		category = "recycling",
		subgroup = "recyclable",	
		energy_required = 0.01,    
		order = "z",
		enabled = true,
		icon = "__modmash__/graphics/stickers/blank-icon.png",	
		icon_size = 32,
		hide_from_stats = true,
		ingredients = {{name = "void-item", amount = 1}},
		results = 
		{
		  {name = "void-item", amount = 1}
		},
	}
})

for index=1, #local_valves do local valve = local_valves[index]
	--if valve.name == "modmash-check-valve" and mods["underground-pipe-pack"] then
	--	util.log("Skipping check-valve Confict with Advanced Underground Piping")
	--else
		util.log("Creating Valve " .. valve.name)
		local_create_valve(valve.name,valve.localised_name,valve.localised_description,valve.order,valve.ingredients,valve.technology, valve.energy_source, valve.energy_usage)
	--end
end