data:extend(
{
	{
		type = "item",
		name = "ai-circuit",
		icon = "__modmashsplinterelectronics__/graphics/icons/ai-circuit.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "intermediate-product",
		order = "f[ai-circuit]",
		stack_size = 200
	},
	{
		type = "recipe",
		name = "ai-circuit",
		enabled = true,
		normal =
		{
			enabled = true,
			ingredients = {
			{"faulty-circuit", 3},
			{"copper-cable", 1}
			},
			results =
			{
				{
					name = "ai-circuit",      
					amount = 1
				}
			}
		},
		expensive =
		{
			enabled = true,
			ingredients = {
			{"faulty-circuit", 4},
			{"copper-cable", 2}
			},
			results =
			{
				{
					name = "ai-circuit",      
					amount = 2
				}
			}
		}
	},
	{
		type = "recipe",
		name = "advanced-circuit-with-ai-circuit",
		enabled = false,
		normal =
		{
			enabled = false,
			ingredients = {
				{
					"ai-circuit",
					6
				},
				{
					"copper-cable",
					5
				}
			},
			results =
			{
				{
					name = "advanced-circuit",      
					amount = 1
				}
			}
		},
		expensive =
		{
			enabled = false,
			ingredients = {
				{
					"ai-circuit",
					8
				},
				{
					"copper-cable",
					8
				}
			},
			results =
			{
				{
					name = "advanced-circuit",      
					amount = 1
				}
			}
		}
	}
})

if deadlock_stacking then
  local Items = {
		{"ai-circuit", "deadlock-stacking-1"},
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