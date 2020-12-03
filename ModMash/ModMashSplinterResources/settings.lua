data:extend(
{
	{
		type = "int-setting",
		name = "setting-alien-loot-chance",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "a"
	},{
		type = "string-setting",
		name = "setting-glass-recipes",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "b"
	}
})