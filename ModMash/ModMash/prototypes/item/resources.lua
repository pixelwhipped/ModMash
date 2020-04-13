if not modmash then modmash = {} end
if not modmash.defines then require ("prototypes.scripts.defines") end
--[[Code check 29.2.20
removed old comments
--]]
data:extend(
{
  {
    type = "item",
    name = modmash.defines.names.titanium_ore_name,
    icon = "__modmashgraphics__/graphics/icons/titanium-ore.png",
    icon_size = 32,    
    subgroup = "raw-resource",
    order = "g[titanium-ore]",
    stack_size = 75
  },
  {
    type = "item",
    name = "alien-ore",
    icon = "__modmashgraphics__/graphics/icons/alien-ore.png",
    icon_size = 32,    
    subgroup = "raw-resource",
    order = "h[alien-ore]",
    stack_size = 75
  },
  {
    type = "item",
    name = "titanium-plate",
    icon = "__modmashgraphics__/graphics/icons/titanium-plate.png",
    icon_size = 32,   
    subgroup = "raw-material",
    order = "d[titanium-plate]",
    stack_size = 75
  },
  {
    type = "item",
    name = "alien-plate",
    icon = "__modmashgraphics__/graphics/icons/alien-plate.png",
    icon_size = 32,    
    subgroup = "raw-material",
    order = "d[alien-plate]",
    stack_size = 75
  },{
    type = "item",
    name = "alien-artifact",
    icon = "__modmashgraphics__/graphics/icons/alien-artifact.png",
    icon_size = 32,    
    subgroup = "raw-resource",
    order = "z",
    stack_size = 10
  },
})