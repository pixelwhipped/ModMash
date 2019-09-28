if not modmash or not modmash.util then require("prototypes.scripts.util") end

local starts_with  = modmash.util.starts_with
local is_valid  = modmash.util.is_valid

local init = function()	
	if global.modmash.regenerative == nil then global.modmash.regenerative = {} end
	if global.modmash.regenerative.research_modifier == nil then global.modmash.regenerative.research_modifier = 0.1 end
	return nil end

local local_regenerative_notify_damaged = function(ent)
	if starts_with(ent.name,"regenerative") then
		local regenerables = global.modmash.regenerative
		for index=1, #regenerables do local regenerable = regenerables[index]		
			if regenerable.valid then
				if not regenerable.to_be_deconstructed(regenerable.force) then	
					if ent == regenerable then	
						return
					end
				end
			end
		end
		table.insert(global.modmash.regenerative, ent)	
	end end

local local_new_health = function(health,max_health,research_modifier)
	--=MAX((($A$2-B2)*$A$1),$A$1)+B2
	return math.max(((max_health-health)*research_modifier),research_modifier)+health	end


local local_regenerative_tick = function()
	if game.tick % 30 == 0 then		
		if init ~= nil then init = init() end		
		local regenerables = global.modmash.regenerative
		for index=1, #regenerables do local regenerable = regenerables[index]		
			if is_valid(regenerable) then
				if not regenerable.to_be_deconstructed(regenerable.force) then	
					local max_health = regenerable.prototype.max_health
				    if regenerable.health < max_health then
						regenerable.health = local_new_health(regenerable.health,max_health,global.modmash.regenerative.research_modifier)
					else
						table.remove(global.modmash.regenerative, index)
					end					
				else
					table.remove(global.modmash.regenerative, index)
				end
			else
				table.remove(global.modmash.regenerative, index)
			end
		end
	end end

local local_regenerative_added = function(ent)
	if starts_with(ent.name,"regenerative") then
		if ent.health < ent.prototype.max_health then
			table.insert(global.modmash.regenerative, ent)	
		end
	end end

local local_regenerative_research = function(event)		
	if starts_with(event.research.name,"enhance-regenerative-speed") then
		if global.modmash.regenerative.research_modifier == nil then global.modmash.regenerative.research_modifier = 0.1 end
		global.modmash.regenerative.research_modifier =  global.modmash.regenerative.research_modifier * 1.25
    end	end

if modmash.ticks ~= nil then	
	table.insert(modmash.ticks,local_regenerative_tick)	
	table.insert(modmash.on_added,local_regenerative_added)
	table.insert(modmash.on_damage,local_regenerative_notify_damaged)
	table.insert(modmash.on_research,local_regenerative_research)
end