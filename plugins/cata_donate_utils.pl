my $eom_id = 6;
my $eom_item_id = 46779;
my $eom_log = "total-eom-spend";

sub CheckWorldWideBuffs {
    my $target = shift;
    if($target->IsClient() || ($target->Ispet() && $target->HasOwner() && $target->GetOwner()->IsClient())) {
        for my $spell_id (43002 .. 43008) {
            my $data = quest::get_data("eom_$spell_id");

            if ($data) {               
                $npc->ApplySpellBuff($spell_id, quest::get_data_remaining("eom_$spell_id")/6);                
            } else {
                $npc->BuffFadeBySpellID($spell_id);
            }
        }
    }
}

# Spend EOM. Returns true on success, false on failure
# usage: plugin::SpendEOM($client, $amount)
sub SpendEOM {
    my ($client, $amount) = @_;
    my $eom_available = $client->GetAlternateCurrencyValue($eom_id);

    if ($eom_available >= $amount) {
        $client->SetAlternateCurrencyValue($eom_id, $eom_available - $amount);
        $client->Message(15, "You have spent $amount [".quest::varlink($eom_item_id)."].");
        if (!$client->GetGM()) {
            quest::set_data($eom_log, (quest::get_data($eom_log) || 0) + $amount);
        }
        return 1;
    }
    return 0;
}

sub RefundEOM {
    my ($client, $amount) = @_;
    my $eom_available = $client->GetAlternateCurrencyValue($eom_id);
    $client->SetAlternateCurrencyValue($eom_id, $eom_available + $amount);
    $client->Message(15, "You have gained $amount [".quest::varlink($eom_item_id)."].");
    if (!$client->GetGM()) {
        quest::set_data($eom_log, (quest::get_data($eom_log) || 0) - $amount);
    }
}

sub GetEOM {
    my ($client) = @_;

    return $client->GetAlternateCurrencyValue($eom_id);
}

sub EOMLink {
    return quest::varlink($eom_item_id);
}

sub num2en {
    my $number = shift;

    return "zero" if $number == 0; # Handle 0 explicitly
    return "one thousand" if $number == 1000; # Special case for 1000

    my %map = (
        1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five",
        6 => "six", 7 => "seven", 8 => "eight", 9 => "nine", 10 => "ten",
        11 => "eleven", 12 => "twelve", 13 => "thirteen", 14 => "fourteen",
        15 => "fifteen", 16 => "sixteen", 17 => "seventeen", 18 => "eighteen", 19 => "nineteen",
    );

    my %tens_map = (
        2 => "twenty", 3 => "thirty", 4 => "forty", 5 => "fifty",
        6 => "sixty", 7 => "seventy", 8 => "eighty", 9 => "ninety",
    );

    my $word = '';

    if ($number >= 100) {
        my $hundreds = int($number / 100);
        $word .= $map{$hundreds} . " hundred";
        $number %= 100; # Reduce number to remainder for further processing
        $word .= " and " if $number > 0; # Add 'and' if there's more to come
    }

    if ($number >= 20) {
        my $tens = int($number / 10);
        $word .= $tens_map{$tens};
        $number %= 10; # Reduce number to remainder for ones place
        $word .= "-" if $number > 0; # Add hyphen for numbers like "twenty-one"
    }

    $word .= $map{$number} if $number > 0 && exists $map{$number};

    return $word;
}