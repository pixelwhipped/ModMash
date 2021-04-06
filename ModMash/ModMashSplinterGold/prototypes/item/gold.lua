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
  },
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

data:extend(
{
  {
    type = "item",
    name = "gold-statue",
    icon = "__modmashsplintergold__/graphics/icons/statue.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "defensive-structure",
    place_result = "gold-statue",
    order = "e[rocket-silo][statue]",
    stack_size = 1
  },
  {
    type = "simple-entity",
    name = "gold-statue",
    icon = "__modmashsplintergold__/graphics/icons/statue.png",
    icon_mipmaps = 4,
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "filter-directions"},
    minable = {mining_time = 20, result = "gold-statue"},
    max_health = 5000,
    {
      {
        type = "fire",
        percent = 90
      },
      {
        type = "impact",
        percent = 60
      }
    },
    collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture = {
        filename = "__modmashsplintergold__/graphics/entity/gold-statue.png",
        priority = "high",
        shift = {3.25,-2.25},
        width = 323,
        height = 243
	}
  }
})