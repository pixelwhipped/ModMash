--[[Code check 29.2.20
no changes
--]]
data:extend(
{
{
    type = "technology",
    name = "valkyrie-robot",
    icon_size = 128,
    icon = "__base__/graphics/technology/combat-robotics.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "valkyrie-robot"
      }
    },
    prerequisites = {"combat-robotics-2", "construction-robotics"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1}
      },
      time = 30
    },
    order = "e-p-b-a"
  },  
  {
	type = "technology",
	name = "valkyries-network",
	icon = "__base__/graphics/technology/combat-robotics.png",
	icon_size = 128,
	effects =
	{
	},
	prerequisites =
	{
		"valkyrie-robot"
	},
	unit =
	{
		count = 200,
		ingredients =
		{
			{"military-science-pack", 1}	
		},
		time = 45
	},
	upgrade = true,
	order = "a-b-d",
  },
  {
	type = "technology",
	name = "valkyrie-range-1",
	icon = "__base__/graphics/technology/combat-robotics.png",
	icon_size = 128,
	localised_name = {"technology-description.valkyrie-range-1"},
	localised_description =  {"technology-description.valkyrie-range-1"},
	effects =
	{
	},
	prerequisites =
	{
		"valkyrie-robot"
	},
	unit =
	{
		count = 200,
		ingredients =
		{
			{"military-science-pack", 1}	
		},
		time = 45
	},
	upgrade = true,
	order = "a-b-d",
  },
  {
	type = "technology",
	name = "valkyrie-force-1",
	icon = "__base__/graphics/technology/combat-robotics.png",
	icon_size = 128,
	localised_name = {"technology-description.valkyrie-force-1"},
	localised_description =  {"technology-description.valkyrie-force-1"},
	effects =
	{
	},
	prerequisites =
	{
		"valkyrie-robot"
	},
	unit =
	{
		count = 200,
		ingredients =
		{
			{"military-science-pack", 1}	
		},
		time = 45
	},
	upgrade = true,
	order = "a-b-d",
  },
})


local create_range_technology = function(level)
	return  
	{
		{
			type = "technology",
			name = "valkyrie-range-"..level,
			icon = "__base__/graphics/technology/combat-robotics.png",
			icon_size = 128,
			localised_name = {"",{"technology-description.valkyrie-range-1"}," ",level},
			localised_description =  {"technology-description.valkyrie-range-1"},
			effects =
			{
			},
			prerequisites =
			{
				"valkyrie-range-"..(level-1)
			},
			unit =
			{
				count = (200+(level*25)),
				ingredients =
				{
					{"military-science-pack", 1}	
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
	}
end

local create_force_technology = function(level)
	return  
	{
		{
			type = "technology",
			name = "valkyrie-force-"..level,
			icon = "__base__/graphics/technology/combat-robotics.png",
			icon_size = 128,
			localised_name = {"",{"technology-description.valkyrie-force-1"}," ",level},
			localised_description =  {"technology-description.valkyrie-force-1"},
			effects =
			{
			},
			prerequisites =
			{
				"valkyrie-force-"..(level-1)
			},
			unit =
			{
				count = (200+(level*25)),
				ingredients =
				{
					{"military-science-pack", 1}	
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
	}
end

for k=2, 5 do
	data:extend(create_range_technology(k))
end

for k=2, 10 do
	data:extend(create_force_technology(k))
end