--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "ammo",
    name = "titanium-rounds-magazine",
    icon = "__modmashsplinterdefense__/graphics/icons/titanium-rounds-magazine.png",
    icon_size = 64,
	icon_mipmaps = 4,    
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
              damage = { amount = 28, type = "physical"}
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
    icon = "__modmashsplinterdefense__/graphics/icons/alien-rounds-magazine.png",
    icon_size = 64,
	icon_mipmaps = 4,
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
    order = "a[basic-clips]-e[alien-rounds-magazine]",
    stack_size = 200
  },
  }
)