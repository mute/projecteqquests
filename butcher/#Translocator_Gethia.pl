# Zone: butcher

sub EVENT_SAY {
    if (plugin::is_stage_complete($client, 'RoK')) {
        if ($text =~ /Hail/i) {
            quest::say("Hello there, $name. There seem to be some strange problems with the boats in this area. " .
                       "The Academy of Arcane Sciences has sent a small team of us to investigate them. If you need to " .
                       "[" . quest::saylink("travel to the Timorous Deep") . "] in the meantime, I can transport you to " .
                       "my companion there.");
        } elsif ($text =~ /travel to the Timorous Deep/i) {                 
            quest::say("Off you go!");
            quest::movepc(96, -3260.10, -4544.56, 19.47); # Zone: timorous
        }
    }

    else {
        if ($text =~ /Hail/i) {
            quest::say("Come back when you are more experienced to journey to Kunark.");
        }
    }
}
