data:extend(
{
	 {
		type = "string-setting",
		name = "setting-tech-loot",
		setting_type = "startup",
		default_value = "Instant",
		allowed_values = {"Instant", "Science", "Disabled"},
		order = "a"
	},
  	{
		type = "string-setting",
		name = "setting-item-loot",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "b"
	},
	{
		type = "string-setting",
		name = "setting-loot-planet",
		setting_type = "startup",
		default_value = "Nauvis",
		allowed_values = {"Nauvis", "Any"},
		order = "e" 
	},{
		type = "int-setting",
		name = "setting-loot-chance",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "f "
	},
})