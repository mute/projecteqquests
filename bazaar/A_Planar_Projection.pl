sub EVENT_SAY {
    $key = $client->AccountID() . "-kunark-flag";
    $expansion = quest::get_data($key);
	
    if ($text=~/hail/i) {
        if ($expansion >= 19) {
            plugin::Whisper("EXCEPTIONAL! It looks like you are ready to join us in the battle for the future of Planes of Power! Good luck to you, hero!");
        }

        if ($expansion < 19) {
            plugin::Whisper("Ah... I see you have yet to unlock the Planes of Power. You have two options. One is the route of the [hero]. The other, is the route of the [collector].");
    
        }
    }
            if (($text =~/hero/i) && ($expansion <19)){
            plugin::Whisper("To enter the Planes of Power, you must slay the Crawling Beast, the Master of End, the Creature of Nightmares, the Giver of Hate, and the Mighty Emperor.");
            $progressionCount = 5;
		    $progressCount = 0;
            $progressText = "";
            if (quest::get_data($client->AccountID() . "deep") > 0) {
            $progressCount++;
            $progressText .= "Thought Horror Fiend in the Deep, ";
            }

            if (quest::get_data($client->AccountID() . "akh") > 0) {
            $progressCount++;
            $progressText .= "The Insanity Crawler in Akheva Ruins, ";
            }

            if (quest::get_data($client->AccountID() . "griegs") > 0) {
            $progressCount++;
            $progressText .= "Greg Veneficus in Grieg's End, ";
            }

            if (quest::get_data($client->AccountID() . "ssraone") > 0) {
            $progressCount++;
            $progressText .= "Xerkizh the Creator in Ssraeshza Temple, ";
            }

            if (quest::get_data($client->AccountID() . "ssratwo") > 0) {
            $progressCount++;
            $progressText .= "Emperor Ssraeshza in Ssraeshza Temple, ";
            }

            if ($progressCount > 0) {
            $progressText = substr($progressText, 0, -2);
            plugin::Whisper("You have defeated $progressCount of $progressionCount targets: $progressText.");
            }
        }
        if (($text =~/collector/i) && ($expansion <19)){
      plugin::Whisper("Yes, I remember how patient you were... Bring to me an Unadorned Scepter of Shadows, an Apocryphal Shadel Bandit Ring, an Apocryphal Zekhas' Katar, and an Apocryphal Blade of Insanity. This will grant you three Apocryphal tokens. When one is turned in to me, that hero will be granted access to The Planes of Power.");
      return;
      }
  }

sub EVENT_ITEM {
  $key = $client->AccountID() . "-kunark-flag";
  $expansion = quest::get_data($key);

  if ($expansion < 20){
    if (plugin::takeItems(17324 => 1, 828708 => 1, 826826 => 1, 861227 =>1)) {
      plugin::Whisper("Here are three tokens. Hand one back to me for your flag!");
      quest::summonfixeditem(99103);
      quest::summonfixeditem(99103);
      quest::summonfixeditem(99103);
      quest::summonfixeditem(22198);

      quest::ding();
      quest::exp(1000000);
    }

  if ($expansion >= 14){  
    if (plugin::takeItems(99103 => 1)){
      plugin::Whisper("Well done! Beware of the evils that lurk in the Planes $name!");
      quest::ding();
      quest::set_data($client->AccountID() . "akh", 1);
      quest::set_data($client->AccountID() . "griegs", 1);
      quest::set_data($client->AccountID() . "deep", 1);
      quest::set_data($client->AccountID() . "ssraone", 1);
      quest::set_data($client->AccountID() . "ssratwo", 1);

      quest::set_data($key, 19);
    }       
  }

  plugin::returnUnusedItems();

}
}