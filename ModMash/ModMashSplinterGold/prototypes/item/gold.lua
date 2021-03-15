require("prototypes.scripts.defines") 

if data.raw.item["gold-ore"] == nil then
data:extend(
{
  {
    type = "item",
    name = "gold-ore",
    icon = "__modmashsplintergold__/graphics/icons/gold-ore.png",
    icon_mipmaps = 4,
    icon_size = 64,
    pictures = {
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-1.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-2.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplintergold__/graphics/icons/gold-ore-3.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        }
    },
    subgroup = "raw-resource",    
    order = "g[gold-ore]",
    stack_size = 100
  }
})
end

if data.raw.item["gold-plate"] == nil then
data:extend(
{
  {
    type = "item",
    name = "gold-plate",
    icon = "__modmashsplintergold__/graphics/icons/gold-plate.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "raw-material",
    order = "d[gold-plate]",
    stack_size = 100
  }
})
end

if data.raw.item["gold-cable"] == nil then
data:extend(
 {
  {
    type = "item",
    name = "gold-cable",
    icon = "__modmashsplintergold__/graphics/icons/gold-cable.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "a[copper-cable][gold-wire]",
    stack_size = 200,
	wire_count = 1
  }
})
end