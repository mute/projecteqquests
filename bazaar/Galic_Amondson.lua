-- Removed turn in functions
function event_say(e)
	if(e.message:findi("hail")) then
		e.self:Say("Greetings " .. e.other:GetName() .. ". Aren't horses amazing creatures? I used to dream of riding across Dawnshroud, but I simply can't afford one. I bet you'll be able to one day though! Good luck to you hero!");
	end
end

-------------------------------------------------------------------------------------------------
-- Too much plat available.
-------------------------------------------------------------------------------------------------
