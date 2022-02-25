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
		},
        allow_as_intermediate = false,
        allow_decomposition = false
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
		category = "crafting",
        energy_required = 2.5,
		normal =
		{
			enabled = true,
			energy_required = 2.5,
			ingredients = {{"gold-plate", 1}},
            results = {{type="item",name="gold-cable",amount=2}},            
			allow_as_intermediate = true
		},
        allow_as_intermediate = true,
        allow_decomposition = false
    }
  })
end

  data:extend({
    {
        icon = "__modmashsplintergold__/graphics/icons/statue.png",
        icon_mipmaps = 4,
        icon_size = 64,
        type = "recipe",
		name = "gold-statue",
		category = "crafting",
        energy_required = 10,
		normal =
		{
			enabled = true,
			energy_required = 10,
			ingredients = {{"gold-plate", 5000}},
			result = "gold-statue"
		},
        expensive =
		{
			enabled = true,
			energy_required = 10,
			ingredients = {{"gold-plate", 8000}},
			result = "gold-statue"
		},
        allow_as_intermediate = false,
        allow_decomposition = false
    }
  })