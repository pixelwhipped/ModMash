require("prototypes.scripts.defines") 
local underground_accumulator  = modmashsplinterunderground.defines.names.underground_accumulator
local underground_access  = modmashsplinterunderground.defines.names.underground_access
local underground_access2  = modmashsplinterunderground.defines.names.underground_access2
local used_battery_cell  = modmashsplinterunderground.defines.names.used_battery_cell
local battery_cell  = modmashsplinterunderground.defines.names.battery_cell
local recharged_battery_cell = modmashsplinterunderground.defines.names.recharged_battery_cell



data:extend(
{
    {
		type = "recipe",
		name = underground_access,
		energy_required = 10,
		enabled = true,
		ingredients = modmashsplinterunderground.util.get_item_ingredient_substitutions({"assembling-machine-burner"},
		{
			{"assembling-machine-burner", 1},
			{"steel-chest", 5},
			{"pipe", 10},
		}),
		ingredients_expensive = modmashsplinterunderground.util.get_item_ingredient_substitutions({"assembling-machine-burner"},
		{
			{"assembling-machine-burner", 1},
			{"steel-chest", 10},
			{"pipe", 12},
		}),
		result = underground_access
	},
	{
		type = "recipe",
		name = underground_access2,
		energy_required = 10,
		enabled = false,
		ingredients = modmashsplinterunderground.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{underground_access, 2},
				{"titanium-plate", 10}
		}),
		ingredients_expensive = modmashsplinterunderground.util.get_item_ingredient_substitutions({"titanium-plate"},{
				{underground_access, 2},
				{"titanium-plate", 15}
		}),
		result = underground_access2
	},
	{
		type = "recipe",
		name = underground_accumulator,
		energy_required = 10,
		enabled = false,
		ingredients =
		{
		  {"iron-plate", 10},
		  {"battery", 5}
		},
		ingredients_expensive =
		{
		  {"iron-plate", 15},
		  {"battery", 8}
		},
		result = underground_accumulator
	},{
		type = "recipe",
		name = recharged_battery_cell,
		energy_required = 10,
		enabled = false,
		ingredients =
		{
		  {used_battery_cell, 1},
		  {"battery", 2}
		},
		ingredients_expensive =
		{
		  {used_battery_cell, 1},
		  {"battery", 4}
		},
		result = battery_cell
	},{
		type = "recipe",
		name = battery_cell,
		energy_required = 10,
		enabled = false,
		ingredients =
		{
		  {"iron-plate", 10},
		  {"battery", 5}
		},
		ingredients_expensive =
		{
		  {"iron-plate", 15},
		  {"battery", 8}
		},
		result = battery_cell
	}--[[,{
		type = "recipe",
		name = used_battery_cell,
		energy_required = 10,
		enabled = false,
		ingredients =
		{
		  {"iron-plate", 10},
		  {"battery", 5}
		},
		ingredients_expensive =
		{
		  {"iron-plate", 15},
		  {"battery", 8}
		},
		result = used_battery_cell
	}]]
})
