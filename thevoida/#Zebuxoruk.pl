sub EVENT_SAY {
    my $account_zeb_progress = quest::get_data(plugin::GetAccountKey() . "zeb-progress") || 0;
    my $character_zeb_progress = $client->GetBucket("zeb-progress") || 0;
    my $last_zeb_charname = quest::get_data(plugin::GetAccountKey() . "zeb-last-charname") || "";

    my $base_class = $client->GetClass();
    my $base_class_name = quest::getclassname($base_class);
    my $deity = $client->GetDeity();
    my $deity_name = quest::getdeityname($deity);

    quest::set_data(plugin::GetAccountKey() . "zeb-last-charname", $client->GetCleanName());

    # Greetings
    # Condition 1: Neither this character nor this account have interacted with this NPC
    if ($text=~/hail/i && !$account_zeb_progress && !$character_zeb_progress) {
        quest::say("Hail yourself, $base_class_name. Yet another wandering immortal finds this place through the blind eternities, the end of all things. We have met once before, when I challenged the gods, so long ago. In light of that service that you once performed, and will again, I will grant you the ability to [start anew]. Shall we begin?");
    }

    # Condition 2: This account has interacted with this NPC, but the character has not
    elsif ($text=~/hail/i && $account_zeb_progress && !$character_zeb_progress) {
        quest::say("Hail. You find yourself here, again. The cycle continues. This time, present yourself before me as a $base_class_name, in this place beyond the concept of both time and 'place' itself. At the end of all. I suppose it is time to once again [start anew]. Shall we begin?");
    }

    # Condition 3: This character has interacted with Zeb before, but the most recent time was not this character.
    elsif ($text=~/hail/i && $character_zeb_progress && $last_zeb_charname ne $client->GetCleanName()) {
        quest::say("Back again, immortal? You shift your face as often as I shift the fates, and both of them futile. What do you [require of me]?");
    }

    # Condition 4: This character has interacted with Zeb before, and the most recent time was this character.
    elsif ($text=~/hail/i && $character_zeb_progress) {
        quest::say("Immortal. Your journey continues, much as mine - eternally. What do you [require of me]?");
    }

    
    elsif ($text=~/start anew/i) {
        my $extra_class_list = GetExtraClassesList();
        my $deity_message = $deity_name eq "Agnostic" ? "free from the whims of the gods" : "of the so-called god, $deity_name, now lost to the ages";
        quest::say("Yes, let us explore the multitude of paths before you, lost immortal. As a $base_class_name $deity_message, your first choice, shall it be " . $extra_class_list);

        quest::say("Yes, yes. I think... yes. Let us try something new. What else would you like to be, $base_class_name $deity_message? Your first choice, then. Shall it be " . $extra_class_list);
    }


    # Update interaction records
    #quest::set_data(plugin::GetAccountKey() . "zeb-progress", 1);
    
    #$client->SetBucket("zeb-progress", 1);
}

sub GetExtraClassHash {
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

sub GetExtraClassesList {
    my $base_class = $client->GetClass();
    my %extra_classes = GetExtraClassHash();
    
    # Remove the player's current class from the list of extra classes
    delete $extra_classes{$base_class};
    
    # Get all remaining class names
    my @classes = values %extra_classes;
    
    # Initialize the extra class list string
    my $extra_class_list = '';
    
    # Check if there are multiple classes to list
    if (@classes > 1) {
        # Join all but the last class name with commas
        $extra_class_list = join(", ", @classes[0 .. $#classes-1]);
        # Add 'or' before the last class name
        $extra_class_list .= " or $classes[-1]";
    } else {
        # Only one class, so just use it
        $extra_class_list = $classes[0] // ''; # The // operator is used to handle the case when @classes is empty
    }
    
    return $extra_class_list;
}

