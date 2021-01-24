local local_add_item = function(item)
    if data.raw["item"][item.name] ~= nil then return end
    data:extend({item})    
end

local_add_item(
    {
		type = "item",
		name = "assembling-machine-burner",
		icon = "__modmashsplinterassembling__/graphics/icons/assembling-machine-0.png",
		icon_size = 64,
        icon_mipmaps = 4,   
		subgroup = "production-machine",
		order = "a[assembling-machine-0]",
		place_result = "assembling-machine-burner",
		stack_size = 50
    })

if settings.startup["setting-assembling-machine-burner-only"].value == "No" then
    local_add_item(
        {
            type = "item",
            name = "assembling-machine-4",
            icon = "__modmashsplinterassembling__/graphics/icons/assembling-machine-4.png",
		    icon_size = 64,
            icon_mipmaps = 4,   
	        subgroup = "production-machine",
            order = "c[assembling-machine-4]",
            place_result = "assembling-machine-4",
            stack_size = 50
        })

    local_add_item(
        {
            type = "item",
            name = "assembling-machine-5",
            icon = "__modmashsplinterassembling__/graphics/icons/assembling-machine-5.png",
		    icon_size = 64,
            icon_mipmaps = 4,   
            subgroup = "production-machine",
            order = "c[assembling-machine-5]",
            place_result = "assembling-machine-5",
            stack_size = 50
        })
end