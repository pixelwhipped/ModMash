data:extend(
{
    {
      effects = {
        {
          recipe = "titanium-rounds-magazine",
          type = "unlock-recipe"
        },
        {
          recipe = "alien-rounds-magazine",
          type = "unlock-recipe"
        }
      },
      icon = "__base__/graphics/technology/military.png",
      icon_mipmaps = 4,
      icon_size = 256,
      name = "military-mm",
      order = "e-a-b",
      prerequisites = {
        "military-3",
      },
      type = "technology",
      unit = {
        count = 20,
        ingredients = {
          {
            "automation-science-pack",
            1
          },
          {
            "logistic-science-pack",
            1
          },
          {
            "military-science-pack",
            1
          }
        },
        time = 15
      }
    }
})