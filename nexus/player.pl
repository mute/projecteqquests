
sub EVENT_CLICKDOOR {
    quest::debug("objectid " . $objectid);
    $key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);
    if($doorid ==78)
    {
	if ($expansion >= 19){
	quest::movepc(202, -79, 411, -157, 0 );
	}
    else {
    quest::whisper("I must return once I have conquered Luclin");
}
}

if($doorid ==2)
    {
	if ($expansion >= 19){
	quest::movepc(202, -79, 411, -157, 0 );
	}
    else {
    quest::whisper("I must return once I have conquered Luclin");
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

if ($expansion < 14){ #Luclin
    $client->Message(7, "You don't belong here!");
    $client->MovePC($bind, $bindx, $bindy, $bindz, $bindh);
  }

}

