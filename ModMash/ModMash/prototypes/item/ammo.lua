data:extend(
{
  {
    type = "ammo",
    name = "titanium-rounds-magazine",
    icon = "__modmash__/graphics/icons/titanium-rounds-magazine.png",
	localised_name = "Titanium rounds magazine",
	localised_description = "Titanium rounds magazine Damage 32",
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
              type = "create-entity",
              entity_name = "explosion-hit"
            },
            {
              type = "damage",
              damage = { amount = 32, type = "physical"}
            }
          }
        }
      }
    },
    magazine_size = 10,
    subgroup = "ammo",
    order = "a[basic-clips]-d[piercing-rounds-magazine]",
    stack_size = 200
  },
  {
    type = "ammo",
    name = "alien-rounds-magazine",
	localised_name = "Alien rounds magazine",
	localised_description = "Alien rounds magazine Damage 48",
    icon = "__modmash__/graphics/icons/alien-rounds-magazine.png",
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
              type = "create-entity",
              entity_name = "explosion-hit"
            },
            {
              type = "damage",
              damage = { amount = 48, type = "physical"}
            }
          }
        }
      }
    },
    magazine_size = 10,
    subgroup = "ammo",
    order = "a[basic-clips]-e[alien-rounds-magazine]",
    stack_size = 200
  },
  }
)