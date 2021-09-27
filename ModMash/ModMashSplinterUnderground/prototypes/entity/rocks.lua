require("prototypes.scripts.defines") 
local get_name_for = modmashsplinterunderground.util.get_name_for
local level_one_rock_prefix  = modmashsplinterunderground.defines.names.level_one_rock_prefix
local level_two_rock_prefix  = modmashsplinterunderground.defines.names.level_two_rock_prefix
local dirt_prefix  = modmashsplinterunderground.defines.names.dirt_prefix
local rock_names  = modmashsplinterunderground.defines.names.rock_names
local level_one_attack_rock = modmashsplinterunderground.defines.names.level_one_attack_rock
local level_two_attack_rock = modmashsplinterunderground.defines.names.level_two_attack_rock

local local_generate_rocks = function(prefix,tint)
	for k=1, #rock_names do
		local name = prefix..rock_names[k]
		if data.raw["simple-entity"][name] == nil then
			local r = table.deepcopy(data.raw["simple-entity"][rock_names[k]])
			--local desc = data.raw["simple-entity"][rock_names[k]].localised_name -- get_name_for(r.name)
			r.name = name
			r.loot = nil
			r.dying_trigger_effect = nil
			if r.autoplace ~= nil then r.autoplace.default_enabled = false end
			--r.localised_name = desc
			r.max_health = r.max_health/3
			r.minable =
			{
			  mining_particle = "stone-particle",
			  mining_time = 0.75,
			  results = {{name = "stone", amount_min = 1, amount_max = 8, probability = 0.5}},
			}
			for j=1, #r.pictures do
				r.pictures[j].tint = tint
				if r.pictures[j].hr_version then
					r.pictures[j].hr_version.tint = tint
				end
			end
			data:extend({r})
		end
	end
end

local_generate_rocks(level_one_rock_prefix, {0.8,0.8,0.8,1.0})
local_generate_rocks(level_two_rock_prefix, {0.4,0.4,0.4,1.0})


local local_generate_attack_rocks = function(name,tint)
	if data.raw["simple-entity"][name] == nil then
		local r = table.deepcopy(data.raw["simple-entity"][rock_names[1]])
		local desc = get_name_for(r.name)
		r.name = name
        r.type = "radar"
		r.loot = nil
		r.localised_name = "Rock"
		r.max_health = 50
		r.flags = {"placeable-player", "player-creation"}
		--r.selectable_in_game = false
		r.dying_trigger_effect = nil
		if r.autoplace ~= nil then r.autoplace.default_enabled = false end
		r.minable =
		{
			mining_particle = "stone-particle",
			mining_time = 0.75,
			results = {{name = "stone", amount_min = 1, amount_max = 8, probability = 0.5}},
		}
        r.energy_per_sector = "1W"
        r.max_distance_of_sector_revealed = 0
        r.max_distance_of_nearby_sector_revealed = 0
        r.energy_per_nearby_scan = "1W"
        r.energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input"
        }
        r.energy_usage = "1W"
        r.render_no_network_icon = false
		r.render_no_power_icon = false
        r.alert_when_damaged = false
        r.create_ghost_on_death = false
        r.pictures =
        {
            layers =
            {
                {
                    --filename = "__modmashsplinterunderground__/graphics/entity/attack-rock/attack-rock.png",
					filename = "__base__/graphics/decorative/rock-huge/rock-huge-20.png",
					width = 114,
                    height = 125,
                    priority = "low",
                    --width = 98,
                    --height = 128,
                    apply_projection = false,
                    direction_count = 1,
                    line_length = 1,
					shift = {0.140625, 0.03125},
					tint = tint,
                   -- shift = util.by_pixel(1, -16),
                    hr_version =
                    {
                    --filename = "__modmashsplinterunderground__/graphics/entity/attack-rock/hr-attack-rock.png",
					filename = "__base__/graphics/decorative/rock-huge/hr-rock-huge-20.png",
                    priority = "low",
					width = 287,
                    height = 250,
                    --width = 196,
                    --height = 254,
                    apply_projection = false,
                    direction_count = 1,
                    line_length = 1,
                    --shift = util.by_pixel(1, -16),
					shift = {0.132812, 0.03125},
                    scale = 0.5,
					tint = tint
                    }
                }
            }
        },
		data:extend(
		{
			r,
			{		
				type = "item",
				name = r.name,
				icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
				icon_size = 64, icon_mipmaps = 4,	    
				order = "x",
				place_result = r.name,
				stack_size = 50,
				hide_from_player_crafting = true
			}
		})
	end
end

local local_generate_attack_rocks_tmp = function(name,tint)
	if data.raw["radar"][name] == nil then
		local r = table.deepcopy(data.raw["radar"]["radar"])
		local desc = get_name_for(rock_names[1])
		r.name = name
		r.localised_name = "Rock"
		--r.max_health = 50
		--r.flags = {"placeable-player", "player-creation"}
		--r.selectable_in_game = false
		--r.dying_trigger_effect = nil
		--if r.autoplace ~= nil then r.autoplace.default_enabled = false end
		--r.minable =
		--{
		--	mining_time = 0.1,
		--	result = "radar"
			--mining_particle = "stone-particle",
			--mining_time = 0.75,
			--results = {{name = "stone", amount_min = 1, amount_max = 8, probability = 0.5}},
		--}
        --r.energy_per_sector = "1W"
        --r.max_distance_of_sector_revealed = 0
        --r.max_distance_of_nearby_sector_revealed = 0
        --r.energy_per_nearby_scan = "1W"
        --r.energy_source =
        --{
        --    type = "electric",
        --    usage_priority = "secondary-input"
        --}
        --r.energy_usage = "1W"
        --r.render_no_network_icon = false
		--r.render_no_power_icon = false
        --r.alert_when_damaged = false
        --r.create_ghost_on_death = false
        r.pictures =
        {
            layers =
            {
                {
                    --filename = "__modmashsplinterunderground__/graphics/entity/attack-rock/attack-rock.png",
					filename = "__base__/graphics/decorative/rock-huge/rock-huge-20.png",
					width = 114,
                    height = 125,
                    priority = "low",
                    --width = 98,
                    --height = 128,
                    apply_projection = false,
                    direction_count = 1,
                    line_length = 1,
					shift = {0.140625, 0.03125},
					tint = tint,
                   -- shift = util.by_pixel(1, -16),
                    hr_version =
                    {
                    --filename = "__modmashsplinterunderground__/graphics/entity/attack-rock/hr-attack-rock.png",
					filename = "__base__/graphics/decorative/rock-huge/hr-rock-huge-20.png",
                    priority = "low",
					width = 287,
                    height = 250,
                    --width = 196,
                    --height = 254,
                    apply_projection = false,
                    direction_count = 1,
                    line_length = 1,
                    --shift = util.by_pixel(1, -16),
					shift = {0.132812, 0.03125},
                    scale = 0.5,
					tint = tint
                    }
                }
            }
        },
		data:extend(
		{
			r,
			{		
				type = "item",
				name = r.name,
				icon = "__modmashsplinter__/graphics/icons/bad-icon.png",
				icon_size = 64, icon_mipmaps = 4,	    
				order = "x",
				place_result = r.name,
				stack_size = 50,
				hide_from_player_crafting = true
			}
		})
	end
end
local_generate_attack_rocks(level_one_attack_rock, {0.8,0.8,0.8,1.0})
local_generate_attack_rocks(level_two_attack_rock, {0.4,0.4,0.4,1.0})