if data.raw["technology"]["electronics"].effects == nil then
	data.raw["technology"]["electronics"].effects = {}
end

table.insert(
data.raw["technology"]["electronics"].effects,
{type = "unlock-recipe",recipe = "droid"}
)
table.insert(
data.raw["technology"]["electronics"].effects,
{type = "unlock-recipe",recipe = "droid-chest"}
)

data:extend(
{
  {
    type = "technology",
    name = "enhance-drone-targeting-1",
	localised_name = "Drone Targeting Enhancement 1",
	localised_description = "Increases the droid search range",
	icon = "__modmash__/graphics/icons/construction_drone_icon.png",
    icon_size = 64,
    effects =
    {
    },
    prerequisites =
    {
      "electronics"
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
}
)

local create_technology = function(level)
	return  
	{
		{
			type = "technology",
			name = "enhance-drone-targeting-"..level,
			icon = "__modmash__/graphics/icons/construction_drone_icon.png",
			icon_size = 64,
			localised_name = "Drone Targeting Enhancement "..level,
			localised_description = "Increases the droid search range",
			effects =
			{
			},
			prerequisites =
			{
				"enhance-drone-targeting-"..(level-1)
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
	}
end

for k=2, 6 do
	data:extend(create_technology(k))
end