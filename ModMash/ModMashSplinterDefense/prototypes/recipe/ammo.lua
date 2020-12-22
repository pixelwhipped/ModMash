--[[Code check 29.2.20
no changes
--]]
data:extend(
{
  {
    type = "recipe",
    name = "titanium-rounds-magazine",
    enabled = false,
    energy_required = 3,
    ingredients =
    {
      {"firearm-magazine", 1},      
      {"titanium-plate", 5}
    },
    result = "titanium-rounds-magazine"
  },
  {
    type = "recipe",
    name = "alien-rounds-magazine",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {"firearm-magazine", 1},      
      {"alien-plate", 6}
    },
    result = "alien-rounds-magazine"
  },
  }
  )