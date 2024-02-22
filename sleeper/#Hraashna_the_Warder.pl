sub EVENT_DEATH_COMPLETE {
quest::spawn(12000081,0,0,$x,$y,($z+10));

$nanzata = $entity_list->GetMobByNpcTypeID(128090);
$ventani = $entity_list->GetMobByNpcTypeID(128091);
$tukaarak = $entity_list->GetMobByNpcTypeID(128092);
if (!$nanzata && !$ventani && !$tukaarak) {
#quest::signalwith(128094,66,0); # NPC: #The_Sleeper
quest::shout("Warders, I have fallen. Prepare yourselves, these fools are determined to unleash doom!");
}
else { 
quest::shout("Warders, I have fallen. Prepare yourselves, these fools are determined to unleash doom!");
}
 }

sub EVENT_KILLED_MERIT {
    plugin::set_subflag($client, 'SoL', $npc->GetCleanName());
}
