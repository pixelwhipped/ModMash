--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
 {
	type = "technology",
    name = "allow-pickup-rotations",
    icon = "__base__/graphics/technology/logistics.png",
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