data:extend(
{
  {
    type = "technology",
    name = "extend-build-range-1",
	localised_name = {"technology-description.extend-build-range-1"},
	localised_description =  {"technology-description.extend-build-range-1"},
	icon = "__spaghetti__/graphics/technology/extend-build-range.png",
    icon_size = 128,
    effects =
    {
    },
    prerequisites =
    {
      "logistic-science-pack"
    },
    unit =
    {
      count = 200,
      ingredients =
      {
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
			name = "extend-build-range-"..level,
			icon = "__spaghetti__/graphics/technology/extend-build-range.png",
			icon_size = 128,
			localised_name = {"",{"technology-description.extend-build-range-1"}," ",level},
			localised_description =  {"technology-description.extend-build-range-1"},
			effects =
			{
			},
			prerequisites =
			{
				"extend-build-range-"..(level-1)
			},
			unit =
			{
				count = (200+(level*25)),
				ingredients =
				{
					{"logistic-science-pack", 1},	
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
	}
end

for k=2, 3 do
	data:extend(create_technology(k))
end