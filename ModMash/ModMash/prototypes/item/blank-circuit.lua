--[[Code check 29.2.20
removed old comments
--]]
if not data.raw.item["sand"] then
  data:extend({
    {
      icon = "__modmash__/graphics/icons/sand.png",
      icon_size = 32,
      name = "sand",
      order = "a[wood]-b-b",
      stack_size = 200,
      subgroup = "raw-material",
      type = "item"
    }
  })
end

if not data.raw.item["glass"] then
  data:extend({
    {
      icon = "__modmash__/graphics/icons/glass.png",
      icon_size = 64,
      name = "glass",
      order = "a[wood]-b-c",
      stack_size = 100,
      subgroup = "raw-material",
      type = "item"
    }
  })
end
if not data.raw.recipe["sand-from-stone"] then
  data:extend({
    {
      ingredients = {
        { "stone", 1 }
      },
      name = "sand-from-stone",
      result = "sand",
      result_count = 2,
      type = "recipe",
      enabled = true,
      energy_required = 0.5,
    }
  })
end

if not data.raw.recipe["glass-from-sand"] then
  data:extend({
    {
      category = "smelting",
      energy_required = 4,
      ingredients = {
        { "sand", 1 }
      },
      name = "glass-from-sand",
      result = "glass",
      type = "recipe",
    },
  })
end

data:extend(
{
	{
		type = "item",
		name = "blank-circuit",
		icon = "__modmash__/graphics/icons/blank-circuit.png",
		icon_size = 32,
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
		  ingredients =
		  {
			{"glass", 1},
			{"red-wire", 1}
		  },
		  result = "blank-circuit"
		},
	}
})