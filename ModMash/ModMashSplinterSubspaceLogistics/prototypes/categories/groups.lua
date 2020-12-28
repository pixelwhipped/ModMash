data:extend(
{
    {
        type = "item-group",
        hidden = true,
        name = "containment",
        icon = "__modmashsplintersubspacelogistics__/graphics/item-group/containment.png",
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
		type = "recipe-category",
		name = "containment"
	},  
    {
        type = "item-subgroup",
        name = "super-material",
        group = "intermediate-products",
        order = "b-a"
    },
    {
        group = "logistics",
        name = "subspace-logistic",
        order = "g",
        type = "item-subgroup"
    }

    --[[
    {
      group = "production",
      name = "production-machine",
      order = "e",
      type = "item-subgroup"
    },]]
}
)