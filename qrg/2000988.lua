-- Granus of Vegarlson encounter script

-- Totem locations
local totem_id = 3061;
local totem_locs = {
    [1] = {-492, 50, 41},
    [2] = {-510, 72, 41},
    [3] = {-535, 53, 41}
}

function Totem_Death()
    local entity_list = eq.get_entity_list();
    local granus = entity_list.GetMobNyNpcTypeID(2000988);
    if not entity_list:IsMobSpawnedByNpcTypeID(totem_id) then
        -- Stop the timer
        eq.stop_timer("totem_dead");

        -- Remove immunity
        granus:SetSpecialAbility(35, 0); --turn on immunity

        -- Attack normal speed again
        e.self:ModifyNPCStat("attack_delay", "3000");

        granus:Emote("'s earthen shell cracks and fractures.");
    end
end

function event_spawn(e)
    -- Granus is rooted and summons
    e.self:SetPseudoRoot(true);

    eq.set_next_hp_event(60);
end

function event_combat(e)
	-- On combat end, we need to reset by depopping totems and resetting hp events.
    if not e.joined then
        -- Set next_hp_event to 60 again
        eq.set_next_hp_event(60);

        -- Heal to 100
        e.self:Heal();

        -- Depop all of the totems
        local npc_list =  eq.get_entity_list():GetNPCList();
        for npc in npc_list.entries do
            if (npc:GetNPCTypeID() == totem_id) then
                npc:depop();
            end
        end
	end
end

function event_hp(e)
    if (e.hp_event == 60) then
        e.self:Say("The earth surrounds me. I will not cave so easily.");
        e.self:Emote(" hardens as earthen totems rise from the ground.");

        -- Spawn the totems
        for i = 1, 3 do
            eq.spawn2(totem_id, 0, 0, totem_locs[i][1], totem_locs[i][2], totem_locs[i][3], 0);
        end

        -- Go immune
        e.self:SetSpecialAbility(35, 1); --turn on immunity

        -- Attack very slowly
        e.self:ModifyNPCStat("attack_delay", "9000");

        -- Start a timer to check for the totems being dead
        eq.set_timer("totem_dead", 1000);

        eq.set_next_hp_event(10);
    elseif (e.hp_event == 10) then
        e.self:Say("Well done, young one. This is only just the beginning.");
    end
end

function event_timer(e)
    if (e.timer == "totem_dead") then
        Totem_Death();
    end
end