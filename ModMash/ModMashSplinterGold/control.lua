require("prototypes.scripts.defines") 

local local_on_configuration_changed = function(event) 	
	 local changed = event.mod_changes and event.mod_changes["modmashsplintergold"]
	 if changed then
		if changed.old_version == nil then
			for index, force in pairs(game.forces) do
			  force.reset_technology_effects()
			end
		end
	 end
end

script.on_configuration_changed(local_on_configuration_changed)
