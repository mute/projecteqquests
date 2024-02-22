#Just a little flavor for when XTC kills someone.

sub EVENT_SLAY {
  quest::say("Odd, we normally have to drag sacrifices kicking and screaming, but this one all but throws himself at us.");
}

sub EVENT_DEATH_COMPLETE {

 quest::spawn(202368,0,0,$x,$y,($z+10)); #Planar Projection

}

#Submitted by: Jim Mills