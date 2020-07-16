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

function NS.updatePlayerSkillLevel(setts, skillName, skillLevel)
	assert(setts, "updatePlayerSkillLevel - setts is nill");
	assert(skillName, "updatePlayerSkillLevel - skillName is nill");
	assert(skillLevel, "updatePlayerSkillLevel - skillLevel is nill");
	assert(tonumber(skillLevel), "updatePlayerSkillLevel - skillLevel cannot be converted to number");

	if setts.skills == nil then
		setts.skills = {};
	end

	setts.skills[skillName] = tonumber(skillLevel);
end

-- get skill level that we know (if we saved it before) or nil
function NS.getPlayerSkillLevel(setts, skillName)
	assert(setts, "getPlayerSkillLevel - setts is nill");
	assert(skillName, "getPlayerSkillLevel - skillName is nill");

	if setts.skills == nil then	
		return nil;
	end

	if setts.skills[skillName] == nil then
		return nil;
	end

	local skillLevel = tonumber(setts.skills[skillName]);
	return skillLevel;
end
