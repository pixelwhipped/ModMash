--[[Code check 29.2.20
no change
--]]
data:extend(
{
	{
		type = "recipe",
		name = "steam-engine-mk2",
		enabled = false,
		normal =
		{
		  enabled = false,
		  ingredients =
		  {
			{"iron-gear-wheel", 8},
			{"titanium-pipe", 5},
			{"titanium-plate", 8}
		  },
		  result = "steam-engine-mk2"
		},
		expensive =
		{
		  enabled = false,
		  ingredients =
		  {
			{"iron-gear-wheel", 10},
			{"titanium-pipe", 5},
			{"titanium-plate", 25}
		  },
		  result = "steam-engine-mk2"
		}
	}
})