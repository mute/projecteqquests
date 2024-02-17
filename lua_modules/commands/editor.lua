local function editor(e)
    local target = e.self:GetTarget();

    if not target.null then
            local target_NPCID = target:GetNPCTypeID()
            local target_name = target:GetName()

            local address = "http://5.78.74.8:8081/index.php?editor=npc&npcid="..target_NPCID.."&action=1"
            local message = "Click to edit "..target_name

            e.self:Popup("NPC Editor", eq.popup_link(address, message))
    end
end

return editor;