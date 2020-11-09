data:extend(
{
  {
    type = "assembling-machine",
    name = modmashsplinterairpurifier.defines.names.air_purifier,

    icon = "__modmashsplinterairpurifier__/graphics/icons/air-purifier.png",
	icon_size = 64,
    icon_mipmaps = 4,           
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, result = modmashsplinterairpurifier.defines.names.air_purifier},
    max_health = 250,
    crafting_categories = {modmashsplinterairpurifier.defines.names.air_purifier},
    crafting_speed = modmashsplinterairpurifier.defines.air_purifier.entity_crafting_speed,
    ingredient_count = 1,
    module_specification = nil,
    allowed_effects = nil,
    fast_replaceable_group = nil,
    corpse = "big-remnants",
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
		base_area = 10,
		base_level = 1,
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
		production_type = "output",
		pipe_connections =
		{
			{
				position = {0, 2},
				type = "output"
			}
		},		
      },
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
	always_draw_idle_animation = false,
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute  = modmashsplinterairpurifier.defines.air_purifier.entity_energy_source_emissions_per_minute,
	  drain = modmashsplinterairpurifier.defines.air_purifier.entity_energy_source_drain,
    },
    energy_usage = modmashsplinterairpurifier.defines.air_purifier.entity_energy_usage,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound = {
        audible_distance_modifier = 0.5,
        fade_in_ticks = 4,
        fade_out_ticks = 20,
        match_speed_to_activity = true,
        max_sounds_per_type = 3,
        sound = {
          filename = "__base__/sound/steam-engine-90bpm.ogg",
          volume = 0.08
        }
      },
    animation =
    {
      layers =
      {
        {
          filename = "__modmashsplinterairpurifier__/graphics/entity/air-purifier/air-purifier.png",
          priority = "high",
          width = 107,
          height = 113,
          frame_count = 8,
          line_length = 8,
          shift = {
              0,
              0.0625
          },
          hr_version = {
              filename = "__modmashsplinterairpurifier__/graphics/entity/air-purifier/hr-air-purifier.png",
              priority = "high",              
              width = 214,
              height = 226,
              frame_count = 8,
              line_length = 8,              
              scale = 0.5,
              shift = {
                0,
                0.0625
              },          
          },
        },
      }
    },
  },
  {
    type = "assembling-machine",
    name = modmashsplinterairpurifier.defines.names.advanced_air_purifier,

    icon = "__modmashsplinterairpurifier__/graphics/icons/air-purifier.png",
	icon_size = 64,
    icon_mipmaps = 4,           
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, result = modmashsplinterairpurifier.defines.names.advanced_air_purifier},
    max_health = 250,
    crafting_categories = {modmashsplinterairpurifier.defines.names.air_purifier},
    crafting_speed = modmashsplinterairpurifier.defines.advanced_air_purifier.entity_crafting_speed,
    ingredient_count = 1,
    module_specification = nil,
    allowed_effects = nil,
    fast_replaceable_group = nil,
    corpse = "big-remnants",
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
		base_area = 10,
		base_level = 1,
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
		production_type = "output",
		pipe_connections =
		{
			{
				position = {0, 2},
				type = "output"
			}
		},		
      },
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
	always_draw_idle_animation = false,
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute  = modmashsplinterairpurifier.defines.advanced_air_purifier.entity_energy_source_emissions_per_minute,
	  drain = modmashsplinterairpurifier.defines.air_purifier.entity_energy_source_drain,
    },
    energy_usage = modmashsplinterairpurifier.defines.advanced_air_purifier.entity_energy_usage,
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound = {
        audible_distance_modifier = 0.5,
        fade_in_ticks = 4,
        fade_out_ticks = 20,
        match_speed_to_activity = true,
        max_sounds_per_type = 3,
        sound = {
          filename = "__base__/sound/steam-engine-90bpm.ogg",
          volume = 0.08
        }
      },
    animation =
    {
      layers =
      {
        {
          filename = "__modmashsplinterairpurifier__/graphics/entity/air-purifier/air-purifier-2.png",
          priority = "high",
          width = 107,
          height = 124,
          frame_count = 8,
          line_length = 8,
          shift = {
              0,
              0.0625
          },
          hr_version = {
              filename = "__modmashsplinterairpurifier__/graphics/entity/air-purifier/hr-air-purifier-2.png",
              priority = "high",              
              width = 214,
              height = 247,
              frame_count = 8,
              line_length = 8,              
              scale = 0.5,
              shift = {
                0,
                0.0625
              },          
          },
        },
      }
    },
  },
}
)