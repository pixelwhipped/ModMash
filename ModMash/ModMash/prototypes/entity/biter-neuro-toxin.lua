--[[Code check 29.2.20
removed old comments
--]]
if not modmash or not modmash.util then require("prototypes.scripts.util") end

local get_name_for = modmash.util.get_name_for

data:extend({
  {
    type = "ammo",
    name = "biter-neuro-toxin-artillery-shell",
    icon = "__modmash__/graphics/icons/biter-neuro-toxin.png",

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
    duration = 60 * 50,
    fade_away_duration = 2 * 60,
    spread_duration = 15,
    color = { r = 0.1, g = 0.0, b = 0.45 },
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