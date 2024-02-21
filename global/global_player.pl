sub EVENT_SIGNAL {
	plugin::CheckWorldWideBuffs($client);
}

sub EVENT_ENTERZONE { 
    plugin::CheckWorldWideBuffs($client);
    plugin::CommonCharacterUpdate($client);

    if (!plugin::IsEligibleForZone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
	}
}

sub EVENT_CONNECT {
    plugin::CheckWorldWideBuffs($client);
    plugin::CommonCharacterUpdate($client);

    if (!$client->GetBucket("CharMaxLevel")) {
		$client->SetBucket("CharMaxlevel", 51); #By default, on initial log in (first time) we are setting Max Level to 51.
        plugin::YellowText("Your Level Cap has been set to 51.");
	}

    if (!plugin::IsEligibleForZone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
	}
}

sub EVENT_LEVEL_UP {
    plugin::CheckWorldWideBuffs($client);
    plugin::CommonCharacterUpdate($client);

    my $new_level = $client->GetLevel();

    if (($new_level % 10 == 0) || $new_level == 5) {
        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        plugin::WorldAnnounce("$name ($full_class_name) has reached Level $new_level.");
    }
}

sub EVENT_CLICKDOOR {
	#my $target_zone = plugin::get_target_door_zone($zonesn, $doorid, $version);

	#if (!plugin::IsEligibleForZone($client, $target_zone, 1)) {
		#Disallow Zone
		#return 1;
	#}
}

sub EVENT_DISCOVER_ITEM {
    my $name = $client->GetCleanName();
    plugin::WorldAnnounceItem("$name has discovered: {item}.",$itemid);    
}

sub EVENT_ZONE {
    my $ReturnX = $client->GetBucket("Return-X");
    my $ReturnY = $client->GetBucket("Return-Y");
    my $ReturnZ = $client->GetBucket("Return-Z");
    my $ReturnH = $client->GetBucket("Return-H");
    my $ReturnZone = $client->GetBucket("Return-Zone");

    if ($ReturnX && $ReturnY && $ReturnZ && $ReturnH && $ReturnZone) {
        if ($from_zone_id == 151) {        
            $client->MovePC($ReturnZone, $ReturnX, $ReturnY, $ReturnZ, $ReturnH);
        } elsif ($from_zone_id != $ReturnZone) {
            $client->DeleteBucket("Return-X");
            $client->DeleteBucket("Return-Y");
            $client->DeleteBucket("Return-Z");
            $client->DeleteBucket("Return-H");
            $client->DeleteBucket("Return-Zone");
        }
    }

	plugin::CheckWorldWideBuffs($client);
}

sub EVENT_WARP {
    my $name = $client->GetCleanName();
    quest::discordsend("cheaters", "$name was detected warping.");
}

sub EVENT_COMBINE_VALIDATE {
	if ($recipe_id == 10344) {
		if ($validate_type =~/check_zone/i) {
			if ($zone_id != 289 && $zone_id != 290) {
				return 1;
			}
		}
	}
	
	return 0;
}

sub EVENT_COMBINE_SUCCESS {
    if ($recipe_id =~ /^1090[4-7]$/) {
        $client->Message(1,
            "The gem resonates with power as the shards placed within glow unlocking some of the stone's power. ".
            "You were successful in assembling most of the stone but there are four slots left to fill, ".
            "where could those four pieces be?"
        );
    }
    elsif ($recipe_id =~ /^10(903|346|334)$/) {
        my %reward = (
            melee  => {
                10903 => 67665,
                10346 => 67660,
                10334 => 67653
            },
            hybrid => {
                10903 => 67666,
                10346 => 67661,
                10334 => 67654
            },
            priest => {
                10903 => 67667,
                10346 => 67662,
                10334 => 67655
            },
            caster => {
                10903 => 67668,
                10346 => 67663,
                10334 => 67656
            }
        );
        my $type = plugin::ClassType($class);
        quest::summonitem($reward{$type}{$recipe_id});
        quest::summonitem(67704); # Item: Vaifan's Clockwork Gemcutter Tools
        $client->Message(1,"Success");
    }
}