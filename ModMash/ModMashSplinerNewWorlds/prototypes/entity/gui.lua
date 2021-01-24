data:extend(
{
	{
		type     = "sprite",
		name     = "planets-button-gui",
		filename = "__modmashsplinternewworlds__/planets.png",
		width    = 128,
		height   = 128
	},
	{
		icon = "__base__/graphics/icons/biter-spawner.png",
		icon_mipmaps = 4,
		icon_size = 64,
		name = "queen-hive-signal",
		order = "zz",
		subgroup = "virtual-signal",
		type = "virtual-signal"
	}
	  
})

local styles = data.raw["gui-style"]["default"]

styles["planets-icon-button"] =
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

styles["planets-window"] =
{
	type           = "frame_style",
	width          = 240, 
	height         = 600,
	top_padding    = 4,
	bottom_padding = 4,
	right_padding  = 8,	
	left_padding  = 8,	
	graphical_set  =
	{
		filename = "__core__/graphics/gui-new.png",
		position = {0, 0},
		opacity = 0.95,
        background_blur = true,
		corner_size = 8 	
	},
	use_header_filler = true,
	drag_by_title     = true,
	header_background =
	{
		center = {x = 8, y = 8, width = 1, height = 1}
	}
}

styles["planets-bottom-button-flow"] =
{
	type = "horizontal_flow_style",
	parent = "dialog_buttons_horizontal_flow",
	vertically_stretchable   = "off",
	horizontally_stretchable = "on",	
	width   = 230,
	padding = 0,
	graphical_set = {},
    background_graphical_set = {}
}

styles["planets-bottom-filler"] =
{    
    type = "empty_widget_style",
    parent = "draggable_space",
    width = 108,
	height = 24,
    right_margin = 0
}

styles["planets-window-flow"] =
{
	type = "horizontal_flow_style",
    padding = 2,
	maximal_width = 220,
	natural_width = 220,
	graphical_set =
	{
		base = 
		{
			filename = "__core__/graphics/gui-new.png",
			position = {12, 0},
			opacity = 0.0,
			background_blur = true,
			corner_size = 8
		}
	}
}
--[[
styles["planets-title-flow"] =
{
	type = "horizontal_flow_style",
    horizontal_align = "center",
	vertically_stretchable = "off",
	natural_width = 200,
    padding = 1,
	margin = 1
}]]

styles["planets-left-window-flow"] =
{
	type = "vertical_flow_style",
	vertically_stretchable = "on",
    padding = 1,
	width = 218,
	graphical_set =
	{
		filename = "__core__/graphics/gui-new.png",
		position = {0, 0},
		opacity = 0.0,
		background_blur = true
	}
}

--------------------------------------------------Platform UI

styles["platform-window"] =
{
	type           = "frame_style",
	width          = 240, 
	height         = 600,
	top_padding    = 4,
	bottom_padding = 4,
	right_padding  = 8,	
	left_padding  = 8,	
	graphical_set  =
	{
		filename = "__core__/graphics/gui-new.png",
		position = {0, 0},
		opacity = 0.95,
        background_blur = true,
		corner_size = 8 	
	},
	use_header_filler = true,
	drag_by_title     = true,
	header_background =
	{
		center = {x = 8, y = 8, width = 1, height = 1}
	}
}


styles["platform-progress"] =
{
	width = 218,
	type = "progressbar_style",
	parent = "progressbar",
	smooth_color = {r=0.1, g=0.92, b=0.0}
}

styles["platform-left-window-flow"] =
{
	type = "vertical_flow_style",
	vertically_stretchable = "on",
    padding = 1,
	width = 218,
	graphical_set =
	{
		filename = "__core__/graphics/gui-new.png",
		position = {0, 0},
		opacity = 0.95,
		background_blur = true
	}
}