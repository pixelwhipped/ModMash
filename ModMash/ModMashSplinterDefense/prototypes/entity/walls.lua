local local_get_remnants = function(name)
    data:extend({ {
      animation = {
        {
          direction_count = 2,
          filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/wall-remnants.png",
          frame_count = 1,
          height = 58,
          hr_version = {
            direction_count = 2,
            filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/hr-wall-remnants.png",
            frame_count = 1,
            height = 114,
            line_length = 1,
            scale = 0.5,
            shift = {
              0.09375,
              0.234375
            },
            width = 118,
            y = 0
          },
          line_length = 1,
          shift = {
            0.09375,
            0.234375
          },
          width = 60,
          y = 0
        },
        {
          direction_count = 2,
          filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/wall-remnants.png",
          frame_count = 1,
          height = 58,
          hr_version = {
            direction_count = 2,
            filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/hr-wall-remnants.png",
            frame_count = 1,
            height = 114,
            line_length = 1,
            scale = 0.5,
            shift = {
              0.09375,
              0.234375
            },
            width = 118,
            y = 228
          },
          line_length = 1,
          shift = {
            0.09375,
            0.234375
          },
          width = 60,
          y = 116
        },
        {
          direction_count = 2,
          filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/wall-remnants.png",
          frame_count = 1,
          height = 58,
          hr_version = {
            direction_count = 2,
            filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/hr-wall-remnants.png",
            frame_count = 1,
            height = 114,
            line_length = 1,
            scale = 0.5,
            shift = {
              0.09375,
              0.234375
            },
            width = 118,
            y = 456
          },
          line_length = 1,
          shift = {
            0.09375,
            0.234375
          },
          width = 60,
          y = 232
        },
        {
          direction_count = 2,
          filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/wall-remnants.png",
          frame_count = 1,
          height = 58,
          hr_version = {
            direction_count = 2,
            filename = "__modmashsplinterdefense__/graphics/entity/"..name.."/remnants/hr-wall-remnants.png",
            frame_count = 1,
            height = 114,
            line_length = 1,
            scale = 0.5,
            shift = {
              0.09375,
              0.234375
            },
            width = 118,
            y = 684
          },
          line_length = 1,
          shift = {
            0.09375,
            0.234375
          },
          width = 60,
          y = 348
        }
      },
      collision_box = {
        {
          -0.4,
          -0.4
        },
        {
          0.4,
          0.4
        }
      },
      final_render_layer = "remnants",
      flags = {
        "placeable-neutral",
        "not-on-map"
      },
      icon = "__base__/graphics/icons/wall.png",
      icon_mipmaps = 4,
      icon_size = 64,
      localised_name = {
        "remnant-name",
        {
          "entity-name."..name
        }
      },
      name = name.."-remnants",
      order = "a-a-a",
      remove_on_tile_placement = false,
      selectable_in_game = false,
      selection_box = {
        {
          -0.5,
          -0.5
        },
        {
          0.5,
          0.5
        }
      },
      subgroup = "defensive-structure-remnants",
      tile_height = 1,
      tile_width = 1,
      time_before_removed = 54000,
      type = "corpse"
    }
    })

    return name.."-remnants"
end

data:extend(
	{
	    {
            type = "wall",
            name = "regenerative-wall",
            icon = "__modmashsplinterdefense__/graphics/icons/regenerative-wall.png",
       		icon_size = 64,
		    icon_mipmaps = 4,    
            flags = {"placeable-neutral", "player-creation"},
            collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
            selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
            minable = {mining_time = 0.2, result = "regenerative-wall"},
            fast_replaceable_group = "wall",
            max_health = 600,
            repair_speed_modifier = 2,
            corpse = local_get_remnants("regenerative-wall"),
            repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
            mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
            vehicle_impact_sound =  { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
            connected_gate_visualization =
            {
              filename = "__core__/graphics/arrows/underground-lines.png",
              priority = "high",
              width = 64,
              height = 64,
              scale = 0.5
            },
            resistances =
            {
              {
                type = "physical",
                decrease = 3,
                percent = 20
              },
              {
                type = "impact",
                decrease = 45,
                percent = 60
              },
              {
                type = "explosion",
                decrease = 10,
                percent = 30
              },
              {
                type = "fire",
                percent = 100
              },
              {
                type = "acid",
                percent = 80
              },
              {
                type = "laser",
                percent = 70
              }
            },
            pictures =
            {
              single =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-single.png",
                    priority = "extra-high",
                    width = 32,
                    height = 46,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-single.png",
                      priority = "extra-high",
                      width = 64,
                      height = 86,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, -5),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-single-shadow.png",
                    priority = "extra-high",
                    width = 50,
                    height = 32,
                    repeat_count = 2,
                    shift = util.by_pixel(10, 16),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-single-shadow.png",
                      priority = "extra-high",
                      width = 98,
                      height = 60,
                      repeat_count = 2,
                      shift = util.by_pixel(10, 17),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              straight_vertical =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-vertical.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 5,
                    line_length = 5,
                    shift = util.by_pixel(0, 8),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-vertical.png",
                      priority = "extra-high",
                      width = 64,
                      height = 134,
                      variation_count = 5,
                      line_length = 5,
                      shift = util.by_pixel(0, 8),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-vertical-shadow.png",
                    priority = "extra-high",
                    width = 50,
                    height = 58,
                    repeat_count = 5,
                    shift = util.by_pixel(10, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-vertical-shadow.png",
                      priority = "extra-high",
                      width = 98,
                      height = 110,
                      repeat_count = 5,
                      shift = util.by_pixel(10, 29),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              straight_horizontal =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-horizontal.png",
                    priority = "extra-high",
                    width = 32,
                    height = 50,
                    variation_count = 6,
                    line_length = 6,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-horizontal.png",
                      priority = "extra-high",
                      width = 64,
                      height = 92,
                      variation_count = 6,
                      line_length = 6,
                      shift = util.by_pixel(0, -2),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-horizontal-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 36,
                    repeat_count = 6,
                    shift = util.by_pixel(14, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-horizontal-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 68,
                      repeat_count = 6,
                      shift = util.by_pixel(14, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              corner_right_down =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-corner-right.png",
                    priority = "extra-high",
                    width = 32,
                    height = 64,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-corner-right.png",
                      priority = "extra-high",
                      width = 64,
                      height = 128,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, 7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-corner-right-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 60,
                    repeat_count = 2,
                    shift = util.by_pixel(14, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-corner-right-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 120,
                      repeat_count = 2,
                      shift = util.by_pixel(17, 28),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              corner_left_down =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-corner-left.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-corner-left.png",
                      priority = "extra-high",
                      width = 64,
                      height = 134,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, 7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-corner-left-shadow.png",
                    priority = "extra-high",
                    width = 54,
                    height = 60,
                    repeat_count = 2,
                    shift = util.by_pixel(8, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-corner-left-shadow.png",
                      priority = "extra-high",
                      width = 102,
                      height = 120,
                      repeat_count = 2,
                      shift = util.by_pixel(9, 28),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              t_up =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-t.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 4,
                    line_length = 4,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-t.png",
                      priority = "extra-high",
                      width = 64,
                      height = 134,
                      variation_count = 4,
                      line_length = 4,
                      shift = util.by_pixel(0, 7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-t-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 60,
                    repeat_count = 4,
                    shift = util.by_pixel(14, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-t-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 120,
                      repeat_count = 4,
                      shift = util.by_pixel(14, 28),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              ending_right =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-ending-right.png",
                    priority = "extra-high",
                    width = 32,
                    height = 48,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-ending-right.png",
                      priority = "extra-high",
                      width = 64,
                      height = 92,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, -3),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-ending-right-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 36,
                    repeat_count = 2,
                    shift = util.by_pixel(14, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-ending-right-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 68,
                      repeat_count = 2,
                      shift = util.by_pixel(17, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              ending_left =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-ending-left.png",
                    priority = "extra-high",
                    width = 32,
                    height = 48,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-ending-left.png",
                      priority = "extra-high",
                      width = 64,
                      height = 92,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, -3),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-ending-left-shadow.png",
                    priority = "extra-high",
                    width = 54,
                    height = 36,
                    repeat_count = 2,
                    shift = util.by_pixel(8, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-ending-left-shadow.png",
                      priority = "extra-high",
                      width = 102,
                      height = 68,
                      repeat_count = 2,
                      shift = util.by_pixel(9, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              filling =
              {
                filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-filling.png",
                  priority = "extra-high",
                  width = 24,
                  height = 30,
                  variation_count = 8,
                  line_length = 8,
                  shift = util.by_pixel(0, -2),
                  hr_version =
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-filling.png",
                    priority = "extra-high",
                    width = 48,
                    height = 56,
                    variation_count = 8,
                    line_length = 8,
                    shift = util.by_pixel(0, -1),
                    scale = 0.5
                  }
              },
              water_connection_patch =
              {
                sheets =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-patch.png",
                    priority = "extra-high",
                    width = 58,
                    height = 64,
                    shift = util.by_pixel(0, -2),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-patch.png",
                      priority = "extra-high",
                      width = 116,
                      height = 128,
                      shift = util.by_pixel(0, -2),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-patch-shadow.png",
                    priority = "extra-high",
                    width = 74,
                    height = 52,
                    shift = util.by_pixel(8, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-patch-shadow.png",
                      priority = "extra-high",
                      width = 144,
                      height = 100,
                      shift = util.by_pixel(9, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              gate_connection_patch =
              {
                sheets =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/wall-gate.png",
                    priority = "extra-high",
                    width = 42,
                    height = 56,
                    shift = util.by_pixel(0, -8),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/regenerative-wall/hr-wall-gate.png",
                      priority = "extra-high",
                      width = 82,
                      height = 108,
                      shift = util.by_pixel(0, -7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-gate-shadow.png",
                    priority = "extra-high",
                    width = 66,
                    height = 40,
                    shift = util.by_pixel(14, 18),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-gate-shadow.png",
                      priority = "extra-high",
                      width = 130,
                      height = 78,
                      shift = util.by_pixel(14, 18),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              }
            },

            wall_diode_green = util.conditional_return(not data.is_demo,
            {
              sheet =
              {
                filename = "__base__/graphics/entity/wall/wall-diode-green.png",
                priority = "extra-high",
                width = 38,
                height = 24,
                --frames = 4, -- this is optional, it will default to 4 for Sprite4Way
                shift = util.by_pixel(-2, -24),
                hr_version =
                {
                  filename = "__base__/graphics/entity/wall/hr-wall-diode-green.png",
                  priority = "extra-high",
                  width = 72,
                  height = 44,
                  --frames = 4,
                  shift = util.by_pixel(-1, -23),
                  scale = 0.5
                }
              }
            }),
            wall_diode_green_light_top = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(0, -30),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_green_light_right = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(12, -23),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_green_light_bottom = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(0, -17),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_green_light_left = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(-12, -23),
              size = 1,
              intensity = 0.3
            }),

            wall_diode_red = util.conditional_return(not data.is_demo,
            {
              sheet =
              {
                filename = "__base__/graphics/entity/wall/wall-diode-red.png",
                priority = "extra-high",
                width = 38,
                height = 24,
                --frames = 4, -- this is optional, it will default to 4 for Sprite4Way
                shift = util.by_pixel(-2, -24),
                hr_version =
                {
                  filename = "__base__/graphics/entity/wall/hr-wall-diode-red.png",
                  priority = "extra-high",
                  width = 72,
                  height = 44,
                  --frames = 4,
                  shift = util.by_pixel(-1, -23),
                  scale = 0.5
                }
              }
            }),
            wall_diode_red_light_top = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(0, -30),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_red_light_right = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(12, -23),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_red_light_bottom = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(0, -17),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_red_light_left = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(-12, -23),
              size = 1,
              intensity = 0.3
            }),

            circuit_wire_connection_point = circuit_connector_definitions["gate"].points,
            circuit_connector_sprites = circuit_connector_definitions["gate"].sprites,
            circuit_wire_max_distance = default_circuit_wire_max_distance,
            default_output_signal = data.is_demo and {type = "virtual", name = "signal-green"} or {type = "virtual", name = "signal-G"}
        },
        {
            type = "wall",
            name = "titanium-wall",
            icon = "__modmashsplinterdefense__/graphics/icons/titanium-wall.png",
            icon_size = 64,
		    icon_mipmaps = 4,    
            flags = {"placeable-neutral", "player-creation"},
            collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
            selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
            minable = {mining_time = 0.2, result = "titanium-wall"},
            fast_replaceable_group = "wall",
            max_health = 800,
            repair_speed_modifier = 2,
            corpse = local_get_remnants("titanium-wall"),
            repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
            mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
            vehicle_impact_sound =  { filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0 },
            connected_gate_visualization =
            {
              filename = "__core__/graphics/arrows/underground-lines.png",
              priority = "high",
              width = 64,
              height = 64,
              scale = 0.5
            },
            resistances =
            {
              {
                type = "physical",
                decrease = 3,
                percent = 20
              },
              {
                type = "impact",
                decrease = 45,
                percent = 60
              },
              {
                type = "explosion",
                decrease = 10,
                percent = 30
              },
              {
                type = "fire",
                percent = 100
              },
              {
                type = "acid",
                percent = 80
              },
              {
                type = "laser",
                percent = 70
              }
            },
            pictures =
            {
              single =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-single.png",
                    priority = "extra-high",
                    width = 32,
                    height = 46,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-single.png",
                      priority = "extra-high",
                      width = 64,
                      height = 86,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, -5),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-single-shadow.png",
                    priority = "extra-high",
                    width = 50,
                    height = 32,
                    repeat_count = 2,
                    shift = util.by_pixel(10, 16),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-single-shadow.png",
                      priority = "extra-high",
                      width = 98,
                      height = 60,
                      repeat_count = 2,
                      shift = util.by_pixel(10, 17),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              straight_vertical =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-vertical.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 5,
                    line_length = 5,
                    shift = util.by_pixel(0, 8),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-vertical.png",
                      priority = "extra-high",
                      width = 64,
                      height = 134,
                      variation_count = 5,
                      line_length = 5,
                      shift = util.by_pixel(0, 8),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-vertical-shadow.png",
                    priority = "extra-high",
                    width = 50,
                    height = 58,
                    repeat_count = 5,
                    shift = util.by_pixel(10, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-vertical-shadow.png",
                      priority = "extra-high",
                      width = 98,
                      height = 110,
                      repeat_count = 5,
                      shift = util.by_pixel(10, 29),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              straight_horizontal =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-horizontal.png",
                    priority = "extra-high",
                    width = 32,
                    height = 50,
                    variation_count = 6,
                    line_length = 6,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-horizontal.png",
                      priority = "extra-high",
                      width = 64,
                      height = 92,
                      variation_count = 6,
                      line_length = 6,
                      shift = util.by_pixel(0, -2),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-horizontal-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 36,
                    repeat_count = 6,
                    shift = util.by_pixel(14, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-horizontal-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 68,
                      repeat_count = 6,
                      shift = util.by_pixel(14, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              corner_right_down =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-corner-right.png",
                    priority = "extra-high",
                    width = 32,
                    height = 64,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-corner-right.png",
                      priority = "extra-high",
                      width = 64,
                      height = 128,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, 7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-corner-right-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 60,
                    repeat_count = 2,
                    shift = util.by_pixel(14, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-corner-right-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 120,
                      repeat_count = 2,
                      shift = util.by_pixel(17, 28),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              corner_left_down =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-corner-left.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-corner-left.png",
                      priority = "extra-high",
                      width = 64,
                      height = 134,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, 7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-corner-left-shadow.png",
                    priority = "extra-high",
                    width = 54,
                    height = 60,
                    repeat_count = 2,
                    shift = util.by_pixel(8, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-corner-left-shadow.png",
                      priority = "extra-high",
                      width = 102,
                      height = 120,
                      repeat_count = 2,
                      shift = util.by_pixel(9, 28),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              t_up =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-t.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 4,
                    line_length = 4,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-t.png",
                      priority = "extra-high",
                      width = 64,
                      height = 134,
                      variation_count = 4,
                      line_length = 4,
                      shift = util.by_pixel(0, 7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-t-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 60,
                    repeat_count = 4,
                    shift = util.by_pixel(14, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-t-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 120,
                      repeat_count = 4,
                      shift = util.by_pixel(14, 28),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              ending_right =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-ending-right.png",
                    priority = "extra-high",
                    width = 32,
                    height = 48,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-ending-right.png",
                      priority = "extra-high",
                      width = 64,
                      height = 92,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, -3),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-ending-right-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 36,
                    repeat_count = 2,
                    shift = util.by_pixel(14, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-ending-right-shadow.png",
                      priority = "extra-high",
                      width = 124,
                      height = 68,
                      repeat_count = 2,
                      shift = util.by_pixel(17, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              ending_left =
              {
                layers =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-ending-left.png",
                    priority = "extra-high",
                    width = 32,
                    height = 48,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-ending-left.png",
                      priority = "extra-high",
                      width = 64,
                      height = 92,
                      variation_count = 2,
                      line_length = 2,
                      shift = util.by_pixel(0, -3),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-ending-left-shadow.png",
                    priority = "extra-high",
                    width = 54,
                    height = 36,
                    repeat_count = 2,
                    shift = util.by_pixel(8, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-ending-left-shadow.png",
                      priority = "extra-high",
                      width = 102,
                      height = 68,
                      repeat_count = 2,
                      shift = util.by_pixel(9, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              filling =
              {
                filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-filling.png",
                  priority = "extra-high",
                  width = 24,
                  height = 30,
                  variation_count = 8,
                  line_length = 8,
                  shift = util.by_pixel(0, -2),
                  hr_version =
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-filling.png",
                    priority = "extra-high",
                    width = 48,
                    height = 56,
                    variation_count = 8,
                    line_length = 8,
                    shift = util.by_pixel(0, -1),
                    scale = 0.5
                  }
              },
              water_connection_patch =
              {
                sheets =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-patch.png",
                    priority = "extra-high",
                    width = 58,
                    height = 64,
                    shift = util.by_pixel(0, -2),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-patch.png",
                      priority = "extra-high",
                      width = 116,
                      height = 128,
                      shift = util.by_pixel(0, -2),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-patch-shadow.png",
                    priority = "extra-high",
                    width = 74,
                    height = 52,
                    shift = util.by_pixel(8, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-patch-shadow.png",
                      priority = "extra-high",
                      width = 144,
                      height = 100,
                      shift = util.by_pixel(9, 15),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              },
              gate_connection_patch =
              {
                sheets =
                {
                  {
                    filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/wall-gate.png",
                    priority = "extra-high",
                    width = 42,
                    height = 56,
                    shift = util.by_pixel(0, -8),
                    hr_version =
                    {
                      filename = "__modmashsplinterdefense__/graphics/entity/titanium-wall/hr-wall-gate.png",
                      priority = "extra-high",
                      width = 82,
                      height = 108,
                      shift = util.by_pixel(0, -7),
                      scale = 0.5
                    }
                  },
                  {
                    filename = "__base__/graphics/entity/wall/wall-gate-shadow.png",
                    priority = "extra-high",
                    width = 66,
                    height = 40,
                    shift = util.by_pixel(14, 18),
                    draw_as_shadow = true,
                    hr_version =
                    {
                      filename = "__base__/graphics/entity/wall/hr-wall-gate-shadow.png",
                      priority = "extra-high",
                      width = 130,
                      height = 78,
                      shift = util.by_pixel(14, 18),
                      draw_as_shadow = true,
                      scale = 0.5
                    }
                  }
                }
              }
            },

            wall_diode_green = util.conditional_return(not data.is_demo,
            {
              sheet =
              {
                filename = "__base__/graphics/entity/wall/wall-diode-green.png",
                priority = "extra-high",
                width = 38,
                height = 24,
                --frames = 4, -- this is optional, it will default to 4 for Sprite4Way
                shift = util.by_pixel(-2, -24),
                hr_version =
                {
                  filename = "__base__/graphics/entity/wall/hr-wall-diode-green.png",
                  priority = "extra-high",
                  width = 72,
                  height = 44,
                  --frames = 4,
                  shift = util.by_pixel(-1, -23),
                  scale = 0.5
                }
              }
            }),
            wall_diode_green_light_top = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(0, -30),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_green_light_right = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(12, -23),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_green_light_bottom = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(0, -17),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_green_light_left = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {g=1},
              shift = util.by_pixel(-12, -23),
              size = 1,
              intensity = 0.3
            }),

            wall_diode_red = util.conditional_return(not data.is_demo,
            {
              sheet =
              {
                filename = "__base__/graphics/entity/wall/wall-diode-red.png",
                priority = "extra-high",
                width = 38,
                height = 24,
                --frames = 4, -- this is optional, it will default to 4 for Sprite4Way
                shift = util.by_pixel(-2, -24),
                hr_version =
                {
                  filename = "__base__/graphics/entity/wall/hr-wall-diode-red.png",
                  priority = "extra-high",
                  width = 72,
                  height = 44,
                  --frames = 4,
                  shift = util.by_pixel(-1, -23),
                  scale = 0.5
                }
              }
            }),
            wall_diode_red_light_top = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(0, -30),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_red_light_right = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(12, -23),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_red_light_bottom = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(0, -17),
              size = 1,
              intensity = 0.3
            }),
            wall_diode_red_light_left = util.conditional_return(not data.is_demo,
            {
              minimum_darkness = 0.3,
              color = {r=1},
              shift = util.by_pixel(-12, -23),
              size = 1,
              intensity = 0.3
            }),

            circuit_wire_connection_point = circuit_connector_definitions["gate"].points,
            circuit_connector_sprites = circuit_connector_definitions["gate"].sprites,
            circuit_wire_max_distance = default_circuit_wire_max_distance,
            default_output_signal = data.is_demo and {type = "virtual", name = "signal-green"} or {type = "virtual", name = "signal-G"}
        }
	}
)