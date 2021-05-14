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
    },
    {
        type = "technology",
        name = "fish-juice",
        icon = "__modmashsplinterresources__/graphics/technology/fish.png",
        icon_size = 128,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "fish-juice"
          }
        },
        prerequisites =
        {
          "fish1"
        },
        unit =
        {
          count = 200,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
          },
          time = 45
        },
        upgrade = true,
        order = "a-b-d",
    },
    {
        type = "technology",
        name = "ooze-juice",
        icon = "__modmashsplinterresources__/graphics/technology/conversion.png",
        icon_size = 128,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "ooze-juice"
          }
        },
        prerequisites =
        {
          "alien-conversion1"
        },
        unit =
        {
          count = 200,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
          },
          time = 45
        },
        upgrade = true,
        order = "a-b-d",
    },
    {
        type = "technology",
        name = "neural-toxin-rounds-magazine",
        icon = "__base__/graphics/technology/military.png",
        icon_mipmaps = 4,
        icon_size = 256,
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "neural-toxin-rounds-magazine"
          }
        },
        prerequisites =
        {
          "fish-juice","ooze-juice"
        },
        unit =
        {
          count = 200,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack",1}
          },
          time = 45
        },
        upgrade = true,
        order = "a-b-d",
    },
})