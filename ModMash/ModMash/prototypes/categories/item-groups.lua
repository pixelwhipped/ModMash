--[[Code check 29.2.20
removed old comments
removed localized string
--]]
data:extend(
{
  {
    type = "item-group",
    hidden = true,
	name = "recycling",
    icon = "__modmash__/graphics/item-group/recycling.png",
    icon_size = 64,
    order = "z",
    inventory_order = "z",
  },
  {
    type = "item-subgroup",
    name = "recyclable",
    group = "recycling",
    order = "a",
  },
  {
    type = "item-group",
    hidden = true,
	name = "containment",
    icon = "__modmash__/graphics/item-group/containment.png",
    icon_size = 64,
    order = "z",
    inventory_order = "z",
  },
  {
    type = "item-subgroup",
    name = "containers",
    group = "containment",
    order = "a",
  },
  {
    type = "item-group",
    hidden = true,
	name = "refining",
    icon = "__modmash__/graphics/item-group/refining.png",
    icon_size = 64,
    order = "zz",
    inventory_order = "zz"
  },
  {
    type = "item-subgroup",
    name = "refine",
    group = "refining",
    order = "zz"
  },
}
)