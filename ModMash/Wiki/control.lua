require("prototypes.scripts.defines") 
require("prototypes.scripts.util")
data_state = wiki.defines.data_stages.control

require("prototypes.scripts.gui")

script.on_event(defines.events.on_gui_click, wiki_on_gui_click)
script.on_event(defines.events.on_gui_selection_state_changed,wiki_on_gui_selection_state_changed)	
script.on_event(defines.events.on_runtime_mod_setting_changed,wiki_on_runtime_mod_setting_changed)

script.on_event(defines.events.on_player_created,wiki_initialize)	

script.on_configuration_changed(function(f) 	
	for i = 1, #game.players do
		wiki_initialize({player_index = i})
	end
	end)

remote.add_interface("wiki",{register_mod_wiki = wiki_register_mod_wiki})


--example use in control
--require("demo") 
--local initialize_wiki = function()
--	remote.call("wiki","register_mod_wiki",modmash_wiki)
--	end

--script.on_init(function() initialize_wiki() end)
--script.on_load(function() initialize_wiki() end)	
