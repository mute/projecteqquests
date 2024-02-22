sub EVENT_SPAWN {
  quest::settimer(1,1200);
}

sub EVENT_SAY {

$key = $client->AccountID() . "-kunark-flag";
$expansion = quest::get_data($key);

$quarmkey = $client->AccountID() . "-quarm-kill";

if ($text=~/hail/i){
  
  if (quest::get_data($quarmkey) == "") {
    quest::set_data($quarmkey, 1);
    quest::say("I have been watching you... since the great before. How interesting that you would take this same path... again. Perhaps there is a certain memory you are searching for?");
    quest::emote("An Observer beams a smile at you."); 
    quest::say("Did you know? Your great deeds are [" . quest::saylink("fabled") . "] even among my kind.");

    $client->Message(4, "You have gained an expansion flag!");
    quest::set_data($key, quest::get_data($key) + 1);
  }
  else
  {
    quest::say("Did you know? Your great deeds are [" . quest::saylink("fabled") . "] even among my kind.");
  }

}
if ($text =~ /fabled/i && $expansion >=20) {
    quest::say("Indeed. I remember one particularly harrowing battle we all gathered to watch. Despite being hard to see, stealing glimpses through a fire giant's channeling crystal, you put on the show of a lifetime... maybe reliving that battle will help you remember hero.");
}
if (($text =~ /Expansions/i) && ($ == 0)) {
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
quest::say("Expansions Unlocked: Planes of Power");
}
if (($text =~ /Expansions/i) && ($expansion >= 20 )) {
quest::say("Expansions Unlocked: Fabled Classic");
}

}

sub EVENT_TIMER {
  quest::depop();
}