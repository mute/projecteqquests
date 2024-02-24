sub EVENT_SAY {
  if ($text=~/hail/i) {
    if (!$client->GetBucket('newbieRewardBits')) {
      quest::emote("laughs");
      quest::say("Oh my, you really don’t remember me do you? I could never forget a comrade in arms! 
                  Hail $name! Let me see that faded writ and I’ll give you something to jog your memory");
    } else {
      quest::emote("laughs");
      quest::say("I'm so glad to see you again!");
      RewardItems($client);
    }
  }  
  if($text=~/denizens of this realm/i){
    quest::say("Hmmm I don’t want to risk sending you into shock or an existential crisis. Just do what 
               feels natural and try to remember who needs your help and whose demise you must bring about. 
               Every quest you endeavor will reward you with Rose Colored or Apocryphal items like I have. 
               You may return to wherever you were when you opened your portal here by simply leaving the bazaar. 
               Conversely, you may return to any place which you have attuned by speaking with Tearel! Good luck $name.");
  }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 18471 => 1)) {
      quest::debug("TEST");
      RewardItems($client);
    } else {
        quest::say("I don't need this item, $name. Perhaps you should keep it.");
    }  
    # Return items that are not used
    plugin::returnUnusedItems();
}

sub RewardItems {
    my ($client) = @_;

    my %classRewards = (
        1     => { items => [17423, 89998, 813514], cash => 3 }, # Warrior, 3 silver
        2     => { items => [17423, 89999, 813542], cash => 3 }, # Cleric, 3 silver
        4     => { items => [17423, 855623, 813514], cash => 3 }, # Paladin, 3 silver
        8     => { items => [17423, 89998, 88009, 88500, 88500, 813514], cash => 3 }, # Ranger, 3 silver
        16    => { items => [17423, 855623, 813514, 199999], cash => 3 }, # Shadow Knight, 3 silver
        32    => { items => [17423, 89999, 813542, 199999], cash => 3 }, # Druid, 3 silver
        64    => { items => [17423, 867133, 813514], cash => 3 }, # Monk, 3 silver
        128   => { items => [17423, 89998, 813514, 9992, 15703, 199999], cash => 3 }, # Bard, 3 silver
        256   => { items => [17423, 89997, 813514, 44531], cash => 3 }, # Rogue, 3 silver
        512   => { items => [17423, 89999, 813542, 199999], cash => 3 }, # Shaman, 3 silver
        1024  => { items => [17423, 86012, 813566, 199999], cash => 3 }, # Necromancer, 3 silver
        2048  => { items => [17423, 86012, 813566], cash => 3 }, # Wizard, 3 silver
        4096  => { items => [17423, 86012, 813566, 199999], cash => 3 }, # Magician, 3 silver
        8192  => { items => [17423, 86012, 813566, 199999], cash => 3 }, # Enchanter, 3 silver
        16384 => { items => [17423, 867133, 813514, 199999], cash => 3 }, # Beastlord, 3 silver
        32768 => { items => [17423, 855623, 813514], cash => 3 }, # Berserker, 3 silver
    );

    my $playerClassBitmask = $client->GetClassesBitmask();
    my $rewardedClassesBitmask = $client->GetBucket('newbieRewardBits') || 0;
    my $rewardGiven = 0;

    foreach my $classBitmask (keys %classRewards) {
        if (($playerClassBitmask & $classBitmask) && !($rewardedClassesBitmask & $classBitmask)) { 
            # Summon the fixed items for the class
            foreach my $item (@{$classRewards{$classBitmask}->{items}}) {
                $client->SummonItem($item);
            }
            
            $rewardedClassesBitmask |= $classBitmask; 
            $rewardGiven = 1;
        }
    }

    if ($rewardGiven) {
        $client->SetBucket('newbieRewardBits', $rewardedClassesBitmask);
        $client->say("Hmmm… Does this refresh your memory at all? I think you’ll find that if you look around here long enough, things will seem more and more like you remember. You see, you may have forgotten how strong you are, but the [denizens of this realm] could never.");
    }
}

