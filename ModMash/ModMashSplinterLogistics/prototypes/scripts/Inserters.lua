local is_valid = modmashsplinterlogistics.util.is_valid

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

local local_set_range = function(position_in,range)
  local position = {x = 0, y = 0}  
  if position_in.x > 0.1 then
    position.x = range
  elseif position_in.x < -0.1 then
    position.x = -range
  else
    position.x = 0
  end
  if position_in.y > 0.1 then
    position.y = range
  elseif position_in.y < -0.1 then
    position.y = -range
  else
    position.y = 0
  end
  return position
end

local local_apply_pickup_rotation = function(entity)
  local px = entity.pickup_position.x - entity.position.x
  local py = entity.pickup_position.y - entity.position.y
  local zx = math.abs(entity.drop_position.x - entity.position.x)
  local zy = math.abs(entity.drop_position.y - entity.position.y)
  local dir = local_get_pickup_direction(entity)

  local r  = local_set_range(
  {
    x = local_pickup_rotations[dir].py * py,
    y = local_pickup_rotations[dir].px * px
  },math.max(math.floor(math.abs(px)),math.floor(math.abs(py)),math.floor(zx),math.floor(zy),1))
  entity.pickup_position = { x = entity.position.x+r.x, y = entity.position.y+r.y}
  end

local local_rotate_pickup = function(entity)
  local_apply_pickup_rotation(entity)
  if local_get_pickup_direction(entity) == entity.direction then
    local_apply_pickup_rotation(entity)
  end
  entity.direction = entity.direction end


local local_inserter_adjust = function(event)
    player = game.players[event.player_index]
	entity = player.selected
	if is_valid(entity) and (entity.type == "inserter" or (entity.type == "entity-ghost" and entity.ghost_type == "inserter")) then
		local_rotate_pickup(entity)	
	end
	end

if settings.startup["setting-adjust-inserter-pickup"].value == "Enabled" then
    script.on_event("adjust-inserter-pickup",local_inserter_adjust)
end