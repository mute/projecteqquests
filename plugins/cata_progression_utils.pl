sub CheckLevelCap {
    my $max_level = $client->GetBucket("CharMaxLevel") || 51;
    
	# TODO - Progression framework lol
    
    $client->SetBucket("CharMaxLevel", $max_level);
}

sub IsEligibleForZone {
    my ($client, $zoneid) = $_;

    return 1;
}