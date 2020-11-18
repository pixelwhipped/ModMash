data:extend(
{
	{
		type = "item",
		name = "blank-circuit",
		icon = "__modmashsplinterelectronics__/graphics/icons/blank-circuit.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "intermediate-product",
		order = "e[blank-circuit]",
		stack_size = 200
	},
	{
		type = "recipe",
		name = "blank-circuit",
		enabled = true,
		normal =
		{
			enabled = true,
			ingredients = modmashsplinterelectronics.util.get_item_ingredient_substitutions({"glass"},{
			{"glass", 2},
			{"red-wire", 1}
			}),
			results =
			{
				{
					name = "blank-circuit",      
					amount = 2
				}
			}
		},
		expensive =
		{
			enabled = true,
			ingredients = modmashsplinterelectronics.util.get_item_ingredient_substitutions({"glass"},{
			{"glass", 3},
			{"red-wire", 2}
			}),
			results =
			{
				{
					name = "blank-circuit",      
					amount = 2
				}
			}
		}
	}
})