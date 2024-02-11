sub EVENT_SAY {
    my $account_zeb_progress = quest::get_data(plugin::GetAccountKey() . "zeb-progress") || 0;
    my $character_zeb_progress = $client->GetBucket("zeb-progress") || 0;
    my $last_zeb_charname = quest::get_data(plugin::GetAccountKey() . "zeb-last-charname") || "";

    my $base_class = $client->GetClass();
    my $base_class_name = quest::getclassname($base_class);
    my $deity = $client->GetDeity();
    my $deity_name = quest::getdeityname($deity);

    quest::set_data(plugin::GetAccountKey() . "zeb-last-charname", $client->GetCleanName());

    if ($client->GetGM()) {
        quest::set_data($client->AccountID() . "-account-progression", 1);
    }


    # Greetings
    # Condition 1: Neither this character nor this account have interacted with this NPC
    if ($text=~/hail/i && !$account_zeb_progress && !$character_zeb_progress) {
        quest::say("Hail yourself, $base_class_name. Yet another wandering hero finds this place through the blind abyss, 
                    the end of all things. We have met once before, when I challenged the gods, so long ago. In light of 
                    that service that you once performed, and will again, I will grant you the ability to [start anew]. 
                    Shall we begin?");
    }

    # Condition 2: This account has interacted with this NPC, but the character has not
    elsif ($text=~/hail/i && $account_zeb_progress && !$character_zeb_progress) {
        quest::say("Hail. You find yourself here, again. The cycle continues. This time, present yourself before me as 
                    a $base_class_name, in this place beyond the concept of both time and 'place' itself. At the end 
                    of all. I suppose it is time to once again [start anew]. Shall we begin?");
    }

    # Condition 3: This character has interacted with Zeb before, but the most recent time was not this character.
    elsif ($text=~/hail/i && $character_zeb_progress && $last_zeb_charname ne $client->GetCleanName()) {
        quest::say("Back again, hero? You shift your face as often as I shift the fates, and both of them futile. What 
                    do you [require of me]? If there is nothing, then your fate is set. Go [challenge it].");
    }

    # Condition 4: This character has interacted with Zeb before, and the most recent time was this character.
    elsif ($text=~/hail/i) {
        quest::say("Hero. Your journey continues, much as mine - eternally. What do you [require of me]? If there 
                    is nothing, then your fate is set. Go [challenge it].");
    }

    elsif ($text=~/require of me/i) {
        if (plugin::GetClassesCount($client) < 3) {
            my $selection_response = quest::saylink("start anew",1,"selection");
            quest::say("I see that you have not yet chosen all three of your threefold path. Would you like to make an additional class [$selection_response], or would you like to [leave] this place? 
                        I can also help you to [reforge your soul], so that you might choose new paths.");
        } else {
            quest::say("You have chosen your threefold path, hero. Your fate is set - all there is to do is to [challenge it]. Unless... of course, you'd like to [reforge your soul]?")
        }   
    }
    
    elsif ($text=~/start anew/i || $text =~/again/i) {
        if (plugin::GetClassesCount($client) >= 3) {
            # TODO - Add respec methods
            quest::say("Your fate is set, hero. Go [challenge it].");
        } else {
            my $extra_class_list = plugin::GetClassesSelectionString();
            my $deity_message = $deity_name eq "Agnostic" ? "free from the whims of the gods" : "of the so-called god, $deity_name, now lost to the ages";

            my $color_end = "</c>";
            my $break = "<br>";
            my $yellow = plugin::PWColor("Yellow");
            my $red    = plugin::PWColor("Red");
            my $green  = plugin::PWColor("Green");

            my $website = plugin::PWHyperLink("https://heroesjourneyeq.com","website");
            my $discord = plugin::PWHyperLink("https://discord.gg/h4eRaGjc5T","discord");

            my $popup_title   = "Multiclassing on The Heroes' Journey";
            my $popup_message = 
                                "${red}Please Read Completely${color_end}${break}${break}" .
                                "Characters on The Heroes' Journey each have three classes. You chose one during character creation, " .
                                "and you will choose two more now. You will gain the abilities and attributes of each of the chosen classes; " .
                                "Spells, Skills, Equipment, Alternate Advancement abilities, and even more 'hidden' features like AC caps and melee damage bonuses. " .
                                "We have worked to make this process as intuitive as possible, but there are some things to be aware of as you make your choices.${break}${break}" .
                                "${green}Patcher and Client software${color_end}: You ${red}MUST${color_end} use our client on this server. " .
                                "This isn't a simple matter of spell and string files; much of the multiclassing system will not work at all without the custom client modifications we have made. " .
                                "If you have not obtained it already, please visit ${website}. You can also find a link to our Discord there!${break}${break}" .
                                "${green}Bards${color_end}: If you did not select Bard during character creation and choose Bard as an additional class, you will be " .
                                "immediately disconnected so that certain changes can be made to your character in order for Bard abilities to work correctly.${break}${break}" . #TODO - update this with however bards work out
                                "${green}Quests & Faction${color_end}: The class that you selected during character selection (or Bard, if you include it in your build) may be considered your 'real' class for the purposes of some quests. " .
                                "It is intended that you be able to complete all quests which are available to any of your classes, but you may encounter some faction issues as a result of character select choices. " .
                                "Please report any such issues on our Discord so that they can be corrected.${break}${break}";


            quest::say("Let us explore the many paths before you, lost hero. As a $base_class_name $deity_message, your choice, shall it be " . $extra_class_list . "? Or... 
                        you can simply return from whence you came, and [".quest::saylink("challenge it", 1, "chellenge")."] the fate before you.");
            quest::popup($popup_title, $popup_message);
        }
    }

    elsif ($text =~ /^select_class_(\d+)$/ || $text =~ /continue_/) {
        my $class_to_add = $1;
        my $continue_response = quest::saylink("continue_$class_to_add", 1, "continue");
        my $class_name = quest::getclassname($class_to_add);

        if (!$character_zeb_progress) { $client->SetBucket("zeb-progress", 1); }
        if (!$account_zeb_progress) { quest::set_data(plugin::GetAccountKey() . "zeb-progress", 1); }   

        if ($class_to_add){
            if ($class_to_add == 8) {
                quest::say("Ahh, the Bard. Spellsinger, wordsmith. You must understand that choosing this path will forever change you, opening your soul to the music of Norrath. Do you wish to [$continue_response], or would you rather hear your choices [again]?");
                $client->Message(13, "WARNING: You will be immediately disconnected so that your base class can be changed to Bard. All class combinations that include Bard must be base class Bard.");
                return;
            }
            if (plugin::IsMeleeClass($class_to_add) && !plugin::IsMeleeClass($client->GetClass())) {
                quest::say("A $class_name? I can see it, but you will need to go undergo certain conditioning, first. Do you wish to [$continue_response], or would you rather hear your choices [again]?");
                $client->Message(13, "WARNING: You will be immediately disconnected so that your base class can be changed to $class_name. 
                                      All class combinations that include a melee or Hybrid must have a Melee or Hybrid as their base class.");
                return;
            }
        } elsif ($text =~ /^continue_(\d+)$/) {
            $class_to_add = $1;
        }

        if (plugin::IsValidToAddClass($class_to_add)) {
            if (plugin::IsMeleeClass($class_to_add)) {
                if ($class_to_add == 8 || !plugin::IsMeleeClass($client->GetClass())) {
                    quest::permaclass($class_to_add);
                }
            }
            plugin::AddClass($class_to_add);
            
            my $total_classes_now = plugin::GetClassesCount();
            my $secondary_response;
            
            if ($total_classes_now == 3) {
                $secondary_response = "Your fate is set, hero. Go [challenge it].";
            } else {
                my $selection_string = plugin::GetClassesSelectionString();
                $secondary_response = "Your second and final choice, hero. [".quest::saylink("challenge it", 1, "chellenge your fate")."], or choose wisely: $selection_string";
            }

            quest::say("Indeed - it is done. $secondary_response");
        } else {
            quest::say("Alas, I am unable to do so. Your fate is set, hero. Go [challenge it].");
        }
    }

    elsif ($text=~/challenge it/i || $text=~/leave/i) {
        quest::say("Of this, I am sure. Are you prepared to [return] from whence you came? I have granted you the ability to travel to this place in the future, should you require it.");
        # TODO - Assign Pocket Plane Gate spell or AA here.
    }

    elsif ($text=~/return/i) {        
        quest::say("Farewell, hero. I'm sure that you'll find your way back here again.");
        plugin::ReturnToZone($client);       
    }
}

