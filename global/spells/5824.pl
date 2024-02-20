# Bazaar Portal
sub EVENT_SPELL_EFFECT_CLIENT {
    my $client = plugin::val('$client');

    if ($zoneid != 151) {
        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
    }
}