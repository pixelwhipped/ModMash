--[[Code check 29.2.20
removed old comments
fix string to type
--]]
data:extend(
{
  {
    type = "recipe",
    name = "assembling-machine-5",
    enabled = false,
    ingredients =
    {
      {"assembling-machine-4", 1},
      {"processing-unit", 3},
      {"titanium-plate", 5},
      {"iron-gear-wheel", 5},
    },
    result = "assembling-machine-5"
  }
}
)