function event_enter_zone(e)
	if not e.self:IsTaskActive(11) and not e.self:IsTaskCompleted(11) then
		e.self:AssignTask(11);
	end
end
