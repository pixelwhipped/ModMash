data:extend(
{
	{
		type = "recipe-category",
		name = "recycling"
	},
	{
		type = "item-group",
		hidden = true,
		name = "recycling",
		icon = "__modmashsplinterrecycling__/graphics/item-group/recycling.png",
		icon_size = 128,
		order = "z",
		inventory_order = "z",
	},
	{
		type = "item-subgroup",
		name = "recyclable",
		group = "recycling",
		order = "a",
	}
}
)