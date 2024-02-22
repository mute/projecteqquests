sub EVENT_SPAWN {
quest::shout("For the honor of Rallos Zek! We won't let you escape! Attack!");
quest::spawn2(116553, 0,0, ($x + 150), ($y + 15), $z, $h); # NPC: Ry`Gorr_Basher
quest::spawn2(116553, 0,0, ($x + 100), ($y + 75), $z, $h); # NPC: Ry`Gorr_Basher
quest::spawn2(116553, 0,0, ($x + 150) , ($y - 15), $z, $h); # NPC: Ry`Gorr_Basher
quest::spawn2(116553, 0,0, ($x + 100) , ($y - 75), $z, $h); # NPC: Ry`Gorr_Basher
quest::spawn2(116553, 0,0, ($x - 10), $y, $z, $h); # NPC: Ry`Gorr_Basher
#quest::spawn2(KROMRIFF SOLIDER ID, 0,0, -2089, 98, 147, 58);
#quest::spawn2(KROMRIFF SOLIDER ID, 0,0, -2112, 98, 147, 58);

}

sub EVENT_DEATH_COMPLETE {

quest::spawn2(116118, 0, 0, -2139, 168, 150, 114); # NPC: Dobbin Crossaxe

}
