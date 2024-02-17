function event_spawn(e)
    eq.set_timer("spar2", 5000);
end

function event_timer(e)
    if(e.timer == "spar2") then
            e.self:DoAnim(14);
    end
end

function event_say(e)
    e.self:Emote("hiccups.");
    e.self:Say("Has anyone seen my ice cream?");
end