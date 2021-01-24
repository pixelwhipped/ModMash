data:extend(
{
	{
		type = "assembling-machine",
		name = "terraformer",
		icon = "__modmashsplinternewworlds__/graphics/icons/terraformer.png",
		icon_size = 64,
        icon_mipmaps = 4,        
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 0.2, result = "terraformer"},
		max_health = 100,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		resistances =
		{
		    {
				type = "fire",
				percent = 70
		    }
		},
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		alert_icon_shift = {
                -0.09375,
                -0.375
                },
        scale_entity_info_icon = true,
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
                production_type = "input",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = 1,
                pipe_connections = {{ type="input", position = {0, 2} }}
            },
            off_when_no_fluid_recipe = true
        },
		animation =
		{
			north =
			{
				filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/terraformerv.png",
				width = 107,
				height = 113,
				frame_count = 1,
				hr_version =
				{
					filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/hr-terraformerv.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			},
			east =
			{
				filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/terraformerh.png",
				width = 107,
				height = 113,
				frame_count = 1,
				hr_version =
				{
					filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/hr-terraformerh.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			},
			south =
			{
				filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/terraformervb.png",
				width = 107,
				height = 113,
				frame_count = 1,
				hr_version =
				{
					filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/hr-terraformervb.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			},
			west =
			{
				filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/terraformerh.png",
				width = 107,
				height = 113,
				frame_count = 1,
				hr_version =
				{
					filename = "__modmashsplinternewworlds__/graphics/entity/terraformer/hr-terraformerh.png",
					priority="high",
					width = 214,
					height = 226,
					frame_count = 1,
					scale = 0.5
			    }
			}
		},
		crafting_categories = {"cloning"},
		crafting_speed = 1,
		energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute  = 0.5
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
		},
		ingredient_count = 3,
        module_specification =
        {
            module_slots = 3,
            module_info_icon_shift = {0, 0},
            module_info_multi_row_initial_height_modifier = -0.3
        },
        allowed_effects = {"consumption", "productivity", "pollution"},
	},
    {
      animation = {
        {
          layers = {
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die.png",
              frame_count = 8,
              height = 178,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die.png",
                frame_count = 8,
                height = 354,
                line_length = 8,
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 0
              },
              line_length = 8,
              shift = {
                0.0625,
                -0.0625
              },
              width = 248,
              y = 0
            },
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 8,
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = {
                  a = 0.5,
                  b = 0,
                  g = 0.54000000000000004,
                  r = 0.92000000000000011
                },
                width = 276,
                y = 0
              },
              line_length = 8,
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 0
            },
            {
              direction_count = 1,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-die-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                direction_count = 1,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 8,
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 466,
                y = 0
              },
              line_length = 8,
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 0
            }
          }
        },
        {
          layers = {
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die.png",
              frame_count = 8,
              height = 178,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die.png",
                frame_count = 8,
                height = 354,
                line_length = 8,
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 354
              },
              line_length = 8,
              shift = {
                0.0625,
                -0.0625
              },
              width = 248,
              y = 178
            },
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 8,
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 234
              },
              line_length = 8,
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 118
            },
            {
              direction_count = 1,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-die-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                direction_count = 1,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 8,
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 466,
                y = 406
              },
              line_length = 8,
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 176
            }
          }
        },
        {
          layers = {
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die.png",
              frame_count = 8,
              height = 178,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die.png",
                frame_count = 8,
                height = 354,
                line_length = 8,
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 708
              },
              line_length = 8,
              shift = {
                0.0625,
                -0.0625
              },
              width = 248,
              y = 356
            },
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 8,
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 468
              },
              line_length = 8,
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 236
            },
            {
              direction_count = 1,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-die-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                direction_count = 1,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 8,
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 466,
                y = 812
              },
              line_length = 8,
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 352
            }
          }
        },
        {
          layers = {
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die.png",
              frame_count = 8,
              height = 178,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die.png",
                frame_count = 8,
                height = 354,
                line_length = 8,
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 1062
              },
              line_length = 8,
              shift = {
                0.0625,
                -0.0625
              },
              width = 248,
              y = 534
            },
            {
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-die-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 8,
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 702
              },
              line_length = 8,
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 354
            },
            {
              direction_count = 1,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-die-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                direction_count = 1,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-die-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 8,
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 466,
                y = 1218
              },
              line_length = 8,
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 528
            }
          }
        }
      },
      collision_box = {
        {
          -4,
          -4
        },
        {
          4,
          4
        }
      },
      dying_speed = 0.04,
      final_render_layer = "remnants",
      flags = {
        "placeable-neutral",
        "placeable-off-grid",
        "not-on-map"
      },
      ground_patch = {
        sheet = {
          filename = "__base__/graphics/entity/spawner/spawner-idle-integration.png",
          frame_count = 1,
          height = 188,
          hr_version = {
            filename = "__base__/graphics/entity/spawner/hr-spawner-idle-integration.png",
            frame_count = 1,
            height = 380,
            line_length = 1,
            scale = 0.5,
            shift = {
              0.09375,
              -0.09375
            },
            variation_count = 4,
            width = 522
          },
          line_length = 1,
          shift = {
            0.0625,
            -0.0625
          },
          variation_count = 4,
          width = 258
        }
      },
      icon = "__base__/graphics/icons/biter-spawner-corpse.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "queen-hive-corpse",
      order = "c[corpse]-b[biter-spawner]",
      selectable_in_game = false,
      selection_box = {
        {
          -4,
          -4
        },
        {
          4,
          4
        }
      },
      subgroup = "corpses",
      time_before_removed = 54000,
      type = "corpse"
    },
	{
      loot =
      {
        {
            count_max = 50,
            count_min = 20,
            item = "royal-jelly",
            probability = 1
        }
      },
      animations = {
        {
          layers = {
            {
              animation_speed = 0.17999999999999998,
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-idle.png",
              frame_count = 8,
              height = 180,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle.png",
                frame_count = 8,
                height = 354,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 0
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                0.0625,
                -0.125
              },
              width = 248,
              y = 0
            },
            {
              animation_speed = 0.17999999999999998,
              filename = "__base__/graphics/entity/spawner/spawner-idle-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 0
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 0
            },
            {
              animation_speed = 0.17999999999999998,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-idle-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 464,
                y = 0
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 0
            }
          }
        },
        {
          layers = {
            {
              animation_speed = 0.17999999999999998,
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-idle.png",
              frame_count = 8,
              height = 180,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle.png",
                frame_count = 8,
                height = 354,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 708
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                0.0625,
                -0.125
              },
              width = 248,
              y = 360
            },
            {
              animation_speed = 0.17999999999999998,
              filename = "__base__/graphics/entity/spawner/spawner-idle-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 468
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 236
            },
            {
              animation_speed = 0.17999999999999998,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-idle-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 464,
                y = 812
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 352
            }
          }
        },
        {
          layers = {
            {
              animation_speed = 0.17999999999999998,
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-idle.png",
              frame_count = 8,
              height = 180,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle.png",
                frame_count = 8,
                height = 354,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 1416
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                0.0625,
                -0.125
              },
              width = 248,
              y = 720
            },
            {
              animation_speed = 0.17999999999999998,
              filename = "__base__/graphics/entity/spawner/spawner-idle-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 936
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 472
            },
            {
              animation_speed = 0.17999999999999998,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-idle-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 464,
                y = 1624
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 704
            }
          }
        },
        {
          layers = {
            {
              animation_speed = 0.17999999999999998,
              direction_count = 1,
              filename = "__base__/graphics/entity/spawner/spawner-idle.png",
              frame_count = 8,
              height = 180,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                direction_count = 1,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle.png",
                frame_count = 8,
                height = 354,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  0.09375,
                  -0.0625
                },
                width = 490,
                y = 2124
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                0.0625,
                -0.125
              },
              width = 248,
              y = 1080
            },
            {
              animation_speed = 0.17999999999999998,
              filename = "__base__/graphics/entity/spawner/spawner-idle-mask.png",
              flags = {
                "mask"
              },
              frame_count = 8,
              height = 118,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-mask.png",
                flags = {
                  "mask"
                },
                frame_count = 8,
                height = 234,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  -0.03125,
                  -0.4375
                },
                tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
                width = 276,
                y = 1404
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                -0.0625,
                -0.4375
              },
              tint = 0 --[=[ ref [""].corpse["biter-spawner-corpse"].animation[1].layers[2].hr_version.tint ]=],
              width = 140,
              y = 708
            },
            {
              animation_speed = 0.17999999999999998,
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/spawner/spawner-idle-shadow.png",
              frame_count = 8,
              height = 176,
              scale = 2,
              hr_version = {
                animation_speed = 0.17999999999999998,
                draw_as_shadow = true,
                filename = "__base__/graphics/entity/spawner/hr-spawner-idle-shadow.png",
                frame_count = 8,
                height = 406,
                line_length = 4,
                run_mode = "forward-then-backward",
                scale = 1,
                shift = {
                  1.125,
                  0.3125
                },
                width = 464,
                y = 2436
              },
              line_length = 4,
              run_mode = "forward-then-backward",
              shift = {
                1.125,
                -0.0625
              },
              width = 232,
              y = 1056
            }
          }
        }
      },

      call_for_help_radius = 250,
      collision_box = {
        {
          -6.4000000000000004,
          -4.4000000000000004
        },
        {
          4.4000000000000004,
          4.4000000000000004
        }
      },
      corpse = "queen-hive-corpse",
      damaged_trigger_effect = {
        damage_type_filters = "fire",
        entity_name = "enemy-damaged-explosion",
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
            0
          }
        },
        type = "create-entity"
      },
      dying_explosion = "biter-spawner-die",
      dying_sound = {
        {
          filename = "__base__/sound/creatures/spawner-death-1.ogg",
          volume = 1
        },
        {
          filename = "__base__/sound/creatures/spawner-death-2.ogg",
          volume = 1
        }
      },
      flags = {
        "placeable-player",
        "placeable-enemy",
        "not-repairable"
      },
      healing_per_tick = 0.1,
      icon = "__base__/graphics/icons/biter-spawner.png",
      icon_mipmaps = 4,
      icon_size = 64,
      integration = {
        sheet = {
          filename = "__base__/graphics/entity/spawner/spawner-idle-integration.png",
          frame_count = 1,
          height = 188,
          hr_version = {
            filename = "__base__/graphics/entity/spawner/hr-spawner-idle-integration.png",
            frame_count = 1,
            height = 380,
            line_length = 1,
            scale = 0.5,
            shift = {
              0.09375,
              -0.09375
            },
            variation_count = 4,
            width = 522
          },
          line_length = 1,
          shift = {
            0.0625,
            -0.0625
          },
          variation_count = 4,
          width = 258
        }
      },
      map_generator_bounding_box = {
        {
          -8.4000000000000004,
          -6.4000000000000004
        },
        {
          6.4000000000000004,
          6.4000000000000004
        }
      },
      max_count_of_owned_units = 24,
      max_friends_around_to_spawn = 12,
      max_health = 10000,
      max_richness_for_spawn_shift = 100,
      max_spawn_shift = 0,
      name = "queen-hive",
      order = "b-d-a",
      pollution_absorption_absolute = 20,
      pollution_absorption_proportional = 0.01,
      resistances = {
        {
          decrease = 2,
          percent = 30,
          type = "physical"
        },
        {
          decrease = 5,
          percent = 30,
          type = "explosion"
        },
        {
          decrease = 3,
          percent = 60,
          type = "fire"
        }
      },
      result_units = {
        {
          "behemoth-biter",
          {
            {
              0,
              1
            },
            {
              1,
              1
            }
          }
        }
      },
      selection_box = {
        {
          -7,
          -5
        },
        {
          5,
          5
        }
      },
      spawn_decoration = {
        {
          decorative = "light-mud-decal",
          spawn_max = 2,
          spawn_max_radius = 5,
          spawn_min = 0,
          spawn_min_radius = 2
        },
        {
          decorative = "dark-mud-decal",
          spawn_max = 3,
          spawn_max_radius = 6,
          spawn_min = 0,
          spawn_min_radius = 2
        },
        {
          decorative = "enemy-decal",
          spawn_max = 5,
          spawn_max_radius = 7,
          spawn_min = 3,
          spawn_min_radius = 2
        },
        {
          decorative = "enemy-decal-transparent",
          radius_curve = 0.9,
          spawn_max = 20,
          spawn_max_radius = 14,
          spawn_min = 4,
          spawn_min_radius = 2
        },
        {
          decorative = "muddy-stump",
          spawn_max = 5,
          spawn_max_radius = 6,
          spawn_min = 2,
          spawn_min_radius = 3
        },
        {
          decorative = "red-croton",
          spawn_max = 8,
          spawn_max_radius = 6,
          spawn_min = 2,
          spawn_min_radius = 3
        },
        {
          decorative = "red-pita",
          spawn_max = 5,
          spawn_max_radius = 6,
          spawn_min = 1,
          spawn_min_radius = 3
        }
      },
      spawn_decorations_on_expansion = true,
      spawning_cooldown = {
        360,
        150
      },
      spawning_radius = 10,
      spawning_spacing = 3,
      subgroup = "enemies",
      type = "unit-spawner",
      working_sound = {
        sound = {
          {
            filename = "__base__/sound/creatures/spawner.ogg",
            volume = 0.6
          }
        }
      }
    },
})