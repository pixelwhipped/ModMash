--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
	{
		type = "recipe",
		name = "light-oil-conversion-crude-oil",
		energy_required = 1.5,
		enabled = false,
		category = "chemistry",
		ingredients = {{"coal", 15},{type="fluid", name="light-oil", amount=30},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/light-oil-conversion-crude-oil.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[light-oil-conversion-crude-oil]",
		main_product = "",
		results =
		{
			{type="fluid", name="crude-oil", amount=50},     
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "titanium-plate",
		category = "smelting",
		normal =
		{
			enabled = true,
			energy_required = 17.5,
			ingredients = {{"titanium-ore", 5}},
			result = "titanium-plate"
		}
	},
	{
		type = "recipe",
		name = "alien-plate",
		category = "smelting",
		normal =
		{
			enabled = true,
			energy_required = 17.5,
			ingredients = {{"alien-ore", 1}},
			result = "alien-plate"
		},
	},
	{
		type = "recipe",
		name = "copper-enrichment-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"copper-ore", 4},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/copper-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[copper-enrichment-process]",
		main_product = "",
		results =
		{
			{
				name = "stone",       
				amount = 2
			},
			{
				name = "iron-ore",
				amount = 1,
			},
			{
				name = "copper-ore",
				probability = 0.25,
				amount = 1,
			},
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "stone-enrichment-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"stone", 4},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/stone-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[stone-enrichment-process]",
		main_product = "",
		results =
		{
			{
				name = "stone",       
				amount = 1
			},
			{
				name = "iron-ore",
				probability = 0.4,
				amount = 1,
			},
			{
				name = "copper-ore",
				probability = 0.25,
				amount = 1,
			},
			{
				name = "uranium-ore",
				probability = 0.001,
				amount = 1,
			},
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "uranium-enrichment-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"uranium-ore", 10},{type="fluid", name="steam", amount=100}},
		icon = "__modmash__/graphics/icons/uranium-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[uranium-enrichment-process]",
		main_product = "",
		results =
		{
			{
				name = "stone", 
				amount = 1
			},
			{
				name = "iron-ore",				
				amount = 2,
			},
			{
				name = "copper-ore",				
				amount = 1,
			},
			{
				name = "coal",
				amount = 3,
			},{
				name = "uranium-ore",
				probability = 0.5,
				amount = 1,
			},
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "coal-enrichment-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"coal", 3},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/coal-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[coal-enrichment-process]",
		main_product = "",
		results =
		{
			{type="fluid", name="heavy-oil", amount=25},     
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "iron-enrichment-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"iron-ore", 4},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/iron-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[iron-enrichment-process]",
		main_product = "",
		results =
		{
			{
			name = "stone",       
			amount = 1
			},
			{
			name = "iron-ore",
			probability = 0.3,
			amount = 1,
			},
			{
			name = "titanium-ore",
			probability = 1,
			amount = 1,
			}
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 4},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/alien-conversion.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process]",
		main_product = "",
		results =
		{
			{
			name = "stone",       
			amount = 1
			},
			{
			name = "iron-ore",
			probability = 0.6,
			amount = 1,
			},
			{
			name = "copper-ore",
			probability = 0.4,
			amount = 1,
			}
			,
			{
			name = "titanium-ore",
			probability = 0.4,
			amount = 1,
			}
			,
			{
			name = "uranium-ore",
			probability = 0.005,
			amount = 1,
			}
		},
		allow_decomposition = false,
	},{
		type = "recipe",
		name = "titanium-extraction-process",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"iron-ore", 5},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/titanium-extraction-process.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[titanium-extraction-process]",
		main_product = "",
		results =
		{
			{
			name = "titanium-ore",
			amount = 4,
			}
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-ooze",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 75},{type="fluid", name="steam", amount=50}},
		icon = "__modmash__/graphics/icons/alien-conversion-ooze.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]",
		main_product = "",
		results =
		{			
			{
				type = "fluid",
				name = "alien-ooze",
				amount = 100,
			}			
		},
		crafting_machine_tint =
		{
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000},
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000},
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000}, 
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-ore",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid", name = "alien-ooze",amount = 100}},
		icon = "__modmash__/graphics/icons/alien-conversion-ore.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-enrichment-process-to-ore]",
		main_product = "",
		results =
		{			
			{
			name = "alien-ore",
			amount = 75,
			}			
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-artifact-enrichment-process-to-ore",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{name = "alien-artifact", amount = 2},{type="fluid", name = "alien-ooze",amount = 20}},
		icon = "__modmash__/graphics/icons/alien-artifact-conversion-ore.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-artifact-enrichment-process-to-ore]",
		main_product = "",
		results =
		{			
			{
			name = "alien-ore",
			amount = 75,
			}			
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-iron",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid", name = "alien-ooze",amount = 25}},
		icon = "__modmash__/graphics/icons/alien-conversion-iron.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-enrichment-process-to-iron]",
		main_product = "",
		results =
		{			
			{
			name = "iron-ore",
			amount = 14,
			}			
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-stone",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid",name =  "alien-ooze",amount = 25}},
		icon = "__modmash__/graphics/icons/alien-conversion-stone.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-enrichment-process-to-stone]",
		main_product = "",
		results =
		{
			{
			name = "stone",       
			amount = 15
			}			
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-copper",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid", name = "alien-ooze",amount = 25}},
		icon = "__modmash__/graphics/icons/alien-conversion-copper.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-enrichment-process-to-copper]",
		main_product = "",
		results =
		{
			{
			name = "copper-ore",
			amount = 14,
			}			
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-titanium",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid",name =  "alien-ooze",amount = 25}},
		icon = "__modmash__/graphics/icons/alien-conversion-titanium.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-enrichment-process-to-titanium]",
		main_product = "",
		results =
		{
			{
			name = "titanium-ore",
			amount = 12,
			}
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-coal",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid",name =  "alien-ooze",amount = 25}},
		icon = "__modmash__/graphics/icons/alien-conversion-coal.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-d[alien-enrichment-process-to-coal]",
		main_product = "",
		results =
		{
			{
			name = "coal",
			amount = 14,
			}
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-uranium",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{type="fluid",name = "alien-ooze",amount = 25}},
		icon = "__modmash__/graphics/icons/alien-conversion-uranium.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-e[alien-enrichment-process-to-uranium]",
		main_product = "",
		results =
		{			
			{
			name = "uranium-ore",
			amount = 5,
			}
		},
		allow_decomposition = false,
	},

	{
		type = "recipe",
		name = "alien-enrichment-process-to-artifact",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {
			{type="fluid",name = "sludge",amount = 25},
			{type="item",name = "alien-ore",amount = 25}
		},
		icon = "__modmash__/graphics/icons/alien-enrichment-process-to-artifact.png",
		icon_size = 32,
		subgroup = "intermediate-product",
		order = "c[alien-enrichment-process-to-ooze]-e[alien-enrichment-process-to-artifact]",
		main_product = "",
		results =
		{			
			{
			name = "alien-artifact",
			amount = 2,
			}
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "spawner",
		energy_required = 1.5,
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {{"alien-ore", 10},{"alien-artifact",1},{type="fluid",name = "water",amount = 50}},
		icon = "__modmash__/graphics/icons/spawner.png",
		icon_size = 32,
		subgroup = "defensive-structure",
		order = "z[spawner]",
		main_product = "",
		results =
		{			
			{
			name = "spitter-spawner",
			amount = 1,
			}
		},
		allow_decomposition = false,
	},
	{
    type = "recipe",
    name = "petroleum-gas-from-solid-fuel",
    category = "chemistry",
    energy_required = 2,
    ingredients =
    {
      {type="item", name="solid-fuel", amount=1}
    },
    results=
    {
		{type="fluid", name="petroleum-gas", amount=20}      
    },
    icon = "__modmash__/graphics/icons/petroleum-gas-from-solid-fuel.png",
    icon_size = 32,
    subgroup = "fluid-recipes",
    enabled = false,
    order = "b[fluid-chemistry]-d[petroleum-gas-from-solid-fuel]",
    crafting_machine_tint =
    {
      primary = {r = 0.331, g = 0.075, b = 0.510, a = 0.000},
      secondary = {r = 0.589, g = 0.540, b = 0.615, a = 0.361},
      tertiary = {r = 0.469, g = 0.145, b = 0.695, a = 0.000},
    }
  },
}
)