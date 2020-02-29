--[[Code check 29.2.20
removed old comments
fix string to type
--]]
data:extend(
{
  {
    type = "recipe",
    name = "titanium-wall",
    enabled = false,
    ingredients =
    {
      {"stone-wall", 1},      
      {"titanium-plate", 4},      
    },
    result = "titanium-wall"
  },
}
)