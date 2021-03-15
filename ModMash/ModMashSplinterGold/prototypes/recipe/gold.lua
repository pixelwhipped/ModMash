require("prototypes.scripts.defines") 


if data.raw.recipe["gold-ore"] == nil then
  data:extend({
    {
       icon = "__modmashsplintergold__/graphics/icons/gold-ore.png",
       icon_mipmaps = 4,
       icon_size = 64,
       name = "gold-ore",
       normal =
	   {
            enabled = true,
		    ingredients = {
              {"stone", 2},
              {"copper-ore", 1},
              {type = "fluid", name = "water", amount = 100}
            },
		    results = {{name = "gold-ore", amount = 1},{type = "fluid", name = "water", amount = 10}}
	   },
	   expensive =
	   {
            enabled = true,
		    ingredients = {
              {"stone", 4},
              {"copper-ore", 1},
              {type = "fluid", name = "water",  amount = 200}
            },
		    results = {{name = "gold-ore", amount = 1},{type = "fluid", name = "water",  amount = 10}}
	   },
       subgroup = "raw-resource",
       category = "crafting-with-fluid",
       type = "recipe",
       enabled = true,

    }
  })
end

if data.raw.recipe["gold-plate"] == nil then
  data:extend({
    {
        icon = "__modmashsplintergold__/graphics/icons/gold-plate.png",
        icon_mipmaps = 4,
        icon_size = 64,
        type = "recipe",
		name = "gold-plate",
		category = "smelting",
        energy_required = 4.5,
		normal =
		{
			enabled = true,
			energy_required = 4.5,
			ingredients = {{"gold-ore", 1}},
			result = "gold-plate"
		}
    }
  })
end

if data.raw.recipe["gold-cable"] == nil then
  data:extend({
    {
        icon = "__modmashsplintergold__/graphics/icons/gold-cable.png",
        icon_mipmaps = 4,
        icon_size = 64,
        type = "recipe",
		name = "gold-cable",
		category = "smelting",
        energy_required = 2.5,
		normal =
		{
			enabled = true,
			energy_required = 2.5,
			ingredients = {{"gold-plate", 1}},
			result = "gold-cable"
		}
    }
  })
end