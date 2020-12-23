if not modmashsplinterdefense then modmashsplinterdefense = {} end
if not modmashsplinterdefense.defines then modmashsplinterdefense.defines = {} end
if not modmashsplinterdefense.defines.names then modmashsplinterdefense.defines.names = {} end
if not modmashsplinterdefense.defines.defaults then modmashsplinterdefense.defines.defaults = {} end

if modmashsplinterdefense.util == nil then
	if remote ~= nil then
		require '__modmashsplinter__/prototypes/scripts/util'
		modmashsplinterdefense.util = get_modmashsplinterlib()
	else 
		modmashsplinterdefense.util = get_modmashsplinterlib()
	end
end

modmashsplinterdefense.defines.names.biter_neuro_toxin_cloud = "biter-neuro-toxin-cloud"

modmashsplinterdefense.defines.defaults.biter_nero_toxin_research_modifier = 26
modmashsplinterdefense.defines.defaults.biter_nero_toxin_research_modifier_increment = 1.1
modmashsplinterdefense.defines.defaults.alerts_per_tick = 25