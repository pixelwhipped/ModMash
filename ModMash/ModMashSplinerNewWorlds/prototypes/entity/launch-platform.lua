    
data:extend(
{
    {
      circuit_wire_connection_point = circuit_connector_definitions["assembling-machine"].points,
      circuit_connector_sprites = circuit_connector_definitions["assembling-machine"].sprites,
	  circuit_wire_max_distance = default_circuit_wire_max_distance,
      allow_copy_paste = true,
      close_sound = {
        filename = "__base__/sound/metallic-chest-close.ogg",
        volume = 0.42999999999999998
      },
      collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
      selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
      corpse = "big-remnants",
	  dying_explosion = "medium-explosion",
      damaged_trigger_effect = {
        damage_type_filters = "fire",
        entity_name = "spark-explosion",
        offset_deviation = {
          {
            -0.5,
            -0.5
          },
          {
            0.5,
            0.5
          }
        },
        offsets = {
          {
            0,
            1
          }
        },
        type = "create-entity"
      },
      flags = {
        "placeable-neutral",
        "player-creation"
      },
      icon = "__modmashsplinternewworlds__/graphics/icons/launch-platform-icon.png",
      icon_mipmaps = 4,
      icon_size = 64,
      inventory_size = 128,
      max_health = 500,
      minable = {
        mining_time = 0.2,
        result = "launch-platform"
      },
      name = "launch-platform",
      open_sound = {
        filename = "__base__/sound/metallic-chest-open.ogg",
        volume = 0.42999999999999998
      },
      picture = {
        layers = {
          {
            filename = "__modmashsplinternewworlds__/graphics/entity/launch-platform/launch-platform.png",
            height = 113,
            hr_version = {
              filename = "__modmashsplinternewworlds__/graphics/entity/launch-platform/hr-launch-platform.png",
              height = 226,
              priority = "extra-high",
              scale = 0.5,
              shift = {
                -0.0078125,
                -0.015625
              },
              width = 214
            },
            priority = "extra-high",
            shift = {
              0,
              -0.015625
            },
            width = 107
          },
        }
      },
      resistances = {
        {
          percent = 90,
          type = "fire"
        },
        {
          percent = 60,
          type = "impact"
        }
      },
      type = "container",
      vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    }
})