data:extend(
{
  {
    type = "technology",
    name = modmashsplinterairpurifier.defines.names.air_purifier,
    icon = "__base__/graphics/technology/automation-2.png",
    icon_size = 256,
    icon_mipmaps = 4,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = modmashsplinterairpurifier.defines.names.air_purifier
      }
    },
    prerequisites =
    {
	  "fluid-handling",
    },
    unit =
    {
      count = 60,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 60
    },
    upgrade = true,
    order = "a-b-f"
  },{
    type = "technology",
    name = modmashsplinterairpurifier.defines.names.advanced_air_purifier,
    icon = "__base__/graphics/technology/automation-2.png",
    icon_size = 256,
    icon_mipmaps = 4,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = modmashsplinterairpurifier.defines.names.advanced_air_purifier
      }
    },
    prerequisites =
    {
	  "effectivity-module",
    },
    unit =
    {
      count = 75,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"chemical-science-pack", 1},
      },
      time = 60
    },
    upgrade = true,
    order = "a-b-f"
  },{
    type = "technology",
    name = "sludge-treatment",
    icon = "__base__/graphics/technology/automation-2.png",
    icon_size = 256,
    icon_mipmaps = 4,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "sludge-treatment"
      }
    },
    prerequisites =
    {
	  "oil-processing",
      modmashsplinterairpurifier.defines.names.air_purifier
    },
    unit =
    {
      count = 60,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 60
    },
    upgrade = true,
    order = "a-b-f"
  }}
)