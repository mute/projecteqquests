sub EVENT_SAY {
    if ($client->GetFaction($npc) <= 5) {
        if ($text=~/hail/i) {
            quest::say("Hmm, I have been watching you. You made it further than I thought you would. I will have to work on my defenses in the future. So, what do you seek of me?");
        } elsif ($text=~/Jaled Dar/i) {
            quest::say("Jaled Dar is quite dead, you know. But he was tasty, I feasted on his remains long ago. I do wish his spirit would go away, his incessant wailing disturbs me, and worse, it makes other dragons wary of this place. I have not eaten as well as I would have liked since his shade came to stay. If you wish to speak with him yourself, I can arrange that, for I hold a key that will unlock his tomb.");
        } elsif ($text=~/key/i) {
            quest::say("This IS my realm, after all. Nothing is barred to me. But I did not become who I am by doing something for nothing. If you wish to talk to Jaled Dar, you will have to do something for me first. Are you willing to do this task?");
        } elsif ($text=~/task/i) {
            quest::say("There is an annoying uprising taking place among the Chetari and Paebala. This is affecting my diet. I get cranky when I don't eat right. I am VERY cranky right now. The rebellion is led by a Paebala named Neb. He has taken his followers into a part of the Necropolis that I have difficulty reaching, and he has somehow tamed the goo there as well, preventing my Chetari followers from assaulting them directly. If Neb were to fall, I am certain the rebellion would quickly falter. Bring me Neb's head, and I will give you the key to Jaled Dar's tomb.");
        }
    }
}

sub EVENT_ITEM {
    if ($client->GetFaction($npc) <= 5) {
        if (plugin::check_handin(\%itemcount, 26010 => 1)) {  # Neb's Head
            quest::say("Excellent work! Here is your key, go bother that prattling fool Jaled Dar, and leave me be.");
            $client->Ding();
            $client->SummonItem(28060);     # Jaled Dar's Tomb Key
            quest::rewardfaction(462, 50);  # Chetari
            quest::rewardfaction(464, 500); # Zlandicar
            quest::rewardfaction(430, -50);    # Claws of Veeshan
            quest::rewardfaction(304, -50);    # Ring of Scale
            $client->AddEXP(250000);
			
        }
    }
    # Make sure to return unused items
    plugin::return_items(\%itemcount);
}

sub EVENT_DEATH_COMPLETE {
    if (plugin::subflag_exists($npc->GetCleanName())) {
        my $flag_mob = quest::spawn2(26000, 0, 0, $x, $y, ($z + 10), 0); # Spawn a flag mob
        my $new_npc = $entity_list->GetNPCByID($flag_mob);
        
        $new_npc->SetBucket("Flag-Name", $npc->GetCleanName(), "1200s");
        $new_npc->SetBucket("Stage-Name", plugin::get_subflag_stage($npc->GetCleanName()), "1200s");
    }
}

sub EVENT_KILLED_MERIT {
    if (plugin::subflag_exists($npc->GetCleanName())) {
        plugin::set_subflag($client, plugin::get_subflag_stage($npc->GetCleanName()), $npc->GetCleanName());
    }
}