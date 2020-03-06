data:extend(
{
  {
    type = "ammo",
    name = "mini-nuke-magazine",
    icon = "__mininukes__/graphics/icons/mini-nuke-magazine.png",
    icon_size = 32,    
    ammo_type =
    {
      category = "bullet",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          source_effects =
          {
            type = "create-explosion",
            entity_name = "explosion-gunshot"
          },
          target_effects =
          {
            {
              repeat_count = 10,
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
            type = "damage",
            damage = {amount = 100, type = "explosion"}
          },
          {
            type = "create-entity",
            entity_name = "big-scorchmark",
            check_buildability = true
          },
          {
            type = "nested-result",
            action =
            {
              type = "area",
              target_entities = false,
              trigger_from_target = false,
              repeat_count = 500,
              radius = 8,
              action_delivery =
              {
                type = "projectile",
                projectile = "mini-nuke-wave",
                starting_speed = 0.5
              }
            }
          }
          }
        }
      }
    },
    magazine_size = 2,
    subgroup = "ammo",
    order = "a[basic-clips]-z[piercing-rounds-magazine]",
    stack_size = 200
  },
  {
    type = "projectile",
    name = "mini-nuke-wave",
    flags = {"not-on-map"},
    acceleration = 0,
    action =
    {
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-entity",
              entity_name = "explosion"
            }
          }
        }
      },
      {
        type = "area",
        radius = 2,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            type = "damage",
            damage = {amount = 100, type = "explosion"}
          }
        }
      }
    },
    animation =
    {
      filename = "__core__/graphics/empty.png",
      frame_count = 1,
      width = 1,
      height = 1,
      priority = "high"
    },
    shadow =
    {
      filename = "__core__/graphics/empty.png",
      frame_count = 1,
      width = 1,
      height = 1,
      priority = "high"
    }
  }
  }
)