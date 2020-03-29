﻿local styles = data.raw["gui-style"]["default"]

data:extend(
{
	-- Images
	{
		type     = "sprite",
		name     = "wiki-open-gui",
		filename = "__wiki__/graphics/gui/wiki.png",
		width    = 128,
		height   = 128
	}
})

styles["wiki-window"] =
{
	type           = "frame_style",
	width          = 760, 
	height         = 600,
	top_padding    = 4,
	bottom_padding = 4,
	right_padding  = 8,	
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

-- Main flow
styles["wiki-window-flow"] =
{
	type = "horizontal_flow_style",
    padding = 2,
	maximal_width = 760,
	natural_width = 740,
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

-- Box for left elements
styles["wiki-left-window-flow"] =
{
	type = "vertical_flow_style",
	vertically_stretchable = "on",
    padding = 1,
	width = 200,
	graphical_set =
	{
		filename = "__core__/graphics/gui-new.png",
		position = {0, 0},
		opacity = 0.0,
		background_blur = true
	}
}

-- Inside of right box where put description, this is the vertical box
styles["wiki-right-window-flow"] =
{
	type = "vertical_flow_style",
	vertical_align = "top",
	horizontal_align = "left",
	natural_width  = 600,
	natural_height = 350,
	vertically_stretchable   = "on",
	horizontally_stretchable = "on",
    padding = 1
}

-- Box where put description
styles["wiki-description-flow"] =
{
	type = "scroll_pane_style",
	vertically_stretchable   = "on",
	horizontally_stretchable = "off",
	vertical_scrollbar_style = { type = "vertical_scrollbar_style" },
	width   = 525,
	padding = 4,
	graphical_set = 
	{
		base = 
		{
			position = {0, 0}, 
			corner_size = 8, 
			draw_type = "outer"
		},
		shadow = default_inner_shadow
	},
    background_graphical_set = {},
    extra_padding_when_activated = 4
}

styles["wiki-back-button-flow"] =
{
	type = "horizontal_flow_style",
    horizontal_align = "left",
	natural_width = 740,
	vertically_stretchable = "off",
    padding = 2,
	margin = 2
}

-- Open button
local base_icon_button_grahphical_set =
{
	filename = "__core__/graphics/gui-new.png",
	stretch_image_to_widget_size = true,
	position = {0, 0},
	corner_size = 2,
	opacity = 0.2,
	draw_type = "outer",
	background_blur = true,
	scale = 1,
	border = 1
}
styles["wiki-icon-button"] =
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

-- Back button
styles["wiki-back-button"] =
{
	type = "button_style",
	horizontal_align = "left",
	default_graphical_set = arrow_back(red_arrow_tileset, arrow_idle_index, "shadow", default_dirt_color),
	hovered_graphical_set = arrow_back(red_arrow_tileset, arrow_hovered_index, "glow", red_arrow_button_glow_color),
	clicked_graphical_set = arrow_back(red_arrow_tileset, arrow_clicked_index),
	disabled_font_color = {0.5, 0.5, 0.5},
	horizontally_squashable = "on",
	disabled_graphical_set = arrow_back(red_arrow_tileset, arrow_disabled_index, "glow", default_dirt_color)
}

styles["wiki-title-flow"] =
{
	type = "horizontal_flow_style",
    horizontal_align = "center",
	vertically_stretchable = "off",
	natural_width = 500,
    padding = 1,
	margin = 1
}
-- Description labels
styles["wiki-description-label"] =
{
	type = "label_style",
	parent = "label",
	font = "default",
	rich_text_setting = "enabled",
	single_line = false,
	vertically_stretchable = "on",
	horizontally_stretchable = "off",
	width = 500
}

styles["wiki-image-flow"] =
{
	type = "horizontal_flow_style",
    horizontal_align = "center",
	natural_width = 500,
	vertically_stretchable = "off"
}