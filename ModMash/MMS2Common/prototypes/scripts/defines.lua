if not mms2 then mms2 = {} end
if not mms2.defines then mms2.defines = {} end
if not mms2.entity then mms2.entity = {} end
if not mms2.defines.data_stages then mms2.defines.data_stages = {} end
if not mms2.defines.names then mms2.defines.names = {} end
if not mms2.defines.defaults then mms2.defines.defaults = {} end

--[[stages]]
mms2.defines.data_stages.data = "data"
mms2.defines.data_stages.data_final_fixes = "data-final-fixes"
mms2.defines.data_stages.data_updates = "data-updates"
mms2.defines.data_stages.control = "control"

--[[name]]
mms2.defines.names.force_player = "player"
mms2.defines.names.force_enemy = "enemy"
mms2.defines.names.force_neutral = "neutral"

mms2.defines.icon_pin_topleft = 0
mms2.defines.icon_pin_top = 1
mms2.defines.icon_pin_topright = 2
mms2.defines.icon_pin_right = 3
mms2.defines.icon_pin_bottomright = 4
mms2.defines.icon_pin_bottom = 5
mms2.defines.icon_pin_bottomleft = 6
mms2.defines.icon_pin_left = 7