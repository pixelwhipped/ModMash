data:extend(
{
  {
    type = "recipe",
    name = "valkyrie-robot",
	enabled = false,
	normal =
	{
		enabled = false,
		ingredients =
		{
			{"flying-robot-frame", 1},
			{"defender-capsule", 2},
			{"electronic-circuit", 2}
		},
		 result = "valkyrie-robot"
	},
	expensive =
	{
		enabled = false,
		ingredients =
		{
			{"flying-robot-frame", 1},
			{"distractor-capsule", 2},
			{"electronic-circuit", 2}
		},
		 result = "valkyrie-robot"
	}
   
  },
})