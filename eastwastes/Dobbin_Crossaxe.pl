# items: 30162, 1047
my $ring_seven_final = undef;

sub EVENT_SAY { 
  if($text=~/Hail/i) {
    quest::say("We were too late but you managed to fend themk off yourselves! The Dain will be very pleased!");
    quest::say("Please friend, show me your Mithril ring and I will show you our gratitude.");
  }
}

sub EVENT_ITEM { 
  if (plugin::check_handin(\%itemcount, 30162 => 1)){
    quest::say("Thank you. $name. your deeds will be mentioned to  the Dain. Please take this note from Corbin to Garadain. It may help him to achieve victory over the enemy.");
    quest::summonfixeditem(1047); # Item: Note from Corbin
    quest::faction(406,5); # Faction: Coldain
    quest::faction(405,5); # Faction: Dain Frostreaver IV
    quest::faction(419,-10); # Faction: Kromrif
    quest::faction(448,-10); # Faction: Kromzek
    $ring_seven_final=undef;
  }

  plugin::return_items(\%itemcount);
}

#END of FILE Zone:eastwastes  ID:116129 -- Dobbin_Crossaxe
