--[[Code check 29.2.20
no change
--]]
data:extend(
{
  {
    type = "recipe",
    name = "dredge-pump",
    ingredients =
    {
      {"electronic-circuit", 2},
      {"pipe", 1},
      {"iron-gear-wheel", 2}
    },
    result = "dredge-pump"
  },
  {
    type = "recipe",
    name = "sludge-to-stone",
	category = "crafting-with-fluid",
	icon = "__modmashgraphics__/graphics/icons/sludge-to-stone.png",
	icon_size = 32,
	subgroup = "intermediate-product",
	order = "s[sludge-to-stone]",
    ingredients =
    {
      {type = "fluid", name = "sludge", amount = 50},
    },
    result = "stone"
  },
  {
    type = "item",
    name = "dredge-pump",
    icon = "__modmashgraphics__/graphics/icons/dredge-pump.png",
    icon_size = 32,
    subgroup = "extraction-machine",
    order = "b[fluids]-a[offshore-pump-dredge]",
    place_result = "dredge-pump",
    stack_size = 20
  },
  {
    type = "offshore-pump",
    name = "dredge-pump",
    icon = "__modmashgraphics__/graphics/icons/dredge-pump.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "filter-directions"},
    collision_mask = { "ground-tile", "object-layer" },
    fluid_box_tile_collision_test = { "ground-tile" },
    adjacent_tile_collision_test = { "water-tile" },
    minable = {mining_time = 0.1, result = "dredge-pump"},
    max_health = 150,
    corpse = "small-remnants",
    fluid = "sludge",
	pumping_speed = 5,
    resistances =
    {
      {
        type = "fire",
        percent = 70
      },
      {
        type = "impact",
        percent = 30
      }
    },
    collision_box = {{-0.6, -1.05}, {0.6, 0.3}},
    selection_box = {{-1, -1.49}, {1, 0.49}},
    fluid_box =
    {
      base_area = 1,
      base_level = 1,
      pipe_covers = pipecoverspictures(),
      production_type = "output",
      filter = "water",
      pipe_connections =
      {
        {
          position = {0, 1},
          type = "output"
        }
      }
    },
    pumping_speed = 5,
    tile_width = 1,
    tile_height = 1,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      north =
      {
        filename = "__modmashgraphics__/graphics/entity/dredge-pump/dredge-pump.png",
        priority = "high",
        shift = {0.90625, 0.0625},
        width = 160,
        height = 102
      },
      east =
      {
        filename = "__modmashgraphics__/graphics/entity/dredge-pump/dredge-pump.png",
        priority = "high",
        shift = {0.90625, 0.0625},
        x = 160,
        width = 160,
        height = 102
      },
      south =
      {
        filename = "__modmashgraphics__/graphics/entity/dredge-pump/dredge-pump.png",
        priority = "high",
        shift = {0.90625, 0.65625},
        x = 320,
        width = 160,
        height = 102
      },
      west =
      {
        filename = "__modmashgraphics__/graphics/entity/dredge-pump/dredge-pump.png",
        priority = "high",
        shift = {1.0, 0.0625},
        x = 480,
        width = 160,
        height = 102
      }
    },
    placeable_position_visualization =
    {
      filename = "__core__/graphics/cursor-boxes-32x32.png",
      priority = "extra-high-no-scale",
      width = 64,
      height = 64,
      scale = 0.5,
      x = 3*64
    },
    circuit_wire_connection_points = circuit_connector_definitions["offshore-pump"].points,
    circuit_connector_sprites = circuit_connector_definitions["offshore-pump"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }
})
