data:extend(
{
  {
    type = "item",
    name = modmashsplinterairpurifier.defines.names.air_purifier,
    icon = "__modmashsplinterairpurifier__/graphics/icons/air-purifier.png",
	icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "h[a][" .. modmashsplinterairpurifier.defines.names.air_purifier .. "]",
    place_result = modmashsplinterairpurifier.defines.names.air_purifier,
    stack_size = 50
  },{
    type = "item",
    name = modmashsplinterairpurifier.defines.names.advanced_air_purifier,
    icon = "__modmashsplinterairpurifier__/graphics/icons/air-purifier-2.png",
	icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "production-machine",
    order = "h[b][" .. modmashsplinterairpurifier.defines.names.advanced_air_purifier .. "]",
    place_result = modmashsplinterairpurifier.defines.names.advanced_air_purifier,
    stack_size = 50
  }
}
)