local ends_with = modmashsplinterenrichment.util.ends_with
local starts_with = modmashsplinterenrichment.util.starts_with
local get_item = modmashsplinterenrichment.util.get_item
local get_name_for = modmashsplinterenrichment.util.get_name_for
local ensure_ingredient_format = modmashsplinterenrichment.util.ensure_ingredient_format
local get_standard_results = modmashsplinterenrichment.util.get_standard_results
local get_normal_results = modmashsplinterenrichment.util.get_normal_results
local create_layered_icon_using =	modmashsplinterenrichment.util.create_layered_icon_using

local icon_pin_topleft = modmashsplinterenrichment.util.defines.icon_pin_topleft
local icon_pin_top = modmashsplinterenrichment.util.defines.icon_pin_top
local icon_pin_topright = modmashsplinterenrichment.util.defines.icon_pin_topright
local icon_pin_right = modmashsplinterenrichment.util.defines.icon_pin_right
local icon_pin_bottomright = modmashsplinterenrichment.util.defines.icon_pin_bottomright
local icon_pin_bottom = modmashsplinterenrichment.util.defines.icon_pin_bottom
local icon_pin_bottomleft = modmashsplinterenrichment.util.defines.icon_pin_bottomleft
local icon_pin_left = modmashsplinterenrichment.util.defines.icon_pin_left
local local_get_results = function(ore,ores)
	local results = {}
	for k=1, #ores do local item = ores[k]
		if ore.name ~= item.name then
			table.insert(results,{name = item.name, amount = 2, probability = 0.5})
		end
	end
	return results
end
local local_create_ore_conversions = function()
	local ores = {}
	local steam = data.raw["fluid"]["steam"]
	for name, resource in pairs(data.raw["resource"]) do
		if starts_with(name,"creative") == false then
			if resource ~= nil and resource.name ~= nil and resource.minable ~= nil and resource.minable.result ~= nil then
				log(resource.minable.result)
				local item = data.raw["item"][resource.minable.result]
				if item == nil then log("Nil item "..resource.minable.result) end
				if item.stack_size == nil then log("Nil stack "..resource.minable.result) end
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
				name = "ore-enrichment-process-"..item.name,
				energy_required = 1.5,
				enabled = false,
				category = "crafting-with-fluid",
				icon = false,
				icons = create_layered_icon_using({
					{
						from = steam
					},
					{
						from = item,
						scale = 0.5,
						pin = icon_pin_bottomright
					}
				}),
				icon_size = 64,
				icon_mipmaps = 4,
				subgroup = "raw-material",
				order = "k[uranium-processing][titanium-extraction-process][ore-enrichment-process-"..item.name.."]",
				localised_name = get_name_for(item,""," Conversion"),
				localised_description = get_name_for(item,""," Conversion"),
				main_product = "",
				normal =
				{
					enabled = false,
					energy_required = 4,
					ingredients =
					{
						{type="fluid", name = "steam",amount = 100},
						{item.name, ((#ores-1)*3)}
					},
					results = local_get_results(item,ores)
				},
				expensive =
				{
					enabled = false,
					energy_required = 6,
					ingredients =
					{
						{type="fluid", name = "steam",amount = 100},
						{item.name, ((#ores-1)*4)}
					},
					results = local_get_results(item,ores)
				},
				allow_decomposition = false,
			},
			{
				type = "technology",
				name = "ore-enrichment-process-"..item.name,
				localised_name = get_name_for(item,""," Conversion"),
				localised_description = get_name_for(item,""," Conversion"),
				icon = "__modmashsplinterenrichment__/graphics/technology/conversion.png",
				icon_size = 128,
				effects =
				{
					{
					type = "unlock-recipe",
					recipe = "ore-enrichment-process-"..item.name
					}
				},
				prerequisites =
				{
					"chemical-science-pack"
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
	local_create_ore_conversions()
end