require ("prototypes.scripts.defines")

require("prototypes.technology.logistics")
require("prototypes.entity.logistics") 

if settings.startup["setting-adjust-inserter-pickup"].value == "Enabled" then
    data:extend({
      {
        type = "custom-input",
        name = "adjust-inserter-pickup",
        key_sequence = "CONTROL + R",
        consuming = "game-only"
      },
    })
end