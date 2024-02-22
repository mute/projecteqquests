sub EVENT_SPAWN {
  quest::settimer(1,1200);
}

	  


sub EVENT_SAY {

$key = $client->AccountID() . "-kunark-flag";
$expansion = quest::get_data($key);

$voxkey = $client->AccountID() . "vox";

if ($text=~/hail/i){

  if (quest::get_data($voxkey) == "") {
    quest::set_data($voxkey, 1);
  quest::say("Be gone to the Field of Bone! Oh, my dear love... I am so sorry.");
  $client->Message(4, "You have gained an expansion flag!");
   quest::set_data($key, quest::get_data($key) + 1);
  }
else
{
  quest::say("I have already given you my blessing! Would you like to check your [expansions] unlocked?");
}

}


 if (($text =~ /Expansions/i) && ($expansion == 0)) {
  quest::say("You don't have any expansions unlocked!");
 }

 if (($text =~ /Expansions/i) && ($expansion == 1)) {
  quest::say("You don't have any expansions unlocked!");
 }

 if (($text =~ /Expansions/i) && ($expansion >= 2)) {
  quest::say("Expansions Unlocked: Kunark");
 }
  if (($text =~ /Expansions/i) && ($expansion >= 6)) {
  quest::say("Expansions Unlocked: Velious");
 }
  if (($text =~ /Expansions/i) && ($expansion >= 14)) {
  quest::say("Expansions Unlocked: Luclin");
 }
  if (($text =~ /Expansions/i) && ($expansion >= 19 )) {
  quest::say("Expansions Unlocked: Planes of Power/Legacy of Ykesha");
 }


}





sub EVENT_TIMER {
  quest::depop();
}