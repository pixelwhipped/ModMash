﻿data:extend(
{
  {
	type = "technology",
    name = "logistics-4",
    icon = "__modmashsplinterlogistics__/graphics/technology/logistics-4.png",
    icon_size = 128,
    effects = {},
    prerequisites = {"logistics-3","production-science-pack"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
		{"production-science-pack",2}
      },
      time = 15
    },
    order = "a-f-d"
  },
  {
	type = "technology",
    name = "logistics-5",
    icon = "__modmashsplinterlogistics__/graphics/technology/logistics-5.png",
    icon_size = 128,
    effects = {},
    prerequisites = {"logistics-4","utility-science-pack","military-science-pack"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 4},
        {"logistic-science-pack", 4},	
		{"military-science-pack",3},
        {"utility-science-pack",3}
      },
      time = 15
    },
    order = "a-f-g"
  },
})