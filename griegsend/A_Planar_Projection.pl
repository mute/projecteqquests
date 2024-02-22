sub EVENT_SPAWN {
  quest::settimer(1, 1200);
}

sub EVENT_SAY {
  if ($text =~ /hail/i) {
    plugin::set_subflag($client, 'PoP', 'Greig Veneficus', 1);
  }
}

sub EVENT_TIMER {
  quest::depop();
}
