require ("prototypes.scripts.defines")
require ("prototypes.categories.them")
require ("prototypes.item")
require ("prototypes.concrete")
require ("prototypes.entity.beams")
require ("prototypes.entity.bot")
require ("prototypes.entity.chest")
require ("prototypes.entity.logistics")
require ("prototypes.entity.pole")
require ("prototypes.entity.port")
require ("prototypes.entity.solar")
require ("prototypes.entity.pinch")
require ("prototypes.entity.them-matter-artillery")

data:extend(
{
  {
    type = "achievement",
    name = "them_arrival",
    order = "g[secret]-t[them_arrival]",
    icon = "__modmashsplinterthem__/graphics/achievement/them.png",
    icon_size = 128
  },{
    type = "achievement",
    name = "them_end_game",
    order = "g[secret]-t[them_end_game]",
    icon = "__modmashsplinterthem__/graphics/achievement/them.png",
    icon_size = 128
  },{
    type = "achievement",
    name = "them_oppenheimer",
    order = "g[secret]-t[them_oppenheimer]",
    icon = "__modmashsplinterthem__/graphics/achievement/them.png",
    icon_size = 128
  }
})
