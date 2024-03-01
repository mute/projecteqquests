# Add ports with cost to allow players to visit Hate and Sky- phrase is [nominal fee]

sub EVENT_SPAWN {
    $x = $npc->GetX();
    $y = $npc->GetY();
    $z = $npc->GetZ();

    quest::set_proximity($x - 20, $x + 20, $y - 20, $y + 20);
}

sub EVENT_SAY {
  my $continent_regex = join('|', map { my $continent = plugin::get_continent_by_suffix($_); $continent =~ s/\s+//g; quotemeta($continent) } plugin::get_suffixes());
  my $zone_data       = plugin::get_zone_data($client->AccountID());
  my $flat_data       = plugin::get_flat_data($client->AccountID());
  my $group_flg       = quest::get_data($client->AccountID() ."-group-ports-enabled");
  
  my $eom_available   = $client->GetAlternateCurrencyValue(6);

  my $cost            = 1000 * get_cost_for_level();

  if ($text=~/hail/i) { 
    quest::say("Greetings $name! Have you discovered any Rune Circles in your journeys? I can [transport you] or [your group] to any of those you or any of your lineage have attuned to. If you are looking to journey to The Plane of Hate or The Plane of Sky for the first time, I can get you there for a [nominal fee].");
  }

  elsif ($text=~/your group/i && !$group_flg) {
    quest::say("If you'd like for me to transport your group, I'll need a stronger connection to your memories. Bring me five
                [Echo of Memory], and I will let you transport your entire group any time you ask.");
    return; # Exit early.
  }

  elsif ($text=~/Echo of Memory/i && !$group_flg) {
    if ($eom_available >= 5) {
      quest::say("Simply [confirm] to me that you'd like to spend your Echoes in this way, and it will be done.");
    } else {
      quest::say("I'm sorry, but you don't have enough Echoes at the moment. Do you need to reclaim them under the alt currency tab? If not, ways to donate are listed on the server's Discord server.");
    }
  }

  elsif ($text=~/confirm/ && !$group_flg && $eom_available >= 5) {
    if (plugin::SpendEOM($client, 5)) {
        quest::set_data($client->AccountID() ."-group-ports-enabled",1);
        quest::say("Excellent! I can transport [your group], whenever you'd like.");
    }
  }

  elsif ($text=~/transport you/i || ($text=~/your group/i  && $group_flg)) {
    quest::say("Very good! Tell me about this place that you remember. This transportation will cost " . get_cost_for_level() . " platinum pieces.");
    $client->Message(257, " ------- Select a Continent ------- ");
    # Check for each suffix and add entries if valid zone data exists
    foreach my $suffix (plugin::get_suffixes()) {
        if (exists($zone_data->{$suffix}) && %{ $zone_data->{$suffix} }) {
            my $link_text = plugin::get_continent_by_suffix($suffix);
            my $mode_indicator = $text =~ /group/i ? ":group" : "";
            $client->Message(257, "-[ " . quest::saylink($link_text . $mode_indicator, 1, $link_text));
        }
    }
  }

  elsif ($text =~ /^(.+?)(:group)?$/) { # Capture the location and optional group indicator
    my $location = $1; # This captures the actual location name
    my $is_group_transport = defined $2; # True if it's a group transport

    if (!$is_group_transport || $group_flg) {
      if ($text =~ /^($continent_regex)(:group)?$/i) {
        my $continent = ucfirst(lc($1));
        my $suffix = plugin::get_suffix_by_continent($continent);
        my $continent_data = $zone_data->{$suffix};
      
        # Check if we're in the stage of selecting a location
        if ($continent_data && ref($continent_data) eq 'HASH') {
            $client->Message(257, " ------- Select a Location ------- ");
            foreach my $key (sort keys %{$continent_data}) {
                my $mode_indicator = $is_group_transport ? ":group" : "";
                $client->Message(257, "-[ " . quest::saylink($key . $mode_indicator, 1, $key));
            }
        }
      }
      
      # Execute transport when a specific location is selected
      if (exists($flat_data->{$location})) {
        my $zone = quest::GetZoneID($flat_data->{$location}[0]);
        my $x = $flat_data->{$location}[1];
        my $y = $flat_data->{$location}[2];
        my $z = $flat_data->{$location}[3];
        my $heading = $flat_data->{$location}[4];  

        if ($client->TakeMoneyFromPP($cost, 1)) { 

          if ($is_group_transport) {
            my $raid = $client->GetRaid();
            if($raid) {
              for($count = 0; $count < $raid->RaidCount(); $count++) {
                my $player = $raid->GetMember($count);
                if($player) {
                  if($player->IsClient() && $client->CharacterID() != $player->CharacterID()) {
                    $player->CastToClient()->MovePC($zone, $x, $y, $z, $heading);
                  }
                }
              }
            }

            my $group = $client->GetGroup();
            if ($group) {
              for (my $count = 0; $count < $group->GroupCount(); $count++) {
                  my $player = $group->GetMember($count);
                  if ($player && $client->CharacterID() != $player->CharacterID()) {
                      $player->CastToClient()->MovePC($zone, $x, $y, $z, $heading);
                  }
              }
            }
          }

          quest::debug("$zone $x $y $z $heading");
          $client->MovePC($zone, $x, $y, $z, $heading);
        } else {
          quest::say("I'm sorry, but you don't have enough platinum to pay for this transport.");
        }
      }
    }
  }
}

sub EVENT_ITEM {
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    
    foreach my $item (keys %portal_destinations) {
        if (plugin::check_handin(\%itemcount, $item => 1)) {
            # Set the destination using the item ID
            quest::set_data("magic_map_target", $item); 
            quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
            quest::ze(15, "The Magic Map has been aligned to " . $portal_destinations{$item}[0]);
            plugin::return_items(\%itemcount);
            return;
        }
    }

    plugin::return_items(\%itemcount); # Ensure items are returned if no matching case is found
}

sub EVENT_ENTER {
    my %destination_messages = %{ plugin::get_portal_destinations() };
    
    my $pc = $client;
    if ($pc) {
        my $destination_id = quest::get_data("magic_map_target");
        if ($destination_id && exists $destination_messages{$destination_id}) {
            # Extract the destination name using the saved ID
            my $destination_name = $destination_messages{$destination_id}[0];
            $pc->Message(0, $npc->GetCleanName() . " says 'The Magic Map is currently aligned to " . $destination_name . ".'");
        }
    }
}


sub get_cost_for_level {
  my $client = plugin::val('$client');
  my $level  = $client->GetLevel();

  my %cost_map = (
    0  => 0,  # Default for levels 1-20
    20 => 5, #Cost for levels 20-51
    52 => 25,  # Cost for levels 52-60
    61 => 75,  # Cost for levels 61-65
    66 => 150, # Cost for levels above 65
  );

  for my $threshold (sort { $b <=> $a } keys %cost_map) {
    return $cost_map{$threshold} if $level >= $threshold;
  }
}