data:extend(
{
 {
	type = "technology",
    name = "allow-pickup-rotations",
    icon = "__base__/graphics/technology/logistics.png",
	localised_name = "Advanced Inserter Control",
	localised_description = "Advanced Inserter Control, allows adjustment of Inserter pickup locations",
    icon_size = 128,
    effects = {},
    prerequisites = {"logistics"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},	
      },
      time = 15
    },
    order = "a-f-d"
  },{
	type = "technology",
    name = "allow-fishing",
    icon = "__base__/graphics/technology/logistics.png",
	localised_name = "Inserter Fishing Control",
	localised_description = "Inserter Fishing Control, allows inserters facing water to operate as fishing machines",
    icon_size = 128,
    effects = {},
    prerequisites = {"allow-pickup-rotations"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},	
      },
      time = 15
    },
    order = "a-f-d"
  },
})