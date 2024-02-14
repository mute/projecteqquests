-- abysmal\Magus_Pellen.lua NPCID 279217

function event_say(e)
	if e.message:findi("hail") then
		e.self:Say("I can provide you with travel to [" .. eq.say_link("Natimbi",false,"Natimbi") .. "] and [" .. eq.say_link("Nedaria",false,"Nedaria") .. "]'s Landing with our Farstone magic.  Just tell me where you'd like to go and I shall send you.");
	elseif (e.message:findi("natimbi") and eq.get_data("god-open")) then
        local saryrn_flag = eq.get_data(e.other:AccountID() .. "-saryrn-flag")
        local kunark_flag = eq.get_data(e.other:AccountID() .. "-kunark-flag")
    
        if (tonumber(saryrn_flag or "0") > 0 or tonumber(kunark_flag or "0") >= 20) then
            e.other:MovePC(280, -1557, -853, 241, 180); -- Zone: natimbi
        end
	elseif e.message:findi("nedaria") then
		e.self:CastSpell(4580,e.other:GetID(),0,1); -- Spell: Teleport: Nedaria
	end
end

function event_trade(e)
	local item_lib = require("items");
	item_lib.return_items(e.self, e.other, e.trade);
end
