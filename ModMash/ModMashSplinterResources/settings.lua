data:extend(
{
	{
		type = "string-setting",
		name = "setting-alien-disable-loot-chance",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "a"
	},
	{
		type = "int-setting",
		name = "setting-alien-loot-chance",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "b"
	},{
		type = "string-setting",
		name = "setting-glass-recipes",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "c"
	}
})