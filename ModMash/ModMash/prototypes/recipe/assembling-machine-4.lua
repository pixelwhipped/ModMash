--[[Code check 29.2.20
removed old comments
fix string to type
--]]
data:extend(
{
  {
    type = "recipe",
    name = "assembling-machine-4",	
    enabled = false,
    ingredients =
    {
      {"assembling-machine-3", 1},
      {"advanced-circuit", 3},
      {"titanium-plate", 5},
      {"iron-gear-wheel", 5},
    },
    result = "assembling-machine-4"
  }
}
)