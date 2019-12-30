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

-- Thanks to: https://stackoverflow.com/a/15706820/44096
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- Usage: /trains Fishing
-- show all saved item from DB
SLASH_TRAINS1 = "/trains";
SlashCmdList["TRAINS"] = function(msg)

	assert(NextTrainingSharedDB, "NextTrainingSharedDB is nil");

	if msg == "" then
		print(cYellow.."Usage "..SLASH_TRAINS1.." Mining");
		return;
	end

	if NextTrainingSharedDB[msg] == nil then
		print(cRed.."Do not know skill "..msg);
		return;
	end

	print(cYellow..msg..":");
	for k,v in spairs(NextTrainingSharedDB[msg], function (t,a,b) return (t[a].reqSkillLevel < t[b].reqSkillLevel); end) do

		if v.levelReq == 0 then
			print(cLightBlue..k..cWhite.." sk:"..v.reqSkillLevel.." c: "..v.cost);
		else
			print(cLightBlue..k..cWhite.." sk:"..v.reqSkillLevel.." l:"..v.levelReq.." c:"..v.cost);
		end
	end
end