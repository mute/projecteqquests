-- Granus of Vegarlson encounter script

function event_spawn(e)
    eq.set_next_hp_event(60)
end

-- Totem locations
local totem_id = 3061;
local totem_locs = {
    [1] = {-492, 50, 41},
    [2] = {-510, 72, 41},
    [3] = {-535, 53, 41}
}

function event_hp(e)
    if (e.hp_event == 60) then
        e.self:Say("The earth surrounds me. I will not cave so easily.");
        e.self:Emote(" hardens as earthen totems rise from the ground.")
        for i = 1, 3 do
            eq.spawn2(totem_id, 0, 0, totem_locs[i][0], totem_locs[i][1], totem_locs[i][2], 0);
        end
        eq.set_next_hp_event(10);
    elseif (e.hp_event == 10) then
        e.self:Say("Well done, young one. This is only just the beginning.");
    end
end