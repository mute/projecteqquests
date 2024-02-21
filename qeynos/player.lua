function event_enter_zone(e)
	if not e.self:IsTaskActive(16) and not e.self:IsTaskCompleted(16) then
		e.self:AssignTask(16);
	end
end
