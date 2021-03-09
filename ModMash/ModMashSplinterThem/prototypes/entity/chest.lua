require ("prototypes.scripts.defines")

local resistances = modmashsplinterthem.resistances
local hide_from_player_crafting = true
local minable = null
local placeable = "placeable-enemy"

if modmashsplinterthem.debug == true then
	placeable = "placeable-player"
    hide_from_player_crafting = false
    minable = {mining_time = 0.1, result = "them-chest"}
end
data:extend(
{
    {
		type = "item",
		name = "them-chest",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-chest",
		place_result = "them-chest",
		stack_size = 50,
        hide_from_player_crafting = hide_from_player_crafting
    },
    {
        type = "logistic-container",
		name = "them-chest",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
        map_color = {r=1.0, g=0.0, b=0.5},
        flags = {placeable,"placeable-enemy", "player-creation","hide-alt-info"},
        minable = {mining_time = 0.2, result = "them-chest"},
        max_health = 200,
        logistic_mode = "storage",
        max_logistic_slots = 1,
        healing_per_tick = healing_per_tick,
        render_not_in_network_icon = false,
        corpse = "iron-chest-remnants",
        dying_explosion = "iron-chest-explosion",
        open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.43 },
        close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 },
        resistances = resistances,
        collision_box = {{-0.35, -1.35}, {0.35, 1.35}},
        selection_box = {{-0.5, -1.5}, {0.5, 1.5}},
        damaged_trigger_effect = {
            type = "create-entity",
            entity_name = "spark-explosion",
            offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
            damage_type_filters = "fire"
        },
        --fast_replaceable_group = "container",
        inventory_size = 256, --because i said so
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        picture =
        {
          layers =
          {
            {
              filename = "__modmashsplinterthem__/graphics/entity/chest/chest.png",
              priority = "extra-high",
              width = 34,
              height = 76,
              shift = util.by_pixel(0, -0.5),
              hr_version =
              {
                filename = "__modmashsplinterthem__/graphics/entity/chest/hr-chest.png",
                priority = "extra-high",
                width = 66,
                height = 152,
                shift = util.by_pixel(-0.5, -0.5),
                scale = 0.5
              }
            }
          }
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance
    },
    {
		type = "item",
		name = "them-chest-energy-converter",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-chest-energy-converter",
		place_result = "them-chest-energy-converter",
		stack_size = 50,
        hide_from_player_crafting = hide_from_player_crafting
    },
    {
        type = "logistic-container",
		name = "them-chest-energy-converter",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
        map_color = {r=1.0, g=0.0, b=0.5},
        flags = {placeable,"placeable-enemy", "player-creation","hide-alt-info"},
        minable = {mining_time = 0.2, result = "them-chest"},
        max_health = 200,
        healing_per_tick = healing_per_tick,
        render_not_in_network_icon = false,
        logistic_mode = "passive-provider",
        corpse = "iron-chest-remnants",
        dying_explosion = "iron-chest-explosion",
        open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.43 },
        close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.43 },
        resistances = resistances,
        collision_box = {{-0.35, -1.35}, {0.35, 1.35}},
        selection_box = {{-0.5, -1.5}, {0.5, 1.5}},
        damaged_trigger_effect = {
            type = "create-entity",
            entity_name = "spark-explosion",
            offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
            damage_type_filters = "fire"
        },
        --fast_replaceable_group = "container",
        inventory_size = 32,
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        picture =
        {
          layers =
          {
            {
              filename = "__modmashsplinterthem__/graphics/entity/chest/chest.png",
              priority = "extra-high",
              width = 34,
              height = 76,
              shift = util.by_pixel(0, -0.5),
              hr_version =
              {
                filename = "__modmashsplinterthem__/graphics/entity/chest/hr-chest.png",
                priority = "extra-high",
                width = 66,
                height = 152,
                shift = util.by_pixel(-0.5, -0.5),
                scale = 0.5
              }
            }
          }
        },
        circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
        circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
        circuit_wire_max_distance = default_circuit_wire_max_distance
    }
})
if modmashsplinterthem.debug == true then
    data:extend(
    {
        {
            type = "recipe",
            name = "them-chest",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-chest",
            enabled = true
	    },{
            type = "recipe",
            name = "them-chest-energy-converter",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-chest-energy-converter",
            enabled = true
	    }
	})
end