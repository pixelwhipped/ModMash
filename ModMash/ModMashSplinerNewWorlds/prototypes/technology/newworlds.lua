data:extend(
{
  {
	type = "technology",
	name = "alien-science-pack",
	icon = "__modmashsplinternewworlds__/graphics/technology/alien-science-pack.png",
	icon_size = 256, icon_mipmaps = 4,
	effects =
	{
	  {
        type = "unlock-recipe",
        recipe = "alien-science-pack"
      },
	  {
        type = "unlock-recipe",
        recipe = "royal-jelly"
      },
	},
	prerequisites =
	{
		"space-science-pack"
	},
	unit =
	{
		count = 200,
		ingredients =
		{
			{"alien-science-pack", 1},
		},
		time = 45
	},
	upgrade = true,
	order = "a-b-d",
  },
  {
	type = "technology",
	name = "terraformer",
	icon = "__modmashsplinternewworlds__/graphics/technology/terraformer.png",
	icon_size = 256, icon_mipmaps = 4,
	effects =
	{
	  {
        type = "unlock-recipe",
        recipe = "explorer"
      },
	  {
        type = "unlock-recipe",
        recipe = "terraformer"
      }
	},
	prerequisites =
	{
		"alien-science-pack"
	},
	unit =
	{
		count = 400,
		ingredients =
		{
			{"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"alien-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1}
		},
		time = 45
	},
	upgrade = true,
	order = "a-b-d",
  },
  {
	type = "technology",
	name = "exploration-success",
	icon = "__modmashsplinternewworlds__/graphics/technology/exploration-success.png",
	icon_size = 256, icon_mipmaps = 4,
	effects =
	{
	},
	prerequisites =
	{
		"terraformer"
	},
	unit =
    {
        count_formula = "2^(L-1)*1000",
        ingredients =
        {
            {"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"alien-science-pack", 1},
			{"utility-science-pack", 1},
			{"space-science-pack", 1}
        },
        time = 60
    },
    max_level = "infinite",
	upgrade = true,
	order = "a-b-d",
  },
})