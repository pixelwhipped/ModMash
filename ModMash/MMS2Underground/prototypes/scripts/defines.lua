if not mms2underground then mms2underground = {} end
if not mms2underground.defines then mms2underground.defines = {} end
if not mms2underground.defines.names then mms2underground.defines.names = {} end

if mms2underground.util == nil then
	if remote ~= nil then
		require '__mms2common__/prototypes/scripts/util'
		mms2underground.util = get_mms2lib()		
	else 
		mms2underground.util = get_mms2lib()
	end
end

mms2underground.defines.names.level_one_rock_prefix = "underground-rock-"
mms2underground.defines.names.dirt_prefix = "underground-dark-"
mms2underground.defines.names.level_one_attack_rock = "underground-attack-rock"

mms2underground.defines.names.rock_names = {
  "rock-huge",
  "rock-big",
  "sand-rock-big"
}
