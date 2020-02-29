--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "recipe",
    name = "droid",
	enabled = false,
    ingredients =
    {
      {"electronic-circuit", 1},
      {"radar", 1}
    },
    result = "droid"
  },
  {
        type = "recipe",
		name = "droid-chest",
		enabled = false,
		ingredients =
		{
		  {"iron-plate", 4},
		  {"glass", 1},
		  {"electronic-circuit", 1},
		},
		result = "droid-chest"  
  }
})