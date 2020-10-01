log("turrets.lua")
--[[check and import utils]]
if not heroturrets.defines then require ("prototypes.scripts.defines") end

--[[defines]]

--[[create local references]]
--[[util]]
local is_valid = heroturrets.util.is_valid
local print = heroturrets.util.print
local starts_with = heroturrets.util.starts_with
local ends_with = heroturrets.util.ends_with
local table_contains = heroturrets.util.table.contains
local is_valid_and_persistant = heroturrets.util.entity.is_valid_and_persistant
local distance = heroturrets.util.distance
local get_entities_around  = heroturrets.util.entity.get_entities_around
local find_recipes_for = heroturrets.util.recipe.find_recipes_for

--[[unitialized globals]]

--[[ensure globals]]


local local_replace_turret = function(entity,recipe)	
	local s = entity.surface
	local p = entity.position
	local f = entity.force
	local h = entity.health
	local mh = entity.prototype.max_health
	local k = entity.kills
	local d = entity.direction
	local o = entity.orientation
	local fluid = {}
	if entity.fluidbox ~= nil then 
	  for k = 1, #entity.fluidbox do fb = entity.fluidbox[k]
		if fb ~=nil and fb.name ~= nil then
			table.insert(fluid,{name = fb.name, amount = fb.amount, temperature = fb.temperature})
		end
	  end
	end

	local i = entity.get_inventory(defines.inventory.turret_ammo)
	local c = nil
	if i ~= nil then 
		c = i.get_contents()		
	end
	
	entity.destroy()
	local new_entity = s.create_entity{name=recipe.name, position=p, force = f, direction = d, orientation = o}
	if h ~= mh then new_entity.health = h end
	new_entity.kills = k
	local inv = new_entity.get_inventory(defines.inventory.turret_ammo)
	if inv ~= nil and c ~= nil then
		for name, count in pairs(c) do
			inv.insert{name=name,count=count}
		end
	end
	if fluid ~=nil then
		for k = 1, #fluid do fb = fluid[k]
			new_entity.fluidbox[k] = {name = fb.name, amount = fb.amount, temperature = fb.temperature}
		end
	end

	end

local turret_types = {"ammo-turret", "fluid-turret","electric-turret","artillery-turret"}

local local_turret_added = function(entity,event)	
	if is_valid(entity) ~= true then return end	
	
	if table_contains(turret_types,entity.type)  ~= true then return end    
	if settings.startup["heroturrets-kill-counter"].value == "Exact" and is_valid(event.stack) and event.stack.type == "item-with-tags" and event.stack.get_tag("kills") ~= nil then
		entity.kills = event.stack.get_tag("kills")
	elseif starts_with(entity.name,"hero-turret-4") == true then
		entity.kills = math.max(heroturrets.defines.turret_levelup_four, entity.kills)
	elseif starts_with(entity.name,"hero-turret-3") == true then
		entity.kills = math.max(heroturrets.defines.turret_levelup_three, entity.kills)
	elseif starts_with(entity.name,"hero-turret-2") == true then
		entity.kills = math.max(heroturrets.defines.turret_levelup_two, entity.kills)
	elseif starts_with(entity.name,"hero-turret-1") == true then
		entity.kills = math.max(heroturrets.defines.turret_levelup_one, entity.kills)
	end
	end

local local_turret_removed = function(entity,event)	
 
	if event ~= nil and is_valid(event.cause) == true and table_contains(turret_types,event.cause.type) and event.cause.kills ~=nil then		
		if event.cause.kills >= heroturrets.defines.turret_levelup_four then		
			if starts_with(event.cause.name,"hero-turret") == true then
				--is a hero turret
				if starts_with(event.cause.name,"hero-turret-4") then
					--nothing to do
				else
					local new_name = event.cause.name:gsub("hero%-turret%-3%-for%-", "")
					new_name = new_name:gsub("hero%-turret%-2%-for%-", "")
					new_name = new_name:gsub("hero%-turret%-1%-for%-", "")
					local ug = find_recipes_for("hero-turret-4-for-"..new_name,event.cause.force)
					
					if #ug ~= 0 then
						local_replace_turret(event.cause,ug[1])
					end
				end
			else
				--find upgrade
				local ug = find_recipes_for("hero-turret-4-for-"..event.cause.name,event.cause.force)
				if #ug ~= 0 then
					local_replace_turret(event.cause,ug[1])
				end
			end
		elseif event.cause.kills >= heroturrets.defines.turret_levelup_three then		
			if starts_with(event.cause.name,"hero-turret") == true then
				--is a hero turret
				if starts_with(event.cause.name,"hero-turret-3") then
					--nothing to do
				else
					local new_name = event.cause.name:gsub("hero%-turret%-2%-for%-", "")
					new_name = new_name:gsub("hero%-turret%-1%-for%-", "")
					local ug = find_recipes_for("hero-turret-3-for-"..new_name,event.cause.force)
					
					if #ug ~= 0 then
						local_replace_turret(event.cause,ug[1])
					end
				end
			else
				--find upgrade
				local ug = find_recipes_for("hero-turret-3-for-"..event.cause.name,event.cause.force)
				if #ug ~= 0 then
					local_replace_turret(event.cause,ug[1])
				end
			end
		elseif event.cause.kills >= heroturrets.defines.turret_levelup_two then
			if starts_with(event.cause.name,"hero-turret") then
				--is a hero turret
				if starts_with(event.cause.name,"hero-turret-2") then
					--nothing to do
				else
					local new_name = event.cause.name:gsub("hero%-turret%-1%-for%-", "")
					local ug = find_recipes_for("hero-turret-2-for-"..new_name,event.cause.force)
					if #ug ~= 0 then
						local_replace_turret(event.cause,ug[1])
					end
				end
			else
				--find upgrade
				local ug = find_recipes_for("hero-turret-2-for-"..event.cause.name,event.cause.force)
				if #ug ~= 0 then
					local_replace_turret(event.cause,ug[1])
				end
			end
		elseif event.cause.kills >= heroturrets.defines.turret_levelup_one then
			if starts_with(event.cause.name,"hero-turret") then
				--nothing to do
			else
				--find upgrade
				local ug = find_recipes_for("hero-turret-1-for-"..event.cause.name,event.cause.force)
				if #ug ~= 0 then
					local_replace_turret(event.cause,ug[1])
				end
			end
		end
	elseif settings.startup["heroturrets-kill-counter"].value == "Exact" and event ~= nil and is_valid(event.entity) and is_valid(event.buffer) and table_contains(turret_types,event.entity.type) and event.entity.kills ~= nil and event.entity.kills > 0 then	
		if #event.buffer == 1 and entity.kills==0 then
			local item = event.buffer[1]
			local standard_item = item.name:sub(1,#item.name-#"-with-tags")
			local stack = {
				name = standard_item,
				count = item.count,
				health = item.health,
				ammo = item.ammo
			}
			if event.buffer.can_set_stack(stack) then
				event.buffer.set_stack(stack)
			elseif item.type == "item-with-tags" then 			
				item.set_tag("kills", entity.kills)
				item.custom_description = entity.kills .. " Kills"
			end
		else
			for k=#event.buffer, 1, -1 do item = event.buffer[k]
				if item.type == "item-with-tags" then 			
					item.set_tag("kills", entity.kills)
					item.custom_description = entity.kills .. " Kills"
				end
			end
			--print(serpent.block(item.tags["kills"]))
			--if item.name:match("^hero%-turret%-%d%-for%-") ~= nil then
				
		end		
	end
	end

local local_on_post_entity_died = function(event)
	if settings.global["heroturrets-allow-ghost-rank"].value then return end
	if event.ghost ~= nil then	
		local fstr = event.ghost.ghost_name :match("^hero%-turret%-%d%-for%-")
		if fstr ~=nil then
			local base_entity = event.ghost.ghost_name:sub(#fstr+1)
			local force = event.ghost.force
			local direction = event.ghost.direction
			local position = event.ghost.position
			local surface = event.ghost.surface
			event.ghost.destroy()
			surface.create_entity{name = "entity-ghost", inner_name = base_entity, force = force, position = position, direction = direction}
		end
	end
	end

local control = {
	on_removed = local_turret_removed,
	on_added = local_turret_added,
	on_post_entity_died = local_on_post_entity_died
}

heroturrets.register_script(control)