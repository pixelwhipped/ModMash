data:extend(
{
  {
    type = "assembling-machine",
	stack_size = 50,
    name = "recycling-machine",
    icon = "__modmashsplinterrecycling__/graphics/icons/recycling-machine.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "recycling-machine"},
    max_health = 600,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances = 
    {
      {
        type = "fire",
        percent = 70
      }
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t3-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t3-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    fast_replaceable_group = "assembling-machine",
    animation = {
        layers = {
            {
                filename = "__modmashsplinterrecycling__/graphics/entity/recycling-machine/recycling-machine.png",
                frame_count = 32,
                height = 119, 
                hr_version = {
                    filename = "__modmashsplinterrecycling__/graphics/entity/recycling-machine/hr-recycling-machine.png",
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
                width = 108,
            },
            {
                draw_as_shadow = true,
                filename = "__modmashsplinterrecycling__/graphics/entity/recycling-machine/assembling-machine-shadow.png",
                frame_count = 32,
                height = 87,
                hr_version = {
                    draw_as_shadow = true,
                    filename = "__modmashsplinterrecycling__/graphics/entity/recycling-machine/hr-assembling-machine-shadow.png",
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
    source_inventory_size = 2,
    result_inventory_size = 5,
    crafting_categories = {"recycling"},
    crafting_speed = 1,
    energy_source =
    {	  
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 3
    },
    energy_usage = "240kW",
    ingredient_count = 10,
    module_specification =
    {
      module_slots = 5,
      module_info_icon_shift = {0, 0.5},
      module_info_multi_row_initial_height_modifier = -0.3
    },
	fluid_boxes =
    {
      {
		base_area = 10,
		base_level = 1,
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
		production_type = "output",
		pipe_connections =
		{
			{
				position = {0, -2},
				type = "output"
			}
		},		
      },
	  off_when_no_fluid_recipe = false
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}
  }
}
)