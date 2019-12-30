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

local cYellow = "\124cFFFFFF00";
local cWhite = "\124cFFFFFFFF";
local cRed = "\124cFFFF0000";
local cLightBlue = "\124cFFadd8e6";
local cGreen1 = "\124cFF38FFBE";


local frame = CreateFrame("FRAME");
local events = {};

function events.ADDON_LOADED(...)
	if NextTrainingSharedData == nil then
		NextTrainingSharedData = {};
	end

	if NextTrainingSharedDB == nil then
		NextTrainingSharedDB = {};
	end

	if NextTrainingSettings == nil then
		NextTrainingSettings = {};
	end

	if NextTrainingData == nil then
		NextTrainingData = {};
	end
end

function events.TRAINER_UPDATE(...)
	local nServices = GetNumTrainerServices();

	-- TRAINER_UPDATE event is raised several times when window opens,
	-- but only the last is content loaded (GetNumTrainerServices > 0)
	-- so we ignore the premature events calls
	if nServices == 0 then
		return;
	end

	-- IsTradeskillTrainer == true for profession trainer, false for class trainer
	if IsTradeskillTrainer() == false then
		return;
	end

	--print(cYellow.."GetTrainerServiceInfo");
	NS.saveNewItemsToDB(NextTrainingSharedDB);

	for i = 1, nServices do
		local itemName, itemRank, itemCategory = GetTrainerServiceInfo(i);
		local skillName = GetTrainerServiceSkillLine(i); -- easy way to get name of current skill (work only for lines with training, is nil for headers)

		-- rank empty string usually, or level of spell (eg Shadow Bolt rank 2)
		-- category = nil, "unavailable", "available" "used", "header"

		-- sometimes is category nil, probably when data are still not fully loaded yet
		if skillName ~= nil and itemCategory == "unavailable" then
			local levelReq = GetTrainerServiceLevelReq(i);
			local reqSkillName, reqSkillLevel, hasReq = GetTrainerServiceSkillReq(i); -- "Leatherworking", 20, true

			-- we should check if player has this profession
			-- if not, ignore it

			print(i, GetTrainerServiceInfo(i));

			if hasReq == true then
				print(cYellow.."Skill name", skillName);
				print("Next item:", itemName);
				print("Level req:", levelReq);
				print("Skill req:", reqSkillName, reqSkillLevel);

				if NextTrainingData == nil then
					NextTrainingData = {};
				end

				if NextTrainingData[skillName] == nil then
					NextTrainingData[skillName] = {}
				end

				if NextTrainingData[skillName][itemName] == nil then
					NextTrainingData[skillName][itemName] = {};
				end

				break; -- we look only for first unavailable skill
			end
		end
	end

end



function frame:OnEvent(event, arg1, ...)

	if event == "ADDON_LOADED" then
		if arg1 == addonName then
			events.ADDON_LOADED(arg1, ...)
		end
	elseif event == "TRAINER_UPDATE" then
		events.TRAINER_UPDATE();
	else
		print(cRed.."ERROR. Received unhandled event.");
		print(event, arg1, ...);
	end

end


frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("TRAINER_UPDATE");


frame:SetScript("OnEvent", frame.OnEvent);