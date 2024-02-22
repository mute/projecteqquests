

sub EVENT_CLICKDOOR {
    quest::debug("objectid " . $objectid);
    $key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);
    if($doorid ==109)
    {
	if ($expansion >= 19){
	quest::movepc(202, 883, 877, -157, 0); #Kelethin
	}
    else {
    quest::whisper("I must return once I have conquered Luclin");
}
}
    if($doorid ==108)
    {
        if ($expansion >= 19){
            quest::movepc(202, 71, 812, -157, -130); #Felwithe
        }
        else {
            quest::whisper("I must return once I have conquered Luclin");
        }
    }
}

sub EVENT_TIMER {


  if (defined $qglobals{nexus_gf} && defined $qglobals{spire_gf} && $qglobals{spire_gf} == 1 && plugin::check_hasitem($client, 19720)) {
    $key = $client->AccountID() . "-kunark-flag";
	$expansion = quest::get_data($key);
	if ($expansion > 7){
    quest::selfcast(2433); #self only to avoid AE
    quest::setglobal("spire_gf",0,1,"F");
    quest::delglobal("message_gf");
    $client->NukeItem(19720); #removes stone from inventory.
    $nexus_gf = undef;
    $spire_gf = undef;
    $message_gf = undef;
    }
  }
  elsif (defined $qglobals{nexus_gf} && defined $qglobals{spire_gf} && $qglobals{spire_gf} == 1 && !defined $qglobals{message_gf} && !plugin::check_hasitem($client, 19720)) {
    $client->Message(15,"You don't have the correct component to travel to Luclin.");
    quest::setglobal("message_gf",1,1,"M20"); #prevent component mssage from being spammed.
    $nexus_gf = undef;
    $spire_gf = undef;
    $message_gf = undef;
  }
  elsif (defined $qglobals{nexus_gf} && defined $qglobals{spire_gf} && $qglobals{spire_gf} == 1 && defined $qglobals{message_gf} && !plugin::check_hasitem($client, 19720)) {
    $nexus_gf = undef;
    $spire_gf = undef;
    $message_gf = undef;
  }
}

