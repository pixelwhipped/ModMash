local ends_with = modmashsplinterairpurifier.util.ends_with
local get_item = modmashsplinterairpurifier.util.get_item
local get_name_for = modmashsplinterairpurifier.util.get_name_for

local local_ensure_ingredient_format = function(product)
	local type = nil
	local name = nil
	local amount = nil
	if product == nil then return nil end
	if product.type == nil then
		type = "item" 
	else 
		type = product.type
	end
	if product.name == nil then
		name = product[1] 
	else 
		name = product.name
	end
	if product.amount == nil then
		amount = product[2]
	else 
		amount = product.amount
	end
	if amount == nil then amount = 1 end
	if type ~= nil and name ~= nil then return {type=type, name=name, amount=amount} end
	return nil
end

local local_get_standard_results = function(recipe)
	if recipe == nil then return nil end
	local result_count = 1
	if recipe.results == nil then		
		if recipe.result ~= nil then
			result_count = recipe.result_count or 1
			if type(recipe.result) == "string" then
				return {{type = "item", name = recipe.result, amount = result_count}}
			elseif recipe.result.name then
				return {recipe.result}
			elseif recipe.result[1] then
				result_count = recipe.result[2] or result_count
				return {{type = "item", name = recipe.result[1], amount = result_count}}
			end	
		end
	end
	return recipe.results
end

local local_get_normal_results = function(recipe)
	if recipe == nil then return nil end
	local result_count = 1		
	if recipe.normal ~= nil and type(recipe.normal) == "table" and recipe.normal.result ~= nil then
		result_count = recipe.normal.result_count or 1
		if type(recipe.normal.result) == "string" then
			return {{type = "item", name = recipe.normal.result, amount = result_count}}
		elseif recipe.normal.result.name then
			return {recipe.result}
		elseif recipe.normal.result[1] then
			result_count = recipe.normal.result[2] or result_count
			return {{type = "item", name = recipe.normal.result[1], amount = result_count}}
		end		
	end
	return recipe.results
end

local local_create_ore_refinements = function()
	for name, recipe in pairs(data.raw.recipe) do
		if recipe ~= nil and recipe.name ~= nil and recipe.category=="smelting" then
			local sr = local_get_standard_results(recipe)
			local nr = local_get_normal_results(recipe)
			local s = nil
			local n = nil
			if sr~=nil and #sr==1 then s = sr[1] end
			if nr~=nil and #nr==1 then n = nr[1] end
			local make = nil
			local to_name = "_to_plate"						
			if s ~= nil and s.name ~= nil and (ends_with(s.name,"plate") or ends_with(s.name,"brick")) then
				if #recipe.ingredients == 1 then
					make = 
					{
						results = s,
						energy_required  = recipe.energy_required,
						ingredients = local_ensure_ingredient_format(recipe.ingredients[1])
					}
				end
				if ends_with(s.name,"brick") then to_name = "_to_brick" end
			elseif n ~= nil and n.name ~= nil and (ends_with(n.name,"plate") or ends_with(n.name,"brick"))  then
				if #recipe.normal.ingredients == 1 then	
					make = 
					{
						results = n,
						energy_required  = recipe.normal.energy_required,
						ingredients = local_ensure_ingredient_format(recipe.normal.ingredients[1])
					}
				end
				if ends_with(n.name,"brick") then to_name = "_to_brick" end
			end

			if make ~= nil then
				if make.ingredients ~=nil then
					local i = get_item(make.ingredients.name)
					if i ~= nil and (i.subgroup == "raw-resource" or ends_with(make.ingredients.name,"ore")) then
											
						if type(i.icon) == "string" then
							local m = data.raw["item"][make.ingredients.name].stack_size
							if m == nil then m = 50 end
							local ore_name = i.name.."-refined"
							local item = 
							{
								type = "item",
								name = ore_name,
								localised_name = get_name_for(i,"Refined"),
								localised_description = get_name_for(i,"Refined"),
								hide_from_player_crafting = true,
								icon = false,
								icons = {
									{
										icon = i.icon,
										icon_size = i.icon_size,
										icon_mipmaps = i.icon_mipmaps
									},
									{
										icon = i.icon,
										icon_size = i.icon_size,
										tint = {r=0.0,g=0.0,b=0.0,a=0.25},
										icon_mipmaps = i.icon_mipmaps
									}
								},
								subgroup = "raw-resource",
								order = "z["..ore_name.."]",
								stack_size = m
							}
							if i.pictures and #i.pictures > 0 then
						
								local new_pictures = {}
								for k = 1, #i.pictures do local pic = i.pictures[k]
									table.insert(new_pictures,{
										layers = {
											pic,
											{size = pic.size, filename = pic.filename,   scale = pic.scale, mipmap_count = pic.mipmap_count, shift = pic.shift, tint = {r=0.0,g=0.0,b=0.0,a=0.25}}
										}
									})
								end
								item.pictures = new_pictures
							
							end
							local refine_recipie = 
							{
								type = "recipe",
								name = ore_name,
								category = "ore-refining",
								subgroup = "refine",
								normal =
								{
									hide_from_player_crafting = true,
									allow_as_intermediate = false,
									allow_intermediates = false,
									hidden_from_char_screen = true,
									enabled = true,
									energy_required = 2,
									ingredients = {{i.name, 1}},
									result = ore_name
								}
							}
						

							local refine_result_recipie = 
							{
								type = "recipe",
								name = ore_name..to_name,
								category = "smelting",
								subgroup = "refine",
								normal =
								{
									hide_from_player_crafting = true,
									allow_as_intermediate = false,
									allow_intermediates = false,
									hidden_from_char_screen = true,
									enabled = true,
									energy_required = make.energy_required * 1.2,
									ingredients = {{ore_name, 1}},
									results = { {name = make.results.name, amount = make.results.amount * 2 }}
								}							
							}
							data:extend({item,refine_recipie,refine_result_recipie})
						end
					end
				end
			end
		end
	end
end

local local_create_ore_refinements_experimental = function()
	for name, recipe in pairs(data.raw.recipe) do
		if recipe ~= nil and recipe.name ~= nil and recipe.category=="smelting" then
			local sr = local_get_standard_results(recipe)
			local nr = local_get_normal_results(recipe)
			local s = nil
			local n = nil
			if sr~=nil and #sr==1 then s = sr[1] end
			if nr~=nil and #nr==1 then n = nr[1] end
			local make = nil
			local i = nil
			if s ~= nil and s.name ~= nil then				
				if #recipe.ingredients == 1 then
					local ing = local_ensure_ingredient_format(recipe.ingredients[1])
					i = get_item(ing.name)
					if i ~= nil and i.subgroup == "raw-resource" then
						make = 
						{
							results = s,
							energy_required  = recipe.energy_required,
							ingredients = ing
						}
					end
				end
			elseif n ~= nil and n.name ~= nil and (ends_with(n.name,"plate") or ends_with(n.name,"brick"))  then
				if #recipe.normal.ingredients == 1 then	
					local ing = local_ensure_ingredient_format(recipe.normal.ingredients[1])
					i = get_item(ing.name)
					if i ~= nil and i.subgroup == "raw-resource" then
						make = 
						{
							results = n,
							energy_required  = recipe.normal.energy_required,
							ingredients = ing
						}
					end
				end
			end

			if make ~= nil then
				if make.ingredients ~=nil then			
					if type(i.icon) == "string" then
						local m = data.raw["item"][make.ingredients.name].stack_size
						if m == nil then m = 50 end
						local ore_name = i.name.."-refined"
						local item = 
						{
							type = "item",
							name = ore_name,
							localised_name = get_name_for(i,"Refined"),
							localised_description = get_name_for(i,"Refined"),
							hide_from_player_crafting = true,
							icon = false,
							icons = {
								{
									icon = i.icon,
									icon_size = i.icon_size,
									icon_mipmaps = i.icon_mipmaps
								},
								{
									icon = i.icon,
									icon_size = i.icon_size,
									tint = {r=0.0,g=0.0,b=0.0,a=0.25},
									icon_mipmaps = i.icon_mipmaps
								}
							},
							subgroup = "raw-resource",
							order = "z["..ore_name.."]",
							stack_size = m
						}
						log(serpent.block(i))
						if i.pictures and #i.pictures > 0 then
						
							local new_pictures = {}
							for k = 1, #i.pictures do local pic = i.pictures[k]
								table.insert(new_pictures,{
									layers = {
										pic,
										{size = pic.size, filename = pic.filename,   scale = pic.scale, mipmap_count = pic.mipmap_count, shift = pic.shift, tint = {r=0.0,g=0.0,b=0.0,a=0.25}}
									}
								})
							end
							item.pictures = new_pictures
							
						end
						local refine_recipie = 
						{
							type = "recipe",
							name = ore_name,
							category = "ore-refining",
							subgroup = "refine",
							normal =
							{
								hide_from_player_crafting = true,
								allow_as_intermediate = false,
								allow_intermediates = false,
								hidden_from_char_screen = true,
								enabled = true,
								energy_required = 2,
								ingredients = {{i.name, 1}},
								result = ore_name
							}
						}
						

						local refine_result_recipie = 
						{
							type = "recipe",
							name = ore_name..recipe.name,
							category = "smelting",
							subgroup = "refine",
							normal =
							{
								hide_from_player_crafting = true,
								allow_as_intermediate = false,
								allow_intermediates = false,
								hidden_from_char_screen = true,
								enabled = true,
								energy_required = make.energy_required * 1.2,
								ingredients = {{ore_name, 1}},
								results = { {name = make.results.name, amount = make.results.amount * 2 }}
							}							
						}
						data:extend({item,refine_recipie,refine_result_recipie})
					end
				end
			end
		end
	end
end

if data ~= nil and data_final_fixes == true then
	if settings.startup["setting-ore-detection"].value == "Experimental" then
		local_create_ore_refinements_experimental()
	else
		local_create_ore_refinements()
	end
end