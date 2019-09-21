data:extend(
{
  {
    type = "recipe",
    name = "recycling-machine",
	localised_name = "Recycling machine",		
	localised_description = "Recycles items into their component items, encurs wastage. CTRL+A to enable/disable automation.",
    enabled = "false",
    ingredients =
    {
      {"assembling-machine-2", 1},
      {"steel-plate", 5},
      {"iron-gear-wheel", 5},
    },
    result = "recycling-machine"
  }
}
)