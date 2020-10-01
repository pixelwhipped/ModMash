log("Creating Types")
if not heroturrets.defines then require ("prototypes.scripts.defines") end

local starts_with  = heroturrets.util.starts_with
local ends_with  = heroturrets.util.ends_with
local ends_with  = heroturrets.util.ends_with
local get_name_for = heroturrets.util.get_name_for
local table_contains = heroturrets.util.table.contains
local table_remove = heroturrets.util.table.remove
local create_icon = heroturrets.util.create_icon
local convert_to_string = heroturrets.util.convert_to_string

local tech = data.raw["technology"]

local raw_items = {"item","accumulator","active-defense-equipment","ammo","ammo-turret","arithmetic-combinator","armor","artillery-turret","artillery-wagon","assembling-machine","battery-equipment","beacon","belt-immunity-equipment","boiler","capsule","car","cargo-wagon","combat-robot","constant-combinator","construction-robot","container","decider-combinator","electric-pole","electric-turret","energy-shield-equipment","fluid-wagon","furnace","gate","generator","generator-equipment","gun","heat-pipe","inserter","item","locomotive","logistic-container","logistic-robot","market","mining-drill","module","night-vision-equipment","offshore-pump","pipe","pipe-to-ground","power-switch","programmable-speaker","projectile","pump","radar","rail-chain-signal","rail-planner","rail-signal","reactor","repair-tool","resource","roboport","roboport-equipment","rocket-silo","solar-panel","solar-panel-equipment","splitter","storage-tank","straight-rail","tool","train-stop","transport-belt","underground-belt","wall"}
local item_list = nil

local local_get_item = function(name)
	if item_list == nil then
		item_list = {}
		for r = 1, #raw_items do local raw = raw_items[r]	
			for name,item in pairs(data.raw[raw]) do			
				if item ~= nil and item.name ~= nil then	
					if table_contains(item_list,item.name) then
						if item_list[item.name].icon_size == nil and item.icon_size ~= nil then
							item_list[item.name] = item
						end
					else
						item_list[item.name] = item
					end
				end
			end
		end
	end
	return item_list[name]
    end

local is_nesw = function(entity)
	if entity == nil then return false end
    if entity.base_picture == nil then return false end
    if entity.base_picture.north == nil then return false end
    if entity.base_picture.north.layers == nil then return false end
    if entity.base_picture.east == nil then return false end
    if entity.base_picture.east.layers == nil then return false end
    if entity.base_picture.south == nil then return false end
    if entity.base_picture.south.layers == nil then return false end
    if entity.base_picture.west == nil then return false end
    if entity.base_picture.west.layers == nil then return false end
    return true
    end

local get_badge = function(rank,top,left,rc)
    local img = {
                    filename = "__heroturrets__/graphics/entity/turret/hero-"..rank.."-base.png",
                    priority = "high",
                    width = 23,
                    height = 24,
                    direction_count = 1,
                    frame_count = 1,
                    repeat_count = rc,
                    shift = util.by_pixel((left)*-1,top+(24/3)),
                    hr_version =
                    {
                        filename = "__heroturrets__/graphics/entity/turret/hr-hero-"..rank.."-base.png",
                        priority = "high",
                        line_length = 1,
                        width = 46,
                        height = 48,
                        frame_count = 1,
                        direction_count = 1,
                        shift = util.by_pixel((left)*-1,top+(48/3)),
                        scale = 0.5
                    }
                }
    return img
    end

--[[
   Update as military upgrades effect adds 
      {
        type = "turret-attack",
        turret_id = "flamethrower-turret",
        modifier = x
      } 
      note the turret-id
]]
local update_fluid_turret_tech = function(entity, name,rank)
    log("Updating tech for refined flammables" .. " for "..entity.name)
    for _, tech in pairs(tech) do
        if tech.name:match("^refined%-flammables%-") and tech.effects then            
            local effect = nil
            for _, eff in pairs(tech.effects) do
                if eff.type == "turret-attack" and eff.turret_id == entity.name then
                    effect = table.deepcopy(eff)
                end
            end
            if effect ~= nil then 
                log("Adding tech for "..tech.name .. " for "..entity.name)
                table.insert(tech.effects, {type="turret-attack", turret_id = name, modifier = effect.modifier*(1+(0.25*rank)) })
            else
                log("Missing tech for "..tech.name .. " for "..entity.name)
            end
        end
    end
    end

local update_ammo_turret_tech = function(entity, name, rank)
    log("Updating tech for physical projectile damage")
    for _, tech in pairs(tech) do
        if tech.name:match("^physical%-projectile%-damage%-") and tech.effects then
            local effect = nil
            for _, eff in pairs(tech.effects) do
                if eff.type == "turret-attack" and eff.turret_id == entity.name then
                    effect = table.deepcopy(eff)
                end
            end
            if effect ~= nil then 
                log("Adding tech for "..tech.name .. " for "..entity.name)
                table.insert(tech.effects, {type="turret-attack", turret_id = name, modifier = effect.modifier*(1+(0.25*rank))})
            else 
                log("Missing tech for "..tech.name .. " for "..entity.name)
            end
        end
    end
    end

local local_create_turret_with_tags = function(turret)
    local name_with_tags = turret.item.name.."-with-tags"
    
    local item_with_tags = table.deepcopy(turret.item)
    item_with_tags.type = "item-with-tags"
    item_with_tags.name = name_with_tags
    item_with_tags.localised_name = turret.item.localised_name
    item_with_tags.localised_description = turret.item.localised_desc
    item_with_tags.localised_description = turret.item.localised_desc
    item_with_tags.order = turret.item.order..".tag"
    turret.entity.minable.result = name_with_tags
    data:extend({item_with_tags})
    end

local local_create_turret = function(turret,rank,rank_string,mod)
        local base_icon = 
		{   
           {
            icon = "__heroturrets__/graphics/icons/hero-"..rank.."-icon.png",
			icon_size = 64,
            icon_mipmaps = 4
           }
		}
        local localised_name = get_name_for(turret.item,""," "..rank_string)
        local localised_desc = get_name_for(turret.item,""," "..rank_string)
        local new_icon = create_icon(base_icon, nil, {from = turret.item})
        local rev = {}
        for i=#new_icon, 1, -1 do
	        rev[#rev+1] = new_icon[i]
        end
        new_icon = rev
        local name = "hero-turret-"..rank.."-for-"..turret.item.name
        local name_with_tags = name.."-with-tags"
        local item = {
            type = "item",
            name = name,
            localised_name = localised_name,
            localised_description = localised_desc,
            icon = false,
            icons = new_icon,
            icon_size = 64,
            --hide_from_player_crafting = true,

            subgroup = turret.item.subgroup,
            order = turret.item.order.."["..rank.."]",
            place_result = name,
            stack_size = turret.item.stack_size 
        }
        local item_with_tags = {
            type = "item-with-tags",
            name = name_with_tags,
            localised_name = localised_name,
            localised_description = localised_desc,
            icon = false,
            icons = new_icon,
            icon_size = 64,
            hide_from_player_crafting = true,
            subgroup = turret.item.subgroup,
            order = turret.item.order.."["..rank.."].tag",
            place_result = name,
            stack_size = turret.item.stack_size
        }
        local recipe = {
            type = "recipe",
            name = name,
            localised_name = localised_name,
            localised_description = localised_desc,
            icon = false,
            icons = new_icon,
            icon_size = 64,
            enabled = false,
            energy = turret.recipe.energy,
            category = turret.recipe.category,
            subgroup = turret.recipe.subgroup,
            hide_from_player_crafting = true,
            ingredients =
            {
	            {turret.item.name, 1},
            },
            result = name
        }
        local entity = table.deepcopy(turret.entity)
        entity.name = name
        entity.max_health = (math.floor((entity.max_health*mod)/10)*10)
        if entity.rotation_speed ~= nil then entity.rotation_speed = entity.rotation_speed*mod end
        --if entity.turret_rotation_speed ~= nil then entity.turret_rotation_speed = entity.turret_rotation_speed*mod end
        if entity.preparing_speed ~= nil then entity.preparing_speed = entity.preparing_speed*mod end
        if entity.attacking_speed ~= nil then entity.attacking_speed = entity.attacking_speed*mod end
        if entity.prepare_range ~= nil then entity.prepare_range = entity.prepare_range*mod end
        if entity.turret_rotation_speed ~= nil then entity.turret_rotation_speed = entity.turret_rotation_speed*mod end
        if entity.manual_range_modifier ~= nil then entity.manual_range_modifier = entity.manual_range_modifier*mod end
        if entity.turn_after_shooting_cooldown ~= nil then entity.turn_after_shooting_cooldown = entity.turn_after_shooting_cooldown*(1-(mod-1)) end
        
        if entity.attack_parameters ~= nil then
            if entity.attack_parameters.cooldown ~= nil then entity.attack_parameters.cooldown = entity.attack_parameters.cooldown * (1-(mod-1)) end
            if entity.attack_parameters.range ~= nil then entity.attack_parameters.range = entity.attack_parameters.range * mod end
            if entity.attack_parameters.ammo_type ~= nil and entity.attack_parameters.ammo_type.action ~= nil then
                if entity.attack_parameters.ammo_type.action.action_delivery ~= nil  and entity.attack_parameters.ammo_type.action.action_delivery.max_length ~= nil then
                    entity.attack_parameters.ammo_type.action.action_delivery.max_length  = entity.attack_parameters.ammo_type.action.action_delivery.max_length  * mod
                end
            end
        end
        if entity.gun ~= nil then
            local gun = table.deepcopy(data.raw["gun"][entity.gun])
            if gun.attack_parameters ~= nil then
                local gun_name = "hero-turret-gun-"..rank.."-for-" ..entity.gun
                if gun.attack_parameters.cooldown ~= nil then gun.attack_parameters.cooldown = gun.attack_parameters.cooldown * (1-(mod-1)) end
                if gun.attack_parameters.range ~= nil then gun.attack_parameters.range = gun.attack_parameters.range * mod end
                gun.name = gun_name
                gun.localised_name = localised_name
                gun.localised_desc = localised_desc
                data:extend({gun})
                entity.gun = gun_name
            end
        end
        entity.localised_name = localised_name
        entity.localised_description = localised_desc
        
        local left = nil        
        local top = nil

        local box = entity.drawing_box
        if box == nil then box = entity.selection_box end
        if box == nil then box = entity.collision_box end
        if box ~= nil then
         left = (math.abs(box[1][1])*32)/2
         top = (math.abs(box[1][2])*32)/2
        end
        

        if is_nesw(entity) then
            if left == nil then left = entity.base_picture.north.layers[1].width/2 end
            if left == nil then top = entity.base_picture.north.layers[1].height/2 end
            table.insert(entity.base_picture.north.layers,get_badge(rank,top,left,entity.base_picture.north.layers[1].repeat_count or 1))

            if left == nil then left = entity.base_picture.east.layers[1].width/2 end
            if left == nil then top = entity.base_picture.east.layers[1].height/2 end
            table.insert(entity.base_picture.east.layers,get_badge(rank,top,left,entity.base_picture.north.layers[1].repeat_count or 1))

            if left == nil then left = entity.base_picture.south.layers[1].width/2 end
            if left == nil then top = entity.base_picture.south.layers[1].height/2 end
            table.insert(entity.base_picture.south.layers,get_badge(rank,top,left,entity.base_picture.north.layers[1].repeat_count or 1))

            if left == nil then left = entity.base_picture.west.layers[1].width/2 end
            if left == nil then top = entity.base_picture.west.layers[1].height/2 end
            table.insert(entity.base_picture.west.layers,get_badge(rank,top,left,entity.base_picture.north.layers[1].repeat_count or 1))
        else
            if left == nil then left = entity.base_picture.layers[1].width/2 end
            if left == nil then top = entity.base_picture.layers[1].height/2 end
            
            table.insert(entity.base_picture.layers,get_badge(rank,top,left,entity.base_picture.layers[1].repeat_count or 1))
        end
        if turret.entity.fast_replaceable_group == nil then
            turret.entity.fast_replaceable_group = name
            entity.fast_replaceable_group = name
            if turret.entity.next_upgrade == nil then turret.entity.next_upgrade = name end
        else
            if turret.entity.next_upgrade == nil then turret.entity.next_upgrade = name end
        end
        
        if entity.type == "ammo-turret" then update_ammo_turret_tech(turret.entity, name, rank) end
        if entity.type == "fluid-turret" then update_fluid_turret_tech(turret.entity, name, rank) end
        if settings.startup["heroturrets-kill-counter"].value == "Exact" then        
            entity.minable.result = name_with_tags
            data:extend({item_with_tags,item,recipe,entity})
        else
        entity.minable.result = name
            data:extend({item,recipe,entity})
        end
   end

local local_create_turrets = function()
    local turret_types = {"ammo-turret", "fluid-turret","electric-turret", "artillery-turret", "artillery-wagon"}
    local guns = {}
    for at = 1, #turret_types do local tt = turret_types[at]
        for name, entity in pairs(data.raw[tt]) do	
            if entity ~= nil and entity.name ~= nil                    
				    and starts_with(entity.name,"creative-mod") == false
				    and entity.subgroup~="enemies" 
                    and (is_nesw(entity) or (entity.base_picture ~= nil and entity.base_picture.layers ~= nil))
                    and entity.max_health > 1 
                    and entity.minable ~= nil and entity.minable.result ~= nil then
                    
                    local recipe = data.raw["recipe"][entity.name]
                    local item = local_get_item(entity.name)
                    
                    if recipe == nil then log(entity.name.." nil recipe") end
                    if item == nil then log(entity.name.." nil item") end

                    if recipe ~= nil and item ~= nil then
                       table.insert(guns,
                        {
                            item = item,
                            entity = entity,
                            recipe = recipe
					    }
                        )
                    end
            end
        end
    end

    local percent = 1 + (settings.startup["heroturrets-setting-level-buff-modifier"].value/100)
    for k = 1, #guns do local item = guns[k]
        if settings.startup["heroturrets-kill-counter"].value == "Exact" then     
            local_create_turret_with_tags(item)
        end
        local_create_turret(item,1,"Private 1st Class",1.125*percent)
        local_create_turret(item,2,"Corporal",1.25*percent)
        local_create_turret(item,3,"Sergeant",1.375*percent)
        local_create_turret(item,4,"General",1.5*percent)
    end

    end

if data ~= nil and data_final_fixes == true then
   local_create_turrets()

end