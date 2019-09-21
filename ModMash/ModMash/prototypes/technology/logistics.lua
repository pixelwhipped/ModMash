data:extend(
{
  {
	type = "technology",
    name = "logistics-4",
    icon = "__base__/graphics/technology/logistics.png",
	localised_name = "Logistics 4",
	localised_description = "Logistics 4",
    icon_size = 128,
    effects = {},
    prerequisites = {"logistics-3"},
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
	localised_name = "Logistics 5",
	localised_description = "Logistics 5",
    icon = "__base__/graphics/technology/logistics.png",
    icon_size = 128,
    effects = {},
    prerequisites = {"logistics-4"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 4},
        {"logistic-science-pack", 4},	
		{"military-science-pack",3}
      },
      time = 15
    },
    order = "a-f-g"
  },
})