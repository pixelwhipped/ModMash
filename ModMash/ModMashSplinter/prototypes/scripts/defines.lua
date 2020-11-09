if not modmashsplinter then modmashsplinter = {} end
if not modmashsplinter.defines then modmashsplinter.defines = {} end
if not modmashsplinter.entity then modmashsplinter.entity = {} end
if not modmashsplinter.defines.data_stages then modmashsplinter.defines.data_stages = {} end
if not modmashsplinter.defines.names then modmashsplinter.defines.names = {} end
if not modmashsplinter.defines.defaults then modmashsplinter.defines.defaults = {} end

--[[stages]]
modmashsplinter.defines.data_stages.data = "data"
modmashsplinter.defines.data_stages.data_final_fixes = "data-final-fixes"
modmashsplinter.defines.data_stages.data_updates = "data-updates"
modmashsplinter.defines.data_stages.control = "control"

--[[name]]
modmashsplinter.defines.names.force_player = "player"
modmashsplinter.defines.names.force_enemy = "enemy"
modmashsplinter.defines.names.force_neutral = "neutral"

modmashsplinter.defines.healing_per_tick = 0.02