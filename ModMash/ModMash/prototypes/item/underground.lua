require("prototypes.scripts.defines") 
local underground_accumulator  = modmash.defines.names.underground_accumulator
local underground_access  = modmash.defines.names.underground_access
local underground_access2  = modmash.defines.names.underground_access2
data:extend(
{
  {
    type = "item",
    name = underground_access,
    icon = "__modmashgraphics__/graphics/icons/underground-access.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "u[underground-access]",
    place_result = underground_access,
    stack_size = 10
  },
  {
    type = "item",
    name = underground_access2,
    icon = "__modmashgraphics__/graphics/icons/underground-access2.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "v[underground-access2]",
    place_result = underground_access2,
    stack_size = 10
  },
  {
    type = "item",
    name = "underground-accumulator",
    icon = "__modmashgraphics__/graphics/icons/underground-accumulator.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "w[underground-accumulator]",
    place_result = "underground-accumulator",
    stack_size = 10
  },
  {
    type = "item",
    name = "battery-cell",
    icon = "__modmashgraphics__/graphics/icons/battery-cell.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "w[battery-cell]",
    place_result = "battery-cell",
    stack_size = 10
  },
   {
    type = "item",
    name = "used-battery-cell",
    icon = "__modmashgraphics__/graphics/icons/used-battery-cell.png",
    icon_size = 32,
    subgroup = "production-machine",
    order = "w[used-battery-cell]",
    place_result = "used-battery-cell",
    stack_size = 10
  }
})
