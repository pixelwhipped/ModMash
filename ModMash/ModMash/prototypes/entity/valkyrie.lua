data:extend(
{
  {
    type = "combat-robot",
    name = "valkyrie-robot-combat",
    icon = "__modmash__/graphics/icons/valkyrie-robot.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
	minable = {mining_time = 0.1, result = "valkyrie-robot"},
    subgroup="capsule",
    order="e-a-c",
    max_health = 75,
    alert_when_damaged = false,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    --distance_per_frame = 0.13,
    time_to_live = 60 * 60 * 60 * 60,
    speed = 0.06,
    resistances =
    {
      {
        type = "acid",
        decrease = 0,
        percent = 90
      },
	  { 
	    type = "fire", 
		percent = 85 
	  }
    },
    destroy_action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {
            type = "create-entity",
            entity_name = "explosion"
        }
      }
    },
    attack_parameters =
    {
      type = "beam",
      ammo_category = "combat-robot-beam",
      cooldown = 5,
      range = 15,
      ammo_type =
      {
        category = "combat-robot-beam",
        action =
        {
          type = "direct",
          action_delivery =
          {
            type = "beam",
            beam = "electric-beam",
            max_length = 15,
            duration = 5,
            source_offset = {0.15, -0.5}
          }
        }
      }
    },
    idle =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    },
    in_motion =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      y = 36,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0, -4.5),
        direction_count = 16,
        y = 76,
        scale = 0.5
      }
    },
    shadow_idle =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
    shadow_in_motion =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
  },
  {
    type = "construction-robot",
    name = "valkyrie-robot",
    icon = "__modmash__/graphics/icons/valkyrie-robot.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
    minable = {mining_time = 0.1, result = "valkyrie-robot"},
    resistances =
    {
      {
        type = "acid",
        decrease = 0,
        percent = 90
      },
	  { 
	    type = "fire", 
		percent = 85 
	  }
    },
	alert_when_damaged = false,
    max_health = 75,
	order="e-a-c",
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    max_payload_size = 1,
    speed = 0.06,
    transfer_distance = 0.1,
    max_energy = "1.5MJ",
    energy_per_tick = "0.05kJ",
    speed_multiplier_when_out_of_energy = 0.2,
    energy_per_move = "5kJ",
    min_to_charge = 0.2,
    max_to_charge = 0.95,
    working_light = {intensity = 0.8, size = 3, color = {r = 0.8, g = 0.8, b = 0.8}},
    idle =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    },
    in_motion =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      y = 36,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0, -4.5),
        direction_count = 16,
        y = 76,
        scale = 0.5
      }
    },
    shadow_idle =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
    shadow_in_motion =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
    working =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot-working.png",
      priority = "high",
      line_length = 2,
      width = 28,
      height = 36,
      frame_count = 2,
      shift = {0, -0.15625},
      direction_count = 16,
      animation_speed = 0.3,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot-working.png",
        priority = "high",
        line_length = 2,
        width = 57,
        height = 74,
        frame_count = 2,
        shift = util.by_pixel(-0.25, -5),
        direction_count = 16,
        animation_speed = 0.3,
        scale = 0.5
      }
    },
    shadow_working =
    {
      stripes = util.multiplystripes(2,
      {
        {
          filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
          width_in_frames = 16,
          height_in_frames = 1
        }
      }),
      priority = "high",
      width = 50,
      height = 24,
      frame_count = 2,
      shift = {1.09375, 0.59375},
      direction_count = 16
    },
    smoke =
    {
      filename = "__base__/graphics/entity/smoke-construction/smoke-01.png",
      width = 39,
      height = 32,
      frame_count = 19,
      line_length = 19,
      shift = {0.078125, -0.15625},
      animation_speed = 0.3
    },
    sparks =
    {
      {
        filename = "__base__/graphics/entity/sparks/sparks-01.png",
        width = 39,
        height = 34,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.3125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-02.png",
        width = 36,
        height = 32,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-03.png",
        width = 42,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.203125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-04.png",
        width = 40,
        height = 35,
        frame_count = 19,
        line_length = 19,
        shift = {-0.0625, 0.234375},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-05.png",
        width = 39,
        height = 29,
        frame_count = 19,
        line_length = 19,
        shift = {-0.109375, 0.171875},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3
      },
      {
        filename = "__base__/graphics/entity/sparks/sparks-06.png",
        width = 44,
        height = 36,
        frame_count = 19,
        line_length = 19,
        shift = {0.03125, 0.3125},
        tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
        animation_speed = 0.3
      }
    },
    working_sound = flying_robot_sounds(),
    cargo_centered = {0.0, 0.2},
    construction_vector = {0.30, 0.22}
  },
  {
    type = "projectile",
    name = "valkyrie-robot-projectile-player",
    flags = {"not-on-map"},
	reveal_map = true,
    acceleration = 0.005,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            show_in_tooltip = true,
			trigger_created_entity = true,
            entity_name = "valkyrie-robot-combat"
          }
        }
      }
    },
    light = {intensity = 0.5, size = 4},
    enable_drawing_with_mask = false,
    animation =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    },
    shadow =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
	--[[smoke = {
		{
		name = "smoke-fast",
		deviation = {0.15, 0.15},
		frequency = 1,
		position = {0, 0},
		starting_frame = 3,
		starting_frame_deviation = 5,
		starting_frame_speed_deviation = 5
		}
	}]]
  },
  {
    type = "projectile",
    name = "valkyrie-robot-projectile",
    flags = {"not-on-map"},
	reveal_map = true,
    acceleration = 0.005,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            show_in_tooltip = true,
			trigger_created_entity = true,
            entity_name = "valkyrie-robot-combat"
          }
        }
      }
    },
    light = {intensity = 0.5, size = 4},
    enable_drawing_with_mask = false,
    animation =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    },
    shadow =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
--[[smoke = {
		{
		name = "smoke-fast",
		deviation = {0.15, 0.15},
		frequency = 1,
		position = {0, 0},
		starting_frame = 3,
		starting_frame_deviation = 5,
		starting_frame_speed_deviation = 5
		}
	}]]
  },
  {
    type = "combat-robot",
    name = "valkyrie-robot-return",
    icon = "__modmash__/graphics/icons/valkyrie-robot.png",
    icon_size = 32,
    flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-on-map"},
	minable = {mining_time = 0.1, result = "valkyrie-robot"},
    subgroup="capsule",
    order="e-a-c",
    max_health = 75,
    alert_when_damaged = false,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -1.5}, {0.5, -0.5}},
    distance_per_frame = 0.13,
    time_to_live = 60*60*60*60,
	follows_player = true,
    friction = 0.01,
    range_from_player = 1,
    speed = 0.06,
    resistances =
    {
      {
        type = "acid",
        decrease = 0,
        percent = 90
      },
	  { 
	    type = "fire", 
		percent = 85 
	  }
    },
    destroy_action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {
            type = "create-entity",
            entity_name = "explosion"
        }
      }
    },
    attack_parameters =
    {
      type = "beam",
      ammo_category = "combat-robot-beam",
      cooldown = 5,
      range = 15,
      ammo_type =
      {
        category = "combat-robot-beam",
        action =
        {
          type = "direct",
          action_delivery =
          {
            type = "beam",
            beam = "electric-beam",
            max_length = 15,
            duration = 5,
            source_offset = {0.15, -0.5}
          }
        }
      }
    },
    idle =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    },
    in_motion =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      y = 36,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0, -4.5),
        direction_count = 16,
        y = 76,
        scale = 0.5
      }
    },
    shadow_idle =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
    shadow_in_motion =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
  },
  {
    type = "projectile",
    name = "valkyrie-robot-return-projectile",
    flags = {"not-on-map"},
	reveal_map = true,
    acceleration = 0.005,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            show_in_tooltip = true,
			trigger_created_entity = true,
            entity_name = "valkyrie-robot-return"
          }
        }
      }
    },
    light = {intensity = 0.5, size = 4},
    enable_drawing_with_mask = false,
    animation =
    {
      filename = "__modmash__/graphics/entity/valkyrie/valkyrie-robot.png",
      priority = "high",
      line_length = 16,
      width = 32,
      height = 36,
      frame_count = 1,
      shift = {0, -0.15625},
      direction_count = 16,
      hr_version =
      {
        filename = "__modmash__/graphics/entity/valkyrie/hr-valkyrie-robot.png",
        priority = "high",
        line_length = 16,
        width = 66,
        height = 76,
        frame_count = 1,
        shift = util.by_pixel(0,-4.5),
        direction_count = 16,
        scale = 0.5
      }
    },
    shadow =
    {
      filename = "__base__/graphics/entity/construction-robot/construction-robot-shadow.png",
      priority = "high",
      line_length = 16,
      width = 50,
      height = 24,
      frame_count = 1,
      shift = {1.09375, 0.59375},
      direction_count = 16,
      hr_version =
      {
        filename = "__base__/graphics/entity/construction-robot/hr-construction-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 104,
        height = 49,
        frame_count = 1,
        shift = util.by_pixel(33.5, 18.75),
        direction_count = 16,
        scale = 0.5
      }
    },
	--[[smoke = {
		{
		name = "smoke-fast",
		deviation = {0.15, 0.15},
		frequency = 1,
		position = {0, 0},
		starting_frame = 3,
		starting_frame_deviation = 5,
		starting_frame_speed_deviation = 5
		}
	}]]
  }
})