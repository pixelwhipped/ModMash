if not util then require("prototypes.scripts.util") end
if global.modmash.biter_nero_toxin_research_modifier == nil then global.modmash.biter_nero_toxin_research_modifier = 25 end


local local_toxin_added = function(ent)
	if ent.name == "biter-neuro-toxin-cloud" then		
		local enemies = ent.surface.find_entities_filtered({
			force = "enemy",
			position = ent.position,
			radius = global.modmash.biter_nero_toxin_research_modifier,
		})
		for _, entity in ipairs(enemies) do
			entity.force = "player"
		end
	end
end

local local_toxin_research = function(event)		
	if util.starts_with(event.research.name,"enhance-biter-neuro-toxin-range") then
		if global.modmash.biter_nero_toxin_research_modifier == nil then global.modmash.biter_nero_toxin_research_modifier = 26 end
		global.modmash.biter_nero_toxin_research_modifier =  global.modmash.biter_nero_toxin_research_modifier * 1.25
    end	
end
if modmash.ticks ~= nil then	
	table.insert(modmash.on_trigger_created_entity,local_toxin_added)
	table.insert(modmash.on_research,local_toxin_research)
end