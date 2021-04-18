data:extend(
{
	{
		type = "string-setting",
		name = "setting-check-pollution",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "a"
	},
	{
		type = "string-setting",
		name = "setting-restrict-placement",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "b"
	}
})