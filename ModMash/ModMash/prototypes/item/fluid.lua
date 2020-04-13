--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
	{
		type = "fluid",
		name = "alien-ooze",
		default_temperature = 25,
		max_temperature = 100,			
		heat_capacity = "0.2KJ",
		base_color = {r=1.0, g=0.0, b=0.8},
		flow_color = {r=1.0, g=0.0, b=0.7},
		icon = "__modmashgraphics__/graphics/icons/alien-ooze.png",
		icon_size = 32,
		order = "a[fluid]-g[alien-ooze]",
	},{
		type = "fluid",
		name = "sludge",
		default_temperature = 50,
		max_temperature = 100,			
		heat_capacity = "0.1KJ",
		base_color = {r=0.5, g=0.0, b=0.0},
		flow_color = {r=0.4, g=0.25, b=0.0},
		icon = "__modmashgraphics__/graphics/icons/sludge.png",
		icon_size = 32,
		order = "a[fluid]-h[sludge]",
	},{
		type = "fluid",
		name = "fish-oil",
		default_temperature = 50,
		max_temperature = 100,			
		heat_capacity = "0.1KJ",
		base_color = {r=1.0, g=1.0, b=0.0},
		flow_color = {r=0.9, g=0.9, b=0.0},
		icon = "__modmashgraphics__/graphics/icons/fish-oil.png",
		icon_size = 32,
		order = "a[fluid]-i[fish-oil]",
	}
})