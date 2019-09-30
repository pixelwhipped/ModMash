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
  {
    type = "item-group",
    hidden = true,
	name = "containment",
	localised_name = "Containment",
    icon = "__modmash__/graphics/item-group/containment.png",
    icon_size = 64,
    order = "z",
    inventory_order = "z",
  },
  {
    type = "item-subgroup",
	localised_name = "Containment",
    name = "containers",
    group = "containment",
    order = "a",
  },
}
)