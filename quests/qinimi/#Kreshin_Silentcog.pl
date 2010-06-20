sub EVENT_SPAWN {
  quest::say("Thank you for rescuing me. I sense that one of you holds a stone key which allowed you entrance into the courts. Please show it to me.");
}

sub EVENT_ITEM {
  if (plugin::check_handin(\%itemcount, 67415 =>1 )) {
    quest::say("You have done well to get this far. Please, take this to Taminoa and tell him it is vital that he decipher it. I must stay here to investigate more. Let him know I am safe and thank you again.");
    quest::summonitem(67415);
    quest::summonitem(67401);
    quest::settimer(360);
    }
    plugin::return_items(\%itemcount);
}

sub EVENT_TIMER {
   quest::movegrp(281,-1053,438,-16);
  quest::depop(281124);
}