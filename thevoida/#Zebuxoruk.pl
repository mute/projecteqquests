sub EVENT_SAY {

    my $zeb_progress = quest::get_data(plugin::GetAccountKey() . "zeb-progress") || 0;

    my $base_class = $client->GetClass();
    my $base_class_name = quest::getclassname($base_class);
    my $deity = $client->GetDeity();
    my $deity_name = quest::getdeityname($deity);

    if ($text=~/hail/i && !$zeb_progress) {
        quest::say("Hail, yourself. You find yourself here, again. The cycle continues. This time, present youself before me as a $base_class_name, in this place beyond the concept of both time and 'place' itself. At the end of all. I suppose it is time to once again [start anew]. Shall we begin?");
    }

    else if ($text=~/start anew/i) {
        my $extra_class_list = GetExtraClassesList();
        quest::say("Yes, yes. I think... yes. Let us try something new. What else would you like to be, $base_class_name of the so-called god, $deity_name, now lost to the ages? Your first choice, shall it be " . $extra_class_list);
    }
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
    
    # Join the remaining class names into a string
    my $extra_class_list = join(", ", values %extra_classes);
    
    return $extra_class_list;
}
