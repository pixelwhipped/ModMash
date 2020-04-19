modmash_wiki = 
{
	name = "modmash",
	title    = "ModMash",		
	mod_path =  "__modmash__",		
	{
		name = {"gui.modmash-wiki-topic-main"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-main-title"} },
			{type = "line"},
			{				
				type = "image", 
				name = "mm-topic-main-img-1",
				filepath = "__modmashgraphics__/graphics/wiki/thumbnail.png",
				width = 144,
				height = 144,
				scale = 1
			},
			{type = "line"},
			{type = "text", text = {"gui.modmash-wiki-topic-main-text"}},
		}
	},{
		name = {"gui.modmash-wiki-topic-underground"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-underground-title"} },
			{type = "line"},
			{type = "text", text = {"gui.modmash-wiki-topic-underground-text1"} },
			{				
				type = "image", 
				name = "mm-topic-underground-img-1",
				filepath = "__modmashgraphics__/graphics/wiki/underground.png",
				width = 350,
				height = 196,
				scale = 1
			},
			{type = "text", text = {"gui.modmash-wiki-topic-underground-text2"}},
			{type = "text", text = {"gui.modmash-wiki-topic-underground-text3"}},
			{				
				type = "image", 
				name = "mm-topic-underground-img-2",
				filepath = "__modmashgraphics__/graphics/wiki/underground2.png",
				width = 350,
				height = 196,
				scale = 1
			},
		}
	},{
		name = {"gui.modmash-wiki-topic-valkyrie"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-valkyrie-title"} },
			{type = "line"},
			{type = "text", text = {"gui.modmash-wiki-topic-valkyrie-text1"} },
			{type = "text", text = {"gui.modmash-wiki-topic-valkyrie-text2"}},
			{				
				type = "image", 
				name = "mm-topic-valkyries-img",
				filepath = "__modmashgraphics__/graphics/wiki/valkyries.png",
				width = 350,
				height = 196,
				scale = 1
			},
		}
	},{
		name = {"gui.modmash-wiki-topic-inserters"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-inserters-title"} },
			{type = "line"},			
			{type = "text", text = {"gui.modmash-wiki-topic-inserters-text1"}},
			{type = "text", text = settings.startup["modmash-setting-adjust-binding"].value},
			{type = "text", text = {"gui.modmash-wiki-topic-inserters-text2"}},
			--{type = "custom", interface = "modmash", func = "test"},
			
		}
	},{
		name = {"gui.modmash-wiki-topic-alien-ore"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-alien-ore-title"} },
			{type = "line"},
			{type = "text", text = {"gui.modmash-wiki-topic-alien-ore-text1"} },
			{				
				type = "image", 
				name = "mm-topic-underground-img-1",
				filepath = "__modmashgraphics__/graphics/wiki/alien-ore.png",
				width = 350,
				height = 196,
				scale = 1
			},
			{type = "text", text = {"gui.modmash-wiki-topic-alien-ore-text2"}},
		}
	},{
		name = {"gui.modmash-wiki-topic-loot"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-loot-title"} },
			{type = "line"},
			{type = "text", text = {"gui.modmash-wiki-topic-loot-text1"} },
			{				
				type = "image", 
				name = "mm-topic-loot-img",
				filepath = "__modmashgraphics__/graphics/wiki/loot.png",
				width = 350,
				height = 196,
				scale = 1
			},
		}
	},{
		name = {"gui.modmash-wiki-topic-assemblers"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-assemblers-title"} },
			{type = "line"},			
			{				
				type = "image", 
				name = "mm-topic-assemblers-img",
				filepath = "__modmashgraphics__/graphics/wiki/assemblers.png",
				width = 350,
				height = 84,
				scale = 1
			},
			{type = "text", text = {"gui.modmash-wiki-topic-assemblers-text1"} },
			{type = "text", text = {"gui.modmash-wiki-topic-assemblers-text2"} },
		}
	},{
		name = {"gui.modmash-wiki-topic-toxins"},
		topic = {
			{type = "title", title = {"gui.modmash-wiki-topic-toxins-title"} },
			{type = "line"},	
			{type = "text", text = {"gui.modmash-wiki-topic-toxins-text1"} },
			{				
				type = "image", 
				name = "mm-topic-toxins-img",
				filepath = "__modmashgraphics__/graphics/wiki/toxins.png",
				width = 350,
				height = 196,
				scale = 1
			}
		}
	}
}