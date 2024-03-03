sub EVENT_COMBAT {
    if ($combat_state == 1) {
        $npc->SetTimer("help", 5 * 60 * 1000);
        HelpMe($npc);
    } else {
        $npc->StopTimer("help");
    }
}

sub EVENT_TIMER {
    my $npc = $entity_list->GetMobByID($npcid); # Assuming $npcid is available
    if ($timer eq "help") {
        HelpMe($npc);
    }
}

sub HelpMe {
    my ($npc) = @_;
    my $npc_list = $entity_list->GetNPCByNPCTypeID(64092);

    foreach my $entity (@$npc_list) {
        if ($entity->IsNPC() && $entity->IsValid() && ($entity->GetNPCTypeID() == 64092)) {
            $entity->MoveTo($npc->GetX(), $npc->GetY(), $npc->GetZ(), 0, true);
        }
    }
}