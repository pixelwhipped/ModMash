if not modmash then modmash = {} 	end
if not modmash.ticks then modmash.ticks = {} end
if not modmash.on_added then modmash.on_added = {} end
if not modmash.on_remove then modmash.on_remove = {} end
if not modmash.on_adjust then modmash.on_adjust = {} end
if not modmash.on_pick_up then modmash.on_pick_up = {} end
if not modmash.on_selected then modmash.on_selected = {} end
if not modmash.chunks then modmash.chunks = {} end
if not modmash.first_loot then modmash.first_loot = true end

if not modmash.on_player_cursor_stack_changed then modmash.on_player_cursor_stack_changed = {} end
if not modmash.on_damage then modmash.on_damage = {} end
if not modmash.on_research then modmash.on_research = {} end
if not modmash.on_trigger_created_entity then modmash.on_trigger_created_entity = {} end

if not global.modmash then global.modmash = {allow_pickup_rotations = false} end

require("prototypes.scripts.util")
require("prototypes.scripts.regenerative")
require("prototypes.scripts.explosive-mining")
require("prototypes.scripts.valves")
require("prototypes.scripts.wind-trap")
require("prototypes.scripts.discharge-pump")
require("prototypes.scripts.fishing-inserter")
require("prototypes.scripts.pipes")
require("prototypes.scripts.recycling")
require("prototypes.scripts.droid")
require("prototypes.scripts.loader")
require("prototypes.scripts.biter-neuro-toxin")

local build_events = {defines.events.on_built_entity, defines.events.on_robot_built_entity}-- defines.events.on_player_built_tile, defines.events.on_robot_built_tile}
local remove_events = {defines.events.on_entity_died,defines.events.on_robot_pre_mined,defines.events.on_robot_mined_entity,defines.events.on_pre_player_mined_entity,defines.events.on_player_mined_entity} --,defines.events.on_player_mined_tile, defines.events.on_robot_mined_tile}
local item_pick_up_events = {defines.events.on_picked_up_item,defines.events.on_player_mined_item,defines.events.on_robot_mined}

local loot_probability = 12
local local_on_added = function(event)	
	
	local entity = event.created_entity
	
	if entity ~= nil then	
		
		if entity.name == "biter-spawner" then
			entity.force = game.forces["neutral"]
		end
		for k=1, #modmash.on_added do local v = modmash.on_added[k]		
			v(entity)
		end
	end end

script.on_event(defines.events.on_entity_spawned, function(event)
	local entity = event.entity
	if util.ends_with(entity.name,"-biter") and entity.force == game.forces["neutral"] then
		entity.force = game.forces["enemy"]
	end
	end)

local local_on_removed = function(event)
	local entity = event.entity
	if entity ~= nil then		
		for k=1, #modmash.on_remove do local v = modmash.on_remove[k]		
			v(entity)
		end
	end end
local local_on_damage = function(event)
	local entity = event.entity
	if entity ~= nil then		
		for k=1, #modmash.on_damage do local v = modmash.on_damage[k]		
			v(entity)
		end
	end end
local local_item_pick_up = function(event)
	local stack = event.item_stack
	if stack ~= nil then		
		if stack.name == "void-item" then
			if event.player_index then
				local i = game.players[event.player_index].get_main_inventory()
				if i ~= nil then
					local c = i.get_item_count("void-item")
					if c > 0 then
						i.remove({name="void-item", count= c})
					end
				end
			end
		else
			for k=1, #modmash.on_pick_up do local v = modmash.on_pick_up[k]		
				v(stack)
			end
		end
	end end

local local_on_research = function(event)		
	for k=1, #modmash.on_research do local v = modmash.on_research[k]
		v(event)
	end end
local local_on_player_cursor_stack_changed = function(event)		
	for k=1, #modmash.on_player_cursor_stack_changed do local v = modmash.on_player_cursor_stack_changed[k]
		v(event)
	end end 



script.on_event(defines.events.on_tick, function()
	for k=1, #modmash.ticks do local v = modmash.ticks[k]	
		v()
	local alerts = game.players[1].get_alerts{}
	if #alerts>0 then
		for k=1, #alerts do local v = alerts[k] 
			for j=1, #v do local w = v[j] 
				for l=1, #w do local x = w[l] 
					--if x.target~=nil then
					--	util.print(x.target.prototype.subgroup.name)
					--end
					if  x~= nil and x.target~=nil then
						if (x.target.name ~= nil and util.starts_with(x.target.name,"biter")) or x.target.prototype.subgroup.name=="enemies" then
							game.players[1].remove_alert{entity = x.target}
						end
					end
				end
			end
		end
	end
	end end)

local local_on_trigger_created_entity = function(event)					
	local entity = event.entity	
	if entity ~= nil then	
		for k=1, #modmash.on_trigger_created_entity do local v = modmash.on_trigger_created_entity[k]		
			v(entity)
		end
	end end


script.on_event(build_events, local_on_added)
script.on_event(remove_events, local_on_removed)
script.on_event(item_pick_up_events, local_item_pick_up)
script.on_event(defines.events.on_entity_damaged,local_on_damage)
script.on_event(defines.events.on_research_finished, local_on_research)
script.on_event(defines.events.on_player_cursor_stack_changed,local_on_player_cursor_stack_changed)
script.on_event(defines.events.on_trigger_created_entity, local_on_trigger_created_entity)


local local_pickup_rotations = {
  [0] = -- south
  {
	py = -1, px = 0
  },
  [2] = -- west
  {
	py = 0, px = 1
  },
  [4] = -- north
  {
  py = -1, px = 0
  },
  [6] = -- east
  {
  py = 0, px = 1,
  },}

local local_get_pickup_direction = function(entity)
  -- Returns inverted pickup_position direction to match insert_position direction
  local dy = entity.pickup_position.y - entity.position.y
  if dy > 0.5 then
    return defines.direction.north
  elseif dy < -0.5 then
    return defines.direction.south
  else
    local dx = entity.pickup_position.x - entity.position.x
    if dx < -0.5 then
      return defines.direction.east
    else
      return defines.direction.west
    end
  end end
local local_apply_pickup_rotation = function(entity)
  local px = entity.pickup_position.x - entity.position.x
  local py = entity.pickup_position.y - entity.position.y
  local dir = local_get_pickup_direction(entity)
  entity.pickup_position =
  {
    entity.position.x + local_pickup_rotations[dir].py * py,
    entity.position.y + local_pickup_rotations[dir].px * px
  } end
local local_rotate_pickup = function(entity)
  local_apply_pickup_rotation(entity)
  if local_get_pickup_direction(entity) == entity.direction then
    local_apply_pickup_rotation(entity)
  end
  entity.direction = entity.direction end


script.on_event(defines.events.on_player_rotated_entity,function(event)

	entity = event.entity
	if global.modmash.allow_pickup_rotations and entity and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then			
		if global.modmash.allow_fishing then		
			fishing_inserter_removed(entity)
			fishing_inserter_added(entity)
		end
	end end)
  
script.on_event("automate-target",function(event)			
	player = game.players[event.player_index]
	entity = player.selected
	if entity ~= nil then		
		for k=1, #modmash.on_adjust do local v = modmash.on_adjust[k]
			v(entity)
		end	
		if global.modmash.allow_pickup_rotations and entity and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then
			if global.modmash.allow_fishing then
				local_rotate_pickup(entity)	
				fishing_inserter_removed(entity)
				fishing_inserter_added(entity)
			else
				local_rotate_pickup(entity)	
			end
		end
	end end)

local local_allow_pickup_rotations_research = function(event)		
	if util.starts_with(event.research.name,"allow-pickup-rotations") then
		global.modmash.allow_pickup_rotations = true
	elseif util.starts_with(event.research.name,"allow-fishing") then
		global.modmash.allow_fishing = true
    end
	end

local local_on_selected = function(event)
	player = game.players[event.player_index]
	entity = player.selected
	if entity ~= nil and (entity.name == "recycling-machine" or (global.modmash.allow_pickup_rotations and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")))) then
		if settings.startup["modmash-setting-show-adjustable"].value == true then
			entity.surface.create_entity{name="flying-text", position = entity.position, text="Press CTRL + A to adjust", color={r=1,g=1,b=1}}
		end
	end
	for k=1, #modmash.on_selected do local v = modmash.on_selected[k]
		v(entity)
	end
	end

lootable = {
	{name = "piercing-rounds-magazine", count = 200},
	{name = "uranium-rounds-magazine", count = 200},
	{name = "flamethrower-ammo", count = 100},
	{name = "rocket", count = 200},
	{name = "explosive-rocket", count = 200},
	{name = "shotgun-shell", count = 200},
	{name = "piercing-shotgun-shell", count = 200},

	{name = "heavy-armor", count = 1},
	{name = "modular-armor", count = 1},
	{name = "power-armor", count = 1},
	{name = "power-armor-mk2", count = 1},

	{name = "grenade", count = 100},
	{name = "cluster-grenade", count = 100},
	{name = "poison-capsule", count = 100},
	{name = "defender-capsule", count = 100},
	{name = "distractor-capsule", count = 100},
	{name = "destroyer-capsule", count = 100},
	{name = "discharge-defense-remote", count = 1},
	{name = "cliff-explosives", count = 2},

	{name = "solar-panel-equipment", count = 6},
	{name = "fusion-reactor-equipment", count = 1},
	{name = "energy-shield-equipment", count = 1},
	{name = "energy-shield-mk2-equipment", count = 1},
	{name = "battery-equipment", count = 4},
	{name = "battery-mk2-equipment", count = 4},
	{name = "personal-laser-defense-equipment", count = 20},
	{name = "discharge-defense-equipment", count = 20},
	{name = "exoskeleton-equipment", count = 4},
	{name = "personal-roboport-equipment", count = 1},
	{name = "personal-roboport-mk2-equipment", count = 1},
	{name = "night-vision-equipment", count = 1},
	{name = "flamethrower", count = 1},
	{name = "land-mine", count = 1},
	{name = "rocket-launcher", count = 1},
	{name = "shotgun", count = 1},
	{name = "combat-shotgun", count = 1},
	{name = "iron-plate", count = 200},
	{name = "copper-plate", count = 200},
	{name = "transport-belt", count = 100},
	{name = "electronic-circuit", count = 200},
	{name = "electric-mining-drill", count = 50},
	{name = "fast-inserter", count = 50},
	{name = "inserter", count = 50},
	{name = "boiler", count = 10},
	{name = "steam-engine", count = 10},
	{name = "radar", count = 50},
	{name = "assembling-machine-2", count = 50},
	{name = "assembling-machine-3", count = 50},
	{name = "splitter", count = 50},
	{name = "underground-belt", count = 100},
	{name = "electric-furnace", count = 50},
	{name = "big-electric-pole", count = 50},
	{name = "medium-electric-pole", count = 50},
	{name = "car", count = 1},
	{name = "speed-module-2", count = 50},
	{name = "heavy-armor", count = 1},
	{name = "droid", count=5},
	{name = "express-transport-belt", count = 100},
	{name = "long-handed-inserter", count = 50},
	{name = "stack-inserter", count = 50},
	{name = "assembling-machine-3", count = 50},
	{name = "solar-panel", count = 50},
	{name = "player-port", count = 50},
	{name = "gate", count = 50},
	{name = "steel-plate", count = 50},
	{name = "underground-belt", count = 50},
	{name = "express-underground-belt", count = 50}

}



local local_add_loot = function(surface_index, area )
	if util.distance(0,0,area.left_top.x,area.left_top.y) < 224 then return end
	if math.random(1, loot_probability) ~= 1 then return end
	local stack = nil

	local surface = game.surfaces[surface_index]
	local position = {x=area.left_top.x+math.random(0, 30),y=area.left_top.y+math.random(0, 30)}
	local name = "crash-site-chest-"..math.random(1, 2)
	if surface.can_place_entity{name=name,position=position} then
		local ent = surface.create_entity{
			  name = name,
			  position = position,
			  force = "neutral"}
		if ent ~= nil then
			local inv = ent.get_inventory(defines.inventory.chest)
			local stacks = math.random(2, 10)
			for s=1, stacks do
				if modmash.first_loot == true then
					modmash.first_loot = false
					stack = {name="droid", count=5}
				else	
					local r = math.random(1, 6)
					if r ~= 1 then
						stack = lootable[math.random(1, #lootable)]
					end
				end
				if stack ~=nil and inv.can_insert(stack) then
					inv.insert(stack)
				end
				stack = nil
			end	
			
		end
	end
end

local last_chunk = nil
local local_chunks = nil
local local_on_chunk_charted = function(event)
	local id = event.surface_index.."_"..event.position.x.."_"..event.position.y
	if last_chunk == id then return end
	if util.table.index_of(local_chunks,id) == nil then
		table.insert(local_chunks,id)
		last_chunk = id
		local_add_loot(event.surface_index, event.area)
	end
	
end

local local_on_post_entity_died = function(event)
	if event.ghost ~= nil then
		--util.print(event.ghost.ghost_name)
		if event.ghost.ghost_name == "biter-spawner" then
			event.ghost.destroy()
		--	local entites = entity.surface.find_entities_filtered{area = {{entity.position.x, entity.position.y}, {entity.position.x, entity.position.y}}}
		--	util.print(entites[1].name)
		end
	end
end

if modmash.ticks ~= nil then	
	local_chunks  = modmash.chunks
	table.insert(modmash.on_research,local_allow_pickup_rotations_research)
	script.on_event(defines.events.on_selected_entity_changed,local_on_selected)	
	script.on_event(defines.events.on_chunk_charted,local_on_chunk_charted)	
	script.on_event(defines.events.on_post_entity_died,local_on_post_entity_died)	
	
	
end