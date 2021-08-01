require ("prototypes.scripts.defines")

function hr_crash_site_lab_ground()
  return
  {
    filename = "__modmashsplinterloot__/graphics/entity/crash-site-lab/crash-site-lab-ground.png",
    priority = "very-low",
    width = 352,
    height = 170,
    shift = util.by_pixel(-48, 12),
    frame_count = 1,
    line_length = 1,
    hr_version =
    {
      filename = "__modmashsplinterloot__/graphics/entity/crash-site-lab/hr-crash-site-lab-ground.png",
      priority = "very-low",
      width = 700,
      height = 344,
      shift = util.by_pixel(-49, 11),
      frame_count = 1,
      line_length = 1,
      scale = 0.5
    }
  }
end

local lab =   {
    type = "simple-entity",
    name = "crash-site-lab-broken",
    icon = "__modmashsplinterloot__/graphics/icons/crash-site-lab-broken.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"not-deconstructable","not-blueprintable", "placeable-player", "player-creation", "hidden"},
    minable = {
        mining_time = 2.2999999999999998
    },
    map_color = {r = 0, g = 0.365, b = 0.58, a = 1},
    max_health = 150,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-2.2, -1.2}, {2.2, 1.2}},
    selection_box = {{-2.5, -1.5}, {2.5, 1.5}},
    --light = {intensity = 0.75, size = 8, color = {r = 1.0, g = 1.0, b = 1.0}},
    integration_patch_render_layer = "decals",
    integration_patch = hr_crash_site_lab_ground(),

    animations =
    {
      layers =
      {
        {
          filename = "__modmashsplinterloot__/graphics/entity/crash-site-lab/crash-site-lab-broken.png",
          priority = "very-low",
          width = 236,
          height = 140,
          frame_count = 1,
          line_length = 1,
          animation_speed = 1 / 3,
          shift = util.by_pixel(-24, 6),
          hr_version =
          {
            filename = "__modmashsplinterloot__/graphics/entity/crash-site-lab/hr-crash-site-lab-broken.png",
            priority = "very-low",
            width = 472,
            height = 280,
            frame_count = 1,
            line_length = 1,
            animation_speed = 1 / 3,
            shift = util.by_pixel(-24, 6),
            scale = 0.5
          }
        },
        {
          filename = "__modmashsplinterloot__/graphics/entity/crash-site-lab/crash-site-lab-broken-shadow.png",
          priority = "very-low",
          width = 270,
          height = 150,
          frame_count = 1,
          line_length = 1,
          repeat_count = 1,
          animation_speed = 1 / 3,
          shift = util.by_pixel(-16, 10),
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__modmashsplinterloot__/graphics/entity/crash-site-lab/hr-crash-site-lab-broken-shadow.png",
            priority = "very-low",
            width = 550,
            height = 304,
            frame_count = 1,
            line_length = 1,
            repeat_count = 1,
            animation_speed = 1 / 3,
            shift = util.by_pixel(-14, 9),
            scale = 0.5,
            draw_as_shadow = true
          }
        }
      }
    },
    vehicle_impact_sound = {
          {
            filename = "__base__/sound/car-metal-impact-2.ogg", volume = 0.5
          },
          {
            filename = "__base__/sound/car-metal-impact-3.ogg", volume = 0.5
          },
          {
            filename = "__base__/sound/car-metal-impact-4.ogg", volume = 0.5
          },
          {
            filename = "__base__/sound/car-metal-impact-5.ogg", volume = 0.5
          },
          {
            filename = "__base__/sound/car-metal-impact-6.ogg", volume = 0.5
          }
        }
  }

local loot_science_a = table.deepcopy(lab)
	loot_science_a.name = modmashsplinterloot.defines.names.loot_science_a
	loot_science_a.order = "zzzzz"
	loot_science_a.localised_name ="Crashed science lab"
	loot_science_a.max_health = 50
	loot_science_a.map_color = {r=1.0,g=0.45,b=0,a=1}

	local loot_science_b = table.deepcopy(lab)
	loot_science_b.name = modmashsplinterloot.defines.names.loot_science_b
	loot_science_b.order = "zzzzz"
	loot_science_b.localised_name ="Crashed science lab"
	loot_science_b.max_health = 50
	loot_science_b.map_color = {r=1.0,g=0.45,b=0,a=1}

	data.raw["container"]["crash-site-chest-1"].max_health = 50
	data.raw["container"]["crash-site-chest-2"].max_health = 50
	data.raw["container"]["crash-site-chest-1"].map_color = {r=1.0,g=0.45,b=0,a=1}
	data.raw["container"]["crash-site-chest-2"].map_color = {r=1.0,g=0.45,b=0,a=1}
    data.raw["container"]["crash-site-chest-1"].minable = {mining_time = 2.2999999999999998}
	data.raw["container"]["crash-site-chest-2"].minable = {mining_time = 2.2999999999999998}
    
	data:extend({loot_science_a,loot_science_b})