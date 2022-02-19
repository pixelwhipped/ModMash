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
	},{
		type = "int-setting",
		name = "setting-teleport-cooldown",
		setting_type = "runtime-global",
		default_value = 2,
		minimum_value = 1,
		maximum_value = 4,
		order = "g"
	},
	{
		type = "bool-setting",
		name = "setting-exculude-se",
		setting_type = "startup",
		default_value = true,
		order = "h"
	},{
		type = "int-setting",
		name = "setting-underground-biters",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 500,
		order = "i"
	},
})