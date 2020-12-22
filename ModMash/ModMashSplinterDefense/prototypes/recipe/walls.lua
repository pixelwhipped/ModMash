data:extend(
{
  {
    type = "recipe",
    name = "regenerative-wall",
    enabled = "false",
    ingredients =
    {
      {"titanium-wall", 1},      
      {"alien-plate", 4},      
    },
    result = "regenerative-wall"
  },
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