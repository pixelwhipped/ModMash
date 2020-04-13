--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "item",
    name = "regenerative-wall",
    icon = "__modmashgraphics__/graphics/icons/regenerative-wall.png",
    icon_size = 32,
    subgroup = "defensive-structure",
    order = "a[stone-wall]-c[regenerative-wall]",
    place_result = "regenerative-wall",
    stack_size = 50
  },
}
)