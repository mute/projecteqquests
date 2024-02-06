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