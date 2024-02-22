my $expedition_name = "Icewell Keep";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "thurgadinb";
my $dz_version      = 0;
my $dz_duration     = 79200; # 22 hours

sub EVENT_SAY {
  if ($text =~ /hail/i) {
    my $dz = $client->GetExpedition();
    if ($dz && $dz->GetName() eq $expedition_name) {
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
    else {
      quest::say("Would you like to [" . quest::saylink("request") . "] the expedition?");
    }
  }
  elsif ($text =~ /request/i) {
    my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
    if ($dz) {
      $dz->SetCompass("thurgadinb", -8, 166, 3); # AOR inside icewell on right
      $dz->SetSafeReturn("thurgadina", 4, 179, 2, 258); # safe inside thurgadin near icewell
      $dz->SetZoneInLocation(4, 128, 2, 0); # safe zoneline to thurga inside thurgb
      $dz->AddReplayLockout(79200); # immediately add a 22 hour replay lockout on creation
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
  elsif ($text =~ /ready/i) {
    $client->MovePCDynamicZone("thurgadinb");
  }
}