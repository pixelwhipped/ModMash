data:extend(
{
	{
		type = "bool-setting",
		name = "modmash-show-welcome",
		setting_type = "startup",
		default_value = true,
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
	}
})