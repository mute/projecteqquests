sub EVENT_SAY 
{
    $key = $client->AccountID() . "-kunark-flag";
    $expansion = quest::get_data($key);
 if ($text=~ /Hail/i){quest::say("Welcome to the Retribution server! If you came here by selecting Crescent Reach as a starting zone, please recreate your character with an era appropriate starting zone selection. Currently, your account does not have the proper [expansions] unlocked to play your class/race combination. Please create a class/race combination that is appropriate for your account's current progression. For example, if this is your first time playing Retribution, please make a classic race/class combination.");} 

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
 #if ($text =~/reset/i){
  #  quest::set_data($key, quest::get_data($key) - 1);
#}

#if ($text =~/add/i){
 #   quest::set_data($key, quest::get_data($key) + 1);
#}

#if ($text =~/remove/i){
 #   quest::set_data($key, quest::get_data($key) - 1);
#}

 }


