local ends_with = modmashsplinterresources.util.ends_with
local starts_with = modmashsplinterresources.util.starts_with
local get_item = modmashsplinterresources.util.get_item
local get_name_for = modmashsplinterresources.util.get_name_for
local ensure_ingredient_format = modmashsplinterresources.util.ensure_ingredient_format
local get_standard_results = modmashsplinterresources.util.get_standard_results
local get_normal_results = modmashsplinterresources.util.get_normal_results
local create_layered_icon_using =	modmashsplinterresources.util.create_layered_icon_using

local icon_pin_topleft = modmashsplinterresources.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterresources.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterresources.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterresources.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterresources.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterresources.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterresources.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterresources.util.defines.icon_pin_left


local local_create_conversions = function()
	for name, resource in pairs(data.raw["resource"]) do
		if starts_with(name,"creative") == false then
			if resource ~= nil and resource.name ~= nil and resource.minable ~= nil and resource.minable.result ~= nil then
				log(resource.minable.result)
				local item = data.raw["item"][resource.minable.result]
				if item == nil then log("Nil item "..resource.minable.result) end
				if item.stack_size == nil then log("Nil stack "..resource.minable.result) end
				if item and item ~= nil and item.stack_size ~= nil then
					data:extend(
					{
						{
							type = "recipe",
							name = "alien-enrichment-process-to-"..item.name,
							energy_required = 1.5,
							enabled = false,
							category = "crafting-with-fluid",
							ingredients = {{type="fluid", name = "alien-ooze",amount = 25}},
							icon = false,
							icons = create_layered_icon_using({
								{
									icon = "__modmashsplinterresources__/graphics/icons/alien-ooze.png",
									icon_mipmaps = 4,
									icon_size = 64,
								},
								{
									from = item,
									scale = 0.5,
									pin = icon_pin_bottomright
								}
							}),
							icon_size = 64,
							icon_mipmaps = 4,
							subgroup = "conversion",
							order = "d["..item.name.."]",
							localised_name = get_name_for(item,"Alien ooze to "),
							localised_description = get_name_for(item,"Alien ooze to "),
							main_product = "",
							results =
							{			
								{
								name = item.name,
								amount = math.min(item.stack_size,15),
								}			
							},
							allow_decomposition = false,
						},
						{
							type = "technology",
							name = "alien-conversion-2-"..item.name,
							localised_name = get_name_for(item,"Alien ooze to "),
							localised_description = get_name_for(item,"Alien ooze to "),
							icon = "__modmashsplinterresources__/graphics/technology/conversion.png",
							icon_size = 128,
							effects =
							{
							  {
								type = "unlock-recipe",
								recipe = "alien-enrichment-process-to-"..item.name
							  }
							},
							prerequisites =
							{
							  "alien-conversion1"
							},
							unit =
							{
							  count = 75,
							  ingredients =
							  {
								{"automation-science-pack", 1},
								{"logistic-science-pack", 1},
								{"chemical-science-pack", 1},
							  },
							  time = 35
							},
							upgrade = true,
							order = "a-b-d",
						}
					})
				end
			end
		end
	end
end

local local_create_ore_conversions = function()
	local ores = {}
	for name, resource in pairs(data.raw["resource"]) do
		if starts_with(name,"creative") == false then
			if resource ~= nil and resource.name ~= nil and resource.minable ~= nil and resource.minable.result ~= nil then
				log(resource.minable.result)
				local item = data.raw["item"][resource.minable.result]
				if item == nil then log("Nil item "..resource.minable.result) end
				if item and item.stack_size == nil then log("Nil stack "..resource.minable.result) end
				if item ~= nil and item.stack_size ~= nil then
					table.insert(ores,item)
				end
			end
		end
	end
	for k=1, #ores do local item = ores[k]
		data:extend(
		{
			{
				type = "recipe",
				name = "alien-enrichment-process-to-"..item.name,
				energy_required = 1.5,
				enabled = false,
				category = "crafting-with-fluid",
				ingredients = {{type="fluid", name = "alien-ooze",amount = 25}},
				icon = false,
				icons = create_layered_icon_using({
					{
						icon = "__modmashsplinterresources__/graphics/icons/alien-ooze.png",
						icon_mipmaps = 4,
						icon_size = 64,
					},
					{
						from = item,
						scale = 0.5,
						pin = icon_pin_bottomright
					}
				}),
				icon_size = 64,
				icon_mipmaps = 4,
				subgroup = "conversion",
				order = "d["..item.name.."]",
				localised_name = get_name_for(item,"Alien ooze to "),
				localised_description = get_name_for(item,"Alien ooze to "),
				main_product = "",
				results =
				{			
					{
					name = item.name,
					amount = math.min(item.stack_size,15),
					}			
				},
				allow_decomposition = false,
			},
			{
				type = "technology",
				name = "alien-conversion-2-"..item.name,
				localised_name = get_name_for(item,"Alien ooze to "),
				localised_description = get_name_for(item,"Alien ooze to "),
				icon = "__modmashsplinterresources__/graphics/technology/conversion.png",
				icon_size = 128,
				effects =
				{
					{
					type = "unlock-recipe",
					recipe = "alien-enrichment-process-to-"..item.name
					}
				},
				prerequisites =
				{
					"alien-conversion1"
				},
				unit =
				{
					count = 75,
					ingredients =
					{
					{"automation-science-pack", 1},
					{"logistic-science-pack", 1},
					{"chemical-science-pack", 1},
					},
					time = 35
				},
				upgrade = true,
				order = "a-b-d",
			}
		})
	end
end

if data ~= nil and data_final_fixes == true then
	local_create_conversions()
	local_create_ore_conversions()
end