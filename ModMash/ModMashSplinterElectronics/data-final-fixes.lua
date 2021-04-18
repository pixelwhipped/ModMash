data_final_fixes = true
require ("prototypes.scripts.defines")

local local_update_recipe = function(name, standard, normal, expensive)
	if data.raw.recipe[name] == nil then return end
	if standard ~= nil then
		data.raw.recipe[name].ingredients = standard		
	end
	if normal ~= nil then
		if data.raw.recipe[name].normal == nil then data.raw.recipe[name].normal = 
		{
			result = name
		} end
		data.raw.recipe[name].normal.ingredients = normal
	end
	if expensive ~= nil then
		if data.raw.recipe[name].expensive == nil then data.raw.recipe[name].expensive = 
		{
			result = name
		} end
		data.raw.recipe[name].expensive.ingredients = expensive
	end
end

local local_update_recipies = function()
	local_update_recipe("red-wire",{      
		  {name = "copper-cable", amount= 1}
		},nil,nil)
	if data.raw.recipe["red-wire"] ~= nil then data.raw.recipe["red-wire"].result_count = 2 end
	local_update_recipe("green-wire",
		{      
		  {name = "copper-cable", amount = 1}
		},nil,nil)
	if data.raw.recipe["green-wire"] ~= nil then data.raw.recipe["green-wire"].result_count = 2 end
	local_update_recipe("electronic-circuit",nil,
		{      
		  {name = "green-wire",  amount= 1},
		  {name = "blank-circuit",amount= 1}
		},
		{      
		  {name = "green-wire", amount=2},
		  {name = "blank-circuit", amount=2}
		})
	
	local_update_recipe("advanced-circuit",nil,
		{      
		  {name = "blank-circuit", amount=1},
		  {name = "electronic-circuit", amount=1},
		  {name = "plastic-bar", amount=1},
		  {name = "red-wire", amount=1},
		},
		{      
		  {name = "blank-circuit", amount=2},
		  {name = "electronic-circuit", amount=1},
		  {name = "plastic-bar", amount=2},
		  {name = "red-wire", amount=2},
		})

	if data.raw.recipe["processing-unit"].category == "crafting-with-fluid" then
		local_update_recipe("processing-unit",nil,
		{      
		   {name = "blank-circuit", amount=5},
		  {name = "red-wire", amount=1},
		  {name = "green-wire", amount=1},
		  {name = "copper-cable",amount= 1},
		  {type = "fluid", name = "sulfuric-acid",amount=5}
		},
		{      
		  {name = "blank-circuit",amount= 5},
		  {name = "red-wire", amount=2},
		  {name = "green-wire",amount= 2},
		  {name = "copper-cable",amount= 2},
		  {type = "fluid", name = "sulfuric-acid", amount = 10}
		})
	else
		local_update_recipe("processing-circuit",nil,
		{      
		   {name = "blank-circuit", amount=5},
		  {name = "red-wire", amount=1},
		  {name = "green-wire", amount=1},
		  {name = "copper-cable", amount=1},
		},
		{      
		  {name = "blank-circuit", amount=5},
		  {name = "red-wire", amount=2},
		  {name = "green-wire", amount=2},
		  {name = "copper-cable", amount=2},
		})
	end
	local remove_recipie_from = function(tble,value)
		local new_table = {}
		if tble ~= nil then
			for i = 1, #tble do		
				if tble[i].recipe ~= value then 
					table.insert(new_table,tble[i])
				end
			end			
		end
		tble = new_table
		return tble
	end

	data.raw["technology"]["circuit-network"].effects = remove_recipie_from(data.raw["technology"]["circuit-network"].effects,"red-wire")
	data.raw["technology"]["circuit-network"].effects = remove_recipie_from(data.raw["technology"]["circuit-network"].effects,"green-wire")
	data.raw.recipe["red-wire"].enabled = true	
	data.raw.recipe["green-wire"].enabled = true	
	end

local_update_recipies()	

require("prototypes.scripts.types") 