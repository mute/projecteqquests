function event_spawn(e)
    eq.set_timer("spar2", 9000);
end

function event_timer(e)
    if(e.timer == "spar2") then
            e.self:DoAnim(93);
    end
end