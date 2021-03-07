require("prototypes.scripts.defines")

local get_name_for = modmashsplinterdefense.util.get_name_for

data:extend({
  {
    type = "ammo",
    name = "atomic-artillery-shell",
    icon = "__modmashsplinterdefense__/graphics/icons/atomic-artillery.png",
	icon_size = 64,
	icon_mipmaps = 4,
    pictures = {
        layers = {
          {
            filename = "__modmashsplinterdefense__/graphics/icons/atomic-artillery.png",
            mipmap_count = 4,
            scale = 0.25,
            size = 64
          },
          {
            draw_as_light = true,
            filename = "__modmashsplinterdefense__/graphics/icons/atomic-artillery-light.png",
            flags = {
              "light"
            },
            mipmap_count = 4,
            scale = 0.25,
            size = 64
          }
        }
    },
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
          projectile = "atomic-artillery-projectile",
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
    name = "atomic-artillery-projectile",
    flags = {"not-on-map"},
    acceleration = 0,
    direction_only = true,
    reveal_map = true,
    map_color = {r=0.2, g=1, b=0},
    picture =
    {
      filename = "__modmashsplinterdefense__/graphics/entity/shells/hr-atomic-shell.png",
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
				repeat_count = 100,
				type = "create-trivial-smoke",
				smoke_name = "nuclear-smoke",
				offset_deviation = {{-1, -1}, {1, 1}},
				starting_frame = 3,
				starting_frame_deviation = 5,
				starting_frame_speed = 0,
				starting_frame_speed_deviation = 5,
				speed_from_center = 0.5
			},
			{
			    type = "create-entity",
			    entity_name = "explosion"
			},
			{
			    type = "create-entity",
			    entity_name = "huge-scorchmark",
			    check_buildability = true,
			},
			{
			    type = "camera-effect",
			    effect = "screen-burn",
			    duration = 60,
			    ease_in_duration = 5,
			    ease_out_duration = 60,
			    delay = 0,
			    strength = 6,
			    full_strength_max_distance = 200,
			    max_distance = 800
			},
			{
				type = "nested-result",
				affects_target = true,
				action =
				{
				  type = "area",
				  radius = 8,
				  force = "enemy",
				  action_delivery =
				  {
					type = "instant",
					target_effects =
					{
					  {
						type = "damage",
						damage = { amount = 400, type = "explosion"}
					  }
					}
				  }
				}
			},
			{
				type = "nested-result",
				affects_target = true,
				action =
				{
				  type = "area",
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 2000,
				  radius = 35,
				  action_delivery =
				  {
					type = "projectile",
					projectile = "atomic-bomb-wave",
					starting_speed = 0.5
				  }
				}
			},
			{
				explosion = "explosion",
				radius = 35,
				type = "destroy-cliffs"
			},
            {
				  apply_projection = true,
				  radius = 35,
				  tile_collision_mask = {
					"water-tile",
				  },
				  tile_name = "nuclear-ground",
				  type = "set-tile"
            },
			{
				type = "nested-result",
				action =
				{
				  type = "area",
				  show_in_tooltip = false,
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 1000,
				  radius = 8,
				  action_delivery =
				  {
					type = "projectile",
					projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
					starting_speed = 0.5 * 0.65,
					starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
				  }
				}
			},
			{
				type = "nested-result",
				action =
				{
				  type = "area",
				  show_in_tooltip = false,
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 300,
				  radius = 26,
				  action_delivery =
				  {
					type = "projectile",
					projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
					starting_speed = 0.5 * 0.65,
					starting_speed_deviation = nuke_shockwave_starting_speed_deviation,
				  }
				}
			},
			{
				type = "nested-result",
				action =
				{
				  type = "area",
				  show_in_tooltip = false,
				  target_entities = false,
				  trigger_from_target = true,
				  repeat_count = 10,
				  radius = 8,
				  action_delivery =
				  {
					type = "instant",
					target_effects =
					{
					  {
						type = "create-entity",
						entity_name = "nuclear-smouldering-smoke-source",
						tile_collision_mask = { "water-tile" }
					  }
					}
				  }
				}
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
  
  -- technology
    {
        type = "technology",
        name = "atomic-artillery-shell",
        icon = "__base__/graphics/technology/artillery.png",
        icon_mipmaps = 4,
        icon_size = 256,
        effects =
        {
            {
            type = "unlock-recipe",
            recipe = "atomic-artillery-shell"
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
    -- recipe
    {
        type = "recipe",
        name = "atomic-artillery-shell",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 50,
        ingredients =
        {
            {"artillery-shell", 1},
	        {"explosives", 10},
            {"uranium-235", 30}
        },
        result = "atomic-artillery-shell"
    },
})