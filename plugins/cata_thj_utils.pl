sub GetAccountKey
{
    my $client = shift || plugin::val('$client');

    if ($client) {
        return "account-" . $client->AccountID() . "-";
    }
}

sub WorldAnnounce
{
    my $message = shift;
    my $channel = shift || "ooc";

    quest::discordsend($channel, $message);
    quest::worldwidemessage(15, $message);
}

sub ClassType {
    my $client = plugin::val('$client');
    my $class  = $client->GetClass();

    my %melee_classes = map { $_ => 1 } (1, 7, 9, 16);
    my %caster_classes = map { $_ => 1 } (11, 12, 13, 14);
    my %priest_classes = map { $_ => 1 } (2, 6, 10);

    if (exists $melee_classes{$class}) {
        return "melee";
    }

    if (exists $caster_classes{$class}) {
        return "caster";
    }

    if (exists $priest_classes{$class}) {
        return "priest";
    }

    return "hybrid";
}