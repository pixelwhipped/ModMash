data:extend(
{
	{
		type = "string-setting",
		name = "setting-mini-loaders",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "a"
	},{
		type = "string-setting",
		name = "setting-loader-wagon-support",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "b"
	},
	{
		type = "string-setting",
		name = "setting-loader-snapping",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "c"
	}
	,
	{
		type = "string-setting",
		name = "setting-adjust-inserter-pickup",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "c"
	}
})