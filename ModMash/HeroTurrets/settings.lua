data:extend(
{
	{
		type = "int-setting",
		name = "heroturrets-setting-level-up-modifier",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "a"
	},{
		type = "int-setting",
		name = "heroturrets-setting-level-buff-modifier",
		setting_type = "startup",
		default_value = 0,
		minimum_value = 0,
		maximum_value = 100,
		order = "b"
	},{
		type = "bool-setting",
		name = "heroturrets-allow-ghost-rank",
		setting_type = "runtime-global",
		default_value = false,
		order = "c"
	},
	--[[{
		type = "bool-setting",
		name = "heroturrets-allow-blueprint-rank",
		setting_type = "runtime-global",
		default_value = false,
		order = "d"
	},]]
	{
		type = "string-setting",
		name = "heroturrets-kill-counter",
		setting_type = "startup",
		default_value = "Fuzzy",
		allowed_values = {"Fuzzy", "Exact"},
		order = "e"
	},
})