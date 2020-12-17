require("prototypes.scripts.defines") 
local underground_accumulator  = modmashsplinterunderground.defines.names.underground_accumulator
local underground_access  = modmashsplinterunderground.defines.names.underground_access
local underground_access2  = modmashsplinterunderground.defines.names.underground_access2
local underground_accessml  = modmashsplinterunderground.defines.names.underground_accessml
local used_battery_cell  = modmashsplinterunderground.defines.names.used_battery_cell
local battery_cell  = modmashsplinterunderground.defines.names.battery_cell
data:extend(
{
{
    type = "item",
    name = underground_accessml,
    icon = "__modmashsplinterunderground__/graphics/icons/underground-accessml.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "u[underground-access3]",
    place_result = underground_accessml,
    stack_size = 10
  },
  {
    type = "item",
    name = underground_access,
    icon = "__modmashsplinterunderground__/graphics/icons/underground-access.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "u[underground-access]",
    place_result = underground_access,
    stack_size = 10
  },
  {
    type = "item",
    name = underground_access2,
    icon = "__modmashsplinterunderground__/graphics/icons/underground-access2.png",
	icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "v[underground-access2]",
    place_result = underground_access2,
    stack_size = 10
  },
  {
    type = "item",
    name = underground_accumulator,
    icon = "__modmashsplinterunderground__/graphics/icons/underground-accumulator.png",
	icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "w[underground-accumulator]",
    place_result = underground_accumulator,
    stack_size = 10
  },
  {
    type = "item",
    name = battery_cell,
    icon = "__modmashsplinterunderground__/graphics/icons/battery-cell.png",
	icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "w[battery-cell]",
    place_result = battery_cell,
    stack_size = 10
  },
   {
    type = "item-with-tags",
    name = used_battery_cell,
    icon = "__modmashsplinterunderground__/graphics/icons/used-battery-cell.png",
	icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "w[used-battery-cell]",
    place_result = used_battery_cell,
    stack_size = 10
  }
})
