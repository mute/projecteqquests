# items: 1046, 30162
my $corbin = undef;

sub EVENT_SPAWN {
    if ($npc->GetNPCTypeID() == 116119) {
        $corbin = $npc;
        quest::settimer("down",1);
    }
}

sub EVENT_HP {
    if ($inchpevent == 50) {
        quest::emote(" sits up with a groan of effort.");
        $npc->SetAppearance(1);
        quest::setnextinchpevent(75);
    }
    elsif ($inchpevent == 75) {
        quest::emote(" heaves himself heavily to his feet.");
        $npc->SetAppearance(0);
        quest::settimer("down", 5);
    }
}

sub EVENT_SAY { 
    if($text=~/hail/i && $npc->GetGrid() == 0) {
        quest::say("Hurry! There's not much time. Give me the key and show me proof that you are a friend sent to rescue me...");
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 1046 => 1, 30162 => 1)) {
        quest::say("I thought I was a dwarfskin rug there for a minute! Thank Brell for your help stranger! Now cover me while I make good my escape... Wait! What's that in the distance?! Bahreck is already here!");
        quest::summonfixeditem(30162); # Item: Mithril Coldain Insignia Ring
        quest::spawn2(116569, 0, 0, -2139, 168, 150, 114); # NPC: Commander_Bahreck
    }

    plugin::return_items(\%itemcount);
}

#END of FILE Zone:eastwastes  ID:116145 ID:2000944 -- Corbin_Blackwell
