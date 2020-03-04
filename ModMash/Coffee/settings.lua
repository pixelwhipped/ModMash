data:extend(
{
  	{
		type = "string-setting",
		name = "coffee-setting-no-coffee",
		setting_type = "runtime-global",
		default_value = "It Hurts",
		allowed_values = {"It Hurts", "Feeling Sluggish", "Massive Withdrawals", "No Dammage"},
		order = "a"
	},  	
	{
		type = "int-setting",
		name = "coffee-setting-speed-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "b"
	},
	{
		type = "int-setting",
		name = "coffee-setting-mining-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "c"
	},
	{
		type = "int-setting",
		name = "coffee-setting-crafting-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "d"
	},
	{
		type = "int-setting",
		name = "coffee-setting-build-dist-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "e"
	},
	{
		type = "int-setting",
		name = "coffee-setting-reach-dist-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "f"
	},
	{
		type = "int-setting",
		name = "coffee-setting-pickup-dist-mod",
		setting_type = "runtime-global",
		default_value = 100,
		minimum_value = 0,
		maximum_value = 100,
		order = "g"
	},
})