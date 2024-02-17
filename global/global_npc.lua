function event_spawn(e)
        if (e.self:IsPet() and e.self:GetOwner():IsClient()) then
                if (e.self:GetOwner():GetLevel() > 1) then
                        e.self:SetLevel(e.self:GetOwner():GetLevel() - 1);
                        e.self:ScaleNPC(e.self:GetOwner():GetLevel() - 1);
                        e.self:Heal();
                end
        end
end

function event_killed_merit(e)
        if (e.self:IsRareSpawn()) then
                local slain = e.self:GetNPCTypeID();
                local bucket_name = e.other:CharacterID() .. slain .. "-Slain";
                if (eq.get_data(bucket_name) == "") then
                        eq.set_data(bucket_name, "true");
                        e.other:AddAAPoints(e.self:GetLevel());
                        e.other:Ding();
                        e.other:Message(MT.Yellow, "You gain alternate advancement experience from slaying a rare enemy!");
                end
        end
end