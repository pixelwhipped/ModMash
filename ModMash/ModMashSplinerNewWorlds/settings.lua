data:extend(
{
	{
		type = "int-setting",
		name = "setting-launch-platform-lag",
		setting_type = "startup",
		default_value = 1,
		minimum_value = 1,
		maximum_value = 60,
		order = "a"
	},{
		type = "string-setting",
		name = "setting-lab-mod",
		setting_type = "startup",
		default_value = "Original",
		allowed_values = {"Original", "Experimental"},
		order = "b"
	},
})

data:extend(
{
	{
		type = "bool-setting",
		name = "new-worlds-setting-shortcuts-only",
		setting_type = "runtime-global",
		default_value = false,
		order = "c"
	}
})