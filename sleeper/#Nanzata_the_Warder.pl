sub EVENT_DEATH_COMPLETE {
    if (plugin::subflag_exists($npc->GetCleanName())) {
        my $flag_mob = quest::spawn2(26000, 0, 0, $x, $y, ($z + 10), 0); # Spawn a flag mob
        my $new_npc = $entity_list->GetNPCByID($flag_mob);
        
        $new_npc->SetBucket("Flag-Name", $npc->GetCleanName(), "1200s");
        $new_npc->SetBucket("Stage-Name", plugin::get_subflag_stage($npc->GetCleanName()), "1200s");
    }
}

sub EVENT_KILLED_MERIT {
    if (plugin::subflag_exists($npc->GetCleanName())) {
        plugin::set_subflag($client, plugin::get_subflag_stage($npc->GetCleanName()), $npc->GetCleanName());
    }
}