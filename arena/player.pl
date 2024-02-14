$zoneid = quest::GetZoneID();

sub EVENT_CLICKDOOR {
    quest::debug("objectid " . $objectid);
    $key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);
    if($doorid ==77)
    {
	if ($expansion >= 19){
	quest::movepc(202, 140, -433, -157, 250 );
	}
    else {
    quest::whisper("I must return once I have conquered Luclin");
}
}
}


sub EVENT_ENTER_ZONE {
	$ssfkey = $client->AccountID() . "ssf";
	if (quest::get_data($ssfkey) == "1") {
		plugin::SendToInstance("public", "arena", 100, 0, 0, 0, "SSF", 604800);	
	}
}

sub EVENT_CONNECT {
	$ssfkey = $client->AccountID() . "ssf";
	if (quest::get_data($ssfkey) == "1") {
	plugin::SendToInstance("public", "arena", 100, 0, 0, 0, "SSF", 604800);
	}
}




