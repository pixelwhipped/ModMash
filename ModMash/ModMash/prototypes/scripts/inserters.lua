--[[dsync checking Nothing to change]]
if data_updates == true then
	for i,inserter in pairs(data.raw["inserter"]) do
		inserter.allow_custom_vectors = true
	end
	end