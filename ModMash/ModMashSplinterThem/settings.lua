data:extend(
{
	{
		type = "int-setting",
		name = "setting-end-game-mod",
		setting_type = "startup",
		default_value = 50,
		minimum_value = 0,
		maximum_value = 100,
		order = "a "
	},
	{
		type = "int-setting",
		name = "setting-end-game-boom-mod",
		setting_type = "startup",
		default_value = 50,
		minimum_value = 0,
		maximum_value = 100,
		order = "b "
	},
	{
		type = "string-setting",
		name = "setting-domination-mode",
		setting_type = "startup",
		default_value = "Off",
		allowed_values = {"Off", "On"},
		order = "c"
	},
	{
		type = "string-setting",
		name = "setting-mineable-concrete",
		setting_type = "startup",
		default_value = "Off",
		allowed_values = {"Off", "On"},
		order = "d"
	}
})