--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
{
    type = "technology",
    name = "spawner",
    icon = "__base__/graphics/technology/demo/analyse-ship.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "spawner"
      }
    },
    prerequisites =
    {
    },
    unit =
    {
      count = 300,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  },
  {
    type = "technology",
    name = "enrichment",
    icon = "__modmash__/graphics/technology/chemistry.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "stone-enrichment-process"
      },{
        type = "unlock-recipe",
        recipe = "coal-enrichment-process"
      },{
        type = "unlock-recipe",
        recipe = "iron-enrichment-process"
      },{
        type = "unlock-recipe",
        recipe = "fish-conversion"
      },{
        type = "unlock-recipe",
        recipe = "fish-juice"
      }
    },
    prerequisites =
    {
      "automation-2"
    },
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  },{
    type = "technology",
    name = "enrichment-2",
	--localised_name = "Enrichment 2",
	localised_description = {"technology-description.enrichment"}, --"Refines materials to obtain more usefull components",
    icon = "__modmash__/graphics/technology/chemistry.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process"
      },{
        type = "unlock-recipe",
        recipe = "uranium-enrichment-process"
      },{
        type = "unlock-recipe",
        recipe = "copper-enrichment-process"
      }
    },
    prerequisites =
    {
      "enrichment"
    },
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  },{
    type = "technology",
    name = "enrichment-3",
	localised_description = {"technology-description.enrichment"},
    icon = "__modmash__/graphics/technology/advanced-chemistry.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "titanium-extraction-process"
      },
      {
        type = "unlock-recipe",
        recipe = "fish-conversion-light-oil"
      },
      {
        type = "unlock-recipe",
        recipe = "fish-conversion-lubricant"
      },
	  {
        type = "unlock-recipe",
        recipe = "light-oil-conversion-crude-oil"
      }
    },
    prerequisites =
    {
      "enrichment-2"
    },
    unit =
    {
      count = 300,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  }

  ,{
    type = "technology",
    name = "enrichment-4",
	localised_description = {"technology-description.enrichment"},
    icon = "__modmash__/graphics/technology/advanced-chemistry.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-stone"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-iron"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-ore"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-artifact-enrichment-process-to-ore"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-copper"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-coal"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-titanium"
      },
	  {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-uranium"
      },{
        type = "unlock-recipe",
        recipe = "alien-ooze"
      },{
        type = "unlock-recipe",
        recipe = "ooze-juice"
      }
    },
    prerequisites =
    {
      "enrichment-3"
    },
    unit =
    {
      count = 400,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  }

  ,{
    type = "technology",
    name = "enrichment-5",
	localised_description = {"technology-description.enrichment"},
    icon = "__modmash__/graphics/technology/advanced-chemistry.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "alien-enrichment-process-to-artifact"
      }
    },
    prerequisites =
    {
      "enrichment-3"
    },
    unit =
    {
      count = 400,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
      },
      time = 45
    },
    upgrade = true,
    order = "a-b-d",
  }
}
)

table.insert(
  data.raw["technology"]["oil-processing"].effects,
  {type = "unlock-recipe",recipe = "petroleum-gas-from-solid-fuel"})