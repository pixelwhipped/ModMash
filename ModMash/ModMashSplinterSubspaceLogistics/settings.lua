data:extend(
{
	{
		type = "string-setting",
		name = "setting-subspace",
		setting_type = "startup",
		default_value = "Resource Only",
		allowed_values = {"Items", "Off", "Resource Only"}, --"Category"
		order = "a"
	},{
		type = "int-setting",
		name = "setting-max-recipie-stack",
		setting_type = "startup",
		default_value = 1000,
		minimum_value = 100,
		maximum_value = 1000,
		order = "b"
	}
})