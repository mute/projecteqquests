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
    elsif ($text=~/hail/i) {
        quest::say("Immortal. Your journey continues, much as mine - eternally. What do you [require of me]?");
    }

    
    elsif ($text=~/start anew/i) {
        if (plugin::GetClassesCount($client) >= 3) {
            # TODO - Add respec methods
            quest::say("Your fate is set, immortal. Go [challenge it].");
        } else {
            my $extra_class_list = plugin::GetClassesSelectionString();
            my $deity_message = $deity_name eq "Agnostic" ? "free from the whims of the gods" : "of the so-called god, $deity_name, now lost to the ages";
            quest::say("Yes, let us explore the multitude of paths before you, lost immortal. As a $base_class_name $deity_message, your first choice, shall it be " . $extra_class_list);
        }
    }

    elsif ($text =~ /^select_class_(\d+)$/) {
        my $class_to_add = $1;
        if (plugin::IsValidToAddClass($class_to_add)) {
            plugin::AddClass($class_to_add);
            
            # Determine the appropriate $secondary_response based on the new total number of classes
            my $total_classes_now = plugin::GetClassesCount();
            my $secondary_response;
            
            if ($total_classes_now == 3) {
                $secondary_response = "Your fate is set, immortal. Go [challenge it].";
                if (!$account_zeb_progress) {
                    quest::set_data(plugin::GetAccountKey() . "zeb-progress", 1);
                }
                $client->SetBucket("zeb-progress", 1);
            } else {
                # Assuming you have a method to generate the selection string for the remaining classes
                my $selection_string = plugin::GetClassesSelectionString();
                $secondary_response = "Your second and final choice, immortal. Choose wisely: $selection_string";
            }

            quest::say("Indeed - it is done. $secondary_response");
        } else {
            quest::say("Alas, I am unable to do so. Your fate is set, immortal. Go [challenge it].");
        }
    }

    elsif ($text=~/challenge it/i) {
        if (GetClassesCount($client) == 3) {
            quest::say("Farewell, immortal. I'm sure that you'll find your way back here again.");

            plugin::ReturnToZone($client);
        } else {
            quest::say("You are not yet ready to leave, immortal. There is still time to [start anew].");
        }
    }



    # Update interaction records
    #quest::set_data(plugin::GetAccountKey() . "zeb-progress", 1);
    
    #$client->SetBucket("zeb-progress", 1);
}

