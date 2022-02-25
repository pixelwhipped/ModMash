log("LIBORIO UTILDATA")
liborio.print = liborio.log --keep here as may be used

local local_is_valid = function(entity) return type(entity)=="table" end

local local_get_technology = function(technology) return data.raw["technology"][technology] end

local local_patch_technology = function(technology, recipe)
	local tech = nil
	if type(technology) == "table" and technology.effects ~= nil then 
		tech = technology
	elseif type(technology) == "string" then
		tech = local_get_technology(technology)
	end
	if tech then
		for k = 1, #tech.effects do r = tech.effects[k]
			if r.recipe == recipe then return end
		end
        table.insert(tech.effects, {
			type="unlock-recipe",
			recipe=recipe
		})
	elseif type(technology) == "table" then
		--Not Implemented
	end
	end

local local_find_entity_prototypes = function(proto_type)
    local prototypes = {}
	for i,category in pairs(data.raw) do
		if category ~= nil and type(category)=="table" then
			for j,prototype in pairs(category) do					
				if prototype ~= nil and prototype.type == proto_type then 
                     return prototype
                end
            end
        end
    end
	return prototypes
	end

local local_find_entity = function(name)
	for i,category in pairs(data.raw) do
		if category ~= nil and type(category)=="table" then
			for j,prototype in pairs(category) do					
				if prototype ~= nil and prototype.type ~= "recipe" and prototype.name == name then return prototype end
            end
        end
    end
	return nil
    end

local local_format_results_result = function(difficulty)
	local result
	if res.type == "item" or res.type == nil then
		result = {
			type = "item",
			show_details_in_recipe_tooltip = res.show_details_in_recipe_tooltip or true,

			name = res.name or res[1],
			amount = res.amount or res[2],
			probability = res.probability or 1,
			amount_min = (not res.amount and res.amount_min),
			amount_max = (not res.amount and res.amount_max),
			catalyst_amount = res.catalyst_amount, --this does not count automatic amounts
		}
	else
		result = {
			type = "fluid",
			show_details_in_recipe_tooltip = res.show_details_in_recipe_tooltip or true,

			name = res.name or res[1],
			amount = res.amount or res[2],
			probability = res.probability or 1,
			amount_min = (not res.amount and res.amount_min),
			amount_max = (not res.amount and res.amount_max),
			temperature = res.temperature,
			catalyst_amount = res.catalyst_amount, --this does not count automatic amounts
			fluidbox_index = res.fluidbox_index or 0,
		}
	end
	return result
	end

local local_results_among_difficulty = function(difficulty_table)
	if type(difficulty) == "table" then
		local results = {}
		if difficulty.results then
			for k,res in pairs(difficulty.results) do
				results[k] = local_format_results_result(res)
			end
		else
			if difficulty.result then
				results[1] = {
					type = "item",
					name = difficulty.result,
					amount = difficulty.result_count,
					--probability = 1,
				}
			end
		end
		if table_size(results) > 0 then
			return results
		end
	end
	return nil
	end

local local_format_results = function(recipe)
	-- this function returns difficulties which are nil while the other difficulty exists
	-- the other option is to *only* include accessible difficulties, even if a result would exist for a difficulty
	local difficulties = {}
	if recipe.normal or recipe.expensive then
		local other = {["normal"] = "expensive", ["expensive"] = "normal"}
		for _, diff in pairs({"normal", "expensive"}) do
			local difficulty = recipe[diff]
			if difficulty == nil then difficulty = recipe[other[diff]] end
			difficulties[diff] = local_results_among_difficulty(difficulty)
		end
	else
		difficulties[""] = local_results_among_difficulty(recipe)
	end
	if table_size(difficulties) > 0 then return difficulties end
    return nil
    end

local local_find_recipes_for = function(name)
    local recipes = { }
	for i,r in pairs(data.raw["recipe"]) do
		local difficulties = local_format_results(r)
		if difficulties then
			for which, results in pairs(difficulties) do
				for _, result in pairs(results) do
					if result.name == name then
						recipes[r.name] = r
						goto continue
					end
				end
			end
		end
--[[
		if recipes[r.name] == nil then
			if r.normal ~= nil then
				if r.normal.result ~= nil then
					if r.normal.result == name and recipes[r.name] == nil then recipes[r.name] = r end

                end
				if r.normal.results ~= nil then
					for k=1, #r.normal.results do local i = r.normal.results[k]
						if i.name == name and recipes[r.name] == nil then recipes[r.name] = r end

                    end
                end

            end
			if r.expensive ~= nil then
				if r.expensive.result ~= nil then
					if r.expensive.result == name and recipes[r.name] == nil then recipes[r.name] = r end

                end
				if r.expensive.results ~= nil then
					for k=1, #r.expensive.results do local i = r.expensive.results[k]
						if i.name == name and recipes[r.name] == nil then recipes[r.name] = r end
                    end
                end

            end
			if r.result ~= nil then
				if r.result == name and recipes[r.name] == nil then recipes[r.name] = r end
            end
			if r.results ~= nil then
				for k=1, #r.results do local i = r.results[k]
					if i.name == name and recipes[r.name] == nil then recipes[r.name] = r end
                end
            end
        end
--]]
		::continue::
    end
	return recipes
    end

local local_create_icon = function(base_icons, new_icons, options)
	if type(base_icons) ~= "table" then return base_icons end
	if type(options) ~= "table" then options = { } end
    local icon = nil
	if not options.rescale then options.rescale = 1 end
	if not options.origin then options.origin = {0,0} end
	if not new_icons then
		if options.from ~= nil and type(options.from) == "table" then
			if options.from.icons then new_icons = options.from.icons
            elseif options.from.icon then new_icons = {{icon = options.from.icon}}
			else error("Table given had no icons.") end
			for _, icon in pairs(new_icons) do
				if not icon.icon_size then icon.icon_size = options.from.icon_size end
				if not icon.icon_size then error("Had icon "..icon.icon.." but size is missing.") end
            end
		else
			error("Couldn't build icons: no icons and no table to build from.")
        end
    end
    local icons = liborio.table.table_clone(new_icons)
	for _, icon in pairs(base_icons) do
		if not icon.scale then icon.scale = 1 end
		if icon.shift ~= nil and type(icon.shift) ~= "table" then
			icon.shift = {0,0}
		end
		if not icon.shift then icon.shift = {0,0} end
	end
	if options.type == nil or options.type == "recipe" then
		for _, icon in pairs(icons) do
			if not icon.icon_size then icon.icon_size = 32 end
        end
    end
    local extra_scale
	for _, icon in pairs(icons) do
		if not icon.scale then icon.scale = 1 end
		if icon.shift ~= nil and type(icon.shift) ~= "table" then
			icon.shift = {0,0} 
		end
		if (not icon.shift) or (not icon.shift[1]) then icon.shift = {0,0} end
		extra_scale = 1
		if base_icons[1] then
			if (base_icons[1].icon_size* base_icons[1].scale) ~= (icon.icon_size* icon.scale) then
              extra_scale = (base_icons[1].icon_size * base_icons[1].scale) / (icon.icon_size)
			end
		else
			if (icons[1].icon_size* icons[1].scale) ~= (icon.icon_size* icon.scale) then
				extra_scale = (icons[1].icon_size * icons[1].scale) / (icon.icon_size)
			end
        end

        icon.shift[1] = icon.shift[1] / icon.scale
        icon.shift[2] = icon.shift[2] / icon.scale
        icon.scale = icon.scale * options.rescale * extra_scale
        icon.shift[1] = icon.shift[1] * icon.scale + options.origin[1] * icon.scale * icon.icon_size
        icon.shift[2] = icon.shift[2] * icon.scale + options.origin[2] * icon.scale * icon.icon_size
    end
	for _, icon in pairs(icons) do
        table.insert(base_icons, icon)
    end
	for i=1, #base_icons do 
		if type(base_icons[i].shift) ~= table then base_icons[i].shift = {0,0} end
	end
	return base_icons
	end

liborio.is_valid = local_is_valid
liborio.entity.find_raw_entity_prototypes = local_find_raw_entity_prototypes
liborio.tech.get_technology = local_get_technology
liborio.tech.patch_technology = local_patch_technology
liborio.recipe.find_recipes_for = local_find_recipes_for
liborio.entity.find_entity_prototypes = local_find_entity_prototypes
liborio.entity.find_entity = local_find_entity
liborio.create_icon = local_create_icon