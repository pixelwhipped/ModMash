﻿data:extend(
{
	{
		type = "string-setting",
		name = "setting-surface-detination",
		setting_type = "runtime-global",
		default_value = "Current",
		allowed_values = {"Current", "All"},
		order = "a"
	}
})

data:extend(
{
	{
		type = "bool-setting",
		name = "setting-shortcuts-only",
		setting_type = "runtime-global",
		default_value = false,
		order = "b"
	}
})