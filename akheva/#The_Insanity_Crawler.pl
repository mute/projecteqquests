sub EVENT_SLAY {
    quest::spawn2(179136, 0, 0, $npc->GetX() - 10, $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    quest::spawn2(179136, 0, 0, $npc->GetX() + 10, $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    quest::spawn2(179136, 0, 0, $npc->GetX(), $npc->GetY() - 10, $npc->GetZ(), $npc->GetHeading());
    quest::spawn2(179136, 0, 0, $npc->GetX(), $npc->GetY() + 10, $npc->GetZ(), $npc->GetHeading());
    quest::spawn2(179136, 0, 0, $npc->GetX(), $npc->GetY() + 15, $npc->GetZ(), $npc->GetHeading());
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(202368, 0, 0, $npc->GetX() + 3, $npc->GetY() + 3, $npc->GetZ(), 0);
}

sub EVENT_KILLED_MERIT {
	plugin::set_subflag($client, 'SoL', $npc->GetCleanName());
}