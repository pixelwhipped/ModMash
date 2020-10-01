data:extend(
{
	{
		duration_in_ticks = 180000,

		animation= {
			frame_count = 1,
			width = 16,
			priority = "extra-high",
			animation_speed = 0.0001,
			filename =  "__coffee__/graphics/stickers/blank.png",
			height= 16,
		},
		single_particle = true,
		target_movement_modifier = 0.6,
		type = "sticker",
		name = "coffee-blank-sticker"
	},
	{
		type = "capsule",
		name = "coffee-beans",
		icon = "__coffee__/graphics/icons/coffee-beans.png",
		icon_size = 32,
		subgroup = "raw-resource",
		capsule_action =
		{
			type = "use-on-self",
			attack_parameters =
			{
			type = "projectile",
			ammo_category = "capsule",
			cooldown = 45,
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
					damage = {type = "physical", amount = -1}
					}
				}
				}
			}
			}
		},
		order = "a[grenade]-a[normal]-b[coffee-beans]",
		stack_size = 100
	}, 
	{
		type = "capsule",
		name = "coffee-low-grade",
		icon = "__coffee__/graphics/icons/coffee-low-grade.png",
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
					damage = {type = "physical", amount = -2}
					}
				}
				}
			}
			}
		},
		subgroup = "capsule",
		order = "a[grenade]-a[normal]-c[coffee-low-grade]",
		stack_size = 100
	},{
		type = "capsule",
		name = "coffee-high-grade",
		icon = "__coffee__/graphics/icons/coffee-high-grade.png",
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
					damage = {type = "physical", amount = -5}
					}
				}
				}
			}
			}
		},
		subgroup = "capsule",
		order = "a[grenade]-a[normal]-d[coffee-high-grade]",
		stack_size = 100
	},
	{
		type = "item",
		name = "coffee-tree",
		icon = "__base__/graphics/icons/tree-01.png",
		icon_mipmaps = 4,
		icon_size = 64,
		subgroup = "raw-resource",
		subgroup = "capsule",
		order = "a[grenade]-a[normal]-e[coffee-tree]",
		place_result = "tree-01",
		stack_size = 100
	}
	})