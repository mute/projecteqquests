function event_enter_zone(e)
	if not e.self:IsTaskActive(15) and not e.self:IsTaskCompleted(15) then
		e.self:AssignTask(15);
	end
end
