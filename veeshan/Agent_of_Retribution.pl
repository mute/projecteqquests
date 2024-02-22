my $expedition_name = "Veeshan's Peak'";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "veeshan";
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
      $dz->SetCompass("veeshan", 1812, -11, 6); # AOR at the VP buff spot / safe spot
      $dz->SetSafeReturn("skyfire", -4286, -1140, 38, 128); # skyfire safe spot
      $dz->SetZoneInLocation(1678, 39, 29, 12); # zone in pad in VP
      $dz->AddReplayLockout(79200); # immediately add a 22 hour replay lockout on creation
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
  elsif ($text =~ /ready/i) {
    $client->MovePCDynamicZone("veeshan");
  }
}