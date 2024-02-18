function event_enter_zone(e)
	if not e.self:IsTaskActive(8) and not e.self:IsTaskCompleted(8) then
		e.self:AssignTask(8);
	end
end
