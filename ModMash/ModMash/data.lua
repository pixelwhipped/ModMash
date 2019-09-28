﻿require("prototypes.scripts.util")

require("prototypes.categories.discharge-fluids")
require("prototypes.categories.item-groups")
require("prototypes.categories.recycling-category")
require("prototypes.categories.wind-trap")

require("prototypes.item.blank-circuit")
require("prototypes.item.fluid")
require("prototypes.item.resources")
require("prototypes.item.spawner")
require("prototypes.item.assembling-machine-4")
require("prototypes.item.assembling-machine-5")
require("prototypes.item.wind-trap")
require("prototypes.item.discharge-pump")
require("prototypes.item.recycling-machine")
require("prototypes.item.ammo")
require("prototypes.item.regenerative-wall")
require("prototypes.item.titanium-wall")
require("prototypes.item.pipes")
require("prototypes.item.juice")
require("prototypes.item.droid")
require("prototypes.item.steam-engine-mk2")
require("prototypes.item.super-material")

require("prototypes.recipe.enrichment")
require("prototypes.recipe.assembling-machine-4")
require("prototypes.recipe.assembling-machine-5")
require("prototypes.recipe.wind-trap")
require("prototypes.recipe.discharge-pump")
require("prototypes.recipe.recycling-machine")
require("prototypes.recipe.ammo")
require("prototypes.recipe.regenerative-wall")
require("prototypes.recipe.titanium-wall")
require("prototypes.recipe.pipes")
require("prototypes.recipe.fluids")
require("prototypes.recipe.juice")
require("prototypes.recipe.droid")
require("prototypes.recipe.steam-engine-mk2")

require("prototypes.technology.regenerative")
require("prototypes.technology.logistics")
require("prototypes.entity.logistics")
require("prototypes.entity.valves")
require("prototypes.entity.assembling-machine-4")
require("prototypes.entity.assembling-machine-5")
require("prototypes.entity.wind-trap")
require("prototypes.entity.discharge-pump")
require("prototypes.entity.recycling-machine")
require("prototypes.entity.regenerative-wall")
require("prototypes.entity.titanium-wall")
require("prototypes.entity.pipes")
require("prototypes.entity.droid")
require("prototypes.entity.biter-neuro-toxin")
require("prototypes.entity.steam-engine-mk2")

require("prototypes.technology.enrichment")
require("prototypes.technology.inserters")
require("prototypes.technology.valves")
require("prototypes.technology.assembling-machine-4")
require("prototypes.technology.assembling-machine-5")
require("prototypes.technology.wind-trap")
require("prototypes.technology.discharge-pump")
require("prototypes.technology.recycling-machine")
require("prototypes.technology.ammo")
require("prototypes.technology.regenerative-wall")
require("prototypes.technology.titanium-wall")
require("prototypes.technology.pipes")
require("prototypes.technology.droid")

data:extend({
  {
    type = "custom-input",
    name = "automate-target",
    key_sequence = settings.startup["modmash-setting-adjust-binding"].value,
    consuming = "script-only"
  },
})
