--[[ Made changes 2020-04-21 honk honk
--]]
data:extend(
{
	--[[{
		type = "bool-setting",
		name = "modmash-show-welcome",
		setting_type = "startup",
		default_value = false,
		order = "aa" -- important settings at top
	},]]
	{
		type = "bool-setting",
		name = "modmash-setting-show-adjustable",
		setting_type = "startup",
		default_value = false,
		order = "ab"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-adjust-binding",
		setting_type = "startup",
		default_value = "CONTROL + A",
		allowed_values = {"CONTROL + A", "CONTROL + G", "CONTROL + M"},
		order = "ac"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-tech-loot",
		setting_type = "startup",
		default_value = "Instant Tech",
		allowed_values = {"Instant Tech", "Science", "Disabled"},
		order = "ba" --second from top
	},
  	{
		type = "string-setting",
		name = "modmash-setting-item-loot",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "bb"
	},
	{
		type = "string-setting",
		name = "modmash-setting-loot-fill",
		setting_type = "startup",
		default_value = "Disabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "bc"
	},	
  	{
		type = "int-setting",
		name = "modmash-setting-loot-chance",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "bd"
	},{
		type = "int-setting",
		name = "modmash-alien-loot-chance",
		setting_type = "startup",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "be"
	},
	{
		type = "string-setting",
		name = "modmash-setting-loaders",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "la" -- logistic
	},
  	{
		type = "string-setting",
		name = "modmash-setting-mini-loaders",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "lb"
	},
  	{
		type = "string-setting",
		name = "modmash-setting-loader-snapping",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "lc"
	},
	{
		type = "string-setting",
		name = "modmash-check-recipies",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "za" -- "debug" sort of, so at bottom
	},{
		type = "string-setting",
		name = "modmash-check-tech",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "zb"
	},{
		type = "string-setting",
		name = "modmash-setting-glass",
		setting_type = "startup",
		default_value = "Normal",
		allowed_values = {"Normal", "Hard"},
		order = "oa" -- option
	},{
		type = "string-setting",
		name = "modmash-check-pollution",
		setting_type = "startup",
		default_value = "Enabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "ob"
	},{
		type = "string-setting",
		name = "modmash-allow-science-ores",
		setting_type = "startup",
		default_value = "Disabled",
		allowed_values = {"Enabled", "Disabled"},
		order = "oc"
	},{
		type = "string-setting",
		name = "modmash-bob-support",
		setting_type = "startup",
		default_value = "No",
		allowed_values = {"Yes", "No"},
		order = "od"
	},{
		type = "string-setting",
		name = "modmash-droid-support",
		setting_type = "startup",
		default_value = "ModMash",
		allowed_values = {"ModMash", "Construction Drone"},
		order = "oe"
	}
	,{
		type = "bool-setting",
		name = "modmash-allow-air-filter-below",
		setting_type = "startup",
		default_value = false,
		order = "of"
	}
})