local subgroup = "subspace-logistic"
if mods["modmashsplintersubspacelogistics"] == nil then subgroup = "logistic-network" end
data:extend(
{
    {
      category = "productivity",
      effect = {
        consumption = {
          bonus = 0.9
        },
        pollution = {
          bonus = -0.1
        },
        productivity = {
          bonus = 0.15
        },
        speed = {
          bonus = 0.0
        }
      },
      icon = "__modmashsplinternewworlds__/graphics/icons/clone.png",
      icon_mipmaps = 4,
      icon_size = 64,
      limitation = {
        "sulfuric-acid",
        "basic-oil-processing",
        "advanced-oil-processing",
        "coal-liquefaction",
        "heavy-oil-cracking",
        "light-oil-cracking",
        "solid-fuel-from-light-oil",
        "solid-fuel-from-heavy-oil",
        "solid-fuel-from-petroleum-gas",
        "lubricant",
        "iron-plate",
        "copper-plate",
        "steel-plate",
        "stone-brick",
        "sulfur",
        "plastic-bar",
        "empty-barrel",
        "uranium-processing",
        "copper-cable",
        "iron-stick",
        "iron-gear-wheel",
        "electronic-circuit",
        "advanced-circuit",
        "processing-unit",
        "engine-unit",
        "electric-engine-unit",
        "uranium-fuel-cell",
        "explosives",
        "battery",
        "flying-robot-frame",
        "low-density-structure",
        "rocket-fuel",
        "rocket-control-unit",
        "rocket-part",
        "automation-science-pack",
        "logistic-science-pack",
        "chemical-science-pack",
        "military-science-pack",
        "production-science-pack",
        "utility-science-pack",
        "kovarex-enrichment-process"
      },
      limitation_message_key = "production-module-usable-only-on-intermediates",
      name = "clone",
      order = "c",
      stack_size = 10,
      subgroup = subgroup,
      tier = 3,
      type = "module"
    },
    {
      icon = "__modmashsplinternewworlds__/graphics/icons/explorer.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "explorer",
      order = "d",
      rocket_launch_product = {
        "space-science-pack",
        100
      },
      stack_size = 1,
      subgroup = subgroup,
      type = "item"
    },
    {
		type = "item",
		name = "terraformer",
		icon = "__modmashsplinternewworlds__/graphics/icons/terraformer.png",
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = subgroup,
		order = "e",
		place_result = "terraformer",
		stack_size = 50
    },
    {
		type = "item",
		name = "royal-jelly",
		icon = "__modmashsplinternewworlds__/graphics/icons/royal-jelly.png",
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = subgroup,
		order = "e",
		stack_size = 50
    },
    {
      durability = 1,
      durability_description_key = "description.science-pack-remaining-amount-key",
      durability_description_value = "description.science-pack-remaining-amount-value",
      icon = "__modmashsplinternewworlds__/graphics/icons/alien-science-pack.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "alien-science-pack",
      order = "g[zalien-science-pack]",
      stack_size = 200,
      subgroup = "science-pack",
      type = "tool"
    },
})

