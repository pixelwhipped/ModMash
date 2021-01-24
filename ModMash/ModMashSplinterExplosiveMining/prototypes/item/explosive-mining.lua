data:extend(
{
    {
      acceleration = 0.005,
      action = {
        {
          action_delivery = {
            target_effects = {
              {
                entity_name = "grenade-explosion",
                type = "create-entity"
              },
              {
                check_buildability = true,
                entity_name = "small-scorchmark-tintable",
                type = "create-entity"
              },
              {
                repeat_count = 1,
                type = "invoke-tile-trigger"
              },
              {
                decoratives_with_trigger_only = false,
                from_render_layer = "decorative",
                include_decals = false,
                include_soft_decoratives = true,
                invoke_decorative_trigger = true,
                radius = 2.25,
                to_render_layer = "object",
                type = "destroy-decoratives"
              }
            },
            type = "instant"
          },
          type = "direct"
        },
        {
          action_delivery = {
            target_effects = {
              {
                damage = {
                  amount = 5,
                  type = "explosion"
                },
                type = "damage"
              },
              {
                entity_name = "explosion",
                type = "create-entity"
              }
            },
            type = "instant"
          },
          radius = 6.5,
          type = "area"
        }
      },
      animation = {
        animation_speed = 0.25,
        draw_as_glow = true,
        filename = "__modmashsplinterexplosivemining__/graphics/entity/explosive/explosives.png",
        frame_count = 16,
        height = 28,
        hr_version = {
          animation_speed = 0.25,
          draw_as_glow = true,
          filename = "__modmashsplinterexplosivemining__/graphics/entity/explosive/hr-explosives.png",
          frame_count = 16,
          height = 54,
          line_length = 8,
          priority = "high",
          scale = 0.5,
          shift = {
            0.015625,
            0.015625
          },
          width = 48
        },
        line_length = 8,
        priority = "high",
        shift = {
          0.03125,
          0.03125
        },
        width = 26
      },
      flags = {
        "not-on-map"
      },
      light = {
        intensity = 0.5,
        size = 4
      },
      name = "mining-explosive",
      shadow = {
        animation_speed = 0.25,
        draw_as_shadow = true,
        filename = "__modmashsplinterexplosivemining__/graphics/entity/explosive/explosives-shadow.png",
        frame_count = 16,
        height = 20,
        hr_version = {
          animation_speed = 0.25,
          draw_as_shadow = true,
          filename = "__modmashsplinterexplosivemining__/graphics/entity/explosive/hr-explosives-shadow.png",
          frame_count = 16,
          height = 40,
          line_length = 8,
          priority = "high",
          scale = 0.5,
          shift = {
            0.0625,
            0.1875
          },
          width = 50
        },
        line_length = 8,
        priority = "high",
        shift = {
          0.0625,
          0.1875
        },
        width = 26
      },
      type = "projectile"
    },
    {
      capsule_action = {
        attack_parameters = {
          activation_type = "throw",
          ammo_category = "grenade",
          ammo_type = {
            action = {
              {
                action_delivery = {
                  projectile = "mining-explosive",
                  starting_speed = 0.3,
                  type = "projectile"
                },
                type = "direct"
              },
              {
                action_delivery = {
                  target_effects = {
                    {
                      sound = {
                          {
                            filename = "__base__/sound/fight/throw-projectile-1.ogg",
                            volume = 0.4
                          },
                          {
                            filename = "__base__/sound/fight/throw-projectile-2.ogg",
                            volume = 0.4
                          },
                          {
                            filename = "__base__/sound/fight/throw-projectile-3.ogg",
                            volume = 0.4
                          },
                          {
                            filename = "__base__/sound/fight/throw-projectile-4.ogg",
                            volume = 0.4
                          },
                          {
                            filename = "__base__/sound/fight/throw-projectile-5.ogg",
                            volume = 0.4
                          },
                          {
                            filename = "__base__/sound/fight/throw-projectile-6.ogg",
                            volume = 0.4
                          }
                        },
                        type = "play-sound"
                    }
                  },
                  type = "instant"
                },
                type = "direct"
              }
            },
            category = "grenade",
            target_type = "position"
          },
          cooldown = 30,
          projectile_creation_distance = 0.6,
          range = 15,
          type = "projectile"
        },
        type = "throw"
      },
      icon = "__modmashsplinterexplosivemining__/graphics/icons/explosives.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "mining-explosive",
      order = "d[acliff-explosive]",
      stack_size = 100,
      subgroup = "terrain",
      type = "capsule"
    }
}
)