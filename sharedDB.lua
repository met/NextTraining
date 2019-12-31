--[[
Copyright (c) 2019 Martin Hassman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local addonName, NS = ...;

-- Trainer window is opened, scan all items and put into DB
function NS.saveNewItemsToDB(db)
	assert(db, "saveNewItemsToDB - db is nil");

	local nServices = GetNumTrainerServices();

	for i = 1, nServices do

		local skillName = GetTrainerServiceSkillLine(i); -- easy way to get name of current skill (work only for lines with training, is nil for headers)
		local itemName, itemRank, itemCategory = GetTrainerServiceInfo(i);

		-- category is sometimes nil, probably when data are still not fully loaded yet, we should ignore such cases
		-- and we ignore header lines
		if skillName ~= nil and itemCategory ~= nil and itemCategory ~= "header" then

			local levelReq = GetTrainerServiceLevelReq(i);
			local reqSkillName, reqSkillLevel, hasReq = GetTrainerServiceSkillReq(i); -- "Leatherworking", 20, true
			local itemCost = GetTrainerServiceCost(i);
			local itemIcon = GetTrainerServiceIcon(i);

			--print(db, skillName, itemName, levelReq, reqSkillName, reqSkillLevel, itemCost, itemIcon);

			if reqSkillName == nil then
				reqSkillName = "";
			end

			-- add item if not exist yet in DB
			NS.addNewDBItem(db, skillName, itemName, levelReq, reqSkillName, reqSkillLevel, itemCost, itemIcon);

		end
	end
end


function NS.addNewDBItem(db, skillName, itemName, levelReq, reqSkillName, reqSkillLevel, itemCost, itemIcon)
	assert(db, "addNewDBItem - db is nil");
	assert(skillName, "addNewDBItem - skillName is nil");
	assert(itemName, "addNewDBItem - itemName is nil");
	assert(levelReq, "addNewDBItem - levelReq is nil");
	assert(reqSkillName, "addNewDBItem - reqSkillName is nil");
	assert(reqSkillLevel, "addNewDBItem - reqSkillLevel is nil");
	assert(itemCost, "addNewDBItem - itemCost is nil");
	assert(itemIcon, "addNewDBItem - itemIcon is nil");	


	if db[skillName] == nil then
		db[skillName] = {};
	end

	-- item is not in DB yet
	if db[skillName][itemName] == nil then
		db[skillName][itemName] = {
			["levelReq"] = levelReq,
			["reqSkillName"] = reqSkillName,
			["reqSkillLevel"] = reqSkillLevel,
			["cost"] = itemCost,
			["icon"] = itemIcon
		};


		print("Added "..itemName.." to DB.");
	end
end


function NS.dbStats(db)
	assert(db, "dbStats - db is nil");
	local output = {};

	for k,v in pairs(db) do
		local n = 0;
		for k1,v1 in pairs(v) do
			n = n+1;
		end
		output[k] = n;
	end

	return output;
end