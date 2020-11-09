modmashsplinter.print = modmashsplinter.log
local table_contains = modmashsplinter.table.contains

local local_is_valid = function(entity) return type(entity)=="table" end

local raw_items = {"item","accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}
local item_list = nil

local local_get_item = function(name)
	if item_list == nil then
		item_list = {}
		for r = 1, #raw_items do local raw = raw_items[r]	
			for name,item in pairs(data.raw[raw]) do			
				if item ~= nil and item.name ~= nil then	
					if item_list[item.name] ~= nil then
						if item_list[item.name].icon_size == nil and item.icon_size ~= nil and (item.place_result ~= nil or item.stack_size ~= nil) then
                            if item.place_result ~= nil then
                                item_list[item.place_result] = item
                            else
							    item_list[item.name] = item
                            end
						end
					elseif item.place_result ~= nil then
                        item_list[item.place_result] = item
                    else
                        item_list[item.name] = item
					end
				end
			end
		end
	end
	return item_list[name]
    end

if modmashsplinter.mod_request_item_substitutions == nil then 
	modmashsplinter.mod_request_item_substitutions = {
		["titanium-ore"] = {
		func = 	function(qty,probability)
			if settings.startup["modmashsplinter-titanium-ore-preference"].value == "Bobs" and mods["bobsores"] then
				if probability ~= nil then
					return {{name = "rutile-ore", amount = qty, probability = probability}}
				end
				return {{name = "rutile-ore", amount = qty }}
			end
			--defer to titanium if it exists
			if local_get_item("titanium-ore") ~= nil then 
				if probability ~= nil then
					return {{name = "titanium-ore", amount = qty,probability = probability}}
				end
				return {{name = "titanium-ore", amount = qty }}
			end
			if probability ~= nil then
				return {{name = "iron-ore", amount = math.ceil(qty * 2.5),probability = probability}}
			end
			return {{name = "iron-ore", amount = math.ceil(qty * 2.5)}}
			end,
			compat = function() return settings.startup["modmashsplinter-titanium-ore-preference"].value == "Bobs" and mods["bobsores"] end
		},
		["titanium-plate"] = {
			func = function(qty,probability)
			--defer to titanium if it exists
			if local_get_item("titanium-plate") ~= nil then
				if probability ~= nil then
					return {{name = "titanium-plate", amount = qty, probability = probability}} 
				end
				return {{name = "titanium-plate", amount = qty }} 
			end
			return {{name = "steel-plate", amount = math.ceil(qty * 2)}}
			end	
		},
		["sludge"] = {
		func = 	function(qty,probability)
			--defer to sludge if it exists
			if local_get_item("sludge") ~= nil then 
				if probability ~= nil then
					return {{type = "fluid", name = "sludge", amount = qty }}
				end
				return {{type = "fluid", name = "sludge", amount = qty }}
			end
			if probability ~= nil then
				return {{type = "fluid", name = "light-oil", amount = math.ceil(qty), probability = probability}}
			end
			return {{type = "fluid", name = "light-oil", amount = math.ceil(qty)}}
			end	
		},
		["sludge-by-product"] = {
		func = 	function(qty,probability)
			--defer to sludge if it exists
			if local_get_item("sludge") ~= nil then 
				if probability ~= nil then
					return {{"stone", amount = qty, probability = probability}}
				end
				return {{"stone", amount = qty }}
			end
			if probability ~= nil then
				return {{name = "coal", amount = math.ceil(qty), probability = probability}}
			end
			return {{name = "coal", amount = math.ceil(qty)}}
			end	
		},
		["alien-plate"] = {
			func = function(qty,probability)
			--defer to titanium if it exists
			if local_get_item("alien-plate") ~= nil then
				if probability ~= nil then
					return {{name = "alien-plate", amount = qty, probability = probability}} 
				end
				return {{name = "alien-plate", amount = qty }} 
			end
			return modmashsplinter.mod_request_item_substitutions["titanium-plate"].func(math.ceil(qty * 2),probability)
			end	
		},
		["assembling-machine-burner"] = {
			func = function(qty,probability)
			--defer to titanium if it exists
			if local_get_item("assembling-machine-burner") ~= nil or mods["modmashsplinterassembling"] then
				if probability ~= nil then
					return {{name = "assembling-machine-burner", amount = qty, probability = probability}} 
				end
				return {{name = "assembling-machine-burner", amount = qty }} 
			end
			return {{name = "assembling-machine-1", amount = math.ceil(qty)}}
			end	
		}
		
	}
end

local local_validate_item_substitutions = function(name, func)		
	if modmashsplinter.table.is_empty(test) then log("substitution for ".. name .. " is nil or empty") return false end
	if type(func) ~= "function" then log("substitution for ".. name .. " missing function") return false end
	local test  = func(1)
	for k=1, #test do local ingredient = test[k]
		if type(ingredient) ~= "table" then log("substitution for ".. name .. " ingredient[" ..k.. "] invalid") return false end
		if modmashsplinter.is_empty(ingredient.name) then log("substitution for ".. name .. " ingredient[" ..k.. "] missing name") return false end
		if modmashsplinter.is_int(ingredient.amount) then log("substitution for ".. name .. " ingredient[" ..ingredient.name.. "] missing amount") return false end
	end
	return true
	end

local local_register_item_substitution = function(name, func, compat)
	if modmashsplinter.is_empty(name) then log("name for item substitution invalid") return false end
	if local_validate_item_substitutions(name,func) ~= true then log("item ".. name .. " substitution failed") return false end
	if modmashsplinter.mod_request_item_substitutions[name] ~= nil then 
		if modmashsplinter.mod_request_item_substitutions[name].compat() == false then
			log("replacing item ".. name .. " substitution from "..  serpent.block(modmashsplinter.mod_request_item_substitutions[name].func(1)) .. " with " .. serpent.block(func(1)))
		else
			log("cannot replace item ".. name .. " substitution from "..  serpent.block(modmashsplinter.mod_request_item_substitutions[name].func(1)) .. " with " .. serpent.block(func(1)) .. " becase compatibilty function is blocking action")
		end
	end
	if compat == nil or type(compat()) ~= "boolean" then 
		compat = function() return false end
	end
	modmashsplinter.mod_request_item_substitutions[name] = {
		func = func,
		compat = compat
		}
	end
	

local remove_ingredient_from = function(tble,value)
	local new_table = {}
	if tble ~= nil then
		for i = 1, #tble do	
			if tble[i] ~= nil then
				if tble[i].name ~= nil and tble[i].name ~= value then 
					table.insert(new_table,tble[i])
				elseif tble[i][1] ~= nil and tble[i][1] ~= value then						
					table.insert(new_table,tble[i])
				end
			end
		end			
	end
	tble = new_table
	return new_table
	end 

local local_substitue_ingredient_item = function(name,ingredients)		
	log(serpent.block(mods["modmashsplinterassembling"]))
    if modmashsplinter.is_empty(name) then log("name for item substitution invalid") return false end
	if modmashsplinter.table.is_empty(ingredients) then log("ingredients for item substitution " .. name .. " is invalid") return false end -- find name of item to substitue
	local count = 0
	local probability = nil
	for k = 1, #ingredients do local ingredient = ingredients[k]
		if ingredient ~= nil and (ingredient[1] == name or ingredient.name == name) then
			count = count + (ingredient.amount or ingredient[2])
			if ingredient.probability ~= nil then probability = ingredient.probability end
		end
	end
	if modmashsplinter.mod_request_item_substitutions[name] ~= nil then
		local sub = modmashsplinter.mod_request_item_substitutions[name].func(count,probability)
		if sub ~= nil and type(sub) == "table" and #sub > 0 then
			local new_table = remove_ingredient_from(ingredients,name)
			for k = 1, #sub do
				table.insert(new_table,sub[k])
			end
			ingredients = new_table
			return new_table
		end
	end
	return ingredients
	end

local local_get_item_substitution = function(name)
	
	if type(name) == "string" then  
		local s = local_substitue_ingredient_item(name,{{name = name, amount = 1}})
		if s~=nil and type(s) == "table" and #s > 0 and s[1].name ~= nil then 
			if s[1].type == "fluid" then
				local i = data.raw["fluid"][s[1].name]
				return i
			else
				local i = local_get_item(s[1].name) 
				return i
			end			
		end
	end
	return local_get_item(name)
	end


local local_get_item_ingredient_substitutions = function(names,ingredients)
	if type(names) == "string" then return local_substitue_ingredient_item(names,ingredients) end
	for k = 1, #names do local name = names[k]		
		if name ~= nil then ingredients = local_substitue_ingredient_item(name,ingredients) end
	end
	return ingredients
end

local local_check_icon_size = function(size,fallback)
	if size ~= nil then return size end
	if fallback ~= nil then return fallback end
	return 32
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
	
    local icons = modmashsplinter.table.table_clone(new_icons)
	--log(serpent.block(icons))
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

modmashsplinter.is_valid = local_is_valid
modmashsplinter.get_item = local_get_item

modmashsplinter.get_item_ingredient_substitutions = local_get_item_ingredient_substitutions
modmashsplinter.get_item_substitution = local_get_item_substitution

modmashsplinter.create_icon = local_create_icon

modmashsplinter.tech.get_technology = local_get_technology
modmashsplinter.tech.patch_technology = local_patch_technology