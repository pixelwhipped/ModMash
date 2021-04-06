local local_add_recipe = function(recipe)
    if data.raw["recipe"][recipe.name] ~= nil then return end
    data:extend({recipe})    
end

local_add_recipe(
	{
		type = "recipe",
		name = "assembling-machine-burner",	
		normal =
		{
			enabled = true,
			energy_required = 4,
			ingredients =
			{
				{"iron-gear-wheel", 3},
				{"iron-plate", 3},
			},
			result = "assembling-machine-burner"
		},
		expensive =
		{
			enabled = true,
			energy_required = 6,
			ingredients =
			{
				{"iron-gear-wheel", 6},
				{"iron-plate", 4},
			},
			result = "assembling-machine-burner"
		}	
	})


if settings.startup["setting-assembling-machine-burner-only"].value == "No" then
	local_add_recipe(
	{
		type = "recipe",
		name = "assembling-machine-f",	
		normal =
		{
			enabled = false,
			energy_required = 4,
			ingredients =
			{
				{"assembling-machine-burner", 2},
				{"pipe", 2},
			},
			result = "assembling-machine-f"
		},
		expensive =
		{
			enabled = true,
			energy_required = 6,
			ingredients =
			{
				{"assembling-machine-burner", 2},
				{"pipe", 6},
			},
			result = "assembling-machine-f"
		}	
	})

	local_add_recipe(
		{
			type = "recipe",
			name = "assembling-machine-4",	
			energy_required = 10,
			enabled = false,
			normal =
			{
				enabled = false,
				ingredients = modmashsplinterassembling.util.get_item_ingredient_substitutions({"titanium-plate"},
				{
					{"assembling-machine-2", 2},
					{"advanced-circuit", 3},
					{"titanium-plate", 5},
				}),
				result = "assembling-machine-4"
			},
			expensive =
			{
				enabled = false,
				ingredients = modmashsplinterassembling.util.get_item_ingredient_substitutions({"titanium-plate"},
				{
					{"assembling-machine-2", 3},
					{"advanced-circuit", 6},
					{"titanium-plate", 10},
				}),
				result = "assembling-machine-4"
			}		
		})

	local_add_recipe(
		{
			type = "recipe",
			name = "assembling-machine-5",	
			energy_required = 10,
			enabled = false,
			normal =
			{
				enabled = false,
				ingredients = modmashsplinterassembling.util.get_item_ingredient_substitutions({"alien-plate"},
				{
					{"assembling-machine-2", 4},
					{"processing-unit", 3},
					{"alien-plate", 6},
				}),
				result = "assembling-machine-5"
			},
			expensive =
			{
				enabled = false,
				ingredients = modmashsplinterassembling.util.get_item_ingredient_substitutions({"alien-plate"},
				{
					{"assembling-machine-2", 4},
					{"processing-unit", 6},
					{"alien-plate", 10 },
				}),
				result = "assembling-machine-5"
			}		
		})
end