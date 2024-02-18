function event_say(e)
    if(e.message:findi("hail")) then
        if not e.other:IsTaskActive(5) and not e.other:IsTaskCompleted(5) then
            e.self:Say("TOAST DID NOT WRITE THE QUEST TEXT FOR THIS YET");
            e.other:AssignTask(5,e.self:GetID());
        end
    end
end