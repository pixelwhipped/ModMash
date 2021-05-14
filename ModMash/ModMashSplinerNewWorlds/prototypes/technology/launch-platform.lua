    
data:extend(
{
  {
	type = "technology",
	name = "launch-platform",
	icon = "__modmashsplinternewworlds__/graphics/technology/launch-platform.png",
	icon_size = 256, icon_mipmaps = 4,
	effects =
	{
	  {
        type = "unlock-recipe",
        recipe = "launch-platform"
      }
	},
	prerequisites =
	{
		"terraformer"
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
})

local create_transport_technology = function(level,count)
	return  
	{
		{
			type = "technology",
			name = "launch-platform-speed-"..level,
			icon = "__modmashsplinternewworlds__/graphics/technology/launch-platform.png",
			icon_size = 256, icon_mipmaps = 4,
			localised_name = {"",{"technology-name.launch-platform-speed-1"}," ",level},
			localised_description =  {"technology-description.launch-platform-speed-1"},
			effects =
			{
			},
			prerequisites =
			{
				"launch-platform-speed-"..(level-1)
			},
			unit =
			{
				count = count,
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
		}
	}
end

data:extend(
{
	{
		type = "technology",
		name = "launch-platform-speed-1",
		icon = "__modmashsplinternewworlds__/graphics/technology/launch-platform.png",
		icon_size = 256, icon_mipmaps = 4,
		localised_name = {"technology-name.launch-platform-speed-1"},
		localised_description =  {"technology-description.launch-platform-speed-1"},
		effects =
		{
		},
		prerequisites =
		{
			"launch-platform"
		},
		unit =
		{
			count = 200,
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
	}
})

local count = 250

for k=2, 6 do
	data:extend(create_transport_technology(k,count))
	count = count + 50
end