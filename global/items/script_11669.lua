-- Vibrating Hammer of Infuse
function event_item_click(e)
    local item_id = e.self:GetID();
    if (item_id == 11669) then
        e.owner:NukeItem(11669); -- Vibrating Hammer of Infuse
        e.owner:SummonItem(11668); -- Vibrating Gauntlets of Infuse
    end
end