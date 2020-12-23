data:extend({
    {
        type = "technology",
        name = "spawner",
        icon = "__modmashsplinterresources__/graphics/technology/conversion.png",
        icon_size = 128,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "spawner"
          }
        },
        prerequisites =
        {
        },
        unit =
        {
          count = 300,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
          },
          time = 45
        },
        upgrade = true,
        order = "a-b-d",
    }
 })