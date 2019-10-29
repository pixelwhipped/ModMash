data:extend(
{
	{
		type = "capsule",
		name = "fish-juice",
		--localised_name = "Fish Juice",
		--localised_description = "Fish Juice",
		icon = "__modmash__/graphics/icons/fish-juice.png",
		icon_size = 32,
		subgroup = "raw-resource",
		capsule_action =
		{
			type = "use-on-self",
			attack_parameters =
			{
			type = "projectile",
			ammo_category = "capsule",
			cooldown = 30,
			range = 0,
			ammo_type =
			{
				category = "capsule",
				target_type = "position",
				action =
				{
				type = "direct",
				action_delivery =
				{
					type = "instant",
					target_effects =
					{
					type = "damage",
					damage = {type = "physical", amount = -100}
					}
				}
				}
			}
			}
		},
		subgroup = "capsule",
		order = "a[grenade]-a[normal]-b[fish-juice]",
		stack_size = 100
	},{
		type = "capsule",
		name = "ooze-juice",
		icon = "__modmash__/graphics/icons/ooze-juice.png",
		icon_size = 32,
		subgroup = "raw-resource",
		capsule_action =
		{
			type = "use-on-self",
			attack_parameters =
			{
			type = "projectile",
			ammo_category = "capsule",
			cooldown = 30,
			range = 0,
			ammo_type =
			{
				category = "capsule",
				target_type = "position",
				action =
				{
				type = "direct",
				action_delivery =
				{
					type = "instant",
					target_effects =
					{
					type = "damage",
					damage = {type = "physical", amount = -100}
					}
				}
				}
			}
			}
		},
		subgroup = "capsule",
		order = "a[grenade]-a[normal]-c[ooze-juice]",
		stack_size = 100
	}
	})