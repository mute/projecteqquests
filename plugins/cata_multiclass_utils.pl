sub CommonCharacterUpdate
{
    my $client = shift;
    my $levels_gained = shift;
}

sub GetClassMap {
    return (
        1 => "Warrior",
        2 => "Cleric",
        3 => "Paladin",
        4 => "Ranger",
        5 => "Shadow Knight",
        6 => "Druid",
        7 => "Monk",
        8 => "Bard",
        9 => "Rogue",
        10 => "Shaman",
        11 => "Necromancer",
        12 => "Wizard",
        13 => "Magician",
        14 => "Enchanter",
        15 => "Beastlord",
        16 => "Berserker",
    );
}

sub GetClassesCount {
    my $client = shift || plugin::val('$client');

    if ($client) {
        my $class_bits = $client->GetClassesBitmask();
        my $count = 0;
        
        while ($class_bits) {
            $count += $class_bits & 1;
            $class_bits >>= 1;
        }

        return $count;
    }

    # Return 0 or an appropriate value if $client is not provided or no classes bits are set
    return 0;
}

sub GetExtraClassesList {
    my $client = shift || plugin::val('$client');
    my %class_map = GetClassMap();
    my $class_bits = $client->GetClassesBitmask();
    my %available_classes;

    # Determine which classes the player does NOT have based on class bits
    foreach my $class_id (keys %class_map) {
        unless ($class_bits & (1 << ($class_id - 1))) {
            $available_classes{$class_id} = $class_map{$class_id};
        }
    }

    return %available_classes;
}

sub GetClassesSelectionString {
    my $client = shift || plugin::val('$client');
    my %available_classes = GetExtraClassesList($client);
    my @selection_strings;

    foreach my $class_id (sort { $a <=> $b } keys %available_classes) {
        my $class_name = $available_classes{$class_id};
        my $signal_string = "select_class_" . $class_id; # Unique signal string based on class ID
        push @selection_strings, "[".quest::saylink($signal_string, 1, $class_name)."]";
    }

    my $selection_string = join(", ", @selection_strings[0 .. $#selection_strings-1]);
    $selection_string .= ", or " . $selection_strings[-1] if @selection_strings > 1;

    return $selection_string;
}

sub IsValidToAddClass {
    my $class_id_to_add = shift;
    my $client = plugin::val('$client'); # Assuming $client is accessible in this context

    # Retrieve the client's current class bits
    my $class_bits = $client->GetClassesBitmask();

    # Count the number of classes the client already has
    my $classes_count = 0;
    for (my $i = 1; $i <= 16; $i++) {
        $classes_count += ($class_bits & (1 << ($i - 1))) ? 1 : 0;
    }

    # Check if the client already has this class
    my $has_class_already = ($class_bits & (1 << ($class_id_to_add - 1))) ? 1 : 0;

    # Determine if eligible to add: less than 3 classes and doesn't already have this class
    return ($classes_count < 3 && !$has_class_already);
}
