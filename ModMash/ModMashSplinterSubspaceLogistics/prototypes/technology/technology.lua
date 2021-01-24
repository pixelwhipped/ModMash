local prerequisites = nil
if mods["modmashsplinterresources"] then prerequisites = "alien-conversion1" end

data:extend(
{
  {
    type = "technology",
    name = "super-material",
    icon = "__modmashsplintersubspacelogistics__/graphics/technology/super-material.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "modmash-super-boiler-valve"
      },{
        type = "unlock-recipe",
        recipe = "super-material"
      },{
        type = "unlock-recipe",
        recipe = "super-material-235"
      },{
        type = "unlock-recipe",
        recipe = "super-material-crude"
      }
    },
    prerequisites =
    {
      prerequisites
    },
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 35
    },
    upgrade = true,
    order = "a-b-d",
  }
})