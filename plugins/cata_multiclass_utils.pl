sub CommonCharacterUpdate
{
    my $client = shift;

    CheckSkillAcquisition($client);
    CheckSpellAcquisition($client);
}

sub CheckSkillAcquisition
{
    my $client = shift;

    my $max_skill_id = 77;

    foreach my $skill (1..$max_skill_id) {
        if ($client->MaxSkill($skill) > 0 && $client->GetRawSkill($skill) < 1 && $client->CanHaveSkill($skill)) {
            $client->SetSkill($skill, 1);
        }
    }
}

sub CheckSpellAcquisition
{
    my $client = shift;
    my $level  = $client->GetLevel(); 

    $client->ScribeSpells($level, $level);
}