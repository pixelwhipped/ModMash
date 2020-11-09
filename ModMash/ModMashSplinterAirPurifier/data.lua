require ("prototypes.scripts.defines")

require("prototypes.categories.air-purifier")
require("prototypes.item.air-purifier")
require("prototypes.recipe.air-purifier")
require("prototypes.entity.air-purifier")
require("prototypes.technology.air-purifier")
data:extend(
{
  {
    type = "achievement",
    name = "blue-skies",
    order = "g[secret]-a[blue-skies]",
    icon = "__modmashsplinterairpurifier__/graphics/achievement/blue-sky.png",
    icon_size = 128
  }
})