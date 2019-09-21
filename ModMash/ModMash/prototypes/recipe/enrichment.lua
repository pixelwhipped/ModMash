data:extend(
{
	{
		type = "recipe",
		name = "titanium-plate",
		localised_name = "Titanium plate",
		localised_description = "Titanium plate",
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
		localised_name = "Alien plate",
		localised_description = "Alien plate",
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
		localised_name = "Copper enrichment",
		localised_description = "Copper enrichment",
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
		localised_name = "Stone enrichment",
		localised_description = "Stone enrichment",
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
		localised_name = "Uranium enrichment",
		localised_description = "Uranium enrichment",
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
		localised_name = "Coal enrichment",
		localised_description = "Coal enrichment",
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
		localised_name = "Iron ore enrichment",
		localised_description = "Iron ore enrichment",
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
		localised_name = "Alien ore enrichment",
		localised_description = "Alien ore enrichment",
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
		localised_name = "Titanium extraction",
		localised_description = "Titanium extraction",
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
		localised_name = "Alien ooze",
		localised_description = "Alien ooze",
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
		  primary = {r = 1.000, g = 1, b = 0.0, a = 0.000}, -- #ffa70000
		  secondary = {r = 0.812, g = 0.812, b = 0.0, a = 0.000}, -- #cfff0000
		  tertiary = {r = 0.960, g = 0.960, b = 0.0, a = 0.000}, -- #f4cd0000
		 -- primary = {r = 1.000, g = 0.000, b = 0.659, a = 0.000}, -- #ffa70000
		 -- secondary = {r = 0.812, g = 0.000, b = 1.000, a = 0.000}, -- #cfff0000
		 -- tertiary = {r = 0.960, g = 0.000, b = 0.806, a = 0.000}, -- #f4cd0000
		},
		allow_decomposition = false,
	},
	{
		type = "recipe",
		name = "alien-enrichment-process-to-ore",
		localised_name = "Alien ooze to alien ore",
		localised_description = "Alien ooze to alien ore",
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
		localised_name = "Alien artifact to alien ore",
		localised_description = "Alien artifact to alien ore",
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
		localised_name = "Alien ooze to iron",
		localised_description = "Alien ooze to iron",
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
		localised_name = "Alien ooze to stone",
		localised_description = "Alien ooze to stone",
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
		localised_name = "Alien ooze to copper",
		localised_description = "Alien ooze to copper",
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
		localised_name = "Alien ooze to titanium",
		localised_description = "Alien ooze to titanium",
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
		localised_name = "Alien ooze to coal",
		localised_description = "Alien ooze to coal",
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
		localised_name = "Alien ooze to uranium",
		localised_description = "Alien ooze to uranium",
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
		localised_name = "Alien artifact gestation",
		localised_description = "Alien artifact gestation",
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
		localised_name = "Spawner",
		localised_description = "Spawner",
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
	localised_name = "Petroleum gas from solid fuel",
	localised_description = "Petroleum gas from solid fuel",
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
      primary = {r = 0.331, g = 0.075, b = 0.510, a = 0.000}, -- #54138200
      secondary = {r = 0.589, g = 0.540, b = 0.615, a = 0.361}, -- #96899c5c
      tertiary = {r = 0.469, g = 0.145, b = 0.695, a = 0.000}, -- #7724b100
    }
  },
}
)