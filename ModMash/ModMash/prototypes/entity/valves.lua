if not modmash or not modmash.util then require("prototypes.scripts.util") end

local patch_technology  = modmash.util.patch_technology

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

local local_create_valve = function(name,localised_name,localised_description,order,ingredients,technology, source, usage,fixed_recipe,light)
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
		fixed_recipe = fixed_recipe,
        icon_size = 32,
		icon = icon,
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
		crafting_speed = 3,
		crafting_speed = 3,
		ingredient_count = 1,
		always_draw_idle_animation = false,
		crafting_categories = {"discharge-fluids"},--,"recycling"}, --,"wind-trap","recycling"},
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
	patch_technology(technology,name)
	return entity
end

local local_valves = {
	{		
		name = "modmash-check-valve",		
		localised_name = {"item-name.modmash-check-valve"},	
		localised_description = {"item-description.modmash-check-valve"},	
		order = "a",
		technology = "fluid-handling",
		fixed_recipe = nil,
		light = nil,
		ingredients = {
				{"steel-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		},
	},
	{		
		name = "modmash-overflow-valve",	
		localised_name = {"item-name.modmash-overflow-valve"},	
		localised_description = {"item-description.modmash-overflow-valve",settings.startup["modmash-setting-adjust-binding"].value},
		order = "b",
		technology = "fluid-handling-2",
		light = nil,
		fixed_recipe = nil,
		ingredients = {
				{"electronic-circuit", 1},
				{"steel-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		}
	},
	{		
		name = "modmash-underflow-valve",		
		localised_name = {"item-name.modmash-underflow-valve"},	
		localised_description = {"item-description.modmash-underflow-valve",settings.startup["modmash-setting-adjust-binding"].value},
		order = "c",
		technology = "fluid-handling-2",
		fixed_recipe = nil,
		light = nil,
		ingredients = {
				{"electronic-circuit", 1},
				{"steel-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		}
	},
	{		
		name = "mini-boiler",		
		localised_name = {"item-name.mini-boiler"},	
		localised_description = {"item-description.mini-boiler"},
		order = "d",
		technology = "fluid-handling-2",
		fixed_recipe = "valve-water-steam",
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
		light = nil,
		energy_usage = "50kW",
		--crafting_speed = 0.8,
	},
	{		
		name = "modmash-super-boiler-valve",	
		localised_name = {"item-name.modmash-super-boiler-valve"},	
		localised_description = {"item-description.modmash-super-boiler-valve"},
		--localised_name = "Super Boiler",		
		--localised_description = "Converts Water into high temp steam",
		order = "d",
		technology = "fluid-handling-3",
		fixed_recipe = "valve-water-steam",
		ingredients = {
				{"electronic-circuit", 1},
				{"alien-plate", 1},
				{"iron-gear-wheel", 1},
				{"pipe", 1},
		},
		energy_source =
		{
		  type = "burner",
		  fuel_category = "advanced-alien",
		  effectivity = 1,
		  fuel_inventory_size = 1,
		},
		light = {intensity = 0.6, size = 3.3, shift = {0.0, 0.0}, color = {r = 1.0, g = 0.0, b = 0.0}},
		energy_usage = "50kW",
		--crafting_speed = 0.8,
	},
	{		
		name = "condenser-valve",		
		localised_name = {"item-name.condenser-valve"},	
		localised_description = {"item-description.condenser-valve"},
		order = "e",
		technology = "fluid-handling-2",
		fixed_recipe = "valve-steam-water",
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
		light = nil,
		energy_usage = "50kW",
	}	}

for index=1, #local_valves do local valve = local_valves[index]
	local_create_valve(valve.name,valve.localised_name,valve.localised_description,valve.order,valve.ingredients,valve.technology, valve.energy_source, valve.energy_usage, valve.fixed_recipe,valve.light)
end