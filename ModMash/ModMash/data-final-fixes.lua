modmash = { util = get_liborio() }
data_final_fixes = true
require("prototypes.entity.logistics")
require ("prototypes.scripts.types")

local local_add_loot_to_entity = function(entityType, entityName, probability, countMin, countMax)
    if data.raw[entityType] ~= nil then
        if data.raw[entityType][entityName] ~= nil then
            if data.raw[entityType][entityName].loot == nil then
                data.raw[entityType][entityName].loot = {}
            end
			local loot_probability = settings.startup["modmash-alien-loot-chance"].value/100.0
            table.insert(data.raw[entityType][entityName].loot, 
			{
				item = "alien-ore", probability = probability * loot_probability, count_min = countMin, count_max = countMax
			}
			)
			table.insert(data.raw[entityType][entityName].loot,
			{
				item = "alien-artifact", probability = (probability / 20) * loot_probability, count_min = 1, count_max = 1
			}
			)
        end
    end end

local local_create_entity_loot = function()
	local max_health = 0
	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" and unit.max_health then
			if unit.max_health > max_health then max_health = unit.max_health end
		end end

	for i,unit in pairs(data.raw["unit"]) do
		if unit.subgroup == "enemies" and unit.max_health then
			local min = (unit.max_health/max_health)*3
			local max = (unit.max_health/max_health)*50
			local_add_loot_to_entity("unit",unit.name,0.9,math.ceil(min),math.ceil(max))
		end end
	end

local_create_entity_loot()

--adjusting healing properties of fish as superseded by juice
data.raw["capsule"]["raw-fish"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects.damage = {type = "physical", amount = -20}

data.raw["land-mine"]["land-mine"] = 
{
    type = "land-mine",
    name = "land-mine",
    icon = "__base__/graphics/icons/land-mine.png",
    icon_size = 64, icon_mipmaps = 4,
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
    minable = {mining_time = 0.5, result = "land-mine"},
    mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
    max_health = 15,
    corpse = "small-remnants",
    dying_explosion = "land-mine-explosion",
    collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	damaged_trigger_effect = {
		type = "create-entity",
		entity_name = "spark-explosion",
		offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
		offsets = {{0, 1}},
		damage_type_filters = "fire"
	  },
    picture_safe =
    {
      filename = "__base__/graphics/entity/land-mine/land-mine.png",
      priority = "medium",
      width = 32,
      height = 32
    },
    picture_set =
    {
      filename = "__base__/graphics/entity/land-mine/land-mine-set.png",
      priority = "medium",
      width = 32,
      height = 32
    },
    picture_set_enemy =
    {
      filename = "__base__/graphics/entity/land-mine/land-mine-set-enemy.png",
      priority = "medium",
      width = 32,
      height = 32
    },
    trigger_radius = 2.5,
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
            type = "nested-result",
            affects_target = true,
            action =
            {
              type = "area",
              radius = 2.5,
              force = "enemy",
              action_delivery =
              {
                type = "instant",
                target_effects =
                {
                  {
                    type = "damage",
                    damage = { amount = 250, type = "explosion"}
                  },
                  {
                    type = "create-sticker",
                    sticker = "stun-sticker"
                  }
                }
              }
            }
          },
          {
            type = "create-entity",
            entity_name = "explosion"
          },
          {
            type = "damage",
            damage = { amount = 1000, type = "explosion"}
          }
        }
      }
    }
}

--[[]
table.insert(data.raw["capsule"]["land-mine"].action.action_delivery.source_effects,
	{
		action = 
		{
			action_delivery = 
			{
				target_effects = {
					{
						damage = {
						amount = 250,
						type = "explosion"
						},
						type = "damage"
					},
					{
						sticker = "stun-sticker",
						type = "create-sticker"
					}
				},
				type = "instant"
			},
			force = "neutral",
			radius = 6,
			type = "area"
		}
	})
	]]