data:extend(
{
  {
    type = "item-group",
    hidden = true,
	name = "recycling",
	localised_name = "Recycling",
    icon = "__modmash__/graphics/item-group/recycling.png",
    icon_size = 64,
    order = "z",
    inventory_order = "z",
  },
  {
    type = "item-subgroup",
	localised_name = "Recycling",
    name = "recyclable",
    group = "recycling",
    order = "a",
  },
}
)