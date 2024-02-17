function event_spawn(e)
    eq.set_timer("spar2", 5000);
    e.self:AddNimbusEffect(456);
end

function event_timer(e)
    if(e.timer == "spar2") then
            e.self:DoAnim(39);
    end
end