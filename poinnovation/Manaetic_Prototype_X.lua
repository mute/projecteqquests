function event_combat(e)
	if e.joined then
		eq.set_timer("banish",math.random(15,30) * 1000);
	else
		eq.stop_timer("banish");
	end
end

function event_timer(e)
	if e.timer == "banish" then
		local cur_target = e.self:GetHateTopClient()

		eq.stop_timer(e.timer);
		eq.set_timer("banish",math.random(15,30) * 1000);

		if cur_target.valid then
			cur_target:MovePC(206,269.5,-239.5,3.13,128);
		end
	end
end
