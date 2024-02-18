function event_enter_zone(e)
	if not e.other:IsTaskActive(6) and not e.other:IsTaskCompleted(6) then
		e.other:AssignTask(6);
	end
end

function event_death(e)
	if(e.self:HasItem(9816)) then

		e.self:NukeItem(9816); --nuke sealed silver package if you die

	end

end
