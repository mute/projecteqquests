function event_enter_zone(e)
	if not e.self:IsTaskActive(10) and not e.self:IsTaskCompleted(10) then
		e.self:AssignTask(10);
	end
end
