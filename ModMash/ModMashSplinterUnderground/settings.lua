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
		order = "d"
	},{
		type = "int-setting",
		name = "setting-resource-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "e"
	},{
		type = "int-setting",
		name = "setting-pollution-transfer-mod",
		setting_type = "startup",
		default_value = 75,
		minimum_value = 50,
		maximum_value = 100,
		order = "f"
	}
})