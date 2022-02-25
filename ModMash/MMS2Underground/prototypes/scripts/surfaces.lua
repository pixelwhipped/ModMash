--defines surfaces where underground systems are allowed
local surfaces = {}
surfaces["nauvis"] = {
	resources = {
		{name = "uranium-ore", probability = 0.15},
		{name = "uranium-ore", probability = 0.4},
		{name = "uranium-ore", probability = 0.4},
		{name = "uranium-ore", probability = 0.25},
		{name = "uranium-ore", probability = 0.25},
	},
	blocked_top = {
	},
	blocked_bottom = {
		{type="solar-panel"},
		{type="rocket-silo"}
	}
}