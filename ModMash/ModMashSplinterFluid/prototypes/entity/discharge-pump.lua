data:extend(
{
  	{
    type = "offshore-pump",
    name = "mm-discharge-water-pump",
    icon = "__modmashsplinterfluid__/graphics/icons/discharge-pump.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "filter-directions"},
    collision_mask = { "ground-tile", "object-layer" },
    fluid_box_tile_collision_test = { "ground-tile" },
    adjacent_tile_collision_test = { "water-tile" },
    minable = {mining_time = 1, result = "mm-discharge-water-pump"},
    max_health = 150,
    corpse = "small-remnants",
    fluid = "water",
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
      production_type = "input",
      pipe_connections =
      {
        {
          position = {0, 1},
          type = "input"
        }
      }
    },
    pumping_speed = 0.001,
    tile_width = 1,
    tile_height = 1,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    picture =
    {
      north =
      {
        filename = "__modmashsplinterfluid__/graphics/entity/discharge-pump/discharge-pump.png",
        priority = "high",
        shift = {0.90625, 0.0625},
        width = 160,
        height = 102
      },
      east =
      {
        filename = "__modmashsplinterfluid__/graphics/entity/discharge-pump/discharge-pump.png",
        priority = "high",
        shift = {0.90625, 0.0625},
        x = 160,
        width = 160,
        height = 102
      },
      south =
      {
        filename = "__modmashsplinterfluid__/graphics/entity/discharge-pump/discharge-pump.png",
        priority = "high",
        shift = {0.90625, 0.65625},
        x = 320,
        width = 160,
        height = 102
      },
      west =
      {
        filename = "__modmashsplinterfluid__/graphics/entity/discharge-pump/discharge-pump.png",
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