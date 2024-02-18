function event_enter_zone(e)
	if not e.self:IsTaskActive(9) and not e.self:IsTaskCompleted(9) then
		e.self:AssignTask(9);
	end
end
