if data_final_fixes then
	data.raw["assembling-machine"]["assembling-machine-3"].next_upgrade = "assembling-machine-4"
else
    data:extend(
    {
        {
		    type = "assembling-machine",
		    name = "assembling-machine-burner",
		    icon = "__modmashsplinterassembling__/graphics/icons/assembling-machine-0.png",
		    icon_size = 64,
            icon_mipmaps = 4,        
		    flags = {"placeable-neutral", "placeable-player", "player-creation"},
		    minable = {mining_time = 0.2, result = "assembling-machine-burner"},
		    max_health = 150,
		    corpse = "big-remnants",
		    dying_explosion = "medium-explosion",
		    resistances =
		    {
		      {
			    type = "fire",
			    percent = 70
		      }
		    },
		    collision_box = {{-0.6, -0.6}, {0.6, 0.6}},
		    selection_box = {{-0.75, -0.75}, {0.75, 0.75}},
		    alert_icon_shift = util.by_pixel(-3, -12),
            scale_entity_info_icon = true,
		    animation =
		    {
		      layers =
		      {
			    {
			      filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-0/assembling-machine-0.png",
			      priority="high",
			      width = 108,
			      height = 114,
			      frame_count = 32,
			      line_length = 8,
			      scale= 0.5,
			      shift = util.by_pixel(0, 2),
			      hr_version =
			      {
				    filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-0/hr-assembling-machine-0.png",
				    priority="high",
				    width = 214,
				    height = 226,
				    frame_count = 32,
				    line_length = 8,
				    shift = util.by_pixel(0, 2),
				    scale = 0.25
			      }
			    },
			    {
			      filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-0/assembling-machine-0-shadow.png",
			      priority="high",
			      width = 95,
			      height = 83,
			      frame_count = 1,
			      line_length = 1,
			      repeat_count = 32,
			      draw_as_shadow = true,
			      shift = util.by_pixel(8.5, 5.5),
			      scale= 0.5,
			      hr_version =
			      {
				    filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-0/hr-assembling-machine-0-shadow.png",
				    priority="high",
				    width = 190,
				    height = 165,
				    frame_count = 1,
				    line_length = 1,
				    repeat_count = 32,
				    draw_as_shadow = true,
				    shift = util.by_pixel(8.5, 5),
				    scale = 0.25
			      }
			    }
		      }
		    },
		    crafting_categories = {"crafting"},
		    crafting_speed = 0.25,
		    energy_source =
		    {
		      type = "burner",
		      fuel_category = "chemical",
		      effectivity = 1,
		      fuel_inventory_size = 1,
		      emissions_per_minute = 12,
		      smoke =
		      {
			    {
			      name = "smoke",
			      deviation = {0.1, 0.1},
			      frequency = 5
			    }
		      }
		    },
		    energy_usage = "75kW",
		    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
		    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
		    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
		    working_sound =
		    {
		      sound =
		      {
			    {
			      filename = "__base__/sound/assembling-machine-t1-1.ogg",
			      volume = 0.8
			    },
			    {
			      filename = "__base__/sound/assembling-machine-t1-2.ogg",
			      volume = 0.8
			    }
		      },
		      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		      apparent_volume = 1.5
		    }
	    },
        {
            type = "assembling-machine",
            name = "assembling-machine-4",
            icon = "__modmashsplinterassembling__/graphics/icons/assembling-machine-4.png",
            icon_size = 64,
            icon_mipmaps = 4,        
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
                    filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-4/assembling-machine-4.png",
                    frame_count = 32,
                    height = 119, --124,
                    hr_version = {
                        filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-4/hr-assembling-machine-4.png",
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
                    filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-4/assembling-machine-shadow.png",
                    frame_count = 32,
                    height = 87,
                    hr_version = {
                        draw_as_shadow = true,
                        filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-4/hr-assembling-machine-shadow.png",
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
            crafting_categories = {"crafting", "advanced-crafting", "crafting-with-fluid"},
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
        },
        {
            type = "assembling-machine",
            name = "assembling-machine-5",
            icon = "__modmashsplinterassembling__/graphics/icons/assembling-machine-5.png",
            icon_size = 64,
            icon_mipmaps = 4,        
            flags = {"placeable-neutral","placeable-player", "player-creation"},
            minable = {hardness = 0.2, mining_time = 0.5, result = "assembling-machine-5"},
            max_health = 600,
            healing_per_tick = modmashsplinterassembling.util.defines.healing_per_tick,
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
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = -1,
                pipe_connections = {{ type="input", position = {0, -2} }}
              },
              {
                production_type = "output",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = 1,
                pipe_connections = {{ type="output", position = {0, 2} }}
              },
              off_when_no_fluid_recipe = true
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
            alert_icon_shift = {
                -0.09375,
                -0.375
              },
              animation = {
                layers = {
		          {
                    filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-5/assembling-machine-5.png",
                    frame_count = 32,
                    height = 119, --124,
                    hr_version = {
                      filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-5/hr-assembling-machine-5.png",
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
                    filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-4/assembling-machine-shadow.png",
                    frame_count = 32,
                    height = 87,
                    hr_version = {
                      draw_as_shadow = true,
                      filename = "__modmashsplinterassembling__/graphics/entity/assembling-machine-4/hr-assembling-machine-shadow.png",
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
            crafting_categories = {"crafting", "advanced-crafting", "crafting-with-fluid"},
            crafting_speed = 4,
            energy_source =
            {
              type = "electric",
              usage_priority = "secondary-input",
              emissions_per_minute  = 2
            },
            energy_usage = "480kW",
            ingredient_count = 6,
            module_specification =
            {
              module_slots = 6,
              module_info_icon_shift = {0, 0.5},
              module_info_multi_row_initial_height_modifier = -0.3
            },
            allowed_effects = {"consumption", "speed", "productivity", "pollution"}
        }
    })
end