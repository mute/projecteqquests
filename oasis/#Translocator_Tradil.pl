

##Translocator_Gethia.pl
#Zone: butcher

sub EVENT_SAY{

 $key = $client->AccountID() . "-kunark-flag";
 $expansion = quest::get_data($key);
 if($expansion >= 2){
  if ($text=~/Hail/i){ 

  quest::say("Hello there, $name. There seem to be some strange problems with the boats in this area. The Academy of Arcane Sciences has sent a small team of us to investigate them. If you need to [" . quest::saylink("travel to the Timorous Deep") . "] in the meantime, I can transport you to my companion there.");
  }
 }
  if($expansion >= 2){
     if ($text=~/timorous deep/i){
  quest::say("Off you go!");
  quest::movepc(96,-3260.10,-4544.56,19.47); # Zone: timorous
  }
  }

if ($expansion < 2){
   if ($text =~/Hail/i){
  quest::say("Come back when you are more experienced to journey to Kunark.");
  }
}
}
