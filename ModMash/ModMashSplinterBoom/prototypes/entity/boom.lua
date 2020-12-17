data:extend(
{
	{
		type     = "sprite",
		name     = "landmine-button-gui",
		filename = "__modmashsplinterboom__/boom.png",
		width    = 128,
		height   = 128
	}
})

local styles = data.raw["gui-style"]["default"]

styles["landmine-icon-button"] =
{
	type = "button_style",
	horizontal_align = "center",
	vertical_align = "center",
	icon_horizontal_align = "center",
	minimal_width = 36,
	height = 36,
	padding = 0,
	stretch_image_to_widget_size = true,
	default_graphical_set = base_icon_button_grahphical_set,
	hovered_graphical_set =
    {
		base = {position = {34, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
        shadow = default_dirt,
        glow = default_glow(default_glow_color, 0.5)
	},
	clicked_graphical_set =
	{
		base   = {position = {51, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
        shadow = default_dirt
	},
	selected_graphical_set =
	{
		base   = {position = {225, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
		shadow = default_dirt
	},
	selected_hovered_graphical_set =
	{
		base   = {position = {369, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
		shadow = default_dirt
	},
	strikethrough_color = {0.5, 0.5, 0.5},
	pie_progress_color = {1, 1, 1},
	left_click_sound =
	{
		{ filename = "__core__/sound/gui-click.ogg" }
	},
	draw_shadow_under_picture = true
}

data:extend(
  {
	{
		type = "land-mine",
		name = "nuclear-land-mine",
		icon = "__modmashsplinterboom__/graphics/icons/land-mine-a.png",
		icon_size = 64,
		icon_mipmaps = 4,
		create_ghost_on_death = false,
		flags =
			{
			  "placeable-player",
			  "placeable-enemy",
			  "player-creation",
			  "placeable-off-grid",
			  "not-on-map",
			  "not-repairable"
			},
		minable = {mining_time = 0.5, result = "nuclear-land-mine"},
		mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
		max_health = 15,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		picture_safe =
		{
		  filename = "__modmashsplinterboom__/graphics/entity/land-mine/hr-land-mine-a.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set =
		{
		  filename = "__modmashsplinterboom__/graphics/entity/land-mine/hr-land-mine-set-a.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set_enemy =
		{
		  filename = "__base__/graphics/entity/land-mine/land-mine-set-enemy.png",
		  priority = "medium",
		  width = 32,
		  height = 32,
		},
		trigger_radius = 3,
		ammo_category = "landmine",
		action =
		{
		  type = "direct",
		  action_delivery =
		  {
			type = "instant",
			source_effects =
			{
			  {
				  repeat_count = 100,
				  type = "create-trivial-smoke",
				  smoke_name = "nuclear-smoke",
				  offset_deviation = {{-1, -1}, {1, 1}},
				  starting_frame = 3,
				  starting_frame_deviation = 5,
				  starting_frame_speed = 0,
				  starting_frame_speed_deviation = 5,
				  speed_from_center = 0.5
			  },
			  {
				type = "create-entity",
				entity_name = "explosion"
			  },
			  {
				type = "create-entity",
				entity_name = "huge-scorchmark",
				check_buildability = true,
			  },
			  {
				type = "camera-effect",
				effect = "screen-burn",
				duration = 60,
				ease_in_duration = 5,
				ease_out_duration = 60,
				delay = 0,
				strength = 6,
				full_strength_max_distance = 200,
				max_distance = 800
			  },
			  {
				type = "nested-result",
				affects_target = true,
				action =
				{
				  type = "area",
				  radius = 8,
				  force = "enemy",
				  action_delivery =
				  {
					type = "instant",
					target_effects =
					{
					  {
						type = "damage",
						damage = { amount = 400, type = "explosion"}
					  },
					}
				  }
				}
			  },
			  {
				type = "nested-result",
				affects_target = true,
				action =
				{
				  type = "area",
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 2000,
				  radius = 35,
				  action_delivery =
				  {
					type = "projectile",
					projectile = "atomic-bomb-wave",
					starting_speed = 0.5
				  }
				}
			  },
			  {
				explosion = "explosion",
				radius = 35,
				type = "destroy-cliffs"
			  },
			  {
				type = "nested-result",
				action =
				{
				  type = "area",
				  show_in_tooltip = false,
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 1000,
				  radius = 8,
				  action_delivery =
				  {
					type = "projectile",
					projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
					starting_speed = 0.5 * 0.65,
					starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
				  }
				}
			  },
			  {
				type = "nested-result",
				action =
				{
				  type = "area",
				  show_in_tooltip = false,
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 300,
				  radius = 26,
				  action_delivery =
				  {
					type = "projectile",
					projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
					starting_speed = 0.5 * 0.65,
					starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
				  }
				}
			  },
			  {
				type = "nested-result",
				action =
				{
				  type = "area",
				  show_in_tooltip = false,
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 10,
				  radius = 8,
				  action_delivery =
				  {
					type = "instant",
					target_effects =
					{
					  {
						type = "create-entity",
						entity_name = "nuclear-smouldering-smoke-source",
						tile_collision_mask = { "water-tile" }
					  }
					}
				  }
				}
			  }
			}
		  }
		}
	},
	{
      icon = "__modmashsplinterboom__/graphics/icons/land-mine-a.png",
	  icon_size = 64,
	  icon_mipmaps = 4,
      name = "nuclear-land-mine",
      order = "f[land-mine][nuclear-land-mine]",
      place_result = "nuclear-land-mine",
      stack_size = 100,
      subgroup = "gun",
      type = "item"
    },
	{
      enabled = false,
      energy_required = 5,
      ingredients = 
	  {
        {
          "land-mine",
          1
        },
        {
          "uranium-235",
          2
        }
      },
      name = "nuclear-land-mine",
      result = "nuclear-land-mine",
      result_count = 1,
      type = "recipe"
    },
	{
      effects = 
	  {
        {
          recipe = "nuclear-land-mine",
          type = "unlock-recipe"
        }
      },
      icon = "__base__/graphics/technology/land-mine.png",
      icon_size = 256,
	  icon_mipmaps = 4,
      name = "nuclear-land-mine",
      order = "e-e",
      prerequisites = { "land-mine" },
      type = "technology",
      unit = {
        count = 100,
        ingredients = 
		{
          {
            "automation-science-pack",
            1
          },
          {
            "logistic-science-pack",
            1
          },
          {
            "military-science-pack",
            1
          }
        },
        time = 30
      }
    },
})


data:extend(
  {
	{
		type = "land-mine",
		name = "bigger-land-mine",
		icon = "__modmashsplinterboom__/graphics/icons/land-mine-b.png",
		icon_size = 64,
		icon_mipmaps = 4,
		create_ghost_on_death = false,
		flags =
			{
			  "placeable-player",
			  "placeable-enemy",
			  "player-creation",
			  "placeable-off-grid",
			  "not-on-map",
			  "not-repairable"
			},
		minable = {mining_time = 0.5, result = "bigger-land-mine"},
		mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
		max_health = 15,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		picture_safe =
		{
		  filename = "__modmashsplinterboom__/graphics/entity/land-mine/hr-land-mine-b.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set =
		{
		  filename = "__modmashsplinterboom__/graphics/entity/land-mine/hr-land-mine-set-b.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set_enemy =
		{
		  filename = "__base__/graphics/entity/land-mine/land-mine-set-enemy.png",
		  priority = "medium",
		  width = 32,
		  height = 32
		},
		trigger_radius = 3,
		ammo_category = "landmine",
		action =
		{
		  type = "direct",
		  action_delivery =
		  {
			type = "instant",
			source_effects =
			{
			  {
				type = "nested-result",
				affects_target = true,
				action =
				{
				  type = "area",
				  radius = 5,
				  force = "enemy",
				  action_delivery =
				  {
					type = "instant",
					target_effects =
					{
					  {
						type = "damage",
						damage = { amount = 650, type = "explosion"}
					  },
					  {
						type = "create-sticker",
						sticker = "stun-sticker"
					  }
					}
				  }
				}
			  },
			  {
				explosion = "explosion",
				radius = 5,
				type = "destroy-cliffs"
			  },
			  {
				type = "create-entity",
				entity_name = "big-explosion"
			  },
			  {
				type = "damage",
				damage = { amount = 1500, type = "explosion"}
			  }
			}
		  }
		}
	},
	{
      icon = "__modmashsplinterboom__/graphics/icons/land-mine-b.png",
	  icon_size = 64,
	  icon_mipmaps = 4,
      name = "bigger-land-mine",
      order = "f[land-mine][bigger-land-mine]",
      place_result = "bigger-land-mine",
      stack_size = 100,
      subgroup = "gun",
      type = "item"
    },
	{
      enabled = false,
      energy_required = 5,
      ingredients = 
	  {
        {
          "land-mine",
          1
        },
        {
          "explosives",
          4
        }
      },
      name = "bigger-land-mine",
      result = "bigger-land-mine",
      result_count = 1,
      type = "recipe"
    },
	{
      effects = 
	  {
        {
          recipe = "bigger-land-mine",
          type = "unlock-recipe"
        }
      },
      icon = "__base__/graphics/technology/land-mine.png",
      icon_size = 256,
	  icon_mipmaps = 4,
      name = "bigger-land-mine",
      order = "e-e",
      prerequisites = { "land-mine" },
      type = "technology",
      unit = {
        count = 100,
        ingredients = 
		{
          {
            "automation-science-pack",
            1
          },
          {
            "logistic-science-pack",
            1
          },
          {
            "military-science-pack",
            1
          }
        },
        time = 30
      }
    },
})
