function event_enter_zone(e)
	if not e.self:IsTaskActive(12) and not e.self:IsTaskCompleted(12) then
		e.self:AssignTask(12);
	end
end
