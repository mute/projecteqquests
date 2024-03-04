sub EVENT_SAY {
  if ($text=~/hail/i) {
    if (plugin::HasClass("Berserker")) { #Berserker Epic
      quest::say("Ah, I see you follow the arts of the berserker."); #Text made up
    }
    else {
      quest::say("You do not seem to follow the arts of the berserker, I'm afraid you cannot help me.");
    }
  }
}