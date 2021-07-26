require ("prototypes.scripts.defines")

require ("prototypes.item.blank-circuit")
require ("prototypes.item.ai-circuit")

data:extend(
{
  {
        type = "produce-achievement",
        name = "mass-blank_circuit-production-1",
        order = "d[production]-a[blank-circuit-production]-a",
        icon = "__modmashsplinterelectronics__/graphics/achievement/blank-circuit-production-1.png",
        amount = 10000,
        item_product = "blank-circuit",
        limited_to_one_game = false,
        icon_size = 128
  },
  {
        type = "produce-achievement",
        name = "mass-blank_circuit-production-2",
        order = "d[production]-a[blank-circuit-production]-a",
        icon = "__modmashsplinterelectronics__/graphics/achievement/blank-circuit-production-2.png",
        amount = 1000000,
        item_product = "blank-circuit",
        limited_to_one_game = false,
        icon_size = 128
  },
  {
        type = "produce-achievement",
        name = "mass-blank_circuit-production-3",
        order = "d[production]-a[blank-circuit-production]-c",
        icon = "__modmashsplinterelectronics__/graphics/achievement/blank-circuit-production-3.png",
        amount = 20000000,
        item_product = "blank-circuit",
        limited_to_one_game = false,
        icon_size = 128
  },
  {
        amount = 5000,
        icon = "__modmashsplinterelectronics__/graphics/achievement/blank-circuit-production-1.png",
        icon_size = 128,
        item_product = "blank-circuit",
        name = "blank-circuit-veteran-1",
        order = "d[production]-a[blank-circuit-production]-d",
        type = "produce-per-hour-achievement",
        limited_to_one_game = false
  },
})

table.insert(data.raw["technology"]["advanced-electronics"].effects,{type = "unlock-recipe",recipe = "advanced-circuit-with-ai-circuit"})