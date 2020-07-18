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

-- player's skill level has changed, save new value
function NS.updatePlayerSkillLevel(setts, skillName, skillLevel)
	assert(setts, "updatePlayerSkillLevel - setts is nil");
	assert(skillName, "updatePlayerSkillLevel - skillName is nil");
	assert(skillLevel, "updatePlayerSkillLevel - skillLevel is nil");
	assert(tonumber(skillLevel), "updatePlayerSkillLevel - not able to convert skillLevel to number");

	if setts.skills == nil then
		setts.skills = {};
	end

	setts.skills[skillName] = tonumber(skillLevel);
end

-- get skill level for given skill (or nil if we don't know it)
function NS.getPlayerSkillLevel(setts, skillName)
	assert(setts, "getPlayerSkillLevel - setts is nil");
	assert(skillName, "getPlayerSkillLevel - skillName is nil");

	if setts[skillName] == nil then
		return nil;
	end

	local skillLevel = tonumber(setts[skillName]);
	return skillLevel;
end

-- true if there is training available for player for given skill
function NS.isTrainingAvailableForSkill(settsNext, skillName, skillLevel, playerLevel)
	assert(settsNext, "isTrainingAvailableForSkill - settsNext is nil");
	assert(skillName, "isTrainingAvailableForSkill - skillName is nil");
	assert(skillLevel, "isTrainingAvailableForSkill - skillLevel is nil");
	assert(playerLevel, "isTrainingAvailableForSkill - playerLevel is nil");

	if settsNext[skillName] == nil or
	   settsNext[skillName][1] == nil or
	   settsNext[skillName][1].reqSkillLevel == nil then
		return false; -- we have not data yet, so we don't know about any training
	end

	local trainingAvailable = false;

	if settsNext[skillName][1].reqSkillLevel <= skillLevel then -- check required skill level
		if settsNext[skillName][1].reqLevel == nil then
			trainingAvailable = true;  -- there is not limit for player level
		else			
			if settsNext[skillName][1].reqLevel <= playerLevel then -- check player level if matters
				trainingAvailable = true;
			end
		end
	end

	return trainingAvailable;
end
