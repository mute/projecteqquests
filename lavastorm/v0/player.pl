sub EVENT_ENTER_ZONE {
    $client->MovePC($zoneid, quest::GetInstanceID($zonesn, 1), $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
}

sub EVENT_CONNECT {
    $client->MovePC($zoneid, quest::GetInstanceID($zonesn, 1), $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
}