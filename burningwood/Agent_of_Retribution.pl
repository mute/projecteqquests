my $expedition_name = "Chardok";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "chardok";
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
      $dz->SetCompass("burningwood", -4156, 7383, -232); # AOR at Chardok zone out
      $dz->SetSafeReturn("burningwood", -4156, 7383, -232, 186); # Chardok zone out
      $dz->SetZoneInLocation(935, -100, 104, 388); # safe zone in inside chardok
      $dz->AddReplayLockout(79200); # immediately add a 22 hour replay lockout on creation
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
  elsif ($text =~ /ready/i) {
    $client->MovePCDynamicZone("chardok");
  }
}