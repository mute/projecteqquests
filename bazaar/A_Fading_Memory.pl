my %classRewards = (
    1     => { items => [17423, 89998, 813514], cash => [0, 0, 3, 0] }, # Warrior, bitmask: 1 (2^0)
    2     => { items => [17423, 89999, 813542], cash => [0, 0, 3, 0] }, # Cleric, bitmask: 2 (2^1)
    4     => { items => [17423, 855623, 813514], cash => [0, 0, 3, 0] }, # Paladin, bitmask: 4 (2^2)
    8     => { items => [17423, 89998, 88009, 88500, 88500, 813514], cash => [0, 0, 3, 0] }, # Ranger, bitmask: 8 (2^3)
    16    => { items => [17423, 855623, 813514, 199999], cash => [0, 0, 3, 0] }, # Shadow Knight, bitmask: 16 (2^4)
    32    => { items => [17423, 89999, 813542, 199999], cash => [0, 0, 3, 0] }, # Druid, bitmask: 32 (2^5)
    64    => { items => [17423, 867133, 813514], cash => [0, 0, 3, 0] }, # Monk, bitmask: 64 (2^6)
    128   => { items => [17423, 89998, 813514, 9992, 15703, 199999], cash => [0, 0, 3, 0] }, # Bard, bitmask: 128 (2^7)
    256   => { items => [17423, 89997, 813514, 44531], cash => [0, 0, 3, 0] }, # Rogue, bitmask: 256 (2^8)
    512   => { items => [17423, 89999, 813542, 199999], cash => [0, 0, 3, 0] }, # Shaman, bitmask: 512 (2^9)
    1024  => { items => [17423, 86012, 813566, 199999], cash => [0, 0, 3, 0] }, # Necromancer, bitmask: 1024 (2^10)
    2048  => { items => [17423, 86012, 813566], cash => [0, 0, 3, 0] }, # Wizard, bitmask: 2048 (2^11)
    4096  => { items => [17423, 86012, 813566, 199999], cash => [0, 0, 3, 0] }, # Magician, bitmask: 4096 (2^12)
    8192  => { items => [17423, 86012, 813566, 199999], cash => [0, 0, 3, 0] }, # Enchanter, bitmask: 8192 (2^13)
    16384 => { items => [17423, 867133, 813514, 199999], cash => [0, 0, 3, 0] }, # Beastlord, bitmask: 16384 (2^14)
    32768 => { items => [17423, 855623, 813514], cash => [0, 0, 3, 0] }, # Berserker, bitmask: 32768 (2^15)
);

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
        RewardItems($client);
    } else {
        quest::say("I don't need this item, $name. Perhaps you should keep it.");
    }  
    # Return items that are not used
    plugin::returnUnusedItems();
}

sub RewardItems {
    my ($client) = @_;

    my $playerClassBitmask = $client->GetClassesBitmask();
    my $rewardedClassesBitmask = $client->GetBucket('newbieRewardBits') || 0; # Retrieve previously rewarded classes, defaulting to 0

    my $rewardGiven = 0;
    foreach my $classBitmask (keys %{$classRewards}) {
        if (($playerClassBitmask & $classBitmask) && !($rewardedClassesBitmask & $classBitmask)) { 
            # Summon the fixed items for the class
            foreach my $item (@{$classRewards->{$classBitmask}->{items}}) {
                $client->summonitem($item);
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
