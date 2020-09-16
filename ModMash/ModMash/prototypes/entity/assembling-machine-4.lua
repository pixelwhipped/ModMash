--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "assembling-machine",
    name = "assembling-machine-4",
    icon = "__modmashgraphics__/graphics/icons/assembling-machine-4.png",
    icon_size = 32,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "assembling-machine-4"},
    max_health = 500,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    },
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }}
      },
      {
        production_type = "output",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0, 2} }}
      },
      off_when_no_fluid_recipe = true
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    fast_replaceable_group = "assembling-machine",
	alert_icon_shift = {
        -0.09375,
        -0.375
      },
      animation = {
        layers = {
          {
            filename = "__modmashgraphics__/graphics/entity/assembling-machine-4/assembling-machine-4.png",
            frame_count = 32,
            height = 119, --124,
            hr_version = {
              filename = "__modmashgraphics__/graphics/entity/assembling-machine-4/hr-assembling-machine-4.png",
              frame_count = 32,
              height = 247,
              line_length = 8,
              priority = "high",
              scale = 0.5,
              shift = {
                0,
                -0.0234375
              },
              width = 214
            },
            line_length = 8,
            priority = "high",
            shift = {
              0,
              -0.015625
            },
            width = 108
          },
          {
            draw_as_shadow = true,
            filename = "__modmashgraphics__/graphics/entity/assembling-machine-4/assembling-machine-shadow.png",
            frame_count = 32,
            height = 87,
            hr_version = {
              draw_as_shadow = true,
              filename = "__modmashgraphics__/graphics/entity/assembling-machine-4/hr-assembling-machine-shadow.png",
              frame_count = 32,
              height = 172,
              line_length = 8,
              priority = "high",
              scale = 0.5,
              shift = {
                0.875,
                0.125
              },
              width = 260
            },
            line_length = 8,
            priority = "high",
            shift = {
              0.875,
              0.125
            },
            width = 130
          }
        }
      },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t2-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t2-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_categories = {"crafting", "advanced-crafting", "crafting-with-fluid","containment"},
    crafting_speed = 2.5,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute  = 2
    },
    energy_usage = "360kW",
    ingredient_count = 6,
    module_specification =
    {
      module_slots = 5,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},

  }
}
)

if data_final_fixes then
	data.raw["assembling-machine"]["assembling-machine-3"].next_upgrade = "assembling-machine-4"
end