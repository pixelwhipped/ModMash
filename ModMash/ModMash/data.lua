--[[Code check 29.2.20
removed old comments
--]]
--require("prototypes.scripts.util")
modmash = { util = get_liborio() }
require("prototypes.categories.discharge-fluids")
require("prototypes.categories.item-groups")
require("prototypes.categories.recycling-category")
require("prototypes.categories.wind-trap")

require("prototypes.item.underground")
require("prototypes.item.blank-circuit")
require("prototypes.item.fluid")
require("prototypes.item.resources")
require("prototypes.item.spawner")
require("prototypes.item.assembling-machine-4")
require("prototypes.item.assembling-machine-5")
require("prototypes.item.wind-trap")
require("prototypes.item.discharge-pump")
require("prototypes.item.recycling-machine")
require("prototypes.item.ammo")
require("prototypes.item.regenerative-wall")
require("prototypes.item.titanium-wall")
require("prototypes.item.pipes")
require("prototypes.item.juice")
require("prototypes.item.droid")
require("prototypes.item.steam-engine-mk2")
require("prototypes.item.super-material")
require("prototypes.item.valkyrie")

require("prototypes.recipe.underground")
require("prototypes.recipe.enrichment")
require("prototypes.recipe.assembling-machine-4")
require("prototypes.recipe.assembling-machine-5")
require("prototypes.recipe.wind-trap")
require("prototypes.recipe.discharge-pump")
require("prototypes.recipe.recycling-machine")
require("prototypes.recipe.ammo")
require("prototypes.recipe.regenerative-wall")
require("prototypes.recipe.titanium-wall")
require("prototypes.recipe.pipes")
require("prototypes.recipe.fluids")
require("prototypes.recipe.juice")
require("prototypes.recipe.droid")
require("prototypes.recipe.steam-engine-mk2")
require("prototypes.recipe.valkyrie")

require("prototypes.technology.regenerative")
require("prototypes.technology.logistics")
require("prototypes.technology.underground")

require("prototypes.entity.underground")
require("prototypes.entity.logistics")
require("prototypes.entity.valves")
require("prototypes.entity.assembling-machine-4")
require("prototypes.entity.assembling-machine-5")
require("prototypes.entity.wind-trap")
require("prototypes.entity.discharge-pump")
require("prototypes.entity.recycling-machine")
require("prototypes.entity.regenerative-wall")
require("prototypes.entity.titanium-wall")
require("prototypes.entity.pipes")
require("prototypes.entity.droid")
require("prototypes.entity.biter-neuro-toxin")
require("prototypes.entity.steam-engine-mk2")
require("prototypes.entity.valkyrie")
require("prototypes.entity.ore-refinery")
require("prototypes.entity.assembling-machine-burner")
require("prototypes.entity.dredge-pump")

require("prototypes.technology.enrichment")
require("prototypes.technology.inserters")
require("prototypes.technology.valves")
require("prototypes.technology.assembling-machine-4")
require("prototypes.technology.assembling-machine-5")
require("prototypes.technology.wind-trap")
require("prototypes.technology.discharge-pump")
require("prototypes.technology.recycling-machine")
require("prototypes.technology.ammo")
require("prototypes.technology.regenerative-wall")
require("prototypes.technology.titanium-wall")
require("prototypes.technology.pipes")
require("prototypes.technology.droid")
require("prototypes.technology.valkyrie")

data:extend({
  {
    type = "custom-input",
    name = "automate-target",
    key_sequence = "CONTROL + A",
    consuming = "script-only"
  },
})

data:extend({
  {
    type = "custom-input",
    name = "automate-target",
    key_sequence = "CONTROL + A",
    consuming = "script-only"
  },
})

data:extend({
  {
    type = "custom-input",
    name = "profiler-dump",
    key_sequence = "CONTROL + L",
    consuming = "script-only"
  },
})
require("wiki") 
wiki_register_mod_wiki(modmash_wiki)

data:extend(
{
	{
		type     = "sprite",
		name     = "landmine-button-gui",
		filename = "__modmash__/boom.png",
		width    = 128,
		height   = 128
	}
})

local styles = data.raw["gui-style"]["default"]

styles["landmine-icon-button"] =
{
	type = "button_style",
	horizontal_align = "center",
	vertical_align = "center",
	icon_horizontal_align = "center",
	minimal_width = 36,
	height = 36,
	padding = 0,
	stretch_image_to_widget_size = true,
	default_graphical_set = base_icon_button_grahphical_set,
	hovered_graphical_set =
    {
		base = {position = {34, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
        shadow = default_dirt,
        glow = default_glow(default_glow_color, 0.5)
	},
	clicked_graphical_set =
	{
		base   = {position = {51, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
        shadow = default_dirt
	},
	selected_graphical_set =
	{
		base   = {position = {225, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
		shadow = default_dirt
	},
	selected_hovered_graphical_set =
	{
		base   = {position = {369, 17}, corner_size = 2, draw_type = "outer", opacity = 0.5},
		shadow = default_dirt
	},
	strikethrough_color = {0.5, 0.5, 0.5},
	pie_progress_color = {1, 1, 1},
	left_click_sound =
	{
		{ filename = "__core__/sound/gui-click.ogg" }
	},
	draw_shadow_under_picture = true
}
--[[
data:extend(
  {
	{
		type = "land-mine",
		name = "nuclear-land-mine",
		icon = false,
		icons =
			{
				{
					icon = "__base__/graphics/icons/land-mine.png",
					tint = {r=0,g=0.45,b=0},
					icon_size = 64, icon_mipmaps = 4,
				}
			},
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
		minable = {mining_time = 0.5, result = "nuclear-land-mine"},
		mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
		max_health = 15,
		corpse = "small-remnants",
		dying_explosion = "land-mine-explosion",
		collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		damaged_trigger_effect = 
		{
			type = "create-entity",
			entity_name = "spark-explosion",
			offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
			offsets = {{0, 1}},
			damage_type_filters = "fire"
		},
		picture_safe =
		{
		  tint = {r=0,g=0.45,b=0},
		  filename = "__base__/graphics/entity/land-mine/land-mine.png",
		  priority = "medium",
		  width = 32,
		  height = 32
		},
		picture_set =
		{
		  tint = {r=0,g=0.45,b=0},
		  filename = "__base__/graphics/entity/land-mine/land-mine-set.png",
		  priority = "medium",
		  width = 32,
		  height = 32
		},
		picture_set_enemy =
		{
		  tint = {r=0,g=0.45,b=0},
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
            entity_name = "small-scorchmark",
            check_buildability = true
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
                  },
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
          }
        }
      }
	}
	},
	{
      icon = false,
	  icons = 
	  {
			{
				icon = "__base__/graphics/icons/land-mine.png",
				tint = {r=0,g=0.45,b=0},
				icon_size = 64, icon_mipmaps = 4,
			}
	  },
      name = "nuclear-land-mine",
      order = "f[nuclear-land-mine]",
      place_result = "nuclear-land-mine",
      stack_size = 100,
      subgroup = "gun",
      type = "item"
    },
	{
      enabled = false,
      energy_required = 5,
      ingredients = 
	  {
        {
          "land-mine",
          1
        },
        {
          "uranium-235",
          2
        }
      },
      name = "nuclear-land-mine",
      result = "nuclear-land-mine",
      result_count = 1,
      type = "recipe"
    },
	{
      effects = 
	  {
        {
          recipe = "nuclear-land-mine",
          type = "unlock-recipe"
        }
      },
      icon = "__base__/graphics/technology/land-mine.png",
      icon_size = 128,
      name = "nuclear-land-mine",
      order = "e-e",
      prerequisites = { "land-mine" },
      type = "technology",
      unit = {
        count = 100,
        ingredients = 
		{
          {
            "automation-science-pack",
            1
          },
          {
            "logistic-science-pack",
            1
          },
          {
            "military-science-pack",
            1
          }
        },
        time = 30
      }
    }
  })
]]