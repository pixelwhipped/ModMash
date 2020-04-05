--[[Code check 29.2.20
no changes
--]]
data:extend(
{
	{
		type = "bool-setting",
		name = "modmash-show-welcome",
		setting_type = "startup",
		default_value = false,
	},
	{
		type = "bool-setting",
		name = "modmash-setting-show-adjustable",
		setting_type = "startup",
		default_value = false,
	},
  	{
		type = "string-setting",
		name = "modmash-setting-adjust-binding",
		setting_type = "startup",
		default_value = "CONTROL + A",
		allowed_values = {"CONTROL + A", "CONTROL + G", "CONTROL + M"},
		order = "a"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-tech-loot",
		setting_type = "startup",
		default_value = "Instant Tech",
		allowed_values = {"Instant Tech", "Science", "Disabled"},
		order = "b"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-item-loot",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "c"
	},
	{
		type = "string-setting",
		name = "modmash-setting-loot-fill",
		setting_type = "startup",
		default_value = "Disabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "d"
	},	
  	{
		type = "int-setting",
		name = "modmash-setting-loot-chance",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "e"
	},
	{
		type = "string-setting",
		name = "modmash-setting-loaders",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "f"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-mini-loaders",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "g"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-loader-snapping",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "ga"
	},
	{
		type = "string-setting",
		name = "modmash-check-recipies",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "h"
	},{
		type = "string-setting",
		name = "modmash-check-tech",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "i"
	},{
		type = "string-setting",
		name = "modmash-setting-glass",
		setting_type = "startup",
		default_value = "Normal",
		allowed_values = {"Normal", "Hard"},
		order = "j"
	},{
		type = "string-setting",
		name = "modmash-check-pollution",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "k"
	},{
		type = "string-setting",
		name = "modmash-allow-science-ores",
		setting_type = "startup",
		default_value = "Disabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "l"
	},
	{
		type = "int-setting",
		name = "modmash-alien-ore-chance",
		setting_type = "startup",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "e"
	},{
		type = "string-setting",
		name = "modmash-bob-support",
		setting_type = "startup",
		default_value = "No",
		allowed_values = {"Yes", "No"},
		order = "f"
	},{
		type = "bool-setting",
		name = "modmash-allow-air-filter-below",
		setting_type = "startup",
		default_value = false,
		order = "g"
	}
})