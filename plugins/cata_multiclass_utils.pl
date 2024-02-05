sub CommonCharacterUpdate
{
    my $client = plugin::val('$client');

    CheckSkillAcquisition();
    CheckSpellAcquisition($client->GetLevel());

}

# Check if the player is eligible for the first point of a new skill
sub CheckSkillAcquisition
{
    my $client = plugin::val('$client');

    my $max_skill_id = 77;

    foreach my $skill (1..$max_skill_id) {
        if ($client->MaxSkill($skill) > 0 && $client->GetRawSkill($skill) < 1 && $client->CanHaveSkill($skill)) {
            $client->SetSkill($skill, 1);
        }
    }
}

sub CheckSpellAcquisition
{
    my $client = plugin::val('$client');
    my $level  = shift || $client->GetLevel(); 

    quest::debug("Attempting to learn $level spells");
    $client->ScribeSpells($level, $level);
}