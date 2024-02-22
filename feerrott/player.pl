
sub EVENT_CLICKDOOR {
    $key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);
    if($doorid ==77)
    {
	if ($expansion >= 19){
	quest::movepc(202, 443, -862, -157, -256);
	}
    else {
    quest::whisper("I must return once I have conquered Luclin");
}
}
}

