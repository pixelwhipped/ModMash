data:extend(
{
  {
    type = "item",
    name = "titanium-pipe",
	--localised_name = "Titanium pipe",
	--localised_description = "Titanium pipe",
    icon = "__modmash__/graphics/icons/titanium-pipe.png",
    icon_size = 32,
    subgroup = "energy-pipe-distribution",
    order = "a[pipe]-a[pipe]-2",
    place_result = "titanium-pipe",
    stack_size = 50,
  },

  {
    type = "item",
    name = "titanium-pipe-to-ground",
	--localised_name = "Titanium pipe to ground",
	--localised_description = "Titanium pipe to ground",
    icon = "__modmash__/graphics/icons/titanium-pipe-to-ground.png",
    icon_size = 32,
    subgroup = "energy-pipe-distribution",
    order = "a[pipe]-b[pipe-to-ground]-2",
    place_result = "titanium-pipe-to-ground",
    stack_size = 50,
  },
})