data:extend(
  {
	{
		type = "land-mine",
		name = "toxin-land-mine",
		icon = "__modmashsplinterdefense__/graphics/icons/land-mine-nt.png",
		icon_size = 64,
		icon_mipmaps = 4,
		create_ghost_on_death = false,
		flags =
			{
			"placeable-player",
			  "placeable-enemy",
			  "player-creation",
			  "placeable-off-grid",
			  "not-on-map",
			  "not-repairable"
			},
		minable = { mining_time = 0.5, result = "toxin-land-mine"},
		mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
		max_health = 15,
		corpse = "small-remnants",
		collision_box = { { -0.4,-0.4}, { 0.4, 0.4} },
		selection_box = { { -0.5, -0.5}, { 0.5, 0.5} },
		picture_safe =
		{
		  filename = "__modmashsplinterdefense__/graphics/entity/land-mine-nt/hr-land-mine-a.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set =
		{
		  filename = "__modmashsplinterdefense__/graphics/entity/land-mine-nt/hr-land-mine-set-a.png",
		  priority = "medium",
		  width = 64,
		  height = 64,
		  scale = 0.5
		},
		picture_set_enemy =
		{
		  filename = "__base__/graphics/entity/land-mine/land-mine-set-enemy.png",
		  priority = "medium",
		  width = 32,
		  height = 32,
		},
		trigger_radius = 3,
		ammo_category = "landmine",
		action =
		{
			type = "direct",
		  action_delivery =
		  {
				type = "instant",
			source_effects =
			{
					{
						type = "create-entity",
				entity_name = "explosion"
	  			  },
			  {
						type = "create-entity",
				show_in_tooltip = true,
				trigger_created_entity = true,
				entity_name = "biter-neuro-toxin-cloud",
			  }, 
			}
			}
		}
	},
	{
	  icon = "__modmashsplinterdefense__/graphics/icons/land-mine-nt.png",
	  icon_size = 64,
	  icon_mipmaps = 4,
      name = "toxin-land-mine",
      order = "f[toxin-land-mine]",
      place_result = "toxin-land-mine",
      stack_size = 100,
      subgroup = "gun",
      type = "item"

	},
	{
		enabled = false,
      energy_required = 5,
      ingredients =
	  {
			{
				"land-mine",
          1
	
		},
        { "alien-artifact",1},
		{ "fish-juice", 4},
		{ "ooze-juice", 4},
		{ type = "fluid", name = "sludge", amount = 40}
		},
	  category = "crafting-with-fluid",
      name = "toxin-land-mine",
      result = "toxin-land-mine",
      result_count = 1,
      type = "recipe"

	},
	{
		effects =
	  {
			{
				recipe = "toxin-land-mine",
          type = "unlock-recipe"
	
		}
		},
      icon = "__base__/graphics/technology/land-mine.png",
      icon_size = 256, icon_mipmaps = 4,
      name = "toxin-land-mine",
      order = "e-e",
      prerequisites = { "land-mine","biter-neuro-toxin-artillery-shell" },
      type = "technology",
      unit = {
			count = 100,
        ingredients =
		{
				{
					"automation-science-pack",
            1
	  
		  },
          {
					"logistic-science-pack",
            1

		  },
          {
					"military-science-pack",
            1

		  }
			},
        time = 30

	  }
	},
})