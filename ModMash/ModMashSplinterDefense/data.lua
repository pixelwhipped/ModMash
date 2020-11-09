require ("prototypes.scripts.defines")
require("prototypes.scripts.util")

require ("prototypes.item.underground")
require ("prototypes.entity.underground")
require ("prototypes.recipe.underground")
require ("prototypes.technology.underground")

require ("prototypes.entity.rocks")

data:extend(
{
  {
    type = "achievement",
    name = "hollow_earth",
    order = "g[secret]-a[hollow_earth]",
    icon = "__modmashsplinterunderground__/graphics/achievement/hollow_earth.png",
    icon_size = 128
  }
})