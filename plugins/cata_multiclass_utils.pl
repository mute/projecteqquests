sub CommonCharacterUpdate {    
    my $client = shift || plugin::val('$client');
    my $void_zone = quest::GetZoneID("thevoida");
    my $zoneid = $client->GetZoneID();
    my $instanceid = $client->GetInstanceID();

    # Check if not in an instance and has less than 3 classes
    if (!$instanceid && GetClassesCount($client) < 3) {
        quest::debug("Not in an instance!");
        
        # Create a new instance of 'thevoida'
        my $instance = quest::CreateInstance('thevoida', 0, 360000);
        $client->AssignToInstance($instance);

        # Save the client's last position
        $client->SetBucket("Last-Position-Zone", $zoneid);
        $client->SetBucket("Last-Position-X", $client->GetX());
        $client->SetBucket("Last-Position-Y", $client->GetY());
        $client->SetBucket("Last-Position-Z", $client->GetZ());
        $client->SetBucket("Last-Position-Heading", $client->GetHeading());

        # Move the client to the instance
        $client->MovePCInstance($void_zone, $instance, quest::GetZoneSafeX($void_zone), quest::GetZoneSafeY($void_zone), quest::GetZoneSafeZ($void_zone), quest::GetZoneSafeHeading($void_zone));
    }
}

sub ReturnToZone {
    my $client = shift || plugin::val('$client');

    # Check if all last position values exist
    my $last_zone = $client->GetBucket("Last-Position-Zone");
    my $last_x = $client->GetBucket("Last-Position-X");
    my $last_y = $client->GetBucket("Last-Position-Y");
    my $last_z = $client->GetBucket("Last-Position-Z");
    my $last_heading = $client->GetBucket("Last-Position-Heading");

    # Use bind point if any last position value is missing
    unless (defined $last_zone && defined $last_x && defined $last_y && defined $last_z && defined $last_heading) {
        $last_zone = $client->GetBindZoneID();
        $last_x = $client->GetBindX();
        $last_y = $client->GetBindY();
        $last_z = $client->GetBindZ();
        $last_heading = $client->GetBindHeading();
    }

    # Move the client to the determined position
    $client->MovePC($last_zone, $last_x, $last_y, $last_z, $last_heading);
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

sub AddClass {
    my $class_id = shift;
    my $client = shift || plugin::val('$client');

    if ($class_id && $class_id > 0 && $class_id < 17 && GetClassesCount($client) < 3) {
        $client->AddExtraClass($class_id);

        my $class_name = quest::getclassname($class_id);
        my $full_class_name = GetPrettyClassString();        

        $client->Message(15, "You have permanently gained access to the $class_name class, and are now a $full_class_name.");
    }
}

sub GetPrettyClassString {
    my $client = shift || plugin::val('$client');  # Ensure $client is available
    my %class_map = GetClassMap();  # Get the full class map
    my $class_bits = $client->GetClassesBitmask();  # Retrieve the class bits for the client

    my @client_classes;

    # Iterate through class IDs to check which classes the client has
    foreach my $class_id (sort { $a <=> $b } keys %class_map) {
        if ($class_bits & (1 << ($class_id - 1))) {
            push @client_classes, $class_map{$class_id};  # Add class name if the client has it
        }
    }

    # Join the client's class names with slashes
    my $pretty_class_string = join('/', @client_classes);

    return $pretty_class_string;
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
