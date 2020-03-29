demo_wiki = 
{
	name = "wiki",
	title    = "Factorio Wiki Mod",		
	mod_path =  "__wiki__",		
	{
		name = "Non Localized Name [img=item/iron-plate]",
		topic = {
			{type = "title", title = "Non Localized Title" },
			{				
				type = "image", 
				name = "topic-1-img",
				filepath = "__wiki__/graphics/gui/wiki.png",
				width = 128,
				height = 128,
				scale = 1
			},
			{type = "text", text = "Non Localized Text"},
			{type = "text", text = "[entity=radar]"}
		}
	},
	{
		name = "Non Localized Name",
		topic = {
			{type = "title", title = {"gui.wiki-demo-name"}},
			{
				type = "image", 
				name = "topic-2-img",
				filepath = "__wiki__/graphics/gui/wiki.png",
				width = 128,
				height = 128,
				scale = 1
			},
			{type = "line"},
			{type = "text", text = {"gui.wiki-demo-text"}}	

		}
	}
}