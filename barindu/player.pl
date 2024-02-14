#BeginFile: barindu\player.pl
#Quest file for Barindu - Viarglug: Spawn Chest during Necromancer Epic 1.5 (Soulwhisper)
sub EVENT_LOOT {
  if (($corpse eq "#Viarglug") && $looted_id == 11174) {  #Whiahdi's Earthly Possessions
	if (defined($qglobals{Soulwhisper}) && $qglobals{Soulwhisper} == 2) {
	  if (!defined($qglobals{nec_epic_barindu})) {
			quest::setglobal("nec_epic_barindu", "1", 5, "F"); 
			$x = $client->GetX();
			$y = $client->GetY();
			$z = $client->GetZ();
			quest::spawn2(283157,0,0,$x,$y,$z,0); # NPC: a_chest
		}
	  return 0;
	}
	else 
	{
		return 1;
	}
  }
}

sub EVENT_ENTERZONE {
	$key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);

	$bind = $client->GetBindZoneID;
	$bindh = $client->GetBindHeading;
	$bindx = $client->GetBindX;
	$bindy = $client->GetBindY;
	$bindz = $client->GetBindZ;

	if (quest::get_data("god-open") == 10 && ($expansion >= 20 || quest::get_data($client->AccountID() . "-saryrn-flag"))) {
		# do nothing
	} else {
		$client->Message(7, "You don't belong here!");
		$client->MovePC($bind, $bindx, $bindy, $bindz, $bindh);
	}
}


