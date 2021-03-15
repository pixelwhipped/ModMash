require ("prototypes.scripts.defines")

require("prototypes.item.gold") 
require("prototypes.recipe.gold") 

data:extend(
{
  {
    type = "achievement",
    name = "gold-rush",
    order = "d[production]-z[gold-rush]",
    icon = "__modmashsplintergold__/gold.png",
    amount = 20000,
    item_product = "gold-ore",
    icon_size = 128
  }
})