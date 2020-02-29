--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "recipe",
    name = "recycling-machine",
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