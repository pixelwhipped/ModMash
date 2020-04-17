 --[[dsync checking 
ok only local is reference to global
]]

--[[code reviewed 6.10.19
	Used defines for enitity name references
	Updated symbols]]
log("biter-neuro-toxin.lua")

--[[check and import utils]]
if modmash == nil or modmash.util == nil then require("prototypes.scripts.util") end
if not modmash.defines then require ("prototypes.scripts.defines") end

--[[defines]]
local biter_neuro_toxin_cloud = modmash.defines.names.biter_neuro_toxin_cloud
local enhance_biter_neuro_toxin_range = modmash.defines.names.enhance_biter_neuro_toxin_range
local define_biter_nero_toxin_research_modifier = modmash.defines.defaults.biter_nero_toxin_research_modifier 
local define_biter_nero_toxin_research_modifier_increment = modmash.defines.defaults.biter_nero_toxin_research_modifier_increment
local force_player = modmash.defines.names.force_player
local force_enemy = modmash.defines.names.force_enemy
local force_neutral  = modmash.defines.names.force_neutral

--[[create local references]]
--[[util]]
local starts_with  = modmash.util.starts_with

--[[unitialized globals]]
local biter_nero_toxin = nil

--[[ensure globals]]
local local_init = function()	
	log("biter-neuro-toxin.local_init")
	if global.modmash.biter_nero_toxin == nil then global.modmash.biter_nero_toxin = {} end
	if global.modmash.biter_nero_toxin.research_modifier == nil then global.modmash.biter_nero_toxin.research_modifier = define_biter_nero_toxin_research_modifier end
	biter_nero_toxin = global.modmash.biter_nero_toxin
	end
local local_load = function()
	log("biter-neuro-toxin.local_load")
	biter_nero_toxin = global.modmash.biter_nero_toxin
	end

local local_get_random_point = function(x, y, radius)
	local randX, randY
	repeat
		randX, randY = math.random(-radius, radius), math.random(-radius, radius)
	until (((-randX) ^ 2) + ((-randY) ^ 2)) ^ 0.5 <= radius
	return {x + randX, y + randY}
	end

local local_toxin_added = function(event)	
	local entity = event.entity
	if entity.name == biter_neuro_toxin_cloud then
		local count = 10 * (biter_nero_toxin.research_modifier/modmash.defines.defaults.biter_nero_toxin_research_modifier)
		for i =1, count do
			entity.surface.create_entity{name="toxin-poison-cloud",position=local_get_random_point(entity.position.x,entity.position.y,biter_nero_toxin.research_modifier)}
			--[[entity.surface.create_particle{
				name="poison-capsule-metal-particle", 
				position=local_get_random_point(entity.position.x,entity.position.y,biter_nero_toxin.research_modifier),
				movement={0,0},
				height=1, 
				vertical_speed=0, 
				frame_speed=1}]]
		end
		local enemies = entity.surface.find_entities_filtered({
			type = {"unit-spawner","unit","turret"},
			position = entity.position,
			radius = biter_nero_toxin.research_modifier,
		})
		for _, enemy in ipairs(enemies) do
			if enemy.prototype.subgroup.name=="enemies" then
				if enemy.type == "unit-spawner" then
					--enemy.force = game.forces[force_neutral]
					local p = enemy.position
					local n = enemy.name
					enemy.destroy()
					entity.surface.create_entity{name=n, position=p, force = game.forces[force_neutral]}

				elseif enemy.type == "turret" then
					--enemy.force = game.forces[force_neutral] dose not work need to remove and add back
					local p = enemy.position
					local n = enemy.name
					enemy.destroy()
					entity.surface.create_entity{name=n, position=p, force = game.forces[force_player]}
					
				else
					enemy.force = game.forces[force_player]
				end
			end
		end
	end
end

local local_toxin_research = function(event)		
	if starts_with(event.research.name,enhance_biter_neuro_toxin_range) then		
		biter_nero_toxin.research_modifier =  biter_nero_toxin.research_modifier * define_biter_nero_toxin_research_modifier_increment
    end	
end

local local_on_configuration_changed = function(f)
	if f.mod_changes["modmash"].old_version < "0.17.61" then	
		--fix tech
		for _, tech in pairs(game.players[1].force.technologies) do
			if tech.researched == true and starts_with(tech.name,enhance_biter_neuro_toxin_range) then
				biter_nero_toxin.research_modifier =  biter_nero_toxin.research_modifier * define_biter_nero_toxin_research_modifier_increment
			end
		end
	end
	end

--[[local local_on_selected = function(player,entity)
	if entity ~= nil then
		entity.surface.create_entity{name="poison-cloud",position={entity.position.x+1,position=entity.position.y+1}}
		--modmash.util.print(entity.name)

	end
	end]]

modmash.register_script({
	names = {biter_neuro_toxin_cloud},
	on_init = local_init,
	on_load = local_load,
	on_trigger_created_entity = local_toxin_added,
	on_research = local_toxin_research,
	on_configuration_changed = local_on_configuration_changed,
	--on_selected = local_on_selected,
})