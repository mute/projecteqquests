sub EVENT_DEATH_COMPLETE {
    quest::spawn(12000078,0,0,$x,$y,($z+10));
}

sub EVENT_KILLED_MERIT {
	plugin::set_subflag($client, 'SoV', $npc->GetCleanName());
}