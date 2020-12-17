data:extend(
{
	{
		type = "string-setting",
		name = "setting-resource-detection",
		setting_type = "startup",
		default_value = "Original",
		allowed_values = {"Original", "Experimental"},
		order = "a"
	},
	{
		type = "string-setting",
		name = "setting-surface-detection",
		setting_type = "startup",
		default_value = "Original",
		allowed_values = {"Original", "Experimental"},
		order = "b"
	},{
		type = "string-setting",
		name = "setting-biter-rocks",
		setting_type = "runtime-global",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "c"
	},{
		type = "string-setting",
		name = "setting-biter-teleport",
		setting_type = "runtime-global",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "c"
	}
})