function event_enter_zone(e)
	if not e.self:IsTaskActive(13) and not e.self:IsTaskCompleted(13) then
		e.self:AssignTask(13);
	end
end
