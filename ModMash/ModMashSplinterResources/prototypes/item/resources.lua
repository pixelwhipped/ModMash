require("prototypes.scripts.defines") 
local titanium_ore_name = modmashsplinterresources.util.get_item_ingredient_substitutions({"titanium-ore"},{{name = "titanium-ore", amount = 1}})[1].name
if titanium_ore_name == nil then titanium_ore_name = "titanium-ore" end
local local_get_alien_particle_shadow_pictures = function()
	return
	{
	{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-shadow-1.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-1.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	},
	{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-shadow-2.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-2.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	},
	{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-shadow-3.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-3.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	},
	{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-shadow-4.png",
		priority = "extra-high",
		width = 16,
		height = 16,
		frame_count = 1,
		hr_version =
		{
		filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-shadow-4.png",
		priority = "extra-high",
		width = 32,
		height = 32,
		frame_count = 1,
		scale = 0.5
		}
	}
	}
	end
local local_get_alien_particle_pictures = function()
	return
	{
		{
		  filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-1.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-1.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		},
		{
		  filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-2.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-2.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		},
		{
		  filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-3.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-3.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		},
		{
		  filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-particle-4.png",
		  priority = "extra-high",
		  width = 16,
		  height = 16,
		  frame_count = 1,
		  hr_version =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-particle-4.png",
			priority = "extra-high",
			width = 32,
			height = 32,
			frame_count = 1,
			scale = 0.5
		  }
		}
    }
	end

local local_make_particle = function()
	return
	{
		{
			type = "optimized-particle",
			name = "alien-ore-particle",
			life_time = 180,
			render_layer = "projectile",
			 render_layer_when_on_ground =  "corpse",
			regular_trigger_effect_frequency = 2,
			pictures = local_get_alien_particle_pictures(),
			shadows = local_get_alien_particle_shadow_pictures()
		}
	}
	end

data:extend(local_make_particle())

data:extend(
{
  {
    type = "item",
    name = titanium_ore_name,
    icon = "__modmashsplinterresources__/graphics/icons/titanium-ore.png",
    icon_mipmaps = 4,
    icon_size = 64,
    pictures = {
        {
          filename = "__modmashsplinterresources__/graphics/icons/titanium-ore.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/titanium-ore-1.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/titanium-ore-2.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/titanium-ore-3.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        }
    },
    subgroup = "raw-resource",
    order = "g[titanium-ore]",
    stack_size = 75
  },
  {
    type = "item",
    name = "sand",
    icon = "__modmashsplinterresources__/graphics/icons/sand.png",
    icon_mipmaps = 4,
    icon_size = 64,
    pictures = {
        {
          filename = "__modmashsplinterresources__/graphics/icons/sand.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/sand-1.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/sand-2.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/sand-3.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        }
    },
    subgroup = "raw-resource",
    order = "a[wood]-b-b",
    stack_size = 200
  },
  {
    type = "item",
    name = "alien-ore",
    icon = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
    icon_mipmaps = 4,
    icon_size = 64,    
    pictures = {
        {
          filename = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/alien-ore-1.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/alien-ore-2.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        },
        {
          filename = "__modmashsplinterresources__/graphics/icons/alien-ore-3.png",
          mipmap_count = 4,
          scale = 0.25,
          size = 64
        }
    },
    subgroup = "raw-resource",
    order = "h[alien-ore]",
    stack_size = 100
  },
  {
    type = "item",
    name = "titanium-plate",
    icon = "__modmashsplinterresources__/graphics/icons/titanium-plate.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "raw-material",
    order = "d[titanium-plate]",
    stack_size = 100
  },
  {
    type = "item",
    name = "alien-plate",
    icon = "__modmashsplinterresources__/graphics/icons/alien-plate.png",
    icon_mipmaps = 4,
    icon_size = 64,
    subgroup = "raw-material",
    order = "d[alien-plate]",
    stack_size = 100
  },
  {
    type = "item",
    name = "alien-artifact",
    icon = "__modmashsplinterresources__/graphics/icons/alien-artifact.png",
    icon_mipmaps = 4,
    icon_size = 64,   
    subgroup = "raw-resource",
    order = "z",
    stack_size = 10
  },
  {
		type = "resource",
		name = "alien-ore",
		icon = "__modmashsplinterresources__/graphics/icons/alien-ore.png",
		icon_mipmaps = 4,
		icon_size = 64,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "alien-ore-particle",
		  mining_time = 1,
		  result = "alien-ore"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=1.0, g=0.0, b=0.5},
		effect_animation_period = 5,
		effect_animation_period_deviation = 1,
		effect_darkness_multiplier = 3.6000000000000001,

		max_effect_alpha = 0.3,
		min_effect_alpha = 0.2,
		mining_visualisation_tint = {
			a = 1,
			b = 0.5,
			g = 0.0,
			r = 1.0
		},
		stages_effect = {
			sheet = {
			  blend_mode = "additive",
			  filename = "__modmashsplinterresources__/graphics/entity/alien-ore/alien-ore-glow.png",
			  flags = {
				"light"
			  },
			  frame_count = 8,
			  height = 64,
			  hr_version = {
				blend_mode = "additive",
				filename = "__modmashsplinterresources__/graphics/entity/alien-ore/hr-alien-ore-glow.png",
				flags = {
				  "light"
				},
				frame_count = 8,
				height = 128,
				priority = "extra-high",
				scale = 0.5,
				variation_count = 8,
				width = 128
			  },
			  priority = "extra-high",
			  variation_count = 8,
			  width = 64
			}
		},
	}
})
if not data.raw.item["glass"] then
  data:extend({
    {
      icon = "__modmashsplinterresources__/graphics/icons/glass.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "glass",
      order = "a[wood]-b-c",
      stack_size = 100,
      subgroup = "raw-material",
      type = "item"
    },
	{
      category = "smelting",
      energy_required = 4,
      ingredients = {
        { "sand", 1 }
      },
      name = "glass-from-sand",
      results =
	  {
		{
			name = "glass",      
			amount = 2
		}
	  },
      type = "recipe",
    },
	{
      icon = "__modmashsplinterresources__/graphics/icons/glass.png",
      icon_mipmaps = 4,
      icon_size = 64,
      name = "glass",
      order = "a[wood]-b-c",
      stack_size = 100,
      subgroup = "raw-material",
      type = "item"
    },
	{
		type = "resource",
		name = "sand",
		icon = "__modmashsplinterresources__/graphics/icons/sand.png",
		icon_mipmaps = 4,
		icon_size = 64,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "stone-particle",
		  mining_time = 0.75,
		  result = "sand"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/sand/sand.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashsplinterresources__/graphics/entity/sand/hr-sand.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=0.9, g=0.9, b=0.9},
		mining_visualisation_tint = {
			a = 1,
			b = 0.9,
			g = 0.9,
			r = 0.9
		}
	}
  })
end

if not data.raw["resource"]["sulfur"] then
data:extend(
{
	{
		type = "resource",
		name = "sulfur",
		icon = "__base__/graphics/icons/sulfur.png",
		icon_size = 64, icon_mipmaps = 4,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "stone-particle",
		  mining_time = 1.75,
		  result = "sulfur"
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/sulfur/sulfur-ore.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashsplinterresources__/graphics/entity/sulfur/hr-sulfur-ore.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {r=0.95, g=0.75, b=0.0},		
		mining_visualisation_tint = {
			a = 1,
			b = 0.0,
			g = 0.75,
			r = 0.95
		}
	}
	})
end

if not data.raw["resource"][titanium_ore_name] then
data:extend(
{
	{
		type = "resource",
		name = titanium_ore_name,
		icon = "__modmashsplinterresources__/graphics/icons/titanium-ore.png",
		icon_mipmaps = 4,
		icon_size = 64,
		flags = {"placeable-neutral"},
		order="a-b-z",
		tree_removal_probability = 0.8,
		tree_removal_max_distance = 32 * 32,
		minable =
		{
		  mining_particle = "iron-ore-particle",
		  mining_time = 1.5,
		  result = titanium_ore_name
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = 
		{
			create = false,
			starting_area = false,
			richness = 0.0,
			size = 0.0
		},
		stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
		stages =
		{
		  sheet =
		  {
			filename = "__modmashsplinterresources__/graphics/entity/titanium-ore/titanium-ore.png",
			priority = "extra-high",
			size = 64,
			frame_count = 8,
			variation_count = 8,
			hr_version =
			{
			  filename = "__modmashsplinterresources__/graphics/entity/titanium-ore/hr-titanium-ore.png",
			  priority = "extra-high",
			  size = 128,
			  frame_count = 8,
			  variation_count = 8,
			  scale = 0.5
			}
		  }
		},
		map_color = {0.315, 0.425, 0.480},
		mining_visualisation_tint = {
			a = 1,
			b = 0.480,
			g = 0.425,
			r = 0.315
		}
	}
})
end