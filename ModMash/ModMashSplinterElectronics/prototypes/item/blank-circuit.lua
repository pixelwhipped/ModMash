data:extend(
{
	{
		type = "item",
		name = "faulty-circuit",
		icon = "__modmashsplinterelectronics__/graphics/icons/faulty-circuit.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "intermediate-product",
		order = "e[a-circuit]",
		stack_size = 200
	},
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
	},
	{
		type = "recipe",
		name = "blank-circuit-from-faulty-circuit",
		enabled = true,
		normal =
		{
			enabled = true,
			ingredients = {{"faulty-circuit", 3}},
			results =
			{
				{
					name = "blank-circuit",      
					amount = 1
				}
			},
			allow_as_intermediate = false,
			allow_decomposition = false,
			hide_from_player_crafting = true
		},
		expensive =
		{
			enabled = true,
			ingredients = {{"faulty-circuit", 4}},
			results =
			{
				{
					name = "blank-circuit",      
					amount = 1
				}
			},
			allow_as_intermediate = false,
			allow_decomposition = false,
			hide_from_player_crafting = true
		}
		
	}
})

if deadlock_stacking then
  local Items = {
		{"blank-circuit", "deadlock-stacking-1"},
		{"faulty-circuit", "deadlock-stacking-1"}
	}

	for _, item in pairs(Items) do
		local name = item[1]
		local tech = item[2]
		if data.raw.item[name] then
			if not data.raw.item["deadlock-stack-" .. name] then
				deadlock.add_stack(name, nil, tech, 64, "item", 4)
			end
		end
	end
end