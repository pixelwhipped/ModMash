--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "item",
    name = "mm-discharge-water-pump",
    icon = "__modmash__/graphics/icons/discharge-pump.png",
    icon_size = 32,
    subgroup = "extraction-machine",
    order = "b[fluids]-a[pffshore-pump]",
    place_result = "mm-discharge-water-pump",
    stack_size = 50
  },
})