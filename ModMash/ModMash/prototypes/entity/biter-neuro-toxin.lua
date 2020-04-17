--[[Code check 29.2.20
removed old comments
--]]
if not modmash or not modmash.util then require("prototypes.scripts.util") end

local get_name_for = modmash.util.get_name_for

data:extend({
  {
    type = "ammo",
    name = "biter-neuro-toxin-artillery-shell",
    icon = "__modmashgraphics__/graphics/icons/biter-neuro-toxin.png",

    icon_size = 32,
    ammo_type =
    {
      category = "artillery-shell",
      target_type = "position",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "artillery",
          projectile = "biter-neuro-toxin-projectile",
          starting_speed = 1,
          direction_deviation = 0,
          range_deviation = 0,
          source_effects =
          {
            type = "create-explosion",
            entity_name = "artillery-cannon-muzzle-flash"
          },
        }
      },
    },
    subgroup = "ammo",
    order = "d[explosive-cannon-shell]-d[artillery]",
    stack_size = 1
  },
  -- projectile
  {
    type = "artillery-projectile",
    name = "biter-neuro-toxin-projectile",
    flags = {"not-on-map"},
    acceleration = 0,
    direction_only = true,
    reveal_map = true,
    map_color = {r=0.2, g=1, b=0},
    picture =
    {
      filename = "__base__/graphics/entity/artillery-projectile/hr-shell.png",
      width = 64,
      height = 64,
      scale = 0.5,
    },
    shadow =
    {
      filename = "__base__/graphics/entity/artillery-projectile/hr-shell-shadow.png",
      width = 64,
      height = 64,
      scale = 0.5,
    },
    chart_picture =
    {
      filename = "__base__/graphics/entity/artillery-projectile/artillery-shoot-map-visualization.png",
      flags = { "icon" },
      frame_count = 1,
      width = 64,
      height = 64,
      priority = "high",
      scale = 0.25,
    },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "nested-result",
            action =
            {
              type = "area",
              radius = 4.0,
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = {amount = 0 , type = "physical"}
                  },
                  {
                    type = "damage",
                    damage = {amount = 0 , type = "explosion"}
                  }
                }
              }
            }
          },
          {
            type = "create-entity",
            show_in_tooltip = true,
			trigger_created_entity = true,
            entity_name = "biter-neuro-toxin-cloud",
          },      
          {
            type = "create-entity",
            entity_name = "big-artillery-explosion"
          },		  
          {
            type = "show-explosion-on-chart",
            scale = 8/32,
          }
        }
      }
    },    
    animation =
    {
      filename = "__base__/graphics/entity/bullet/bullet.png",
      frame_count = 1,
      width = 3,
      height = 50,
      priority = "high"
    },
  },
  -- cloud
  {
    type = "smoke-with-trigger",
    name = "biter-neuro-toxin-cloud",
    flags = {"not-on-map"},
    show_when_smoke_off = true,
	trigger_created_entity="true",
    animation =
    {
      filename = "__base__/graphics/entity/cloud/cloud-45-frames.png",
      flags = { "compressed" },
      priority = "low",
      width = 256,
      height = 256,
      frame_count = 45,
      animation_speed = 0.5,
      line_length = 7,
      scale = 4.5,
    },
    slow_down_factor = 0,
    affected_by_wind = true,
    cyclic = true,
    duration = 1,
    fade_away_duration = 1,
    spread_duration = 15,
    color = { r = 0.1, g = 0.0, b = 0.45, a = 0},
    action =
	{
		{
		  type = "direct",
		  action_delivery =
		  {
			type = "instant",
			target_effects =
			{
			  type = "nested-result",
			  action =
			  {
				type = "area",
				radius = 20,
				entity_flags = {"breaths-air"},
				force = "enemy",
				action_delivery =
				{
				  type = "instant",
				  target_effects =
				  {
					  {
						type = "damage",
						damage = { amount = 0, type = "poison"}
					  },
				  }
				}
			  }
			}
		  }
		},
		{
		  type = "direct",
		  action_delivery =
		  {
			type = "instant",
			target_effects =
			{
			  type = "nested-result",
			  action =
			  {
				type = "area",
				radius = 20,
				entity_flags = {"not-repairable"},
				force = "ally",
				--forces = {"ally","enemy"},
				action_delivery =
				{
				  type = "instant",
				  target_effects =
				  {
					  {
						type = "damage",
						damage = { amount = 0, type = "poison"}
					  }					  
				  }
				}
			  }
			}
		  }
		}
	},
    action_cooldown = 30
  },
  {
      affected_by_wind = false,
      animation = {
        animation_speed = 0.25,
        filename = "__base__/graphics/entity/smoke/smoke.png",
        flags = {
          "smoke"
        },
        frame_count = 60,
        height = 120,
        line_length = 5,
        priority = "high",
        shift = {
          -0.53125,
          -0.4375
        },
        width = 152
      },
      color = { r = 0.1, g = 0.0, b = 0.45, a = 0.5},
      cyclic = true,
      duration = 1440,
      fade_away_duration = 180,
      flags = {
        "not-on-map"
      },
      name = "toxin-poison-cloud-visual-dummy",
      particle_count = 24,
      particle_distance_scale_factor = 0.5,
      particle_duration_variation = 180,
      particle_scale_factor = {
        1,
        0.70699999999999994
      },
      particle_spread = {
        3.7800000000000002,
        2.2680000000000002
      },
      render_layer = "object",
      show_when_smoke_off = true,
      spread_duration = 140,
      spread_duration_variation = 280,
      type = "smoke-with-trigger",
      wave_distance = {
        1,
        0.5
      },
      wave_speed = {
        0.00625,
        0.0083333333333333321
      }
  },
  {
		action = {
		action_delivery = {
			target_effects = {
			action = {
				action_delivery = {
				target_effects = {
					damage = {
					amount = 0,
					type = "poison"
					},
					type = "damage"
				},
				type = "instant"
				},
				entity_flags = {
				"breaths-air"
				},
				radius = 11,
				type = "area"
			},
			type = "nested-result"
			},
			type = "instant"
		},
		type = "direct"
		},
		action_cooldown = 30,
		affected_by_wind = false,
		animation = {
		animation_speed = 0.25,
		filename = "__base__/graphics/entity/smoke/smoke.png",
		flags = {
			"smoke"
		},
		frame_count = 60,
		height = 120,
		line_length = 5,
		priority = "high",
		shift = {
			-0.53125,
			-0.4375
		},
		width = 152
		},
		color = { r = 0.1, g = 0.0, b = 0.45, a = 0.5},
		created_effect = {
		{
			action_delivery = {
			target_effects = {
				entity_name = "toxin-poison-cloud-visual-dummy",
				initial_height = 0,
				show_in_tooltip = false,
				type = "create-smoke"
			},
			type = "instant"
			},
			cluster_count = 10,
			distance = 4,
			distance_deviation = 5,
			type = "cluster"
		},
		{
			action_delivery = 
			{
				target_effects = {
					entity_name = "toxin-poison-cloud-visual-dummy",
					initial_height = 0,
					show_in_tooltip = false,
					type = "create-smoke"
				},
				type = "instant"
			},
			cluster_count = 11,
			distance = 8.8000000000000007,
			distance_deviation = 2,
			type = "cluster"
		}
		},
		cyclic = true,
		duration = 1200,
		fade_away_duration = 120,
		flags = {
			"not-on-map"
		},
		name = "toxin-poison-cloud",
		particle_count = 16,
		particle_distance_scale_factor = 0.5,
		particle_duration_variation = 180,
		particle_scale_factor = {
			1,
			0.70699999999999994
		},
		particle_spread = {
			3.7800000000000002,
			2.2680000000000002
		},
		render_layer = "object",
		show_when_smoke_off = true,
		spread_duration = 20,
		spread_duration_variation = 20,
		type = "smoke-with-trigger",
		wave_distance = {
			0.3,
			0.2
		},
		wave_speed = {
			0.0125,
			0.016666666666666665
		},
		working_sound = 
		{
			sound = {
				filename = "__base__/sound/fight/poison-cloud.ogg",
				volume = 0.7
			}
		}
	},
  
  -- technology
  {
    type = "technology",
    name = "biter-neuro-toxin-artillery-shell",
    icon = "__base__/graphics/technology/artillery.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "biter-neuro-toxin-artillery-shell"
      }
    },
    prerequisites = {"artillery"},
    unit =
    {
      ingredients =
      {
        {"automation-science-pack", 1},
	    {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
      },
      time = 30,
      count = 500
    },
    order = "a-h-d"
  },  
  {
			type = "technology",
			name = "enhance-biter-neuro-toxin-range-1",
			icon = "__base__/graphics/technology/artillery-range.png",
			icon_size = 128,
			localised_name = {"technology-name.enhance-biter-neuro-toxin-range-1"},
			localised_description =  {"technology-description.enhance-biter-neuro-toxin-range-1"},
			effects =
			{
			},
			prerequisites =
			{
				"biter-neuro-toxin-artillery-shell"
			},
			unit =
			{
				count = 200,
				ingredients =
				{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},	
					{"chemical-science-pack", 1},
				    {"military-science-pack", 1},
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
  -- recipe
  {
    type = "recipe",
    name = "biter-neuro-toxin-artillery-shell",
	category = "crafting-with-fluid",
    enabled = false,
    energy_required = 15,
    ingredients =
    {
      {"artillery-shell", 1},
	  {"alien-artifact",1},
      {"fish-juice", 4},
	  {"ooze-juice", 4},
	  {type="fluid", name="sludge", amount=40}
    },
    result = "biter-neuro-toxin-artillery-shell"
  },
})


local create_technology = function(level)
	return  
	{
		{
			type = "technology",
			name = "enhance-biter-neuro-toxin-range-"..level,
			icon = "__base__/graphics/technology/artillery-range.png",
			icon_size = 128,
			localised_name = {"",{"technology-name.enhance-biter-neuro-toxin-range-1"}," ",level},
			localised_description =  {"technology-description.enhance-biter-neuro-toxin-range-1"},
			effects =
			{
			},
			prerequisites =
			{
				"enhance-biter-neuro-toxin-range-"..(level-1)
			},
			unit =
			{
				count = (200+(level*100)),
				ingredients =
				{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},	
					{"chemical-science-pack", 1},
				    {"military-science-pack", 1},
				},
				time = 45
			},
			upgrade = true,
			order = "a-b-d",
		},
	}
end

for k=2, 6 do
	data:extend(create_technology(k))
end