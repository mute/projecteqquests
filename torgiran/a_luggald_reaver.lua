function event_death_complete(e)
    if(e.self:GetSp2() == 29975 or e.self:GetSp2() == 29976 or e.self:GetSp2() == 29977 or e.self:GetSp2() == 29978) then --spawn groups inside the water spirit room
        eq.signal(226213,1); --signal An_ancient_spirit (226213) to add to wave counter
    end
    if(e.self:GetSp2() == 282505) then --spawn group inside the overlord room
        eq.signal(226204,1); --#overlord_trigger (226204) to add to wave counter
    end
end