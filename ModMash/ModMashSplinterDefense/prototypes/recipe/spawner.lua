data:extend(
{
	{
		type = "recipe",
		name = "spawner",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 10},{"alien-artifact",1},{type="fluid",name = "water",amount = 50}},
		icon = "__base__/graphics/icons/biter-spawner.png",
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = "defensive-structure",
		order = "z[spawner]",
		main_product = "",
		results =
		{			
			{
			name = "spawner",
			amount = 1,
			}
		},
		allow_decomposition = false,
	}
})