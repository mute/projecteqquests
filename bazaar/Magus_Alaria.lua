-- Old guildlobby\Magus_Alaria.lua NPCID 344013

function event_say(e)
	--Adventurers Stone Requirement Removed
		if(e.message:findi("hail")) then
			e.self:Say("Greetings, " .. e.other:GetName() .. ". As you may have guessed I used to be a member of the Wayfarers Brotherhood. While the dungeons we once sought are lost again, I know that I am meant to assist those that still need our magic. As I understand it, the Gates of Discord have been opened again... I think I still know how to get your kind to [" .. eq.say_link("Nedaria's Landing",false,"Nedaria's Landing") .. "]. Prepare yourself. From what I can still remember, it will not be a pleasant journey.");
		elseif(e.message:findi("nedaria")) then
			e.other:MovePC(182,1463,1053,82.86,136); -- Zone: nedaria
		end
end
