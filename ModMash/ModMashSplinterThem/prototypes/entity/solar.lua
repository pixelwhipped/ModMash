require ("prototypes.scripts.defines")

local hide_from_player_crafting = true
local minable = nil
local healing_per_tick = modmashsplinterthem.healing_per_tick
local placeable = "placeable-enemy"

if modmashsplinterthem.debug == true then
	placeable = "placeable-player"
    hide_from_player_crafting = false
    minable = {mining_time = 0.1, result = "them-solar-panel"}
end
data:extend(
{
    {
		type = "item",
		name = "them-solar-panel",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
		subgroup = "them",		    
		order = "them-solar-panel",
		place_result = "them-solar-panel",
		stack_size = 50,
        hide_from_player_crafting = hide_from_player_crafting
    },
    {
        type = "solar-panel",
        name = "them-solar-panel",
        icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
        icon_size = 64, icon_mipmaps = 4,
        map_color = {r=1.0, g=0.0, b=0.5},
        flags = {placeable,"placeable-enemy", "player-creation"},
        minable = minable,     
        max_health = 75,
        healing_per_tick = healing_per_tick,
        corpse = "solar-panel-remnants",
        dying_explosion = "solar-panel-explosion",
        collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        damaged_trigger_effect = {
            type = "create-entity",
            entity_name = "spark-explosion",
            offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
            damage_type_filters = "fire"
        },
        energy_source =
        {
            type = "electric",
            usage_priority = "solar"
        },
        picture =
        {
            layers =
            {
            {
                filename = "__modmashsplinterthem__/graphics/entity/solar/solar-panel.png",
                priority = "high",
                width = 116,
                height = 112,
                shift = util.by_pixel(-3, 3),
                hr_version =
                {
                filename = "__modmashsplinterthem__/graphics/entity/solar/hr-solar-panel.png",
                priority = "high",
                width = 230,
                height = 224,
                shift = util.by_pixel(-3, 3.5),
                scale = 0.5
                }
            },
            {
                filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow.png",
                priority = "high",
                width = 112,
                height = 90,
                shift = util.by_pixel(10, 6),
                draw_as_shadow = true,
                hr_version =
                {
                filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow.png",
                priority = "high",
                width = 220,
                height = 180,
                shift = util.by_pixel(9.5, 6),
                draw_as_shadow = true,
                scale = 0.5
                }
            }
            }
        },
        overlay =
        {
            layers =
            {
            {
                filename = "__base__/graphics/entity/solar-panel/solar-panel-shadow-overlay.png",
                priority = "high",
                width = 108,
                height = 90,
                shift = util.by_pixel(11, 6),
                hr_version =
                {
                filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow-overlay.png",
                priority = "high",
                width = 214,
                height = 180,
                shift = util.by_pixel(10.5, 6),
                scale = 0.5
                }
            }
            }
        },
        vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        production = "50MJ"
    }
})
if modmashsplinterthem.debug == true then
    data:extend(
    {
        {
            type = "recipe",
            name = "them-solar-panel",
            ingredients = {{name = "stone", amount = 1}},
            result = "them-solar-panel",
            enabled = true
	    }
	})
end