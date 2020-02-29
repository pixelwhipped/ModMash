--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
    -- sprites
    {
        type = "sprite",
        name = "ore-refinery-spr",
        filename = "__modmash__/graphics/icons/ore-refinery.png",
        width = 32,
        height = 32,
		scale = 1
    },
	{
		type = "recipe-category",
		name = "ore-refining",		
	},
	{
		type = "item",
		name = "ore-refinery",
		icon = "__modmash__/graphics/icons/ore-refinery.png",
		icon_size = 32,
		subgroup = "production-machine",
		order = "c[ore-refinery]",
		place_result = "ore-refinery",
		stack_size = 50
	},
	{
		type = "assembling-machine",
		name = "ore-refinery",
		icon = "__modmash__/graphics/icons/ore-refinery.png",
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-player", "player-creation"},
		minable = {mining_time = 0.2, result = "ore-refinery"},
		max_health = 300,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		resistances =
		{
			{
				type = "fire",
				percent = 70
			}
		},   
		collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
		selection_box = {{-0.8, -1}, {0.8, 1}},

		always_draw_idle_animation = true,

		idle_animation =
		{
			layers =
			{
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-C.png",
				priority = "high",
				line_length = 8,
				width = 119,
				height = 107,
				scale = 0.8,
				frame_count = 64,
				hr_version =
				{
				filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C.png",
				priority = "high",
				scale = 0.4,
				line_length = 8,
				width = 237,
				height = 214,
				frame_count = 64,
				}
			},
			{
				filename = "__base__/graphics/entity/centrifuge/centrifuge-C-shadow.png",
				draw_as_shadow = true,
				priority = "high",
				line_length = 8,
				width = 132,
				height = 74,
				scale = 0.8,
				frame_count = 64,
				hr_version =
				{
				filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-shadow.png",
				draw_as_shadow = true,
				priority = "high",
				scale = 0.4,
				line_length = 8,
				width = 279,
				height = 152,
				frame_count = 64,
				}
			},	
			}
		},

		animation =
		{
			layers =
			{
			-- Centrifuge C
				{
					filename = "__base__/graphics/entity/centrifuge/centrifuge-C-light.png",
					priority = "high",
					tint = {r=1.0,g=0.0,b=0.0},
					blend_mode = "additive", -- centrifuge
					line_length = 8,
					width = 96,
					height = 104,
					frame_count = 64,
					hr_version =
					{
						filename = "__base__/graphics/entity/centrifuge/hr-centrifuge-C-light.png",
						priority = "high",
						scale = 0.5,
						tint = {r=1.0,g=0.0,b=0.0},
						blend_mode = "additive", -- centrifuge
						line_length = 8,
						width = 190,
						height = 207,
						frame_count = 64,
					}
				},      
			}
		},

		working_visualisations =
		{
			{
			effect = "uranium-glow", -- changes alpha based on energy source light intensity
			light = {intensity = 0.6, size = 6.6, shift = {0.0, 0.0}, color = {r = 1.0, g = 0.0, b = 0.0}}
			}
		},
		crafting_categories = {"ore-refining"},
		crafting_speed = 1,
		energy_source =
		{
			type = "electric",
			usage_priority = "secondary-input",
			emissions = 0.04
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
		type = "recipe",
		name = "ore-refinery",	
		enabled = "true",
		ingredients =
		{
			{"stone", 3},
			{"iron-plate", 2},
		},
		result = "ore-refinery"
	},
}
)

data.raw["gui-style"].default["ore-refinery-image-button-style"] = {
	type = "button_style",
	parent = "button",
	font = "default",
	align = "left",
	top_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 0,
	width = 34,
	height = 34,
	default_graphical_set = {
		type = "composition",
		filename = "__modmash__/graphics/icons/ore-refinery.png",
		priority = "extra-high-no-scale",
		corner_size = 1,
		position = {0, 0}
	},
	hovered_graphical_set = {
		type = "composition",
		filename = "__modmash__/graphics/icons/ore-refinery.png",
		priority = "extra-high-no-scale",
		corner_size = 1,
		position = {0, 0}
	},
	clicked_graphical_set = {
		type = "composition",
		filename = "__modmash__/graphics/icons/ore-refinery.png",
		priority = "extra-high-no-scale",
		corner_size = 1,
		position = {0, 0}
	},
	disabled_graphical_set = {
		type = "composition",
		filename = "__modmash__/graphics/icons/ore-refinery.png",
		priority = "extra-high-no-scale",
		corner_size = 1,
		position = {0, 0}
	}
}