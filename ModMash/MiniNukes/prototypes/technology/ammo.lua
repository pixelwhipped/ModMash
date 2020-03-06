data:extend(
{
  {
    type = "technology",
    name = "mini-nuke-ammo",
    icon_size = 128,
    icon = "__mininukes__/graphics/technology/mini-nuke-ammo.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "mini-nuke-magazine"
      }
    },
    prerequisites = {"uranium-ammo"},
    unit =
    {
      count = 500,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 45
    },
    order = "e-a-b"
  }
})