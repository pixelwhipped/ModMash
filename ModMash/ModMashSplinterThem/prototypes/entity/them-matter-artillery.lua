require("prototypes.scripts.defines")
local set = settings.startup["setting-end-game-boom-mod"].value
local mod = ((set-50)/100)*256

data:extend({
  {
    type = "ammo",
    name = "them-matter-artillery",
    icon = "__modmashsplinterthem__/graphics/icons/matter-artillery.png",
	icon_size = 64,
	icon_mipmaps = 4,
    pictures = {
        layers = {
          {
            filename = "__modmashsplinterthem__/graphics/icons/matter-artillery.png",
            mipmap_count = 4,
            scale = 0.25,
            size = 64
          },
          {
            draw_as_light = true,
            filename = "__modmashsplinterthem__/graphics/icons/matter-artillery-light.png",
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
          projectile = "them-matter-artillery-projectile",
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
    name = "them-matter-artillery-projectile",
    flags = {"not-on-map"},
    acceleration = 0,
    direction_only = true,
    reveal_map = true,
    map_color = {r=0.2, g=1, b=0},
    picture =
    {
      filename = "__modmashsplinterthem__/graphics/entity/shells/hr-matter-shell.png",
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
			    type = "camera-effect",
			    effect = "screen-burn",
			    duration = 255,
			    ease_in_duration = 0,
			    ease_out_duration = 240,
			    delay = 0,
			    strength = 10,
			    full_strength_max_distance = 800,
			    max_distance = 1600
			},
			{
				type = "nested-result",
				affects_target = true,
				action =
				{
				  type = "area",
				  radius = 512+mod,
				  force = "all",
				  action_delivery =
				  {
					type = "instant",
					target_effects =
					{
					  {
						type = "damage",
						damage = { amount = 10000, type = "explosion"}
					  }
					},
                    source_effects =
			        {
                        {
				            type = "script",
				            effect_id = "matter-explosion"
			            }
                    }
				  }
				}
			},

			{
				explosion = "explosion",
				radius = 512+mod,
				type = "destroy-cliffs"
			},
            {
				  apply_projection = true,
				  radius = 512+mod,
				  tile_collision_mask = {
					"water-tile",
				  },
				  tile_name = "them-scorched-earth",
				  type = "set-tile"
            },
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
        name = "them-matter-artillery",
        icon = "__base__/graphics/technology/artillery.png",
        icon_mipmaps = 4,
        icon_size = 256,
        effects =
        {
            {
            type = "unlock-recipe",
            recipe = "them-matter-artillery"
            }
        },
        prerequisites = {"space-science-pack"},
        unit =
        {
            ingredients =
            {
            {"automation-science-pack", 1},
	        {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"space-science-pack", 1},
            },
            time = 60,
            count = 4000
        },
        order = "a-h-d"
    },  
    -- recipe
    {
        type = "recipe",
        name = "them-matter-artillery",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 150,
        ingredients =
        {
            {"artillery-shell", 1},
	        {"them-matter-cube", 500},
        },
        result = "them-matter-artillery"
    },
})