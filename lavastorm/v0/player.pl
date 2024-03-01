sub EVENT_ENTER_ZONE {
    $client->MovePC($zoneid, quest::GetInstanceID($zonesn, 1), $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
}

sub EVENT_CONNECT {
    quest::debug(quest::GetInstanceID($zonesn, 1));
    $client->MovePC($zoneid, quest::GetInstanceID($zonesn, 1), $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
}