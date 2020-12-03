require("prototypes.scripts.defines") 
if not global.modmashsplinterresources then global.modmashsplinterresources = {} end
local get_item = modmashsplinterresources.util.get_item

local local_register_resources = function()
	local titanium_ore_name = get_item("titanium-ore") 
	if titanium_ore_name == nil then titanium_ore_name = get_item("rutile-ore") end
	if titanium_ore_name ~= nil then titanium_ore_name = titanium_ore_name.name else titanium_ore_name = "titanium-ore" end


	if remote.interfaces["modmashsplinterunderground"] ~= nil and remote.interfaces["modmashsplinterloot"]["register_resource_level_one"] ~= nil then	
		remote.call("modmashsplinterunderground","register_resource_level_one",{name = "alien-ore", probability = 0.1})
		remote.call("modmashsplinterunderground","register_resource_level_one",{name = titanium_ore_name, probability = 0.1})
		remote.call("modmashsplinterunderground","register_resource_level_one",{name = "sand", probability = 0.1})
	end
	if remote.interfaces["modmashsplinterunderground"] ~= nil and remote.interfaces["modmashsplinterloot"]["register_resource_level_two"] ~= nil then	
		remote.call("modmashsplinterunderground","register_resource_level_two",{name = "alien-ore", probability = 0.4})
		remote.call("modmashsplinterunderground","register_resource_level_two",{name = titanium_ore_name, probability = 0.2})
		remote.call("modmashsplinterunderground","register_resource_level_two",{name = "sand", probability = 0.2})
		remote.call("modmashsplinterunderground","register_resource_level_two",{name = "sulfur", probability = 0.1})
	end
	resources_registered = true
end

local local_register_loot = function()	
	if loot_registered then return end
	if remote.interfaces["modmashsplinterloot"] ~= nil and remote.interfaces["modmashsplinterloot"]["register_loot"] ~= nil then
		local loot = {
			{
				name = "alien", probability = 0.1, 
				items = {
					{{name = "alien-artifact" ,max_stacks = 3, probability = 0.5}},
				}
			}
		}
		for k = 1, #loot do
			remote.call("modmashsplinterloot","register_loot",loot[k])
		end
	end
	loot_registered = true
end

local local_init = function() 
	local_register_resources()
	local_register_loot()
	end

local local_on_configuration_changed = function() 
	local_register_resources()
	local_register_loot()
	end

script.on_init(local_init)
script.on_configuration_changed(local_on_configuration_changed)