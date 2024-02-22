my $expedition_name = "TempleVeeshan";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "templeveeshan";
my $dz_version      = 0;
my $dz_duration     = 172800; # 48 hours

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
      $dz->SetCompass("templeveeshan", -499, -2122, -36); # 
      $dz->SetSafeReturn("templeveeshan", -499, -2122, -36, 511);
      $dz->SetZoneInLocation(-499, -2122, -36, 511); # Ent
      $dz->AddReplayLockout(79200); # immediately add a 22 hour replay lockout on creation
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
  elsif ($text =~ /ready/i) {
    $client->MovePCDynamicZone("templeveeshan");
  }
}