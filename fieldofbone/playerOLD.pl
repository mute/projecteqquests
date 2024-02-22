
sub EVENT_CLICKDOOR {
    quest::debug("objectid " . $objectid);
    $key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);
    if($doorid ==77)
    {
	if ($expansion >= 19){
	quest::movepc(202, 34, -629, -157, 0 );
	}
    else {
    quest::whisper("I must return once I have conquered Luclin");
}
}
}

