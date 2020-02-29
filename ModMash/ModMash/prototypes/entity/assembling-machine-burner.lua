--[[Code check 29.2.20
no changes
--]]
data:extend({
	{
		type = "assembling-machine",
		name = "assembling-machine-burner",
		icon = "__modmash__/graphics/icons/assembling-machine-0.png",
		icon_size = 32,
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
		animation =
		{
		  layers =
		  {
			{
			  filename = "__modmash__/graphics/entity/assembling-machine-0/assembling-machine-0.png",
			  priority="high",
			  width = 108,
			  height = 114,
			  frame_count = 32,
			  line_length = 8,
			  scale= 0.5,
			  shift = util.by_pixel(0, 2),
			  hr_version =
			  {
				filename = "__modmash__/graphics/entity/assembling-machine-0/hr-assembling-machine-0.png",
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
			  filename = "__modmash__/graphics/entity/assembling-machine-0/assembling-machine-0-shadow.png",
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
				filename = "__modmash__/graphics/entity/assembling-machine-0/hr-assembling-machine-0-shadow.png",
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
		type = "item",
		name = "assembling-machine-burner",
		icon = "__modmash__/graphics/icons/assembling-machine-0.png",
		icon_size = 32,
		subgroup = "production-machine",
		order = "c[assembling-machine-burner]",
		place_result = "assembling-machine-burner",
		stack_size = 50
    },
	{
		type = "recipe",
		name = "assembling-machine-burner",	
		enabled = "true",
		ingredients =
		{
			{"iron-gear-wheel", 3},
			{"iron-plate", 3},
		},
		result = "assembling-machine-burner"
	},
})