require ("prototypes.scripts.defines")

require ("prototypes.item.underground")
require ("prototypes.entity.underground")
require ("prototypes.recipe.underground")
require ("prototypes.technology.underground")
require ("prototypes.tile.underground")

require ("prototypes.entity.rocks")
require ("prototypes.entity.rail")

data:extend(
{
    {
        type = "achievement",
        name = "hollow_earth",
        order = "g[secret]-a[hollow_earth]",
        icon = "__mms2underground__/graphics/achievement/hollow_earth.png",
        icon_size = 128
    }
})


data:extend(
{
    {
        type = "custom-input",
        name = "enter-subway-input",
        key_sequence = "ENTER",
        consuming = "none"
    }
})