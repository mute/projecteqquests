sub EVENT_SPAWN {
  quest::settimer(1, 1200);

  quest::emote("rises from the corpse and stares around, as if waiting...");
}

sub EVENT_SAY {
  if ($text =~ /hail/i) {
    my $flag_stage = $npc->GetBucket("Stage-Name");
    my $flag_name  = $npc->GetBucket("Flag-Name");
    plugin::set_subflag($client, $flag_stage, $flag_name);
  }
}

sub EVENT_TIMER {
    quest::emote("vanishes.");
    quest::depop();
}