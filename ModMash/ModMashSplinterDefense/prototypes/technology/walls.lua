data:extend(
  {
     {
        type = "technology",
        name = "regenerative-wall",
              icon_mipmaps = 4,
      icon_size = 256,
        icon = "__base__/graphics/technology/stone-wall.png",
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "regenerative-wall"
          }
        },
	    prerequisites = {"titanium-walls"},
        unit =
        {
          count = 50,
          ingredients =
          {
		    {"automation-science-pack", 1},
		    {"logistic-science-pack", 1},	
		    {"military-science-pack",1}
          },
          time = 10
        },
        order = "a-k-a"
      },    
      {
        type = "technology",
        name = "titanium-walls",
              icon_mipmaps = 4,
      icon_size = 256,
        icon = "__base__/graphics/technology/stone-wall.png",
        effects =
        {
          {
            type = "unlock-recipe",
            recipe = "titanium-wall"
          }
        },
	    prerequisites = {"stone-wall"},
        unit =
        {
          count = 50,
          ingredients =
          {
		    {"automation-science-pack", 1},
		    {"logistic-science-pack", 1},	
		    {"military-science-pack",1}
          },
          time = 10
        },
        order = "a-k-a"
      }
  }
)
