function event_enter_zone(e)
	if not e.self:IsTaskActive(7) and not e.self:IsTaskCompleted(7) then
		e.self:AssignTask(7);
	end
end
