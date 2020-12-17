require("prototypes.scripts.defines") 

local underground_accumulator  = modmashsplinterunderground.defines.names.underground_accumulator
local underground_access2  = modmashsplinterunderground.defines.names.underground_access2
local underground_accessml  = modmashsplinterunderground.defines.names.underground_accessml
local recharged_battery_cell  = modmashsplinterunderground.defines.names.recharged_battery_cell
local battery_cell  = modmashsplinterunderground.defines.names.battery_cell

table.insert(
  data.raw["technology"]["battery"].effects,
  {type = "unlock-recipe",recipe = underground_accumulator})
 
 data:extend(
 {
  {
	type = "technology",
    name = "underground",
    icon = "__base__/graphics/technology/logistics-1.png",
    icon_size = 256, icon_mipmaps = 4,
    effects = {
	  {
        type = "unlock-recipe",
        recipe = underground_access2
      },
      {
        type = "unlock-recipe",
        recipe = underground_accumulator
      },{
        type = "unlock-recipe",
        recipe = recharged_battery_cell
      },	  
	  {
        type = "unlock-recipe",
        recipe = battery_cell
      }
	},
    prerequisites = {"logistics-3"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
      },
      time = 15
    },
    order = "a-f-d"
  },
  {
	type = "technology",
    name = "underground2",
    icon = "__base__/graphics/technology/logistics-1.png",
    icon_size = 256, icon_mipmaps = 4,
    effects = {
	  {
        type = "unlock-recipe",
        recipe = underground_accessml
      }
	},
    prerequisites = {"underground"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"automation-science-pack", 3},
        {"logistic-science-pack", 3},	
      },
      time = 15
    },
    order = "a-f-d"
  }
  })