data:extend(
{
  {
    type = "recipe",
    name = "titanium-pipe",
    enabled = "false",
    ingredients =
    {
      {"titanium-plate", 1},
	  {"glass", 1},
    },
    result = "titanium-pipe",
  },

  {
    type = "recipe",
    name = "titanium-pipe-to-ground",
    enabled = "false",
    ingredients =
    {
      {"titanium-pipe", 15},
      {"titanium-plate", 5},
    },
    result_count = 2,
    result = "titanium-pipe-to-ground",
  },
}
)