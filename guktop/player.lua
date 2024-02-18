function event_enter_zone(e)
	if not e.self:IsTaskActive(14) and not e.self:IsTaskCompleted(14) then
		e.self:AssignTask(14);
	end
end
