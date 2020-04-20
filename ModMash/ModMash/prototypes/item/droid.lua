if modmash.defines.names.droid_name ~= "droid" then return end

data:extend(
{
  {
    type = "item",
    name = "droid",
	icon = "__modmashgraphics__/graphics/icons/construction_drone_icon.png",
    icon_size = 64,
    subgroup = "logistic-network",
    order = "b[robot]-z[droid]",
    place_result = "droid",
    stack_size = 50
  },  {
    type = "item",
    name = "droid-chest",
    icon = "__modmashgraphics__/graphics/icons/droid-chest.png",
    icon_size = 32,
    subgroup = "logistic-network",
    order = "b[robot]-z[droid-chest]",
    place_result = "droid-chest",
    stack_size = 50
  },
})