require ("prototypes.scripts.defines")

--local pinch_scorchmark = table.deepcopy(data.raw["corpse"]["small-scorchmark-tintable"])
--pinch_scorchmark.name="pinch-scorchmark-tintable"

data:extend(
  {
    --pinch_scorchmark,
	{
		type = "land-mine",
		name = "them-pinch-mine",
		icon = "__modmashsplinterthem__/graphics/icons/land-mine-p.png",
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
		minable = {mining_time = 0.5, result = "them-pinch-mine"},
		mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
		max_health = 15,
		corpse = "small-remnants",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		picture_safe =
		{
		  filename = "__modmashsplinterthem__/graphics/entity/land-mine-p/hr-land-mine-a.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set =
		{
		  filename = "__modmashsplinterthem__/graphics/entity/land-mine-p/hr-land-mine-set-a.png",
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
		trigger_radius = 4,
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
				type = "script",
				effect_id = "pinch-explosion"
			  },
			  {
				type = "camera-effect",
				effect = "screen-burn",
				duration = 30,
				ease_in_duration = 2,
				ease_out_duration = 30,
				delay = 0,
				strength = 4,
				full_strength_max_distance = 80,
				max_distance = 360
			  },

			  --[[{
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
			  }--]]
			}
		  }
		}
	},
	{
      icon = "__modmashsplinterthem__/graphics/icons/land-mine-p.png",
	  icon_size = 64,
	  icon_mipmaps = 4,
      name = "them-pinch-mine",
      order = "f[land-mine][them-pinch-mine]",
      place_result = "them-pinch-mine",
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
          "copper-cable",
          20
        },
        {
          "accumulator",
          2
        }
      },
      ingredients_expensive =
	  {
		{
          "copper-cable",
          25
        },
        {
          "accumulator",
          3
        }
	  },
      name = "them-pinch-mine",
      result = "them-pinch-mine",
      result_count = 1,
      type = "recipe"
    },
	{
      effects = 
	  {
        {
          recipe = "them-pinch-mine",
          type = "unlock-recipe"
        }
      },
      icon = "__base__/graphics/technology/land-mine.png",
      icon_size = 256,
	  icon_mipmaps = 4,
      name = "them-pinch-mine",
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
