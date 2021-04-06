require("prototypes.scripts.defines")

local patch_technology  = modmashsplinterfluid.util.tech.patch_technology


local local_create_valve = function(name,localised_name,localised_description,order,normal,expensive,technology, source, usage,fixed_recipe,light)
	local icon = "__modmashsplinterfluid__/graphics/icons/" .. name .. ".png"
	if source == nil then
		source = {type = "burner", effectivity = 1, fuel_inventory_size = 0, render_no_power_icon = false}
	end
	if usage == nil then
		usage = "1W"
	end

	local entity = {
		type = "assembling-machine",
		name = name,
		localised_name = localised_name,
		localised_description = localised_description,
		fixed_recipe = fixed_recipe,
		icon = icon,
		icon_size = 64,
		icon_mipmaps = 4,
		flags = {"placeable-player", "player-creation"},
		minable = {mining_time = 0.5, result = name},
		max_health = 150,
		corpse = "small-remnants",
		fast_replaceable_group = "pipe",
		always_draw_idle_animation = true,
		light = light,
		collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
		fluid_boxes =
		{			
			{
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = -1,
				pipe_connections =
				{
					{type = "input", position = {0, 1}},
				},
				production_type = "input"
			},
			{
				pipe_covers = pipecoverspictures(),
				base_area = 10,
				base_level = 1,
				pipe_connections =
				{
					{type = "output", position = {0, -1}}
				},
				production_type = "output"
			}
		},
		animation =
		{
			north =
			{
				filename = "__modmashsplinterfluid__/graphics/entity/"..name.."/small-pump-up.png",
				width = 46,
				height = 56,
				frame_count = 8,
				shift = {0.09375, 0.03125},
				animation_speed = 0.5
			},
			east =
			{
				filename = "__modmashsplinterfluid__/graphics/entity/"..name.."/small-pump-right.png",
				width = 51,
				height = 56,
				frame_count = 8,
				shift = {0.265625 - 6/2/32, -0.21875},
				animation_speed = 0.5
			},
			south =
			{
				filename = "__modmashsplinterfluid__/graphics/entity/"..name.."/small-pump-down.png",
				width = 61,
				height = 58,
				frame_count = 8,
				shift = {0.421875, -0.125},
				animation_speed = 0.5
			},
			west =
			{
				filename = "__modmashsplinterfluid__/graphics/entity/"..name.."/small-pump-left.png",
				width = 56,
				height = 44,
				frame_count = 8,
				shift = {0.3125, 0.0625},
				animation_speed = 0.5
			}
		},
		energy_source = source,
		energy_usage = usage,
		crafting_speed = 3,
		crafting_speed = 3,
		ingredient_count = 1,
		always_draw_idle_animation = false,
		crafting_categories = {"discharge-fluids"},
		module_specification = {module_slots = 0},
		allowed_effects = {"pollution"}
		}
	local item = {
	    type = "item",
		name = name,
		localised_name = localised_name,
	    localised_description = localised_description,
		icon = icon,
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "energy-pipe-distribution",
		order = "b[pipe]-"..order.."["..name.."]",
		place_result = name,
		stack_size = 50}
	local recipe = {
      type = "recipe",
      name = name,
	  localised_name = localised_name,
	  localised_description = localised_description,
      enabled = false,
	  normal =
	  {
			enabled = false,
			ingredients = normal,
			result = name
	  },
	  expensive =
	  {
			enabled = false,
			ingredients = expensive,
			result = name
	  }
	}
	if category ~= nil then recipe.category = category end
	data:extend({item})
	data:extend({entity})
	data:extend({recipe})	
	patch_technology(technology,name)
	return entity
end

local local_valves = {
	{		
		name = "mini-boiler",		
		localised_name = {"item-name.mini-boiler"},	
		localised_description = {"item-description.mini-boiler"},
		order = "d",
		technology = "fluid-handling-2",
		fixed_recipe = "valve-water-steam",
		normal = {
				{"titanium-plate", 1},
				{"iron-gear-wheel", 2},
				{"titanium-pipe", 2},
		},
		expensive = {
				{"titanium-plate", 2},
				{"iron-gear-wheel", 3},
				{"titanium-pipe", 3},
		},
		energy_source =
		{
			  type = "electric",
			  usage_priority = "secondary-input",
			  emissions_per_minute  = 0,
			  drain = "25kW",
		},
		light = nil,
		energy_usage = "50kW",
	},
	{		
		name = "condenser-valve",		
		localised_name = {"item-name.condenser-valve"},	
		localised_description = {"item-description.condenser-valve"},
		order = "e",
		technology = "fluid-handling-2",
		fixed_recipe = "valve-steam-water",
		normal = {
				{"titanium-plate", 1},
				{"iron-gear-wheel", 2},
				{"titanium-pipe", 2},
		},
		expensive = {
				{"titanium-plate", 2},
				{"iron-gear-wheel", 3},
				{"titanium-pipe", 3},
		},
		energy_source =
		{
			  type = "electric",
			  usage_priority = "secondary-input",
			  emissions_per_minute  = 0,
			  drain = "25kW",
		},
		light = nil,
		energy_usage = "50kW",
	}	
}

local mini_boiler_recipe =
{
	type = "recipe",
	name = "valve-water-steam",
	localised_name = "Valve fluid Water To Steam",
	localised_description = "Valve fluid Water To Steam",
	category = "discharge-fluids",
	energy_required = 1.5,    
	hide_from_player_crafting = true,
	hidden = false,
	order = "z[valve-water-steam]",
	enabled = true,
	icon = "__modmashsplinter__/graphics/icons/blankicon.png",	
	icon_size = 64,
	icon_mipmaps = 4,
	hide_from_stats = true,
	ingredients = {{type = "fluid", name = "water", amount = 100}},
	results = 
	{
		{type = "fluid", name = "steam", amount = 100, temperature = 90}
	}
}

local mini_condenser_recipe =
{
	type = "recipe",
	name = "valve-steam-water",
	localised_name = "Valve fluid Steam To Water",
	localised_description = "Valve fluid Steam To Water",
	category = "discharge-fluids",
	energy_required = 1.5,    
	hide_from_player_crafting = true,
	hidden = false,
	order = "z[valve-steam-water]",
	enabled = true,
	icon = "__modmashsplinter__/graphics/icons/blankicon.png",	
	icon_size = 64,
	icon_mipmaps = 4,
	hide_from_stats = true,
	ingredients = {{type = "fluid", name = "steam", amount = 100}},
	results = 
	{
		{type = "fluid", name = "water", amount = 100}
	}
}
data:extend({mini_boiler_recipe,mini_condenser_recipe})

for index=1, #local_valves do local valve = local_valves[index]
	local_create_valve(valve.name,valve.localised_name,valve.localised_description,valve.order,valve.normal,valve.expensive,valve.technology, valve.energy_source, valve.energy_usage, valve.fixed_recipe,valve.light)
end