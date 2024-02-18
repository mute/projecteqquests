function event_enter_zone(e)
	eq.debug("Entered zone");
	if not e.self:IsTaskActive(6) and not e.self:IsTaskCompleted(6) then
		e.self:AssignTask(6);
	end
end

function event_death(e)
	if(e.self:HasItem(9816)) then

		e.self:NukeItem(9816); --nuke sealed silver package if you die

	end

end
